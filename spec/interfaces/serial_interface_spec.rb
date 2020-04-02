# encoding: ascii-8bit

# Copyright 2014 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt

if RUBY_ENGINE == 'ruby' or Gem.win_platform?

  require 'spec_helper'
  require 'cosmos/interfaces/serial_interface'

  module Cosmos

    describe SerialInterface do

      describe "initialize" do
        it "initializes the instance variables" do
          i = SerialInterface.new('COM1','COM1','9600','NONE','1','0','0','burst')
          expect(i.name).to eql "SerialInterface"
        end

        it "is not writeable if no write port given" do
          i = SerialInterface.new('nil','COM1','9600','NONE','1','0','0','burst')
          expect(i.write_allowed?).to be false
          expect(i.write_raw_allowed?).to be false
          expect(i.read_allowed?).to be true
        end

        it "is not readable if no read port given" do
          i = SerialInterface.new('COM1','nil','9600','NONE','1','0','0','burst')
          expect(i.write_allowed?).to be true
          expect(i.write_raw_allowed?).to be true
          expect(i.read_allowed?).to be false
        end
      end

      describe "connect" do
        before(:all) do
          # If we're locally testing on a Windows box test for serial ports
          if Kernel.is_windows? && !ENV['APPVEYOR']
            result = `chgport 2>&1`
            @ports = !result.include?("No serial ports")
          end
        end

        it "passes a new SerialStream to the stream protocol" do
          # Ensure the 'NONE' parity is coverted to a symbol
          if @ports
            i = SerialInterface.new('COM1','COM1','9600','NONE','1','0','0','burst')
            expect(i.connected?).to be false
            i.connect
            expect(i.stream.instance_variable_get(:@flow_control)).to eq :NONE
            expect(i.stream.instance_variable_get(:@data_bits)).to eq 8
            expect(i.connected?).to be true
            i.disconnect
            expect(i.connected?).to be false
          end
        end

        it "sets options on the interface" do
          if @ports
            i = SerialInterface.new('nil','COM1','9600','NONE','1','0','0','burst')
            i.set_option("FLOW_CONTROL", ["RTSCTS"])
            i.set_option("DATA_BITS", ["7"])
            i.connect
            expect(i.stream.instance_variable_get(:@flow_control)).to eq :RTSCTS
            expect(i.stream.instance_variable_get(:@data_bits)).to eq 7
          end
        end
      end
    end
  end

end
