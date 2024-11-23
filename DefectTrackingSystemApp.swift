import SwiftUI

@main
struct DefectTrackingSystemApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedPage: String = "home"
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var userRole: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var projectName: String = ""
    @State private var defectTitle: String = ""
    @State private var defectDescription: String = ""
    @State private var defectPriority: String = "Low"
    @State private var employeeName: String = ""
    @State private var employeeRole: String = "Developer"
    @State private var assignedEmployee: String = ""
    
    @State private var projects: [String] = []
    @State private var defects: [(title: String, description: String, priority: String, status: String, assignedTo: String)] = []
    @State private var employees: [(name: String, role: String)] = []
    
    // Users data
    @State private var users: [(username: String, password: String, role: String)] = [
        (username: "admin", password: "admin", role: "admin"),
        (username: "developer", password: "developer", role: "developer"),
        (username: "tester", password: "tester", role: "tester")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                headerView
                
                if !isLoggedIn {
                    loginView
                } else {
                    mainContent
                }
            }
            .padding()
            .navigationTitle("") // Hide the navigation title
            .navigationBarBackButtonHidden(true) // Optionally hide the back button
        }
        .onAppear {
            loadData()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    var headerView: some View {
        HStack {
            Text("Defect Tracking System")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            if isLoggedIn {
                Button(action: signOut) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
    }
    
    var loginView: some View {
        VStack {
            Text("Login")
                .font(.title)
                .padding()
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: login) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    var mainContent: some View {
        VStack {
            Picker("Select Page", selection: $selectedPage) {
                Text("Home").tag("home")
                if userRole == "admin" {
                    Text("Users").tag("users")
                    Text("Projects").tag("projects")
                }
                Text("Defects").tag("defects")
                Text("Reports").tag("reports")
                if userRole == "admin" {
                    Text("Employees").tag("employees")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            switch selectedPage {
            case "home":
                homeView
            case "users":
                userManagementView
            case "projects":
                projectsView
            case "defects":
                defectsView
            case "reports":
                reportsView
            case "employees":
                employeesView
            default:
                homeView
            }
        }
    }
    var homeView: some View {
        Text("Welcome to the Defect Tracking System.")
            .padding()
    }
    
    var userManagementView: some View {
        Group {
            if userRole == "admin" {
                VStack {
                    Text("User  Management")
                        .font(.title)
                    TextField("New Username", text: $employeeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    SecureField("New Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Picker("Role", selection: $employeeRole) {
                        Text("Developer").tag("Developer")
                        Text("Tester").tag("Tester")
                        Text("Admin").tag("Admin")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    Button(action: addUser ) {
                        Text("Add User")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    List(users, id: \.username) { user in
                        Text("\(user.username) - \(user.role)")
                    }
                }
                .padding()
            } else {
                Text("Access Denied").foregroundColor(.red)
            }
        }
    }

    var employeesView: some View {
        Group {
            if userRole == "admin" {
                VStack {
                    Text("Employees")
                        .font(.title)
                    TextField("Employee Name", text: $employeeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Picker("Role", selection: $employeeRole) {
                        Text("Developer").tag("Developer")
                        Text("Tester").tag("Tester")
                        Text("Manager").tag("Manager")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    Button(action: addEmployee) {
                        Text("Add Employee")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    List(employees, id: \.name) { employee in
                        Text("\(employee.name) - \(employee.role)")
                    }
                }
                .padding()
            } else {
                Text("Access Denied").foregroundColor(.red)
            }
        }
    }
    var projectsView: some View {
        VStack {
            Text("Projects")
                .font(.title)
            TextField("Project Name", text: $projectName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: addProject) {
                Text("Add Project")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            List(projects, id: \.self) { project in
                Text(project)
            }
        }
        .padding()
    }
    
    var defectsView: some View {
        VStack {
            Text("Defects")
                .font(.title)
            TextField("Defect Title", text: $defectTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Defect Description", text: $defectDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Picker("Priority", selection: $defectPriority) {
                Text("Low").tag("Low")
                Text("Medium").tag("Medium")
                Text("High").tag("High")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Picker("Assign To", selection: $assignedEmployee) {
                ForEach(employees, id: \.name) { employee in
                    Text(employee.name).tag(employee.name)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            Button(action: addDefect) {
                Text("Add Defect")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            List(defects, id: \.title) { defect in
                VStack(alignment: .leading) {
                    Text(defect.title).fontWeight(.bold)
                    Text(defect.description)
                    Text("Priority: \(defect.priority)").font(.subheadline)
                    Text("Status: \(defect.status)").font(.subheadline)
                    Text("Assigned To: \(defect.assignedTo)").font(.subheadline)
                }
            }
        }
        .padding()
    }
    
    var reportsView: some View {
        VStack {
            Text("Reports")
                .font(.title)
            List(defects, id: \.title) { defect in
                Text("\(defect.title) - Status: \(defect.status)")
            }
        }
        .padding()
    }
    
    var UserManagementView: some View {
        Group {
            if userRole == "admin" {
                VStack {
                    Text("User  Management")
                        .font(.title)
                    TextField("New Username", text: $employeeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    SecureField("New Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Picker("Role", selection: $employeeRole) {
                        Text("Developer").tag("Developer")
                        Text("Tester").tag("Tester")
                        Text("Admin").tag("Admin")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    Button(action: addUser ) {
                        Text("Add User")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    List(users, id: \.username) { user in
                        Text("\(user.username) - \(user.role)")
                    }
                }
                .padding()
            } else {
                Text("Access Denied").foregroundColor(.red)
            }
        }
    }

    var EmployeesView: some View {
        Group {
            if userRole == "admin" {
                VStack {
                    Text("Employees")
                        .font(.title)
                    TextField("Employee Name", text: $employeeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Picker("Role", selection: $employeeRole) {
                        Text("Developer").tag("Developer")
                        Text("Tester").tag("Tester")
                        Text("Manager").tag("Manager")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    Button(action: addEmployee) {
                        Text("Add Employee")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    List(employees, id: \.name) { employee in
                        Text("\(employee.name) - \(employee.role)")
                    }
                }
                .padding()
            } else {
                AnyView(Text("Access Denied").foregroundColor(.red))
            }
        }
    }
    
    func login() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let user = users.first(where: {
            $0.username.lowercased() == trimmedUsername.lowercased() &&
            $0.password == trimmedPassword
        }) {
            isLoggedIn = true
            userRole = user.role
            alertMessage = "Welcome, \(user.role)!"
            username = ""
            password = ""
        } else {
            alertMessage = "Invalid username or password."
            showAlert = true
        }
    }
    
    func signOut() {
        isLoggedIn = false
        userRole = ""
    }
    
    func addUser () {
        if !employeeName.isEmpty && !password.isEmpty {
            users.append((username: employeeName, password: password, role: employeeRole))
            employeeName = ""
            password = ""
        }
    }
    
    func addProject() {
        if !projectName.isEmpty {
            projects.append(projectName)
            projectName = "" // Clear the project name after adding
        }
    }
    
    func addDefect() {
        if !defectTitle.isEmpty && !defectDescription.isEmpty {
            defects.append((title: defectTitle, description: defectDescription, priority: defectPriority, status: "Pending", assignedTo: assignedEmployee))
            defectTitle = ""
            defectDescription = ""
            assignedEmployee = ""
        }
    }
    
    func addEmployee() {
        if !employeeName.isEmpty {
            employees.append((name: employeeName, role: employeeRole))
            employeeName = ""
        }
    }
    
    func loadData() {
        // Load projects
        if let savedProjects = UserDefaults.standard.array(forKey: "projects") as? [String] {
            projects = savedProjects
        }
        
        // Load defects
        if let savedDefects = UserDefaults.standard.array(forKey: "defects") as? [[String: String]] {
            defects = savedDefects.compactMap { dict in
                guard let title = dict["title"],
                      let description = dict["description"],
                      let priority = dict["priority"],
                      let status = dict["status"],
                      let assignedTo = dict["assignedTo"] else { return nil }
                return (title: title, description: description, priority: priority, status: status, assignedTo: assignedTo)
            }
        }
        
        // Load employees
        if let savedEmployees = UserDefaults.standard.array(forKey: "employees") as? [[String: String]] {
            employees = savedEmployees.compactMap { dict in
                guard let name = dict["name"], let role = dict["role"] else { return nil }
                return (name: name, role: role)
            }
        }
    }
}
