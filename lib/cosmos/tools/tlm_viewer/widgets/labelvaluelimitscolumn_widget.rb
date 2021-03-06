# encoding: ascii-8bit

# Copyright 2014 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt

require 'cosmos/tools/tlm_viewer/widgets/widget'
require 'cosmos/tools/tlm_viewer/widgets/multi_widget'
require 'cosmos/tools/tlm_viewer/widgets/labelvalue_widget'
require 'cosmos/tools/tlm_viewer/widgets/limitsbar_widget'

module Cosmos
  # Vertically stacks a LabelWidget, LimitscolumnWidget, and ValueWidget
  class LabelvaluelimitscolumnWidget < Qt::Widget
    include Widget
    include MultiWidget

    def initialize(parent_layout, target_name, packet_name, item_name, value_type = :WITH_UNITS, characters = 12)
      super(target_name, packet_name, item_name, value_type)
      setLayout(Qt::VBoxLayout.new())
      layout.setSpacing(1)
      layout.setContentsMargins(0,0,0,0)
      @widgets << LabelWidget.new(layout, item_name.to_s)
      @widgets << LimitscolumnWidget.new(layout, target_name, packet_name, item_name, value_type)
      @widgets << ValueWidget.new(layout, target_name, packet_name, item_name, value_type, characters)
      parent_layout.addWidget(self) if parent_layout
    end

    def self.takes_value?
      return true
    end
  end
end
