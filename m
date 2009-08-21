From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator
	fair queuing
Date: Thu, 20 Aug 2009 22:00:28 -0400
Message-ID: <20090821020028.GA3763@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-3-git-send-email-vgoyal@redhat.com>
	<4A8DFE3A.6030503@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A8DFE3A.6030503@cn.fujitsu.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Fri, Aug 21, 2009 at 09:54:02AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
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
> Hi Vivek,
> 
> we don't need to update prio here for the following enqueue_io_entity() 
> is already taking care of it.
> 

Thanks Gui. Jerome already raised this point in one of the replies. Will
take care of it in next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 201543e..b720139 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -607,7 +607,6 @@ static void put_prev_io_entity(struct io_entity *entity)
>  
>  	if (unlikely(entity->ioprio_changed)) {
>  		dequeue_io_entity(entity);
> -		io_entity_update_prio(entity);
>  		enqueue_io_entity(entity);
>  	} else
>  		__enqueue_io_entity(st, entity);
> -- 
> 1.5.4.rc3
> 
