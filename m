From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: convert dm-thin to use dm-bufio
Date: Fri, 19 Aug 2011 06:17:19 -0400
Message-ID: <20110819101718.GA1335@redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819070435.GA32300@redhat.com> <20110819091106.GA3193@ubuntu>
	<20110819094604.GA1059@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110819094604.GA1059@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 19 2011 at  5:46am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Aug 19 2011 at  5:11am -0400,
> Joe Thornber <thornber@redhat.com> wrote:
>
> > An alternative would be to iterate through all the pools in the system
> > check whether any of them already had the same metadata device open.
> > Of course this doesn't catch the cases where the stacking is used and
> > a metadata device eventually maps onto the same physical disk as an
> > existing md area.
> 
> The lack of checking for a metadata or data device that is already in
> use should probably be fixed.
> 
> As for stacking, can't we just read the superblock to check if a device
> is already in use (would work metadata anyway)?  No idea if that'd be
> too costly -- probably not: read superblock and check if
> THIN_SUPERBLOCK_MAGIC is set.

Bleh, that won't work.  THIN_SUPERBLOCK_MAGIC is the same for all
devices...

dm_pool_metadata_open() knows when a superblock isn't all zeroes.  We
could read the suerblock's uuid (which we provisioned for in the
superblock but don't yet set) and then go searching all other pools to
see if the same superblock uuid exists.
