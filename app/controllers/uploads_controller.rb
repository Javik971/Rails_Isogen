class UploadsController < ApplicationController
    def new
    end
  
    def create
      uploaded_files = params[:files]
      file_paths = []
      uploaded_files.each do |file|
        file_path = "/tmp/#{file.original_filename.gsub(" ", "_")}"
        File.open(file_path, 'wb') do |f|
          f.write(file.read)
        end
        file_paths << file_path
      end
      
      $iso_path = "/tmp/cloudconfig.iso"

      `genisoimage -o #{$iso_path} --volid cidata -joliet -rock #{file_paths.join(' ')}`
      
      flash[:notice] = "Iso generated"

      file_paths.each do |path|
        File.delete(path) if File.exist?(path)
      end
      
      redirect_to uploads_new_path
    end

    def download
      File.open($iso_path, 'r') do |f|
        send_data f.read, type: "application/octet-stream", filename: "cloudconfig.iso"
      end
    end
end
