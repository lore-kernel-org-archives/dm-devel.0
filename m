From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/21] kpartx: fix crash during boot
Date: Mon, 21 May 2007 11:23:05 +0200
Message-ID: <20070521092305.D7A79D44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


kpartx will crash during boot as device-mapper insists on freeing
all passed memory upon exit. So we don't have to do it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/devmapper.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 5b27487..4b228ed 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -95,19 +95,16 @@ dm_addmap (int task, const char *name, c
 		}
 		sprintf(prefixed_uuid, UUID_PREFIX "%s", part, uuid);
 		if (!dm_task_set_uuid(dmt, prefixed_uuid))
-			goto freeout;
+			goto addout;
 	}
 
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
 
-	freeout:
-	if (prefixed_uuid)
-		free(prefixed_uuid);
-
 	addout:
 	dm_task_destroy (dmt);
+
 	return r;
 }
 
-- 
1.4.3.4
