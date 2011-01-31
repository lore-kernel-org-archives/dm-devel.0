From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] dm mpath: fail message ioctl if specified
	path is not valid
Date: Mon, 31 Jan 2011 11:14:17 -0500
Message-ID: <1296490458-12910-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The message ioctl would succeed for the 'reinistate_path' and
'fail_path' messages even if action was not taken because the
specified device was not a valid path of the multipath device.

before:
$ dmsetup message mpathb 0 reinstate_path /dev/vdb
$ echo $?
0

after:
$ dmsetup message mpathb 0 reinstate_path /dev/vdb
device-mapper: message ioctl failed: Invalid argument
Command failed
$ echo $?
1

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index b82d288..97842c6 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1065,7 +1065,7 @@ out:
 static int action_dev(struct multipath *m, struct dm_dev *dev,
 		      action_fn action)
 {
-	int r = 0;
+	int r = -EINVAL;
 	struct pgpath *pgpath;
 	struct priority_group *pg;
 
-- 
1.7.3.4
