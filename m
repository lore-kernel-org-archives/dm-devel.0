From: Joe Thornber <thornber@redhat.com>
Subject: Re: kernel BUG at
 drivers/md/persistent-data/dm-btree-remove.c:182!
Date: Wed, 21 Oct 2015 18:49:40 +0100
Message-ID: <20151021174939.GA3144@rh-vpn>
References: <5624B4B8.1030404@siteground.com> <5624B505.6000406@siteground.com>
	<20151019103057.GA14688@rh-vpn> <5624C9CB.7000702@siteground.com>
	<20151019160230.GA23826@redhat.com>
	<CAKTMprPVpRH6jktgPQ=f9Ak3XO8wg50oNqr8o-1UXTd=_9u0SA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKTMprPVpRH6jktgPQ=f9Ak3XO8wg50oNqr8o-1UXTd=_9u0SA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <shinrairis@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Nikolay Borisov <n.borisov@siteground.com>, SiteGround Operations <operations@siteground.com>
List-Id: dm-devel.ids

On Tue, Oct 20, 2015 at 10:39:31AM +0800, Dennis Yang wrote:
> Hi,
> 
> After I analyzed the metadata of this case couple months ago, I find
> out that there is another possible bug which might trigger this
> assertion fail in shift(). I had posted a patch two months ago on the
> list to explain and fix this issue. Could you help reviewing this?
> 
> https://www.redhat.com/archives/dm-devel/2015-August/msg00155.html

Yep, that's a bug.  Sorry I missed it before when you posted.  Here's
my fix:

commit 05ce4edf20c7e4a0d7a3c8d87a3d4b6744d0fea2
Author: Joe Thornber <ejt@redhat.com>
Date:   Wed Oct 21 18:36:49 2015 +0100

    [dm-btree] Fix bug when rebalancing nodes after removal
    
    The redistribute3 function takes 3 btree nodes and shares out the entries
    evenly between them.  If the three nodes in total contained
    (MAX_ENTRIES * 3) - 1 entries between them then this was erroneously getting
    rebalanced as (MAX_ENTRIES - 1) on the left and right, and (MAX_ENTRIES + 1) in
    the center.
    
    This patch is more careful about calculating the target nr entries for the left
    and right nodes.
    
    Unit tested in userspace using this program:
    
    https://github.com/jthornber/redistribute3-test/blob/master/redistribute3_t.c

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 4222f77..1dac15d 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -301,11 +301,16 @@ static void redistribute3(struct dm_btree_info *info, struct btree_node *parent,
 {
        int s;
        uint32_t max_entries = le32_to_cpu(left->header.max_entries);
-       unsigned target = (nr_left + nr_center + nr_right) / 3;
-       BUG_ON(target > max_entries);
+       unsigned total = nr_left + nr_center + nr_right;
+       unsigned target_right = total / 3;
+       unsigned remainder = (target_right * 3) != total;
+       unsigned target_left = target_right + remainder;
+
+       BUG_ON(target_left > max_entries);
+       BUG_ON(target_right > max_entries);
 
        if (nr_left < nr_right) {
-               s = nr_left - target;
+               s = nr_left - target_left;
 
                if (s < 0 && nr_center < -s) {
                        /* not enough in central node */
@@ -316,10 +321,10 @@ static void redistribute3(struct dm_btree_info *info, struct btree_node *parent,
                } else
                        shift(left, center, s);
 
-               shift(center, right, target - nr_right);
+               shift(center, right, target_right - nr_right);
 
        } else {
-               s = target - nr_right;
+               s = target_right - nr_right;
                if (s > 0 && nr_center < s) {
                        /* not enough in central node */
                        shift(center, right, nr_center);
@@ -329,7 +334,7 @@ static void redistribute3(struct dm_btree_info *info, struct btree_node *parent,
                } else
                        shift(center, right, s);
 
-               shift(left, center, nr_left - target);
+               shift(left, center, nr_left - target_left);
        }
 
        *key_ptr(parent, c->index) = center->keys[0];
