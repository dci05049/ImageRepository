class ImageController < ApplicationController
  before_action :authenticate_user!

  def index
    @images = current_user.images.all.order(created_at: :desc)
  end

  def store
    params[:image].each do |image|
      @value = Cloudinary::Uploader.upload(image)
      @image = Image.new({:user_id => current_user.id, :link => @value['secure_url'], :caption => params[:caption], :public => params[:permission]})
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
