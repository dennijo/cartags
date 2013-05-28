namespace :email_handler do
  desc "Get pictures from emails and post accordingly"
  task(:get_pix => :environment) do
    require 'net/pop'
    require 'tmail'

    Rake::Task['email_handler:check_pid'].execute

    username = "pictures"
    password = "C@p1tu5v"
    host = "localhost"
    #while 1
    Net::POP3.start("localhost", nil, username, password) do |pop|
      if pop.mails.empty?
        print "No mail.\n"
      else
        pop.mails.each do |email|
          begin
            mymail = TMail::Mail.parse(email.pop)
            from = mymail.from[0]
            #print "From: #{from}\n"
            to = mymail.to[0]
            #print "To: #{to}\n"
            user = User.find_by_unique_email to
            unless user
              email.delete
              next
            end
            subject = mymail.subject
            #print "Subject: #{subject}\n"
            body = mymail.body
            #print "Body: #{body}\n"
            sent_on = mymail.date
            #print "Sent on: #{sent_on}\n"
            unless mymail.attachments.blank?
              tmp_file = "/tmp/"+rand(999999999).to_s+mymail.attachments.first.original_filename
              File.open(tmp_file,"w+") { |local_file|
                local_file << mymail.attachments.first.read
              }
            else
              email.delete
              next
            end
            body = body.gsub("Attachment: #{mymail.attachments.first.original_filename}",'')
            body = body.gsub("attachment: #{mymail.attachments.first.original_filename}",'')
            body = body.gsub("Attached: #{mymail.attachments.first.original_filename}",'')
            body = body.gsub("attached: #{mymail.attachments.first.original_filename}",'')
            
            email.delete

            #print "Working on user #{user.profile.first_name} #{user.profile.last_name}"
            picture = Picture.new
            picture.description = body
            picture.title = subject
            picture.image = File.open(tmp_file)
            picture.user_id = user.id
            picture.save

            pic = Picture.find(picture.id)
            if user.fb_access_token
              pic.post_to_fb
            end

            if tmp_file
              File.delete(tmp_file)
              tmp_file = nil
            end
            print "Moving on to next email \n"
          rescue Exception => e
            logger.error "Error receiving email at " + Time.now.to_s + "::: " + e.message + "\n"
          end
        end
      end
      puts "Done handling pictures from email\n"
    end
    #end
  end

  desc "Check PID status"
  task(:check_pid => :environment) do
    pid_file = "#{Rails.root}/tmp/pids/email_pix.rake.pid"
    begin
      file = File.new(pid_file, "r")
      while (line = file.gets)
        pid = line.to_i
      end
      file.close
    rescue => err
     File.open(pid_file, 'w') {|f| f.write('') }
      #puts "Exception: #{err}"
    end

    if pid
      #puts "Checking PID: #{pid}"
      begin
        Process.kill(0, Integer(pid))
        #puts "#{pid} is alive!"
        exit 1
      rescue Errno::EPERM
        #puts "#{pid} has escaped my control, this is bad!"
        Process.kill("SIGKILL", Integer(pid))
      rescue Errno::ESRCH
        #puts "#{pid} is deceased or zombied."
      rescue => err
        #puts "Odd; I couldn't check the status, I'm dying because: #{err}"
        exit 1
      end
    end

    my_pid = Process.pid
    File.open(pid_file, 'w') {|f| f.write(my_pid) }
  end

end


