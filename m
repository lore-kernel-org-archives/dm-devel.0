From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCHES] shared snapshots release 18
Date: Fri, 26 Mar 2010 20:35:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003262024080.6303@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I released version 18 of shared snapshots. See 
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r18/

It contains a variable to tune cache memory consumption.

I decided to place it as a module parameter, to 
/sys/module/dm_store_mikulas/parameters/dm_bufio_cache_size It is one 
setting, the cache is divided fairly for all the instances. I may come up 
with some sort of adaptive sharing (i.e. shrink cache for unused caches 
and allow the space to be used by used)


Other options, where to place the configuration are:

*** On lvm command line, passed through dm table line (or messages):
+ could be saved in lvm2 metadata
- the cache management policy may change and require additional parameters 
or drop the existing parameter, if memory management people provide us 
with a callback to free cache. This leads to a situation where kernel and 
userspace needs synchronization. For the same reason, vm or tcpip tunables 
are exported in /proc and are not set with an userspace utility --- the 
tunables change from kernel to kernel.

*** Create a directory and file in /proc
+ /proc is disorganized, so we can create what we want there
- /proc is disorganized, so people don't want to add new stuff there

*** Set it individually for each block device
+ it is understandable for the admin
- it is logicaly wrong, because dm targets don't correspond to block 
devices (for example, if we have two targets in a table for one device, 
how does one setting affect the targets?). dm-bufio doesn't know 
anything about the device it is used for and it would need a lot of glue 
code.

Mikulas
