From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] dm: dm-cache fails to write the cache device in
 writethrough mode
Date: Fri, 22 Mar 2013 13:50:05 -0700
Message-ID: <20130322205005.GD5371@blackbox.djwong.org>
References: <20130322201151.GB5357@blackbox.djwong.org>
 <1363983716.3728.42.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1363983716.3728.42.camel@deadeye.wl.decadent.org.uk>
Sender: stable-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Paul Taysom <taysom@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Mar 22, 2013 at 08:21:56PM +0000, Ben Hutchings wrote:
> On Fri, 2013-03-22 at 13:11 -0700, Darrick J. Wong wrote:
> > The new writethrough strategy for dm-cache issues a bio to the origin device,
> > remaps the bio to the cache device, and issues the bio to the cache device.
> > However, the block layer modifies bi_sector and bi_size, so we need to preserve
> > these or else nothing gets written to the cache (bi_size == 0).  This fixes the
> > problem where someone writes a block through the cache, but a subsequent reread
> > (from the cache) returns old contents.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> [...]
> 
> This is not the correct way to submit a change to stable.  See
> Documentation/stable_kernel_rules.txt

Frankly, I'm not sure why agk sent the 3.9-fixes pull request to -stable.  7 of
the 10 commits are for dm-cache, and dm-cache is a new feature for 3.9.  I
probably could have dropped -stable from the cc: list when I started
complaining about bugs.  :)

Sorry about the noise.

--D
> 
> Ben.
> 
> -- 
> Ben Hutchings
> Make three consecutive correct guesses and you will be considered an expert.
