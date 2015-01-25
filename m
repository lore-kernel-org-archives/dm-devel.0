From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] md: fix raid5 livelock
Date: Sun, 25 Jan 2015 21:06:20 +0100
Message-ID: <54C54CBC.50101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de >> NeilBrown" <neilb@suse.de>
Cc: "dm-devel >> device-mapper development" <dm-devel@redhat.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Hi Neil,

the reconstruct write optimization in raid5, function fetch_block causes
livelocks in LVM raid4/5 tests.

Test scenarios:
the tests wait for full initial array resynchronization before making a 
filesystem
on the raid4/5 logical volume, mounting it, writing to the filesystem 
and failing
one physical volume holding a raiddev.

In short, we're seeing livelocks on fully synchronized raid4/5 arrays 
with a failed device.

This patch fixes the issue but likely in a suboptimnal way.

Do you think there is a better solution to avoid livelocks on 
reconstruct writes?

Regards,
Heinz

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Jon Brassow <jbrassow@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>

---
  drivers/md/raid5.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c1b0d52..0fc8737 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2915,7 +2915,7 @@ static int fetch_block(struct stripe_head *sh, 
struct stripe_head_state *s,
              (s->failed >= 1 && fdev[0]->toread) ||
              (s->failed >= 2 && fdev[1]->toread) ||
              (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
-             (!test_bit(R5_Insync, &dev->flags) || 
test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
+             (!test_bit(R5_Insync, &dev->flags) || 
test_bit(STRIPE_PREREAD_ACTIVE, &sh->state) || s->non_overwrite) &&
               !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
              ((sh->raid_conf->level == 6 ||
                sh->sector >= sh->raid_conf->mddev->recovery_cp)
-- 
2.1.0

