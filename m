From: Dennis Yang <shinrairis@gmail.com>
Subject: Re: Poor snapshot performance in linux-3.19
Date: Fri, 29 May 2015 11:03:28 +0800
Message-ID: <CAKTMprOX0aF_vwWeO7hFSk9F+AekbqpPLYp7vV+UtCNhGaYXKg@mail.gmail.com>
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

> Dne 28.5.2015 v 12:18 Dennis Yang napsal(a):
>> Hi,
>>
>> I have a workstation which runs Fedora 21 with linux-3.19 kernel and
>> create a thin pool onto of a RAID0 (chunksize = 512KB) with five
>> Crucial 256GB SSDs.
>> [root@localhost ~]# dmsetup create pool --table "0 2478300160
>> thin-pool /dev/md0p1 /dev/md0p2 1024 0 1 skip_block_zeroing"
>>
>> Then, I create a small thin volume with the following commands.
>> [root@localhost ~]# dmsetup message pool 0 "create_thin 0"
>> [root@localhost ~]# dmsetup create thin --table "0 400000000 thin
>> /dev/mapper/pool 0"
>>
>> After that, I use both dd and fio for throughput testing and get the
>> following result.
>> [root@localhost ~]# dd if=/dev/zero of=/dev/mapper/thin bs=2M count=25k
>> 25600+0 records in
>> 25600+0 records out
>> 53687091200 bytes (54 GB) copied, 29.0871 s, 1.8 GB/s
>>
>> The 1.8 GB/s throughput looks pretty reasonable to me. However, after
>> taking a single snapshot of this thin device, I get a pretty low
>> throughput with the same command.
>> [root@localhost ~]# dd if=/dev/zero of=/dev/mapper/thin bs=2M count=25k
>> 25600+0 records in
>> 25600+0 records out
>> 53687091200 bytes (54 GB) copied, 191.495 s, 280 MB/s
>>
>> I am aware of that writing to a snapshotted device will trigger lots
>> of copy-on-write requests, so I was expecting a 50~60% performance
>> loss in this case. However, 85% performance loss can be observed in my
>> test above. Am I doing anything wrong or is there anything I can tune
>> to make this right? If someone can point direction for me, I am glad
>> to test or even modify the source code to solve this case.
>
>
> Hi
>
> Using  0.5MB chunks and expecting fast snapshots is not going to work.
> Have you measured speed with smaller chunks -  i.e. 64k/128k ?
>
> Zdenek
>

Hi,

I have run the same test on pool with 64K/128K block size thin-pool on
linux-3.19 and get these results.
<<< 64k block size - before snapshot>>>
[root@localhost ~]# dd if=/dev/zero of=/dev/mapper/thin bs=2M
count=25k
25600+0 records in
25600+0 records out
53687091200 bytes (54 GB) copied, 205.887 s, 261 MB/s

<<< 64k block size - after snapshot>>>
[root@localhost ~]# dd if=/dev/zero of=/dev/mapper/thin bs=2M
count=25k
25600+0 records in
25600+0 records out
53687091200 bytes (54 GB) copied, 205.887 s, 261 MB/s

<<< 128k block size - before snapshot>>>
[root@localhost ~]# dd if=/dev/zero of=/dev/mapper/thin bs=2M count=25k
25600+0 records in
25600+0 records out
53687091200 bytes (54 GB) copied, 29.5981 s, 1.8 GB/s

<<< 128k block size - after snapshot>>>
[root@localhost ~]# dd if=/dev/zero of=/dev/mapper/thin bs=2M
count=25k
25600+0 records in
25600+0 records out
53687091200 bytes (54 GB) copied, 197.798 s, 271 MB/s

I also run the similar test with fio to observe the throughput across
the snapshot test. The throughput will first reach 1.1GB/s and then
keep bouncing between 700MB/s to 40MB/s.
The average queue size of data device will keep bouncing between 700k
~ 200k, while the average queue size of RAID0 could reach 7 million.
One thing weird is that even after the test is over, the avgqu-sz of
RAID0 is still around 2 million with 100% utilization.

The server I have tested is equipped with Xeon E3-1246 with 4 physical
cores, so I think CPU might not be the bottleneck of the storage
throughput.
Any idea?

Dennis
