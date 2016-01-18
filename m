From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Re: device mapper increased latency on RAID array
Date: Mon, 18 Jan 2016 10:52:27 +0000
Message-ID: <CAM2wQBtN_uxfDBxc0og9p=iXnFg3TXP6ddxpD6SbrL8NCvdeWw@mail.gmail.com>
References: <CAM2wQBvNvm+0i1fkstDvez7yskd7RT_g+cCMfUavw20ksDzYXg@mail.gmail.com>
	<56996CF5.5060008@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56996CF5.5060008@redhat.com>
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

I used fio and got the exact same results, so it doesn't seem to be
tool-related. Indeed the RAID controller (PERC H730P Mini) and SSDs
(INTEL SSDSC1BG200G4R) are quite fast. I cannot reproduce this on any
other configuration either (e.g. another disk, ramdisk, etc.) so it
definitely has something to do with the controller.

I used blktrace and here's the output, on the SSD passed through by
the RAID controller:

ioping-8868  [002]  5666.780726:   8,32   Q   R 232955928 + 8 [ioping]
ioping-8868  [002]  5666.780731:   8,32   G   R 232955928 + 8 [ioping]
ioping-8868  [002]  5666.780732:   8,32   P   N [ioping]
ioping-8868  [002]  5666.780733:   8,32   I   R 232955928 + 8 [ioping]
ioping-8868  [002]  5666.780734:   8,32   U   N [ioping] 1
ioping-8868  [002]  5666.780735:   8,32   D   R 232955928 + 8 [ioping]
<idle>-0     [014]  5666.780803:   8,32   C   R 232955928 + 8 [0]

And on the RAID array:

ioping-8869  [003]  5673.729427:   8,32   A   R 1696736 + 8 <- (253,1) 1696736
ioping-8869  [003]  5673.729429:   8,32   Q   R 1696736 + 8 [ioping]
ioping-8869  [003]  5673.729431:   8,32   G   R 1696736 + 8 [ioping]
ioping-8869  [003]  5673.729432:   8,32   P   N [ioping]
ioping-8869  [003]  5673.729433:   8,32   I   R 1696736 + 8 [ioping]
ioping-8869  [003]  5673.729434:   8,32   U   N [ioping] 1
ioping-8869  [003]  5673.729435:   8,32   D   R 1696736 + 8 [ioping]
<idle>-0     [001]  5673.729615:   8,32   C   R 1696736 + 8 [0]

In both cases the vast majority of time is spent doing I/O (77 us vs.
188 us), as expected. Also, DM's remap overhead is negligible. The
exact same sectors are
accessed so it doesn't seem related to alignment etc.

On 15 January 2016 at 22:04, Heinz Mauelshagen <heinzm@redhat.com> wrote:
>
> You can use blktrace to figure which block device introduces the latencies.
>
>
>
> On 01/14/2016 05:21 PM, Thanos Makatos wrote:
>>
>> I noticed that when a linear device mapper target is used on top of a
>> RAID array (made of SSDs), latency is 3 times higher than accessing
>> the RAID array itself. Strangely, when I do the same test to an SSD on
>> the controller that is passed through (not configured in an array),
>> latency is unaffected.
>>
>> /dev/sda is the SSD passed through from the RAID controller.
>> /dev/sdc is the block device in the RAID array.
>>
>> [ ~]# dmsetup create sda --table "0 $((2**30/512)) linear /dev/sda 0
>> [ ~]# dmsetup create sdc --table "0 $((2**30/512)) linear /dev/sdc 0
>> [ ~]# echo noop > /sys/block/sda/queue/scheduler
>> [ ~]# echo noop > /sys/block/sdc/queue/scheduler
>>
>> [ ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/sda
>>
>> --- /dev/sda (block device 186.3 GiB) ioping statistics ---
>> 10 k requests completed in 377.9 ms, 39.1 MiB read, 26.5 k iops, 103.4
>> MiB/s
>> min/avg/max/mdev = 31 us / 37 us / 140 us / 20 us
>>
>> [ ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/mapper/sda
>>
>> --- /dev/mapper/sda (block device 1 GiB) ioping statistics ---
>> 10 k requests completed in 387.5 ms, 39.1 MiB read, 25.8 k iops, 100.8
>> MiB/s
>> min/avg/max/mdev = 36 us / 38 us / 134 us / 5 us
>>
>> [root@192.168.1.130 ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/mapper/sdc
>>
>> --- /dev/mapper/sdc (block device 1 GiB) ioping statistics ---
>> 10 k requests completed in 1.33 s, 39.1 MiB read, 7.50 k iops, 29.3 MiB/s
>> min/avg/max/mdev = 112 us / 133 us / 226 us / 11 us
>> [ ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/sdc
>>
>> --- /dev/sdc (block device 1.45 TiB) ioping statistics ---
>> 10 k requests completed in 477.8 ms, 39.1 MiB read, 20.9 k iops, 81.7
>> MiB/s
>> min/avg/max/mdev = 36 us / 47 us / 158 us / 18 us
>>
>> [ ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/mapper/sdc
>>
>> --- /dev/mapper/sdc (block device 1 GiB) ioping statistics ---
>> 10 k requests completed in 1.33 s, 39.1 MiB read, 7.50 k iops, 29.3 MiB/s
>> min/avg/max/mdev = 111 us / 133 us / 181 us / 11 us
>>
>> These results are reproduced consistently. I've tried this on kernels
>> 2.6.32-431.29.2.el6.x86_64, 3.10.68-11.el6.centos.alt.x86_64 (CentOS
>> 6), and 4.3 (Debian testing).
>>
>> I really doubt that there is something with the device mapper here,
>> but I'd like to understand this weird interaction between the device
>> mapper (or maybe the block I/O layer?) and the RAID controller. Any
>> ideas how to investigate this?
>>
>>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



-- 
Thanos Makatos
