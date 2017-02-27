From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 2/6] libmultipath: cleanup orphan device states
Date: Mon, 27 Feb 2017 12:26:39 -0600
Message-ID: <1488220003-20541-3-git-send-email-bmarzins@redhat.com>
References: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
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

After a path device is orphaned, multipathd stops checking its state.
However, multipathd show state still shows its old state. It should
display "undef unknown" instead.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 5b03383..00a3626 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -392,7 +392,7 @@ snprint_dev_t (char * buff, size_t len, struct path * pp)
 static int
 snprint_offline (char * buff, size_t len, struct path * pp)
 {
-	if (!pp)
+	if (!pp || !pp->mpp)
 		return snprintf(buff, len, "unknown");
 	else if (pp->offline)
 		return snprintf(buff, len, "offline");
@@ -403,7 +403,7 @@ snprint_offline (char * buff, size_t len, struct path * pp)
 static int
 snprint_chk_state (char * buff, size_t len, struct path * pp)
 {
-	if (!pp)
+	if (!pp || !pp->mpp)
 		return snprintf(buff, len, "undef");
 
 	switch (pp->state) {
-- 
1.8.3.1
