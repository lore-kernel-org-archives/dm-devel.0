From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH 05/18] io-controller: Common hierarchical fair queuing
	code in elevaotor layer
Date: Fri, 8 May 2009 23:09:37 +0200
Message-ID: <20090508210936.GA5763@linux>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-6-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761644AbZEHVJv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1241553525-28095-6-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Tue, May 05, 2009 at 03:58:32PM -0400, Vivek Goyal wrote:
> +#define STORE_FUNCTION(__VAR, __MIN, __MAX)				\
> +static int io_cgroup_##__VAR##_write(struct cgroup *cgroup,		\
> +					struct cftype *cftype,		\
> +					u64 val)			\
> +{									\
> +	struct io_cgroup *iocg;					\
> +	struct io_group *iog;						\
> +	struct hlist_node *n;						\
> +									\
> +	if (val < (__MIN) || val > (__MAX))				\
> +		return -EINVAL;						\
> +									\
> +	if (!cgroup_lock_live_group(cgroup))				\
> +		return -ENODEV;						\
> +									\
> +	iocg = cgroup_to_io_cgroup(cgroup);				\
> +									\
> +	spin_lock_irq(&iocg->lock);					\
> +	iocg->__VAR = (unsigned long)val;				\
> +	hlist_for_each_entry(iog, n, &iocg->group_data, group_node) {	\
> +		iog->entity.new_##__VAR = (unsigned long)val;		\
> +		smp_wmb();						\
> +		iog->entity.ioprio_changed = 1;				\
> +	}								\
> +	spin_unlock_irq(&iocg->lock);					\
> +									\
> +	cgroup_unlock();						\
> +									\
> +	return 0;							\
> +}
> +
> +STORE_FUNCTION(weight, 0, WEIGHT_MAX);

A small fix: io.weight should be strictly greater than 0 if we don't
want to automatically trigger the BUG_ON(entity->weight == 0) in
bfq_calc_finish().

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 block/elevator-fq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 9500619..de25f44 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1136,7 +1136,7 @@ static int io_cgroup_##__VAR##_write(struct cgroup *cgroup,		\
 	return 0;							\
 }
 
-STORE_FUNCTION(weight, 0, WEIGHT_MAX);
+STORE_FUNCTION(weight, 1, WEIGHT_MAX);
 STORE_FUNCTION(ioprio_class, IOPRIO_CLASS_RT, IOPRIO_CLASS_IDLE);
 #undef STORE_FUNCTION
 
