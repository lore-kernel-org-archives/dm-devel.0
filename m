From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio
	allocation by stacking drivers
Date: Tue, 11 Sep 2012 00:09:17 +0100
Message-ID: <20120910230917.GB10477@agk-dp.fab.redhat.com>
References: <20120910002810.GA23241@moria.home.lan> <20120910172210.GC14103@google.com> <20120910202435.GG16360@google.com> <20120910204010.GA32310@google.com> <20120910213349.GH16360@google.com> <20120910213710.GA7677@google.com> <20120910215633.GA19739@google.com> <20120910220910.GB7677@google.com> <20120910225057.GA10477@agk-dp.fab.redhat.com> <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 04:01:01PM -0700, Tejun Heo wrote:
> IIUC, Kent posted a patch which converts all of them to use front-pad

The only patch I saw posted here only handles one of the easier cases so far.

The others are a bit trickier and probably involve a decision about which way to
change an in-kernel dm interface.

Alasdair
