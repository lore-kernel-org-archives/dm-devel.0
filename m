From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/7] dm-crypt: avoid deadlock in mempools
Date: Mon, 16 Feb 2015 11:29:03 -0500
Message-ID: <20150216162902.GB20303@redhat.com>
References: <alpine.LRH.2.02.1502130823540.6449@file01.intranet.prod.int.rdu2.redhat.com>
	<20150213211614.GA7180@redhat.com>
	<alpine.LRH.2.02.1502131708030.447@file01.intranet.prod.int.rdu2.redhat.com>
	<20150214011445.GA14223@redhat.com> <54E1B8D9.3050803@redhat.com>
	<20150216135852.GA20220@redhat.com> <54E1FA75.1070101@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54E1FA75.1070101@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 16 2015 at  9:11am -0500,
Ondrej Kozina <okozina@redhat.com> wrote:

> On 02/16/2015 02:58 PM, Mike Snitzer wrote:
> >On Mon, Feb 16 2015 at  4:31am -0500,
> >Milan Broz <mbroz@redhat.com> wrote:
> >
> >>On 02/14/2015 02:14 AM, Mike Snitzer wrote:
> >>>On Fri, Feb 13 2015 at  5:09P -0500,
> >>>Mikulas Patocka <mpatocka@redhat.com> wrote:
> >>>
> >>>>
> >>>>
> >>>>On Fri, 13 Feb 2015, Mike Snitzer wrote:
> >>>>
> >>>>>   * In order to not degrade performance with excessive locking, we try
> >>>>>- * non-blocking allocations without a mutex first and if it fails, we fallback
> >>>>>+ * non-blocking allocation without a mutex first and if it fails, we fallback
> >>>>>   * to a blocking allocation with a mutex.
> >>>>>   */
> >>>>>  static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
> >>>>
> >>>>There are multiple allocations, so I would leave plural there.
> >>>
> >>>Fixed, and tweaked the headers (already did that last time around so
> >>>nothing new, you just didn't pick up my headers for your v2).  I pushed
> >>>your patchset to linux-next (for 3.21), see:
> >>>https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next
> >>>
> >>>Ondrej and Milan, please let us know if you hit any problems with this
> >>>patchset and/or branch.
> >>
> >>Will try to test it soon on some strange configurations :)
> >
> >OK, see if you and Ondrej can re-test with urgency over the next few
> >days.
> >
> 
> I'll post summary of results as a reply to the top post, including
> short commentary on why we decided to implement the switch for
> dmtable.
> 
> For anyone interested I'll also give links to full test results.
> 
> AFAIK the only thing that should be tested again at the moment is
> the switch itself.

There are now 2 switches.  But in order to test these switches you'll
need to re-establish the baseline without any patches.

See:
1) same_cpu_crypt
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=a3a0e3e8b98d9ada663023937eaddd7e54961a7d
2) submit_from_crypt_cpus
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=0f5d8e6ee758f7023e4353cca75d785b2d4f6abe

Please make sure you're using latest rebased dm-for-3.20 branch (tip is
commit b3c5fd3052492f1b8d060799d4f18be5a5438add).

Please test the 4 different permutations these flags can enable (so it
looks like it'd be runs against 5 different dm-cryot.ko permutations).

Thanks!
