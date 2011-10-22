From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Simulating faulty disk
Date: Sat, 22 Oct 2011 00:16:50 -0600
Message-ID: <4EA25FD2.8060706@cs.utah.edu>
References: <4E9F9321.8090704@cs.utah.edu> <4E9FE97E.4030209@redhat.com>
	<4EA04201.1050702@cs.utah.edu> <4EA044A9.6070406@redhat.com>
	<4EA05072.10107@cs.utah.edu> <4EA05D0A.7030909@redhat.com>
	<4EA06020.9000708@cs.utah.edu> <4EA13A52.60902@redhat.com>
	<4EA18610.3050900@cs.utah.edu> <4EA1881B.5070607@redhat.com>
	<4EA188F3.4000206@cs.utah.edu> <4EA18C11.5060600@cs.utah.edu>
	<4EA18DF3.3000800@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EA18DF3.3000800@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

All I want to do is simulate a delay or flakey device. Mount it. And see 
how regular read/write commands
such as cat, echo, vim etc behave.

*  I created a delay device d0 and mounted it on /mnt
*  Copied few files into /mnt
*  Invoked dd command on /dev/mapper/d0 and it was slow
*  Invoked cat command on some file in /mnt but it was not slow

What is wrong here?

Steps I followed are shown below:
==========================================================
root@nodea:/users/ydev# dmsetup remove_all

#Created a delay device d0
root@nodea:/users/ydev# dmsetup create d0 --table="0 `blockdev --getsize 
/dev/sdb` delay /dev/sdb 0 500"

#Put a filesystem on top of d0
root@nodea:/users/ydev# mkfs -t ext3 /dev/mapper/d0
mke2fs 1.41.11 (14-Mar-2010)
Filesystem label=
OS type: Linux
....
....
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
....

#Mounted the device-mapper device on /mnt.
root@nodea:/users/ydev# mount -t ext3 /dev/mapper/d0 /mnt

#Copied some arbitrary files into /mnt
root@nodea:/users/ydev# cp -r stap_tests /mnt

#Invoked a dd command to check if it is slowing down and it did as seen 
below.

root@nodea:/# dd if=/dev/mapper/d0 of=/dev/null bs=400k count=1
1+0 records in
1+0 records out
409600 bytes (410 kB) copied, 1.01523 s, 403 kB/s

#But it did not slow down cat command as seen below.

root@nodea:/mnt/stap_tests# sysctl vm.drop_caches=3
vm.drop_caches = 3

root@nodea:/mnt/stap_tests# time cat 12M > /dev/null

real    0m0.034s
user    0m0.000s
sys     0m0.004s

==========================================================

Thanks,
Yathi



On 10/21/2011 9:21 AM, Bryn M. Reeves wrote:
> On 10/21/2011 04:13 PM, Yathindra wrote:
>> >mount -t ext3 /dev/sdb /mnt
>> Copied some data into /mnt
>> >dmsetup create d0 --table="0 `blockdev --getsize /dev/sdb` delay
>> /dev/sdb 0 500"
>> device-mapper: reload ioctl failed: Invalid argument
>> Command failed
>
> You can't create a mapped device on something while it is mounted as 
> device-mapper needs to open it exclusively.
>
>> But as seen from above, dmsetup is failing to create a flakey/delay
>> device when /dev/sdb
>> has a filesystem on top of it. Is there any workaround ?
>
> Set up the file system the way you want it on sdb first. Then unmount 
> it and create the device-mapper devices and mount that.
>
> Regards,
> Bryn.
