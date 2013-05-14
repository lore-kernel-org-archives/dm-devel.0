From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache policy mq: promotion very picky?
Date: Tue, 14 May 2013 14:44:53 +0100
Message-ID: <20130514134452.GA8304@debian>
References: <519159B7.3030205@pierre-beck.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <519159B7.3030205@pierre-beck.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, May 13, 2013 at 11:23:04PM +0200, Pierre Beck wrote:
> Maybe I'm misunderstanding how the heuristics work - what makes mq
> pick a block for promotion?

Hi Pierre,

The mq policy is indeed very picky.  The first thing I'd suggest is
you pick up my latest patches if you haven't already:

http://device-mapper.org/patches/3.10/

You just need the dm-cache*.patch ones, apply in the order given in
the series file.

At it's heart mq is v. simple.  It divides time up into slices called
'ticks'.  Hit counts are maintained for all blocks in the cache, and a
group of blocks that we're thinking of promoting.  A cache/origin
block can only be hit once in each tick.  When a candidate block's hit
count goes over a threshold it gets promoted.

The threshold depends on the hit counts of the entries in the cache.

At the moment hit counts don't degrade with time, that's something I
need to add to allow the cache to be more responsive to changing work
loads.


If you start with a discarded device (eg, you've run mkfs).  Then the
cache should fill up v. quickly with my latest patches.  Perhaps it
would be worth verifying this before you start investigating the
effects of sequential io?

- Joe
