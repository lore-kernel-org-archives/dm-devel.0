From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2 of 2] DM Snapshot: dont insert before
	existing chunk
Date: Thu, 24 Sep 2009 13:48:42 +0100
Message-ID: <20090924124841.GI3866@agk-dp.fab.redhat.com>
References: <200909231525.n8NFP87C029957@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200909231525.n8NFP87C029957@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 23, 2009 at 10:25:08AM -0500, Jon Brassow wrote:
> Don't insert into hash before an existing chunk.
> Most inserts are after an existing extent anyway so this code is used
> very rarely.
 
Again, I'm not particularly keen on taking this one.  Some systems are very
short of memory and everything we can save matters and we have no statistics
about how "rare" this actually is.

Is it really that difficult to split into two when removing?

Alasdair
