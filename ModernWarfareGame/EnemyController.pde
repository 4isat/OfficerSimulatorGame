class EnemyController{
  //Make it work so that enemy units first scan to see if they can attack any player units. If they are able to,
  //attack the unit, and do not move the next turn. If morale is less than 20, move towards the right (increasing the grid[][x]'s x). 
  //If there are no player units in range, make it so enemy moves to the closest tile that is a forest or a 
  //building. if there are none of these in movement range, make them move randomly. Make sure they do not move
  // to tiles that are not on the map. If the unit is a supply unit, ignore all the following information and make them move to the 
  //unit with the lowest ammo amount. If there are multiple units with 0 ammo, move it to the closest one with 0 ammo (use distance
  //formula to calculate). When next to a friendly unit, make it attack that friendly unit.
  //I think the biggest problem with this is that the movement and attack is handled in multiple different places, such as Level, 
  // Unit, so I dont know whether I should extend from which class. I cannot make objects of either class either, as then I will be creating 
  // duplicate objects. Another idea is maybe I just put all of this within the Level class?
  
  private Unit unit;
  
  
}
