From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] dm: Avoid sleeping while holding the dm_bufio lock
Date: Mon, 12 Dec 2016 16:08:12 -0800
Message-ID: <CAD=FV=U+1VA23s1WMn4srH5U3Cjuz+0OLhq1qD5qw0oTE34xFQ@mail.gmail.com>
References: <1479410660-31408-1-git-send-email-dianders@chromium.org>
 <alpine.LRH.2.02.1611231543020.31481@file01.intranet.prod.int.rdu2.redhat.com>
 <CAD=FV=V85=ZTXURVZ3Xo1gS80rqA8gOhr+Xm47axrwVUpjQFuw@mail.gmail.com> <alpine.LRH.2.02.1612081758250.25149@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1612081758250.25149@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Sonny Rao <sonnyrao@chromium.org>, Guenter Roeck <linux@roeck-us.net>
List-Id: dm-devel.ids

Hi,

On Thu, Dec 8, 2016 at 3:20 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Wed, 7 Dec 2016, Doug Anderson wrote:
>
>> Hi,
>>
>> On Wed, Nov 23, 2016 at 12:57 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> > Hi
>> >
>> > The GFP_NOIO allocation frees clean cached pages. The GFP_NOWAIT
>> > allocation doesn't. Your patch would incorrectly reuse buffers in a
>> > situation when the memory is filled with clean cached pages.
>> >
>> > Here I'm proposing an alternate patch that first tries GFP_NOWAIT
>> > allocation, then drops the lock and tries GFP_NOIO allocation.
>> >
>> > Note that the root cause why you are seeing this stacktrace is, that your
>> > block device is congested - i.e. there are too many requests in the
>> > device's queue - and note that fixing this wait won't fix the root cause
>> > (congested device).
>> >
>> > The congestion limits are set in blk_queue_congestion_threshold to 7/8 to
>> > 13/16 size of the nr_requests value.
>> >
>> > If you don't want your device to report the congested status, you can
>> > increase /sys/block/<device>/queue/nr_requests - you should test if your
>> > chromebook is faster of slower with this setting increased. But note that
>> > this setting won't increase the IO-per-second of the device.
>>
>> Cool, thanks for the insight!
>>
>> Can you clarify which block device is relevant here?  Is this the DM
>> block device, the underlying block device, or the swap block device?
>> I'm not at all an expert on DM, but I think we have:
>>
>> 1. /dev/mmcblk0 - the underlying storage device.
>> 2. /dev/dm-0 - The verity device that's run atop /dev/mmcblk0p3
>> 3. /dev/zram0 - Our swap device
>
> The /dev/mmcblk0 device is congested. You can see the number of requests
> in /sys/block/mmcblk0/inflight

Hrm.  Doing some tests doesn't show that to be true.

I ran this command while doing my test (the "balloon" test described
in my patch, not the running the computer as a real user):

  while true;
    do grep -v '0 *0' /sys/block/*/inflight;
    sleep .1;
  done

The largest numbers I ever saw was:

  /sys/block/mmcblk0/inflight:       6        0

...and in one case when I saw a "long bufio" mesage I was seeing:

/sys/block/zram0/inflight:       1        0
/sys/block/zram0/inflight:       0        1
/sys/block/zram0/inflight:       0        1
/sys/block/zram0/inflight:       1        1
/sys/block/zram0/inflight:       0        1


>> As stated in the original email, I'm running on a downstream kernel
>> (kernel-4.4) with bunches of local patches, so it's plausible that
>> things have changed in the meantime, but:
>>
>> * At boot time the "nr_requests" for all block devices was 128
>> * I was unable to set the "nr_requests" for dm-0 and zram0 (it just
>> gives an error in sysfs).
>> * When I set "nr_requests" to 4096 for /dev/mmcblk0 it didn't seem to
>> affect the problem.
>
> The eMMC has some IOPS and the IOPS can't be improved. Use faster block
> device - but it will cost more money.

It's so strange since when I see this failure I'm not even doing lots
of eMMC traffic.  As per above my swap goes to zram and there's no
disk backing, so there should be very minimal disk usage.

If I run iostat now after having been running my test for a while (and
having seen a bunch of "long bufio" messages, you can see that there
hasn't exactly been lots of activity.

localhost debug # iostat
Linux 4.4.21 (localhost)        12/09/16        _aarch64_       (6 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6.11   33.87   36.63    1.78    0.00   21.61

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
loop0             2.74        39.01        68.95      33529      59264
loop1             0.07         1.23         0.00       1055          0
loop2             0.04         0.13         0.00        112          0
loop3             0.00         0.00         0.00          4          0
loop4             0.00         0.01         0.00          8          0
loop5             0.00         0.01         0.00          8          0
mmcblk1           0.56        44.45         0.00      38202          0
mmcblk0          14.37       636.29        38.74     546888      33300
mmcblk0rpmb       0.01         0.03         0.00         28          0
mmcblk0boot1      0.03         0.15         0.00        128          0
mmcblk0boot0      0.03         0.15         0.00        128          0
dm-0             11.50       419.25         0.00     360344          0
dm-1              2.15        36.53        68.95      31401      59264
zram0         42103.26     84111.64     84301.42   72293956   72457068

---

OK, so I just put a printk in wait_iff_congested() and it didn't show
me waiting for the timeout (!).  I know that I saw
wait_iff_congested() in the originally reproduction of this problem,
but it appears that in my little "balloon" reproduction it's not
actually involved...


...I dug further and it appears that __alloc_pages_direct_reclaim() is
actually what's slow.  Specifically it looks as if shrink_zone() can
actually take quite a while.  As I've said, I'm not an expert on the
memory manager but I'm not convinced that it's wrong for the direct
reclaim path to be pretty slow at times, especially when I'm putting
an abnormally high amount of stress on it.

I'm going to take this as further evidence that the patch being
discussed in this thread is a good one (AKA don't hold the dm bufio
lock while allocating memory).  :)  If it's unexpected that
shrink_zone() might take several seconds when under extreme memory
pressure then I can do some additional digging.  Do note that I am
running with "zram" and remember that I'm on an ancient 4.4-based
kernel, so perhaps one of those two factors causes problems.


> If you want to handle such a situation where you run 4 tasks each eating
> 900MB, just use more memory, don't expect that this will work smoothly on
> 4GB machine.
>
> If you want to protect the chromebook from runaway memory allocations, you
> can detect this situation in some watchdog process and either kill the
> process that consumes most memory with the kill syscall or trigger the
> kernel OOM killer by writing 'f' to /proc/sysrq-trigger.
>
> The question is what you really want - handle this situation smoothly
> (then, you must add more memory) or protect chromeOS from applications
> allocating too much memory?

These are definitely important things to think about.  In the end user
bug report, though, we were seeing this super slow / janky behavior
_without_ a runaway process--they were just using memory (and swap)
normally.  I've simulated it with the "balloon" process, but users
were seeing it without anything so crazy.


-Doug
