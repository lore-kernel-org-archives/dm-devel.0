From: Sandeep Patil <sspatil@google.com>
Subject: Re: [dm-devel] [RFC] dm-bow working prototype
Date: Sun, 2 Dec 2018 02:07:29 -0800
Message-ID: <20181202100729.GT239052@google.com>
References: <20181023212358.60292-1-paullawrence@google.com>
 <20181023221819.GB17552@agk-dp.fab.redhat.com>
 <296148c2-f2d9-5818-ea76-d71a0d6f5cd4@google.com>
 <alpine.LRH.2.02.1810241514310.4080@file01.intranet.prod.int.rdu2.redhat.com>
 <4a934593-1bd1-be5f-35c0-945c42762627@google.com>
 <alpine.LRH.2.02.1810261558460.28906@file01.intranet.prod.int.rdu2.redhat.com>
 <fba91b2e-4b2e-8daf-ff64-a12c9139cada@google.com>
 <alpine.LRH.2.02.1811151809380.25860@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1811151809380.25860@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Paul Lawrence <paullawrence@google.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org, kernel-team@android.com, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

Hi Mikulas,

On Thu, Nov 15, 2018 at 06:15:34PM -0500, Mikulas Patocka wrote:
> 
> 
> On Mon, 29 Oct 2018, Paul Lawrence wrote:
> 
> > 
> > > The snapshot target could be hacked so that it remembers space trimmed
> > > with REQ_OP_DISCARD and won't reallocate these blocks.
> > > 
> > > But I suspect that running discard over the whole device would degrade
> > > performance more than copying some unneeded data.
> > > 
> > > How much data do you intend to backup with this solution?
> > > 
> > > 
> > We are space-constrained - we will have to free up space for the backup before
> > we apply the update, so we have to predict the size and keeping usage as low
> > as possible is thus very important.
> > 
> > Also, we've discussed the resizing requirement of the dm-snap solution and
> > that part is not attractive at all - it seems it would be impossible to
> > guarantee that the resizing happens in a timely fashion during the (very busy)
> > update cycle.
> > 
> > Thanks everyone for the insights, especially into how dm-snap works, which I
> > hadn't fully appreciated. At the moment, and for the above reasons, we intend
> > to continue with the dm-bow solution, but do want to keep this discussion
> > open. If anyone is going to be at Linux Plumbers, I'll be presenting this work
> > and would love to chat about it more.
> 
> dm-snapshot took 9 years to fix the last data corruption bug (2004-2013 - 
> the commit e9c6a182649f4259db704ae15a91ac820e63b0ca).
> 
> And with the new target duplicating the snapshot functionality, it may be 
> the same.
> 

Thanks for that. We are as much sensitive to not duplicating functionality
and of course reliability of the implementation.

So we did spend considerable amount of time trying to make dm-snapshot work
for us (including the approach suggested here now). However, the additional
space needed to make dm-snapshot work in this situation is unfortunate and
won't work for Android. Especially given that we will be taking that space
away from the user all in one go too.

Anyway, I wanted to ask if there is any way we can make dm-snapshot work the
way dm-bow does? With patches is fine, we can work on that :).

I think Paul is planning to send a v2 with more description and the block
size fix that caused problems for others trying it out.

FWIW, dm-bow itself suffers from a mutex for each write that stalls for
longer when the write is to a block being modified (as opposed to a free
block being written to). We are hoping to iterate over that problem once the
general idea is acceptable to everyone.

Thanks for your help.

- ssp


> Mikulas
