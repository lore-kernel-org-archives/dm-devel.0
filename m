From: mwilck@suse.com
Subject: [PATCH 2/2] multipath: add "-e" option to enable foreign
	libraries
Date: Fri,  8 May 2020 21:33:02 +0200
Message-ID: <20200508193302.11401-3-mwilck@suse.com>
References: <20200508193302.11401-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200508193302.11401-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "George, Martin" <Martin.George@netapp.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

As we have set "enable_foreign" to "NONE" now by default, users
may find it useful to be able to switch on foreign multipath display
with an extra command line option even if foreign libraries are
not enabled in multipath.conf. Currently this makes only sense
with "multipath -ll", as the nvme library (and foreign libraries
in general) support only the display of status information.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c      | 11 ++++++++++-
 multipath/multipath.8 |  6 ++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index cf9d2a28..af9d757a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -148,6 +148,7 @@ usage (char * progname)
 		"  -h      print this usage text\n"
 		"  -l      show multipath topology (sysfs and DM info)\n"
 		"  -ll     show multipath topology (maximum info)\n"
+		"  -e      enable foreign libraries with -l/-ll\n"
 		"  -f      flush a multipath device map\n"
 		"  -F      flush all multipath device maps\n"
 		"  -a      add a device wwid to the wwids file\n"
@@ -898,6 +899,7 @@ main (int argc, char *argv[])
 	char *dev = NULL;
 	struct config *conf;
 	int retries = -1;
+	bool enable_foreign = false;
 
 	udev = udev_new();
 	logsink = 0;
@@ -907,7 +909,7 @@ main (int argc, char *argv[])
 	multipath_conf = conf;
 	conf->retrigger_tries = 0;
 	conf->force_sync = 1;
-	while ((arg = getopt(argc, argv, ":adcChl::FfM:v:p:b:BrR:itTquUwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adcChl::eFfM:v:p:b:BrR:itTquUwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -1000,6 +1002,9 @@ main (int argc, char *argv[])
 		case 'R':
 			retries = atoi(optarg);
 			break;
+		case 'e':
+			enable_foreign = true;
+			break;
 		case ':':
 			fprintf(stderr, "Missing option argument\n");
 			usage(argv[0]);
@@ -1051,6 +1056,10 @@ main (int argc, char *argv[])
 		condlog(0, "failed to initialize prioritizers");
 		goto out;
 	}
+
+	if ((cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG) && enable_foreign)
+		conf->enable_foreign = "";
+
 	/* Failing here is non-fatal */
 	init_foreign(conf->multipath_dir, conf->enable_foreign);
 	if (cmd == CMD_USABLE_PATHS) {
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 9cdd05a3..6fb8645a 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -223,6 +223,12 @@ The verbosity level also controls the level of log and debug messages printed to
 Dry run, do not create or update devmaps.
 .
 .TP
+.B \-e
+Enable all foreign libraries. This overrides the
+.I enable_foreign 
+option from \fBmultipath.conf(5)\fR.
+.
+.TP
 .B \-i
 Ignore WWIDs file when processing devices. If
 \fIfind_multipaths strict\fR or \fIfind_multipaths no\fR is set in
-- 
2.26.2
