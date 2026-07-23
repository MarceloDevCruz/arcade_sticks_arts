class Psd::FilesController < ApplicationController

  def new
    @psd_file = Psd::File.new
  end

  def index
    @psd_files = Psd::File.all.order(created_at: :desc)
  end

  def create
    service = Psd::FilesServices::Create.new(psd_file_params)

    if service.call
      redirect_to psd_files_path, notice: "PSD adicionado com sucesso!"
    else
      @psd_file = service.psd_file
      flash.now[:alert] = service.error
      render :new, status: :unprocessable_entity
    end
  end

  private

  def psd_file_params
    params.require(:psd_file).permit(:title, :description, :psd)
  end
end