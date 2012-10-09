From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] aio: Kill return value of aio_complete()
Date: Tue, 9 Oct 2012 11:25:31 -0700
Message-ID: <20121009182531.GL26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349764760-21093-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

On Mon, Oct 08, 2012 at 11:39:16PM -0700, Kent Overstreet wrote:
> Nothing used the return value, and it probably wasn't possible to use it
> safely for the locked versions (aio_complete(), aio_put_req()). Just
> kill it.

Nice, seems reasonable enough.  (Queue the timer for complaints from out
of tree code?)

Acked-by: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Though, in the future please cc: aio patches to the maintainers.  I'd
have missed this if I wasn't sifting through lkml:

$ ./scripts/get_maintainer.pl -f fs/aio.c
Benjamin LaHaise <bcrl-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org> (supporter:AIO)
Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> (maintainer:FILESYSTEMS (VFS...)
linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org (open list:AIO)
linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:FILESYSTEMS (VFS...)
linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)

- z
