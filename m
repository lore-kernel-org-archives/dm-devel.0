From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] last-minute device-mapper fix for 3.4
Date: Sat, 19 May 2012 01:33:03 +0100
Message-ID: <20120519003302.GB20415@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Joe Thornber <thornber@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

If it's not too late, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.4-fixes-2

to get a last-minute fix for a problem discovered a couple of days ago.

Thanks,
Alasdair
 
----------------------------------------------------------------
A fix to the thin provisioning userspace interface.

----------------------------------------------------------------
Mike Snitzer (1):
      dm thin: fix table output when pool target disables discard passdown internally

 drivers/md/dm-thin.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)
