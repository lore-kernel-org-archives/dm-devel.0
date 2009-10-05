From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: IO scheduler based IO controller V10
Date: Mon, 05 Oct 2009 19:38:08 +0900 (JST)
Message-ID: <20091005.193808.104033719.ryov@valinux.co.jp>
References: <20091001133109.GA4058@redhat.com>
	<20091002025731.GA2738@redhat.com> <4AC6623F.70600@ds.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AC6623F.70600@ds.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: m-ikeda@ds.jp.nec.com
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, yoshikawa.takuya@oss.ntt.co.jp, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, vgoyal@redhat.com, righi.andrea@gmail.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi,

Munehiro Ikeda <m-ikeda@ds.jp.nec.com> wrote:
> Vivek Goyal wrote, on 10/01/2009 10:57 PM:
> > Before finishing this mail, will throw a whacky idea in the ring. I was
> > going through the request based dm-multipath paper. Will it make sense
> > to implement request based dm-ioband? So basically we implement all the
> > group scheduling in CFQ and let dm-ioband implement a request function
> > to take the request and break it back into bios. This way we can keep
> > all the group control at one place and also meet most of the requirements.
> >
> > So request based dm-ioband will have a request in hand once that request
> > has passed group control and prio control. Because dm-ioband is a device
> > mapper target, one can put it on higher level devices (practically taking
> > CFQ at higher level device), and provide fairness there. One can also
> > put it on those SSDs which don't use IO scheduler (this is kind of forcing
> > them to use the IO scheduler.)
> >
> > I am sure that will be many issues but one big issue I could think of that
> > CFQ thinks that there is one device beneath it and dipsatches requests
> > from one queue (in case of idling) and that would kill parallelism at
> > higher layer and throughput will suffer on many of the dm/md configurations.
> >
> > Thanks
> > Vivek
> 
> As long as using CFQ, your idea is reasonable for me.  But how about for
> other IO schedulers?  In my understanding, one of the keys to guarantee
> group isolation in your patch is to have per-group IO scheduler internal
> queue even with as, deadline, and noop scheduler.  I think this is
> great idea, and to implement generic code for all IO schedulers was
> concluded when we had so many IO scheduler specific proposals.
> If we will still need per-group IO scheduler internal queues with
> request-based dm-ioband, we have to modify elevator layer.  It seems
> out of scope of dm.
> I might miss something...

IIUC, the request based device-mapper could not break back a request
into bio, so it could not work with block devices which don't use the
IO scheduler.

How about adding a callback function to the higher level controller?
CFQ calls it when the active queue runs out of time, then the higer
level controller use it as a trigger or a hint to move IO group, so
I think a time-based controller could be implemented at higher level.

My requirements for IO controller are:
- Implement s a higher level controller, which is located at block
  layer and bio is grabbed in generic_make_request().
- Can work with any type of IO scheduler.
- Can work with any type of block devices.
- Support multiple policies, proportional wegiht, max rate, time
  based, ans so on.

The IO controller mini-summit will be held in next week, and I'm
looking forard to meet you all and discuss about IO controller.
https://sourceforge.net/apps/trac/ioband/wiki/iosummit

Thanks,
Ryo Tsuruta
