From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 4/6] dm-linear: Improve error message consistency
Date: Wed, 28 Oct 2015 04:38:58 +0900
Message-ID: <1445974740-8362-4-git-send-email-kusumi.tomohiro@gmail.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, mpatocka@redhat.com
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

72d94861 back in 2006 should have removed "dm-linear: "
from these three as well.

  # grep "ti->error =" drivers/md -rIh | grep "dm-"
		ti->error = "Cannot initialize dm-bufio";
		ti->error = "dm-linear: Cannot allocate linear context";
		ti->error = "dm-linear: Invalid device sector";
		ti->error = "dm-linear: Device lookup failed";
  # grep "Cannot allocate .* context\"" drivers/md -rI
  drivers/md/dm-raid1.c:		ti->error = "Cannot allocate mirror context";
  drivers/md/dm-crypt.c:		ti->error = "Cannot allocate encryption context";
  drivers/md/dm-raid.c:		ti->error = "Cannot allocate raid context";
  drivers/md/dm-linear.c:		ti->error = "dm-linear: Cannot allocate linear context";
  drivers/md/dm-switch.c:		ti->error = "Cannot allocate redirection context";
  # grep "Invalid device sector\"" drivers/md -rI
  drivers/md/dm-delay.c:		ti->error = "Invalid device sector";
  drivers/md/dm-crypt.c:		ti->error = "Invalid device sector";
  drivers/md/dm-flakey.c:		ti->error = "Invalid device sector";
  drivers/md/dm-linear.c:		ti->error = "dm-linear: Invalid device sector";
  # grep "Device lookup failed\"" drivers/md -rI
  drivers/md/dm-log-writes.c:		ti->error = "Device lookup failed";
  drivers/md/dm-delay.c:		ti->error = "Device lookup failed";
  drivers/md/dm-crypt.c:		ti->error = "Device lookup failed";
  drivers/md/dm-flakey.c:		ti->error = "Device lookup failed";
  drivers/md/dm-linear.c:		ti->error = "dm-linear: Device lookup failed";
  drivers/md/dm-switch.c:		ti->error = "Device lookup failed";

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 drivers/md/dm-linear.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 436f5c9..60baa12 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -39,20 +39,20 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
 	if (lc == NULL) {
-		ti->error = "dm-linear: Cannot allocate linear context";
+		ti->error = "Cannot allocate linear context";
 		return -ENOMEM;
 	}
 
 	ret = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1) {
-		ti->error = "dm-linear: Invalid device sector";
+		ti->error = "Invalid device sector";
 		goto bad;
 	}
 	lc->start = tmp;
 
 	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
 	if (ret) {
-		ti->error = "dm-linear: Device lookup failed";
+		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
-- 
1.7.1
