From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mmotm 2012-06-21-16-20 uploaded (dm-thin)
Date: Sun, 24 Jun 2012 19:34:50 +0100
Message-ID: <20120624183449.GB17647@agk-dp.fab.redhat.com>
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
	<4FE4AAAE.3090803@xenotime.net>
	<20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
	<20120624165555.GA17647@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120624165555.GA17647@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Joe Thornber <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Sun, Jun 24, 2012 at 05:55:55PM +0100, Alasdair G Kergon wrote:
> Ah yes, I'll fix that, and check we handle "too large" devices sensibly.
 
What does it mean when sector_t is 32 bits but dm_block_t is 64 bits?

- You're loading a large pool device you created on a system where sector_t was 64 bits?
  (and we refuse to load this device)

- The top 32 bits of dm_block_t would always be zero so we should make
dm_block_t match the type of sector_t?
(Because blocks are bigger than sectors?)

int sm_ll_extend(struct ll_disk *ll, dm_block_t extra_blocks)

        old_blocks = dm_sector_div_up(ll->nr_blocks, ll->entries_per_block);

[ll->nr_blocks is 64 bits]

#define dm_sector_div_up(n, sz) ( \
{ \
        sector_t _r = ((n) + (sz) - 1); \

[sector_t might be 32 bits => truncation]

        sector_div(_r, (sz)); \
        _r; \
} \
)

Alasdair
