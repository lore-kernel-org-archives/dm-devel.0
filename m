From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] i/o errors with dm-over-md-raid0
Date: Mon, 18 May 2009 11:17:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0905181115410.22422@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0905111226120.1438@hs20-bc2-1.build.redhat.com>
	<20090512113037.GA3966@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090512113037.GA3966@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 12 May 2009, Alasdair G Kergon wrote:

> On Mon, May 11, 2009 at 12:35:34PM -0400, Mikulas Patocka wrote:
> > +	 * If the target doesn't support merge method and some of the devices
> 
> Do you think we should add merge methods to more of our targets?
> It looks like we've only done linear and crypt so far.

For performance improvement we could add more merge methods.

But for correctness and and i/o error avoidance the patch that I posted 
should be applied.

Mikulas

> Alasdair
> 
