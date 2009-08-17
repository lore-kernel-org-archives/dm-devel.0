From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator
	fair queuing
Date: Mon, 17 Aug 2009 13:29:48 +0800
Message-ID: <4A88EACC.6010805@cn.fujitsu.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> +static void place_entity(struct io_service_tree *st, struct io_entity *entity,
> +				int add_front)
> +{
> +	u64 vdisktime = st->min_vdisktime;
> +	struct rb_node *parent;
> +	struct io_entity *entry;
> +	int nr_active = st->nr_active - 1;
> +
> +	/*
> +	 * Currently put entity at the end of last entity. This probably will
> +	 * require adjustments as we move along
> +	 */
> +	if (io_entity_class_idle(entity)) {
> +		vdisktime = elv_delta_fair(ELV_IDLE_DELAY, entity);
> +		parent = rb_last(&st->active);
> +		if (parent) {
> +			entry = rb_entry(parent, struct io_entity, rb_node);
> +			vdisktime += entry->vdisktime;
> +		}
> +	} else if (!add_front && nr_active) {
> +		parent = rb_last(&st->active);
> +		if (parent) {
> +			entry = rb_entry(parent, struct io_entity, rb_node);
> +			vdisktime = entry->vdisktime;
> +		}
> +	} else
> +		vdisktime = st->min_vdisktime;

Hi Vivek,

Should we set vdisktime a little small than st->min_vdisktime to ensure putting
this entity at the left-most position when add_front is set?

> +
> +	entity->vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
> +}
> +
> +static inline void io_entity_update_prio(struct io_entity *entity)
> +{
> +	if (unlikely(entity->ioprio_changed)) {
> +		/*
> +		 * Re-initialize the service tree as ioprio class of the
> +		 * entity might have changed.
> +		 */
> +		init_io_entity_service_tree(entity, parent_entity(entity));
> +		entity->ioprio_changed = 0;
> +	}
> +}
> +


-- 
Regards
Gui Jianfeng
