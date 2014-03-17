From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/6] dm: introduce dm_accept_partial_bio
Date: Mon, 17 Mar 2014 15:47:02 -0400
Message-ID: <20140317194701.GB3269@redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317132740.GA7184@redhat.com>
	<alpine.LRH.2.02.1403171251510.24934@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317174324.GA2285@redhat.com>
	<20140317190907.GA3269@redhat.com>
	<alpine.LRH.2.02.1403171511360.9770@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1403171511360.9770@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 17 2014 at  3:18pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 17 Mar 2014, Mike Snitzer wrote:
> 
> > On Mon, Mar 17 2014 at  1:43pm -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > On Mon, Mar 17 2014 at  1:08pm -0400,
> > > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > 
> > > > 
> > > > Regarding REQ_FLUSH - it would already crash on NULL pointer dereference 
> > > > when accessing *tio->len_ptr.
> > 
> > I realize if any of these BUG_ON checks hits the calling target code has
> > a bug.  I just think it a fairly harsh response to BUG the system.  But
> > I can let this issue go.
> > 
> > I do however want you to add yet another BUG_ON for any bio that isn't
> > meant to be sent to this interface (only one so far is REQ_FLUSH AFAIK).
> 
> Then, it triggers NULL pointer dereference. You don't have to add BUG_ON 
> for it, it crashes anyway.

I understand it'll NULL pointer, but that is _always_ confusing for
someone who wasn't the original developer.  Please add the explicit
BUG_ON() for REQ_FLUSH.
