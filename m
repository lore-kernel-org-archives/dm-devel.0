From: Gris Ge <fge@redhat.com>
Subject: [PATCH] multipath-tools: multipathd: Fix memory leak on
	load_config().
Date: Sun, 22 Jan 2017 15:14:55 +0800
Message-ID: <1485069295-17766-1-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

 * Just free_config() before exit.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 multipathd/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1e64afc..2f5042e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2633,6 +2633,7 @@ main (int argc, char *argv[])
 				conf->verbosity = verbosity;
 			uxsock_timeout = conf->uxsock_timeout;
 			uxclnt(optarg, uxsock_timeout + 100);
+			free_config(conf);
 			exit(0);
 		case 'B':
 			bindings_read_only = 1;
@@ -2667,6 +2668,7 @@ main (int argc, char *argv[])
 		}
 		c += snprintf(c, s + CMDSIZE - c, "\n");
 		uxclnt(s, uxsock_timeout + 100);
+		free_config(conf);
 		exit(0);
 	}
 
-- 
1.8.3.1
