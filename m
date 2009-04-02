From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper changes for 2.6.30
Date: Thu, 2 Apr 2009 20:23:58 +0100
Message-ID: <20090402192358.GL5098@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Cheng Renquan <crquan@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper changes for 2.6.30

Alasdair G Kergon (1):
      dm table: fix upgrade mode race

Cheng Renquan (2):
      dm target: use module refcount directly
      dm target: remove struct tt_internal

Johannes Weiner (1):
      dm crypt: use kzfree

Jonathan Brassow (12):
      dm exception store: separate type from instance
      dm raid1: add is_remote_recovering hook for clusters
      dm exception store: introduce registry
      dm exception store: move dm_target pointer
      dm exception store: move chunk_fields
      dm exception store: move cow pointer
      dm snapshot: remove dm_snap header use
      dm snapshot: remove dm_snap header
      dm snapshot: use DMEMIT macro for status
      dm snapshot: move ctr parsing to exception store
      dm snapshot: move status to exception store
      dm snapshot: persistent fix dtr cleanup

Jun'ichi Nomura (1):
      dm: path selector use module refcount directly

Mike Snitzer (2):
      dm log: use standard kernel module refcount
      dm log: remove struct dm_dirty_log_internal

Mikulas Patocka (17):
      dm: preserve bi_io_vec when resubmitting bios
      dm raid1: switch read_record from kmalloc to slab to save memory
      dm io: make sync_io uninterruptible
      dm snapshot: refactor __find_pending_exception
      dm snapshot: avoid dropping lock in __find_pending_exception
      dm snapshot: avoid having two exceptions for the same chunk
      dm: bio list add bio_list_add_head
      dm: remove unnecessary work queue type field
      dm: remove unnecessary work queue context field
      dm: remove unnecessary struct dm_wq_req
      dm: rename __split_bio
      dm: move bio_io_error into __split_and_process_bio
      dm: merge __flush_deferred_io into caller
      dm: allow uninterruptible wait for pending io
      dm: merge pushback and deferred bio lists
      dm: move wait queue declaration
      dm: set queue ordered mode

 drivers/md/dm-bio-list.h        |   10 +
 drivers/md/dm-bio-record.h      |   26 +++
 drivers/md/dm-crypt.c           |    6 +-
 drivers/md/dm-exception-store.c |  252 +++++++++++++++++++++++++
 drivers/md/dm-exception-store.h |   58 +++++-
 drivers/md/dm-io.c              |    5 +-
 drivers/md/dm-log.c             |   75 ++------
 drivers/md/dm-path-selector.c   |   21 +--
 drivers/md/dm-raid1.c           |   50 +++++-
 drivers/md/dm-snap-persistent.c |  153 +++++++++++-----
 drivers/md/dm-snap-transient.c  |   86 +++++++--
 drivers/md/dm-snap.c            |  384 ++++++++++++++++++++-------------------
 drivers/md/dm-snap.h            |  105 -----------
 drivers/md/dm-table.c           |   26 ++--
 drivers/md/dm-target.c          |  104 +++--------
 drivers/md/dm.c                 |  134 +++++---------
 drivers/md/dm.h                 |    2 +-
 include/linux/device-mapper.h   |    3 +
 include/linux/dm-dirty-log.h    |   13 ++
 19 files changed, 893 insertions(+), 620 deletions(-)
 delete mode 100644 drivers/md/dm-snap.h

Alasdair
-- 
agk@redhat.com
