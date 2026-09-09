require "test_helper"

class ActiveStorage::DiskControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data = "Some file data"
    @account = accounts("37s")
  end

  test "direct upload round trip under an account slug" do
    sign_in_as :david

    post rails_direct_uploads_path(script_name: @account.slug), params: { blob: blob_params }, as: :json
    assert_response :success

    signed_id = response.parsed_body["signed_id"]
    direct_upload = response.parsed_body["direct_upload"]
    assert_match %r{^#{@account.slug}/rails/active_storage/disk/}, URI.parse(direct_upload["url"]).path

    put direct_upload["url"], params: @data, headers: direct_upload["headers"]
    assert_response :no_content

    assert_equal @data, ActiveStorage::Blob.find_signed!(signed_id).download
  end

  private
    def blob_params
      { filename: "test.txt", byte_size: @data.bytesize, checksum: Digest::MD5.base64digest(@data), content_type: "text/plain" }
    end
end
