From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Date: Thu, 11 Oct 2012 09:43:12 -0700
Message-ID: <20121011164312.GD8768@lenny.home.zabbo.net>
References: <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
 <20121009225509.GA26835@google.com>
 <20121009231059.GV26187@lenny.home.zabbo.net>
 <20121010000600.GB26835@google.com>
 <20121010002634.GX26187@lenny.home.zabbo.net>
 <20121010004746.GF26835@google.com>
 <20121010214315.GE6371@lenny.home.zabbo.net>
 <20121011025102.GE24174@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121011025102.GE24174-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

> Yeah, but that means the completion has to be delivered from process
> context. That's not what aio does today, and it'd be a real performance
> regression.

It'd only have to to complete from process context if it faults. The
cheapest possible delivery mechanism is simple cpu stores.  In the vast
majority of cases the ring will be resident and it'll be done.  In rare
cases it could fall back to a deferred completion.  If apps can't
stomach that latency and want to pay the overhead of pinning to remove
that risk, they're welcome to do so.

That's my hope, anyway.

- z
