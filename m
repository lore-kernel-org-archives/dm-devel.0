From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 3.9-rc6
Date: Sat, 6 Apr 2013 02:47:48 +0100
Message-ID: <20130406014748.GA10444@agk-dp.fab.redhat.com>
References: <20130321022625.GA25054@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130321022625.GA25054@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.9-fixes-2
 
to get the following device-mapper fixes for 3.9.

Thanks,
Alasdair
 
----------------------------------------------------------------
A pair of patches to fix the writethrough mode of the device-mapper
cache target when the device being cached is not itself wrapped with
device-mapper.

----------------------------------------------------------------
Darrick J. Wong (1):
      dm cache: fix writes to cache device in writethrough mode

Mike Snitzer (1):
      dm cache: reduce bio front_pad size in writeback mode

 drivers/md/dm-cache-target.c |   51 +++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 13 deletions(-)
