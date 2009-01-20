From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 0 of 12]  New exception store API
Date: Tue, 20 Jan 2009 13:47:19 -0600
Message-ID: <1232480839.19993.10.camel@hydrogen.msp.redhat.com>
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

The following 12 patches introduce the new exception store API.  (Thanks
to agk for doing most of the work to break-up the original large patch.)
These patches introduce the API that satisfies today's exception stores
(i.e. "persistent" and "transient").  I have not expanded the API to
include what is necessary for the "shared" and "clustered" exception
stores yet.  I hope we can get these pushed first.

agk, you broke up my original patch, which I then broke up some more,
tested, and bug fixed.

Patch names are:
1 of 12: dm-exception-store-separate-type-from-instance.patch
2 of 12: dm-exception-store-introduce-registry.patch
3 of 12: dm-exception-store-move-dm_target-pointer.patch
4 of 12: dm-exception-store-move-chunk_fields.patch
5 of 12: dm-exception-store-move-cow-pointer.patch
6 of 12: dm-snapshot-remove-dm_snap-header-use.patch
7 of 12: dm-snapshot-remove-dm_snap-header.patch
8 of 12: dm-snapshot-use-DMEMIT-macro-for-status.patch
9 of 12: dm-snapshot-move-ctr-parsing-to-exception-store.patch
10 of 12: dm-snapshot-move-status-to-exception-store.patch
11 of 12: dm-exception-store-generalize-table-args.patch
12 of 12: dm-snapshot-new-ctr-table-format.patch

 brassow
