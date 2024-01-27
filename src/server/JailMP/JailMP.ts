import { IsoPlayer, IsoThumpable, getOnlinePlayers, getSteamScoreboard, getWorld, isServer } from '@asledgehammer/pipewrench';
import * as Events from '@asledgehammer/pipewrench-events';



Events.onClientCommand.addListener((module, command, player, args) => {
    if (module != "HungerGames") return
    if (!isServer()) return
    //Catch client commands here
    if (command == "ping") {
      let access_level = player.getAccessLevel();
      if (args.command == "jail") {
          if (access_level == "Admin") {
            jailPlayer(args.username);
          }
      }
      if (args.command == "unjail") {
        if (access_level == "Admin") {
          unjailPlayer(args.username)
        }
    }
    }
  })


  const createWall = (x: any, y: any, z: any, wallname: string, player: IsoPlayer) => {
    if(!isServer()) return;
    const cell = getWorld().getCell();
    const square = cell.getGridSquare(x, y, z);
    const wall = new IsoThumpable(cell, square, wallname,  false, {})
    const wall_name = "prison" + "_" + player.getUsername();
    wall.setName(wall_name);
    wall.setIsThumpable(false);
    square.AddSpecialObject(wall);
    wall.transmitCompleteItemToClients();
  }


  const removeWall = (x: any, y: any, z: any, player: IsoPlayer) => {
    const cell = getWorld().getCell();
    const square = cell.getGridSquare(x, y, z);
    const new_cell = square.getCell();
    let object_list = new_cell.getObjectList();
    const wall = square.getThumpableWall(true);
    if (wall == null) return;
    let wallName = wall.getName();
    if (wallName == "prison" + "_" + player.getUsername()) {
      square.transmitRemoveItemFromSquareOnServer(wall);
      square.transmitRemoveItemFromSquare(wall);
      wall.removeFromWorld();
      wall.removeFromSquare();
      square.transmitRemoveItemFromSquareOnServer(wall);
      square.transmitRemoveItemFromSquare(wall);
    }
  }
  
  const jailPlayer = (username: string) => {
    let users = getOnlinePlayers();
    for (let i = 0; i < users.size(); i++) {
      const user = users.get(i);
      if (user.getUsername() == username) {
        createJail(user);
      }
    }
  }

  const createJail = (player: IsoPlayer) => {
    const playerX = player.getX();
    const playerY = player.getY();
    const playerZ = player.getZ();
    //top corner
    createWall(playerX, playerY, playerZ, "fencing_01_92", player);
    //bottom right corner
    createWall(playerX+1, playerY, playerZ, "fencing_01_90", player);
    //bottom left corner
    createWall(playerX, playerY+1, playerZ, "fencing_01_89", player);
  }

  const unjailPlayer = (username: string) => {
    let users = getOnlinePlayers();
    for (let i = 0; i < users.size(); i++) {
      const user = users.get(i);
      if (user.getUsername() == username) {
        removeJail(user);
      }
    }
  }

  const removeJail = (player: IsoPlayer) => {
    const playerX = player.getX();
    const playerY = player.getY();
    const playerZ = player.getZ();
    const player_name = player.getUsername();
    let cell = player.getCell();
    let objectList = cell.getProcessIsoObjects();
    for (let i = 0; i < objectList.size(); i++) {
      let obj = objectList.get(i);
      if (obj.getName() == "prison" + "_" + player_name) {
        let square = cell.getGridSquare(obj.getX(), obj.getY(), obj.getZ());
        square.transmitRemoveItemFromSquareOnServer(obj);
        square.transmitRemoveItemFromSquare(obj);
        obj.removeFromWorld();
        obj.removeFromSquare();
        square.transmitRemoveItemFromSquareOnServer(obj);
        square.transmitRemoveItemFromSquare(obj);
      }
    }    
  }