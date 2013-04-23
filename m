From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: NULL pointer due to malformed bcache bio
Date: Tue, 23 Apr 2013 12:35:51 -0400
Message-ID: <20130423163551.GA9958@redhat.com>
References: <20130410205439.GA18092@redhat.com>
 <20130422212218.GA4704@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130422212218.GA4704@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk
List-Id: dm-devel.ids

On Mon, Apr 22 2013 at  5:22pm -0400,
Kent Overstreet <koverstreet@google.com> wrote:

> On Wed, Apr 10, 2013 at 04:54:40PM -0400, Mike Snitzer wrote:
> > Hey,
> > 
> > So DM core clearly needs to be more defensive about the possibility for
> > a NULL return from bio_alloc_bioset() given I'm hitting a NULL pointer
> > in DM's alloc_tio() because nr_iovecs=512.  bio_alloc_bioset()'s call to
> > bvec_alloc() only supports nr_iovecs up to BIO_MAX_PAGES (256).
> 
> I have a fix for this queued up in my bcache-for-upstream, if you want
> to check and make sure it works.

Works for me, thanks.
