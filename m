From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 07/18] io-controller: Export disk time used and nr	sectors
 dipatched through cgroups
Date: Thu, 14 May 2009 15:53:18 +0800
Message-ID: <4A0BCDEE.5020708@cn.fujitsu.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-8-git-send-email-vgoyal@redhat.com> <4A0A32CB.4020609@cn.fujitsu.com> <20090513145127.GB7696@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761093AbZENHyZ@vger.kernel.org>
In-Reply-To: <20090513145127.GB7696@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> On Wed, May 13, 2009 at 10:39:07AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>> ...
>>>  
>>> +/*
>>> + * traverse through all the io_groups associated with this cgroup and calculate
>>> + * the aggr disk time received by all the groups on respective disks.
>>> + */
>>> +static u64 calculate_aggr_disk_time(struct io_cgroup *iocg)
>>> +{
>>> +	struct io_group *iog;
>>> +	struct hlist_node *n;
>>> +	u64 disk_time = 0;
>>> +
>>> +	rcu_read_lock();
>>   This function is in slow-path, so no need to call rcu_read_lock(), just need to ensure
>>   that the caller already holds the iocg->lock.
>>
> 
> Or can we get rid of requirement of iocg_lock here and just read the io
> group data under rcu read lock? Actually I am wondering why do we require
> an iocg_lock here. We are not modifying the rcu protected list. We are
> just traversing through it and reading the data.

  Yes, i think removing the iocg->lock from caller(io_cgroup_disk_time_read()) 
  is a better choice.

> 
> Thanks
> Vivek
> 
>>> +	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
>>> +		/*
>>> +		 * There might be groups which are not functional and
>>> +		 * waiting to be reclaimed upon cgoup deletion.
>>> +		 */
>>> +		if (rcu_dereference(iog->key))
>>> +			disk_time += iog->entity.total_service;
>>> +	}
>>> +	rcu_read_unlock();
>>> +
>>> +	return disk_time;
>>> +}
>>> +
>> -- 
>> Regards
>> Gui Jianfeng
> 
> 
> 

-- 
Regards
Gui Jianfeng
