From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v10 1/8] block: Generalized bio pool freeing
Date: Mon, 17 Sep 2012 13:51:39 -0700
Message-ID: <20120917205139.GB14492@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-2-git-send-email-koverstreet@google.com>
 <20120914182828.GK15728@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120914182828.GK15728-FDJ95KluN3Z0klwcnFlA1dvLeJWuRmrY@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
List-Id: dm-devel.ids

On Fri, Sep 14, 2012 at 07:28:28PM +0100, Alasdair G Kergon wrote:
> On Thu, Sep 06, 2012 at 03:34:55PM -0700, Kent Overstreet wrote:
> > With the old code, when you allocate a bio from a bio pool you have to
> > implement your own destructor that knows how to find the bio pool the
> > bio was originally allocated from.
> > 
> > This adds a new field to struct bio (bi_pool) and changes
> > bio_alloc_bioset() to use it. This makes various bio destructors
> > unnecessary, so they're then deleted.
> > 
> > v6: Explain the temporary if statement in bio_put
>  
> This patch also silently reverts 
> commit 4d7b38b7d944a79da3793b6c92d38682f3905ac9
> "dm: clear bi_end_io on remapping failure"
> 
> Why?
> 
> If it's intentional, please explain it in your patch header and
> copy Hannes to reconsider the matter.

Never noticed that was introduced in its own patch until you pointed it
out.

That isn't a very good patch - it says it's clearing bi_end_io as a
precaution, but as a precaution to what?

As far as I can tell, it was never necessary. The bio is about to be
freed - there shouldn't be any other references on it (__bio_map() is
called on freshly allocated bios, and bio_get() is never called in dm.c)
Nothing else should've been looking at bi_end_io, certainly the
destructor didn't.

Now that there's no destructor, it makes even less sense to have it -
after that bio_put() that bio isn't being touched by dm code anymore.
