From: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Date: Tue, 5 Feb 2013 00:30:03 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6542@MYMBX.MY.STEC-INC.AD>
References: <20130202004459.GA4760@blackbox.djwong.org>
 <20130204144016.GA2522@raspberrypi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130204144016.GA2522@raspberrypi>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Warr <jason-/cow75dQlsI@public.gmane.org>
List-Id: dm-devel.ids

> -----Original Message-----
> From: thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org [mailto:thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, February 04, 2013 6:40 AM
> To: Darrick J. Wong
> Cc: Amit Kale; linux-bcache; device-mapper development; Kent
> Overstreet; Mike Snitzer; LKML; Jason Warr
> Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
> caching software for Linux kernel
> 
> On Fri, Feb 01, 2013 at 04:44:59PM -0800, Darrick J. Wong wrote:
> > I will start reviewing the code as soon as this patch posts.  Be
> > warned that I haven't even compile tested this yet. :)
> 
> Has the code been updated since I looked at it a couple of weeks ago?
> For example addressing all the 'sparse' warnings?

Yes. Several warning were fixed and one kernel bug was fixed. It's better in terms of sparse warning, but not there yet.

-Amit

> 
> If you've not compiled or reviewed this code, what do you mean by the
> 'signed-off by' tag?
> 
> - Joe

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
