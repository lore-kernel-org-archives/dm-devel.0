From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio
	allocation by stacking drivers
Date: Tue, 11 Sep 2012 00:45:34 +0100
Message-ID: <20120910234534.GD10477@agk-dp.fab.redhat.com>
References: <20120910202435.GG16360@google.com> <20120910204010.GA32310@google.com> <20120910213349.GH16360@google.com> <20120910213710.GA7677@google.com> <20120910215633.GA19739@google.com> <20120910220910.GB7677@google.com> <20120910225057.GA10477@agk-dp.fab.redhat.com> <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com> <20120910230917.GB10477@agk-dp.fab.redhat.com> <20120910233502.GH7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120910233502.GH7677-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 04:35:02PM -0700, Tejun Heo wrote:
> debug.  Would it be difficult to convert dm drivers to collect size
> requirements and use front-pad for all per-bio data?
 
I can't give a quick answer because a single bio may require a variable
number (depending on the bio content) of (sequential) mempool_allocs from the
same mempool to complete its processing, so we do have to audit all this very
carefully to see what can/can't be pulled out.

Alasdair
