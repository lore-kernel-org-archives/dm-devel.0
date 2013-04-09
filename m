From: Stratos Karafotis <stratosk@semaphore.gr>
Subject: [PATCH linux-next] dm-raid: Fix compiler warning
Date: Tue, 09 Apr 2013 23:16:03 +0300
Message-ID: <51647703.6060804@semaphore.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

=46ix the following compiler warning of uninitialized variable

drivers/md/dm-raid.c: In function =91raid_ctr=92:
drivers/md/dm-raid.c:427:160: warning: =91rebuilds_per_group=92 may be =
used
uninitialized in this function [-Wmaybe-uninitialized]
drivers/md/dm-raid.c:383:11: note: =91rebuilds_per_group=92 was declare=
d
here

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 1d3fe1a..8041de8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -380,7 +380,7 @@ static int validate_region_size(struct raid_set *rs=
, unsigned long region_size)
 static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned i, rebuild_cnt =3D 0;
-	unsigned rebuilds_per_group, copies, d;
+	unsigned copies, d, rebuilds_per_group =3D 0;
 	unsigned group_size, last_group_start;
=20
 	for (i =3D 0; i < rs->md.raid_disks; i++)
--=20
1.8.1.4
