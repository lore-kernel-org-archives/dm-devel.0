From: Christoph Hellwig <hch@lst.de>
Subject: Re: introduce dm-snap-mv
Date: Fri, 8 Oct 2010 10:22:31 +0200
Message-ID: <20101008082231.GA2054@lst.de>
References: <20101006083150.GA15758@zhongling> <201010071431.14937.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201010071431.14937.phillips@phunq.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Daniel Phillips <phillips@phunq.net>
Cc: Cong Meng <mcpacino@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nick Piggin <npiggin@kernel.dk>
List-Id: dm-devel.ids

On Thu, Oct 07, 2010 at 02:31:14PM -0700, Daniel Phillips wrote:
> Hi Meng,
> 
> The patch looks sensible, however the question is: why do you want to
> do this?  Would it not be better to generalize your metadata format to
> accomodate the device's native blocksize?

Even if it uses fixed 4k sectors it should just read them in smaller
chunks OR even better stop using buffer heads and just read them
manually using submit_bio.  BHs really shouldn't be used outside of
filesystems, and even there they slowly are on their way out.

