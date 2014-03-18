From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/6] dm: introduce dm_accept_partial_bio
Date: Mon, 17 Mar 2014 21:26:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403172050330.17942@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317132740.GA7184@redhat.com>
	<alpine.LRH.2.02.1403171251510.24934@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317174324.GA2285@redhat.com> <20140317190907.GA3269@redhat.com>
	<alpine.LRH.2.02.1403171511360.9770@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317194701.GB3269@redhat.com>
	<alpine.LRH.2.02.1403171838380.12877@file01.intranet.prod.int.rdu2.redhat.com>
	<20140318004951.GD4037@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140318004951.GD4037@redhat.com>
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

> > The user will not hit a BUG with REQ_FLUSH. Regarding the developer - it 
> > is expected that the kernel developer is able to decode the oops message, 
> > compare it with disassembled code and find out which variable was NULL. 
> > The function is small, so it's an easy task.
> 
> By that logic then no BUG_ON() should ever be needed.  You need to know
> to quit while you're ahead ;)

The difference is this - if you ignore BUG_ON on bad arithmetics in bio 
processing, you may introduce subtle data corruption. So, the developer 
may spend hours or days trying to reproduce the data corruption. When he 
finds a reproducible case, he has to spend additional time trying to find 
the reason for the corruption, in worst case it may involve recording the 
content of all incoming and outcoming bios and searching for a 
discrepancy.

BUG_ON saves all this work.

> > We don't really need
> > BUG_ON(!pointer);
> > variable = *pointer;
> 
> Right, we don't.. but it helps resolve issues quicker if thoughtful
> BUG_ON()s hit before more obscure crashes do.  Whereby obviating the
> need to reverse engineer _why_ the NULL pointer occurred.

On the other hand, if the developer calls dm_accept_partial_bio on a flush 
request, he gets a NULL pointer dereference, the crash is perfectly 
reproducible, there is no subltle data corruption. You can add 
BUG_ON(bio->bi_rw & REQ_FLUSH), I'm not strongly opposed to that, I just 
think it is not needed.

Mikulas
