From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/6] dm: introduce dm_accept_partial_bio
Date: Mon, 17 Mar 2014 18:45:06 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403171838380.12877@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317132740.GA7184@redhat.com>
	<alpine.LRH.2.02.1403171251510.24934@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317174324.GA2285@redhat.com> <20140317190907.GA3269@redhat.com>
	<alpine.LRH.2.02.1403171511360.9770@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317194701.GB3269@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140317194701.GB3269@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 17 Mar 2014, Mike Snitzer wrote:

> > > I do however want you to add yet another BUG_ON for any bio that isn't
> > > meant to be sent to this interface (only one so far is REQ_FLUSH AFAIK).
> > 
> > Then, it triggers NULL pointer dereference. You don't have to add BUG_ON 
> > for it, it crashes anyway.
> 
> I understand it'll NULL pointer, but that is _always_ confusing for
> someone who wasn't the original developer.  Please add the explicit
> BUG_ON() for REQ_FLUSH.

The user will not hit a BUG with REQ_FLUSH. Regarding the developer - it 
is expected that the kernel developer is able to decode the oops message, 
compare it with disassembled code and find out which variable was NULL. 
The function is small, so it's an easy task.

We don't really need
BUG_ON(!pointer);
variable = *pointer;

Mikulas
