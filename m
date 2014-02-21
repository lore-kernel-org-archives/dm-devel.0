From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-dm-3.14-fixes 0/8] dm thin: address a few
	fundamental problems
Date: Thu, 20 Feb 2014 21:55:57 -0500
Message-ID: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
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

This patchset fixes various thinp issues.  Aside from fixing some bugs
in earlier 3.14-rc1 code (as noted with commit references): the most
significant issue addressed is that until now we didn't have the
awareness or ability to force the user to perform consistency checks
on the thin pool's metadata and data if warranted.

While there is a fair amount of change here I feel pretty strongly
that these fixes should get upstream ASAP.  Posting for review with
the hope that I'll get timely feedback/acks so that I can send to
Linus early next week.

(Alasdair, I went with "needs check" for the flag used in patch 7 even
though you initially disagreed with the name.. it is short and to the
point, and really: it is internal to the thin implementation.
Userspace can spin it however you'd like).

Mike Snitzer (8):
  dm thin: synchronize the pool mode during suspend
  dm thin: set flag when over the metadata low watermark threshold
  dm thin: set flag if metadata is out of space
  dm thin: error out I/O if inappropriate for it to be retried
  dm thin: fix the error path for the thin device constructor
  dm thin: fix pool_preresume resize with heavy IO races
  dm thin: ensure user takes action to validate data and metadata consistency
  dm thin: allow metadata space larger than supported to go unused

 Documentation/device-mapper/cache.txt              |  11 +-
 Documentation/device-mapper/thin-provisioning.txt  |  28 +++
 drivers/md/dm-cache-metadata.c                     |   2 +-
 drivers/md/dm-thin-metadata.c                      | 118 ++++++++++-
 drivers/md/dm-thin-metadata.h                      |  23 ++-
 drivers/md/dm-thin.c                               | 225 ++++++++++++++++-----
 drivers/md/persistent-data/dm-space-map-metadata.c |  19 +-
 .../md/persistent-data/dm-transaction-manager.c    |  13 +-
 .../md/persistent-data/dm-transaction-manager.h    |   2 +-
 9 files changed, 350 insertions(+), 91 deletions(-)

-- 
1.8.3.1
