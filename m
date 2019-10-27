From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: dm-zoned performance degradation after apply
 75d66ffb48efb3 ("dm zoned:, properly handle backing device failure")
Date: Sun, 27 Oct 2019 02:56:20 +0000
Message-ID: <38d2a401ad8111ec0e6806f3e165916b18769d6d.camel@wdc.com>
References: <203cc4c8-b380-5b2f-c9e7-766b3f031c8c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <203cc4c8-b380-5b2f-c9e7-766b3f031c8c@huawei.com>
Content-Language: en-US
Content-ID: <EBFC659219E425459E666222A676A219@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "zhangxiaoxu5@huawei.com" <zhangxiaoxu5@huawei.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

Zhang,

I just did some testing of this scenario with a recent kernel that includes this patch.

The log below is a run in QEMU with 8 CPUs and it took 18.5 minutes to create the FS on a
14TB ATA drive. Doing the same thing on bare metal with 32 CPUs takes 10.5 minutes in my
environment. However, when doing the same test with a SAS drive, the run takes 43 minutes.
This is not quite the degradation you are observing, but still a big performance hit.

Is the disk that you are using SAS or SATA?

My current guess is that sd driver may generate some TEST UNIT READY commands to check if
the drive is really online as a part of check_events() processing. For ATA drives, this is
nearly a NOP since all TURs are completed internally in libata. But, in SCSI case, these
blocking TURs are issued to the drive and certainly may degrade performance.

The check_events() call has been added to bdev_device_is_dying() because simply calling
bdev_queue_dying() doesn't cover the situation when the drive gets offlined in SCSI layer.
It might be possible to only call check_events() once before every reclaim run and to avoid
calling it in I/O mapping path. If this works, the overhead would likely be acceptable.
I am going to take a look into this.

Regards,
Dmitry

[root@xxx dmz]# uname -a
Linux xxx 5.4.0-rc1-DMZ+ #1 SMP Fri Oct 11 11:23:13 PDT 2019 x86_64 x86_64 x86_64 GNU/Linux
[root@xxx dmz]# lsscsi
[0:0:0:0]    disk    QEMU     QEMU HARDDISK    2.5+  /dev/sda 
[1:0:0:0]    zbc     ATA      HGST HSH721415AL T240  /dev/sdb 
[root@xxx dmz]# ./setup-dmz test /dev/sdb
[root@xxx dmz]# cat /proc/kallsyms | grep dmz_bdev_is_dying
(standard input):90782:ffffffffc070a401 t dmz_bdev_is_dying.cold	[dm_zoned]
(standard input):90849:ffffffffc0706e10 t dmz_bdev_is_dying	[dm_zoned]
[root@xxx dmz]# time mkfs.ext4 /dev/mapper/test
mke2fs 1.44.6 (5-Mar-2019)
Discarding device blocks: done                            
Creating filesystem with 3660840960 4k blocks and 457605120 inodes
Filesystem UUID: 4536bacd-cfb5-41b2-b0bf-c2513e6e3360
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
	102400000, 214990848, 512000000, 550731776, 644972544, 1934917632, 
	2560000000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done         


real	18m30.867s
user	0m0.172s
sys	0m11.198s


On Sat, 2019-10-26 at 09:56 +0800, zhangxiaoxu (A) wrote:
> Hi all, when I 'mkfs.ext4' on the dmz device based on 10T smr disk,
> it takes more than 10 hours after apply 75d66ffb48efb3 ("dm zoned:
> properly handle backing device failure").
> 
> After delete the 'check_events' in 'dmz_bdev_is_dying', it just
> take less than 12 mins.
> 
> I test it based on 4.19 branch.
> Must we do the 'check_events' at mapping path, reclaim or metadata I/O?
> 
> Thanks.
> 
