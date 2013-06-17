From: Joe Thornber <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Performance Comparison among EnhanceIO, bcache and dm-cache.
Date: Mon, 17 Jun 2013 11:29:44 +0100
Message-ID: <20130617102943.GA11121@debian>
References: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D399C715A2AD7F4F891A75871FC3117507866B-/Mge6msRHKZU8iYRzhpb3QxBAXYc4onH@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OS Engineering <osengineering-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Cc: "koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Padmini Balasubramaniyan <padminib-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, Amit Phansalkar <aphansalkar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Jun 11, 2013 at 03:05:07PM +0000, OS Engineering wrote:

...

> Dm-cache commits on-disk metadata every time a REQ_SYNC or REQ_FUA
> bio is written. If no such requests are made then it commits
> metadata once every second. If power is lost, it may lose some
> recent writes.

Not true (though it is true for thinp, which may be where you got this
idea?).  For caching we have to commit whenever data is moved about,
otherwise a crash could result in us reading data that is not just out
of date (acceptable for some), but used to belong to a totally
different part of the device (always unacceptable).

- Joe
