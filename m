From: Matt Mackall <mpm@selenic.com>
Subject: Re: [2.6.23 PATCH 13/18] dm: netlink
Date: Thu, 12 Jul 2007 18:19:20 -0500
Message-ID: <20070712231920.GZ11166@waste.org>
References: <20070711210137.GE24114@agk.fab.redhat.com> <20070711142712.e646995b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070711142712.e646995b.akpm@linux-foundation.org>
Sender: netdev-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, netdev@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jul 11, 2007 at 02:27:12PM -0700, Andrew Morton wrote:
> On Wed, 11 Jul 2007 22:01:37 +0100
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > From: Mike Anderson <andmike@us.ibm.com>
> > 
> > This patch adds a dm-netlink skeleton support to the Makefile, and the dm
> > directory.
> > 
> > ...
> >  
> > +config DM_NETLINK
> > +	bool "DM netlink events (EXPERIMENTAL)"
> > +	depends on BLK_DEV_DM && EXPERIMENTAL
> > +	---help---
> > +	Generate netlink events for DM events.
> 
> Need a dependency on NET there?

It's really sad to make DM dependent on the network layer.

-- 
Mathematics is the supreme nostalgia of our time.
