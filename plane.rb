module Plane
  class << self
    # 计算飞机座位数
    #[[列,行]]
    # 列: 代表行的座位个数
    # 按照行进行排列计算座位数
    def calculate_seat array_params = [[3, 3], [2, 2], [3, 2]]
      left = [] #靠窗的位置
      center = [] #中间的位置
      right = [] #靠过道的位置
      @zones_columns = setting_zones(array_params) #根据区域进行列排序
      @zones_rows = setting_zones_row(array_params) #区域行数
      @zone = array_params.length #总共的区域数
      seat_hash = seat_number # 座位进行字母排序
      #按照行数进行循环
      max_row = max_row(array_params) #最大的行
      max_column = max_column(array_params) #最大的列
      (1..max_row).each do |row|
        (1..max_column).each do |column| #列
          value = calculate_zone_column(column, row)
          if value == 'right'
            right << "#{row}#{seat_hash[column]}"
          elsif value == 'center'
            center << "#{row}#{seat_hash[column]}"
          elsif value == 'left'
            left << "#{row}#{seat_hash[column]}"
          end
        end
      end
      {
          "靠窗位置": left,
          "靠过道位置": right,
          "中间的位置": center

      }
    end

    private

    # 最大的行数
    def max_row array_params
      array_params.map {|info| info[1]}.max
    end

    #   最大的列数
    def max_column array_params
      array_params.map {|info| info[0]}.sum
    end

    # 求座位的编号
    def seat_number
      hash_number = {}
      ('A'..'Z').each_with_index do |number, index|
        index += 1
        hash_number[index] = number
      end
      hash_number
    end

    # 根据区域列数计算座位号
    # @!attribute: zones: 区域对应的列
    # @!attribute: column: 当前列
    # @!attribute: zone: 总共的区域
    # @!attribute: row: 当前行
    def calculate_zone_column column, row
      #区域数量
      @zones_columns.each do |key, value|
        if @zones_rows[key] >= row
          #最大的区域计算方式
          if key == @zone
            return "right" if column == value.min
            return "center" if column < value.max && column > value.min
            return "left" if column == value.max
            #最小区域计算方式
          elsif key == 1
            return "right" if column == value.max #最大的值为过道的位置
            return "center" if column < value.max && column > value.min
            return "left" if column == value.min
            #中间区域的计算方法(最大的值,与最小的值为过道位置)
            # 中间的值为中间位置
          elsif key > 1 && key < @zone
            return "right" if column == value.max || column == value.min
            return 'center' if column < value.max && column > value.min
          end
        end
      end
    end

    def setting_zones array_params
      hash = {}
      result = array_params.map {|info| info[0]}
      result.each_with_index do |item, index|
        key = index +1
        if index == 0
          hash[key] = (1..item).map {|info| info}
        else
          min = hash[index].max + 1
          max = hash[index].max + item
          hash[key] = (min..max).map {|info| info}
        end
      end
      hash
    end

    # 计算区域的行数
    def setting_zones_row array_params
      row_hash = {}
      result = array_params.map {|info| info[1]}
      result.each_with_index {|item, index| row_hash[index + 1] = item}
      row_hash
    end
  end
end