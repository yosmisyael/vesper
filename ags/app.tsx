import { App, Widget } from "astal/gtk3"
import Calendar from "./widget/Calendar"

App.start({
    css: "./style.css",
    main() {
        Calendar();
    }
})
