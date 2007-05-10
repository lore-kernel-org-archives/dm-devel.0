From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.22 PATCH 23/26] dm delay:
Date: Thu, 10 May 2007 12:37:55 -0700
Message-ID: <20070510123755.09dbc70c.akpm@linux-foundation.org>
References: <20070508194859.GD24114@agk.fab.redhat.com>
	<20070508175410.d5b7e91f.akpm@linux-foundation.org>
	<20070510120223.bb4c22df.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705101204150.10698@schroedinger.engr.sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0705101204150.10698@schroedinger.engr.sgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Lameter <clameter@sgi.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids

On Thu, 10 May 2007 12:04:50 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 10 May 2007, Andrew Morton wrote:
> 
> > > > +	delayed_cache = kmem_cache_create("dm-delay",
> > > > +					  sizeof(struct delay_info),
> > > > +					  __alignof__(struct delay_info),
> > > > +					  0, NULL, NULL);
> > > 
> > > We have an ugly^Wnice new KMEM_CACHE macro for this now.
> 
> How could I nicify the macro? Lower case?

Lower case would be worse, IMO.  Upper-case says "this is a macro".  Lower-case
macros are OK when they are macros pretending to be functions, but KMEM_CACHE
is not such a thing.

I don't think it can be nicified, except by removing it.  We generally
prefer to open-code things rather than wrapping them up in macros.

But given the amount of variation amongst callers and the number of times
this got screwed up, I agree that burying those details at a single site
makes sense in this instance.
