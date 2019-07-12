From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.3
Date: Fri, 12 Jul 2019 15:05:52 -0400
Message-ID: <20190712190552.GA52544@lobo>
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
Cc: Pavel Begunkov <asml.silence@gmail.com>, Zhengyuan Liu <liuzhengyuan@kylinos.cn>, Junxiao Bi <junxiao.bi@oracle.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Qu Wenruo <wqu@suse.com>, Fuqian Huang <huangfq.daxian@gmail.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

Merging these DM changes will require manual conflict resolution in the
snapshot target's Documentation updates due to conflicts with the
shotgun blast of RST changes to DM documentation that I didn't ack but
got in anyway -- clearly the RST Documentation train brakes for nobody ;)
Feel free to have a look at the test merge I did in the linux-dm.git
'dm-5.3-merge' branch.

Also, you'll note that the last 2 commits of this pull were rebased
today; I did that because the dm-bufio fix's commit header needed a lot
of grammar fixes and was also missing the stable@vger.kernel.org Cc.

The following changes since commit 2eba4e640b2c4161e31ae20090a53ee02a518657:

  dm verity: use message limit for data block corruption message (2019-06-25 14:09:14 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.3/dm-changes

for you to fetch changes up to bd293d071ffe65e645b4d8104f9d8fe15ea13862:

  dm bufio: fix deadlock with loop device (2019-07-12 09:59:37 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Add encrypted byte-offset initialization vector (eboiv) to DM crypt.

- Add optional discard features to DM snapshot which allow freeing space
  from a DM device whose free space was exhausted.

- Various small improvements to use struct_size() and kzalloc().

- Fix to check if DM thin metadata is in fail_io mode before attempting
  to update the superblock to set the needs_check flag.  Otherwise the
  DM thin-pool can hang.

- Fix DM bufio shrinker's potential for ABBA recursion deadlock with DM
  thin provisioning on loop usecase.

----------------------------------------------------------------
Fuqian Huang (1):
      dm integrity: use kzalloc() instead of kmalloc() + memset()

Junxiao Bi (1):
      dm bufio: fix deadlock with loop device

Mike Snitzer (2):
      dm thin metadata: check if in fail_io mode when setting needs_check
      dm snapshot: add optional discard support features

Milan Broz (4):
      dm integrity: always set version on superblock update
      dm crypt: wipe private IV struct after key invalid flag is set
      dm crypt: remove obsolete comment about plumb IV
      dm crypt: implement eboiv - encrypted byte-offset initialization vector

Pavel Begunkov (1):
      dm: update stale comment in end_clone_bio()

Qu Wenruo (1):
      dm log writes: fix incorrect comment about the logged sequence example

Zhengyuan Liu (2):
      dm crypt: use struct_size() when allocating encryption context
      dm log writes: use struct_size() to calculate size of pending_block

 Documentation/device-mapper/snapshot.txt |  16 +++
 drivers/md/dm-bufio.c                    |   4 +-
 drivers/md/dm-crypt.c                    | 101 +++++++++++++++--
 drivers/md/dm-integrity.c                |   7 +-
 drivers/md/dm-log-writes.c               |   4 +-
 drivers/md/dm-rq.c                       |   2 +-
 drivers/md/dm-snap.c                     | 186 +++++++++++++++++++++++++++----
 drivers/md/dm-thin-metadata.c            |   7 +-
 8 files changed, 284 insertions(+), 43 deletions(-)
