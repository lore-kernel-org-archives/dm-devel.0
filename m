From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/26] multipathd: Fixup commandline argument
	handling
Date: Mon,  4 Jul 2016 09:08:43 +0200
Message-ID: <1467616126-10036-24-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

multipathd would attempt to store the commandline arguments in
an empty configuration, which would later be overwritten when
reading in the main configuration.
And it would not pass in the arguments correctly when using the
CLI interface.
So with this patch the commandline arguments are stored in
global variables, which then will always overwrite settings
from the configuration file.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 84dd1f8..c4d6f9f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -99,6 +99,9 @@ struct mpath_event_param
 unsigned int mpath_mx_alloc_len;
 
 int logsink;
+int verbosity;
+int bindings_read_only;
+int ignore_new_devs;
 enum daemon_status running_state = DAEMON_INIT;
 pid_t daemon_pid;
 pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
@@ -1893,9 +1896,12 @@ reconfigure (struct vectors * vecs)
 
 	if (!load_config(DEFAULT_CONFIGFILE)) {
 		dm_drv_version(conf->version, TGT_MPATH);
-		conf->verbosity = old->verbosity;
-		conf->bindings_read_only = old->bindings_read_only;
-		conf->ignore_new_devs = old->ignore_new_devs;
+		if (verbosity)
+			conf->verbosity = verbosity;
+		if (bindings_read_only)
+			conf->bindings_read_only = bindings_read_only;
+		if (ignore_new_devs)
+			conf->ignore_new_devs = ignore_new_devs;
 		configure(vecs, 1);
 		multipath_conf = conf;
 		free_config(old);
@@ -2121,6 +2127,12 @@ child (void * param)
 	if (load_config(DEFAULT_CONFIGFILE))
 		goto failed;
 
+	if (verbosity)
+		conf->verbosity = verbosity;
+	if (bindings_read_only)
+		conf->bindings_read_only = bindings_read_only;
+	if (ignore_new_devs)
+		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
 	multipath_conf = conf;
 	dm_init(conf->verbosity);
@@ -2392,11 +2404,6 @@ main (int argc, char *argv[])
 			strerror(errno));
 	umask(umask(077) | 022);
 
-	conf = alloc_config();
-
-	if (!conf)
-		exit(1);
-
 	udev = udev_new();
 
 	while ((arg = getopt(argc, argv, ":dsv:k::Bn")) != EOF ) {
@@ -2412,7 +2419,7 @@ main (int argc, char *argv[])
 			    !isdigit(optarg[0]))
 				exit(1);
 
-			conf->verbosity = atoi(optarg);
+			verbosity = atoi(optarg);
 			break;
 		case 's':
 			logsink = -1;
@@ -2420,13 +2427,15 @@ main (int argc, char *argv[])
 		case 'k':
 			if (load_config(DEFAULT_CONFIGFILE))
 				exit(1);
+			if (verbosity)
+				conf->verbosity = verbosity;
 			uxclnt(optarg, uxsock_timeout + 100);
 			exit(0);
 		case 'B':
-			conf->bindings_read_only = 1;
+			bindings_read_only = 1;
 			break;
 		case 'n':
-			conf->ignore_new_devs = 1;
+			ignore_new_devs = 1;
 			break;
 		default:
 			fprintf(stderr, "Invalid argument '-%c'\n",
@@ -2441,6 +2450,8 @@ main (int argc, char *argv[])
 
 		if (load_config(DEFAULT_CONFIGFILE))
 			exit(1);
+		if (verbosity)
+			conf->verbosity = verbosity;
 		memset(cmd, 0x0, CMDSIZE);
 		while (optind < argc) {
 			if (strchr(argv[optind], ' '))
-- 
2.6.6
