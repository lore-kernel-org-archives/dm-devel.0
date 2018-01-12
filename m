From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: SRCU's apparent use of NR_CPUS? [was: re: dm: allocate struct
 mapped_device with kvzalloc]
Date: Fri, 12 Jan 2018 11:18:25 -0800
Message-ID: <20180112191825.GB9671@linux.vnet.ibm.com>
References: <alpine.LRH.2.02.1710311931190.28120@file01.intranet.prod.int.rdu2.redhat.com>
 <20171101154844.GA25792@redhat.com>
 <20171101162306.GU3659@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1711031608500.21925@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711031608500.21925@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Nov 03, 2017 at 04:10:50PM -0400, Mikulas Patocka wrote:
> 
> 
> On Wed, 1 Nov 2017, Paul E. McKenney wrote:
> 
> > On Wed, Nov 01, 2017 at 11:48:44AM -0400, Mike Snitzer wrote:
> > > [cc'ing Paul, and LKML, to get his/others' take on SRCU cpu scaling]
> > > 
> > > On Tue, Oct 31 2017 at  7:33pm -0400,
> > > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > 
> > > > The structure srcu_struct can be very big, its size is proportional to the 
> > > > value CONFIG_NR_CPUS. The Fedora kernel has CONFIG_NR_CPUS 8192, the field 
> > > > io_barrier in the struct mapped_device has 84kB in the debugging kernel 
> > > > and 50kB in the non-debugging kernel. The large size may result in failure 
> > > > of the function kzalloc_node.
> > > > 
> > > > In order to avoid the allocation failure, we use the function
> > > > kvzalloc_node, this function falls back to vmalloc if a large contiguous
> > > > chunk of memory is not available. This patch also moves the field
> > > > io_barrier to the last position of struct mapped_device - the reason is
> > > > that on many processor architectures, short memory offsets result in
> > > > smaller code than long memory offsets - on x86-64 it reduces code size by
> > > > 320 bytes.
> > > > 
> > > > Note to stable kernel maintainers - the kernels 4.11 and older don't have
> > > > the function kvzalloc_node, you can use the function vzalloc_node instead.
> > > > 
> > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > > Cc: stable@vger.kernel.org
> > > 
> > > This looks reasonable as a near-term workaround.. BUT:
> > > Paul has there been any discussion about how to make SRCU support
> > > dynamically scaling up to NR_CPUS maximum as 'nr_cpus' changes (rather
> > > than accounting for worst case of NR_CPUS up-front)?
> > 
> > This is the first I have heard of this being a problem.
> > 
> > For static instances of srcu_struct, life is hard.
> > 
> > But it should not be all that difficult for SRCU to provide an allocator
> > for the dynamic cases, which given your kzalloc_node() above is the case
> > you are worried about, at least assuming that these allocations happen
> > after rcu_init() is invoked (which is pretty early).
> > 
> > My approach would be to move the srcu_struct ->node[] array to its
> > own structure, with a pointer from srcu_struct, allowing short-sized
> > allocations to be used.  (But I do need to check to make sure that there
> > are no gotchas, and with RCU there usually are a few.)  Obviously some
> > -serious- testing would be required -- do you have a range of systems
> > to test on?
> > 
> > However, you would still have your potential failure case for systems
> > that really did have large numbers of CPUs, some of which really do
> > exist in the wild.
> 
> So - you can allocate srcu_struct->node with kvmalloc - it will 
> automatically fallback to vmalloc if the allocation is too large for 
> kmalloc.

And after looking more closely at this, I am now leaning more towards
providing a function to run-time allocate an srcu_struct.  I would move
the ->node[] array to the end to allow variable-length allocations.
This would mean that your structures would contain a pointer to the
srcu_struct rather than the srcu_struct itself.

Would that work for you?

							Thanx, Paul

> Mikulas
> 
> > > (But I had a quick look at scrutree.h and I'm not seeing explicit use of
> > > NR_CPUS, so it is likely occuring via implicit percpu through some
> > > member of 'struct srcu_struct', e.g. 'sda'?)
> > 
> > The srcu_struct structure sees NR_CPUS via include/linux/rcu_node_tree.h,
> > which sizes the srcu_node array at build time.
> > 
> > The sda pointer references a per-CPU allocation, which I believe already
> > is sized to the actual system rather than to NR_CPUS.
> > 
> > 							Thanx, Paul
> > 
> > > Thanks,
> > > Mike
> > > 
> > > > 
> > > > ---
> > > >  drivers/md/dm-core.h |    3 ++-
> > > >  drivers/md/dm.c      |    6 +++---
> > > >  2 files changed, 5 insertions(+), 4 deletions(-)
> > > > 
> > > > Index: linux-2.6/drivers/md/dm-core.h
> > > > ===================================================================
> > > > --- linux-2.6.orig/drivers/md/dm-core.h
> > > > +++ linux-2.6/drivers/md/dm-core.h
> > > > @@ -29,7 +29,6 @@ struct dm_kobject_holder {
> > > >   * DM targets must _not_ deference a mapped_device to directly access its members!
> > > >   */
> > > >  struct mapped_device {
> > > > -	struct srcu_struct io_barrier;
> > > >  	struct mutex suspend_lock;
> > > >  
> > > >  	/*
> > > > @@ -127,6 +126,8 @@ struct mapped_device {
> > > >  	struct blk_mq_tag_set *tag_set;
> > > >  	bool use_blk_mq:1;
> > > >  	bool init_tio_pdu:1;
> > > > +
> > > > +	struct srcu_struct io_barrier;
> > > >  };
> > > >  
> > > >  void dm_init_md_queue(struct mapped_device *md);
> > > > Index: linux-2.6/drivers/md/dm.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/drivers/md/dm.c
> > > > +++ linux-2.6/drivers/md/dm.c
> > > > @@ -1695,7 +1695,7 @@ static struct mapped_device *alloc_dev(i
> > > >  	struct mapped_device *md;
> > > >  	void *old_md;
> > > >  
> > > > -	md = kzalloc_node(sizeof(*md), GFP_KERNEL, numa_node_id);
> > > > +	md = kvzalloc_node(sizeof(*md), GFP_KERNEL, numa_node_id);
> > > >  	if (!md) {
> > > >  		DMWARN("unable to allocate device, out of memory.");
> > > >  		return NULL;
> > > > @@ -1795,7 +1795,7 @@ bad_io_barrier:
> > > >  bad_minor:
> > > >  	module_put(THIS_MODULE);
> > > >  bad_module_get:
> > > > -	kfree(md);
> > > > +	kvfree(md);
> > > >  	return NULL;
> > > >  }
> > > >  
> > > > @@ -1814,7 +1814,7 @@ static void free_dev(struct mapped_devic
> > > >  	free_minor(minor);
> > > >  
> > > >  	module_put(THIS_MODULE);
> > > > -	kfree(md);
> > > > +	kvfree(md);
> > > >  }
> > > >  
> > > >  static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
> > > 
> > 
> 
