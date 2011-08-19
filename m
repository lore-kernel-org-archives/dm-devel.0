From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: convert dm-thin to use dm-bufio
Date: Fri, 19 Aug 2011 09:31:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108190926530.2592@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819070435.GA32300@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110819070435.GA32300@redhat.com>
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
Cc: dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, 19 Aug 2011, Mike Snitzer wrote:

> On Thu, Aug 18 2011 at  6:31pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > > This all sounds good; get the locking interface in and I'll switch to
> > > bufio straight away.
> > > 
> > > - Joe
> > 
> > I uploaded bufio-based block manager at 
> > http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/. It 
> > supports locks, but it defines new functions down_write_non_owner and 
> > up_write_non_owner.
> 
> dm-bufio.patch:
> drivers/md/Kconfig needs a more comprehensive description for DM_BUFIO's
> help.

There is intentionally no description. If there is no description, this 
option won't appear in "make menuconfig" menu.

dm-bufio is selected automatically when some module that needs it is 
configured. There is no need to select dm-bufio manually.

> dm-thinp-bufio.patch:
> 1)
> This drivers/md/persistent-data/dm-block-manager.h change avoids lots of
> block manager interface churn:
> 
> -struct dm_block;
> +#define dm_block		dm_buffer
> +#define dm_block_manager	dm_bufio_client
> 
> But I think it'd be best, in the long run, to have a follow-on patch
> that does away with the aliases and just use the bufio structs
> throughout the code.  Anyway, don't need to worry about this now.  But
> what you've done is hack that should probably be cleaned up.

This way, it's easy to swap the original block manager and dm-bufio.

If I changed the names throughout the whole dm-thinp code, it would 
conflict with any changes Joe may do.

Mikulas
