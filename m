From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper update for 2.6.26
Date: Fri, 25 Apr 2008 15:15:00 +0100
Message-ID: <20080425141500.GV24157@agk.fab.redhat.com>
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
Cc: Adrian Bunk <bunk@kernel.org>, "Robert P. J. Day" <rpjday@crashcourse.ca>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Frederik Deweerdt <frederik.deweerdt@gmail.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper update for 2.6.26:
 
Adrian Bunk (2):
      dm table: drop void suspend_targets return
      dm table: remove unused dm_create_error_table

Alasdair G Kergon (5):
      dm io: rename error to error_bits
      dm log: move register functions
      dm: expose macros
      dm kcopyd: rename
      dm: move include files

Frederik Deweerdt (1):
      dm: remove md argument from specific_minor

Heinz Mauelshagen (5):
      dm log: generalise name in messages
      dm log: move dirty region log code into separate module
      dm io: clean interface
      dm kcopyd: clean interface
      dm log: clean interface

Jonathan Brassow (1):
      dm log: make module use tracking internal

Mikulas Patocka (7):
      dm snapshot: fix chunksize sector conversion
      dm snapshot: store pointer to target instance
      dm kcopyd: per device
      dm kcopyd: private mempool
      dm kcopyd: remove redundant client counting
      dm raid1: use timer
      dm: unplug queues in threads

Milan Broz (2):
      dm snapshot: reduce default memory allocation
      dm crypt: add documentation

Robert P. J. Day (1):
      dm raid1: use list_split_init

 Documentation/device-mapper/dm-crypt.txt           |   52 ++++
 drivers/md/Makefile                                |    6 +-
 drivers/md/dm-exception-store.c                    |   10 +-
 drivers/md/dm-io.c                                 |   38 ++-
 drivers/md/{kcopyd.c => dm-kcopyd.c}               |  298 ++++++++------------
 drivers/md/dm-log.c                                |  254 +++++++++++------
 drivers/md/dm-raid1.c                              |  132 +++++-----
 drivers/md/dm-snap.c                               |   22 +-
 drivers/md/dm-snap.h                               |    4 +-
 drivers/md/dm-table.c                              |   42 +---
 drivers/md/dm.c                                    |   16 +-
 drivers/md/dm.h                                    |   98 +------
 drivers/md/kcopyd.h                                |   42 ---
 include/linux/device-mapper.h                      |   96 ++++++-
 .../md/dm-log.h => include/linux/dm-dirty-log.h    |   84 +++---
 {drivers/md => include/linux}/dm-io.h              |   18 +-
 include/linux/dm-kcopyd.h                          |   47 +++
 17 files changed, 659 insertions(+), 600 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-crypt.txt
 rename drivers/md/{kcopyd.c => dm-kcopyd.c} (71%)
 delete mode 100644 drivers/md/kcopyd.h
 rename drivers/md/dm-log.h => include/linux/dm-dirty-log.h (54%)
 rename {drivers/md => include/linux}/dm-io.h (84%)
 create mode 100644 include/linux/dm-kcopyd.h

Alasdair
-- 
agk@redhat.com
