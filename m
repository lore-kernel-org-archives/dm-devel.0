From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
Date: Wed, 8 Aug 2012 17:14:27 -0700
Message-ID: <20120809001427.GD7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-6-git-send-email-koverstreet@google.com>
 <20120807031921.GA31977@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120807031921.GA31977-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Mon, Aug 06, 2012 at 11:19:21PM -0400, Mike Snitzer wrote:
> On Mon, Aug 06 2012 at  6:08pm -0400,
> Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Now that we've got generic code for freeing bios allocated from bio
> > pools, this isn't needed anymore.
> > 
> > This also changes the semantics of bio_free() a bit - it now also frees
> > bios allocated by bio_kmalloc(). It's also no longer exported, as
> > without bi_destructor there should be no need for it to be called
> > anywhere else.
> 
> Seems you forgot to remove bio_free's EXPORT_SYMBOL

Whoops - thanks, fixed.
