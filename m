From: Joe Thornber <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] bcache/dmcache/enhanceio bake-off
Date: Sat, 13 Apr 2013 17:09:25 +0100
Message-ID: <20130413160925.GA5236@debian>
References: <20130411072239.GD8910@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130411072239.GD8910-yuuUpGxbzT9UbpRmUfBrXUB+6BGkLq7r@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Hi Darrick,

On Thu, Apr 11, 2013 at 12:22:39AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Lately I've been having some fun playing with bcache, dmcache, and enhanceio.

I pushed some tweaks to the mq policy today to my thin-dev tree.  They
show some improvements to these fio based tests.

In addition I've written a blog post trying to explain what's going on in dm-cache:
http://device-mapper.org/blog/2013/04/13/benchmarking-dm-cache-with-fio/

- Joe
