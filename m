From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache with a very slow device
Date: Fri, 7 Aug 2015 11:10:36 -0400
Message-ID: <20150807151036.GA4218@redhat.com>
References: <55C44489.2050101@ape3000.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <55C44489.2050101@ape3000.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lauri Niskanen <ape@ape3000.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 07 2015 at  1:39am -0400,
Lauri Niskanen <ape@ape3000.com> wrote:

> Hi,
> 
> In my understanding dm-cache is usually used with fairly fast
> spinning hard drives as the "slow" device. Because of this the cache
> is not used very aggressively and sequential accesses skip the
> cache. Is it possible to configure dm-cache for a scenario where the
> fast disk is a state-of-the-art SSD, but the slow disk is very slow
> especially so that sequential reads and writes are significantly
> slower than on the fast device?
> 
> I'd like it to work as a very aggressive writeback buffer, so that
> all or at least close to all writes are done to the fast device if
> there is at least some free non-dirty space left. And sequential
> reads should also be promoted fairly easily. In addition there
> should be aggressive demotions to make room for future promotions
> always keeping a sizable buffer available.
> 
> So the goal would be to achieve the performance characteristics of
> the fast device for all kinds of use cases even when the backing
> slow device is at least a magnitude slower.

You can disable the sequential IO bypass of the MQ policy using the
following (with a recent lvm2):
  lvchange --cachesettings 'sequential_threshold=0' <vg/lv>

This will cause all sequential IO to be considered for promotion to the
cache.  But even in "writeback" mode dm-cache isn't a purist writeback
cache like you're hoping for.  dm-cache is a hotspot cache; so by
default it will wait for evidence that promoting particular blocks is
meaningful.

With the MQ policy you can alter the default for the
write_promote_adjustment (e.g. setting it to 0) to try to get writes
promoted more aggressively.

But even with these steps the fast device likely won't be able to buffer
all IO written to the device in the hope of later writeback to the
really slow device.  You'll potentially thrash the cache if new writes
demote older blocks aggressively (not to mention partial cache block
writes will require reads from the really slow device).
