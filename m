From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 3/7] libmultipath: make dm_flush_maps only
	return 0 on success
Date: Thu,  2 Jul 2020 19:07:02 -0500
Message-ID: <1593734826-14059-4-git-send-email-bmarzins@redhat.com>
References: <1593734826-14059-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593734826-14059-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

dm_flush_maps() returned both 0 and 1 on error, depending on which part
of the function it was in, but the caller was always treating 0 as a
success. Make dm_flush_maps() always return 1 on error and 0 on success.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 24cc616a..4c86b6d4 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1007,13 +1007,13 @@ dm_flush_map_nopaths(const char * mapname, int deferred_remove)
 
 int dm_flush_maps (int retries)
 {
-	int r = 0;
+	int r = 1;
 	struct dm_task *dmt;
 	struct dm_names *names;
 	unsigned next = 0;
 
 	if (!(dmt = libmp_dm_task_create (DM_DEVICE_LIST)))
-		return 0;
+		return r;
 
 	dm_task_no_open_count(dmt);
 
@@ -1026,6 +1026,7 @@ int dm_flush_maps (int retries)
 	if (!names->dev)
 		goto out;
 
+	r = 0;
 	do {
 		r |= dm_suspend_and_flush_map(names->name, retries);
 		next = names->next;
-- 
2.17.2
