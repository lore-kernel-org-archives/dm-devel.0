From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Merging for old snapshots
Date: Tue, 7 Jul 2009 11:15:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907071101260.12962@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

The last version of snapshot-merging patches is at
http://people.redhat.com/mpatocka/patches/kernel/merging/2.6.28/series.html

The patches that hasn't been accepted so far:

# Remove unused thread
dm-snapshot-remove-unused-thread.patch
--- there is no plan to use the thread for anything, remove it.

Section "# Various chunk size patches"
--- very small fixes or optimizations, fix some misbehavior in situations 
that lvm never does (only visible if someone loads the table by hand).

# Fix the data coruption with different chunk sizes 
dm-snapshot-rework-origin-write.patch
--- this is the first big patch (the merging stuff depends on it, so it is 
compulsory to apply it). It fixes the data corruption with multiple 
snapshots with different chunk sizes. It removes completely primary_pe 
pointer and links between exceptions, because this logic is flawed by 
design.

The logic of the patch: if there are multiple pending exceptions that 
conflict with the bio, the bio is linked to any one of them. After the 
pending exception completes, the bio is rechecked again (this is the 
change from current behavior when bio is not reckecked) against remaining 
pending exceptions and if another pending exception is found, the bio is 
linked on it again ... and so on until there are no remaining exceptions, 
at this point the bio is dispatched.

I have made a testcase for this bug:
http://people.redhat.com/mpatocka/testcases/testcase-different-chunksizes-data-corruption.c
It used to corrupt the data on some older kernel but it doesn't now (but 
the bug is still present, just some timining have changed or it's because 
I use different computer) --- you can examine it and tune it to reproduce 
the bug again.

Once you get through this patch you can start with the merging patches.

Mikulas
