From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 08 Sep 2009 12:01:19 +0900 (JST)
Message-ID: <20090908.120119.71095369.ryov@valinux.co.jp>
References: <20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
	<4AA51065.6050000@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AA51065.6050000@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: riel@redhat.com
Cc: guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Rik,

Rik van Riel <riel@redhat.com> wrote:
> Ryo Tsuruta wrote:
> 
> > However, if you want to get fairness in a case like this, a new
> > bandwidth control policy which controls accurately according to
> > assigned weights can be added to dm-ioband.
> 
> Are you saying that dm-ioband is purposely unfair,
> until a certain load level is reached?

Not unfair, dm-ioband(weight policy) is intentionally designed to
use bandwidth efficiently, weight policy tries to give spare bandwidth
of inactive groups to active groups.

> > We regarded reducing throughput loss rather than reducing duration
> > as the design of dm-ioband. Of course, it is possible to make a new
> > policy which reduces duration.
> 
> ... while also reducing overall system throughput
> by design?

I think it reduces system throughput compared to the current
implementation, because it causes more overhead to do fine grained
control. 

> Why are you even bothering to submit this to the
> linux-kernel mailing list, when there is a codebase
> available that has no throughput or fairness regressions?
> (Vivek's io scheduler based io controler)

I think there are some advantages to dm-ioband. That's why I post
dm-ioband to the mailing list.

- dm-ioband supports not only proportional weight policy but also rate
  limiting policy. Besides, new policies can be added to dm-ioband if
  a user wants to control bandwidth by his or her own policy.
- The dm-ioband driver can be replaced without stopping the system by
  using device-mapper's facility. It's easy to maintain.
- dm-ioband can use without cgroup. (I remember Vivek said it's not an
  advantage.)

Thanks,
Ryo Tsuruta
