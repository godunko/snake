
with Gtk.Drawing_Area;

package Snake.Graphics_Views is

   type Graphics_View_Record is
     new Gtk.Drawing_Area.Gtk_Drawing_Area_Record with private;

   type Graphics_View is access all Graphics_View_Record'Class;

   procedure Gtk_New (Result : in out Graphics_View);

   procedure Initialize
     (Self : not null access Graphics_View_Record'Class);

private

   type Graphics_View_Record is
     new Gtk.Drawing_Area.Gtk_Drawing_Area_Record with record
      null;
   end record;

end Snake.Graphics_Views;
