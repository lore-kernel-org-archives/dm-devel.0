From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 07/20] io-controller: Export disk time used
	and nr sectors dipatched through cgroups
Date: Tue, 23 Jun 2009 10:38:56 -0400
Message-ID: <20090623143856.GB4262@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-8-git-send-email-vgoyal@redhat.com>
	<4A40C64E.8040305@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A40C64E.8040305@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Tue, Jun 23, 2009 at 08:10:54PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
> > +				struct cftype *cftype, struct seq_file *m)
> > +{
> > +	struct io_cgroup *iocg;
> > +	struct io_group *iog;
> > +	struct hlist_node *n;
> > +
> > +	if (!cgroup_lock_live_group(cgroup))
> > +		return -ENODEV;
> > +
> > +	iocg = cgroup_to_io_cgroup(cgroup);
> > +
> > +	spin_lock_irq(&iocg->lock);
> 
> It's better to make use of rcu_read_lock instead since it's
> a read action.
> 

Thanks Gui. Queued for next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 2ad40eb..d779282 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1418,7 +1418,7 @@ static int io_cgroup_disk_time_read(struct cgroup *cgroup,
>  
>  	iocg = cgroup_to_io_cgroup(cgroup);
>  
> -	spin_lock_irq(&iocg->lock);
> +	rcu_read_lock();
>  	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
>  		/*
>  		 * There might be groups which are not functional and
> @@ -1430,7 +1430,7 @@ static int io_cgroup_disk_time_read(struct cgroup *cgroup,
>  					iog->entity.total_service);
>  		}
>  	}
> -	spin_unlock_irq(&iocg->lock);
> +	rcu_read_unlock();
>  	cgroup_unlock();
>  
>  	return 0;
> @@ -1448,7 +1448,7 @@ static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
>  
>  	iocg = cgroup_to_io_cgroup(cgroup);
>  
> -	spin_lock_irq(&iocg->lock);
> +	rcu_read_lock();
>  	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
>  		/*
>  		 * There might be groups which are not functional and
> @@ -1460,7 +1460,7 @@ static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
>  					iog->entity.total_sector_service);
>  		}
>  	}
> -	spin_unlock_irq(&iocg->lock);
> +	rcu_read_unlock();
>  	cgroup_unlock();
>  
>  	return 0;
> @@ -1478,7 +1478,7 @@ static int io_cgroup_disk_queue_read(struct cgroup *cgroup,
>  		return -ENODEV;
>  
>  	iocg = cgroup_to_io_cgroup(cgroup);
> -	spin_lock_irq(&iocg->lock);
> +	rcu_read_lock();
>  	/* Loop through all the io groups and print statistics */
>  	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
>  		/*
> @@ -1491,7 +1491,7 @@ static int io_cgroup_disk_queue_read(struct cgroup *cgroup,
>  					iog->queue_duration);
>  		}
>  	}
> -	spin_unlock_irq(&iocg->lock);
> +	rcu_read_unlock();
>  	cgroup_unlock();
>  
>  	return 0;
> -- 
> 1.5.4.rc3
> 
> 
> 
> > +	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
> > +		/*
> > +		 * There might be groups which are not functional and
> > +		 * waiting to be reclaimed upon cgoup deletion.
> > +		 */
> > +		if (iog->key) {
> > +			seq_printf(m, "%u %u %lu\n", MAJOR(iog->dev),
> > +					MINOR(iog->dev),
> > +					iog->entity.total_sector_service);
> > +		}
> > +	}
> > +	spin_unlock_irq(&iocg->lock);
> > +	cgroup_unlock();
> > +
> > +	return 0;
> > +}
> > +
> >
