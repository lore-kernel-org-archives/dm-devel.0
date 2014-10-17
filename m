From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 00/17] dm thin: performance improvements
Date: Fri, 17 Oct 2014 02:06:50 -0400
Message-ID: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Here is a patchset that Joe and I have been working on for the past 2
weeks to address various performance problems reported against DM thin
provisioning.  DM thinp is now much more capable in the face of heavy
IO (be it random or sequential, multithreaded, etc).

I've just added these patches to linux-dm.git's 'for-next' branch so
that these changes get early exposure/testing for 3.19 inclusion.

Of all the changes the "dm bufio: evict buffers that are past the max
age but retain some buffers" is in the most need of review relative to
upstream code (given it is so different than the RHEL code we also
support -- due to shrinker differences).

Any review/testing is always appreciated, thanks.
Mike

BTW, Mikulas: I had a quick look at your dm-bufio
'max_kept_cache_size_bytes' patch but I need to review it closer (it
seemed a bit too elaborate but I'll revisit).  I also still need to
review/stage your dm-bufio-ratio.patch

Joe Thornber (13):
  dm bufio: switch from a huge hash table to an rbtree
  dm bufio: evict buffers that are past the max age but retain some buffers
  dm bio prison: switch to using a red black tree
  dm thin metadata: change dm_thin_find_block to allow blocking, but not issuing, IO
  dm transaction manager: add support for prefetching blocks of metadata
  dm thin: prefetch missing metadata pages
  dm thin: throttle incoming IO
  dm thin: grab a virtual cell before looking up the mapping
  dm thin: performance improvement to discard processing
  dm thin: defer whole cells rather than individual bios
  dm thin: remap the bios in a cell immediately
  dm thin: direct dispatch when breaking sharing
  dm thin: sort the deferred cells

Mike Snitzer (4):
  dm thin: adjust max_sectors_kb based on thinp blocksize
  dm: improve documentation and code clarity in dm_merge_bvec
  dm thin: implement thin_merge
  dm thin: factor out remap_and_issue_overwrite

 drivers/md/dm-bio-prison.c                         | 186 ++++---
 drivers/md/dm-bio-prison.h                         |  16 +-
 drivers/md/dm-bufio.c                              | 206 +++++---
 drivers/md/dm-cache-target.c                       |   3 +-
 drivers/md/dm-thin-metadata.c                      |  35 +-
 drivers/md/dm-thin-metadata.h                      |   9 +-
 drivers/md/dm-thin.c                               | 574 +++++++++++++++++----
 drivers/md/dm.c                                    |  12 +-
 .../md/persistent-data/dm-transaction-manager.c    |  77 ++-
 .../md/persistent-data/dm-transaction-manager.h    |   7 +
 10 files changed, 804 insertions(+), 321 deletions(-)

-- 
1.9.3
