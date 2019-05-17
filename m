From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/4] multipathd: fix REALLOC_REPLY with max
	length reply
Date: Fri, 17 May 2019 11:14:09 -0500
Message-ID: <1558109650-21179-4-git-send-email-bmarzins@redhat.com>
References: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Commit cd5a9797e added code to REALLOC_REPLY() that intended to stop
growing the reply buffer after it reached a maximum size. However this
code didn't stop the realloc() from happening. Worse, if the realloc()
failed, multipathd would double free the reply buffer. Found by
Coverity.

Fixes: cd5a9797e "libmpathcmd(coverity): limit reply length"
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/multipathd/cli.h b/multipathd/cli.h
index f3fa077a..32dcffac 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -100,15 +100,16 @@ enum {
 			if (m >= MAX_REPLY_LEN) {		\
 				condlog(1, "Warning: max reply length exceeded"); \
 				free(tmp);			\
-				r = NULL;			\
+				(r) = NULL;			\
+			} else {				\
+				(r) = REALLOC((r), (m) * 2);	\
+				if ((r)) {			\
+					memset((r) + (m), 0, (m)); \
+					(m) *= 2;		\
+				}				\
+				else				\
+					free(tmp);		\
 			}					\
-			(r) = REALLOC((r), (m) * 2);		\
-			if ((r)) {				\
-				memset((r) + (m), 0, (m));	\
-				(m) *= 2;			\
-			}					\
-			else					\
-				free(tmp);			\
 		}						\
 	} while (0)
 
-- 
2.17.2
