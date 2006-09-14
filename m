From: "kevin Cheng" <kevin_cheng@thecus.com>
Subject: RE: [Bugme-new] [Bug 7158] New: Out of memory happen in
	snapshot
Date: Thu, 14 Sep 2006 13:25:52 +0800
Message-ID: <200609140525.k8E5Pg4L026098@mail.thecus.com>
References: <20060913205249.1aa784d9.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0354_01C6D801.4DD5C520"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060913205249.1aa784d9.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Andrew Morton' <akpm@osdl.org>, "'bugme-daemon@kernel-bugs.osdl.org'" <bugme-daemon@bugzilla.kernel.org>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------=_NextPart_000_0354_01C6D801.4DD5C520
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Dear Andrew:
   Thanks for your message and help. 

Attech file is the slabinfo from my machine. Thanks!!



Thanks for all advice ,
 
Regards,
 
Kevin Cheng
 
 

-----Original Message-----
From: Andrew Morton [mailto:akpm@osdl.org] 
Sent: Thursday, September 14, 2006 11:53 AM
To: bugme-daemon@kernel-bugs.osdl.org
Cc: dm-devel@redhat.com; agk@redhat.com; kevin_cheng@thecus.com
Subject: Re: [Bugme-new] [Bug 7158] New: Out of memory happen in snapshot

I've switched this to the mailing list - please send all replies via email
(not the bugzilla web interface) and please ensure that all cc's are
retained.


On Wed, 13 Sep 2006 20:20:00 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7158
> 
>            Summary: Out of memory happen in snapshot
>     Kernel Version: 2.6.17.13
>             Status: NEW
>           Severity: blocking
>              Owner: agk@redhat.com
>          Submitter: kevin_cheng@thecus.com
> 
> 
> Most recent kernel where this bug did not occur:
> Distribution:
> Hardware Environment:
>   celoron M 1,5GHz
>   memory :256MB
>   swap memory have 1GB
> 
> Software Environment:
>   My volumn be created on RAID0
>   kernel is 2.6.17.13
>   Filesyetm is ext3
>   
> Problem Description:
>    We create the 8 snapshots in one volumn ,and copy a 4G file to the 
> volumn , and system happen "out of memory" and oom-killer kill my
processes.
> Someone have happen this problem ,have any way to solve it ? Thanks!!
> 
> Steps to reproduce:
>   - use three hdd to create RAID0
>   - create vg on RAID0 is called vg0
>   - Create lv on vg0 is called lv0
>   - mke2fsck -j /dev/vg0/lv0 , format to ext3 filesystem
>   - mount /dev/vg0/lv0 to /raid/data
>   - create a folder pub on /raid/data
>   - create 8 snapshots base on lv0 ,snapshot lv sizes have 22GB,every 
> snapshot are the same.
>   - use dd command to create 4G file to lv0
>     dd if=/dev/zero of=/raid/data/4G.bin bs=1M count=4096
>   - system have some thing happen 
>     sometime system will crash ,not any more message.
>     sometime have "out of memory" in dmesg
> 


The oom-killer info which you've included there is ambiguous.  A large
amount f memory is in slab, which might indicate a slab leak.  But there is
also a large amount of memory on the page LRU, which one would expect to
have been reclaimed before declaration of OOM.  

Could you please capture the contents of /proc/slabinfo after the
oom-killing and send that?

------=_NextPart_000_0354_01C6D801.4DD5C520
Content-Type: text/plain;
	name="slabinfo.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="slabinfo.txt"

root@127.0.0.1:/raid/snapshot# cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> =
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata =
<active_slabs> <num_slabs> <sharedavail>
kcopyd-jobs        16524  62685    264   15    1 : tunables   54   27    =
0 : slabdata   4179   4179      0
scsi_cmd_cache        20     20    384   10    1 : tunables   54   27    =
0 : slabdata      2      2      0
dm-snapshot-in     24833  73219     64   59    1 : tunables  120   60    =
0 : slabdata   1241   1241      0
dm-snapshot-ex    762385 762410     24  145    1 : tunables  120   60    =
0 : slabdata   5258   5258      0
dm_tio             23337  32277     16  203    1 : tunables  120   60    =
0 : slabdata    159    159      0
dm_io              23339  32448     20  169    1 : tunables  120   60    =
0 : slabdata    192    192      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    =
0 : slabdata      4      4      0
rpc_tasks              8     20    192   20    1 : tunables  120   60    =
0 : slabdata      1      1      0
rpc_inode_cache        6      9    448    9    1 : tunables   54   27    =
0 : slabdata      1      1      0
uhci_urb_priv          0      0     28  127    1 : tunables  120   60    =
0 : slabdata      0      0      0
UNIX                   7     10    384   10    1 : tunables   54   27    =
0 : slabdata      1      1      0
cfq_ioc_pool         121    160     96   40    1 : tunables  120   60    =
0 : slabdata      4      4      0
cfq_pool             109    120     96   40    1 : tunables  120   60    =
0 : slabdata      3      3      0
crq_pool             288    468     48   78    1 : tunables  120   60    =
0 : slabdata      6      6      0
deadline_drq           0      0     52   72    1 : tunables  120   60    =
0 : slabdata      0      0      0
as_arq                 0      0     64   59    1 : tunables  120   60    =
0 : slabdata      0      0      0
mqueue_inode_cache      1      7    512    7    1 : tunables   54   27   =
 0 : slabdata      1      1      0
ntfs_big_inode_cache      0      0    448    9    1 : tunables   54   27 =
   0 : slabdata      0      0      0
ntfs_inode_cache       0      0    148   26    1 : tunables  120   60    =
0 : slabdata      0      0      0
ntfs_name_cache        0      0    512    8    1 : tunables   54   27    =
0 : slabdata      0      0      0
ntfs_attr_ctx_cache      0      0     32  113    1 : tunables  120   60  =
  0 : slabdata      0      0      0
ntfs_index_ctx_cache      0      0     64   59    1 : tunables  120   60 =
   0 : slabdata      0      0      0
fat_inode_cache        0      0    344   11    1 : tunables   54   27    =
0 : slabdata      0      0      0
fat_cache              0      0     20  169    1 : tunables  120   60    =
0 : slabdata      0      0      0
ext2_inode_cache     222    549    420    9    1 : tunables   54   27    =
0 : slabdata     61     61      0
ext2_xattr             0      0     48   78    1 : tunables  120   60    =
0 : slabdata      0      0      0
journal_handle         0      0     20  169    1 : tunables  120   60    =
0 : slabdata      0      0      0
journal_head       23029  25272     52   72    1 : tunables  120   60    =
0 : slabdata    351    351      0
revoke_table          18    254     12  254    1 : tunables  120   60    =
0 : slabdata      1      1      0
revoke_record          0      0     16  203    1 : tunables  120   60    =
0 : slabdata      0      0      0
ext3_inode_cache      21     27    436    9    1 : tunables   54   27    =
0 : slabdata      3      3      0
ext3_xattr             0      0     48   78    1 : tunables  120   60    =
0 : slabdata      0      0      0
reiser_inode_cache      0      0    368   10    1 : tunables   54   27   =
 0 : slabdata      0      0      0
dnotify_cache          1    169     20  169    1 : tunables  120   60    =
0 : slabdata      1      1      0
eventpoll_pwq          0      0     36  101    1 : tunables  120   60    =
0 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    =
0 : slabdata      0      0      0
kioctx                 0      0    192   20    1 : tunables  120   60    =
0 : slabdata      0      0      0
kiocb                  0      0    128   30    1 : tunables  120   60    =
0 : slabdata      0      0      0
fasync_cache           0      0     16  203    1 : tunables  120   60    =
0 : slabdata      0      0      0
shmem_inode_cache    130    130    384   10    1 : tunables   54   27    =
0 : slabdata     13     13      0
posix_timers_cache      0      0     88   44    1 : tunables  120   60   =
 0 : slabdata      0      0      0
uid_cache              2     59     64   59    1 : tunables  120   60    =
0 : slabdata      1      1      0
tcp_bind_bucket       17    203     16  203    1 : tunables  120   60    =
0 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    =
0 : slabdata      0      0      0
ip_fib_alias          17    113     32  113    1 : tunables  120   60    =
0 : slabdata      1      1      0
ip_fib_hash           17    113     32  113    1 : tunables  120   60    =
0 : slabdata      1      1      0
ip_dst_cache          65     75    256   15    1 : tunables  120   60    =
0 : slabdata      5      5      0
arp_cache             13     30    128   30    1 : tunables  120   60    =
0 : slabdata      1      1      0
RAW                    2      9    448    9    1 : tunables   54   27    =
0 : slabdata      1      1      0
UDP                   23     27    448    9    1 : tunables   54   27    =
0 : slabdata      3      3      0
tw_sock_TCP            1     30    128   30    1 : tunables  120   60    =
0 : slabdata      1      1      0
request_sock_TCP       0      0     64   59    1 : tunables  120   60    =
0 : slabdata      0      0      0
TCP                   28     28   1088    7    2 : tunables   24   12    =
0 : slabdata      4      4      0
sgpool-128            34     34   2048    2    1 : tunables   24   12    =
0 : slabdata     17     17      0
sgpool-64             36     36   1024    4    1 : tunables   54   27    =
0 : slabdata      9      9      0
sgpool-32             40     40    512    8    1 : tunables   54   27    =
0 : slabdata      5      5      0
sgpool-16             38     45    256   15    1 : tunables  120   60    =
0 : slabdata      3      3      0
sgpool-8              48     60    128   30    1 : tunables  120   60    =
0 : slabdata      2      2      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    =
0 : slabdata      0      0      0
blkdev_ioc            42    127     28  127    1 : tunables  120   60    =
0 : slabdata      1      1      0
blkdev_queue          59     60    948    4    1 : tunables   54   27    =
0 : slabdata     15     15      0
blkdev_requests      282    396    176   22    1 : tunables  120   60    =
0 : slabdata     18     18      0
biovec-(256)          15     16   3072    2    2 : tunables   24   12    =
0 : slabdata      8      8      0
biovec-128            23     25   1536    5    2 : tunables   24   12    =
0 : slabdata      5      5      0
biovec-64             39     40    768    5    1 : tunables   54   27    =
0 : slabdata      8      8      0
biovec-16             39     40    192   20    1 : tunables  120   60    =
0 : slabdata      2      2      0
biovec-4            2815   3717     64   59    1 : tunables  120   60    =
0 : slabdata     63     63      0
biovec-1           33507  47096     16  203    1 : tunables  120   60    =
0 : slabdata    232    232      0
bio                36390  50130    128   30    1 : tunables  120   60    =
0 : slabdata   1671   1671      0
sock_inode_cache      80     80    384   10    1 : tunables   54   27    =
0 : slabdata      8      8      0
skbuff_fclone_cache     10     10    384   10    1 : tunables   54   27  =
  0 : slabdata      1      1      0
skbuff_head_cache    580    580    192   20    1 : tunables  120   60    =
0 : slabdata     29     29      0
file_lock_cache       20     42     92   42    1 : tunables  120   60    =
0 : slabdata      1      1      0
proc_inode_cache      28     65    308   13    1 : tunables   54   27    =
0 : slabdata      5      5      0
sigqueue              27     27    144   27    1 : tunables  120   60    =
0 : slabdata      1      1      0
radix_tree_node      907   1680    276   14    1 : tunables   54   27    =
0 : slabdata    120    120      0
bdev_cache            39     45    448    9    1 : tunables   54   27    =
0 : slabdata      5      5      0
sysfs_dir_cache     4751   4788     44   84    1 : tunables  120   60    =
0 : slabdata     57     57      0
mnt_cache             32     60    128   30    1 : tunables  120   60    =
0 : slabdata      2      2      0
inode_cache         1238   1274    292   13    1 : tunables   54   27    =
0 : slabdata     98     98      0
dentry_cache        1737   3162    124   31    1 : tunables  120   60    =
0 : slabdata    102    102      0
filp                 596    840    192   20    1 : tunables  120   60    =
0 : slabdata     42     42      0
names_cache            5      5   4096    1    1 : tunables   24   12    =
0 : slabdata      5      5      0
idr_layer_cache       93    116    136   29    1 : tunables  120   60    =
0 : slabdata      4      4      0
buffer_head        24234  36000     52   72    1 : tunables  120   60    =
0 : slabdata    500    500      0
mm_struct             70     81    448    9    1 : tunables   54   27    =
0 : slabdata      9      9      0
vm_area_struct      1188   1188     88   44    1 : tunables  120   60    =
0 : slabdata     27     27      0
fs_cache              89    113     32  113    1 : tunables  120   60    =
0 : slabdata      1      1      0
files_cache          112    180    192   20    1 : tunables  120   60    =
0 : slabdata      9      9      0
signal_cache         120    120    384   10    1 : tunables   54   27    =
0 : slabdata     12     12      0
sighand_cache         96     96   1344    3    1 : tunables   24   12    =
0 : slabdata     32     32      0
task_struct          132    144   1264    3    1 : tunables   24   12    =
0 : slabdata     48     48      0
anon_vma             545    678      8  339    1 : tunables  120   60    =
0 : slabdata      2      2      0
pgd                   50     50   4096    1    1 : tunables   24   12    =
0 : slabdata     50     50      0
pid                  157    505     36  101    1 : tunables  120   60    =
0 : slabdata      5      5      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    =
0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    =
0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    =
0 : slabdata      0      0      0
size-65536             1      1  65536    1   16 : tunables    8    4    =
0 : slabdata      1      1      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    =
0 : slabdata      0      0      0
size-32768           256    259  32768    1    8 : tunables    8    4    =
0 : slabdata    256    259      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    =
0 : slabdata      0      0      0
size-16384             0      0  16384    1    4 : tunables    8    4    =
0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    =
0 : slabdata      0      0      0
size-8192            128    136   8192    1    2 : tunables    8    4    =
0 : slabdata    128    136      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    =
0 : slabdata      0      0      0
size-4096            308    308   4096    1    1 : tunables   24   12    =
0 : slabdata    308    308      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    =
0 : slabdata      0      0      0
size-2048             76     76   2048    2    1 : tunables   24   12    =
0 : slabdata     38     38      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    =
0 : slabdata      0      0      0
size-1024            140    140   1024    4    1 : tunables   54   27    =
0 : slabdata     35     35      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    =
0 : slabdata      0      0      0
size-512             312    312    512    8    1 : tunables   54   27    =
0 : slabdata     39     39      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-256             105    105    256   15    1 : tunables  120   60    =
0 : slabdata      7      7      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-192             720    720    192   20    1 : tunables  120   60    =
0 : slabdata     36     36      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-128             854    870    128   30    1 : tunables  120   60    =
0 : slabdata     29     29      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-64             2240   2360     64   59    1 : tunables  120   60    =
0 : slabdata     40     40      0
size-32            13991  14351     32  113    1 : tunables  120   60    =
0 : slabdata    127    127      0
kmem_cache           123    150    128   30    1 : tunables  120   60    =
0 : slabdata      5      5      0

------=_NextPart_000_0354_01C6D801.4DD5C520
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_NextPart_000_0354_01C6D801.4DD5C520--
