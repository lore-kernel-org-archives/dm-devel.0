From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/8] dm mpath: remove process_queued_ios()
Date: Wed, 5 Mar 2014 09:24:15 -0500
Message-ID: <20140305142414.GB2226@redhat.com>
References: <1393598029-67995-1-git-send-email-hare@suse.de>
	<1393598029-67995-5-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784010DC73B@BPXM12GP.gisp.nec.co.jp>
	<5316E774.8060600@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5316E774.8060600@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Mar 05 2014 at  3:59am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 03/03/2014 12:12 AM, Junichi Nomura wrote:
> > On 02/28/14 23:33, Hannes Reinecke wrote:
> >> @@ -1214,9 +1189,12 @@ static void pg_init_done(void *data, int errors)
> >>  
> >>  	if (!m->pg_init_required)
> >>  		m->queue_io = 0;
> >> -
> >> -	m->pg_init_delay_retry = delay_retry;
> >> -	queue_work(kmultipathd, &m->process_queued_ios);
> >> +	else if (m->current_pg) {
> >> +		m->pg_init_delay_retry = delay_retry;
> >> +		if (__pg_init_all_paths(m))
> >> +			goto out;
> >> +		m->queue_io = 0;
> >> +	}
> > 
> > Hi Hannes,
> > 
> > If m->pg_init_required && !m->current_pg,
> > doesn't m->queue_io remain 1 while nobody kicks pg_init?
> > 
> > That's why I suggested this:
> > 
> > 	if (m->pg_init_required) {
> > 		m->pg_init_delay_retry = delay_retry;
> > 		if (__pg_init_all_paths(m))
> > 			goto out;
> > 	}
> > 	m->queue_io = 0;
> > 
> Yeah, sorry. You are right.
> 
> Mike, can you fix it up or do you need an additional round of patches?

I'll take care of it.  I won't be looking at these patches until next
week though.

Mike
