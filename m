From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: convert dm-thin to use dm-bufio
Date: Fri, 19 Aug 2011 03:04:36 -0400
Message-ID: <20110819070435.GA32300@redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 18 2011 at  6:31pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > This all sounds good; get the locking interface in and I'll switch to
> > bufio straight away.
> > 
> > - Joe
> 
> I uploaded bufio-based block manager at 
> http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/. It 
> supports locks, but it defines new functions down_write_non_owner and 
> up_write_non_owner.

dm-bufio.patch:
drivers/md/Kconfig needs a more comprehensive description for DM_BUFIO's
help.


dm-thinp-bufio.patch:
1)
This drivers/md/persistent-data/dm-block-manager.h change avoids lots of
block manager interface churn:

-struct dm_block;
+#define dm_block		dm_buffer
+#define dm_block_manager	dm_bufio_client

But I think it'd be best, in the long run, to have a follow-on patch
that does away with the aliases and just use the bufio structs
throughout the code.  Anyway, don't need to worry about this now.  But
what you've done is hack that should probably be cleaned up.

2)
dm_bm_rebind_block_device:
+	 * !!! FIXME: remove this. It is supposedly unused.

I'll need to look closer at the overall changes to dm-block-manager.c
but you've clearly gotten rid of struct dm_block_manager; so there is no
reference to a bdev that needs to be flushed.

Which begs the question:
Have you tested this bufio conversion with the thinp-test-suite?
git://github.com/jthornber/thinp-test-suite.git




Question for Joe:
You're making conflicting changes quick enough that I wonder if you
and Mikulas will ever converge (e.g. why do multiple block managers need
to have access to the same metadata device!?).

-  - [ ] Sometimes I'm getting kmem_cache name clashes in the block
+  - [X] Sometimes I'm getting kmem_cache name clashes in the block
         manager.  We're obviously not deleting the cache in a particular
         error path.  Recently introduced.                               :ejt:

commit 049bf17f41147ba3d51bac6ebee038d3d79a086c
Author: Joe Thornber <ejt@redhat.com>
Date:   Wed Aug 17 13:46:12 2011 +0100

    [block-manager, thin-metadata] Make the bm kmemcache name unique to
    the pool.
    
    ATM the kmem_cache identifier just includes the major/minor of the
    device that the bm is looking at.  This means you can't create 2 bms
    that point to the same device without generating a nasty stack
    trace.
    
    This patch makes the name unique to the pool.  It's a quick hack to
    allow me to keep on testing.  Could someone who cares about these
    kmemcaches decide on a proper solution please.
