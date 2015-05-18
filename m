From: Dennis Yang <shinrairis@gmail.com>
Subject: Possible BUG in the entry removal process of dm-btree
	structure
Date: Mon, 18 May 2015 15:21:52 +0800
Message-ID: <CAKTMprNmf7KKAPMj0CFj32y+0OpYJPiqQTbiQiuUAiteJiQeEg@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

Recently, I had run into the same dm-btree-remove bug reported before
in this mailing list.
(https://www.redhat.com/archives/dm-devel/2013-February/msg00063.html)
I google this and it turns out there is someone else had faced the
same issue with CentOS couple of days ago.
(http://mogu.io/docker_crash).

Also, since we will run thin_check every couple of hours on our server
to check if the metadata is corrupted, we do occasionally find that
the key ordering of some btree nodes become unsorted by using the
thin_debug tool to examine them. Therefore, my colleague and I have
traced the dm-btree-remove.c and find something which might be the
root cause of these issues.

In dm-btree-remove.c, there is a redistribute3() function which is
called when we try to rebalance the entry of three nodes with their
total entry count is higher than a defined threshold. I paste the code
below for further discussion.

target = (nr_left + nr_center + nr_right) / 3;
if (nr_left < nr_right) {
    s = nr_left - target;

    if (s < 0 && nr_center < -s) {
        /* not enough in central node */
        shift(left, center, nr_center);
        s = nr_center - target;
        shift(left, right, s);
        nr_right += s;
    } else
        shift(left, center, s);

    shift(center, right, target - nr_right);
} else {

If the entry count of left node is smaller than target and the entry
count of center node is not enough to cover this gap, I think what we
try to do here is to move all the entries in the center node to the
left node first, then move some entries from the right node to the
left one to make its entry count equals to target. However, since
nr_center is always positive, the code above will first move up to
nr_center entries from the left node to the center node. This, in our
opinion, might trigger the BUG_ON in shift(), for we cannot sure left
node has nr_center nodes to be moved. At this point, the left node
will have (nr_left - nr_center) entries, and the center node will have
(2 * nr_center) entries. Then, it will try to move (target -
nr_center) entries from right to left. Since the center node still
have (2 * nr_center) entries, moving entries directly from right to
left will mess up the ordering of entries between left and center
node.

To fix this issue, I think we should stick with the plan that move all
the entries from center node to left/right node first, and then make
it up to target entries by moving them from right/left node to it. I
have attached a simple patch to demonstrate the idea here.

Any help would be grateful.
Thanks.

Dennis

diff --git a/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
b/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
index b88757c..9026fb8 100644
--- a/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
+++ b/linux-3.12.6/drivers/md/persistent-data/dm-btree-remove.c
@@ -309,8 +309,9 @@ static void redistribute3(struct dm_btree_info
*info, struct btree_node *parent,

          if (s < 0 && nr_center < -s) {
          /* not enough in central node */
-             shift(left, center, nr_center);
-             s = nr_center - target;
+            shift(center, left, nr_center);
+            s += nr_center;
              shift(left, right, s);
              nr_right += s;
         } else
@@ -323,7 +324,7 @@ static void redistribute3(struct dm_btree_info
*info, struct btree_node *parent,
        if (s > 0 && nr_center < s) {
        /* not enough in central node */
            shift(center, right, nr_center);
-           s = target - nr_center;
+          s -= nr_center;
            shift(left, right, s);
            nr_left -= s;
       } else
