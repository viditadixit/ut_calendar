package utcalendar;
import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

public class DeleteItem extends HttpServlet {
	static {
        ObjectifyService.register(User.class);
    }

	public void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		
		String item = (String) request.getParameter("item");
		Long id = Long.parseLong(request.getParameter("id"));

		List<User> users = ObjectifyService.ofy().load().type(User.class).list();
		User currentUser = new User();
		for (User u : users) {
			if (u.getId().equals(id)) {
				if (!item.equals("")) {
					currentUser = new User(u.getName(), u.getEmail(), u.getPassword());
					currentUser.setId(id);
					u.deleteItem(item);
					currentUser.toDoList = u.toDoList;
					currentUser.schedules = u.schedules;
					ofy().delete().entity(u).now();
					ofy().save().entity(currentUser).now();
					request.setAttribute("id", id);
				}
				break;
			}
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher("/calendar.jsp");
		try {
			dispatcher.forward(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}