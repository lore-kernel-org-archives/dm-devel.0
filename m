From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH] multipath-tools: fix incorrect length for
	strncmp in uevent.c
Date: Tue, 5 Sep 2017 11:54:42 +0800
Message-ID: <1504583682-14112-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: guanjunxiong@huawei.com, chengjike.cheng@huawei.com, mwilck@suse.com, shenhong09@huawei.com, niuhaoxin@huawei.com
List-Id: dm-devel.ids

Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/uevent.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index eb44da56..a98633e7 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -885,7 +885,7 @@ int uevent_get_disk_ro(struct uevent *uev)
 	int i, ro = -1;
 
 	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DISK_RO", 6) && strlen(uev->envp[i]) > 7) {
+		if (!strncmp(uev->envp[i], "DISK_RO", 7) && strlen(uev->envp[i]) > 8) {
 			p = uev->envp[i] + 8;
 			ro = strtoul(p, &q, 10);
 			if (p == q) {
@@ -904,8 +904,8 @@ char *uevent_get_dm_name(struct uevent *uev)
 	int i;
 
 	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DM_NAME", 6) &&
-		    strlen(uev->envp[i]) > 7) {
+		if (!strncmp(uev->envp[i], "DM_NAME", 7) &&
+		    strlen(uev->envp[i]) > 8) {
 			p = MALLOC(strlen(uev->envp[i] + 8) + 1);
 			strcpy(p, uev->envp[i] + 8);
 			break;
-- 
2.11.1
