import com.GameInterface.DialogIF;
import com.GameInterface.DistributedValueBase;
import com.GameInterface.Input;
import com.GameInterface.PlayerDeath;
import com.GameInterface.RadioButtonsDialog;
import com.GameInterface.RespawnPoint;

class com.fox.KeyConfirm
{
	static var dialogue:RadioButtonsDialog;
	public static function main(swfRoot:MovieClip):Void
	{
		var s_app = new KeyConfirm(swfRoot);
		swfRoot.onLoad = function() {s_app.Load()};
		swfRoot.onUnload = function() {s_app.Unload()};
	}
	public function KeyConfirm()
	{
		// F is missing Enum, just have to guess numbers until you hit the right one
		// likely to break if new keybinds ever get added
		// luckily this should just stop the mod from working without breaking anything else
		// Default keys use HotKeyDown, so using Up allows the mod to use same keys
		Input.RegisterHotkey(148, "com.fox.KeyConfirm.FPressed", _global.Enums.Hotkey.eHotkeyUp, 0);
		Input.RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_ESC, "com.fox.KeyConfirm.ESCPressed", _global.Enums.Hotkey.eHotkeyUp, 0);
	}
	public static function FPressed()
	{
		if (dialogue)
		{
			dialogue.Respond(_global.Enums.StandardButtonID.e_ButtonIDAccept);
		}
		else if (_root.deathwindowcontroller.m_ShowingTombstone)
		{
			PlayerDeath.ClearGhosting();
		}
		else if (_root.deathwindowcontroller.i_BigWindow)
		{
			var animaWells:Array = PlayerDeath.GetAnimaWellArray();
			var closest:Number = 10000;
			var nearestWell:RespawnPoint;
			for (var i in animaWells)
			{
				if (RespawnPoint(animaWells[i]).m_DistanceInMeters < closest)
				{
					nearestWell = animaWells[i];
				}
			}
			if (nearestWell)
			{
				PlayerDeath.Resurrect(nearestWell.m_Id);
			}
		}
	}
	public static function ESCPressed()
	{
		if (dialogue)
		{
			dialogue.Respond(_global.Enums.StandardButtonID.e_ButtonIDCancel);
		}
		else if (_root.deathwindowcontroller.m_ShowingTombstone)
		{
			_root.deathwindowcontroller.Decline();
			DistributedValueBase.SetDValue("mainmenu_window", false);
		}
	}
	public function Load()
	{
		DialogIF.SignalShowDialog.Connect(SetDialogue, this);
	}
	public function Unload()
	{
		DialogIF.SignalShowDialog.Disconnect(SetDialogue, this);
	}
	private function SetDialogue(dialog:RadioButtonsDialog)
	{
		dialogue = dialog;
		dialogue.SignalSelectedAS.Connect(ClearWindow, this);
	}
	// trying to close right after respond doesnt work
	// works fine with SignalSelectedAS though
	private function ClearWindow(buttonId, Variant, selection)
	{
		dialogue.SignalSelectedAS.Disconnect(ClearWindow, this);
		dialogue.Close();
		dialogue = undefined;
	}

}