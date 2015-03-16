From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/78] multipathd: cleanup foreground operation
Date: Mon, 16 Mar 2015 13:36:16 +0100
Message-ID: <1426509425-15978-30-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When specifying '-d' it actually does two things, namely do not
daemonize the program and prints logging messages to stdout
instead of syslog.
This partially clashes with '-s' which suppresses the timestamp
printing. So separate both use cases and ensure that '-d' doesn't
overwrite '-s' if specified later.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 494f4bb..ac1e1a2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1998,6 +1998,7 @@ main (int argc, char *argv[])
 	extern int optind;
 	int arg;
 	int err;
+	int foreground = 0;
 
 	logsink = 1;
 	running_state = DAEMON_INIT;
@@ -2022,7 +2023,9 @@ main (int argc, char *argv[])
 	while ((arg = getopt(argc, argv, ":dsv:k::B")) != EOF ) {
 	switch(arg) {
 		case 'd':
-			logsink = 0;
+			foreground = 1;
+			if (logsink > 0)
+				logsink = 0;
 			//debug=1; /* ### comment me out ### */
 			break;
 		case 'v':
@@ -2062,7 +2065,7 @@ main (int argc, char *argv[])
 		exit(0);
 	}
 
-	if (logsink < 1) {
+	if (foreground) {
 		if (!isatty(fileno(stdout)))
 			setbuf(stdout, NULL);
 		err = 0;
-- 
1.8.4.5
