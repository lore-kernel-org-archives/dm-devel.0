From: Lauri Niskanen <ape@ape3000.com>
Subject: dm-cache with a very slow device
Date: Fri, 7 Aug 2015 08:39:21 +0300
Message-ID: <55C44489.2050101@ape3000.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

In my understanding dm-cache is usually used with fairly fast spinning 
hard drives as the "slow" device. Because of this the cache is not used 
very aggressively and sequential accesses skip the cache. Is it possible 
to configure dm-cache for a scenario where the fast disk is a 
state-of-the-art SSD, but the slow disk is very slow especially so that 
sequential reads and writes are significantly slower than on the fast 
device?

I'd like it to work as a very aggressive writeback buffer, so that all 
or at least close to all writes are done to the fast device if there is 
at least some free non-dirty space left. And sequential reads should 
also be promoted fairly easily. In addition there should be aggressive 
demotions to make room for future promotions always keeping a sizable 
buffer available.

So the goal would be to achieve the performance characteristics of the 
fast device for all kinds of use cases even when the backing slow device 
is at least a magnitude slower.

-- 
Lauri Niskanen
