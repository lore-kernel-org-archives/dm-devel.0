From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/6] multipathd: set return code for multipathd
	commands
Date: Wed, 10 Oct 2018 13:01:11 -0500
Message-ID: <1539194473-6243-5-git-send-email-bmarzins@redhat.com>
References: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Failed multipathd commands should set the return code to 1.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c   |  8 ++++----
 multipathd/uxclnt.c | 13 ++++++++-----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d3f7719..2d45d98 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2966,9 +2966,9 @@ main (int argc, char *argv[])
 			if (verbosity)
 				conf->verbosity = verbosity;
 			uxsock_timeout = conf->uxsock_timeout;
-			uxclnt(optarg, uxsock_timeout + 100);
+			err = uxclnt(optarg, uxsock_timeout + 100);
 			free_config(conf);
-			exit(0);
+			return err;
 		case 'B':
 			bindings_read_only = 1;
 			break;
@@ -3005,9 +3005,9 @@ main (int argc, char *argv[])
 			optind++;
 		}
 		c += snprintf(c, s + CMDSIZE - c, "\n");
-		uxclnt(s, uxsock_timeout + 100);
+		err = uxclnt(s, uxsock_timeout + 100);
 		free_config(conf);
-		exit(0);
+		return err;
 	}
 
 	if (foreground) {
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 08db0e8..a76f8e2 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -103,14 +103,14 @@ static void process(int fd, unsigned int timeout)
 	}
 }
 
-static void process_req(int fd, char * inbuf, unsigned int timeout)
+static int process_req(int fd, char * inbuf, unsigned int timeout)
 {
 	char *reply;
 	int ret;
 
 	if (send_packet(fd, inbuf) != 0) {
 		printf("cannot send packet\n");
-		return;
+		return 1;
 	}
 	ret = recv_packet(fd, &reply, timeout);
 	if (ret < 0) {
@@ -118,9 +118,12 @@ static void process_req(int fd, char * inbuf, unsigned int timeout)
 			printf("timeout receiving packet\n");
 		else
 			printf("error %d receiving packet\n", ret);
+		return 1;
 	} else {
 		printf("%s", reply);
+		ret = (strcmp(reply, "fail\n") == 0);
 		FREE(reply);
+		return ret;
 	}
 }
 
@@ -129,16 +132,16 @@ static void process_req(int fd, char * inbuf, unsigned int timeout)
  */
 int uxclnt(char * inbuf, unsigned int timeout)
 {
-	int fd;
+	int fd, ret = 0;
 
 	fd = mpath_connect();
 	if (fd == -1)
 		exit(1);
 
 	if (inbuf)
-		process_req(fd, inbuf, timeout);
+		ret = process_req(fd, inbuf, timeout);
 	else
 		process(fd, timeout);
 	mpath_disconnect(fd);
-	return 0;
+	return ret;
 }
-- 
2.7.4
