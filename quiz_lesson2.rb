#1.)
@a = 2
# => An instance variable
user = User.name
# => An instance object of User class
user.name
# => A getter
user.name = "Joe"
# => A setter

#2.)
# => Creating a Module then using "require" in the Class that you want to mixin the module.

#3.) 
# => Class variables are shared through the whole class.  It uses @@ symbols at the beginning.
# => Instance variables are not shared through the whole class and begins with @ symbol.

#4.) 
# => The atter_accessor provides getter and setter methods for a class.

#5.) 
# => The Dog class calling the some_method class method.

#6.)
# => Subclasses recieve a single inheritance from superclasses.  They have an is relationship, e.g. A Dog subclass is an Animal class.
# => Modules are usually when classes have multiple inheritances or there are some behaviors that some subclasses have but others don't.
# => They have a has relationship, e.g. a Dog subclass has the ability to swim, but a Bird subclass doesn't but both are subclases of Animal class. 

#7.)
# => Class User
# =>  attr_accessor :name
# =>  def initialize(name)
# =>    @name = name
# =>  end
# => end

#8.)
# => Yes

#9.)
# => Read the error message to check what the error is and what line the error might be on. 
# => If I can't see it right away after reading the error message I will use pry.


