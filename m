From: Mikulas Patocka <mpatocka@redhat.com>
Subject: A BUG in snapshot merging
Date: Tue, 22 Sep 2009 12:37:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909221130590.24935@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0909211349480.16230@hs20-bc2-1.build.redhat.com>
	<20090921175655.GA28074@redhat.com>
	<Pine.LNX.4.64.0909211815580.31653@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0909211815580.31653@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

I got this BUG when attempting to use merged patchset of Mike's and Jon's 
patches (from 
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified/2.6.31/)

I think we shouldn't join these two patchsets together. I mean, before 
clustered patches, merging was stable (I reviewed and tested it and except 
for one userspace bug (already fixed) there were no flaws) ... now it 
doesn't work.

I would recommend to leave merging as it was (i.e. stable, apply only 
little patches on it) and develop Jon's clustering on the top of merging 
and not interleave it with merging, so that the clustering patches could 
be rolled back if problems were found. When clustering will be stable and 
reviewed, it could be added to the kernel --- but it may happen later than 
merging, so don't mix it.

Mikulas

kernel BUG at drivers/md/dm-snap-persistent.c:498!
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
kcopyd(3648): Kernel bad sw trap 5 [#1]
TSTATE: 0000008080001604 TPC: 0000000010077cd4 TNPC: 0000000010077cd8 Y: 
00000000    Not tainted
TPC: <persistent_commit_merge+0xf4/0x120 [dm_snapshot]>
g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000000000 g3: 
0000000000000001
g4: fffff8003f335100 g5: 0000000000000000 g6: fffff8003baa0000 g7: 
00000000006d76c0
o0: 0000000000000036 o1: 0000000010079848 o2: 00000000000001f2 o3: 
0000000000000000
o4: 0000000000000001 o5: 0000000000000000 sp: fffff8003baa31b1 ret_pc: 
0000000010077ccc
RPC: <persistent_commit_merge+0xec/0x120 [dm_snapshot]>
l0: 0000000100384390 l1: fffff8003f77ea60 l2: 0000000000000000 l3: 
ff00000000000000
l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 
00000000f7d21000
i0: 0000000000000000 i1: 000000000000003a i2: fffff8003f588140 i3: 
0000000000000000
i4: 0000000000000000 i5: 0000000000000000 i6: fffff8003baa3271 i7: 
0000000010074ee4
I7: <merge_callback+0xa4/0x140 [dm_snapshot]>
Disabling lock debugging due to kernel taint
Caller[0000000010074ee4]: merge_callback+0xa4/0x140 [dm_snapshot]
Caller[00000000100533dc]: run_complete_job+0x3c/0x80 [dm_mod]
Caller[000000001005300c]: process_jobs+0x8c/0x180 [dm_mod]
Caller[0000000010053118]: do_work+0x18/0x60 [dm_mod]
Caller[0000000000466ad4]: worker_thread+0x134/0x220
Caller[000000000046b180]: kthread+0x60/0x80
Caller[000000000042b4b0]: kernel_thread+0x30/0x60
Caller[000000000046b070]: kthreadd+0xf0/0x1a0
Instruction DUMP: 921021f2  7c0ec8cd  90122048 <91d02005> 110401e6  
92102371  7c0ec8c8  90122048  91d02005
