From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] Further device-mapper fixes for 3.8
Date: Fri, 1 Feb 2013 00:53:08 +0000
Message-ID: <20130201005308.GG3228@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Daniel Browning <db@kavod.com>, linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.8-fixes-2

to get the following device-mapper fixes for 3.8.
 
Thanks,
Alasdair
  
----------------------------------------------------------------
A fix for stacked dm thin devices and a fix for the new dm WRITE SAME
support.

----------------------------------------------------------------
Alasdair G Kergon (1):
      dm: fix write same requests counting

Mike Snitzer (1):
      dm thin: fix queue limits stacking

 drivers/md/dm-thin.c |   13 +------------
 drivers/md/dm.c      |    6 ++++--
 2 files changed, 5 insertions(+), 14 deletions(-)
