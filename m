From: malahal@us.ibm.com
Subject: Re: Re: dm: bind new table before destroying old
Date: Wed, 18 Nov 2009 18:51:40 -0800
Message-ID: <20091119025140.GA17829@us.ibm.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
	<20091111132056.GA28612@redhat.com>
	<20091111234555.GA24019@redhat.com>
	<20091119005036.GE6644@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091119005036.GE6644@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Alasdair G Kergon [agk@redhat.com] wrote:
> > After further testing I've hit a lockdep trace.  My testing was with
> > handing over on the same device.  I had the snapshot (of an ext3 FS)
> > mounted and I was doing a sequential direct-io write to a file in the
> > FS.  While writing I triggered a handover with the following:
> 
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.32-rc6-snitm #8
> > -------------------------------------------------------
> > dmsetup/1827 is trying to acquire lock:
> >  (&md->suspend_lock){+.+...}, at: [<ffffffffa00678d8>] dm_swap_table+0x2d/0x249 [dm_mod]
> > 
> > but task is already holding lock:
> >  (&journal->j_barrier){+.+...}, at: [<ffffffff8119192d>] journal_lock_updates+0xe1/0xf0
> > 
> > which lock already depends on the new lock.
> 
> I'm going to assume this is bogus - and I can't spot any annotations
> available to suppress it, so people will just have to ignore it.
> 
> Suspend involves:
>   get suspend lock
>   if dev is not already suspended
>     get journal lock
>     set state "dev is suspended"
>   release suspend lock
>   
> Resume involves
>   [journal lock is held]
>   get suspend lock
>   if dev is suspended 
>     release journal lock
>     set state "dev is not suspended"
>   release suspend lock
> 
> It looks as if lockdep sees that as a problem:
>   Imagine those two sections running in parallel without the "Is dev
>   suspended?" check, of which lockdep has no knowledge.

Agreed, but is it possible to restructure the suspend code such that it
acquires the journal lock before the suspend lock, and then releases the
journal lock if dev is already suspended? This needs some explaining
in a comment form though! :-)

Thanks, Malahal.
