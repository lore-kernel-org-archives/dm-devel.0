From: Damir Dezeljin <programing@mbss.org>
Subject: Snapshot hang problem
Date: Mon, 20 Jun 2005 14:46:30 +0100 (GMT-1)
Message-ID: <Pine.LNX.4.44.0506201408390.4911-100000@Server.mbss.org>
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
To: dm-Devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi.

I'm experiencing a LVM (dm) hang during a live volume snapshot creation.
I'm using FC4 with a custom built 2.6.12 kernel on a dual P_III 1.3 GHz /
1GB RAM / 1 IDE ATA HDD.

I started a 'dd':
----
dd if=/dev/urandom of=/lvm_part/file.oput bs=1M count=3000
----

After cca. 200 MB were written, I started creating snapshots of the
mentioned volume:
----
i=1
while ((i<=20)); do
  lvcreate -s -L 320M -n s${i} -p r /dev/vg00/test01
  let i=i+1
done
----

The affected LVM volume + underlying 'dm' freezed during creation of the
5th snapshot - afterwards any I/O on the affected volume freeze too (e.g.
'echo blabla > /lvm_part/file.out' (only 'ls' was still working). Any
'LVM' command for the affected volume group (e.g. 'lvscan',
'vgdisplay',...) freeze too.
I/O on a volume in the same volume group was still working.

I had to reboot to solve the problem.


I found some threads with similar problems:
- https://www.redhat.com/archives/dm-devel/2005-February/msg00009.html
- http://marc.theaimsgroup.com/?t=110507495500002&r=1&w=2

I guess my problem is related to the above threads, however it seams it is
not exactly the same - it seams to me that I'm not going out of memory
(see below).


Do anyone have a hint what's going on? Is there any kernel patch that fix
the mentioned problem? If not ... any hint where should I start? << I
have to fix the problem :)


# cat /proc/slabinfo | head -2; cat /proc/slabinfo |grep -e dm -e jour -e
bio -e ext3
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab>
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata
<active_slabs> <num_slabs> <sharedavail>
dm-snapshot-in       128    162     48   81    1 : tunables  120   60    8
: slabdata      2      2      0
dm-snapshot-ex      1981   2260     16  226    1 : tunables  120   60    8
: slabdata     10     10      0
dm_tio              4574   4746     16  226    1 : tunables  120   60    8
: slabdata     21     21      0
dm_io               4574   4746     16  226    1 : tunables  120   60    8
: slabdata     21     21      0
journal_handle        32    185     20  185    1 : tunables  120   60    8
: slabdata      1      1      0
journal_head         265   1350     52   75    1 : tunables  120   60    8
: slabdata     18     18      0
ext3_inode_cache     756    763    508    7    1 : tunables   54   27    8
: slabdata    109    109      0
ext3_xattr           118    176     44   88    1 : tunables  120   60    8
: slabdata      2      2      0
biovec-(256)         264    264   3072    2    2 : tunables   24   12    8
: slabdata    132    132      0
biovec-128           272    275   1536    5    2 : tunables   24   12    8
: slabdata     55     55      0
biovec-64            288    290    768    5    1 : tunables   54   27    8
: slabdata     58     58      0
biovec-16            288    300    192   20    1 : tunables  120   60    8
: slabdata     15     15      0
biovec-4             288    305     64   61    1 : tunables  120   60    8
: slabdata      5      5      0
biovec-1             732   1582     16  226    1 : tunables  120   60    8
: slabdata      7      7      0
bio                  732   1558     96   41    1 : tunables  120   60    8
: slabdata     38     38      0




# cat /proc/meminfo
MemTotal:       906280 kB
MemFree:        557632 kB
Buffers:         30008 kB
Cached:         264500 kB
SwapCached:          0 kB
Active:          68044 kB
Inactive:       249244 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:       906280 kB
LowFree:        557632 kB
SwapTotal:     1048816 kB
SwapFree:      1048816 kB
Dirty:              36 kB
Writeback:         888 kB
Mapped:          31732 kB
Slab:            18700 kB
CommitLimit:   1501956 kB
Committed_AS:    59292 kB
PageTables:        600 kB
VmallocTotal:   122824 kB
VmallocUsed:      2536 kB
VmallocChunk:   114632 kB
HugePages_Total:     0
HugePages_Free:      0
Hugepagesize:     4096 kB




Thanks and best regards,
Dezo
