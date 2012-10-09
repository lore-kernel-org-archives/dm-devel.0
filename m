From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Date: Tue, 9 Oct 2012 14:31:11 -0700
Message-ID: <20121009213111.GE29494@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121009182949.GO26187@lenny.home.zabbo.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tytso@mit.edu
List-Id: dm-devel.ids

On Tue, Oct 09, 2012 at 11:29:49AM -0700, Zach Brown wrote:
> On Mon, Oct 08, 2012 at 11:39:19PM -0700, Kent Overstreet wrote:
> > It simplifies a lot of stuff if the ringbuffer is contiguously mapped
> > into kernel space, and we can delete a lot of code - in particular, this
> > is useful for converting read_events() to cmpxchg.
> 
> 1) I'm concerned that Our Favourite Database Benchmarkers will see an
> effect of having more TLB pressure from that mapping.  kmap_atomic()
> should be cheaper.  We'll need to measure the difference.

If it is measurable I'll take another stab at using memory from
__get_free_pages() for the ringbuffer. That really would be the ideal
solution.

The other reason I wanted to do this was for the aio attributes stuff -
for return values, I think the only sane way is for the return values to
go in the ringbuffer, which means records are no longer fixed size so
dealing with pages is even more of a pain.
