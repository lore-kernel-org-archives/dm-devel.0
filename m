From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 0/3] dm-zoned: harden error handling
Date: Sat, 10 Aug 2019 14:43:08 -0700
Message-ID: <20190810214311.9503-1-dmitry.fomichev@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

This series contains a few patches aimed to make dm-zoned properly
handle backing zoned storage device failures.

The following test environment was used to trigger device failures:
A 100% write file I/O fio workload was run against an XFS volume
created on top of a dm-zoned target device. The dm-zoned device,
in turn, was created on top of a zoned device provisioned by
tcmu-runner ZBC file handler. The backing storage file for the
tcmu-runner handler has been created on a separate ext4 file system.

Two different failure modes were tested -
1. Removal of the tcmu-runner device under I/O
2. Complete failure of the backing storage of tcmu-runner under I/O

In both of these test cases, dm-zoned has been observed to hang and
the only possible remedy to recover from that state was to reboot the
test system. The fio test script would also hang forever.

With these patches in place, the test script properly reports the
error and exits. After that, it is possible to remove the dm-zoned
target device and then recreate it with some working backup storage
without rebooting the system.

v1 -> v2:	- don't set dm-zoned disk read-only after BD failure

Dmitry Fomichev (3):
  dm-zoned: improve error handling in reclaim
  dm-zoned: improve error handling in i/o map code
  dm-zoned: properly handle backing device failure

 drivers/md/dm-zoned-metadata.c | 55 ++++++++++++++++++++++------
 drivers/md/dm-zoned-reclaim.c  | 44 +++++++++++++++++-----
 drivers/md/dm-zoned-target.c   | 67 ++++++++++++++++++++++++++++++----
 drivers/md/dm-zoned.h          | 10 +++++
 4 files changed, 146 insertions(+), 30 deletions(-)

-- 
2.21.0
