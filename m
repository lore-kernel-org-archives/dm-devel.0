From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/42] libmultipath: Invalid check for mpp->wwid
	in dm_addmap()
Date: Tue,  8 Jan 2013 14:53:39 +0100
Message-ID: <1357653259-62650-2-git-send-email-hare@suse.de>
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

mpp->wwid is an array, and so a check against NULL
is wrong; we need to use strlen here.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index de7d446..5132399 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -281,7 +281,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 	if (ro)
 		dm_task_set_ro(dmt);
 
-	if (use_uuid && mpp->wwid){
+	if (use_uuid && strlen(mpp->wwid) > 0){
 		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(mpp->wwid) + 1);
 		if (!prefixed_uuid) {
 			condlog(0, "cannot create prefixed uuid : %s\n",
-- 
1.7.4.2
