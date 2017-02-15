/* This file is part of Gradio.
 *
 * Gradio is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Gradio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Gradio.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;

namespace Gradio{

	[GtkTemplate (ui = "/de/haecker-felix/gradio/ui/view/row-view.ui")]
	public class RowView : Gtk.ListBox, View{

		public StationModel model;

		public RowView(ref StationModel m){
			model = m;
			this.set_header_func(header_func);

			connect_signals();
		}

		private void header_func(ListBoxRow row, ListBoxRow? row_before){
			if(row_before == null){
				row.set_header(null);
				return;
			}

			Gtk.Widget current = row.get_header();

			if(current == null){
				current = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
				current.show();
				row.set_header(current);
			}
		}

		private void connect_signals(){
			this.bind_model (this.model, (obj) => {
     				assert (obj is RadioStation);

				weak RadioStation station = (RadioStation)obj;
				Row item = new Row(station);

      				return item;
			});

			this.row_activated.connect((t,a) => {
				Row row = (Row)a;
				Gradio.App.window.show_station_detail_page(row.station);
			});

		}
	}
}
