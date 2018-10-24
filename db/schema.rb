# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_181_024_134_607) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'categories', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'category_bannings', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'category_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['category_id'], name: 'index_category_bannings_on_category_id'
    t.index ['user_id'], name: 'index_category_bannings_on_user_id'
  end

  create_table 'category_managements', force: :cascade do |t|
    t.bigint 'manager_id'
    t.bigint 'category_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['category_id'], name: 'index_category_managements_on_category_id'
    t.index ['manager_id'], name: 'index_category_managements_on_manager_id'
  end

  create_table 'forum_thread_votings', force: :cascade do |t|
    t.bigint 'voter_id'
    t.bigint 'forum_thread_id'
    t.integer 'value'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['forum_thread_id'], name: 'index_forum_thread_votings_on_forum_thread_id'
    t.index ['voter_id'], name: 'index_forum_thread_votings_on_voter_id'
  end

  create_table 'forum_threads', force: :cascade do |t|
    t.bigint 'creator_id'
    t.bigint 'category_id'
    t.string 'name'
    t.integer 'status'
    t.integer 'score', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['category_id'], name: 'index_forum_threads_on_category_id'
    t.index ['creator_id'], name: 'index_forum_threads_on_creator_id'
  end

  create_table 'post_votings', force: :cascade do |t|
    t.bigint 'voter_id'
    t.bigint 'post_id'
    t.integer 'value'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['post_id'], name: 'index_post_votings_on_post_id'
    t.index ['voter_id'], name: 'index_post_votings_on_voter_id'
  end

  create_table 'posts', force: :cascade do |t|
    t.bigint 'creator_id'
    t.bigint 'forum_thread_id'
    t.text 'content'
    t.integer 'score', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['creator_id'], name: 'index_posts_on_creator_id'
    t.index ['forum_thread_id'], name: 'index_posts_on_forum_thread_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'username'
    t.string 'email'
    t.string 'password_digest'
    t.integer 'role'
    t.integer 'status'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email'
  end
end
