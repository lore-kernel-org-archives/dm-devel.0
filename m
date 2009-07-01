From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] io-controller: Don't expire an idle ioq if
 it's the	only ioq in hierarchy
Date: Wed, 01 Jul 2009 09:40:33 +0800
Message-ID: <4A4ABE91.8020307@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-9-git-send-email-vgoyal@redhat.com>
	<4A49C381.3040302@cn.fujitsu.com>
	<20090701013239.GB13958@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090701013239.GB13958@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> On Tue, Jun 30, 2009 at 03:49:21PM +0800, Gui Jianfeng wrote:
>> Hi Vivek,
>>
>> We don't expect expiring an idle ioq if it's the only ioq 
>> in the hierarchy.
>>
> 
> Hi Gui,
> 
> This patch will avoid idle queue expiry for single ioq schedulers. But
> that's not an issue anyway as single ioq schedulers don't have the notion
> of idle queue. It is only CFQ which allows creation of idle ioq.

  Oh, yes, please ignore this mindless patch.

> 
> Thanks
> Vivek
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/elevator-fq.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
>> index 4270cfd..0b65e16 100644
>> --- a/block/elevator-fq.c
>> +++ b/block/elevator-fq.c
>> @@ -4058,12 +4058,6 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>>  			elv_clear_ioq_slice_new(ioq);
>>  		}
>>  
>> -		if (elv_ioq_class_idle(ioq)) {
>> -			if (elv_iosched_expire_ioq(q, 1, 0))
>> -				elv_ioq_slice_expired(q);
>> -			goto done;
>> -		}
>> -
>>  		/*
>>  		 * If there is only root group present, don't expire the queue
>>  		 * for single queue ioschedulers (noop, deadline, AS). It is
>> @@ -4077,6 +4071,12 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>>  			goto done;
>>  		}
>>  
>> +		if (elv_ioq_class_idle(ioq)) {
>> +			if (elv_iosched_expire_ioq(q, 1, 0))
>> +				elv_ioq_slice_expired(q);
>> +			goto done;
>> +		}
>> +
>>  		/* For async queue try to do wait busy */
>>  		if (efqd->fairness && !elv_ioq_sync(ioq) && !ioq->nr_queued
>>  		    && (elv_iog_nr_active(iog) <= 1)) {
>> -- 
>> 1.5.4.rc3
>>
> 
> 
> 

-- 
Regards
Gui Jianfeng
