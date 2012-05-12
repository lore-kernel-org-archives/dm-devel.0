From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 3.4
Date: Sat, 12 May 2012 02:07:34 +0100
Message-ID: <20120512010734.GA20415@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Ben Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, Joe Thornber <thornber@redhat.com>, stable@kernel.org, xiaoli@redhat.com
List-Id: dm-devel.ids

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.4-fixes

to get the following device-mapper fixes for 3.4.

Thanks,
Alasdair

----------------------------------------------------------------
Device-mapper fixes for 3.4.

Fix a couple of serious memory leaks in device-mapper thin provisioning
and tidy its MODULE_DESCRIPTION.

Mitigate occasional reported hangs associated with multipath scsi_dh
module loading.

----------------------------------------------------------------
Alasdair G Kergon (1):
      dm thin: correct module description

Mike Snitzer (3):
      dm thin: reinstate missing mempool_free in cell_release_singleton
      dm thin: fix unprotected use of prepared_discards list
      dm mpath: check if scsi_dh module already loaded before trying to load

 drivers/md/dm-mpath.c |    4 ++--
 drivers/md/dm-thin.c  |   16 ++++++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)
