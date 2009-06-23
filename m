From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair
	queuing code in elevaotor layer
Date: Mon, 22 Jun 2009 22:43:37 -0400
Message-ID: <20090623024337.GC3620@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-3-git-send-email-vgoyal@redhat.com>
	<20090622084612.GD3728@balbir.in.ibm.com>
	<20090622124313.GF28770@gandalf.sssup.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090622124313.GF28770@gandalf.sssup.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Fabio Checconi <fchecconi@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, Balbir Singh <balbir@linux.vnet.ibm.com>, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 22, 2009 at 02:43:13PM +0200, Fabio Checconi wrote:

[..]
> > > +/**
> > > + * bfq_first_active - find the eligible entity with the smallest finish time
> > > + * @st: the service tree to select from.
> > > + *
> > > + * This function searches the first schedulable entity, starting from the
> > > + * root of the tree and going on the left every time on this side there is
> > > + * a subtree with at least one eligible (start <= vtime) entity.  The path
> > > + * on the right is followed only if a) the left subtree contains no eligible
> > > + * entities and b) no eligible entity has been found yet.
> > > + */
> > > +static struct io_entity *bfq_first_active_entity(struct io_service_tree *st)
> > > +{
> > > +	struct io_entity *entry, *first = NULL;
> > > +	struct rb_node *node = st->active.rb_node;
> > > +
> > > +	while (node != NULL) {
> > > +		entry = rb_entry(node, struct io_entity, rb_node);
> > > +left:
> > > +		if (!bfq_gt(entry->start, st->vtime))
> > > +			first = entry;
> > > +
> > > +		BUG_ON(bfq_gt(entry->min_start, st->vtime));
> > > +
> > > +		if (node->rb_left != NULL) {
> > > +			entry = rb_entry(node->rb_left,
> > > +					 struct io_entity, rb_node);
> > > +			if (!bfq_gt(entry->min_start, st->vtime)) {
> > > +				node = node->rb_left;
> > > +				goto left;
> > > +			}
> > > +		}
> > > +		if (first != NULL)
> > > +			break;
> > > +		node = node->rb_right;
> > 
> > Please help me understand this, we sort the tree by finish time, but
> > search by vtime, start_time. The worst case could easily be O(N),
> > right?
> > 
> 
> no, (again, the full answer is in the paper); the nice property of
> min_start is that it partitions the tree in two regions, one with
> eligible entities and one without any of them.  once we know that
> there is one eligible entity (checking the min_start at the root)
> we can find the node i with min(F_i) subject to S_i < V walking down
> a single path from the root to the leftmost eligible entity.  (we
> need to go to the right only if the subtree on the left contains 
> no eligible entities at all.)  since the RB tree is balanced this
> can be done in O(log N).
> 

Hi Fabio,

When I go thorough the paper you mentioned above, they seem to have
sorted the tree based on eligible time (looks like equivalent of start
time) and then keep track of minimum deadline on each node (equivalnet of
finish time).

We seem to be doing reverse in BFQ where we sort tree on finish time
and keep track of minimum start time on each node. Is there any specific
reason behind that?

Thanks
Vivek
