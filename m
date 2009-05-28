From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 15/20] io-controller: map async requests to
 appropriate cgroup
Date: Thu, 28 May 2009 18:27:40 +0900 (JST)
Message-ID: <20090528.182740.193697101.ryov@valinux.co.jp>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-16-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1243377729-2176-16-git-send-email-vgoyal@redhat.com>
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
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

Hi Vivek,

> +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
> +	if (elv_bio_sync(bio)) {
> +		/* sync io. Determine cgroup from submitting task context. */
> +		cgroup = task_cgroup(current, io_subsys_id);
> +		return cgroup;
> +	}
> +
> +	/* Async io. Determine cgroup from with cgroup id stored in page */
> +	bio_cgroup_id = get_blkio_cgroup_id(bio);
> +
> +	if (!bio_cgroup_id)
> +		return NULL;
> +
> +	cgroup = blkio_cgroup_lookup(bio_cgroup_id);
> +#else
> +	cgroup = task_cgroup(current, io_subsys_id);
> +#endif
> +	return cgroup;
> +}

There is a case where a kernel thread (such as device-mapper drivers)
submits a sync IO instead of a task which originates the IO. I think
you should always use get_blkio_cgroup_id() to determine cgroup.

Thanks,
Ryo Tsuruta
