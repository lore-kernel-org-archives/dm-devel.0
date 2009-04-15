From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Re: dm-ioband: Test results.
Date: Wed, 15 Apr 2009 13:04:15 -0400
Message-ID: <20090415170415.GE15067@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
	<20090413144626.GF18007@redhat.com>
	<20090414.183022.71120459.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090414.183022.71120459.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com, vivek.goyal2008@gmail.com, agk@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Apr 14, 2009 at 06:30:22PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> > I quickly looked at the xls sheet. Most of the test cases seem to be
> > direct IO. Have you done testing with buffered writes/async writes and
> > been able to provide service differentiation between cgroups?
> > 
> > For example, two "dd" threads running in two cgroups doing writes.
> 
> Thanks for taking a look at the sheet. I did a buffered write test
> with "fio." Only two "dd" threads can't generate enough I/O load to
> make dm-ioband start bandwidth control. The following is a script that
> I actually used for the test.
> 
>   #!/bin/bash
>   sync
>   echo 1 > /proc/sys/vm/drop_caches
>   arg="--size=64m --rw=write --numjobs=50 --group_reporting"
>   echo $$ > /cgroup/1/tasks
>   fio $arg --name=ioband1 --directory=/mnt1 --output=ioband1.log &
>   echo $$ > /cgroup/2/tasks
>   fio $arg --name=ioband2 --directory=/mnt2 --output=ioband2.log &
>   echo $$ > /cgroup/tasks
>   wait
> 

Ryo,

Can you also send bio-cgroup patches which apply to 2.6.30-rc1 so that
I can do testing for async writes.

Why have you split the regular patch and bio-cgroup patch? Do you want
to address only reads and sync writes?

In the above test case, do these "fio" jobs finish at different times?
In my testing I see that two dd generate a lot of traffic at IO scheudler
level but traffic seems to be bursty. So when higher weight process has
done some IO, it seems to disappear for .2 to 1 seconds and in that
time other writer gets to do lot of IO and eradicates any service
difference provided so far. 

I am not sure where this high priority writer is blocked and that needs
to be looked into. But I am sure that you will also face the same issue.

Thanks
Vivek

> I created two dm-devices to easily monitor the throughput of each
> cgroup by iostat, and gave weights of 200 for cgroup1 and 100 for
> cgroup2 that means cgroup1 can use twice bandwidth of cgroup2. The
> following is a part of the output of iostat. dm-0 and dm-1 corresponds
> to ioband1 and ioband2. You can see the bandwidth is according to the
> weights.
> 
>   avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>              0.99    0.00    6.44   92.57    0.00    0.00
>   
>   Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
>   dm-0           3549.00         0.00     28392.00          0      28392
>   dm-1           1797.00         0.00     14376.00          0      14376
>   
>   avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>              1.01    0.00    4.02   94.97    0.00    0.00
>   
>   Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
>   dm-0           3919.00         0.00     31352.00          0      31352
>   dm-1           1925.00         0.00     15400.00          0      15400
>   
>   avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>              0.00    0.00    5.97   94.03    0.00    0.00
>   
>   Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
>   dm-0           3534.00         0.00     28272.00          0      28272
>   dm-1           1773.00         0.00     14184.00          0      14184
>   
>   avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>              0.50    0.00    6.00   93.50    0.00    0.00
>   
>   Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
>   dm-0           4053.00         0.00     32424.00          0      32424
>   dm-1           2039.00         8.00     16304.00          8      16304
> 

> Thanks,
> Ryo Tsuruta
