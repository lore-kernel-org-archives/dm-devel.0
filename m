From: Guangyu Sun <guangyu.sun@oracle.com>
Subject: [PATCH] libmultipath: fix flush_on_last_del config
	handlers
Date: Fri, 21 Dec 2012 11:11:30 -0800
Message-ID: <50D4B462.4020708@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
List-Id: dm-devel.ids

From: Guangyu Sun <guangyu.sun@oracle.com>

Now flush_on_last_del cannot be set to FLUSH_DISABLED if its default
value is FLUSH_ENABLED. This patch fixes the issue.

Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
  libmultipath/dict.c |    6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e0535a6..ebc49a3 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -508,7 +508,7 @@ def_flush_on_last_del_handler(vector strvec)
  	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
  	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
  		conf->flush_on_last_del = FLUSH_DISABLED;
-	if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
  	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
  		conf->flush_on_last_del = FLUSH_ENABLED;
  	else
@@ -1214,7 +1214,7 @@ hw_flush_on_last_del_handler(vector strvec)
  	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
  	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
  		hwe->flush_on_last_del = FLUSH_DISABLED;
-	if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
  	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
  		hwe->flush_on_last_del = FLUSH_ENABLED;
  	else
@@ -1609,7 +1609,7 @@ mp_flush_on_last_del_handler(vector strvec)
  	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
  	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
  		mpe->flush_on_last_del = FLUSH_DISABLED;
-	if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+	else if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
  	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
  		mpe->flush_on_last_del = FLUSH_ENABLED;
  	else
-- 1.7.9.5
