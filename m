From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/78] Allow for empty path argument when
	printing information
Date: Mon, 16 Mar 2015 13:36:04 +0100
Message-ID: <1426509425-15978-18-git-send-email-hare@suse.de>
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

When calling the various print functions we should be
allowing for empty path argument.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/print.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 130a9af..39b4f98 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -287,7 +287,7 @@ snprint_path_uuid (char * buff, size_t len, struct path * pp)
 static int
 snprint_hcil (char * buff, size_t len, struct path * pp)
 {
-	if (pp->sg_id.host_no < 0)
+	if (!pp || pp->sg_id.host_no < 0)
 		return snprintf(buff, len, "#:#:#:#");
 
 	return snprintf(buff, len, "%i:%i:%i:%i",
@@ -300,7 +300,7 @@ snprint_hcil (char * buff, size_t len, struct path * pp)
 static int
 snprint_dev (char * buff, size_t len, struct path * pp)
 {
-	if (!strlen(pp->dev))
+	if (!pp || !strlen(pp->dev))
 		return snprintf(buff, len, "-");
 	else
 		return snprint_str(buff, len, pp->dev);
@@ -309,7 +309,7 @@ snprint_dev (char * buff, size_t len, struct path * pp)
 static int
 snprint_dev_t (char * buff, size_t len, struct path * pp)
 {
-	if (!strlen(pp->dev))
+	if (!pp || !strlen(pp->dev))
 		return snprintf(buff, len, "#:#");
 	else
 		return snprint_str(buff, len, pp->dev_t);
@@ -318,8 +318,12 @@ snprint_dev_t (char * buff, size_t len, struct path * pp)
 static int
 snprint_offline (char * buff, size_t len, struct path * pp)
 {
-	if (pp->offline)
+	if (!pp)
+		return snprintf(buff, len, "unknown");
+	else if (pp->offline)
 		return snprintf(buff, len, "offline");
+	else if (!pp->mpp)
+		return snprintf(buff, len, "orphan");
 	else
 		return snprintf(buff, len, "running");
 }
@@ -327,6 +331,9 @@ snprint_offline (char * buff, size_t len, struct path * pp)
 static int
 snprint_chk_state (char * buff, size_t len, struct path * pp)
 {
+	if (!pp)
+		return snprintf(buff, len, "undef");
+
 	switch (pp->state) {
 	case PATH_UP:
 		return snprintf(buff, len, "ready");
@@ -350,6 +357,9 @@ snprint_chk_state (char * buff, size_t len, struct path * pp)
 static int
 snprint_dm_path_state (char * buff, size_t len, struct path * pp)
 {
+	if (!pp)
+		return snprintf(buff, len, "undef");
+
 	switch (pp->dmstate) {
 	case PSTATE_ACTIVE:
 		return snprintf(buff, len, "active");
@@ -370,7 +380,7 @@ snprint_vpr (char * buff, size_t len, struct path * pp)
 static int
 snprint_next_check (char * buff, size_t len, struct path * pp)
 {
-	if (!pp->mpp)
+	if (!pp || !pp->mpp)
 		return snprintf(buff, len, "orphan");
 
 	return snprint_progress(buff, len, pp->tick, pp->checkint);
@@ -379,7 +389,7 @@ snprint_next_check (char * buff, size_t len, struct path * pp)
 static int
 snprint_pri (char * buff, size_t len, struct path * pp)
 {
-	return snprint_int(buff, len, pp->priority);
+	return snprint_int(buff, len, pp ? pp->priority : -1);
 }
 
 static int
-- 
1.8.4.5
