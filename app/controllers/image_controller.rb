class ImageController < ApplicationController
  before_action :authenticate_user!

  def index
    @images = current_user.images.all.order(created_at: :desc)
  end

  def store
    #use active_import bulk creation to avoide having to loop through it
    params[:image].each do |image|
      @upload = Cloudinary::Uploader.upload(image)
      @price = params[:price]
      @discount = params[:discount]
      @caption = params[:caption]
      @permission = params[:permission]

      @image = Image.new({:user_id => current_user.id, :link => @upload['secure_url'], :price => @price,
      :discount => @discount, :caption => @caption, :public => @permission })
      # n + 1 query
      if @image.save
        # broadcasting posts using pusher
        Pusher.trigger('posts-channel','new-post', {
        link: @image.link,
        caption: @image.caption
        })
      end
    end

    redirect_to('/')
  end

  def destroy
    @image = current_user.images.find(params[:id])
    @image.destroy
    redirect_to('/')
  end

  private 
  # accept only these params 
  def post_params
    params.require(:image).permit(:caption, images: [])
  end
end
