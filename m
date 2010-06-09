From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/2] dm: table load must always try
	dm_setup_md_queue
Date: Wed, 9 Jun 2010 04:53:46 -0400
Message-ID: <20100609085346.GA1009@redhat.com>
References: <1274964469-22289-1-git-send-email-snitzer@redhat.com>
	<1274964469-22289-3-git-send-email-snitzer@redhat.com>
	<20100604201524.GC4917@redhat.com> <4C0F28F0.5090604@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4C0F28F0.5090604@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 09 2010 at  1:38am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 06/05/2010 05:15 AM +0900, Mike Snitzer wrote:
> > @@ -2164,7 +2164,8 @@ static int dm_init_request_based_queue(s
> >  {
> >  	struct request_queue *q = NULL;
> >  
> > -	BUG_ON(md->queue->elevator);
> > +	if (unlikely(md->queue->elevator))
> > +		return 1;
> 
> I think the "unlikely" should be rather "likely", since
> dm_init_request_based_queue() is now called whenever request-based
> table is loaded even after the actual initialization has been done.

Yes, good point.  Though I'd expect reloading a request-based table is
actually fairly rare.  Is it really all that worthwhile to have any
branch prediction here?  Should we just remove the likely/unlikely
entirely?

Thanks,
Mike
