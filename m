From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 17] DM exception store API alterations
Date: Fri, 20 Feb 2009 17:08:36 -0600
Message-ID: <1235171319.24593.14.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

I am requesting comments on the next set of patches.  They are the next
batch in a series designed to create/reshape the exception store API
(currently used by snapshots).  Since this is the second batch, the
following patches are prerequisites:
  1) dm-exception-store-introduce-registry.patch
  2) dm-exception-store-move-dm_target-pointer.patch
  3) dm-exception-store-move-chunk_fields.patch
  4) dm-exception-store-move-cow-pointer.patch
  5) dm-snapshot-remove-dm_snap-header-use.patch
  6) dm-snapshot-remove-dm_snap-header.patch
  7) dm-snapshot-use-DMEMIT-macro-for-status.patch
  8) dm-snapshot-move-ctr-parsing-to-exception-store.patch
  9) dm-snapshot-move-status-to-exception-store.patch
  10) dm-exception-store-generalize-table-args.patch
  11) dm-snapshot-new-ctr-table-format.patch
  12) dm-snapshot-cleanup.patch
  13) dm-snap-minor-fix.patch (the one I just sent but didn't explicitly
name)

The patches to follow I've preliminarily named:
   1) dm-snap-rename-dm_snap_exception.patch
   2) dm-snap-rename-exception_table.patch
   3) dm-snap-consolidate-insert_exception.patch
   4) dm-snap-rename-exception-functions.patch
   5) dm-snap-exception_table-ptrs.patch
   6) dm-snap-exception-arg-changes.patch
   7) dm-snap-code-move.patch
   8) dm-snap-persistent-minor-code-cleanup.patch
   9) dm-exception-store-add-resume-to-API.patch
   10) dm-exception-stores-populate-cache-on-commit.patch
   11) dm-exception-store-add-lookup-to-API.patch
   12) dm-snap-remove-completed-exception-cache.patch
   13) dm-snap-possible-code-optimization.patch
   14) dm-exception-store-remove-read_metadata-from-API.patch
   15) dm-exception-store-add-suspend-to-API.patch
   16) dm-exception-store-rename-drop_snapshot.patch
   17) dm-exception-store-clusterized-type.patch
These patches are designed to make a useful interface for the next
generation of exception store implementations - including "shared" and
"cluster-aware" types.

 brassow
