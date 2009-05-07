From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 05/18] io-controller: Common hierarchical fair queuing
 code in elevaotor layer
Date: Thu, 07 May 2009 16:05:08 +0800
Message-ID: <4A029634.303@cn.fujitsu.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-6-git-send-email-vgoyal@redhat.com> <4A0290ED.7080506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756273AbZEGIEm@vger.kernel.org>
In-Reply-To: <4A0290ED.7080506@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, nauman@google.com, dpshah@google.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Gui Jianfeng wrote:
> Vivek Goyal wrote:
>> This patch enables hierarchical fair queuing in common layer. It is
>> controlled by config option CONFIG_GROUP_IOSCHED.
> ...
>> +}
>> +
>> +void iocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>> +{
>> +	struct io_cgroup *iocg = cgroup_to_io_cgroup(cgroup);
>> +	struct hlist_node *n, *tmp;
>> +	struct io_group *iog;
>> +
>> +	/*
>> +	 * Since we are destroying the cgroup, there are no more tasks
>> +	 * referencing it, and all the RCU grace periods that may have
>> +	 * referenced it are ended (as the destruction of the parent
>> +	 * cgroup is RCU-safe); bgrp->group_data will not be accessed by
>> +	 * anything else and we don't need any synchronization.
>> +	 */
>> +	hlist_for_each_entry_safe(iog, n, tmp, &iocg->group_data, group_node)
>> +		io_destroy_group(iocg, iog);
>> +
>> +	BUG_ON(!hlist_empty(&iocg->group_data));
>> +
> 
>     Hi Vivek,
> 
>     IMHO, free_css_id() needs to be called here.
> 

Right.

Though alloc_css_id() is called by cgroup core in cgroup_create(),
free_css_id() should be called by subsystem itself.

This is a bit strange, but it's required by memory cgroup. Normally,
free_css_id() is called in destroy() handler, but memcg calls it
when a mem_cgroup's refcnt goes to 0. When a cgroup is destroyed,
the mem_cgroup won't be destroyed (refcnt > 0) if it has records on
swap-entry.

>> +	kfree(iocg);
>> +}
>> +
>> +void io_disconnect_groups(struct elevator_queue *e)
>> +{
>> +	struct hlist_node *pos, *n;
>> +	struct io_group *iog;
>> +	struct elv_fq_data *efqd = &e->efqd;
>> +
>> +	hlist_for_each_entry_safe(iog, pos, n, &efqd->group_list,
>> +					elv_data_node) {
>> +		hlist_del(&iog->elv_data_node);
>> +
> 
