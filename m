From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: A bug in dm-persistent-data module which leads to
 dm-thin metadata corruption
Date: Fri, 7 Mar 2014 11:20:17 -0500
Message-ID: <20140307162016.GB31775@redhat.com>
References: <CAKTMprO45LWFnN0sTES919GYQ9fcqtwzubUf=9s3nBpxTSbZsw@mail.gmail.com>
	<20140307151425.GB10613@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140307151425.GB10613@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Teng-Feng Yang <shinrairis@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 07 2014 at 10:14am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> On Fri, Mar 07, 2014 at 12:00:07PM +0800, Teng-Feng Yang wrote:
> > Dear all,
> > 
> > I had experienced a dm-thin metadata corruption a couple of days ago,
> > and I found that someone had
> > reported the similar corruption to dm-devel recently.
> > http://www.redhat.com/archives/dm-devel/2014-February/msg00157.html
> > 
> > Since this issue will leads to unrecoverable metadata corruption and
> > could be reproduced every time,
> > we add some traces and hope to find out the root cause of this. After
> > dumping the trace, I think we
> > might find a bug in dm-persistent-data and I will try my best to
> > explain it clearly in below.
> > 
> > When decreasing the reference count of a metadata block with its
> > reference count equals 3,
> > we will call dm_btree_remove() to remove this enrty from the B+tree
> > which keeps the reference count info
> > in metadata device.
> > 
> > The B+tree will try to rebalance the entry of the child nodes in each
> > node it traversed, and
> > the rebalance process contains the following steps.
> > 
> > (1) Finding the corresponding children in current node (shadow_current(s))
> > (2) Shadow the children block (issue BOP_INC)
> > (3) redistribute keys among children, and free children if necessary
> > (issue BOP_DEC)
> > 
> > Since the update of a metadata block's reference count could be
> > recursive, we will stash these
> > reference count update operations in smm->uncommitted and then process
> > them in a FILO fashion.
> > The problem is that step(3) could free the children which is created
> > in step(2), so the BOP_DEC issued
> > in step(3) will be carried out  before the BOP_INC issued in step(2)
> > since these BOPs will be processed in
> > FILO fashion. Once the BOP_DEC from step(3) tries to decrease the
> > reference count of newly shadow block,
> > it will report failure for its reference equals 0 before decreasing.
> > It looks like we can solve this issue by processing
> > these BOPs in a FIFO fashion instead of FILO.
> > 
> > Any comment will be grateful.
> 
> Dennis,
> 
> That's a really impressive piece of analysis.  I think you've found
> the issue.
> 
> Could you try with this patch please and see if it fixes things?

Also, if you could share what you're using to (quickly?) reproduce
that'd be appreciated.

Thanks,
Mike
