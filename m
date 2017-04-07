From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/9] multipathd: don't call strlen on NULL
	variables
Date: Fri,  7 Apr 2017 01:16:33 -0500
Message-ID: <1491545798-22183-5-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

strlen has undefined results when passed a NULL variable, so don't do
it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 283d81d..f671d58 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1076,7 +1076,8 @@ uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
 	    (strncmp(str, "list", strlen("list")) != 0) &&
 	    (strncmp(str, "show", strlen("show")) != 0)) {
 		*reply = STRDUP("permission deny: need to be root");
-		*len = strlen(*reply) + 1;
+		if (*reply)
+			*len = strlen(*reply) + 1;
 		return 1;
 	}
 
@@ -1087,12 +1088,14 @@ uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
 			*reply = STRDUP("timeout\n");
 		else
 			*reply = STRDUP("fail\n");
-		*len = strlen(*reply) + 1;
+		if (*reply)
+			*len = strlen(*reply) + 1;
 		r = 1;
 	}
 	else if (!r && *len == 0) {
 		*reply = STRDUP("ok\n");
-		*len = strlen(*reply) + 1;
+		if (*reply)
+			*len = strlen(*reply) + 1;
 		r = 0;
 	}
 	/* else if (r < 0) leave *reply alone */
-- 
1.8.3.1
