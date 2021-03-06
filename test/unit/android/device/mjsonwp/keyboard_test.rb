# frozen_string_literal: true

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'test_helper'
require 'webmock/minitest'
require 'base64'

# $ rake test:unit TEST=test/unit/android/device/mjsonwp/commands_test.rb
class AppiumLibCoreTest
  module Android
    module Device
      module MJSONWP
        class KeyboardTest < Minitest::Test
          include AppiumLibCoreTest::Mock

          def setup
            @core ||= ::Appium::Core.for(Caps.android)
            @driver ||= android_mock_create_session
          end

          def test_is_keyboard_shown
            stub_request(:get, "#{SESSION}/appium/device/is_keyboard_shown")
              .to_return(headers: HEADER, status: 200, body: { value: 'A' }.to_json)

            @driver.is_keyboard_shown

            assert_requested(:get, "#{SESSION}/appium/device/is_keyboard_shown", times: 1)
          end

          def test_hide_keyboard
            stub_request(:post, "#{SESSION}/appium/device/hide_keyboard")
              .with(body: { key: 'Finished' }.to_json)
              .to_return(headers: HEADER, status: 200, body: { value: '' }.to_json)

            @driver.hide_keyboard 'Finished'

            assert_requested(:post, "#{SESSION}/appium/device/hide_keyboard", times: 1)
          end

          def test_keyevent
            # only for Selendroid
            stub_request(:post, "#{SESSION}/appium/device/keyevent")
              .to_return(headers: HEADER, status: 200, body: { value: '' }.to_json)

            @driver.keyevent 86

            assert_requested(:post, "#{SESSION}/appium/device/keyevent", times: 1)
          end

          # keypress
          def test_press_keycode
            stub_request(:post, "#{SESSION}/appium/device/press_keycode")
              .with(body: { keycode: 86 }.to_json)
              .to_return(headers: HEADER, status: 200, body: { value: '' }.to_json)

            @driver.press_keycode 86

            assert_requested(:post, "#{SESSION}/appium/device/press_keycode", times: 1)
          end

          # keypress
          def test_press_keycode_with_flags
            stub_request(:post, "#{SESSION}/appium/device/press_keycode")
              .with(body: { keycode: 86, metastate: 2_097_153, flags: 44 }.to_json)
              .to_return(headers: HEADER, status: 200, body: { value: '' }.to_json)

            # metastate is META_SHIFT_ON and META_NUM_LOCK_ON
            # flags is CANCELFLAG_CANCELEDED, FLAG_KEEP_TOUCH_MODE, FLAG_FROM_SYSTEM
            @driver.press_keycode 86, metastate: [0x00000001, 0x00200000], flags: [0x20, 0x00000004, 0x00000008]

            assert_requested(:post, "#{SESSION}/appium/device/press_keycode", times: 1)
          end

          # keypress
          def test_press_keycode_with_flags_with_wrong_flags
            assert_raises ArgumentError do
              @driver.press_keycode 86, flags: 0x02
            end
          end

          # keypress
          def test_press_keycode_with_flags_with_wrong_metastate
            assert_raises ArgumentError do
              @driver.press_keycode 86, metastate: 0x02
            end
          end

          # keypress
          def test_long_press_keycode
            stub_request(:post, "#{SESSION}/appium/device/long_press_keycode")
              .with(body: { keycode: 86 }.to_json)
              .to_return(headers: HEADER, status: 200, body: { value: '' }.to_json)

            @driver.long_press_keycode 86

            assert_requested(:post, "#{SESSION}/appium/device/long_press_keycode", times: 1)
          end

          # keypress
          def test_long_press_keycodewith_flags
            stub_request(:post, "#{SESSION}/appium/device/long_press_keycode")
              .with(body: { keycode: 86, metastate: 1, flags: 36 }.to_json)
              .to_return(headers: HEADER, status: 200, body: { value: '' }.to_json)

            # metastate is META_SHIFT_ON
            # flags is CANCELFLAG_CANCELEDED, FLAG_KEEP_TOUCH_MODE
            @driver.long_press_keycode 86, metastate: [1], flags: [32, 4]

            assert_requested(:post, "#{SESSION}/appium/device/long_press_keycode", times: 1)
          end

          # keypress
          def test_long_press_keycode_with_flags_with_wrong_flags
            assert_raises ArgumentError do
              @driver.long_press_keycode 86, flags: 0x02
            end
          end

          # keypress
          def test_long_press_keycode_with_flags_with_wrong_metastate
            assert_raises ArgumentError do
              @driver.long_press_keycode 86, metastate: 0x02
            end
          end

          ## Immediate value
          def test_set_immediate_value
            stub_request(:post, "#{SESSION}/appium/element/id/value")
              .with(body: { value: ["abc\ue000"] }.to_json)
              .to_return(headers: HEADER, status: 200, body: { value: '' }.to_json)

            @driver.set_immediate_value ::Selenium::WebDriver::Element.new(@driver.send(:bridge), 'id'), %w(a b c)

            assert_requested(:post, "#{SESSION}/appium/element/id/value", times: 1)
          end

          def test_replace_value
            stub_request(:post, "#{SESSION}/appium/element/id/replace_value")
              .with(body: { value: ["abc\ue000"] }.to_json)
              .to_return(headers: HEADER, status: 200, body: { value: '' }.to_json)

            @driver.replace_value ::Selenium::WebDriver::Element.new(@driver.send(:bridge), 'id'), %w(a b c)

            assert_requested(:post, "#{SESSION}/appium/element/id/replace_value", times: 1)
          end
        end # class Commands
      end # module MJSONWP
    end # module Device
  end # module Android
end # class AppiumLibCoreTest
