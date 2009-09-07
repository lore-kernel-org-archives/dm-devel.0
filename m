From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Mon, 07 Sep 2009 20:02:22 +0900 (JST)
Message-ID: <20090907.200222.193693062.ryov@valinux.co.jp>
References: <20090901165011.GB3753@redhat.com>
	<20090904.130228.104054439.ryov@valinux.co.jp>
	<20090904231129.GA3689@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090904231129.GA3689@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: vgoyal@redhat.com
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > Thank you for testing dm-ioband. dm-ioband is designed to start
> > throttling bandwidth when multiple IO requests are issued to devices
> > simultaneously, IOW, to start throttling when IO load exceeds a
> > certain level.
> > 
> 
> What is that certain level? Secondly what's the advantage of this?
> 
> I can see disadvantages though. So unless a group is really busy "up to
> that certain level" it will not get fairness? I breaks the isolation
> between groups.

In your test case, at least more than one dd thread have to run
simultaneously in the higher weight group. The reason is that
if there is an IO group which does not issue a certain number of IO
requests, dm-ioband assumes the IO group is inactive and assign its
spare bandwidth to active IO groups. Then whole bandwidth of the
device can be efficiently used. Please run two dd threads in the
higher group, it will work as you expect.

However, if you want to get fairness in a case like this, a new
bandwidth control policy which controls accurately according to
assigned weights can be added to dm-ioband.

> I also ran your test of doing heavy IO in two groups. This time I am
> running 4 dd threads in both the ioband devices. Following is the snapshot
> of "dmsetup table" output.
>
> Fri Sep  4 17:45:27 EDT 2009
> ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
> ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0
> 
> Fri Sep  4 17:45:29 EDT 2009
> ioband2: 0 40355280 ioband 1 -1 41 0 4184 0 0 0
> ioband1: 0 37768752 ioband 1 -1 173 0 20096 0 0 0
> 
> Fri Sep  4 17:45:37 EDT 2009
> ioband2: 0 40355280 ioband 1 -1 1605 23 197976 0 0 0
> ioband1: 0 37768752 ioband 1 -1 4640 1 583168 0 0 0
> 
> Fri Sep  4 17:45:45 EDT 2009
> ioband2: 0 40355280 ioband 1 -1 3650 47 453488 0 0 0
> ioband1: 0 37768752 ioband 1 -1 8572 1 1079144 0 0 0
> 
> Fri Sep  4 17:45:51 EDT 2009
> ioband2: 0 40355280 ioband 1 -1 5111 68 635696 0 0 0
> ioband1: 0 37768752 ioband 1 -1 11587 1 1459544 0 0 0
> 
> Fri Sep  4 17:45:53 EDT 2009
> ioband2: 0 40355280 ioband 1 -1 5698 73 709272 0 0 0
> ioband1: 0 37768752 ioband 1 -1 12503 1 1575112 0 0 0
> 
> Fri Sep  4 17:45:57 EDT 2009
> ioband2: 0 40355280 ioband 1 -1 6790 87 845808 0 0 0
> ioband1: 0 37768752 ioband 1 -1 14395 2 1813680 0 0 0
> 
> Note, it took me more than 20 seconds (since I started the threds) to
> reach close to desired fairness level. That's too long a duration.

We regarded reducing throughput loss rather than reducing duration
as the design of dm-ioband. Of course, it is possible to make a new
policy which reduces duration.

Thanks,
Ryo Tsuruta

> Again random readers or small file readers are compeltely out of picture for
> any kind of fairness or are not protected at all with dm-ioband
> controller.
> 
> I think there are serious issues with the notion of fairness and what kind of
> isolation dm-ioband provide between groups and it should be looked into.
> 
> Thanks
> Vivek
