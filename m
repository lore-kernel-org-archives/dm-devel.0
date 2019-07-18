From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] additional device mapper changes for 5.3
Date: Thu, 18 Jul 2019 16:53:08 -0400
Message-ID: <20190718205308.GA65274@lobo>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>, Alasdair G Kergon <agk@redhat.com>, Nikos Tsironis <ntsironis@arrikto.com>
List-Id: dm-devel.ids

Hi Linus,

When I sent my pull last Friday I had overlooked some email that Nikos
(cc'd) sent that same morning concerning review of my dm-snapshot
discard changes that were merged over the weekend.  In addition, Nikos
inquired about his dm-kcopyd subjob size default adjustment I had
requested some changes on.  I've since dealt with those 2 issues and
staged 2 other small fixes (to dm-zoned and DM core's printk wrappers).

The following changes since commit bd293d071ffe65e645b4d8104f9d8fe15ea13862:

  dm bufio: fix deadlock with loop device (2019-07-12 09:59:37 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.3/dm-changes-2

for you to fetch changes up to 733232f8c852bcc2ad6fc1db7f4c43eb01c7c217:

  dm: use printk ratelimiting functions (2019-07-17 13:09:32 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix zone state management race in DM zoned target by eliminating
  the unnecessary DMZ_ACTIVE state.

- A couple fixes for issues the DM snapshot target's optional discard
  support added during first week of the 5.3 merge.

- Increase default size of outstanding IO that is allowed for a each
  dm-kcopyd client and introduce tunable to allow user adjust.

- Update DM core to use printk ratelimiting functions rather than
  duplicate them and in doing so fix an issue where DMDEBUG_LIMIT() rate
  limited KERN_DEBUG messages had excessive "callbacks suppressed"
  messages.

----------------------------------------------------------------
Damien Le Moal (1):
      dm zoned: fix zone state management race

Mike Snitzer (2):
      dm snapshot: fix oversights in optional discard support
      dm: use printk ratelimiting functions

Nikos Tsironis (1):
      dm kcopyd: Increase default sub-job size to 512KB

 drivers/md/dm-kcopyd.c         | 34 ++++++++++++++++++++++++++++------
 drivers/md/dm-snap.c           | 10 ++++++++++
 drivers/md/dm-zoned-metadata.c | 24 ------------------------
 drivers/md/dm-zoned.h          | 28 ++++++++++++++++++++++++----
 include/linux/device-mapper.h  | 17 ++++-------------
 5 files changed, 66 insertions(+), 47 deletions(-)
