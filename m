From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.27.14: BUG: lock held when returning to user space!
Date: Wed, 04 Mar 2009 18:08:04 +0100
Message-ID: <1236186484.5330.8185.camel@laptop>
References: <20090225142136.GA29505@janus>
	 <1235579389.4645.3621.camel@laptop>
	 <20090304165830.GC8748@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755997AbZCDRIu@vger.kernel.org>
In-Reply-To: <20090304165830.GC8748@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
List-Id: dm-devel.ids

On Wed, 2009-03-04 at 17:58 +0100, Jan Kara wrote:
> > On Wed, 2009-02-25 at 15:21 +0100, Frank van Maarseveen wrote:
> > > An lvextend -L+16G command for a logical volume while being mounted rw
> > > as ext3 triggered the following on 2.6.27.14:
> > > 
> > > ================================================
> > > [ BUG: lock held when returning to user space! ]
> > > ------------------------------------------------
> > > lvextend/29191 is leaving the kernel with locks still held!
> > > 2 locks held by lvextend/29191:
> > >  #0: (&type->s_umount_key #15){....}, at: [<c019edfb>] get_super+0x6b/0xb0
> > >  #1: (&journal->j_barrier){....}, at: [<c01f9af3>] journal_lock_updates+0xc3/0xd0
> > 
> > Do recent kernels still say this?
>
>   I'd say so. We really hold j_barrier mutex when leaving the kernel
> after FIFREEZE ioctl (the call path goes as freeze_bdev -> ext3_freeze
> -> journal_lock_updates) until FITHAW is called. As far as I know it was
> designed this way...
>   It would be a pity to completely exclude j_barrier mutex from lockdep
> control so would it be possible to mark the mutex (or even that
> particular acquisition of the mutex) so that lockdep does not warn when
> we return with it to userspace?

Linus specificly stated that we are not to keep locks held when
returning to userspace:

  http://lkml.org/lkml/2007/10/27/135

So sure, we could annotate this, but no I won't until you can convince
both me and Linus that its a sane thing to do.

The problems include: how can you be sure its the same task calling the
completing ioctl?
