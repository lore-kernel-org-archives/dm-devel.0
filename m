From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: dm-cache performance behaviour
Date: Wed, 6 Apr 2016 04:13:49 -0800
Message-ID: <20160406121349.GA11587@kmo-pixel>
References: <20160405071253.GB27444@suselix.suse.de>
 <570378FC.3030701@redhat.com>
 <20160405140507.GG27444@suselix.suse.de>
 <20160405161226.GA17811@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160405161226.GA17811@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andreas Herrmann <aherrmann@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-bcache@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Apr 05, 2016 at 12:12:27PM -0400, Mike Snitzer wrote:
> Anyway, as Zdenek effectively: said dm-cache isn't a writecache.  If you
> need a writecache then bcache is the only option as of now.  Though
> there is an emerging DM writecache target that has stalled but can be
> revisited, see:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=writecache

bcache is still more than that, it's a combined read/writeback cache :) much
like how today we only have one pagecache for both read caching and write
caching. Main trick is you need a pretty sophisticated btree to pull that off
with good performance.
