From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/6] dm-snapshot: use bufio prefetch
Date: Tue, 14 Jan 2014 16:50:40 -0500
Message-ID: <20140114215040.GA12463@redhat.com>
References: <alpine.LRH.2.02.1401131911570.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131912480.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131913090.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131913420.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131914080.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131914270.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<20140114165840.GA10687@redhat.com>
	<alpine.LRH.2.02.1401141540280.19206@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401141540280.19206@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 14 2014 at  3:43pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 14 Jan 2014, Mike Snitzer wrote:
> 
> > On Mon, Jan 13 2014 at  7:14pm -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > +	dm_bufio_set_minimum_buffers(client, DM_PREFETCH_CHUNKS + 1);
> > > +
> > 
> > Why the +1?  I'd prefer that be managed in dm-bufio rather than relying
> > on all callers to know to add +1.
> > 
> > Can you supply a followup patch that cleans this up in bufio and remove
> > the +1 in the above dm_bufio_set_minimum_buffers call?
> 
> If DM_PREFETCH_CHUNKS is 12, we need 13 buffers in dm-bufio (one for the 
> current buffer that is being read and 12 read ahead buffers).
> 
> It is correct to have +1 in snapshot code, not in dm-bufio code.

OK, thanks for clarifying.

I've folded the dm bufio changes needed for the respective dm snapshot
changes -- so there are now 4 patches instead of your otiginal 6.
I added a comment for "1 + DM_PREFETCH_CHUNKS" above the
dm_bufio_set_minimum_buffers call and tweaked the headers a little.

I also staged your non-modular kobject release patch (tweaked the header
on that a little bit too).

Please see the 5 topmost commits here:
http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next
