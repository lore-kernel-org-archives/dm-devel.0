From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.8-rc3
Date: Fri, 19 Aug 2016 12:11:55 -0400
Message-ID: <20160819161154.GA23114@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 694d0d0bb2030d2e36df73e2d23d5770511dbc8d:

  Linux 4.8-rc2 (2016-08-14 19:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.8-fixes-2

for you to fetch changes up to 9e7d9367e6a29e4cac85aa6df199f760dfa39c8a:

  dm raid: support raid0 with missing metadata devices (2016-08-17 10:42:39 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- a stable fix for DM round robin multipath path selector to disable
  preemption before using this_cpu_ptr()

- a slight increase in DM crypt's mempool reserves to make swap ontop of
  DM crypt more performant

- a few DM raid fixes to issues found while testing changes that were
  merged in v4.8-rc1

----------------------------------------------------------------
Heinz Mauelshagen (4):
      dm raid: fix frozen recovery regression
      dm raid: fix restoring of failed devices regression
      dm raid: enhance attempt_restore_of_faulty_devices() to support more devices
      dm raid: support raid0 with missing metadata devices

Mike Snitzer (1):
      dm round robin: do not use this_cpu_ptr() without having preemption disabled

Mikulas Patocka (1):
      dm crypt: increase mempool reserve to better support swapping

 drivers/md/dm-crypt.c       |  2 +-
 drivers/md/dm-raid.c        | 82 ++++++++++++++++++++++++++-------------------
 drivers/md/dm-round-robin.c |  7 ++--
 3 files changed, 53 insertions(+), 38 deletions(-)
