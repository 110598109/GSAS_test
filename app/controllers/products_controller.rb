class ProductsController < ApplicationController

    # before_action :get_user, only: [:new] # 在new的頁面才會做before action

    LIMIT_PRODUCT_NUMBER_A_PAGE = 20


    def index
        @ad = {
            title: "這是廣告",
            des: "這是廣告內文",
            action_title: "閱讀更多",
        }

        @products = Product.all # call database

        @first_page = 1
        count = @products.count
        @last_page = (count / LIMIT_PRODUCT_NUMBER_A_PAGE)
        if (count % LIMIT_PRODUCT_NUMBER_A_PAGE != 0)
            @last_page += 1
        end

        # 決定每頁要呈現的產品
        # Query String 是url中”?”號後面的任何字串
        if params[:page] # 避免主頁面沒有query的情況
            @page = params[:page].to_i - 1 # get current apge
        else
            @page=0
        end
        @products = @products.offset(@page * LIMIT_PRODUCT_NUMBER_A_PAGE).limit(LIMIT_PRODUCT_NUMBER_A_PAGE)

    end

    def new
        @note = flash[:note] # 接收flash message

        @product = Product.new # new頁面接收
    end

    def create
           
        product = Product.create(product_permit)
        
        flash[:note] = product.id # 溝通 by flash message
        redirect_to action: :new
    end

    def get_user
        redirect_to root_path
    end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        product = Product.find(params[:id]) # 拿出指定product
        product.update(product_permit)
        redirect_to action: :edit
    end

    def product_permit # 哪些資料要傳參
        params.require(:product).permit([:name, :description, :image_path, :price]) # return
    end
end
