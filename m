From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 09/15] multipathd: read-only bindings
Date: Sat,  7 Mar 2015 21:31:40 -0600
Message-ID: <1425785506-20419-10-git-send-email-bmarzins@redhat.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Multipath already uses -B to run in a mode where it won't write the the
bindings file (which can be useful in the initramfs). Its simple to make
multipathd able to work this way as well.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c       | 5 ++++-
 multipathd/multipathd.8 | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index bc21d04..7429f66 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1971,7 +1971,7 @@ main (int argc, char *argv[])
 	if (!conf)
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dsv:k::")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dsv:k::B")) != EOF ) {
 	switch(arg) {
 		case 'd':
 			logsink = 0;
@@ -1990,6 +1990,9 @@ main (int argc, char *argv[])
 		case 'k':
 			uxclnt(optarg);
 			exit(0);
+		case 'B':
+			conf->bindings_read_only = 1;
+			break;
 		default:
 			;
 		}
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 358141d..7fe6597 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -28,6 +28,11 @@ Suppress timestamps. Do not prefix logging messages with a timestamp.
 .B -v "level"
 Verbosity level. Print additional information while running multipathd. A  level of 0 means only print errors. A level of 3 or greater prints debugging information as well. 
 .TP
+.B -B
+Read-only bindings file. Multipathd will not write to the user_friendly_names
+bindings file. If a user_friendly_name doesn't already exist for a device, it
+will use its WWID as its alias.
+.TP
 .B -k 
 multipathd will enter interactive mode. From this mode, the available commands can be viewed by entering "help". When you are finished entering commands, press CTRL-D to quit.
 
-- 
1.8.3.1
