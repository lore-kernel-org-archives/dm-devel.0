From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.0-rc5
Date: Fri, 20 Mar 2015 16:31:58 -0400
Message-ID: <20150320203157.GA3735@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit c517d838eb7d07bbe9507871fab3931deccff539:

  Linux 4.0-rc1 (2015-02-22 18:21:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.0-fixes

for you to fetch changes up to e5db29806b99ce2b2640d2e4d4fcb983cea115c5:

  dm io: deal with wandering queue limits when handling REQ_DISCARD and REQ_WRITE_SAME (2015-02-27 14:53:32 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
A handful of stable fixes for DM:
- fix thin target to always zero-fill reads to unprovisioned blocks
- fix to interlock device destruction's suspend from internal suspends
- fix 2 snapshot exception store handover bugs
- fix dm-io to cope with DISCARD and WRITE_SAME capabilities changing

----------------------------------------------------------------
Darrick J. Wong (1):
      dm io: deal with wandering queue limits when handling REQ_DISCARD and REQ_WRITE_SAME

Joe Thornber (1):
      dm thin: fix to consistently zero-fill reads to unprovisioned blocks

Mikulas Patocka (3):
      dm: hold suspend_lock while suspending device during device deletion
      dm snapshot: suspend origin when doing exception handover
      dm snapshot: suspend merging snapshot when doing exception handover

 drivers/md/dm-io.c            |  15 ++++--
 drivers/md/dm-snap.c          | 120 ++++++++++++++++++++++++++++++++++++++----
 drivers/md/dm-thin.c          |  11 ----
 drivers/md/dm.c               |  21 ++++++++
 include/linux/device-mapper.h |   1 +
 5 files changed, 142 insertions(+), 26 deletions(-)
