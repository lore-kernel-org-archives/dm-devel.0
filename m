From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache invalidate_cblocks range parsing
Date: Tue, 26 Nov 2013 11:20:47 -0500
Message-ID: <20131126162046.GA27431@redhat.com>
References: <33A0129EBFD46748804DE81B354CA1B21C0532E5@SACEXCMBX06-PRD.hq.netapp.com>
	<20131125224618.GG27771@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131125224618.GG27771@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 25 2013 at  5:46pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Sun, Nov 24, 2013 at 02:25:33AM +0000, Mears, Morgan wrote:
> > 	dmsetup message cache 0 invalidate_cblocks 10-11
> > cblock 11 will still be in the cache.  
> 
> I think that should be changed.
> 
> It runs counter to the way LVM handles range specifications and seems
> set to create avoidable ambiguity: everyone looking at any ranges in
> dm/lvm would now have to check whether the last item in a range is
> included or not in each context they encounter one as we would no longer
> present a consistent position on this.
>
> To my mind, 10-11 expands to the list of integer block labels consisting 
> of 10 and 11,  (We are not talking about intervals pulled out of a
> continuous number line here: 10-10.9 would have no meaning.)  I consider
> blocks to be discrete objects and saying "the last numbered block listed
> is always excluded" strikes me as counter-intuitive.
> 
> The compromise we reached for dm statistics to reduce the chance of
> misinterpretation was to use start+number_of_items: so 10+1 in this case
> where only one block was meant to be included.

I'm embracing what Joe would like to use.  His preference for this
syntax isn't his alone, see:
http://gcc.gnu.org/onlinedocs/libstdc++/manual/bk01pt08ch19s02.html

As for targets having different meanings for ranges.  People already
need to pour over the table syntax of a given target if they'd like to
assemble it by hand.  Needing to understand the invalidate_cblocks
mesaage range is "one past the end" isn't asking too much.

The invalidate_cblocks interface is really intended to be used by the
cache tools, not humans.

I updated cache.txt to properly document the range syntax, see:
http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=f0417b93a59e8f2
