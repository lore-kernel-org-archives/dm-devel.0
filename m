From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] Allow zero paths for multipath priority groups
Date: Wed, 8 Jul 2009 14:15:39 +0530
Message-ID: <200907081415.39925.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>
Subject: Allow zero paths for multipath priority groups

For correct handling of the all-paths-down scenario we have to
allow zero paths as a valid argument for priority groups.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nikanth Karthikesan <hare@suse.de>

---
 drivers/md/dm-mpath.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-dm/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6-dm.orig/drivers/md/dm-mpath.c
+++ linux-2.6-dm/drivers/md/dm-mpath.c
@@ -787,8 +787,8 @@ static int multipath_ctr(struct dm_targe
 {
 	/* target parameters */
 	static struct param _params[] = {
-		{1, 1024, "invalid number of priority groups"},
-		{1, 1024, "invalid initial priority group number"},
+		{0, 1024, "invalid number of priority groups"},
+		{0, 1024, "invalid initial priority group number"},
 	};
 
 	int r;
