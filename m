From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 7/7] dm snapshot: use bufio prefetch
Date: Mon, 13 Jan 2014 18:45:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401131843470.26646@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229150.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229390.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230080.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230330.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111231000.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111231420.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<20140113213758.GC3268@redhat.com>
	<alpine.LRH.2.02.1401131659250.12957@file01.intranet.prod.int.rdu2.redhat.com>
	<20140113225651.GA1678@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140113225651.GA1678@redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 13 Jan 2014, Mike Snitzer wrote:

> On Mon, Jan 13 2014 at  5:00pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > No.
> > 
> > This changed patch inefficiently loops in bufio_prefetch_chunks for each 
> > buffer that is read.
> 
> Yeah, I overlooked the importance of preserving prefetch_area (which
> explains the unlikely you had).  But my intent was to make your code
> less "special"; your if (DM_PREFETCH_CHUNKS) do { } while() code to
> avoid the extra indentation is pretty ugly.
> 
> Given your current code, DM_PREFETCH_CHUNKS is always 12 so why not just
> remove the check?

If someone ever changes it to a variable, the condition is there avoid 
unneeded call to dm_bufio_prefetch. The compiler optimizes out the 
constant expression, so it doesn't matter that it's there.

Mikulas
