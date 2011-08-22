From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCHES] convert dm-thin to use dm-bufio
Date: Mon, 22 Aug 2011 14:24:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108221421130.26814@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819091224.GB3193@ubuntu> <20110819161745.GA27778@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110819161745.GA27778@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

> Mikulas,
> 
> On Fri, Aug 19, 2011 at 10:12:24AM +0100, Joe Thornber wrote:
> > On Thu, Aug 18, 2011 at 06:31:13PM -0400, Mikulas Patocka wrote:
> > > I uploaded bufio-based block manager at 
> > > http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/. It 
> > > supports locks, but it defines new functions down_write_non_owner and 
> > > up_write_non_owner.
> > 
> > Thanks Mikulas, I'll try and get it merged over the next couple of days.
> 
> I've merged and pushed this to my git repo.

I checkouted the tree now (I tried all branches reported with git-branch 
-a), but I couldn't see bufio in any of the branches.

> All the test-suite is passing.  Performance is identical (though
> hopefully we're a lot more scaleable now).
> 
> I have to say I think the separation of io and locking is very elegant
> now.  Well done.
> 
> I've made two small changes:
> 
> i) I switched to using dm_bufio_new() rather than dm_bufio_read() at
> the start of *write_lock_zero().  No point reading the data if we're
> going to throw it away.

OK, I forgot about this.

> ii) We no longer hold the superblock lock for the duration of the
> transaction.  This means we can get rid of the nasty rwsem non-owner
> patch.
> 
> We have one outstanding issue however.  Now we're using a rwsem per
> block, lockdep is trying to validate there are no deadlocks.  Which it
> can't do, so is producing a warning. See the
>    
>  "Exception: Nested data dependencies leading to nested locking"
> 
> section in lockdep-design.txt for more discussion of the problem.
> 
> We need to suppress this somehow.  I guess the right thing to do is
> use the nesting level facility, eg call the superblock level 0, btree
> roots level 1 etc.  This will involve a lot of code changes however.
> So for now I just want to turn off checking on those locks.

I think you can't turn off lockdep just so. Those "non-owner" lock 
versions, bypass lockdep.

Mikulas

> - Joe
> 
