## This file is added into /usr/local/zeek/share/zeek/site path.
## Used to add new attributes "vpc_name" and "project_id" in all required logs

redef record Conn::Info += {
        vpc_name: string &default="vpc" &log;
        project_id: string &default="project" &log;
};

redef record HTTP::Info += {
        vpc_name: string &default="vpc" &log;
        project_id: string &default="project" &log;
};

redef record SSL::Info += {
        vpc_name: string &default="vpc" &log;
        project_id: string &default="project" &log;
};

redef record SSH::Info += {
        vpc_name: string &default="vpc" &log;
        project_id: string &default="project" &log;
};

redef record DNS::Info += {
        vpc_name: string &default="vpc" &log;
        project_id: string &default="project" &log;
};

redef record DHCP::Info += {
        vpc_name: string &default="vpc" &log;
        project_id: string &default="project" &log;
};
