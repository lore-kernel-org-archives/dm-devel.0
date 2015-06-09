From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/4] Integrate dm-latency functionality to
	dm-statistics
Date: Tue, 9 Jun 2015 17:20:46 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Coly Li <colyli@gmail.com>
Cc: Tao Ma <boyu.mt@taobao.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Robin Dong <sanbai@alibaba-inc.com>
List-Id: dm-devel.ids

Hi

Here I'm sending patches that add funcionality provided by dm-latency into 
dm-statistics framework. Dm-latency was introduced in this post 
https://www.redhat.com/archives/dm-devel/2015-February/msg00158.html , 
however, there is already similar framework dm-statistics in the kernel. 
In order to have cleaner and easier to maintain code, it is better to 
integrate dm-latency functionality into dm-statistics, rather than having 
two frameworks that do similar things.

This patch series makes these changes:
* it is possible to use precise time measurement with nanosecond 
  granularity (previously, time was measured in jiffies)
* it is possible to collect histogram of latencies. The histogram 
  boundaries may be selected by the user and there is unlimited number of 
  possible boundaries (in dm-latency, the histogram boundaries were fixed)
* it is possible to use dm-statistics on multipath

The documentation of these extensions is in 
Documentation/device-mapper/statistics.txt

I'd like to ask people who designed dm-latency to check this patchset, try 
to use it and tell us if it provides sufficient functionality to them (the 
indended functinality of dm-latency was to predict hard disk failures from 
i/o request latency histogram).

Mikulas
