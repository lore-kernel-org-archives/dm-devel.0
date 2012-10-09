From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Date: Tue, 9 Oct 2012 15:58:36 -0700
Message-ID: <20121009225836.GU26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
 <20121009223210.GR26187@lenny.home.zabbo.net>
 <20121009224428.GH29494@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121009224428.GH29494-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

> Not if we decouple the ringbuffer size from max_requests.

Hmm, interesting.

> This would be useful to do anyways because right now, allocating a kiocb
> has to take a global refcount and check head and tail in the ringbuffer
> just so it can avoid overflowing the ringbuffer.

I'm not sure what you mean by a 'global refcount'.. do you mean the
per-mm ctx_lock?

> If we change aio_complete() so that if the ringbuffer is full then the
> kiocb just goes on a linked list - we can size the ringbuffer so this
> doesn't happen normally and avoid the global synchronization in the fast
> path.

How would completion events make their way from the list to the ring if
an app is only checking the ring for completions from userspace?

- z
