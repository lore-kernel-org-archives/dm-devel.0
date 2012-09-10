From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio
 allocation by stacking drivers
Date: Mon, 10 Sep 2012 16:35:02 -0700
Message-ID: <20120910233502.GH7677@google.com>
References: <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <20120910220910.GB7677@google.com>
 <20120910225057.GA10477@agk-dp.fab.redhat.com>
 <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com>
 <20120910230917.GB10477@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120910230917.GB10477-FDJ95KluN3Z0klwcnFlA1dvLeJWuRmrY@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hello, Alasdair.

On Tue, Sep 11, 2012 at 12:09:17AM +0100, Alasdair G Kergon wrote:
> On Mon, Sep 10, 2012 at 04:01:01PM -0700, Tejun Heo wrote:
> > IIUC, Kent posted a patch which converts all of them to use front-pad
> 
> The only patch I saw posted here only handles one of the easier cases so far.
> 
> The others are a bit trickier and probably involve a decision about which way to
> change an in-kernel dm interface.

Ah, I see.  Thought that was full conversion.  I still think this is
the right direction to be headed tho.  Using multiple mempools from
the stacking drivers is way too fragile and difficult to verify and
debug.  Would it be difficult to convert dm drivers to collect size
requirements and use front-pad for all per-bio data?

Thanks.

-- 
tejun
