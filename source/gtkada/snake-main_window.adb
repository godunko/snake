--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: GPL-3.0-or-later
--

with Ada.Command_Line;

with Glib.Application;
with Gtk.Application;
with Gtk.Application_Window;
with Glib.Main;

with Snake.Controller;
with Snake.Graphics_Views;
with Snake.Scene;

package body Snake.Main_Window is

   App : Gtk.Application.Gtk_Application;

   AW  : Gtk.Application_Window.Gtk_Application_Window;
   GV  : Snake.Graphics_Views.Graphics_View;
   T   : Glib.Main.G_Source_Id;

   procedure On_Activate
     (Self : access Glib.Application.Gapplication_Record'Class);

   function On_Timer return Boolean;

   -----------------
   -- On_Activate --
   -----------------

   procedure On_Activate
     (Self : access Glib.Application.Gapplication_Record'Class)
   is
      pragma Unreferenced (Self);

   begin
      Snake.Graphics_Views.Gtk_New (GV);

      Gtk.Application_Window.Gtk_New (AW, App);
      AW.Add (GV);
      AW.Show_All;

      T := Glib.Main.Timeout_Add (400, On_Timer'Access);
   end On_Activate;

   --------------
   -- On_Timer --
   --------------

   function On_Timer return Boolean is
   begin
      Snake.Scene.Move (Snake.Controller.Direction);

      GV.Queue_Draw;

      return True;
   end On_Timer;

   ---------
   -- Run --
   ---------

   procedure Run is
      Status : Glib.Gint;

   begin
      App :=
        Gtk.Application.Gtk_Application_New
          (Flags => Glib.Application.G_Application_Flags_None);

      App.On_Activate (Call => On_Activate'Access);

      Status := App.Run;

      Glib.Main.Remove (T);
      App.Unref;

      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Exit_Status (Status));
   end Run;

end Snake.Main_Window;
