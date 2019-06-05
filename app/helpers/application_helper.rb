module ApplicationHelper
  def tutorial(tutorial, number, msg)
    if (tutorial >> number) & 1 == 0
      @guide = msg
      return (1 << number) + tutorial
    else
      return 0 + tutorial
    end
  end
end
