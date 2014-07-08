From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v3.15 dm-mpath regression: cable pull test causes
	I/O hang
Date: Tue, 8 Jul 2014 12:33:23 -0400
Message-ID: <20140708163323.GB23439@redhat.com>
References: <53AD6B62.2020407@acm.org> <20140627133345.GA6150@redhat.com>
	<20140702220223.GA23894@redhat.com> <53B56120.8040802@acm.org>
	<20140703140516.GB28104@redhat.com> <53B569E1.1010405@acm.org>
	<11AF7C027C4C02408624617A4986078401311EA8@BPXM12GP.gisp.nec.co.jp>
	<53BAA35B.30204@acm.org>
	<11AF7C027C4C02408624617A498607840132038A@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <11AF7C027C4C02408624617A498607840132038A@BPXM12GP.gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On Mon, Jul 07 2014 at  8:55pm -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> On 07/07/14 22:40, Bart Van Assche wrote:
> > Thanks for looking into this issue. I have attached the requested
> > information to this e-mail for a test run with kernel 3.16-rc4 at the
> > initiator side.
> 
> Thank you, Bart. The information is helpful.
> 
> >From "dmsetup table" output, hardware handler is not used
> in your setup. So pg_init is not involved.
> 
> > # cat /proc/diskstats
> ..
> >  253       1 dm-1 127 0 1016 1070 0 0 0 0 1 278360 278820
> 
> In-flight IO remains.
> 
> > # dmsetup info -c
> > Name              Maj Min Stat Open Targ Event  UUID                            
> ...
> > 26466363537333266 253   1 L--w    1    1      0 mpath-26466363537333266 
> 
> Typical reason of remainig IO is device staying as suspended.
> But the device state is ok here.
> 
> > # dmsetup status
> ...
> > 26466363537333266: 0 256000 multipath 2 1 0 0 1 1 E 0 2 2 8:48 A 0 0 1 8:160 A 0 0 1
> 
> Single path group with both paths being active on dm-1.
> But the path group is not active.
> 
> I suspect what's happening here is nobody clears m->queue_io:
> multipath_busy() returns busy when queue_io=1 while clearing queue_io
> needs __choose_pgpath(), which won't be called if multipath_busy() is true.
> 
> I think if you run 'sg_inq /dev/dm-1' for example in this case,
> the device will start working again.
> Since ioctl is not affected by multipath_busy(), somehow the problem
> was hidden in many cases by udev activities, for example.
> 
> Attached patch should fix the problem.
> Could you give it a try?
> 
> -
> Jun'ichi Nomura, NEC Corporation
> 
> 
> pg_ready() checks the current state of the multipath and may return
> false even if a new IO is needed to change the state.
> 
> OTOH, if multipath_busy() returns busy, a new IO will not be sent
> to multipath target and the state change won't happen. That results
> in lock up.
> 
> The intent of multipath_busy() is to avoid unnecessary cycles of
> dequeue + request_fn + requeue if it is known that multipath device
> will requeue.
> 
> Such situation would be:
>   - path group is being activated
>   - there is no path and the multipath is setup to requeue if no path
> 
> This patch should fix the problem introduced as a part of this commit:
>   commit e809917735ebf1b9a56c24e877ce0d320baee2ec
>   dm mpath: push back requests instead of queueing


Thanks Jun'ichi!  I knew multipath_busy() wasn't quite right ;)

I've merged your fix with a revised header, if you see anything wrong
with the header please feel free to let me know!  See:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=75c76c45b76e53b7c2f025d30e7e308bfe331004

This will likely go to Linus for 3.16-rc5 by this Friday.

BTW, I also staged a related cleanup for 3.17, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=2122e57c913cd842e5061137a7093bd06e728677

Thanks again,
Mike
