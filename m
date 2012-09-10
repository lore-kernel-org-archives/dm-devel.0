From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio allocation
 by stacking drivers
Date: Mon, 10 Sep 2012 16:01:01 -0700
Message-ID: <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com>
References: <1347055973-11581-3-git-send-email-koverstreet@google.com>
	<20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120910002810.GA23241@moria.home.lan>
	<20120910172210.GC14103@google.com>
	<20120910202435.GG16360@google.com>
	<20120910204010.GA32310@google.com>
	<20120910213349.GH16360@google.com>
	<20120910213710.GA7677@google.com>
	<20120910215633.GA19739@google.com>
	<20120910220910.GB7677@google.com>
	<20120910225057.GA10477@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120910225057.GA10477-FDJ95KluN3Z0klwcnFlA1dvLeJWuRmrY@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Mon, Sep 10, 2012 at 3:50 PM, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >     Note that this doesn't do anything for allocation from other mempools.
>
> Note that dm has several cases of this, so this patch should not be used with
> dm yet.  Mikulas is studying those cases to see whether anything like this
> might be feasible/sensible or not.

IIUC, Kent posted a patch which converts all of them to use front-pad
(there's no reason not to, really). This better come after that but
it's not like this is gonna break something which isn't broken now.

Thanks.

-- 
tejun
