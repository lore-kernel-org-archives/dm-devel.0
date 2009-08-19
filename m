From: Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator fair queuing
Date: Wed, 19 Aug 2009 18:01:34 +0200
Message-ID: <4A8C21DE.1080001@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750974AbZHSQCl@vger.kernel.org>
In-Reply-To: <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal wrote:
> o This is core of the io scheduler implemented at elevator layer. This is a mix
>   of cpu CFS scheduler and CFQ IO scheduler. Some of the bits from CFS have
>   to be derived so that we can support hierarchical scheduling. Without
>   cgroups or with-in group, we should essentially get same behavior as CFQ.
> 
> o This patch only shows non-hierarchical bits. Hierarhical code comes in later
>   patches.
> 
> o This code is the building base of introducing fair queuing logic in common
>   elevator layer so that it can be used by all the four IO schedulers.

> +static void enqueue_io_entity(struct io_entity *entity)
> +{
> +	struct io_service_tree *st = entity->st;
> +	struct io_sched_data *sd = io_entity_sched_data(entity);
> +
> +	/* In case task ioprio class changed while entity was off tree */
> +	io_entity_update_prio(entity);
> +	st->nr_active++;
> +	sd->nr_active++;
> +	entity->on_st = 1;
> +	place_entity(st, entity, 0);
> +	__enqueue_io_entity(st, entity);
> +}

> +static void put_prev_io_entity(struct io_entity *entity)
> +{
> +	struct io_service_tree *st = entity->st;
> +	struct io_sched_data *sd = io_entity_sched_data(entity);
> +
> +	st->active_entity = NULL;
> +	sd->active_entity = NULL;
> +
> +	if (unlikely(entity->ioprio_changed)) {
> +		dequeue_io_entity(entity);
> +		io_entity_update_prio(entity);

That call to io_entity_update_prio() looks redundant with the one in
enqueue_io_entity().

> +		enqueue_io_entity(entity);
> +	} else
> +		__enqueue_io_entity(st, entity);
> +}

Jerome
