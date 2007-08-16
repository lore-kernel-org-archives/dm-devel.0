From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dm: Fix deadlock under high i/o load in
	raid1 setup.
Date: Wed, 15 Aug 2007 20:10:29 -0700
Message-ID: <20070815201029.fb965871.akpm@linux-foundation.org>
References: <20070813113340.GB30198@osiris.boeblingen.de.ibm.com>
	<20070815155604.87318305.akpm@linux-foundation.org>
	<20070815235956.GD8741@osiris.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070815235956.GD8741@osiris.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stefan Weinhuber <wein@de.ibm.com>, Stefan Bader <shbader@de.ibm.com>, linux-mm@kvack.org, dm-devel@redhat.com, Daniel Kobras <kobras@linux.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 16 Aug 2007 01:59:56 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> > So yes, I'd say this is a bug in DM.
> > 
> > Also, __rh_alloc() is called under read_lock(), via __rh_find().  If
> > __rh_alloc()'s mempool_alloc() fails, it will perform a sleeping allocation
> > under read_lock(), which is deadlockable and will generate might_sleep()
> > warnings
> 
> The read_lock() is unlocked at the beginning of the function.

Oh, OK.  Looks odd, but whatever.

> Unless
> you're talking of a different lock, but I couldn't find any.
> 
> So at least _currently_ this should work unless somebody uses fault
> injection. Would it make sense then to add the __GFP_NOFAIL flag to
> the kmalloc call?

It would best to avoid that.  __GFP_NOFAIL was added as a way of
consolidating a number of callsites which were performing open-coded
infinite retries and it is also used as a "this is lame and needs to be
fixed" indicator.

It'd be better to fix the kmirrord design so that it can use mempools
properly.  One possible way of doing that might be to notice when mempool
exhaustion happens, submit whatever IO is thus-far buffered up and then do
a sleeping mempool allocation, to wait for that memory to come free (via IO
completion).

That would be a bit abusive of the mempool intent though.  A more idiomatic
fix would be to change kmirrord so that it no longer can consume all of the
mempool's reserves without having submitted any I/O (which is what I assume
it is doing).
