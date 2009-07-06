From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 09/25] io-controller: Common hierarchical
 fair queuing code in elevaotor layer
Date: Mon, 06 Jul 2009 10:46:19 +0800
Message-ID: <4A51657B.7000008@cn.fujitsu.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<1246564917-19603-10-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246564917-19603-10-git-send-email-vgoyal@redhat.com>
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
...
> +static struct io_group *
> +io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
> +{
> +	struct io_cgroup *iocg;
> +	struct io_group *iog, *leaf = NULL, *prev = NULL;
> +	gfp_t flags = GFP_ATOMIC |  __GFP_ZERO;
> +
> +	for (; cgroup != NULL; cgroup = cgroup->parent) {
> +		iocg = cgroup_to_io_cgroup(cgroup);
> +
> +		iog = io_cgroup_lookup_group(iocg, key);
> +		if (iog != NULL) {
> +			/*
> +			 * All the cgroups in the path from there to the
> +			 * root must have a io_group for efqd, so we don't
> +			 * need any more allocations.
> +			 */
> +			break;
> +		}
> +
> +		iog = kzalloc_node(sizeof(*iog), flags, q->node);
> +		if (!iog)
> +			goto cleanup;
> +
> +		iog->iocg_id = css_id(&iocg->css);

  Hi Vivek,

  IMHO, The io_cgroup id is nothing more than keeping track the corresponding iocg.
  So why not just store iocg pointer in io_group and just get rid of this complexity.
  I'd like to post a patch to do this change, what's your opinion?

-- 
Regards
Gui Jianfeng
