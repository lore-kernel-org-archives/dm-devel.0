From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.17-rc5
Date: Thu, 10 May 2018 11:56:59 -0400
Message-ID: <20180510155658.GA20132@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Kees Cook <keescook@chromium.org>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 6da6c0db5316275015e8cc2959f12a17584aeb64:

  Linux v4.17-rc3 (2018-04-29 14:17:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.17/dm-fixes

for you to fetch changes up to 28700a36232ba61fb6ac59466821546cb25aec69:

  dm thin: update Documentation to clarify when "read_only" is valid (2018-05-10 11:18:49 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A stable fix for DM integrity to use kvfree.

- Fix for a 4.17-rc1 change to dm-bufio's buffer alignment.

- Fixes for a few sparse warnings.

- Remove VLA usage in DM mirror target.

- Improve DM thinp Documentation for the "read_only" feature.

----------------------------------------------------------------
Kees Cook (1):
      dm mirror: remove VLA usage

Mike Snitzer (3):
      dm cache background tracker: fix sparse warning
      dm: fix some sparse warnings and whitespace in dax methods
      dm thin: update Documentation to clarify when "read_only" is valid

Mikulas Patocka (2):
      dm integrity: use kvfree for kvmalloc'd memory
      dm bufio: fix buffer alignment

 Documentation/device-mapper/thin-provisioning.txt |  5 ++++-
 drivers/md/dm-bufio.c                             |  5 +++--
 drivers/md/dm-cache-background-tracker.c          |  2 +-
 drivers/md/dm-integrity.c                         |  2 +-
 drivers/md/dm-raid1.c                             | 10 ++++++----
 drivers/md/dm.c                                   |  7 ++++---
 6 files changed, 19 insertions(+), 12 deletions(-)
