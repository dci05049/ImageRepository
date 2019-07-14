class UsersController < ApplicationController
    def show
        @user = User.find_by_id(params[:id])
        if current_user == @user
            @images = @user.images
        else
            @images = @user.images.select do |image|
                image.public
            end
        end
    end
    def index
    end

    def update_balance
        user = User.find_by_id(params[:id])
        amount = params[:balance]
        user.add_balance(amount.to_i)
    end

    def purchase_image 
        image = Image.find_by_id(params[:id])

        newImage = Image.new({:user_id => current_user.id, :link => image.link, :price => image.price,
        :discount => image.discount, :caption => image.caption, :public => false })
        if newImage.save
            # broadcasting posts using pusher
            Pusher.trigger('posts-channel','new-post', {
            link: image.link,
            caption: image.caption
            })
        end

        image.user.add_balance(image.price)
        current_user.subtract_balance(image.price)
        
        redirect_to('/')
    end
end
