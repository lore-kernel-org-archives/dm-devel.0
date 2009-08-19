From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator
	fair queuing
Date: Wed, 19 Aug 2009 14:41:42 -0400
Message-ID: <20090819184142.GD4391@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-3-git-send-email-vgoyal@redhat.com>
	<4A8C21DE.1080001@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A8C21DE.1080001@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jerome Marchand <jmarchan@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Wed, Aug 19, 2009 at 06:01:34PM +0200, Jerome Marchand wrote:
> Hi Vivek,
> 
> Vivek Goyal wrote:
> > o This is core of the io scheduler implemented at elevator layer. This is a mix
> >   of cpu CFS scheduler and CFQ IO scheduler. Some of the bits from CFS have
> >   to be derived so that we can support hierarchical scheduling. Without
> >   cgroups or with-in group, we should essentially get same behavior as CFQ.
> > 
> > o This patch only shows non-hierarchical bits. Hierarhical code comes in later
> >   patches.
> > 
> > o This code is the building base of introducing fair queuing logic in common
> >   elevator layer so that it can be used by all the four IO schedulers.
> 
> > +static void enqueue_io_entity(struct io_entity *entity)
> > +{
> > +	struct io_service_tree *st = entity->st;
> > +	struct io_sched_data *sd = io_entity_sched_data(entity);
> > +
> > +	/* In case task ioprio class changed while entity was off tree */
> > +	io_entity_update_prio(entity);
> > +	st->nr_active++;
> > +	sd->nr_active++;
> > +	entity->on_st = 1;
> > +	place_entity(st, entity, 0);
> > +	__enqueue_io_entity(st, entity);
> > +}
> 
> > +static void put_prev_io_entity(struct io_entity *entity)
> > +{
> > +	struct io_service_tree *st = entity->st;
> > +	struct io_sched_data *sd = io_entity_sched_data(entity);
> > +
> > +	st->active_entity = NULL;
> > +	sd->active_entity = NULL;
> > +
> > +	if (unlikely(entity->ioprio_changed)) {
> > +		dequeue_io_entity(entity);
> > +		io_entity_update_prio(entity);
> 
> That call to io_entity_update_prio() looks redundant with the one in
> enqueue_io_entity().
> 

thanks Jerome. Yes it does look like a redundant call. Will get rid of it
in next posting.

Vivek

> > +		enqueue_io_entity(entity);
> > +	} else
> > +		__enqueue_io_entity(st, entity);
> > +}
> 
> Jerome
