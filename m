From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD caching
 software for Linux kernel
Date: Mon, 4 Feb 2013 12:53:39 -0800
Message-ID: <20130204205339.GI4761@blackbox.djwong.org>
References: <20130202004459.GA4760@blackbox.djwong.org>
 <20130204144016.GA2522@raspberrypi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130204144016.GA2522@raspberrypi>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Warr <jason-/cow75dQlsI@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Feb 04, 2013 at 02:40:17PM +0000, thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> On Fri, Feb 01, 2013 at 04:44:59PM -0800, Darrick J. Wong wrote:
> > I will start reviewing the code as soon as this patch posts.  Be warned that I
> > haven't even compile tested this yet. :)
> 
> Has the code been updated since I looked at it a couple of weeks ago?
> For example addressing all the 'sparse' warnings?
> 
> If you've not compiled or reviewed this code, what do you mean by the
> 'signed-off by' tag?

I changed a couple of things in the Kconfig file, most notably setting default
to n and depending on BLK_DEV.

--D
> 
> - Joe
