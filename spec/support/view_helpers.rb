module ViewHelpers
  def mock_policy(user)
    without_partial_double_verification do
      allow(view).to receive(:policy) do |record|
        Pundit.policy(user, record)
      end
    end
  end

  def mock_authentication(is_authenticated)
    without_partial_double_verification do
      allow(view).to receive(:signed_in?).and_return(is_authenticated)
    end
  end

  def paginate(array = [], page = 1)
    assign(:topics, Kaminari.paginate_array(array).page(page))
  end
end
