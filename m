From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] IO-Controller: clear ioq wait flag if a request goes
 into that ioq
Date: Fri, 21 Aug 2009 08:57:27 +0800
Message-ID: <4A8DF0F7.6070100@cn.fujitsu.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-12-git-send-email-vgoyal@redhat.com> <4A8CAAE2.1030804@cn.fujitsu.com> <20090820134221.GC10615@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753141AbZHUA6Q@vger.kernel.org>
In-Reply-To: <20090820134221.GC10615@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
> On Thu, Aug 20, 2009 at 09:46:10AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>> ...
>>>  		/*
>>>  		 * Remember that we saw a request from this process, but
>>> @@ -1940,7 +2013,7 @@ void elv_ioq_request_add(struct request_queue *q, struct request *rq)
>>>  		 * has other work pending, don't risk delaying until the
>>>  		 * idle timer unplug to continue working.
>>>  		 */
>>> -		if (elv_ioq_wait_request(ioq)) {
>>> +		if (group_wait || elv_ioq_wait_request(ioq)) {
>> Hi Vivek,
>>
>> I guess we need to clear ioq_wait_request flags if there are requests to 
>> go in this ioq. Otherwise, once waitting request on ioq, it will go into
>> this path every time when a request is enqueued.
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> 
> Hi Gui,
> 
> It does sound like that we need to clear ioq wait_request flag here. In
> fact upstream CFQ code is also not clearing this flag. Looking at the
> code, can't think why it should not be cleared here.
> 
> Can you please also generate a patch for CFQ and post to lkml.
> 

Sure, will do.

-- 
Regards
Gui Jianfeng
