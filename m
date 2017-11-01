From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: SRCU's apparent use of NR_CPUS? [was: re: dm: allocate struct
 mapped_device with kvzalloc]
Date: Wed, 1 Nov 2017 17:32:22 -0400
Message-ID: <20171101213222.GA27306@redhat.com>
References: <alpine.LRH.2.02.1710311931190.28120@file01.intranet.prod.int.rdu2.redhat.com>
 <20171101154844.GA25792@redhat.com>
 <20171101162306.GU3659@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171101162306.GU3659@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 01 2017 at 12:23pm -0400,
Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Nov 01, 2017 at 11:48:44AM -0400, Mike Snitzer wrote:
> > [cc'ing Paul, and LKML, to get his/others' take on SRCU cpu scaling]
> > 
> > On Tue, Oct 31 2017 at  7:33pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > The structure srcu_struct can be very big, its size is proportional to the 
> > > value CONFIG_NR_CPUS. The Fedora kernel has CONFIG_NR_CPUS 8192, the field 
> > > io_barrier in the struct mapped_device has 84kB in the debugging kernel 
> > > and 50kB in the non-debugging kernel. The large size may result in failure 
> > > of the function kzalloc_node.
> > > 
> > > In order to avoid the allocation failure, we use the function
> > > kvzalloc_node, this function falls back to vmalloc if a large contiguous
> > > chunk of memory is not available. This patch also moves the field
> > > io_barrier to the last position of struct mapped_device - the reason is
> > > that on many processor architectures, short memory offsets result in
> > > smaller code than long memory offsets - on x86-64 it reduces code size by
> > > 320 bytes.
> > > 
> > > Note to stable kernel maintainers - the kernels 4.11 and older don't have
> > > the function kvzalloc_node, you can use the function vzalloc_node instead.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Cc: stable@vger.kernel.org
> > 
> > This looks reasonable as a near-term workaround.. BUT:
> > Paul has there been any discussion about how to make SRCU support
> > dynamically scaling up to NR_CPUS maximum as 'nr_cpus' changes (rather
> > than accounting for worst case of NR_CPUS up-front)?
> 
> This is the first I have heard of this being a problem.
> 
> For static instances of srcu_struct, life is hard.
> 
> But it should not be all that difficult for SRCU to provide an allocator
> for the dynamic cases, which given your kzalloc_node() above is the case
> you are worried about, at least assuming that these allocations happen
> after rcu_init() is invoked (which is pretty early).
> 
> My approach would be to move the srcu_struct ->node[] array to its
> own structure, with a pointer from srcu_struct, allowing short-sized
> allocations to be used.  (But I do need to check to make sure that there
> are no gotchas, and with RCU there usually are a few.)  Obviously some
> -serious- testing would be required -- do you have a range of systems
> to test on?

If you'd like to give it a try I'd be happy to work on getting you test
coverage.

I do have access to a pretty wide range of systems.  What type of
testing would you like to see?

(From where I sit as DM maintainer my testing would be DM-specific, just
loading a DM device would make use of the SRCU code in question, so
please let me know if there is anything more general you'd like done)
 
> However, you would still have your potential failure case for systems
> that really did have large numbers of CPUs, some of which really do
> exist in the wild.
> 
> > (But I had a quick look at scrutree.h and I'm not seeing explicit use of
> > NR_CPUS, so it is likely occuring via implicit percpu through some
> > member of 'struct srcu_struct', e.g. 'sda'?)
> 
> The srcu_struct structure sees NR_CPUS via include/linux/rcu_node_tree.h,
> which sizes the srcu_node array at build time.
> 
> The sda pointer references a per-CPU allocation, which I believe already
> is sized to the actual system rather than to NR_CPUS.

OK, thanks for clarifying.

Mike
