From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache selective promotion of block
Date: Thu, 17 Dec 2015 16:18:06 -0500
Message-ID: <20151217211805.GD25386@redhat.com>
References: <567308D6.8030306@nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <567308D6.8030306@nasa.gov>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mahmoud Hanafi <mahmoud.hanafi@nasa.gov>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 17 2015 at  2:11pm -0500,
Mahmoud Hanafi <mahmoud.hanafi@nasa.gov> wrote:

> We are experimenting with dm-cache and would like to be able to
> promote a range of block and pin them in the cache device.
> 
> Are there any tool that can be used for this?

There isn't an interface to do that right now.  But it _should_ be
possible to add a DM message to easily promote an origin block range.
Pinning isn't something we really do at this point so that'd require
more work.

But it could look something like this:
dmsetup message <cache_dev> 0 promote_oblocks <start> <end>
dmsetup message <cache_dev> 0 pin_oblocks <start> <end>

and:
dmsetup message <cache_dev> 0 demote_oblocks <start> <end>
dmsetup message <cache_dev> 0 unpin_oblocks <start> <end>

(where <start> and <end> are in either cache_block_size units or 512b
sectors... not sure which would be best, sectors is a bit more
approachable)

I could see this getting a bit cumbersome, not to mention the smq cache
policy really _should_ promote if it makes sense to cache a block, but
we'll certainly need Joe's thoughts on this.

Mike
