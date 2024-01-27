/**
 * @noSelfInFile
 *
 * NOTE: Use this at the top of your TypeScript files. This prevents functions & methods
 *       from prepending a 'self' reference, which is usually not necessary and complicates
 *       rendered Lua code.
 */

// PipeWrench API.
import { getPlayer, isClient, sendClientCommand } from '@asledgehammer/pipewrench';
import * as Events from '@asledgehammer/pipewrench-events';
// Example reference API.
import { addRedSquare, alertObjectsAdded, greetPlayer } from './api/ExampleAPI';

// Add all initialization code here.
Events.onAddMessage.addListener((chatMessage, tab) => {
  if (isClient()) {
      if (chatMessage.getText().includes("!jail")) {
        const username = chatMessage.getText().split(" ")[1];
          sendClientCommand(getPlayer(), "HungerGames", "ping", {"command": "jail", "username": username})
      }
      if (chatMessage.getText().includes("!unjail")) {
        const username = chatMessage.getText().split(" ")[1];
        sendClientCommand(getPlayer(), "HungerGames", "ping", {"command": "unjail", "username": username})
    }
  }
})
