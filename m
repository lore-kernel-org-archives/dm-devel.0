From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Need to use FREE macro instead of free.
Date: Tue, 16 Dec 2008 10:54:57 -0500
Message-ID: <1229442897-3765-6-git-send-email-konrad@virtualiron.com>
References: <1229442897-3765-1-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-2-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-3-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-4-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-5-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1229442897-3765-5-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

 When using the internal memory leak checker it is imperative that
 all free use the FREE macro. Otherwise accounting errors show up.

---
 libmultipath/devmapper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a021e44..bcbeb28 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -211,7 +211,7 @@ dm_addmap (int task, const char *name, const char *target,
 
 	freeout:
 	if (prefixed_uuid)
-		free(prefixed_uuid);
+		FREE(prefixed_uuid);
 
 	addout:
 	dm_task_destroy (dmt);
-- 
1.5.4.1
