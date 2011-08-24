From: Mike Snitzer <snitzer@redhat.com>
Subject: [CRAZY RFC PATCH 0/4] dm: share mempools for all
	request-based DM devices
Date: Wed, 24 Aug 2011 19:05:09 -0400
Message-ID: <1314227109-6627-1-git-send-email-snitzer@redhat.com>
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
To: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Request-based DM requires considerably larger mempool reserves than
bio-based DM given that it must clone requests (which may contain
multiple bios) rather than simply cloning bios.

It was reported that bio-based dm-multipath was able to be tested with
1024 mpath devices and failover/failback under load on a server with
only 2 GB of memory.  The same test fails with request-based
dm-multipath because of the increase in bio reserves (biovec-256).

Patches are available here but I'm too ashamed to actually post them
to the list:
http://people.redhat.com/msnitzer/patches/upstream/dm-rq-based-mempool-sharing/

In the end it would likely be best if we simply automatically scaled
RESERVED_REQUEST_BASED_IOS back if the system has low amounts of
memory (say 128 if 4GB, 64 if 3GB, 32 if 2GB, 16 if 1GB) -- this would
result in ~1600MB, ~800MB, ~400MB, and ~200MB (respectively) of slab
reserves for 1024 multipath devices (or 600, 300, 150, 75 MB
respectively if integrity support isn't needed -- yeah bip-256 brings
the pain given objperslab=1 and pagesperslab=2!).

Additional Background:

The relevant slab use for bio-based vs request-based for 1024 devices
is:

bios-based:
bio-0 3.19921875 MB
biovec-256 64.0 MB
bip-256 128.0 MB
dm_io 1.7265625 MB
dm_target_io 0.44140625 MB

total: 197.3671875 MB

request-based:
bio-0 51.19921875 MB
biovec-256 1024.0 MB
bip-256 2048.0 MB
dm_mpath_io 5.06640625 MB
dm_rq_clone_bio_info 5.06640625 MB
dm_rq_target_io 102.3984375 MB

total: 3235.73046875 MB

Above was generated with: bio_vs_rq_slab_usage.py 1024 256
http://people.redhat.com/msnitzer/patches/upstream/dm-rq-based-mempool-sharing/bio_vs_rq_slab_usage.py

Commit a91a2785b200 ("block: Require subsystems to explicitly allocate
bio_set integrity mempool") eliminated unnecessary slab use (bip-256
reserves for all 1024 devices consume 2 GB!) but the system still failed
to boot because of multipathd consuming too much memory.

Mike Snitzer (4):
  dm: share mempools for all request-based DM devices
  dm: increase RESERVED_REQUEST_BASED_IOS
  dm table: disallow stacking request-based DM devices
  dm: add reserved_rq_based_ios module parameter

 drivers/md/dm-table.c |    9 +++
 drivers/md/dm.c       |  166 +++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 156 insertions(+), 19 deletions(-)
