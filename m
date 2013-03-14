From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] libmultipath: Implement PATH_TIMEOUT
Date: Thu, 14 Mar 2013 15:08:44 +0100
Message-ID: <1363270128-20900-3-git-send-email-hare@suse.de>
References: <1363270128-20900-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1363270128-20900-1-git-send-email-hare@suse.de>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The tur checker might run into a timeout, eg when a command is
sent but the checker hasn't been able to receive a reply in time.
Use a specific 'PATH_TIMEOUT' state for these cases.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers.h     |    5 +++++
 libmultipath/checkers/tur.c |    2 +-
 libmultipath/discovery.c    |    2 ++
 libmultipath/print.c        |    4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

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
index 050264e..58ce533 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1027,6 +1027,8 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
 				goto blank;
+			if (pp->state == PATH_TIMEOUT)
+				pp->state = PATH_DOWN;
 		} else {
 			condlog(3, "%s: path inaccessible", pp->dev);
 			pp->chkrstate = pp->state = path_state;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 0e2c680..f40a721 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -332,6 +332,10 @@ snprint_chk_state (char * buff, size_t len, struct path * pp)
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
1.7.10.4
