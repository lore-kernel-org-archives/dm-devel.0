From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 7/7] multipath: add option to skip multipathd
	delegation
Date: Thu, 25 Jun 2020 15:42:21 -0500
Message-ID: <1593117741-28750-8-git-send-email-bmarzins@redhat.com>
References: <1593117741-28750-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593117741-28750-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Add the -D option to allow users to skip delegating commands to
multipathd.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h | 1 +
 multipath/main.c      | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 55569360..92c61a0d 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -190,6 +190,7 @@ struct config {
 	int ghost_delay;
 	int find_multipaths_timeout;
 	int marginal_pathgroups;
+	int skip_delegate;
 	unsigned int version[3];
 	unsigned int sequence_nr;
 
diff --git a/multipath/main.c b/multipath/main.c
index 6a24e483..4c43314e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -817,6 +817,9 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 	*p = '\0';
 	n = sizeof(command);
 
+	if (conf->skip_delegate)
+		return NOT_DELEGATED;
+
 	if (cmd == CMD_CREATE && conf->force_reload == FORCE_RELOAD_YES) {
 		p += snprintf(p, n, "reconfigure");
 	}
@@ -890,7 +893,7 @@ main (int argc, char *argv[])
 	multipath_conf = conf;
 	conf->retrigger_tries = 0;
 	conf->force_sync = 1;
-	while ((arg = getopt(argc, argv, ":adcChl::eFfM:v:p:b:BrR:itTquUwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adDcChl::eFfM:v:p:b:BrR:itTquUwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -922,6 +925,9 @@ main (int argc, char *argv[])
 			if (cmd == CMD_CREATE)
 				cmd = CMD_DRY_RUN;
 			break;
+		case 'D':
+			conf->skip_delegate = 1;
+			break;
 		case 'f':
 			cmd = CMD_FLUSH_ONE;
 			break;
-- 
2.17.2
