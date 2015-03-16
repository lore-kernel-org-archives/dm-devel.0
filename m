From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 47/78] Do not print empty multipaths section
Date: Mon, 16 Mar 2015 13:36:34 +0100
Message-ID: <1426509425-15978-48-git-send-email-hare@suse.de>
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

The CLI command 'show config' or the 'multipath -t' command
should not print an empty 'multipaths' section.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/main.c          | 11 +++++++----
 multipathd/cli_handlers.c |  9 ++++++---
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index c46a9f6..ebca4dc 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -436,10 +436,13 @@ dump_config (void)
 			reply = REALLOC(reply, maxlen *= 2);
 			continue;
 		}
-		c += snprint_mptable(c, reply + maxlen - c, conf->mptable);
-		again = ((c - reply) == maxlen);
-		if (again)
-			reply = REALLOC(reply, maxlen *= 2);
+		if (VECTOR_SIZE(conf->mptable) > 0) {
+			c += snprint_mptable(c, reply + maxlen - c,
+					     conf->mptable);
+			again = ((c - reply) == maxlen);
+			if (again)
+				reply = REALLOC(reply, maxlen *= 2);
+		}
 	}
 
 	printf("%s", reply);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 772531e..dc96c45 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -229,9 +229,12 @@ show_config (char ** r, int * len)
 			maxlen *= 2;
 			continue;
 		}
-		c += snprint_mptable(c, reply + maxlen - c, conf->mptable);
-		again = ((c - reply) == maxlen);
-		REALLOC_REPLY(reply, again, maxlen);
+		if (VECTOR_SIZE(conf->mptable) > 0) {
+			c += snprint_mptable(c, reply + maxlen - c,
+					     conf->mptable);
+			again = ((c - reply) == maxlen);
+			REALLOC_REPLY(reply, again, maxlen);
+		}
 	}
 	*r = reply;
 	*len = (int)(c - reply + 1);
-- 
1.8.4.5
