From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: device mapper increased latency on RAID array
Date: Fri, 15 Jan 2016 16:52:55 -0500
Message-ID: <20160115215255.GA17319@redhat.com>
References: <CAM2wQBvNvm+0i1fkstDvez7yskd7RT_g+cCMfUavw20ksDzYXg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAM2wQBvNvm+0i1fkstDvez7yskd7RT_g+cCMfUavw20ksDzYXg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@onapp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 14 2016 at 11:21am -0500,
Thanos Makatos <thanos.makatos@onapp.com> wrote:

> I noticed that when a linear device mapper target is used on top of a
> RAID array (made of SSDs), latency is 3 times higher than accessing
> the RAID array itself. Strangely, when I do the same test to an SSD on
> the controller that is passed through (not configured in an array),
> latency is unaffected.
> 
> /dev/sda is the SSD passed through from the RAID controller.
> /dev/sdc is the block device in the RAID array.
> 
> [ ~]# dmsetup create sda --table "0 $((2**30/512)) linear /dev/sda 0
> [ ~]# dmsetup create sdc --table "0 $((2**30/512)) linear /dev/sdc 0
> [ ~]# echo noop > /sys/block/sda/queue/scheduler
> [ ~]# echo noop > /sys/block/sdc/queue/scheduler
> 
> [ ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/sda
> 
> --- /dev/sda (block device 186.3 GiB) ioping statistics ---
> 10 k requests completed in 377.9 ms, 39.1 MiB read, 26.5 k iops, 103.4 MiB/s
> min/avg/max/mdev = 31 us / 37 us / 140 us / 20 us
> 
> [ ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/mapper/sda
> 
> --- /dev/mapper/sda (block device 1 GiB) ioping statistics ---
> 10 k requests completed in 387.5 ms, 39.1 MiB read, 25.8 k iops, 100.8 MiB/s
> min/avg/max/mdev = 36 us / 38 us / 134 us / 5 us
> 
> [root@192.168.1.130 ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/mapper/sdc
> 
> --- /dev/mapper/sdc (block device 1 GiB) ioping statistics ---
> 10 k requests completed in 1.33 s, 39.1 MiB read, 7.50 k iops, 29.3 MiB/s
> min/avg/max/mdev = 112 us / 133 us / 226 us / 11 us
> [ ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/sdc
> 
> --- /dev/sdc (block device 1.45 TiB) ioping statistics ---
> 10 k requests completed in 477.8 ms, 39.1 MiB read, 20.9 k iops, 81.7 MiB/s
> min/avg/max/mdev = 36 us / 47 us / 158 us / 18 us
> 
> [ ~]# ./ioping -c 10000 -s 4k -i 0 -q -D /dev/mapper/sdc
> 
> --- /dev/mapper/sdc (block device 1 GiB) ioping statistics ---
> 10 k requests completed in 1.33 s, 39.1 MiB read, 7.50 k iops, 29.3 MiB/s
> min/avg/max/mdev = 111 us / 133 us / 181 us / 11 us
> 
> These results are reproduced consistently. I've tried this on kernels
> 2.6.32-431.29.2.el6.x86_64, 3.10.68-11.el6.centos.alt.x86_64 (CentOS
> 6), and 4.3 (Debian testing).
> 
> I really doubt that there is something with the device mapper here,
> but I'd like to understand this weird interaction between the device
> mapper (or maybe the block I/O layer?) and the RAID controller. Any
> ideas how to investigate this?

I just ran your ioping test against a relatively fast PCIe SSD on a
system with a 4.4.0-rc3 kernel:

# cat /sys/block/fioa/queue/scheduler
[noop] deadline cfq

# ioping -c 10000 -s 4k -i 0 -q -D /dev/fioa

--- /dev/fioa (block device 731.1 GiB) ioping statistics ---
10 k requests completed in 1.71 s, 5.98 k iops, 23.3 MiB/s
min/avg/max/mdev = 26 us / 167 us / 310 us / 53 us

# dmsetup create fioa --table "0 $((2**30/512)) linear /dev/fioa 0"

# ioping -c 10000 -s 4k -i 0 -q -D /dev/mapper/fioa

--- /dev/mapper/fioa (block device 1 GiB) ioping statistics ---
10 k requests completed in 1.81 s, 5.65 k iops, 22.1 MiB/s
min/avg/max/mdev = 74 us / 176 us / 321 us / 46 us

So I cannot replicate your high performance (or drop in performance).

Struggling to understand how you're seeing the performance you are from
your JBOD and RAID devices.  But I've never used ioping before either.

I think this issue is probably very HW dependent; and could be rooted in
some aspect of your controller's cache.  But your iops of > 20.9K seem
_really_ high for this test.

Might be worth trying a more proven load-generator tool to try to
evaluate your hardware (e.g. fio)...
