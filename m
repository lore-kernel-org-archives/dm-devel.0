From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/42] libmultipath: resource leak in
	read_value_block()
Date: Tue,  8 Jan 2013 14:53:42 +0100
Message-ID: <1357653259-62650-5-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

read_value_block() allocates the vector 'elements', but
doesn't free it on error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/parser.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 79c2d22..526c45b 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -311,8 +311,10 @@ read_value_block(void)
 
 	buf = (char *) MALLOC(MAXBUF);
 
-	if (!buf)
+	if (!buf) {
+		vector_free(elements);
 		return NULL;
+	}
 
 	while (read_line(buf, MAXBUF)) {
 		vec = alloc_strvec(buf);
@@ -323,21 +325,20 @@ read_value_block(void)
 				break;
 			}
 
-			if (VECTOR_SIZE(vec))
-				for (i = 0; i < VECTOR_SIZE(vec); i++) {
-					str = VECTOR_SLOT(vec, i);
-					dup = (char *) MALLOC(strlen(str) + 1);
-					if (!dup)
-						goto out;
-					memcpy(dup, str, strlen(str));
-
-					if (!vector_alloc_slot(elements)) {
-						free_strvec(vec);
-						goto out1;
-					}
+			for (i = 0; i < VECTOR_SIZE(vec); i++) {
+				str = VECTOR_SLOT(vec, i);
+				dup = (char *) MALLOC(strlen(str) + 1);
+				if (!dup)
+					goto out;
+				memcpy(dup, str, strlen(str));
 
-					vector_set_slot(elements, dup);
+				if (!vector_alloc_slot(elements)) {
+					free_strvec(vec);
+					goto out1;
 				}
+
+				vector_set_slot(elements, dup);
+			}
 			free_strvec(vec);
 		}
 		memset(buf, 0, MAXBUF);
@@ -348,6 +349,7 @@ out1:
 	FREE(dup);
 out:
 	FREE(buf);
+	vector_free(elements);
 	return NULL;
 }
 
-- 
1.7.4.2
