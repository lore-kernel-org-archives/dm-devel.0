From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Date: Tue, 2 Oct 2012 18:05:53 -0400
Message-ID: <20121002220553.GD14471@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
 <20121002151202.GE758@redhat.com>
 <20121002205249.GR26488@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121002205249.GR26488-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 01:52:50PM -0700, Kent Overstreet wrote:
> On Tue, Oct 02, 2012 at 11:12:02AM -0400, Vivek Goyal wrote:
> > On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:
> > > This adds a pointer to the bvec array to struct bio_integrity_payload,
> > > instead of the bvecs always being inline; then the bvecs are allocated
> > > with bvec_alloc_bs().
> > 
> > Ok, you are introducing bio_vec pointer in this patch. May be we can
> > do it earlier so that we take care of bio pair related issue.
> 
> I was just trying to make the bugfix patch small, since people
> complained about too much stuff being done in one patch.

Can't we introduce the pointer while we retain bip_slabs as it is. Then
this patch will be small. I think this patch is big only because you
are trying to allocate integrity vecs from bio_set out of line.

Thanks
Vivek
