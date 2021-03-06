require 'test_helper'

class SecondLevelCacheTest < ActiveSupport::TestCase
  def setup
    @user = User.create name: 'csdn', email: 'test@csdn.com'
  end

  def test_should_get_cache_key
    attr_list = User.attribute_types.map { |name, type| "#{name}: #{type.type}" } * ', '
    table_digest = Digest::MD5.hexdigest(attr_list)
    refute_nil table_digest
    assert_equal "slc/users/#{@user.id}/#{User::CACHE_VERSION}/#{table_digest}", @user.second_level_cache_key
  end

  def test_should_write_and_read_cache
    @user.write_second_level_cache
    refute_nil User.read_second_level_cache(@user.id)
    @user.expire_second_level_cache
    assert_nil User.read_second_level_cache(@user.id)
  end
end
