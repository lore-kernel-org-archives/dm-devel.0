From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] dm: Use bioset's front_pad for dm_target_io
Date: Tue, 4 Sep 2012 14:20:22 -0700
Message-ID: <20120904212022.GB8724@dhcp-172-17-108-109.mtv.corp.google.com>
References: <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
 <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com>
 <20120904195156.GE25236@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120904195156.GE25236-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

Hello, Kent.

On Tue, Sep 04, 2012 at 12:51:56PM -0700, Kent Overstreet wrote:
> I wrote a patch for dm_target_io last night. I think I know an easy way
> to go about converting the rest but it'll probably have to wait until
> I'm further along with my immutable bvec stuff.
> 
> Completely untested patch below:

Yeap, this looks great to me.  In the end, I think it's better to
require stacking drivers to not use separate mempools other than
bioset.  Timer or not, using multiple alloc pools is brittle.  Any
path which ends up allocating in different orders for whatever reason
can lead to subtle deadlock scenarios which can be very difficult to
track down and, at least currently, there's no way to automatically
detect them.  Besides, w/ front-pad, it really shouldn't be necessary.

Thanks.

-- 
tejun
