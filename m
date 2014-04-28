From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/6] dm: introduce dm_ask_for_duplicate_bios
Date: Mon, 28 Apr 2014 11:45:36 -0400
Message-ID: <20140428154536.GA28470@redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141841290.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141842170.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141843120.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141843520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<20140425185056.GA5388@redhat.com>
	<alpine.LRH.2.02.1404281107270.12081@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1404281107270.12081@file01.intranet.prod.int.rdu2.redhat.com>
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

On Mon, Apr 28 2014 at 11:09am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 25 Apr 2014, Mike Snitzer wrote:
> > 
> > Hey Mikulas,
> > 
> > I'm not immediately seeing how increasing tio->num_bios from within a
> > target's map method, using dm_ask_for_duplicate_bios, will cause DM core
> > to send duplicates.
> > 
> > Nothing in DM core actually consumes tio->num_bios -- please advise.
> > 
> > Thanks,
> > Mike
> 
> tio->num_bios is a pointer. You don't increase tio->num_bios, you increase 
> the value it points to. It points to the local variable that is the limit 
> of the for loop.

I see, thanks for clarifying.
