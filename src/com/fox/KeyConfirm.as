import com.GameInterface.DialogIF;
import com.GameInterface.Input;
import com.GameInterface.RadioButtonsDialog;

class com.fox.KeyConfirm{
	static var dialogue:RadioButtonsDialog;
	public static function main(swfRoot:MovieClip):Void{
		var s_app = new KeyConfirm(swfRoot);
		swfRoot.onLoad = function(){s_app.Load()};
		swfRoot.onUnload = function(){s_app.Unload()};
	}
	public function KeyConfirm() {
		// F is missing Enum, just have to guess numbers until you hit the right one
		// likely to break if new keybinds ever get added
		// luckily this should just stop the mod from working without breaking anything else
		// Default keys use HotKeyDown, so using Up allows the mod to use same keys
		Input.RegisterHotkey(148, "com.fox.KeyConfirm.FPressed", _global.Enums.Hotkey.eHotkeyUp, 0);
		Input.RegisterHotkey(_global.Enums.InputCommand.e_InputCommand_ESC, "com.fox.KeyConfirm.ESCPressed", _global.Enums.Hotkey.eHotkeyUp, 0);
	}
	public static function FPressed(){
		if (dialogue){
			dialogue.Respond(_global.Enums.StandardButtonID.e_ButtonIDAccept);
		}
	}
	public static function ESCPressed(){
		if (dialogue){
			dialogue.Respond(_global.Enums.StandardButtonID.e_ButtonIDCancel);
		}
	}
	public function Load(){
		DialogIF.SignalShowDialog.Connect(SetDialogue, this);
	}
	public function Unload(){
		DialogIF.SignalShowDialog.Disconnect(SetDialogue, this);
	}
	private function SetDialogue(dialog:RadioButtonsDialog){
		dialogue = dialog;
		dialogue.SignalSelectedAS.Connect(ClearWindow, this);
	}
	// trying to close right after respond doesnt work
	// works fine with SignalSelectedAS though
	private function ClearWindow(buttonId, Variant, selection){
		dialogue.SignalSelectedAS.Disconnect(ClearWindow, this);
		dialogue.Close();
		dialogue = undefined;
	}

}