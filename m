From: Daniel Phillips <phillips@phunq.net>
Subject: Re: introduce dm-snap-mv
Date: Fri, 8 Oct 2010 06:22:57 -0700
Message-ID: <201010080622.58095.phillips@phunq.net>
References: <20101006083150.GA15758@zhongling> <AANLkTim9KFuP1_mrUUsMOEspxkfA=SZW2dmTX4WJbfep@mail.gmail.com> <20101008092427.GA5426@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008092427.GA5426@lst.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: McPacino <mcpacino@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>
List-Id: dm-devel.ids

On Friday 08 October 2010, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 05:14:27PM +0800, McPacino wrote:
> > Hi Christoph,
> > 
> > I have to take care the cache problem If using the bio directly.
> > BHs can be released by kernel when necessary.
> > 
> > Is there any existing code using bio to read/write metadata
> > blocks? How do they handle the timing freeing bios? I really
> > wish to learn something form it.
> 
> If you actually need caching just use the pagecache, e.g.
> read_mapping_page to read in your data.  That completely abstracts
> away the underlying block size.

And that will automatically give him the PAGE_CACHE_SIZE objects he
wants.  I still don't understand why his model cannot be generalized
to arbitrary block size specifiable at create time.

Regards,

Daniel
