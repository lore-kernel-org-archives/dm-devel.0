From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.2 final
Date: Thu, 27 Jun 2019 14:19:06 -0400
Message-ID: <20190627181904.GA10850@redhat.com>
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
Cc: Jerome Marchand <jmarchan@redhat.com>, zhangyi <yi.zhang@huawei.com>, Stephen Boyd <swboyd@chromium.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, Gen Zhang <blackgod016574@gmail.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 9e0babf2c06c73cda2c0cd37a1653d823adb40ec:

  Linux 5.2-rc5 (2019-06-16 08:49:45 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.2/dm-fixes-2

for you to fetch changes up to 2eba4e640b2c4161e31ae20090a53ee02a518657:

  dm verity: use message limit for data block corruption message (2019-06-25 14:09:14 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix incorrect uses of kstrndup and DM logging macros in DM's early
  init code.

- Fix DM log-writes target's handling of super block sectors so updates
  are made in order through use of completion.

- Fix DM core's argument splitting code to avoid undefined behaviour
  reported as a side-effect of UBSAN analysis on ppc64le.

- Fix DM verity target to limit the amount of error messages that can
  result from a corrupt block being found.

----------------------------------------------------------------
Gen Zhang (1):
      dm init: fix incorrect uses of kstrndup()

Jerome Marchand (1):
      dm table: don't copy from a NULL pointer in realloc_argv()

Milan Broz (1):
      dm verity: use message limit for data block corruption message

Stephen Boyd (1):
      dm init: remove trailing newline from calls to DMERR() and DMINFO()

zhangyi (F) (1):
      dm log writes: make sure super sector log updates are written in order

 drivers/md/dm-init.c          | 10 +++++-----
 drivers/md/dm-log-writes.c    | 23 +++++++++++++++++++++--
 drivers/md/dm-table.c         |  2 +-
 drivers/md/dm-verity-target.c |  4 ++--
 4 files changed, 29 insertions(+), 10 deletions(-)
