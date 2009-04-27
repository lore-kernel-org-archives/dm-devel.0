From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: [PATCH 12/17] bottom-layer barrier support
Date: Mon, 27 Apr 2009 19:36:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904271932310.9362@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<20090427214837.GF23302@agk.fab.redhat.com>
	<20090427220644.GG23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271907150.9362@hs20-bc2-1.build.redhat.com>
	<20090427232108.GJ23302@agk.fab.redhat.com>
	<20090427232434.GL23302@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090427232434.GL23302@agk.fab.redhat.com>
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

On Tue, 28 Apr 2009, Alasdair G Kergon wrote:

> In other words, I'm asking for it to be defined and documented what the 
> target map function receives as input for one of these flush requests.
> 
> Alasdair
> -- 
> agk@redhat.com

It receives what it's set in dm_flush and __clone_and_map_empty_barrier.

bio is standard zero barrier with set bi_bdev and bi_rw. 
tio->info.flush_request is the sequence number of the request. (typical 
devices require just one request, dm_stripe asks for several requests for 
each striped device).

Mikulas
