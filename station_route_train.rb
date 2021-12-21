class Station

  #	Getter может возвращать список всех поездов на станции, находящихся в текущий момент
  attr_reader :all_trains, :name_station
  # Создание константы TYPE
  TYPE = ["passenger", "cargo"]

  # Имеет название, которое указывается при создании станции
  def initialize(name_station)
    @name_station = name_station if (name_station != "") # Инициализация переменной при условии, что строка не пустая
    @all_trains = [] # Создание пустого массива поездов на станции
  end

  #	Может принимать поезда (по одному за раз)
  def accept_train(train)    # Передача в аргумент объекта train класса Train
    @all_trains.push(train).uniq  # Добавление объекта train в массив поездов и удаление всех повторяющихся элементов
    train.take_a_route(self) # Вызов метода назначения маршрута поезду для объекта train класса Train
  end

  #	Может возвращать список поездов на станции по типу: количество грузовых, пассажирских
  def list_trains_type
    @cargo = @all_trains.reject { |train| train.train_type == TYPE[0] }
    puts "Грузовые поезда на станции #{@name_station} : #{@cargo} в количестве #{@cargo.length}"
    @passenger = @all_trains.reject { |train| train.train_type == TYPE[1] }
    puts "Пассажирские поезда на станции #{@name_station} : #{@passenger} в количестве #{@passenger.length}"
  end

  #	Список всех поездов на станции, находящиеся в текущий момент
  def all_trains
    puts "Список всех поездов на станции #{@name_station} : #{@all_trains} в количестве #{@all_trains.length}"
  end

  #	Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  def send_train(train)  # Передача в аргумент объекта train класса Train
    @all_trains.delete(train) if @all_trains.include?(train)
  end
end

class Route

  #	Getter может возвращать список всех станций в маршруте
  attr_reader :all_stations_in_the_route

  #	Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  def initialize(first, last)     # Объекты класса Station передаются в аргументы
    @all_stations_in_the_route = [first, last] # Создание массива из двух элементов: начальной и конечной станции
  end

  #	Может добавлять промежуточную станцию в список и удалять все повторяющиеся элементы
  def add_station(middle_station)     # Объект класса Station передаётся в аргумент
    @all_stations_in_the_route.insert(1, middle_station).uniq
  end

  #	Может удалять промежуточную станцию из списка
  def delete_station(middle_station)
    @all_stations_in_the_route.delete_if { |station| station == middle_station && station != @all_stations_in_the_route[0] && station != @all_stations_in_the_route[-1] }
  end
  
  #	Может выводить список всех станций по-порядку от начальной до конечной
  def list_all_stations
    @all_stations_in_the_route.each { |station| puts "Станция маршрута #{self.to_s} : #{station}" }
  end
end

class Train

  #	Getter может возвращать текущую скорость, количество вагонов, номер поезда, тип, станцию (текущую, предыдущую, следующую), маршрут следования, индекс текущей станции.
  attr_reader :speed, :train_car, :train_number, :train_type, :current_station, :previous_station, :next_station, :route, :index

  #	Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
  def initialize(train_number, train_type, train_car, speed = 0)
    @train_number = train_number.to_s
    @train_type = train_type if (train_type == Station::TYPE[0]) || (train_type == Station::TYPE[1]) # Может принимать значения только из массива TYPE
    @train_car = train_car if (train_car.is_a?(Integer)) # Может принимать только целочисленное значение
    @speed = speed
  end

  #	Может набирать скорость
  def gather_speed(km_per_hour)
    @speed += km_per_hour if (km_per_hour > 0)
  end

  #	Может тормозить (сбрасывать скорость до нуля)
  def slow_down(km_per_hour)
    @speed -= km_per_hour while (@speed >= 0)
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
    @current_station = @route.all_stations_in_the_route[0]
  end

  #	Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  def moving_forward
    @index = @route.all_stations_in_the_route.index(@current_station)  # Находим индекс текущей станции
    @current_station = @route.all_stations_in_the_route[@index + 1]   # Перемещение вперёд на одну станцию (текущая поменялась)
  end
  def moving_back
    @index = @route.all_stations_in_the_route.index(@current_station)  # Находим индекс текущей станции
    @current_station = @route.all_stations_in_the_route[@index - 1]   # Перемещение назад на одну станцию (текущая поменялась)
  end

  #	Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
  def previous_station
    @index = @route.all_stations_in_the_route.index(@current_station)  # Находим индекс текущей станции
    @previous_station = @route.all_stations_in_the_route[@index - 1]   # Возвращаем предыдущую станцию (текущая осталась той же)
  end
  def next_station
    @index = @route.all_stations_in_the_route.index(@current_station)  # Находим индекс текущей станции
    @next_station = @route.all_stations_in_the_route[@index + 1]   # Возвращаем следующую станцию (текущая осталась той же)
  end
  def current_station
    @index = @route.all_stations_in_the_route.index(@current_station)  # Находим индекс текущей станции
    @current_station = @route.all_stations_in_the_route[@index]  # Возвращаем текущую станцию
  end
end

