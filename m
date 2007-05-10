From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [2.6.22 PATCH 23/26] dm delay:
Date: Thu, 10 May 2007 12:04:50 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705101204150.10698@schroedinger.engr.sgi.com>
References: <20070508194859.GD24114@agk.fab.redhat.com>
 <20070508175410.d5b7e91f.akpm@linux-foundation.org>
 <20070510120223.bb4c22df.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761385AbXEJTFA@vger.kernel.org>
In-Reply-To: <20070510120223.bb4c22df.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids

On Thu, 10 May 2007, Andrew Morton wrote:

> > > +	delayed_cache = kmem_cache_create("dm-delay",
> > > +					  sizeof(struct delay_info),
> > > +					  __alignof__(struct delay_info),
> > > +					  0, NULL, NULL);
> > 
> > We have an ugly^Wnice new KMEM_CACHE macro for this now.

How could I nicify the macro? Lower case?
