From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fix for 3.10
Date: Sun, 19 May 2013 20:34:31 +0100
Message-ID: <20130519193431.GL3316@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.10-fixes

to get the following device-mapper fix for 3.10.

Thanks,
Alasdair


----------------------------------------------------------------
A patch to fix metadata resizing with device-mapper thin devices.

----------------------------------------------------------------
Alasdair G Kergon (1):
      dm thin: fix metadata dev resize detection

 drivers/md/dm-thin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
