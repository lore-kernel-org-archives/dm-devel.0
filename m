From: Rik van Riel <riel@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Mon, 07 Sep 2009 09:53:41 -0400
Message-ID: <4AA51065.6050000@redhat.com>
References: <20090901165011.GB3753@redhat.com>	<20090904.130228.104054439.ryov@valinux.co.jp>	<20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090907.200222.193693062.ryov@valinux.co.jp>
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
Cc: guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Ryo Tsuruta wrote:

> However, if you want to get fairness in a case like this, a new
> bandwidth control policy which controls accurately according to
> assigned weights can be added to dm-ioband.

Are you saying that dm-ioband is purposely unfair,
until a certain load level is reached?

> We regarded reducing throughput loss rather than reducing duration
> as the design of dm-ioband. Of course, it is possible to make a new
> policy which reduces duration.

... while also reducing overall system throughput
by design?

Why are you even bothering to submit this to the
linux-kernel mailing list, when there is a codebase
available that has no throughput or fairness regressions?
(Vivek's io scheduler based io controler)

-- 
All rights reversed.
