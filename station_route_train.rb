class Station

  #	Getter может возвращать список всех поездов на станции, находящихся в текущий момент
  attr_reader :trains, :name
  # Создание константы TYPE
  TYPE = [:passenger, :cargo]

  # Имеет название, которое указывается при создании станции
  def initialize(name)
    @name = name if (name != "") # Инициализация переменной при условии, что строка не пустая
    @trains = [] # Создание пустого массива поездов на станции
  end

  #	Может принимать поезда (по одному за раз)
  def accept_train(train)    # Передача в аргумент объекта train класса Train
    @trains.push(train).uniq  # Добавление объекта train в массив поездов и удаление всех повторяющихся элементов
    train.take_a_route(self) # Вызов метода назначения маршрута поезду для объекта train класса Train
  end

  #	Может возвращать список поездов на станции по типу: количество грузовых, пассажирских
  def list_trains_type(type)
    @cargo = @trains.reject { |train| train.type == TYPE[0] } # Метод reject возвращает новый массив, содержащий элементы, которые не соответствуют условию
    puts "Грузовые поезда на станции #{@name} : #{@cargo} в количестве #{@cargo.length}"
    @passenger = @trains.reject { |train| train.type == TYPE[1] }  # Метод reject возвращает новый массив, содержащий элементы, которые не соответствуют условию
    puts "Пассажирские поезда на станции #{@name} : #{@passenger} в количестве #{@passenger.length}"
  end

  #	Список всех поездов на станции, находящиеся в текущий момент
  def all_trains
    puts "Список всех поездов на станции #{@name} : #{@trains} в количестве #{@trains.length}"
  end

  #	Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  def send_train(train)  # Передача в аргумент объекта train класса Train
    @trains.delete(train) if @trains.include?(train)
  end
end

class Route

  #	Getter может возвращать список всех станций в маршруте
  attr_reader :stations

  #	Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  def initialize(first_station, last_station)   # Объекты класса Station передаются в аргументы
    @stations = [first_station, last_station]  # Создание массива из двух элементов: начальной и конечной станции
  end

  #	Может добавлять промежуточную станцию в список и удалять все повторяющиеся элементы
  def add_station(middle_station)     # Объект класса Station передаётся в аргумент
    @stations.insert(1, middle_station).uniq
  end

  #	Может удалять промежуточную станцию из списка
  def delete_station(middle_station)  # Объект класса Station передаётся в аргумент
    @stations.delete_if { |station| station == middle_station && station != @stations[0] && station != @stations[-1] }
  end
  
  #	Может выводить список всех станций по-порядку от начальной до конечной
  def list_all_stations
    @stations.each { |station| puts "Станция маршрута #{self.to_s} : #{station}" }
  end
end

class Train

  #	Getter может возвращать текущую скорость, количество вагонов, номер поезда, тип, текущую станцию, маршрут следования.
  attr_reader :speed, :train_car, :number, :type, :current_station, :route

  #	Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
  def initialize(number, type, train_car, speed = 0)
    @number = number.to_s
    @type = type if (type == Station::TYPE[0]) || (type == Station::TYPE[1]) # Может принимать значения только из массива TYPE
    @train_car = train_car if (train_car.is_a?(Integer)) # Может принимать только целочисленное значение
    @speed = speed
  end

  #	Может набирать скорость
  def gather_speed(value)
    @speed += value if (value > 0)
  end

  #	Может тормозить (сбрасывать скорость до нуля)
  def stop
    @speed = 0
  end

  #	Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  def hitching_train_car     # Прицепка вагонов
    @train_car += 1  if (@speed == 0)
  end

  def uncoupling_train_car   # Отцепка вагонов
    @train_car -= 1  if (@speed == 0)
  end

  #	Может принимать маршрут следования (объект класса Route)
  def take_a_route(route)   # В аргумент передаётся объект класса Route
    @route = route
    #	При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте
    @current_station = @route.stations[0]
  end

  #	Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  def moving_forward
    index = @route.stations.index(@current_station)  # Находим индекс текущей станции
    @current_station = @route.stations[index + 1]   # Перемещение вперёд на одну станцию (текущая поменялась)
  end
  def moving_back
    index = @route.stations.index(@current_station)  # Находим индекс текущей станции
    @current_station = @route.stations[index - 1]   # Перемещение назад на одну станцию (текущая поменялась)
  end

  #	Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
  def previous_station
    index = @route.stations.index(@current_station)  # Находим индекс текущей станции
    @route.stations[index - 1]   # Возвращаем предыдущую станцию
  end
  def next_station
    index = @route.stations.index(@current_station)  # Находим индекс текущей станции
    @route.stations[index + 1]   # Возвращаем следующую станцию
  end
end

