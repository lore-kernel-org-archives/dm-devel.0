From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 00/18] Clusterized exception store preparation
Date: Tue, 29 Sep 2009 18:53:25 -0400
Message-ID: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
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

This patch series provides Jon Brassow's refactored DM exceptions,
exception tables and more.  These patches form the basis upon which
Jon's clusterized exception store is built.

Given the fundamental nature of these changes, relative to code movement
and abstractions, the snapshot-merge patches must follow these patches
(particularly because of the way the hadnover snapshot exception table
handover mechanism changes relative to these patches).

Jon Brassow (18):
  dm-snap-consolidate-insert_exception-functions
  dm-exception-store-generalize-table-args
  dm-snapshot-new-ctr-table-format
  dm-snapshot-rename-dm_snap_exception-to-dm_exception
  dm-snapshot-rename-exception_table-to-dm_exception_table
  dm-snapshot-rename-exception-functions
  dm-snapshot-use-allocated-exception-tables
  dm-snapshot-exception-function-changes-1
  dm-snapshot-exception-function-changes-2
  dm-snapshot-exception-function-changes-3
  dm-snapshot-exception-function-changes-4
  dm-snapshot-exception-function-changes-5
  dm-snapshot-exception-function-changes-6
  dm-snapshot-move-exception-code-to-new-file
  dm-exception-store-create-local-exception-caches
  dm-exception-store-add-lookup_exception-to-API
  dm-snapshot-remove-completed-exception-cache
  dm-exstore-persistent-allow-metadata-reread

 drivers/md/Makefile             |    4 +-
 drivers/md/dm-exception-store.c |   36 ++--
 drivers/md/dm-exception-store.h |   92 ++-------
 drivers/md/dm-exception.c       |  163 +++++++++++++++
 drivers/md/dm-exception.h       |  104 ++++++++++
 drivers/md/dm-snap-persistent.c |  259 ++++++++++++++++++++----
 drivers/md/dm-snap-transient.c  |   88 ++++++++-
 drivers/md/dm-snap.c            |  415 ++++++++++++++-------------------------
 8 files changed, 748 insertions(+), 413 deletions(-)
 create mode 100644 drivers/md/dm-exception.c
 create mode 100644 drivers/md/dm-exception.h
