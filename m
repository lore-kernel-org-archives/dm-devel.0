From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 11/26] block: Add submit_bio_wait(), remove
 from md
Date: Tue, 2 Oct 2012 13:11:05 -0700
Message-ID: <20121002201105.GL26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-12-git-send-email-koverstreet@google.com>
 <20121002194132.GF3283@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121002194132.GF3283-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 03:41:32PM -0400, Vivek Goyal wrote:
> On Mon, Sep 24, 2012 at 03:34:51PM -0700, Kent Overstreet wrote:
> > Random cleanup - this code was duplicated and it's not really specific
> > to md.
> > 
> > Also added the ability to return the actual error code.
> 
> Who is going to make use of actual error code and why checking
> BIO_UPTODATE is not sufficient (as existing code is doing)?

Some things do, though it's not common and I forget where I saw it -
checking for -ENOTSUPPORTED vs. other stuff
