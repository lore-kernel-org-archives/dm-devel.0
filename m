From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 33] DM Snapshot exception store API changes
Date: Fri, 01 May 2009 09:15:36 -0500
Message-ID: <1241187336.22347.4.camel@hydrogen.msp.redhat.com>
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

I am revising the patches for 2.6.30-rc4; otherwise, nothing has changed
since the last post.

Patches include:
dm-exception-store-generalize-table-args.patch
dm-snapshot-new-ctr-table-format.patch
dm-snapshot-cleanup.patch
dm-snap-rename-dm_snap_exception-to-dm_exception.patch
dm-snap-rename-exception_table-to-dm_exception_table.patch
dm-snap-consolidate-insert_exception-functions.patch
dm-snap-rename-exception-functions.patch
dm-snap-use-allocated-exception-tables.patch
dm-snap-exception-function-changes-1.patch
dm-snap-exception-function-changes-2.patch
dm-snap-exception-function-changes-3.patch
dm-snap-exception-function-changes-4.patch
dm-snap-exception-function-changes-5.patch
dm-snap-exception-function-changes-6.patch
dm-snap-move-exception-code-to-new-file.patch
dm-snap-persistent-store-minor-code-cleanup.patch
dm-exception-store-add-resume-to-API.patch
dm-exception-store-populate-cache-on-commit.patch
dm-exception-store-add-lookup_exception-to-API.patch
dm-snap-remove-completed-exception-cache.patch
dm-snap-small-code-optimization.patch
dm-exception-store-remove-read_metadata-from-API.patch
dm-exception-store-add-suspend-to-API.patch
dm-exception-store-rename-drop_snapshot.patch
dm-exception-store-add-shared_uuid.patch
dm-exception-store-add-arg-to-prepare_commit.patch
dm-exception-store-add-arg-to-lookup_exception.patch
dm-snap-get-rid-of-init_hash_tables-fn.patch
dm-snap-get-rid-of-__free_exceptions-fn.patch
dm-snap-split-ctr-and-dtr.patch
dm-snap-change-parameters-to-__lookup_pending_exception.patch
dm-snap-introduce-snapshare.patch
dm-snap-utilize-snapshare.patch

You can find these patches in a tarball (along with all the other
patches that precede them in agk's tree) at
http://www.brassow.com/patches

 brassow
