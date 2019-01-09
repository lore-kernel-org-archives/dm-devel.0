From: Mike Snitzer <snitzer@redhat.com>
Subject: SMR 512e drive firmware advertising misleading limits?
 [was: Re: [RFC PATCH 1/1] dm: add dust target]
Date: Wed, 9 Jan 2019 09:29:13 -0500
Message-ID: <20190109142913.GA26563@redhat.com>
References: <1546889483-6341-1-git-send-email-bgurney@redhat.com>
	<1546889483-6341-2-git-send-email-bgurney@redhat.com>
	<20190108001049.GM11315@octiron.msp.redhat.com>
	<CAHhmqcSLxihW3L+w=MZ22Z9pbU13MLD7Bn6YQey-u1soFp-KJw@mail.gmail.com>
	<20190108162314.GA16936@redhat.com>
	<CAHhmqcTfKniu1eP+fBwHf4gohOfUaz_cgaC3EUezNauUAk6O-Q@mail.gmail.com>
	<BYAPR04MB581645C55BCC328E193D3DBEE78B0@BYAPR04MB5816.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BYAPR04MB581645C55BCC328E193D3DBEE78B0@BYAPR04MB5816.namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: John Dorminy <jdorminy@redhat.com>, Joe Shimkus <jshimkus@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "tjaskiew@redhat.com" <tjaskiew@redhat.com>, John Pittman <jpittman@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 08 2019 at  8:03pm -0500,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
 
> You may want to check against the physical_block_size, and not the logical. SMR
> disks that are 512 e (512B logical and 4K physical) can handle reads in 512B
> units but writes have to be 4K. These are exceptions though and kind of breaking
> all LBA definitions known to men... This check on the physical_block_size can be
> limited to setups where the underlying disk is SMR.

Damien, this sounds like a serious issue with SMR firmware.  If the
512e SMR drive cannot handle 512b writes then it has no business
advertising 512B logical.  It should be advertising 4K logical.

What am I missing?

Mike
