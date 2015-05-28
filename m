From: Dennis Yang <shinrairis@gmail.com>
Subject: Poor snapshot performance in linux-3.19
Date: Thu, 28 May 2015 18:18:05 +0800
Message-ID: <CAKTMprNqkA2dvG3sQRKqWAttaLzicE7C4s6pftbnrqSg+0EJcw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,

I have a workstation which runs Fedora 21 with linux-3.19 kernel and
create a thin pool onto of a RAID0 (chunksize = 512KB) with five
Crucial 256GB SSDs.
[root@localhost ~]# dmsetup create pool --table "0 2478300160
thin-pool /dev/md0p1 /dev/md0p2 1024 0 1 skip_block_zeroing"

Then, I create a small thin volume with the following commands.
[root@localhost ~]# dmsetup message pool 0 "create_thin 0"
[root@localhost ~]# dmsetup create thin --table "0 400000000 thin
/dev/mapper/pool 0"

After that, I use both dd and fio for throughput testing and get the
following result.
[root@localhost ~]# dd if=/dev/zero of=/dev/mapper/thin bs=2M count=25k
25600+0 records in
25600+0 records out
53687091200 bytes (54 GB) copied, 29.0871 s, 1.8 GB/s

The 1.8 GB/s throughput looks pretty reasonable to me. However, after
taking a single snapshot of this thin device, I get a pretty low
throughput with the same command.
[root@localhost ~]# dd if=/dev/zero of=/dev/mapper/thin bs=2M count=25k
25600+0 records in
25600+0 records out
53687091200 bytes (54 GB) copied, 191.495 s, 280 MB/s

I am aware of that writing to a snapshotted device will trigger lots
of copy-on-write requests, so I was expecting a 50~60% performance
loss in this case. However, 85% performance loss can be observed in my
test above. Am I doing anything wrong or is there anything I can tune
to make this right? If someone can point direction for me, I am glad
to test or even modify the source code to solve this case.

Thanks,
Dennis
