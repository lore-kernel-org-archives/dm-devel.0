From: Joe Thornber <thornber@redhat.com>
Subject: Re: Possible BUG in the entry removal process of
 dm-btree structure
Date: Mon, 18 May 2015 13:51:53 +0100
Message-ID: <20150518125152.GA10459@rh-vpn>
References: <CAKTMprNmf7KKAPMj0CFj32y+0OpYJPiqQTbiQiuUAiteJiQeEg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKTMprNmf7KKAPMj0CFj32y+0OpYJPiqQTbiQiuUAiteJiQeEg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, May 18, 2015 at 03:21:52PM +0800, Dennis Yang wrote:
> Hi,
> 
> Recently, I had run into the same dm-btree-remove bug reported before
> in this mailing list.

Hi Dennis,

You diagnosis looks correct, though I think your patch introduces
entry reordering.

> In dm-btree-remove.c, there is a redistribute3() function which is
> called when we try to rebalance the entry of three nodes with their
> total entry count is higher than a defined threshold. I paste the code
> below for further discussion.
> 
> target = (nr_left + nr_center + nr_right) / 3;
> if (nr_left < nr_right) {
>     s = nr_left - target;
> 
>     if (s < 0 && nr_center < -s) {
>         /* not enough in central node */
>         shift(left, center, nr_center);
>         s = nr_center - target;
>         shift(left, right, s);
>         nr_right += s;
>     } else
>         shift(left, center, s);
> 
>     shift(center, right, target - nr_right);
> } else {
> 
> If the entry count of left node is smaller than target and the entry
> count of center node is not enough to cover this gap, I think what we
> try to do here is to move all the entries in the center node to the
> left node first, then move some entries from the right node to the
> left one to make its entry count equals to target. However, since
> nr_center is always positive, the code above will first move up to
> nr_center entries from the left node to the center node.

Yep, this is a bug, it should be -nr_center.

> To fix this issue, I think we should stick with the plan that move all
> the entries from center node to left/right node first, and then make
> it up to target entries by moving them from right/left node to it. I
> have attached a simple patch to demonstrate the idea here.
> 
> diff --git a/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
> b/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
> index b88757c..9026fb8 100644
> --- a/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
> +++ b/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
> @@ -309,8 +309,9 @@ static void redistribute3(struct dm_btree_info
> *info, struct btree_node *parent,
> 
>           if (s < 0 && nr_center < -s) {
>           /* not enough in central node */
> -             shift(left, center, nr_center);
> -             s = nr_center - target;
> +            shift(center, left, nr_center);

You can't put the nodes out of order, what you actually want to do is:
shift(left, center, -nr_center).  Other than that your patch looks
good.  Updated patch below.

Thanks,

- Joe


diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index e04cfd2..9836c0a 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -309,8 +309,8 @@ static void redistribute3(struct dm_btree_info *info, struct btree_node *parent,
 
                if (s < 0 && nr_center < -s) {
                        /* not enough in central node */
-                       shift(left, center, nr_center);
-                       s = nr_center - target;
+                       shift(left, center, -nr_center);
+                       s += nr_center;
                        shift(left, right, s);
                        nr_right += s;
                } else
@@ -323,7 +323,7 @@ static void redistribute3(struct dm_btree_info *info, struct btree_node *parent,
                if (s > 0 && nr_center < s) {
                        /* not enough in central node */
                        shift(center, right, nr_center);
-                       s = target - nr_center;
+                       s -= nr_center;
                        shift(left, right, s);
                        nr_left -= s;
                } else
