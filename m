From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 00/14] mikulas' shared snapshot patches
Date: Mon,  1 Mar 2010 19:23:44 -0500
Message-ID: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas,

This is just the full submit of your shared snapshot patches from:
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r15/

I think the next phase of review should possibly be driven through the
dm-devel mailing list.  I'd at least like the option of exchanging
mail on aspects of some of these patches.

The first patch has one small cleanup in do_origin_write(): I
eliminated the 'midcycle' goto.

But the primary difference with this submission (when compared to your
r15 patches) is I editted the patches for whitespace and typos.  I'm
_really_ not trying to step on your hard work by doing this
superficial stuff.  But while reviewing the code the insanely long
lines really were distracting.  I tried very hard to preserve the
intent of the DM_MULTISNAP_SET_ERROR/DM_ERR messages by still having
grep'able content (on a single line).

I also didn't go crazy like a checkpatch.pl zealot.. I didn't even run
these patches through checkpatch!

I know how sensitive you are about allowing the editor do the wrapping
but I trully think the length of some lines would never get past
Alasdair (or Linus) -- even though they have relaxed the rules for
line length.

I'll respond to this cover-letter with a single incremental patch that
shows my edits.

All my edits aside; I must say I'm impressed at the amount/complexity
of code you've cranked out for this shared snapshot support.  It is
going to take me many more review iterations of these patches before
I'll be able to say I understand all that these patches achieve.

I think drivers/md/dm-bufio.c will be controversial (to the greater
upstream community) but I understand that it enabled you to focus on
the problem of shared snapshots without having to concern yourself
with core VM and block changes to accomplish the same.

Mikulas Patocka (14):
  dm-multisnap-common
  dm-bufio
  dm-multisnap-mikulas-headers
  dm-multisnap-mikulas-alloc
  dm-multisnap-mikulas-blocks
  dm-multisnap-mikulas-btree
  dm-multisnap-mikulas-commit
  dm-multisnap-mikulas-delete
  dm-multisnap-mikulas-freelist
  dm-multisnap-mikulas-io
  dm-multisnap-mikulas-snaps
  dm-multisnap-mikulas-common
  dm-multisnap-mikulas-config
  dm-multisnap-daniel

 Documentation/device-mapper/dm-multisnapshot.txt |   77 +
 drivers/md/Kconfig                               |   33 +
 drivers/md/Makefile                              |   10 +
 drivers/md/dm-bufio.c                            |  987 +++++++++++
 drivers/md/dm-bufio.h                            |   35 +
 drivers/md/dm-multisnap-alloc.c                  |  590 +++++++
 drivers/md/dm-multisnap-blocks.c                 |  333 ++++
 drivers/md/dm-multisnap-btree.c                  |  838 +++++++++
 drivers/md/dm-multisnap-commit.c                 |  245 +++
 drivers/md/dm-multisnap-daniel.c                 | 1711 ++++++++++++++++++
 drivers/md/dm-multisnap-delete.c                 |  137 ++
 drivers/md/dm-multisnap-freelist.c               |  296 ++++
 drivers/md/dm-multisnap-io.c                     |  209 +++
 drivers/md/dm-multisnap-mikulas-struct.h         |  380 ++++
 drivers/md/dm-multisnap-mikulas.c                |  760 ++++++++
 drivers/md/dm-multisnap-mikulas.h                |  247 +++
 drivers/md/dm-multisnap-private.h                |  161 ++
 drivers/md/dm-multisnap-snaps.c                  |  636 +++++++
 drivers/md/dm-multisnap.c                        | 2007 ++++++++++++++++++++++
 drivers/md/dm-multisnap.h                        |  183 ++
 20 files changed, 9875 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-multisnapshot.txt
 create mode 100644 drivers/md/dm-bufio.c
 create mode 100644 drivers/md/dm-bufio.h
 create mode 100644 drivers/md/dm-multisnap-alloc.c
 create mode 100644 drivers/md/dm-multisnap-blocks.c
 create mode 100644 drivers/md/dm-multisnap-btree.c
 create mode 100644 drivers/md/dm-multisnap-commit.c
 create mode 100644 drivers/md/dm-multisnap-daniel.c
 create mode 100644 drivers/md/dm-multisnap-delete.c
 create mode 100644 drivers/md/dm-multisnap-freelist.c
 create mode 100644 drivers/md/dm-multisnap-io.c
 create mode 100644 drivers/md/dm-multisnap-mikulas-struct.h
 create mode 100644 drivers/md/dm-multisnap-mikulas.c
 create mode 100644 drivers/md/dm-multisnap-mikulas.h
 create mode 100644 drivers/md/dm-multisnap-private.h
 create mode 100644 drivers/md/dm-multisnap-snaps.c
 create mode 100644 drivers/md/dm-multisnap.c
 create mode 100644 drivers/md/dm-multisnap.h
