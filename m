From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH linux-next v2] DM RAID: validate_raid_redundancy: Silence uninitialized variable warning
Date: Thu, 21 Feb 2013 07:50:26 -0700
Message-ID: <1361458226-8142-1-git-send-email-tim.gardner@canonical.com>
References: <20130221131931.GA29577@agk-dp.fab.redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130221131931.GA29577@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

drivers/md/dm-raid.c:453:53: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]
drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared here

It is impossible that rebuilds_per_group could be used before set, but set
it to 0 anyways to silence GCC warnings.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

v2 - Added GCC comment. Update commit log with a more definite explanation.

As Neil has pointed out, https://lwn.net/Articles/529954/ indicates
uninitialized_var() is going away.

 drivers/md/dm-raid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9d6bf19..1dbc341 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -380,7 +380,8 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned i, rebuild_cnt = 0;
-	unsigned rebuilds_per_group, copies, d;
+	unsigned rebuilds_per_group = 0; /* GCC 4.6.3 */
+	unsigned copies, d;
 	unsigned group_size, last_group_start;
 
 	for (i = 0; i < rs->md.raid_disks; i++)
-- 
1.7.9.5
