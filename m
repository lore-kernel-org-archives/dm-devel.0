From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.14-rc4
Date: Thu, 5 Oct 2017 16:32:48 -0400
Message-ID: <20171005203248.GA6858@redhat.com>
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
Cc: Jeffy Chen <jeffy.chen@rock-chips.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit e19b205be43d11bff638cad4487008c48d21c103:

  Linux 4.14-rc2 (2017-09-24 16:38:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.14/dm-fixes

for you to fetch changes up to 41dcf197ad5373a7dd0a4b6572aec2e3ec6a0e49:

  dm raid: fix incorrect status output at the end of a "recover" process (2017-10-05 16:21:30 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- A stable fix for the alignment of the event number reported at the
  end of the 'DM_LIST_DEVICES' ioctl.

- A couple stable fixes for the DM crypt target.

- A DM raid health status reporting fix.

----------------------------------------------------------------
Jeffy Chen (1):
      dm crypt: fix memory leak in crypt_ctr_cipher_old()

Jonathan Brassow (1):
      dm raid: fix incorrect status output at the end of a "recover" process

Mikulas Patocka (1):
      dm ioctl: fix alignment of event number in the device list

Milan Broz (1):
      dm crypt: reject sector_size feature if device length is not aligned to it

 Documentation/device-mapper/dm-raid.txt |  1 +
 drivers/md/dm-core.h                    |  1 +
 drivers/md/dm-crypt.c                   |  5 +++++
 drivers/md/dm-ioctl.c                   | 37 +++++++++++++++++++++------------
 drivers/md/dm-raid.c                    | 11 +++++-----
 drivers/md/dm.c                         | 10 +++++++--
 include/uapi/linux/dm-ioctl.h           |  4 ++--
 7 files changed, 47 insertions(+), 22 deletions(-)
