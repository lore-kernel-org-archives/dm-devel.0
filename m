From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/6] dm: introduce dm_accept_partial_bio
Date: Mon, 17 Mar 2014 15:18:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403171511360.9770@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317132740.GA7184@redhat.com>
	<alpine.LRH.2.02.1403171251510.24934@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317174324.GA2285@redhat.com> <20140317190907.GA3269@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140317190907.GA3269@redhat.com>
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

> On Mon, Mar 17 2014 at  1:43pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Mon, Mar 17 2014 at  1:08pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > 
> > > Regarding REQ_FLUSH - it would already crash on NULL pointer dereference 
> > > when accessing *tio->len_ptr.
> 
> I realize if any of these BUG_ON checks hits the calling target code has
> a bug.  I just think it a fairly harsh response to BUG the system.  But
> I can let this issue go.
> 
> I do however want you to add yet another BUG_ON for any bio that isn't
> meant to be sent to this interface (only one so far is REQ_FLUSH AFAIK).

Then, it triggers NULL pointer dereference. You don't have to add BUG_ON 
for it, it crashes anyway.


BTW. just a quote from a historical article to show how far have these 
attempts to handle errors went - about half of the code in Multics was 
error recovery (http://www.multicians.org/unix.html):

	We went to lunch afterward, and I remarked to Dennis that easily half the 
	code I was writing in Multics was error recovery code. He said, "We left
	all that stuff out. If there's an error, we have this routine called 
	panic, and when it is called, the machine crashes, and you holler down the 
	hall, 'Hey, reboot it.'"

Mikulas
