From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.15 final
Date: Fri, 19 Jan 2018 17:03:16 -0500
Message-ID: <20180119220315.GA30994@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Thornber <thornber@redhat.com>, Dennis Yang <dennisyang@qnap.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Wei Yongjun <weiyongjun1@huawei.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 1291a0d5049dbc06baaaf66a9ff3f53db493b19b:

  Linux 4.15-rc4 (2017-12-17 18:59:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.15/dm-fixes-2

for you to fetch changes up to 3cc2e57c4beabcbbaa46e1ac6d77ca8276a4a42d:

  dm crypt: fix error return code in crypt_ctr() (2018-01-17 09:10:55 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
All stable@ fixes:

- Fix DM thinp btree corruption seen when inserting a new key/value pair
  into a full root node.

- Fix DM thinp btree removal deadlock due to artificially low number of
  allowed concurrent locks allowed.

- Fix possible DM crypt corruption if kernel keyring service is used.
  Only affects ciphers using following IVs: essiv, lmk and tcw.

- Two DM crypt device initialization error checking fixes.

- Fix DM integrity to allow use of async ciphers that require DMA.

----------------------------------------------------------------
Dennis Yang (1):
      dm thin metadata: THIN_MAX_CONCURRENT_LOCKS should be 6

Joe Thornber (1):
      dm btree: fix serious bug in btree_split_beneath()

Mikulas Patocka (1):
      dm integrity: don't store cipher request on the stack

Milan Broz (1):
      dm crypt: fix crash by adding missing check for auth key size

Ondrej Kozina (1):
      dm crypt: wipe kernel key copy after IV initialization

Wei Yongjun (1):
      dm crypt: fix error return code in crypt_ctr()

 drivers/md/dm-crypt.c                 | 20 ++++++++++----
 drivers/md/dm-integrity.c             | 49 ++++++++++++++++++++++++++---------
 drivers/md/dm-thin-metadata.c         |  6 ++++-
 drivers/md/persistent-data/dm-btree.c | 19 ++------------
 4 files changed, 59 insertions(+), 35 deletions(-)
