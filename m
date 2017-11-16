From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] more device mapper changes for 4.15
Date: Thu, 16 Nov 2017 17:13:31 -0500
Message-ID: <20171116221330.GA16904@redhat.com>
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
Cc: dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

Hi Linus,

Given your expected travel I figured I'd get these fixes to you sooner
rather than later.

The following changes since commit ef7afb3656854de04fe03b0b9b4f3722b5722d8d:

  dm cache: lift common migration preparation code to alloc_migration() (2017-11-10 15:45:07 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.15/dm-changes-2

for you to fetch changes up to 74d4108d9e681dbbe4a2940ed8fdff1f6868184c:

  dm bufio: fix integer overflow when limiting maximum cache size (2017-11-16 16:49:57 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A DM multipath stable@ fix to silence an annoying error message that
  isn't _really_ an error

- A DM core @stable fix for discard support that was enabled for an
  entire DM device despite only having partial support for discards due
  to a mix of discard capabilities across the underlying devices.

- A couple other DM core discard fixes.

- A DM bufio @stable fix that resolves a 32-bit overflow

----------------------------------------------------------------
Eric Biggers (1):
      dm bufio: fix integer overflow when limiting maximum cache size

Mike Snitzer (3):
      dm: discard support requires all targets in a table support discards
      dm: do not set 'discards_supported' in targets that do not need it
      dm: clear all discard attributes in queue_limits when discards are disabled

Ming Lei (1):
      dm mpath: remove annoying message of 'blk_get_request() returned -11'

 drivers/md/dm-bufio.c      | 15 ++++++---------
 drivers/md/dm-era-target.c |  1 -
 drivers/md/dm-mpath.c      |  2 --
 drivers/md/dm-raid.c       |  6 ------
 drivers/md/dm-table.c      | 43 ++++++++++++++++++++++---------------------
 5 files changed, 28 insertions(+), 39 deletions(-)
