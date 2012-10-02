From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Date: Tue, 2 Oct 2012 15:17:23 -0700
Message-ID: <20121002221723.GX26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
 <20121002151202.GE758@redhat.com>
 <20121002205249.GR26488@google.com>
 <20121002220553.GD14471@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121002220553.GD14471@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 06:05:53PM -0400, Vivek Goyal wrote:
> On Tue, Oct 02, 2012 at 01:52:50PM -0700, Kent Overstreet wrote:
> > On Tue, Oct 02, 2012 at 11:12:02AM -0400, Vivek Goyal wrote:
> > > On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:
> > > > This adds a pointer to the bvec array to struct bio_integrity_payload,
> > > > instead of the bvecs always being inline; then the bvecs are allocated
> > > > with bvec_alloc_bs().
> > > 
> > > Ok, you are introducing bio_vec pointer in this patch. May be we can
> > > do it earlier so that we take care of bio pair related issue.
> > 
> > I was just trying to make the bugfix patch small, since people
> > complained about too much stuff being done in one patch.
> 
> Can't we introduce the pointer while we retain bip_slabs as it is. Then
> this patch will be small. I think this patch is big only because you
> are trying to allocate integrity vecs from bio_set out of line.

Ok - yeah, that makes sense to break out. I think I'll just make the
integrity stuff a separate patch series, it's going to be like 4 patches
now.
