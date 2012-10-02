From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 04/26] block: Refactor blk_update_request()
Date: Tue, 2 Oct 2012 13:09:46 -0700
Message-ID: <20121002200946.GJ26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-5-git-send-email-koverstreet@google.com>
 <20121002185955.GD3283@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121002185955.GD3283-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 02:59:55PM -0400, Vivek Goyal wrote:
> On Mon, Sep 24, 2012 at 03:34:44PM -0700, Kent Overstreet wrote:
> > Converts it to use bio_advance(), simplifying it quite a bit in the
> > process.
> > 
> > Note that req_bio_endio() now always calls bio_advance() - which means
> > it always loops over the biovec, not just on partial completions. Don't
> > expect it to affect performance, but worth noting.
> > 
> > Tested it by forcing partial updates, and dumping before and after on
> > various bio/bvec fields when doing a partial update.
> 
> Kent,
> 
> In general, have you tested all these changes with FLUSH and DISCARD 
> bios/requests. Some of the code paths tend to break down because of these
> special bios don't have payload.

Believe so, I should double check - also, I changed the bio_advance()
patch since the one I posted to make it handle DISCARD and WRITE_SAME
requests more explicitly.

(At this level, discards do (sometimes) have payloads, it's just always
a single page)
