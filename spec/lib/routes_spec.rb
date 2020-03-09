require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  context 'users' do
    it { expect(get: 'users').to be_routable }
    it { expect(post: 'users').to be_routable }
    it { expect(get: 'users/:id').to be_routable }
    it { expect(patch: 'users/:id').to be_routable }
    it { expect(put: 'users/:id').to be_routable }
    it { expect(delete: 'users/:id').to be_routable }

    it { expect(get: 'users/:user_id/lists').to be_routable }
    it { expect(post: 'users/:user_id/lists').to be_routable }
    it { expect(get: 'users/:user_id/lists/:id').to be_routable }
    it { expect(patch: 'users/:user_id/lists/:id').to be_routable }
    it { expect(put: 'users/:user_id/lists/:id').to be_routable }
    it { expect(delete: 'users/:user_id/lists/:id').to be_routable }

    it { expect(post: 'users/:user_id/relationships/lists').to be_routable }
    it { expect(patch: 'users/:user_id/relationships/lists').to be_routable }
    it { expect(put: 'users/:user_id/relationships/lists').to be_routable }
    it { expect(delete: 'users/:user_id/relationships/lists').to be_routable }
  end

  context 'lists' do
    it { expect(get: 'lists').to be_routable }
    it { expect(post: 'lists').to be_routable }
    it { expect(get: 'lists/:id').to be_routable }
    it { expect(patch: 'lists/:id').to be_routable }
    it { expect(put: 'lists/:id').to be_routable }
    it { expect(delete: 'lists/:id').to be_routable }

    it { expect(get: 'lists/:list_id/todos').to be_routable }
    it { expect(post: 'lists/:list_id/todos').to be_routable }
    it { expect(get: 'lists/:list_id/todos/:id').to be_routable }
    it { expect(patch: 'lists/:list_id/todos/:id').to be_routable }
    it { expect(put: 'lists/:list_id/todos/:id').to be_routable }
    it { expect(delete: 'lists/:list_id/todos/:id').to be_routable }

    it { expect(get: 'lists/:list_id/user').to be_routable }
    it { expect(patch: 'lists/:list_id/user').to be_routable }
    it { expect(put: 'lists/:list_id/user').to be_routable }
    it { expect(delete: 'lists/:list_id/user').to be_routable }

    it { expect(get: 'lists/:list_id/permissions').to be_routable }

    it { expect(post: 'lists/:list_id/relationships/todos').to be_routable }
    it { expect(patch: 'lists/:list_id/relationships/todos').to be_routable }
    it { expect(put: 'lists/:list_id/relationships/todos').to be_routable }
    it { expect(delete: 'lists/:list_id/relationships/todos').to be_routable }

    it { expect(patch: 'lists/:list_id/relationships/user').to be_routable }
    it { expect(put: 'lists/:list_id/relationships/user').to be_routable }
  end

  context 'todos' do
    it { expect(get: 'todos').to be_routable }
    it { expect(post: 'todos').to be_routable }
    it { expect(get: 'todos/:id').to be_routable }
    it { expect(patch: 'todos/:id').to be_routable }
    it { expect(put: 'todos/:id').to be_routable }
    it { expect(delete: 'todos/:id').to be_routable }

    it { expect(get: 'todos/:todo_id/list').to be_routable }
    it { expect(patch: 'todos/:todo_id/list').to be_routable }
    it { expect(put: 'todos/:todo_id/list').to be_routable }
    it { expect(delete: 'todos/:todo_id/list').to be_routable }

    
    it { expect(patch: 'todos/:todo_id/relationships/list').to be_routable }
    it { expect(put: 'todos/:todo_id/relationships/list').to be_routable }
  end
end
