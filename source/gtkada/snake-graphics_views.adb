
with Cairo;
with Gdk.Cairo;
with Gdk.Event;
with Gdk.RGBA;
with Gdk.Types.Keysyms;
with Glib;
with Gtk.Widget;

with Snake.Controller;
with Snake.Scene;

package body Snake.Graphics_Views is

   function On_Draw_Dispatch
     (Self : access Gtk.Widget.Gtk_Widget_Record'Class;
      Cr   : Cairo.Cairo_Context) return Boolean;

   function On_Key_Press_Event_Dispatch
     (Self  : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Key) return Boolean;

   function On_Draw
     (Self : in out Graphics_View_Record'Class;
      Cr   : Cairo.Cairo_Context) return Boolean;

   function On_Key_Press_Event
     (Self  : access Graphics_View_Record'Class;
      Event : Gdk.Event.Gdk_Event_Key) return Boolean;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Result : in out Graphics_View) is
   begin
      Result := new Graphics_View_Record;
      Initialize (Result);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Self : not null access Graphics_View_Record'Class) is
   begin
      Snake.Scene.Initialize;

      Gtk.Drawing_Area.Initialize (Self);
      Self.Set_Can_Focus (True);
      Self.On_Draw (On_Draw_Dispatch'Access);
      Self.On_Key_Press_Event (On_Key_Press_Event_Dispatch'Access);
   end Initialize;

   -------------
   -- On_Draw --
   -------------

   function On_Draw
     (Self : in out Graphics_View_Record'Class;
      Cr   : Cairo.Cairo_Context) return Boolean
   is
      use type Glib.Gdouble;

      W  : constant Glib.Gdouble := Glib.Gdouble (Self.Get_Allocated_Width);
      H  : constant Glib.Gdouble := Glib.Gdouble (Self.Get_Allocated_Height);

      CX : constant Glib.Gdouble := W / 2.0;
      CY : constant Glib.Gdouble := H / 2.0;

      S  : constant Glib.Gdouble :=
        Glib.Gdouble'Min (W / 16.0, H / 16.0);
      B  : constant Glib.Gdouble := S / 4.0;
      L  : constant Glib.Gdouble := S / 2.0;

      CXB : Glib.Gdouble;
      CYB : Glib.Gdouble;

      LXB : Glib.Gdouble;
      LYB : Glib.Gdouble;

   begin
      Gdk.Cairo.Set_Source_RGBA (Cr, Gdk.RGBA.Black_RGBA);

      Cairo.Rectangle (Cr, 0.0, 0.0, W, H);
      Cairo.Fill (Cr);

      for J in Snake.Scene.Board'Range (1) loop
         for K in Snake.Scene.Board'Range (2) loop
            CXB := CX + Glib.Gdouble (K - 9) * S;
            CYB := CY + Glib.Gdouble (J - 9) * S;

            LXB := CXB + B;
            LYB := CYB + B;

            case Scene.Board (J, K) is
               when Snake.Scene.Empty =>
                  Gdk.Cairo.Set_Source_RGBA (Cr, (0.1, 0.1, 0.1, 1.0));

               when Snake.Scene.Wall =>
                  Gdk.Cairo.Set_Source_RGBA (Cr, Gdk.RGBA.White_RGBA);

               when Snake.Scene.Apple =>
                  Gdk.Cairo.Set_Source_RGBA (Cr, (1.0, 0.86, 0.12, 1.0));

               when Snake.Scene.Creature =>
                  Gdk.Cairo.Set_Source_RGBA (Cr, (0.0, 1.0, 0.0, 1.0));

               when Snake.Scene.Crash =>
                  Gdk.Cairo.Set_Source_RGBA (Cr, (1.0, 0.0, 0.0, 1.0));

               when Snake.Scene.Font =>
                  Gdk.Cairo.Set_Source_RGBA (Cr, (1.0, 1.0, 1.0, 1.0));
            end case;

            Cairo.Rectangle (Cr, LXB, LYB, L, L);
            Cairo.Fill (Cr);
         end loop;
      end loop;

      return True;
   end On_Draw;

   ----------------------
   -- On_Draw_Dispatch --
   ----------------------

   function On_Draw_Dispatch
     (Self : access Gtk.Widget.Gtk_Widget_Record'Class;
      Cr   : Cairo.Cairo_Context) return Boolean is
   begin
      return Graphics_View_Record'Class (Self.all).On_Draw (Cr);
   end On_Draw_Dispatch;

   ------------------------
   -- On_Key_Press_Event --
   ------------------------

   function On_Key_Press_Event
     (Self  : access Graphics_View_Record'Class;
      Event : Gdk.Event.Gdk_Event_Key) return Boolean
   is
      pragma Unreferenced (Self);

   begin
      case Event.Keyval is
         when Gdk.Types.Keysyms.GDK_Right | Gdk.Types.Keysyms.GDK_KP_Right =>
            Snake.Controller.Change_Direction (Snake.Controller.Right);

         when Gdk.Types.Keysyms.GDK_Up | Gdk.Types.Keysyms.GDK_KP_Up =>
            Snake.Controller.Change_Direction (Snake.Controller.Up);

         when Gdk.Types.Keysyms.GDK_Left | Gdk.Types.Keysyms.GDK_KP_Left =>
            Snake.Controller.Change_Direction (Snake.Controller.Left);

         when Gdk.Types.Keysyms.GDK_Down | Gdk.Types.Keysyms.GDK_KP_Down =>
            Snake.Controller.Change_Direction (Snake.Controller.Down);

         when others =>
            return False;
      end case;

      return True;
   end On_Key_Press_Event;

   ---------------------------------
   -- On_Key_Press_Event_Dispatch --
   ---------------------------------

   function On_Key_Press_Event_Dispatch
     (Self  : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Key) return Boolean is
   begin
      return Graphics_View_Record'Class (Self.all).On_Key_Press_Event (Event);
   end On_Key_Press_Event_Dispatch;

end Snake.Graphics_Views;
