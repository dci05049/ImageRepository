class ImageController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def index
    @images = current_user.images.all.order(created_at: :desc)
  end

  def store
    #use active_import bulk creation to avoide having to loop through it
    params[:image].each do |image|
      upload = Cloudinary::Uploader.upload(image)
      price = params[:price]
      discount = params[:discount]
      caption = params[:caption]
      permission = params[:permission]

      image = Image.new({:user_id => current_user.id, :link => upload['secure_url'], :price => price,
      :discount => discount, :caption => caption, :public => permission })  
      if image.save
        # broadcasting posts using pusher
        Pusher.trigger('posts-channel','new-post', {
        link: image.link,
        caption: image.caption
        })
      end
    end

    redirect_to('/')
  end

  def destroy
    #do validation to make sure it is the owner's image that is being destroyed
    image = current_user.images.find(params[:id])
    raise "error: attempting to delete other user's image" if image.user_id != current_user.id
    image.destroy
    redirect_to('/')
  end

  def destroy_multiple 
    #do validation to make sure it is the owner's image
    images = params[:images]
    # remove n+1 query with eager loading
    params[:images].each do |id|
      image = Image.find_by_id(id)
      raise "error: attempting to delete other user's image" if image.user_id != current_user.id
    end
    Image.destroy(params[:images])
    redirect_to('/')
  end

  private 
  # accept only these params 
  def post_params
    params.require(:image).permit(:caption, images: [])
  end
end
