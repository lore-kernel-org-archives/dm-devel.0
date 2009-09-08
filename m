From: Rik van Riel <riel@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 08 Sep 2009 15:24:08 -0400
Message-ID: <4AA6AF58.3050501@redhat.com>
References: <20090904231129.GA3689@redhat.com>	<20090907.200222.193693062.ryov@valinux.co.jp>	<4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090908.120119.71095369.ryov@valinux.co.jp>
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
> Rik van Riel <riel@redhat.com> wrote:

>> Are you saying that dm-ioband is purposely unfair,
>> until a certain load level is reached?
> 
> Not unfair, dm-ioband(weight policy) is intentionally designed to
> use bandwidth efficiently, weight policy tries to give spare bandwidth
> of inactive groups to active groups.

This sounds good, except that the lack of anticipation
means that a group with just one task doing reads will
be considered "inactive" in-between reads.

This means writes can always get in-between two reads,
sometimes multiple writes at a time, really disadvantaging
a group that is doing just disk reads.

This is a problem, because reads are generally more time
sensitive than writes.

>>> We regarded reducing throughput loss rather than reducing duration
>>> as the design of dm-ioband. Of course, it is possible to make a new
>>> policy which reduces duration.
>> ... while also reducing overall system throughput
>> by design?
> 
> I think it reduces system throughput compared to the current
> implementation, because it causes more overhead to do fine grained
> control. 

Except that the io scheduler based io controller seems
to be able to enforce fairness while not reducing
throughput.

Dm-ioband would have to address these issues to be a
serious contender, IMHO.

-- 
All rights reversed.
