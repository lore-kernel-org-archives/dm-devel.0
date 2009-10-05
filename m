From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/4] snapshot-merge preparation
Date: Mon,  5 Oct 2009 15:00:27 -0400
Message-ID: <1254769231-12053-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Preparitory patches for snapshot merging.

Mike Snitzer (1):
  dm-snapshot-refactor-associations

Mikulas Patocka (3):
  dm-snapshot-rework-origin-write
  dm-snapshot-exception-handover
  dm-exception-store-dont-read-metadata-if-going-to-handover

 drivers/md/dm-exception-store.c |   31 ++---
 drivers/md/dm-exception-store.h |   14 ++-
 drivers/md/dm-snap-persistent.c |   16 +-
 drivers/md/dm-snap-transient.c  |    8 +-
 drivers/md/dm-snap.c            |  322 +++++++++++++++++++++++----------------
 5 files changed, 225 insertions(+), 166 deletions(-)
