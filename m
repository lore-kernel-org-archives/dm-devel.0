From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Mon, 31 May 2010 22:39:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1005312236570.6372@hs20-bc2-1.build.redhat.com>
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com>
 <20100531174225.GE10766@basil.fritz.box> <4C03FB8E.1060109@redhat.com>
 <20100531182724.GG10766@basil.fritz.box>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100531182724.GG10766@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>, ak@linux.intel.com, linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au, Andi Kleen <andi@firstfloor.org>, agk@redhat.com
List-Id: dm-devel.ids

> > >> 2) Per volume threads and mempools were added to solve low memory
> > >> problems (exhausted mempools), isn't now possible deadlock here again?
> > > 
> > > Increasing the number of parallel submitters does not increase deadlocks
> > > with mempool as long as they don't nest.  They would just
> > > block each other, but eventually make progress as one finishes. 
> > 
> > I mean if they nest of course, sorry for confusion.
> 
> No change to that, it's the same as it always worked.
> 
> Anyways, Right now you would need to nest more than 16 times I think
> to exhaust the mempool (or 8, but the pages are less critical I think)
> 
> For me that seems like a "don't do that if hurts" situation.

If the mempools are per-instance (they are), it can nest any number of 
times, because each nested instance will get new mempools. It is not a 
problem.

Mikulas
