From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
 handling
Date: Thu, 14 May 2009 09:02:05 +0800
Message-ID: <4A0B6D8D.6060202@cn.fujitsu.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com> <20090513152909.GD7696@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762369AbZENBDR@vger.kernel.org>
In-Reply-To: <20090513152909.GD7696@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> On Wed, May 13, 2009 at 10:00:21AM +0800, Gui Jianfeng wrote:
> 
> [..]
>> @@ -2137,7 +2366,7 @@ void elv_fq_unset_request_ioq(struct request_queue *q, struct request *rq)
>>  void bfq_init_entity(struct io_entity *entity, struct io_group *iog)
>>  {
>>  	entity->ioprio = entity->new_ioprio;
>> -	entity->weight = entity->new_weight;
>> +	entity->weight = entity->new_weigh;
>>  	entity->ioprio_class = entity->new_ioprio_class;
>>  	entity->sched_data = &iog->sched_data;
>>  }
>> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
>> index db3a347..0407633 100644
>> --- a/block/elevator-fq.h
>> +++ b/block/elevator-fq.h
>> @@ -253,6 +253,14 @@ struct io_group {
>>  #endif
>>  };
>>  
>> +struct policy_node {
> 
> Would "io_policy_node" be better?

  Sure

> 
>> +	struct list_head node;
>> +	char dev_name[32];
>> +	void *key;
>> +	unsigned long weight;
>> +	unsigned long ioprio_class;
>> +};
>> +
>>  /**
>>   * struct bfqio_cgroup - bfq cgroup data structure.
>>   * @css: subsystem state for bfq in the containing cgroup.
>> @@ -269,6 +277,9 @@ struct io_cgroup {
>>  
>>  	unsigned long weight, ioprio_class;
>>  
>> +	/* list of policy_node */
>> +	struct list_head list;
>> +
> 
> How about "struct list_head policy_list" or "struct list_head io_policy"?

  OK

-- 
Regards
Gui Jianfeng
