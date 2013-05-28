class CommentController < ApplicationController
  def create
    @comment = Comment.create( params[:comment] )
    #flash[:success] = "Success"
    picture = Picture.find params[:comment][:picture_id]
    unless picture.user.id == session[:user_id]
      Emailer.send_later(:deliver_comment,picture,@comment)
    end
    comments = Comment.find_all_by_picture_id(picture.id)
    comments.each {|c|
      unless c.user_id == session[:user_id]
        Emailer.send_later(:deliver_comment_cc,picture,c)
      end
    }
    redirect_to view_url(:id=>picture.guid)
  end

  def delete
    comment = Comment.find(params[:id])
    unless comment.nil?
      picture = Picture.find(comment.picture_id)
      if picture.user_id == session[:user_id]
        comment.destroy
      else
        flash[:error] = "Sorry, an error occurred trying to delete the comment."
      end
      redirect_to view_url(:id=>picture.guid)
      return
    else
      flash[:error] = "An error has occurred"
      redirect_to :controller=>:main
      return
    end
  end

end
