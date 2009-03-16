From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Poor iSCSI performance
Date: Mon, 16 Mar 2009 05:58:57 -0400
Message-ID: <1237197537.6525.60.camel@jaspav.missionsit.net.missionsit.net>
References: <1237197464.6525.58.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-9GCwio6DU5OkTDYzYpo7"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237197464.6525.58.camel@jaspav.missionsit.net.missionsit.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-9GCwio6DU5OkTDYzYpo7
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-03-16 at 05:57 -0400, John A. Sullivan III wrote:
> Hello, all.  We've been struggling to tweak performance between on Linux
> iSCSI initiators (open-iscsi) and our opensolar iSCSI targets (Nexenta).
> On top of our generally poor performance (max 7000 IOPS per GbE NIC), we
> are seeing abysmal performance when we try to compensate by using either
> dm-multipath or dmadm to use multiple iSCSI LUNs.
> 
> We have been testing using an eight processor Linux server with 6 GbE
> network interfaces speaking to a Nexenta based Z200 storage system from
> Pogo Linux with 10 GbE ports.  I will attach a text file with some
> results using disktest.
> 
> In summary, if we ran four completely independent tests against four
> separate targets on four separate NICs, we achieved an aggregate 24940
> IOPS with 512 byte blocks and 6713 IOPS with 64KB blocks.
> 
> However, we would prefer to treat the storage as a single disk and so
> attempted to use software RAID, i.e., we created four LUNs, presented
> them as four separate disks and then used software RAID0 to stripe
> across all four targets.  We expected slightly less than the performance
> cited above.  Instead, we received 4450 IOPS for 512 and for 64KB.
> 
> We then took a different approach and created one big LUN with eight
> paths to the target using dm-multipath multibus with round-robin
> scheduling and rr_min_io=100.  Our numbers were 4350 IOPS for 512 and
> 1450 IOPS with 64KB.
> 
> We then suspected it might an issue of the number of threads rather than
> just the number of disks, i.e., the four independent disk test was using
> four separate processes.  So we ran four separate, concurrent tests
> against the RAID0 array and the multipath setup.
> 
> RAID0 increased to 11720 IOPS for 512 and 3188 IOPS for 64 KB - still a
> far cry from 24900 and and 6713.  dm-multipath numbers were 10140 IOPS
> for 512 and 2563 IOPS for 64KB.  Moreover, the CPU utilization was
> brutal.
> 
> /etc/multipath.conf:
> blacklist {
> #        devnode "*"
>         # sdb
>         wwid SATA_ST3250310NS_9SF0L234
>         #sda
>         wwid SATA_ST3250310NS_9SF0LVSR
>         # The above does not seem to be working thus we will do
>         devnode "^sd[ab]$"
>         # This is usually a bad idea as the device names can change
>         # However, since we add our iSCSI devices long after boot, I
> think we are safe
> }
> defaults {
>         udev_dir                /dev
>         polling_interval        5
>         selector                "round-robin 0"
>         path_grouping_policy    multibus
>         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>         prio_callout            /bin/true
>         path_checker            readsector0
>         rr_min_io               100
>         max_fds                 8192
>         rr_weight               priorities
>         failback                immediate
>         no_path_retry           fail
> #       user_friendly_names     yes
> }
> multipaths {
>         multipath {
>                 wwid
> 3600144f0e2824900000049b98e2b0001
>                 alias                   isda
>         }
>         multipath {
>                 wwid
> 3600144f0e2824900000049b062950002
>                 alias                   isdplain
>         }
>         multipath {
>                 wwid
> 3600144f0e2824900000049b9bb350001
>                 alias                   isdb
>         }
>         multipath {
>                 wwid
> 3600144f0e2824900000049b9bb350002
>                 alias                   isdc
>         }
>         multipath {
>                 wwid
> 3600144f0e2824900000049b9bb360003
>                 alias                   isdd
>         }
>         multipath {
>                 wwid
> 3600144f0e2824900000049b7878a0006
>                 alias                   isdtest
>         }
> }
> devices {
>        device {
>                vendor                  "NEXENTA"
>                product                 "COMSTAR"
> #               vendor                  "SUN"
> #               product                 "SOLARIS"
>                getuid_callout          "/sbin/scsi_id -g -u -s /block/%
> n"
>                features                "0"
>                hardware_handler        "0"
> #               path_grouping_policy    failover
>                rr_weight               uniform
> #               rr_min_io               1000
>                path_checker            readsector0
>        }
> }
> 
> What would account for such miserable performance? How can we improve
> it? We do not want to proliferate disks just to increase aggregate
> performance.  Thanks - John
Oops! Forgot to attach the file - John

-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society

--=-9GCwio6DU5OkTDYzYpo7
Content-Disposition: attachment; filename=DiskTestNotes.txt
Content-Type: text/plain; name=DiskTestNotes.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

Disktest notes

./disktest -B512 -h1 -ID -pL -K100 -PT -T300 -r /dev/raw/raw1 

Eight paths to one target - round robin multipath:
512 blocks - 4350 IOPS:

Tasks: 212 total,   1 running, 211 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  1.5%sy,  0.0%ni,  0.0%id, 96.9%wa,  0.2%hi,  1.4%si,  0.0%st
Cpu2  :  0.0%us,  1.0%sy,  0.0%ni,  0.4%id, 96.8%wa,  0.4%hi,  1.4%si,  0.0%st
Cpu3  :  0.0%us,  0.1%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.1%hi,  0.1%si,  0.0%st
Cpu4  :  0.1%us,  1.8%sy,  0.0%ni,  0.0%id, 94.9%wa,  0.3%hi,  2.9%si,  0.0%st
Cpu5  :  0.2%us,  1.5%sy,  0.0%ni,  0.0%id, 96.2%wa,  0.3%hi,  1.8%si,  0.0%st
Cpu6  :  0.0%us,  0.1%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.1%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st


64K blocks - 2000 - 2200 IOPS: (1450 with multipath - I forgot to start multipathd the first time)

top - 21:59:45 up 55 min,  2 users,  load average: 89.52, 44.36, 23.60
Tasks: 212 total,   1 running, 211 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.3%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.2%sy,  0.0%ni, 85.7%id, 14.0%wa,  0.0%hi,  0.1%si,  0.0%st
Cpu2  :  0.1%us,  2.1%sy,  0.0%ni,  0.0%id, 91.3%wa,  1.2%hi,  5.3%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni, 98.6%id,  1.4%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.2%us,  1.8%sy,  0.0%ni,  0.0%id, 89.2%wa,  0.4%hi,  8.4%si,  0.0%st
Cpu5  :  0.2%us,  2.3%sy,  0.0%ni,  0.0%id, 93.3%wa,  0.2%hi,  4.0%si,  0.0%st
Cpu6  :  0.0%us,  1.7%sy,  0.0%ni,  0.0%id, 94.9%wa,  0.2%hi,  3.2%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni, 89.2%id, 10.8%wa,  0.0%hi,  0.0%si,  0.0%st

RAID0 across four targets
512 blocks - 4450 IOPS
top - 22:20:36 up  1:16,  2 users,  load average: 81.25, 34.24, 24.49
Tasks: 288 total,   1 running, 287 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  1.2%sy,  0.0%ni,  0.0%id, 96.4%wa,  0.3%hi,  2.1%si,  0.0%st
Cpu2  :  0.0%us,  0.3%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.2%si,  0.0%st
Cpu3  :  0.1%us,  3.3%sy,  0.0%ni,  0.0%id, 92.1%wa,  0.5%hi,  4.0%si,  0.0%st
Cpu4  :  0.1%us,  1.3%sy,  0.0%ni,  0.0%id, 96.1%wa,  0.7%hi,  1.8%si,  0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni, 99.6%id,  0.0%wa,  0.1%hi,  0.3%si,  0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni, 99.9%id,  0.0%wa,  0.1%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:  33020800k total,   497424k used, 32523376k free,    26504k buffers

64K blocks - 1280 IOPS

top - 22:23:26 up  1:19,  2 users,  load average: 97.37, 60.75, 36.23
Tasks: 288 total,   1 running, 287 sleeping,   0 stopped,   0 zombie
Cpu0  :  1.5%us,  0.5%sy,  0.0%ni, 85.3%id, 12.5%wa,  0.0%hi,  0.2%si,  0.0%st
Cpu1  :  0.1%us,  2.6%sy,  0.0%ni,  0.0%id, 92.2%wa,  0.5%hi,  4.6%si,  0.0%st
Cpu2  :  0.0%us,  0.1%sy,  0.0%ni, 88.6%id,  9.9%wa,  0.4%hi,  1.0%si,  0.0%st
Cpu3  :  0.0%us,  5.1%sy,  0.0%ni,  0.0%id, 87.2%wa,  0.5%hi,  7.2%si,  0.0%st
Cpu4  :  1.7%us,  1.0%sy,  0.0%ni, 13.1%id, 78.4%wa,  1.2%hi,  4.6%si,  0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu6  :  0.0%us,  0.1%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.1%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

Four separate disks as four separate PVs placed in one VG and one LV
512 blocks - 5750 - 5800 IOPS
top - 22:44:12 up 13 min,  2 users,  load average: 89.54, 36.43, 13.60
Tasks: 241 total,   1 running, 240 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.1%us,  3.7%sy,  0.0%ni,  0.0%id, 90.1%wa,  1.6%hi,  4.5%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  1.0%sy,  0.0%ni, 98.3%id,  0.0%wa,  0.0%hi,  0.7%si,  0.0%st
Cpu4  :  0.2%us,  2.2%sy,  0.0%ni,  0.0%id, 93.6%wa,  0.6%hi,  3.4%si,  0.0%st
Cpu5  :  0.1%us,  2.4%sy,  0.0%ni,  0.0%id, 94.2%wa,  0.5%hi,  2.8%si,  0.0%st
Cpu6  :  0.1%us,  0.1%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.1%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

64K blocks - 1300 IOPS
top - 22:46:03 up 15 min,  2 users,  load average: 94.37, 53.52, 22.27
Tasks: 241 total,   1 running, 240 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.6%us,  0.1%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  1.8%sy,  0.0%ni, 24.5%id, 61.0%wa,  2.7%hi, 10.0%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.5%us,  5.9%sy,  0.0%ni,  0.0%id, 86.9%wa,  0.5%hi,  6.2%si,  0.0%st
Cpu5  :  0.1%us,  6.9%sy,  0.0%ni,  0.0%id, 85.7%wa,  0.8%hi,  6.5%si,  0.0%st
Cpu6  :  0.1%us,  0.1%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:  33020800k total,   400224k used, 32620576k free,    20896k buffers

Four separate disks - aggregate of four separate parallel tests
512 blocks - 24940 IOPS
top - 22:58:33 up 7 min,  5 users,  load average: 329.69, 117.85, 42.52
Tasks: 249 total,   1 running, 248 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.7%us,  0.1%sy,  0.0%ni, 99.2%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  1.9%us, 16.0%sy,  0.0%ni,  0.0%id, 51.5%wa,  8.3%hi, 22.3%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  2.7%sy,  0.0%ni, 21.4%id, 74.6%wa,  0.0%hi,  1.3%si,  0.0%st
Cpu4  :  0.7%us,  5.5%sy,  0.0%ni,  0.0%id, 82.5%wa,  1.4%hi,  9.9%si,  0.0%st
Cpu5  :  0.5%us,  6.0%sy,  0.0%ni,  0.0%id, 82.0%wa,  1.6%hi,  9.9%si,  0.0%st
Cpu6  :  0.0%us,  0.1%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.1%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  5.2%sy,  0.0%ni, 20.2%id, 71.5%wa,  0.0%hi,  3.1%si,  0.0%st

64K blocks - 6713 IOPS
top - 23:01:53 up 10 min,  5 users,  load average: 363.88, 219.53, 96.34
Tasks: 249 total,   1 running, 248 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.9%us,  0.1%sy,  0.0%ni, 99.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.5%us,  5.1%sy,  0.0%ni,  0.0%id, 73.8%wa,  4.3%hi, 16.3%si,  0.0%st
Cpu2  :  0.0%us,  0.6%sy,  0.0%ni, 41.1%id, 58.0%wa,  0.0%hi,  0.3%si,  0.0%st
Cpu3  :  0.0%us,  0.1%sy,  0.0%ni, 99.9%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.4%us,  3.0%sy,  0.0%ni,  0.0%id, 89.4%wa,  0.6%hi,  6.6%si,  0.0%st
Cpu5  :  0.2%us,  2.5%sy,  0.0%ni,  0.0%id, 89.8%wa,  0.6%hi,  6.9%si,  0.0%st
Cpu6  :  0.1%us,  0.0%sy,  0.0%ni, 99.9%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  1.2%sy,  0.0%ni, 40.9%id, 57.3%wa,  0.0%hi,  0.6%si,  0.0%st

3.4 Gbps however the switches do not seem to reflect this throughput:

switchdc1_01> sho int po
 Status and Counters - Port Utilization

                                 Rx                           Tx
 Port      Mode     | --------------------------- | ---------------------------
                    | Kbits/sec   Pkts/sec  Util  | Kbits/sec  Pkts/sec   Util
 --------- -------- + ---------- ---------- ----- + ---------- ---------- -----
 1         100FDx   | 488        5          00.48 | 512        6          00.51
 2-Trk24   1000FDx  | 5000       0          00.50 | 1624       0          00.16
 3         1000FDx  | 4896       3          00.48 | 4888       0          00.48
 4         1000FDx  | 5000       5          00.50 | 5000       4          00.50
 5         1000FDx  | 0          0          0     | 0          0          0
 6         1000FDx  | 4896       1          00.48 | 5000       2          00.50
 7         1000FDx  | 5000       3          00.50 | 5000       0          00.50
 8         1000FDx  | 344904     6788       34.49 | 8616       4253       00.86
 9         1000FDx  | 0          0          0     | 5000       0          00.50
 10        1000FDx  | 4776       2          00.47 | 4888       2          00.48
 11        100FDx   | 0          0          0     | 496        0          00.49
 12        1000FDx  | 5000       3          00.50 | 5000       0          00.50
 13        1000FDx  | 5000       3          00.50 | 5008       8          00.50
 14        1000FDx  | 4856       1          00.48 | 5000       2          00.50
 15        1000FDx  | 0          0          0     | 0          0          0
 16        1000FDx  | 120        0          00.01 | 5000       0          00.50
 17        1000FDx  | 0          0          0     | 0          0          0
 18        1000FDx  | 8456       4224       00.84 | 344320     6757       34.43
 19        1000FDx  | 0          0          0     | 0          0          0
 20        1000FDx  | 1320       0          00.13 | 5000       0          00.50
 21        100FDx   | 0          0          0     | 496        0          00.49
 22        1000FDx  | 4864       1          00.48 | 5000       2          00.50
 23-Trk24  1000FDx  | 4848       8          00.48 | 2496       0          00.24
 24-Trk24  1000FDx  | 4984       0          00.49 | 4992       3          00.49

switchdc1_02> sho int po
 Status and Counters - Port Utilization

                                 Rx                           Tx
 Port      Mode     | --------------------------- | ---------------------------
                    | Kbits/sec   Pkts/sec  Util  | Kbits/sec  Pkts/sec   Util
 --------- -------- + ---------- ---------- ----- + ---------- ---------- -----
 1         1000FDx  | 0          0          0     | 0          0          0
 2-Trk24   1000FDx  | 1672       0          00.16 | 5000       0          00.50
 3         1000FDx  | 4992       8          00.49 | 5000       8          00.50
 4         1000FDx  | 8400       4186       00.84 | 341664     6698       34.16
 5         1000FDx  | 0          0          0     | 0          0          0
 6         1000FDx  | 14160      10807      01.41 | 855656     17153      85.56
 7         1000FDx  | 0          0          0     | 0          0          0
 8         1000FDx  | 120        0          00.01 | 5000       0          00.50
 9         1000FDx  | 0          0          0     | 0          0          0
 10        1000FDx  | 160        0          00.01 | 5000       0          00.50
 11        1000FDx  | 0          0          0     | 0          0          0
 12        1000FDx  | 5000       3          00.50 | 5000       0          00.50
 13        1000FDx  | 5000       7          00.50 | 5000       3          00.50
 14        1000FDx  | 4856       1          00.48 | 5000       2          00.50
 15        1000FDx  | 0          0          0     | 5000       0          00.50
 16        1000FDx  | 855864     17156      85.58 | 14240      10806      01.42
 17        1000FDx  | 5000       3          00.50 | 5000       0          00.50
 18        1000FDx  | 4824       1          00.48 | 5000       2          00.50
 19        1000FDx  | 0          0          0     | 0          0          0
 20        1000FDx  | 342296     6734       34.22 | 8592       4219       00.85
 21        100FDx   | 0          0          0     | 496        0          00.49
 22        1000FDx  | 5008       6          00.50 | 5000       0          00.50
 23-Trk24  1000FDx  | 2408       0          00.24 | 4848       8          00.48
 24-Trk24  1000FDx  | 4992       4          00.49 | 4992       0          00.49

Does bonding targets (LVM, RAID) or multipathing dramatically reduce throughput or is it a consequence of running four separate tests? Let's run four separate tests agains RAID0 and against one target with eight paths in round robin.

RAID0 - four concurrent tests
512 blocks - 2930 IOPS = 11720 IOPS
top - 23:19:33 up 28 min,  5 users,  load average: 381.54, 241.74, 193.55
Tasks: 249 total,   1 running, 248 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.2%us,  1.8%sy,  0.0%ni,  0.0%id, 94.9%wa,  0.9%hi,  2.2%si,  0.0%st
Cpu2  :  0.0%us,  0.4%sy,  0.0%ni, 99.4%id,  0.0%wa,  0.0%hi,  0.2%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.1%us,  1.0%sy,  0.0%ni,  0.0%id, 96.8%wa,  0.3%hi,  1.8%si,  0.0%st
Cpu5  :  0.0%us,  1.6%sy,  0.0%ni,  0.0%id, 96.3%wa,  0.3%hi,  1.8%si,  0.0%st
Cpu6  :  0.0%us,  0.1%sy,  0.0%ni, 99.8%id,  0.1%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

64K blocks - 797 IOPS * 4 = 3188 IOPS
top - 23:22:23 up 31 min,  5 users,  load average: 365.45, 277.87, 214.36
Tasks: 249 total,   1 running, 248 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.5%us,  0.0%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.9%sy,  0.0%ni,  0.0%id, 94.0%wa,  0.9%hi,  4.2%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.6%us,  3.2%sy,  0.0%ni,  0.0%id, 93.8%wa,  0.1%hi,  2.3%si,  0.0%st
Cpu5  :  0.0%us,  2.4%sy,  0.0%ni,  0.0%id, 95.1%wa,  0.2%hi,  2.3%si,  0.0%st
Cpu6  :  0.0%us,  0.1%sy,  0.0%ni, 99.7%id,  0.1%wa,  0.1%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.1%sy,  0.0%ni, 76.6%id, 23.3%wa,  0.0%hi,  0.0%si,  0.0%st

Multipath round robin - four concurrent tests
512 blocks - 10140 IOPS
top - 23:31:43 up 5 min,  5 users,  load average: 285.93, 89.10, 31.16
Tasks: 210 total,   1 running, 209 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.1%sy,  0.0%ni, 73.5%id, 26.4%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.1%us,  1.3%sy,  0.0%ni,  0.0%id, 98.2%wa,  0.0%hi,  0.4%si,  0.0%st
Cpu2  :  0.4%us,  4.2%sy,  0.0%ni,  0.0%id, 88.5%wa,  0.7%hi,  6.2%si,  0.0%st
Cpu3  :  0.1%us,  1.7%sy,  0.0%ni,  0.0%id, 97.4%wa,  0.0%hi,  0.8%si,  0.0%st
Cpu4  :  0.3%us,  3.7%sy,  0.0%ni,  0.0%id, 88.1%wa,  0.8%hi,  7.1%si,  0.0%st
Cpu5  :  0.1%us,  1.7%sy,  0.0%ni,  0.0%id, 97.2%wa,  0.0%hi,  1.0%si,  0.0%st
Cpu6  :  0.1%us,  1.5%sy,  0.0%ni,  0.0%id, 97.9%wa,  0.0%hi,  0.5%si,  0.0%st
Cpu7  :  0.0%us,  0.2%sy,  0.0%ni, 28.8%id, 71.0%wa,  0.0%hi,  0.0%si,  0.0%st

64K blocks - 2563 IOPS
top - 23:38:23 up 11 min,  5 users,  load average: 388.21, 292.94, 147.88
Tasks: 210 total,   1 running, 209 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.1%us,  0.5%sy,  0.0%ni,  0.0%id, 99.3%wa,  0.0%hi,  0.1%si,  0.0%st
Cpu1  :  0.1%us,  0.5%sy,  0.0%ni,  0.0%id, 99.3%wa,  0.0%hi,  0.1%si,  0.0%st
Cpu2  :  0.1%us,  1.0%sy,  0.0%ni,  0.0%id, 95.5%wa,  0.1%hi,  3.3%si,  0.0%st
Cpu3  :  0.1%us,  0.6%sy,  0.0%ni,  0.0%id, 99.3%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.0%us,  1.1%sy,  0.0%ni,  0.0%id, 94.7%wa,  0.3%hi,  3.9%si,  0.0%st
Cpu5  :  0.1%us,  0.6%sy,  0.0%ni,  0.0%id, 99.1%wa,  0.0%hi,  0.2%si,  0.0%st
Cpu6  :  0.0%us,  0.4%sy,  0.0%ni,  0.0%id, 99.6%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.1%us,  0.4%sy,  0.0%ni,  0.0%id, 99.5%wa,  0.0%hi,  0.0%si,  0.0%st

--=-9GCwio6DU5OkTDYzYpo7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-9GCwio6DU5OkTDYzYpo7--
