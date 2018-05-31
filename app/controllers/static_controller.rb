class StaticController < ApplicationController
  layout 'layouts/static'

  def terms_and_privacy
    @theme = 'minimal'
  end

  def ccs
    ccs_method = !Settings.ccs ? 'local_tar_gz' : Settings.ccs.ccs_method
    if (ccs_method == 'local_tar_gz')
      temp_file = "#{$RAILS_ROOT}/tmp/#{Time.current.to_i}.tar.gz"
      result = Kernel.system("git archive --format=tar.gz -o #{temp_file} HEAD")
      if result
        send_file(temp_file, :type => "application/gzip")
      else
        render :nothing => true, :status => 500
      end
    elsif (ccs_method == 'github')
      git_hash = File.read("#{$RAILS_ROOT}/CCS_HASH")
      redirect_to "https://github.com/#{Settings.ccs.options.account}/#{Settings.ccs.options.repo}/tree/#{git_hash}"
    end

  end
end
