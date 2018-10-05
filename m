From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.19-rc7
Date: Fri, 5 Oct 2018 15:05:25 -0400
Message-ID: <20181005190524.GA5921@redhat.com>
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: dm-devel@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Greg,

The following changes since commit 7876320f88802b22d4e2daf7eb027dd14175a0f8:

  Linux 4.19-rc4 (2018-09-16 11:52:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.19/dm-fixes-2

for you to fetch changes up to 5d07384a666d4b2f781dc056bfeec2c27fbdf383:

  dm cache: fix resize crash if user doesn't reload cache table (2018-10-04 15:20:52 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix a DM thinp __udivdi3 undefined on 32-bit bug introduced during
  4.19 merge window.

- Fix leak and dangling pointer in DM multipath's scsi_dh related code.

- A couple stable@ fixes for DM cache's resize support.

- A DM raid fix to remove "const" from decipher_sync_action()'s return
  type.

----------------------------------------------------------------
Geert Uytterhoeven (1):
      dm raid: remove bogus const from decipher_sync_action() return type

Joe Thornber (1):
      dm cache metadata: ignore hints array being too small during resize

Mike Snitzer (3):
      dm thin metadata: fix __udivdi3 undefined on 32-bit
      dm mpath: fix attached_handler_name leak and dangling hw_handler_name pointer
      dm cache: fix resize crash if user doesn't reload cache table

 drivers/md/dm-cache-metadata.c |  4 ++--
 drivers/md/dm-cache-target.c   |  9 +++++++--
 drivers/md/dm-mpath.c          | 14 ++++++++------
 drivers/md/dm-raid.c           |  2 +-
 drivers/md/dm-thin-metadata.c  |  6 ++----
 5 files changed, 20 insertions(+), 15 deletions(-)
