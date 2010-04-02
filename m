From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/7] some shared snapshot readability improvements
Date: Fri,  2 Apr 2010 01:17:51 -0400
Message-ID: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Quite a lot of churn but I think it is for the better in the end.

(I developed these changes on Wednesday but just got around to getting
them sent out now)

Mike Snitzer (7):
  document low hanging fruit to help improve code readability
  Improve name used for "persistent store" in 'struct dm_multisnap'
  Avoid exception store being confused with snapshot 's'
  Avoid struct members with the name 'dm'
  rename snapid members to use 'snapid' names
  move individual dm_multisnap 'flags' values
  Removed remaining 'struct dm_exception_store' FIXMEs.

 drivers/md/dm-multisnap-alloc.c          |  271 +++++++++---------
 drivers/md/dm-multisnap-blocks.c         |  118 ++++----
 drivers/md/dm-multisnap-btree.c          |  330 +++++++++++-----------
 drivers/md/dm-multisnap-commit.c         |  140 +++++-----
 drivers/md/dm-multisnap-daniel.c         |   32 +-
 drivers/md/dm-multisnap-delete.c         |   70 +++---
 drivers/md/dm-multisnap-freelist.c       |   96 ++++----
 drivers/md/dm-multisnap-io.c             |  148 +++++-----
 drivers/md/dm-multisnap-mikulas-struct.h |    8 +-
 drivers/md/dm-multisnap-mikulas.c        |  441 +++++++++++++++---------------
 drivers/md/dm-multisnap-mikulas.h        |  110 ++++----
 drivers/md/dm-multisnap-private.h        |    8 +-
 drivers/md/dm-multisnap-snaps.c          |  234 ++++++++--------
 drivers/md/dm-multisnap.c                |   72 +++---
 drivers/md/dm-multisnap.h                |   38 ++--
 15 files changed, 1060 insertions(+), 1056 deletions(-)
