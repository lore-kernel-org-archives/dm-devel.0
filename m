From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: BUG: sleeping function called during table_load()
Date: Tue, 09 Apr 2013 14:37:45 +0900
Message-ID: <5163A929.4050300@ce.jp.nec.com>
References: <51306300.40309@suse.de> <51306634.2010702@ce.jp.nec.com>
	<20130301090625.GS4727@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130301090625.GS4727@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Jens,

On 03/01/13 18:06, Jens Axboe wrote:
> On Fri, Mar 01 2013, Jun'ichi Nomura wrote:
>> On 03/01/13 17:12, Hannes Reinecke wrote:
>>> during booting 3.8.0 I hit this:
>>>
>>> BUG: sleeping function called from invalid context at kernel/rcutree.c:2208
>>> in_atomic(): 1, irqs_disabled(): 0, pid: 1976, name: multipath
>>> Pid: 1976, comm: multipath Not tainted 3.8.0-default+ #18
>>
>> It seems the same issue with this:
>>   [PATCH repost] blkcg: fix "scheduling while atomic" in blk_queue_bypass_start
>>   https://patchwork.kernel.org/patch/2183891/
>>
>> I've been waiting for Jens to pick it up.
> 
> I just offloaded the bigger chunk for 3.9, there will be a 2nd round
> after -rc1 where this is going to be included (amongst other things).

It seems the above patch hasn't yet included in 3.9-rc6.
Could you take it?
(Maybe for 3.10, if it's too late for 3.9)

-- 
Jun'ichi Nomura, NEC Corporation
