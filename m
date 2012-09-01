From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 6/9] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Date: Fri, 31 Aug 2012 19:17:03 -0700
Message-ID: <20120901021703.GC19535@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-7-git-send-email-koverstreet@google.com>
 <20120828204148.GE24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828220332.GA1048@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120828220332.GA1048@moria.home.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com, bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

On Tue, Aug 28, 2012 at 03:03:32PM -0700, Kent Overstreet wrote:
> On Tue, Aug 28, 2012 at 01:41:48PM -0700, Tejun Heo wrote:
> > Hello, Kent.
> > 
> > On Tue, Aug 28, 2012 at 10:37:33AM -0700, Kent Overstreet wrote:
> > > v7: Re-add dropped comments, improv patch description
> > 
> > I don't think you did the former part.  Other than that looks good to
> > me.
> 
> I folded them into the bio_alloc_bioset() comments - so all the
> information that was there previously should still be there, just
> centralized. That good enough for your acked-by?

I think it would still be better to at least refer to
bio_alloc_bioset() from bio_alloc*()'s comments.

Thanks.

-- 
tejun
