From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 52/57] libmultipath: make 'dm_addmap' static
Date: Wed, 27 Apr 2016 13:10:53 +0200
Message-ID: <1461755458-29225-53-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

dm_addmap() is only used within devmapper.c, so it can be made
static.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index b10f9e6..4a87bf7 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -275,7 +275,7 @@ dm_device_remove (const char *name, int needsync, int deferred_remove) {
 			    deferred_remove, needsync ? &cookie : NULL);
 }
 
-extern int
+static int
 dm_addmap (int task, const char *target, struct multipath *mpp,
 	   char * params, int ro, uint32_t *cookie) {
 	int r = 0;
-- 
2.6.6
