// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import NotificationController from "./notification_controller";
import SyncController from "./sync_controller";

eagerLoadControllersFrom("controllers", application)
application.register("notification", NotificationController);
application.register("sync", SyncController);