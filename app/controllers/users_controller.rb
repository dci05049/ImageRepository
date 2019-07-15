class UsersController < ApplicationController
    def show
        #if current user, display all images, if not display public
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
        #some checks to do: make sure image's owner and current_user is not the same
        #since we can't purchase our own images
        image = Image.find_by_id(params[:id])
        raise 'error: image owner cannot be same as current user' if image.user_id == current_user.id

        newImage = Image.new({:user_id => current_user.id, :link => image.link, :price => image.price,
        :discount => image.discount, :caption => image.caption, :public => false })
        if newImage.save
            # broadcasting posts using pusher
            Pusher.trigger('posts-channel','new-post', {
            link: image.link,
            caption: image.caption
            })
        end

        price = image.price - image.price * image.discount / 100.00
        image.user.add_balance(price.to_i)
        current_user.subtract_balance(price.to_i)
        
        redirect_to('/')
    end
end
