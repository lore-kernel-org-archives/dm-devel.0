From: jbrassow@redhat.com
Subject: [PATCH] DM RAID: Fix off-by-one comparison.
Date: Mon,  8 Aug 2011 14:29:17 -0500
Message-ID: <1312831757-12685-1-git-send-email-jbrassow@redhat.com>
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
List-Id: dm-devel.ids

Fix off-by-one comparison.

The user-supplied value given for the 'write_mostly' argument must be an
index starting at 0.  The validation of the supplied argument failed to
check for 'N' ('>' vs '>='), which would have caused an access beyond the
end of the array.

Reported-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>


Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -449,7 +449,7 @@ static int parse_raid_params(struct raid
 				rs->ti->error = "write_mostly option is only valid for RAID1";
 				return -EINVAL;
 			}
-			if (value > rs->md.raid_disks) {
+			if (value >= rs->md.raid_disks) {
 				rs->ti->error = "Invalid write_mostly drive index given";
 				return -EINVAL;
 			}
