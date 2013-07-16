From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/30] libmultipath: Implement PATH_TIMEOUT
Date: Tue, 16 Jul 2013 09:12:57 +0200
Message-ID: <1373958801-103613-7-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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

The tur checker might run into a timeout, eg when a command is
sent but the checker hasn't been able to receive a reply in time.
Use a specific 'PATH_TIMEOUT' state for these cases.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers.c     | 3 ++-
 libmultipath/checkers.h     | 5 +++++
 libmultipath/checkers/tur.c | 2 +-
 libmultipath/discovery.c    | 2 ++
 libmultipath/print.c        | 4 ++++
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 01dafdd..47f5c68 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -16,7 +16,8 @@ char *checker_state_names[] = {
       "up",
       "shaky",
       "ghost",
-      "pending"
+      "pending",
+      "timeout",
 };
 
 static LIST_HEAD(checkers);
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 5a96165..1b6c22d 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -46,6 +46,10 @@
  * PATH_PENDING:
  * - Use: All async checkers
  * - Description: Indicates a check IO is in flight.
+ *
+ * PATH_TIMEOUT:
+ * - Use: Only tur checker
+ * - Description: Command timed out
  */
 enum path_check_state {
 	PATH_WILD,
@@ -55,6 +59,7 @@ enum path_check_state {
 	PATH_SHAKY,
 	PATH_GHOST,
 	PATH_PENDING,
+	PATH_TIMEOUT,
 	PATH_MAX_STATE
 };
 
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 9c141aa..6f5d4d9 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -297,7 +297,7 @@ libcheck_check (struct checker * c)
 				pthread_cancel(ct->thread);
 				ct->running = 0;
 				MSG(c, MSG_TUR_TIMEOUT);
-				tur_status = PATH_DOWN;
+				tur_status = PATH_TIMEOUT;
 				ct->state = PATH_UNCHECKED;
 			} else {
 				condlog(3, "%d:%d: tur checker not finished",
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 04c6029..6af5083 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1065,6 +1065,8 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
 				goto blank;
+			if (pp->state == PATH_TIMEOUT)
+				pp->state = PATH_DOWN;
 		} else {
 			condlog(3, "%s: path inaccessible", pp->dev);
 			pp->chkrstate = pp->state = path_state;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 274f5e7..b6d08b7 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -335,6 +335,10 @@ snprint_chk_state (char * buff, size_t len, struct path * pp)
 		return snprintf(buff, len, "shaky");
 	case PATH_GHOST:
 		return snprintf(buff, len, "ghost");
+	case PATH_PENDING:
+		return snprintf(buff, len, "i/o pending");
+	case PATH_TIMEOUT:
+		return snprintf(buff, len, "i/o timeout");
 	default:
 		return snprintf(buff, len, "undef");
 	}
-- 
1.7.12.4
