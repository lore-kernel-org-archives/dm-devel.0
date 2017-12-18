From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] persistent-data: fix bug about btree of
 updating internal node's minima key in btree_split_beneath.
Date: Mon, 18 Dec 2017 17:34:09 +0000
Message-ID: <20171218173409.px65ncx2kp7d6p2v@reti>
References: <20171218212758.GA12360@yyp.>
	<20171218171307.obyq62v3jt4lgqwg@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171218171307.obyq62v3jt4lgqwg@reti>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: monty_pavel@sina.com, dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Mon, Dec 18, 2017 at 05:13:08PM +0000, Joe Thornber wrote:
> Hi Monty,
> 
> On Mon, Dec 18, 2017 at 04:27:58PM -0500, monty wrote:
> > Subject: [PATCH] persistent-data: fix bug about btree of updating internal node's minima
> >  key in btree_split_beneath.
> > 
> >  fix bug about btree_split_beneath func, this bug may cause a key had
> >  been inserted to btree, but dm_btree_lookup can not find the key in
> >  btree later.
> 
> I think you've spotted a real issue, but I don't like where you've
> fixed up the btree_split_beneath() function.  I'll post a patch in a
> bit.

Patch below.  This is completely untested.  I'll test tomorrow and update.

Instead of fiddling with the spine we unlock both the new children and
let the current spine entry (which now has just two entries) continue.
That way the bounds on the lowest key is adjusted within the main loop
of btree_insert_raw().

- Joe



diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 416060c2570..ee2c01685f5 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -572,23 +572,8 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
        pn->keys[1] = rn->keys[0];
	        memcpy_disk(value_ptr(pn, 1), &val, sizeof(__le64));

-       /*
-        * rejig the spine.  This is ugly, since it knows too
-        * much about the spine
-        */
-       if (s->nodes[0] != new_parent) {
-               unlock_block(s->info, s->nodes[0]);
-               s->nodes[0] = new_parent;
-       }
-       if (key < le64_to_cpu(rn->keys[0])) {
-               unlock_block(s->info, right);
-               s->nodes[1] = left;
-       } else {
-               unlock_block(s->info, left);
-               s->nodes[1] = right;
-       }
-       s->count = 2;
-
+       unlock_block(s->info, left);
+       unlock_block(s->info, right);
        return 0;
}
