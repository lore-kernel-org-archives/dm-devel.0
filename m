From: "kevin Cheng" <kevin_cheng@thecus.com>
Subject: RE: RE: [Bugme-new] [Bug 7158] New: Out of memory happen
	insnapshot
Date: Mon, 18 Sep 2006 12:36:08 +0800
Message-ID: <200609180435.k8I4Yk4L011665@mail.thecus.com>
References: <20060915200938.GT13859@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000E_01C6DB1F.05AAB320"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060915200938.GT13859@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Alasdair G Kergon' <agk@redhat.com>
Cc: 'Andrew Morton' <akpm@osdl.org>, 'device-mapper development' <dm-devel@redhat.com>, "'bugme-daemon@kernel-bugs.osdl.org'" <bugme-daemon@bugzilla.kernel.org>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------=_NextPart_000_000E_01C6DB1F.05AAB320
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

 Dear Alasdair:
    Thanks for your message. This moning I redo the OOM problem. 
Hardware eviroment is the same. And use chunk size 64KB. Aatech file have
the dm info and slab info .
This time we use dd command and dd 8GB file to lvm ,second time
out-of-memory happen.   Thanks!!


Regards,

Kevin

-----Original Message-----
From: Alasdair G Kergon [mailto:agk@redhat.com] 
Sent: Saturday, September 16, 2006 4:10 AM
To: kevin Cheng
Cc: 'device-mapper development'; 'Andrew Morton';
'bugme-daemon@kernel-bugs.osdl.org'
Subject: Re: [dm-devel] RE: [Bugme-new] [Bug 7158] New: Out of memory happen
insnapshot

I notice that the 'dmsetup table' output does not correspond to the
information you gave at the beginning of the bug.  (Different volume sizes -
16.5GB not 22GB - and different chunk size - 64KB not 8KB.)

Does that 'dmsetup status' output correspond to the time the system reached
OOM and tie in with the slabinfo you provided?

If not, please can you try to get fresh data from the time of the failure?
(both slabinfo and 'dmsetup status' taken at approximately the same time
when the system is in (or close to) OOM; it's OK to take 'dmsetup info' and
'dmsetup table' earlier in the test as they won't change during it)

Alasdair
--
agk@redhat.com

------=_NextPart_000_000E_01C6DB1F.05AAB320
Content-Type: text/plain;
	name="dminfo_after_create_snapshot.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dminfo_after_create_snapshot.txt"

-----Not Create Snapshot
root@127.0.0.1:/app# /app/dmsetup info -c
Name             Maj Min Stat Open Targ Event  UUID
vg0-syslv        253   0 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u0y1V4NRFFWrp9Icngea0s2wRCSsV003X
vg0-lv0          253   1 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ux4nzi3NZCKF8sFWmhHiQ8IIXgc7ehqVO
root@127.0.0.1:/app# /app/dmsetup table
vg0-syslv: 0 2097152 linear 9:0 384
vg0-lv0: 0 138625024 linear 9:0 2097536
root@127.0.0.1:/app# /app/dmsetup status
vg0-syslv: 0 2097152 linear
vg0-lv0: 0 138625024 linear


-----After Create Snapshot
root@127.0.0.1:/app# /app/dmsetup info -c
Name             Maj Min Stat Open Targ Event  UUID
vg0-2006--09--18--10--52--24 253   8 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uOofID2neSxfPcsO871Se1HXplZBhT2AS
vg0-lv0-real     253   2 L--w    9    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ux4nzi3NZCKF8sFWmhHiQ8IIXgc7ehqVO-real=

vg0-2006--09--18--10--52--33-cow 253  15 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u1vug1rkLqFsFGe8k6szOIqT3aIM1o8MB-cow
vg0-2006--09--18--10--52--24-cow 253   7 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uOofID2neSxfPcsO871Se1HXplZBhT2AS-cow
vg0-2006--09--18--10--52--19 253   4 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u446Ibv1KacV3YVQmPie8leLExIvKMvQS
vg0-2006--09--18--10--52--36 253  18 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uR5Kh1pa6ph4RUKKdSDnIKeLiN0bEu01E
vg0-2006--09--18--10--52--21 253   6 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1un2UBTeOfeppFCf9VeExzKa5VBe5MliSI
vg0-syslv        253   0 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u0y1V4NRFFWrp9Icngea0s2wRCSsV003X
vg0-2006--09--18--10--52--33 253  16 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u1vug1rkLqFsFGe8k6szOIqT3aIM1o8MB
vg0-2006--09--18--10--52--26-cow 253   9 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1usWSLaHa2VLnfZCcExOZvY1338X6Lcqf2-cow
vg0-2006--09--18--10--52--30-cow 253  13 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uhjh1FrbiN7EaTxnHDqrp2sHTYiwonEB4-cow
vg0-lv0          253   1 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ux4nzi3NZCKF8sFWmhHiQ8IIXgc7ehqVO
vg0-2006--09--18--10--52--36-cow 253  17 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uR5Kh1pa6ph4RUKKdSDnIKeLiN0bEu01E-cow
vg0-2006--09--18--10--52--21-cow 253   5 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1un2UBTeOfeppFCf9VeExzKa5VBe5MliSI-cow
vg0-2006--09--18--10--52--28 253  12 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ummF3OUXe9YXnOfWJGjZZvBtncw1xv01G
vg0-2006--09--18--10--52--30 253  14 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uhjh1FrbiN7EaTxnHDqrp2sHTYiwonEB4
vg0-2006--09--18--10--52--28-cow 253  11 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ummF3OUXe9YXnOfWJGjZZvBtncw1xv01G-cow
vg0-2006--09--18--10--52--26 253  10 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1usWSLaHa2VLnfZCcExOZvY1338X6Lcqf2
vg0-2006--09--18--10--52--19-cow 253   3 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u446Ibv1KacV3YVQmPie8leLExIvKMvQS-cow
root@127.0.0.1:/app# /app/dmsetup table
vg0-2006--09--18--10--52--24: 0 138625024 snapshot 253:2 253:7 P 128
vg0-lv0-real: 0 138625024 linear 9:0 2097536
vg0-2006--09--18--10--52--33-cow: 0 40370176 linear 9:0 382943616
vg0-2006--09--18--10--52--24-cow: 0 40370176 linear 9:0 221462912
vg0-2006--09--18--10--52--19: 0 138625024 snapshot 253:2 253:3 P 128
vg0-2006--09--18--10--52--36: 0 138625024 snapshot 253:2 253:17 P 128
vg0-2006--09--18--10--52--21: 0 138625024 snapshot 253:2 253:5 P 128
vg0-syslv: 0 2097152 linear 9:0 384
vg0-2006--09--18--10--52--33: 0 138625024 snapshot 253:2 253:15 P 128
vg0-2006--09--18--10--52--26-cow: 0 40370176 linear 9:0 261833088
vg0-2006--09--18--10--52--30-cow: 0 40370176 linear 9:0 342573440
vg0-lv0: 0 138625024 snapshot-origin 253:2
vg0-2006--09--18--10--52--36-cow: 0 41525248 linear 9:0 423313792
vg0-2006--09--18--10--52--21-cow: 0 40370176 linear 9:0 181092736
vg0-2006--09--18--10--52--28: 0 138625024 snapshot 253:2 253:11 P 128
vg0-2006--09--18--10--52--30: 0 138625024 snapshot 253:2 253:13 P 128
vg0-2006--09--18--10--52--28-cow: 0 40370176 linear 9:0 302203264
vg0-2006--09--18--10--52--26: 0 138625024 snapshot 253:2 253:9 P 128
vg0-2006--09--18--10--52--19-cow: 0 40370176 linear 9:0 140722560
root@127.0.0.1:/app# /app/dmsetup status
vg0-2006--09--18--10--52--24: 0 138625024 snapshot 384/40370176
vg0-lv0-real: 0 138625024 linear
vg0-2006--09--18--10--52--33-cow: 0 40370176 linear
vg0-2006--09--18--10--52--24-cow: 0 40370176 linear
vg0-2006--09--18--10--52--19: 0 138625024 snapshot 384/40370176
vg0-2006--09--18--10--52--36: 0 138625024 snapshot 384/41525248
vg0-2006--09--18--10--52--21: 0 138625024 snapshot 384/40370176
vg0-syslv: 0 2097152 linear
vg0-2006--09--18--10--52--33: 0 138625024 snapshot 384/40370176
vg0-2006--09--18--10--52--26-cow: 0 40370176 linear
vg0-2006--09--18--10--52--30-cow: 0 40370176 linear
vg0-lv0: 0 138625024 snapshot-origin
vg0-2006--09--18--10--52--36-cow: 0 41525248 linear
vg0-2006--09--18--10--52--21-cow: 0 40370176 linear
vg0-2006--09--18--10--52--28: 0 138625024 snapshot 384/40370176
vg0-2006--09--18--10--52--30: 0 138625024 snapshot 384/40370176
vg0-2006--09--18--10--52--28-cow: 0 40370176 linear
vg0-2006--09--18--10--52--26: 0 138625024 snapshot 384/40370176
vg0-2006--09--18--10--52--19-cow: 0 40370176 linear


--------------cat /proc/slabinfo
root@127.0.0.1:/app# awk =
'/kcopyd-jobs/||/dm-snapshot-in/||/dm-snapshot-ex/||/dm_tio/||/dm_io/||/j=
ournal_head/||/biovec-4/||/biovec-1/||/buffer_head/||/bio/' =
/proc/slabinfo
kcopyd-jobs          512    525    184   21    1 : tunables  120   60    =
0 : slabdata     25     25      0
dm-snapshot-in       128    177     64   59    1 : tunables  120   60    =
0 : slabdata      3      3      0
dm-snapshot-ex         8    145     24  145    1 : tunables  120   60    =
0 : slabdata      1      1      0
dm_tio              4864   4872     16  203    1 : tunables  120   60    =
0 : slabdata     24     24      0
dm_io               4864   4901     20  169    1 : tunables  120   60    =
0 : slabdata     29     29      0
journal_head           1     72     52   72    1 : tunables  120   60    =
0 : slabdata      1      1      0
biovec-(256)          15     16   3072    2    2 : tunables   24   12    =
0 : slabdata      8      8      0
biovec-128            23     25   1536    5    2 : tunables   24   12    =
0 : slabdata      5      5      0
biovec-64             39     40    768    5    1 : tunables   54   27    =
0 : slabdata      8      8      0
biovec-16             39     40    192   20    1 : tunables  120   60    =
0 : slabdata      2      2      0
biovec-4              39     59     64   59    1 : tunables  120   60    =
0 : slabdata      1      1      0
biovec-1              39    203     16  203    1 : tunables  120   60    =
0 : slabdata      1      1      0
bio                  288    330    128   30    1 : tunables  120   60    =
0 : slabdata     11     11      0
buffer_head         1559   6336     52   72    1 : tunables  120   60    =
0 : slabdata     88     88      0



------=_NextPart_000_000E_01C6DB1F.05AAB320
Content-Type: text/plain;
	name="dminfo_after_oom_happen.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dminfo_after_oom_happen.txt"

--------------cat /proc/slabinfo
root@127.0.0.1:~# cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> =
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata =
<active_slabs> <num_slabs> <sharedavail>
kcopyd-jobs          512   1638    184   21    1 : tunables  120   60    =
0 : slabdata     78     78      0
scsi_cmd_cache        10     10    384   10    1 : tunables   54   27    =
0 : slabdata      1      1      0
dm-snapshot-in       128   3068     64   59    1 : tunables  120   60    =
0 : slabdata     52     52      0
dm-snapshot-ex    1154368 1154490     24  145    1 : tunables  120   60  =
  0 : slabdata   7962   7962      0
dm_tio              4864   8323     16  203    1 : tunables  120   60    =
0 : slabdata     41     41      0
dm_io               4864  12168     20  169    1 : tunables  120   60    =
0 : slabdata     72     72      0
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
cfq_ioc_pool         102    160     96   40    1 : tunables  120   60    =
0 : slabdata      4      4      0
cfq_pool              94    160     96   40    1 : tunables  120   60    =
0 : slabdata      4      4      0
crq_pool              36    156     48   78    1 : tunables  120   60    =
0 : slabdata      1      2      0
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
ext2_inode_cache     215    459    420    9    1 : tunables   54   27    =
0 : slabdata     51     51      0
ext2_xattr             2     78     48   78    1 : tunables  120   60    =
0 : slabdata      1      1      0
journal_handle         0      0     20  169    1 : tunables  120   60    =
0 : slabdata      0      0      0
journal_head         106   6480     52   72    1 : tunables  120   60    =
0 : slabdata     90     90      0
revoke_table          20    254     12  254    1 : tunables  120   60    =
0 : slabdata      1      1      0
revoke_record          0      0     16  203    1 : tunables  120   60    =
0 : slabdata      0      0      0
ext3_inode_cache      23     36    436    9    1 : tunables   54   27    =
0 : slabdata      4      4      0
ext3_xattr             1     78     48   78    1 : tunables  120   60    =
0 : slabdata      1      1      0
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
shmem_inode_cache    153    160    384   10    1 : tunables   54   27    =
0 : slabdata     16     16      0
posix_timers_cache      0      0     88   44    1 : tunables  120   60   =
 0 : slabdata      0      0      0
uid_cache              0      0     64   59    1 : tunables  120   60    =
0 : slabdata      0      0      0
tcp_bind_bucket       11    203     16  203    1 : tunables  120   60    =
0 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    =
0 : slabdata      0      0      0
ip_fib_alias          17    113     32  113    1 : tunables  120   60    =
0 : slabdata      1      1      0
ip_fib_hash           17    113     32  113    1 : tunables  120   60    =
0 : slabdata      1      1      0
ip_dst_cache          30     75    256   15    1 : tunables  120   60    =
0 : slabdata      5      5      0
arp_cache              2     30    128   30    1 : tunables  120   60    =
0 : slabdata      1      1      0
RAW                    2      9    448    9    1 : tunables   54   27    =
0 : slabdata      1      1      0
UDP                   14     27    448    9    1 : tunables   54   27    =
0 : slabdata      3      3      0
tw_sock_TCP            0      0    128   30    1 : tunables  120   60    =
0 : slabdata      0      0      0
request_sock_TCP       0      0     64   59    1 : tunables  120   60    =
0 : slabdata      0      0      0
TCP                   14     28   1088    7    2 : tunables   24   12    =
0 : slabdata      4      4      0
sgpool-128            32     32   2048    2    1 : tunables   24   12    =
0 : slabdata     16     16      0
sgpool-64             32     32   1024    4    1 : tunables   54   27    =
0 : slabdata      8      8      0
sgpool-32             32     32    512    8    1 : tunables   54   27    =
0 : slabdata      4      4      0
sgpool-16             32     45    256   15    1 : tunables  120   60    =
0 : slabdata      3      3      0
sgpool-8              48     60    128   30    1 : tunables  120   60    =
0 : slabdata      2      2      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    =
0 : slabdata      0      0      0
blkdev_ioc            51    127     28  127    1 : tunables  120   60    =
0 : slabdata      1      1      0
blkdev_queue          58     60    948    4    1 : tunables   54   27    =
0 : slabdata     15     15      0
blkdev_requests       36     66    176   22    1 : tunables  120   60    =
0 : slabdata      2      3      0
biovec-(256)          15     16   3072    2    2 : tunables   24   12    =
0 : slabdata      8      8      0
biovec-128            23     25   1536    5    2 : tunables   24   12    =
0 : slabdata      5      5      0
biovec-64             39     40    768    5    1 : tunables   54   27    =
0 : slabdata      8      8      0
biovec-16             39    120    192   20    1 : tunables  120   60    =
0 : slabdata      6      6      0
biovec-4              39    177     64   59    1 : tunables  120   60    =
0 : slabdata      3      3      0
biovec-1              55    609     16  203    1 : tunables  120   60    =
0 : slabdata      3      3      0
bio                  304   2070    128   30    1 : tunables  120   60    =
0 : slabdata     69     69      0
sock_inode_cache      54     70    384   10    1 : tunables   54   27    =
0 : slabdata      7      7      0
skbuff_fclone_cache      5     10    384   10    1 : tunables   54   27  =
  0 : slabdata      1      1      0
skbuff_head_cache    560    560    192   20    1 : tunables  120   60    =
0 : slabdata     28     28      0
file_lock_cache       13     42     92   42    1 : tunables  120   60    =
0 : slabdata      1      1      0
proc_inode_cache      14    104    308   13    1 : tunables   54   27    =
0 : slabdata      8      8      0
sigqueue               0     27    144   27    1 : tunables  120   60    =
0 : slabdata      0      1      0
radix_tree_node      958   1344    276   14    1 : tunables   54   27    =
0 : slabdata     96     96      0
bdev_cache            37     45    448    9    1 : tunables   54   27    =
0 : slabdata      5      5      0
sysfs_dir_cache     4718   4788     44   84    1 : tunables  120   60    =
0 : slabdata     57     57      0
mnt_cache             33     60    128   30    1 : tunables  120   60    =
0 : slabdata      2      2      0
inode_cache         1205   1235    292   13    1 : tunables   54   27    =
0 : slabdata     95     95      0
dentry_cache        1683   3193    124   31    1 : tunables  120   60    =
0 : slabdata    103    103      0
filp                 500    740    192   20    1 : tunables  120   60    =
0 : slabdata     37     37      0
names_cache            4      4   4096    1    1 : tunables   24   12    =
0 : slabdata      4      4      0
idr_layer_cache       94    116    136   29    1 : tunables  120   60    =
0 : slabdata      4      4      0
buffer_head        27575  37368     52   72    1 : tunables  120   60    =
0 : slabdata    519    519      0
mm_struct             61     72    448    9    1 : tunables   54   27    =
0 : slabdata      8      8      0
vm_area_struct       884   1364     88   44    1 : tunables  120   60    =
0 : slabdata     31     31      0
fs_cache              89    113     32  113    1 : tunables  120   60    =
0 : slabdata      1      1      0
files_cache           76    100    192   20    1 : tunables  120   60    =
0 : slabdata      5      5      0
signal_cache         109    120    384   10    1 : tunables   54   27    =
0 : slabdata     12     12      0
sighand_cache        100    102   1344    3    1 : tunables   24   12    =
0 : slabdata     34     34      0
task_struct          103    129   1264    3    1 : tunables   24   12    =
0 : slabdata     43     43      0
anon_vma             499    678      8  339    1 : tunables  120   60    =
0 : slabdata      2      2      0
pgd                   55     55   4096    1    1 : tunables   24   12    =
0 : slabdata     55     55      0
pid                  125    303     36  101    1 : tunables  120   60    =
0 : slabdata      3      3      0
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
size-32768           256    256  32768    1    8 : tunables    8    4    =
0 : slabdata    256    256      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    =
0 : slabdata      0      0      0
size-16384             0      0  16384    1    4 : tunables    8    4    =
0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    =
0 : slabdata      0      0      0
size-8192             98    102   8192    1    2 : tunables    8    4    =
0 : slabdata     98    102      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    =
0 : slabdata      0      0      0
size-4096            283    283   4096    1    1 : tunables   24   12    =
0 : slabdata    283    283      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    =
0 : slabdata      0      0      0
size-2048             86     86   2048    2    1 : tunables   24   12    =
0 : slabdata     43     43      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    =
0 : slabdata      0      0      0
size-1024            136    136   1024    4    1 : tunables   54   27    =
0 : slabdata     34     34      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    =
0 : slabdata      0      0      0
size-512             312    312    512    8    1 : tunables   54   27    =
0 : slabdata     39     39      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-256              89     90    256   15    1 : tunables  120   60    =
0 : slabdata      6      6      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-192             714    720    192   20    1 : tunables  120   60    =
0 : slabdata     36     36      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-128             844    870    128   30    1 : tunables  120   60    =
0 : slabdata     29     29      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    =
0 : slabdata      0      0      0
size-64             2166   2478     64   59    1 : tunables  120   60    =
0 : slabdata     42     42      0
size-32            13605  14012     32  113    1 : tunables  120   60    =
0 : slabdata    124    124      0
kmem_cache           123    150    128   30    1 : tunables  120   60    =
0 : slabdata      5      5      0



--------------DM info
root@127.0.0.1:~# /app/dmsetup info -c
Name             Maj Min Stat Open Targ Event  UUID
vg0-2006--09--18--10--52--24 253   8 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uOofID2neSxfPcsO871Se1HXplZBhT2AS
vg0-lv0-real     253   2 L--w    9    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ux4nzi3NZCKF8sFWmhHiQ8IIXgc7ehqVO-real=

vg0-2006--09--18--10--52--33-cow 253  15 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u1vug1rkLqFsFGe8k6szOIqT3aIM1o8MB-cow
vg0-2006--09--18--10--52--24-cow 253   7 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uOofID2neSxfPcsO871Se1HXplZBhT2AS-cow
vg0-2006--09--18--10--52--19 253   4 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u446Ibv1KacV3YVQmPie8leLExIvKMvQS
vg0-2006--09--18--10--52--36 253  18 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uR5Kh1pa6ph4RUKKdSDnIKeLiN0bEu01E
vg0-2006--09--18--10--52--21 253   6 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1un2UBTeOfeppFCf9VeExzKa5VBe5MliSI
vg0-syslv        253   0 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u0y1V4NRFFWrp9Icngea0s2wRCSsV003X
vg0-2006--09--18--10--52--33 253  16 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u1vug1rkLqFsFGe8k6szOIqT3aIM1o8MB
vg0-2006--09--18--10--52--26-cow 253   9 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1usWSLaHa2VLnfZCcExOZvY1338X6Lcqf2-cow
vg0-2006--09--18--10--52--30-cow 253  13 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uhjh1FrbiN7EaTxnHDqrp2sHTYiwonEB4-cow
vg0-lv0          253   1 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ux4nzi3NZCKF8sFWmhHiQ8IIXgc7ehqVO
vg0-2006--09--18--10--52--36-cow 253  17 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uR5Kh1pa6ph4RUKKdSDnIKeLiN0bEu01E-cow
vg0-2006--09--18--10--52--21-cow 253   5 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1un2UBTeOfeppFCf9VeExzKa5VBe5MliSI-cow
vg0-2006--09--18--10--52--28 253  12 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ummF3OUXe9YXnOfWJGjZZvBtncw1xv01G
vg0-2006--09--18--10--52--30 253  14 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1uhjh1FrbiN7EaTxnHDqrp2sHTYiwonEB4
vg0-2006--09--18--10--52--28-cow 253  11 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1ummF3OUXe9YXnOfWJGjZZvBtncw1xv01G-cow
vg0-2006--09--18--10--52--26 253  10 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1usWSLaHa2VLnfZCcExOZvY1338X6Lcqf2
vg0-2006--09--18--10--52--19-cow 253   3 L--w    1    1      0 =
LVM-svg5FSJWZJHHDFgyzCBKuyuZ6ZkLgq1u446Ibv1KacV3YVQmPie8leLExIvKMvQS-cow
root@127.0.0.1:~# /app/dmsetup table
vg0-2006--09--18--10--52--24: 0 138625024 snapshot 253:2 253:7 P 128
vg0-lv0-real: 0 138625024 linear 9:0 2097536
vg0-2006--09--18--10--52--33-cow: 0 40370176 linear 9:0 382943616
vg0-2006--09--18--10--52--24-cow: 0 40370176 linear 9:0 221462912
vg0-2006--09--18--10--52--19: 0 138625024 snapshot 253:2 253:3 P 128
vg0-2006--09--18--10--52--36: 0 138625024 snapshot 253:2 253:17 P 128
vg0-2006--09--18--10--52--21: 0 138625024 snapshot 253:2 253:5 P 128
vg0-syslv: 0 2097152 linear 9:0 384
vg0-2006--09--18--10--52--33: 0 138625024 snapshot 253:2 253:15 P 128
vg0-2006--09--18--10--52--26-cow: 0 40370176 linear 9:0 261833088
vg0-2006--09--18--10--52--30-cow: 0 40370176 linear 9:0 342573440
vg0-lv0: 0 138625024 snapshot-origin 253:2
vg0-2006--09--18--10--52--36-cow: 0 41525248 linear 9:0 423313792
vg0-2006--09--18--10--52--21-cow: 0 40370176 linear 9:0 181092736
vg0-2006--09--18--10--52--28: 0 138625024 snapshot 253:2 253:11 P 128
vg0-2006--09--18--10--52--30: 0 138625024 snapshot 253:2 253:13 P 128
vg0-2006--09--18--10--52--28-cow: 0 40370176 linear 9:0 302203264
vg0-2006--09--18--10--52--26: 0 138625024 snapshot 253:2 253:9 P 128
vg0-2006--09--18--10--52--19-cow: 0 40370176 linear 9:0 140722560
root@127.0.0.1:~# /app/dmsetup status
vg0-2006--09--18--10--52--24: 0 138625024 snapshot 18475136/40370176
vg0-lv0-real: 0 138625024 linear
vg0-2006--09--18--10--52--33-cow: 0 40370176 linear
vg0-2006--09--18--10--52--24-cow: 0 40370176 linear
vg0-2006--09--18--10--52--19: 0 138625024 snapshot 18475136/40370176
vg0-2006--09--18--10--52--36: 0 138625024 snapshot 18475136/41525248
vg0-2006--09--18--10--52--21: 0 138625024 snapshot 18475136/40370176
vg0-syslv: 0 2097152 linear
vg0-2006--09--18--10--52--33: 0 138625024 snapshot 18475136/40370176
vg0-2006--09--18--10--52--26-cow: 0 40370176 linear
vg0-2006--09--18--10--52--30-cow: 0 40370176 linear
vg0-lv0: 0 138625024 snapshot-origin
vg0-2006--09--18--10--52--36-cow: 0 41525248 linear
vg0-2006--09--18--10--52--21-cow: 0 40370176 linear
vg0-2006--09--18--10--52--28: 0 138625024 snapshot 18475136/40370176
vg0-2006--09--18--10--52--30: 0 138625024 snapshot 18475136/40370176
vg0-2006--09--18--10--52--28-cow: 0 40370176 linear
vg0-2006--09--18--10--52--26: 0 138625024 snapshot 18475136/40370176
vg0-2006--09--18--10--52--19-cow: 0 40370176 linear

------=_NextPart_000_000E_01C6DB1F.05AAB320
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_NextPart_000_000E_01C6DB1F.05AAB320--
