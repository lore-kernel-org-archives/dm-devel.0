From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 47/57] libmultipath: sanity check on store_path()
Date: Wed, 27 Apr 2016 13:10:48 +0200
Message-ID: <1461755458-29225-48-git-send-email-hare@suse.de>
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

If a path has neither pp->dev nor pp->dev_t set we cannot
identify the path at all.
So reject any path where this is not the case.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 39b2e05..937e4a2 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -283,6 +283,20 @@ free_multipathvec (vector mpvec, enum free_path_mode free_paths)
 int
 store_path (vector pathvec, struct path * pp)
 {
+	int err = 0;
+
+	if (!strlen(pp->dev_t)) {
+		condlog(2, "%s: Empty device number", pp->dev);
+		err++;
+	}
+	if (!strlen(pp->dev)) {
+		condlog(2, "%s: Empty device name", pp->dev_t);
+		err++;
+	}
+
+	if (err > 1)
+		return 1;
+
 	if (!vector_alloc_slot(pathvec))
 		return 1;
 
-- 
2.6.6
