class CreateStategyForRepositoryPattern
  def association(runner)
    runner.run
  end

  def result(evaluation)
    result = nil

    evaluation.object.tap do |instance|
      evaluation.notify(:after_build, instance)
      evaluation.notify(:before_create, instance)
      result = evaluation.create(instance)
      evaluation.notify(:after_create, result)
    end

    result
  end
end

FactoryBot.register_strategy(:create, CreateStategyForRepositoryPattern)
