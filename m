From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] Use low pointer bits for dm io region
Date: Wed, 11 Nov 2009 15:50:39 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911111548180.32278@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911102104350.23116@hs20-bc2-1.build.redhat.com>
	<4AFA6717.2060305@ct.jp.nec.com>
	<20091111150408.GN17055@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091111150408.GN17055@agk-dp.fab.redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 11 Nov 2009, Alasdair G Kergon wrote:

> On Wed, Nov 11, 2009 at 04:26:15PM +0900, Kiyoshi Ueda wrote:
> > The code is not easily readable for me.
> 
> Introducing some macros will probably deal with that.

There is:
- bit masking in bio_set_io_region and bio_get_io_region (but they are 
complement to each other and bit tricks are not diffused elsewhere)
- an ugly trick in sync_io to work around gcc definicency (it can't align 
variables on stack)

Otherwise, it's standard C.

Mikulas

> > Why don't you introduce a new structure in which those two things
> > can be stored, and allocate/attach it per bio?
> 
> That code didn't want the overhead of managing additional allocations.
>  
> Alasdair
> 
