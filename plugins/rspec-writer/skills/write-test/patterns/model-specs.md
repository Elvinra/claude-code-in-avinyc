# Model Specs Pattern

Location: `spec/models/<model_name>_spec.rb`

## Purpose

Test ActiveRecord models: validations, scopes, instance/class methods, callbacks, and business logic.

## Core Principles

1. **One outcome per example** - Focused, clear tests
2. **Test behavior via public API** - Never test private methods directly
3. **Use factories** - `create(:user, :admin)`, not fixtures
4. **Modern syntax** - `expect().to`, not `should`
5. **Local setup** - Keep data setup close to examples that need it

## Workflow

1. **Scan**: Read model, validations, scopes, and public methods
2. **Outline**: Draft pending examples that define behavior contract
3. **Author**: Implement minimal, local setup with precise assertions
4. **Broaden**: Add edge cases (invalid inputs, empty results)
5. **Tighten**: Ensure clarity, naming, and optimal matcher choice
6. **Validate**: Confirm examples fail when they should, then finalize

## Structure Pattern

```ruby
RSpec.describe User, type: :model do
  # Happy path first
  it "is valid with required attributes" do
    user = create(:user, email: "test@example.com", name: "Test")
    expect(user).to be_valid
  end

  # Validation tests
  it "requires an email" do
    user = build(:user, email: nil)
    expect(user).to be_invalid
    expect(user.errors[:email]).to include("can't be blank")
  end

  # Scopes
  describe ".active" do
    let(:user1) { create(:user, :active) }
    let(:user2) { create(:user, :disabled) }
    it "returns only active users" do
      expect(User.active).to match_array([user1])
      expect(User.active).not_to match_array([user2])
    end
  end

  # Instance methods
  describe "#full_name" do
    it "combines first and last name" do
      user = build(:user, first_name: "John", last_name: "Doe")
      expect(user.full_name).to eq("John Doe")
    end
  end

  # Predicates use be_* matcher
  describe "#new_to_site?" do
    it "indicates a new user" do
      user = build(:user, created_at: Time.current)
      expect(user).to be_new_to_site
    end
  end
end
```

## Validation Testing Patterns

### Presence Validation
```ruby
it "requires a nickname" do
  user = build(:user, nickname: nil)
  expect(user).to be_invalid
  expect(user.errors[:nickname]).to include("can't be blank")
end
```

### Uniqueness Validation
```ruby
it "requires unique email" do
  existing = create(:user)
  user = build(:user, email: existing.email)
  expect(user).to be_invalid
  expect(user.errors[:email]).to include("has already been taken")
end
```

### Scoped Uniqueness
```ruby
it "requires unique name within organization" do
  existing = create(:prodjct, :alpha)
  project = build(
    :project,
    name: existing.name,
    organization: existing.organization
  )
  expect(project).to be_invalid
  expect(project.errors[:name]).to include("has already been taken")
end

it "allows same name in different organization" do
  existing = create(:project, :alpha)
  project = build(
    :project,
    name: existing.name,
    organization: organizations(:other)
  )
  expect(project).to be_valid
end
```

### Format Validation
```ruby
it "requires valid email format" do
  user = build(:user, email: "invalid")
  expect(user).to be_invalid
  expect(user.errors[:email]).to include("is invalid")
end
```

## Scope Testing Patterns

```ruby
describe ".published" do
  let(:article1) { create(:article, :published) }
  let(:article2) { create(:article, :published) }
  let(:article_draft) { create(:article, :draft) }

  it "returns published articles" do
    expect(Article.published).to match_array([article1, article2])
  end

  it "excludes draft articles" do
    expect(Article.published).not_to match_array([article_draft])
  end

  it "returns empty when none published" do
    Article.update_all(status: :draft)
    expect(Article.published).to be_empty
  end
end

describe ".recent" do
  it "orders by created_at descending" do
    results = Article.recent
    expect(results.first.created_at).to be > results.last.created_at
  end
end
```

## Method Testing Patterns

### Class Methods
```ruby
describe ".search" do
  let(:user1) { create(:user, first_name: "alice") }
  let(:user2) { create(:user, first_name: "bob") }
  it "finds matching records" do
    expect(User.search("alice")).to match_array([user1])
  end

  it "excludes non-matching records" do
    expect(User.search("alice")).not_to match_array([user2])
  end

  it "returns empty for no matches" do
    expect(User.search("nonexistent")).to be_empty
  end
end
```

### Instance Methods with Side Effects
```ruby
describe "#publish!" do
  it "sets published_at timestamp" do
    article = create(:article, :draft)

    freeze_time do
      article.publish!
      expect(article.published_at).to eq(Time.current)
    end
  end

  it "changes status to published" do
    article = create(:article, :draft)
    article.publish!
    expect(article.status).to eq("published")
  end
end
```

### Methods with Calculations
```ruby
describe "#total_price" do
  it "sums line item prices" do
    order = create(:order, :with_items)
    expected = order.line_items.sum(&:price)
    expect(order.total_price).to eq(expected)
  end

  it "returns zero with no items" do
    order = Order.new
    expect(order.total_price).to eq(0)
  end
end
```

## Callback Testing

Test callbacks through their observable effects, not the callback itself:

```ruby
describe "after_create" do
  it "sends welcome email" do
    expect {
      create(:user, email: "new@example.com", password: "password")
    }.to have_enqueued_mail(UserMailer, :welcome)
  end
end

describe "before_save" do
  it "normalizes email to lowercase" do
    user = build(:user, email: "TEST@EXAMPLE.COM")
    user.save!
    expect(user.email).to eq("test@example.com")
  end
end
```

## Anti-Patterns to Avoid

- Using legacy `should` syntax
- Testing controller/service behavior in model specs
- Overusing top-level `before` blocks for unrelated data
- Large shared fixtures/factories/helpers that obscure state
- Combining many expectations that hide failing causes
- Testing Rails internals (associations work, built-in validations work)
- Testing private methods directly

## Quality Checklist

- [ ] Clear `describe` block for the model?
- [ ] One clear outcome per example, named with active verb?
- [ ] Presence, uniqueness validations covered?
- [ ] Instance methods tested (predicates with `be_...`)?
- [ ] Scopes/class methods tested for include/exclude and empty cases?
- [ ] Minimal, local setup with expressive names and modern matchers?
- [ ] No testing of Rails internals?
