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
using Gd;

namespace Gradio{

	[GtkTemplate (ui = "/de/haecker-felix/gradio/ui/filter-box.ui")]
	public class FilterBox : Gtk.Box{

		private TaggedEntry SearchEntry;
		public string search_term;
		[GtkChild] Box SearchBox;

		[GtkChild] private Revealer CountryRevealer;
		[GtkChild] private Button SelectCountryButton;
		[GtkChild] private Button ClearCountryButton;
		[GtkChild] private ListBox CountryListBox;
		public string selected_country = "";
		private TaggedEntryTag country_tag;

		[GtkChild] private Revealer StateRevealer;
		[GtkChild] private Button SelectStateButton;
		[GtkChild] private Button ClearStateButton;
		[GtkChild] private ListBox StateListBox;
		public string selected_state = "";
		private TaggedEntryTag state_tag;

		[GtkChild] private Revealer LanguageRevealer;
		[GtkChild] private Button SelectLanguageButton;
		[GtkChild] private Button ClearLanguageButton;
		[GtkChild] private ListBox LanguageListBox;
		public string selected_language = "";
		private TaggedEntryTag language_tag;

		private CategoryItems category_items;

		public signal void information_changed();

		public FilterBox(){
			SearchEntry = new TaggedEntry();
			SearchEntry.width_request = 400;
			SearchEntry.set_visible(true);
			SearchBox.pack_start(SearchEntry);

			country_tag = new TaggedEntryTag("");
			state_tag = new TaggedEntryTag("");
			language_tag = new TaggedEntryTag("");

			category_items = new CategoryItems();

			LanguageListBox.bind_model(category_items.languages_model, (i) => {
				GenericItem item = (GenericItem)i;
				return get_row(item.text);
			});

			CountryListBox.bind_model(category_items.countries_model, (i) => {
				GenericItem item = (GenericItem)i;
				return get_row(item.text);
			});

			StateListBox.bind_model(category_items.states_model, (i) => {
				GenericItem item = (GenericItem)i;
				return get_row(item.text);
			});

			connect_signals();
		}

		private void connect_signals(){
			SearchEntry.tag_button_clicked.connect((t,a) => {
				if(a == language_tag){
					clear_selected_language();
				}
				if(a == country_tag){
					clear_selected_country();
				}
				if(a == state_tag){
					clear_selected_state();
				}
			});

			SearchEntry.search_changed.connect(() => {
				search_term = SearchEntry.get_text();
				information_changed();
			});

			CountryListBox.row_activated.connect((t,a) => {
				string selected_item = a.get_data("ITEM");
				SelectCountryButton.set_label(selected_item);

				selected_country = selected_item;
				country_tag.set_label(selected_item);
				SearchEntry.add_tag(country_tag);

				CountryRevealer.set_reveal_child(false);
				ClearCountryButton.set_visible(true);
				SelectStateButton.set_sensitive(false);

				information_changed();
			});

			StateListBox.row_activated.connect((t,a) => {
				string selected_item = a.get_data("ITEM");
				SelectStateButton.set_label(selected_item);

				selected_state = selected_item;
				state_tag.set_label(selected_item);
				SearchEntry.add_tag(state_tag);

				StateRevealer.set_reveal_child(false);
				SelectCountryButton.set_sensitive(false);
				ClearStateButton.set_visible(true);

				information_changed();
			});

			LanguageListBox.row_activated.connect((t,a) => {
				string selected_item = a.get_data("ITEM");
				SelectLanguageButton.set_label(selected_item);

				selected_language = selected_item;
				language_tag.set_label(selected_item);
				SearchEntry.add_tag(language_tag);

				LanguageRevealer.set_reveal_child(false);
				ClearLanguageButton.set_visible(true);

				information_changed();
			});
		}


		private void unreveal_all(){
			CountryRevealer.set_reveal_child(false);
			StateRevealer.set_reveal_child(false);
			LanguageRevealer.set_reveal_child(false);
		}

		private void clear_selected_country(){
			selected_country = "";
			country_tag.set_label("");
			SearchEntry.remove_tag(country_tag);
			SelectCountryButton.set_label("Select Country ...");
			ClearCountryButton.set_visible(false);
			SelectStateButton.set_sensitive(true);

			information_changed();
		}

		[GtkCallback]
		private void SelectCountryButton_clicked(){
			unreveal_all();
			CountryRevealer.set_reveal_child(!CountryRevealer.get_child_revealed());
		}

		[GtkCallback]
		private void ClearCountryButton_clicked(){
			clear_selected_country();
		}

		private void clear_selected_state(){
			selected_state = "";
			state_tag.set_label("");
			SearchEntry.remove_tag(state_tag);
			SelectStateButton.set_label("Select State ...");
			ClearStateButton.set_visible(false);
			SelectCountryButton.set_sensitive(true);

			information_changed();
		}

		[GtkCallback]
		private void SelectStateButton_clicked(){
			unreveal_all();
			StateRevealer.set_reveal_child(!StateRevealer.get_child_revealed());
		}

		[GtkCallback]
		private void ClearStateButton_clicked(){
			clear_selected_state();
		}

		private void clear_selected_language(){
			selected_language = "";
			language_tag.set_label("");
			SearchEntry.remove_tag(language_tag);
			SelectLanguageButton.set_label("Select Language ...");
			ClearLanguageButton.set_visible(false);

			information_changed();
		}

		[GtkCallback]
		private void SelectLanguageButton_clicked(){
			unreveal_all();
			LanguageRevealer.set_reveal_child(!LanguageRevealer.get_child_revealed());
		}

		[GtkCallback]
		private void ClearLanguageButton_clicked(){
			clear_selected_language();
		}

		public void reset_filters(){
			ClearCountryButton_clicked();
			ClearLanguageButton_clicked();
			ClearStateButton_clicked();
			SearchEntry.set_text("");
		}

		private ListBoxRow get_row(string text){
			ListBoxRow row = new ListBoxRow();

			Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
			box.vexpand = true;

			Gtk.Box rowbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			rowbox.add(box);
			row.add(rowbox);

			Label label = new Label (text);
			label.margin = 5;
			box.add(label);

			Separator sep = new Separator(Gtk.Orientation.HORIZONTAL);
			sep.set_halign(Align.FILL);
			sep.set_valign(Align.END);
			rowbox.pack_end(sep);

			row.height_request = 40;
			row.set_data("ITEM", text);
			row.show_all();

			return row;
		}
	}
}
