From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] dm-integrity: fix inefficient allocation
	of	stack space
Date: Wed, 19 Jul 2017 14:39:56 -0400
Message-ID: <22895.42876.199753.299282@quad.stoffel.home>
References: <alpine.LRH.2.02.1707191122240.2305@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1707191122240.2305@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

Mikulas> When using block size greater than 512 bytes, the dm-integrity target
Mikulas> allocates journal space inefficiently, it allocates one entry for each
Mikulas> 512-byte chunk of data, fills entries for each block of data and leaves
Mikulas> the remaining entries unused. This doesn't cause data corruption, but it
Mikulas> causes severe performance degradation.

Mikulas> This patch fixes the journal allocation. As a safety it also
Mikulas> adds BUG that fires if the variables representing journal
Mikulas> usage get out of sync (it's better to crash than continue and
Mikulas> corrupt data, so BUG is justified).

No, I don't agree.  You should lock down the block device(s) using the
dm-integrity target, but you should NOT take down the entire system
because of this.  Just return a failure up the stack that forces the
device into read only mode so that there's a chance to debug this
issue.

Using a BUG_ON, especially for code that isn't proven, is just wrong.
Do a WARN_ONCE() and then return an error instead.

John



Mikulas> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Mikulas> Cc: stable@vger.kernel.org
Mikulas> Fixes: 7eada909bfd7 ("dm: add integrity target")

Mikulas> ---
Mikulas>  drivers/md/dm-integrity.c |    7 ++++---
Mikulas>  1 file changed, 4 insertions(+), 3 deletions(-)

Mikulas> Index: linux-2.6/drivers/md/dm-integrity.c
Mikulas> ===================================================================
Mikulas> --- linux-2.6.orig/drivers/md/dm-integrity.c
Mikulas> +++ linux-2.6/drivers/md/dm-integrity.c
Mikulas> @@ -1589,14 +1589,14 @@ retry:
Mikulas>  			unsigned next_entry, i, pos;
Mikulas>  			unsigned ws, we;
 
Mikulas> -			dio->range.n_sectors = min(dio->range.n_sectors, ic->free_sectors);
Mikulas> +			dio->range.n_sectors = min(dio->range.n_sectors, ic->free_sectors << ic->sb->log2_sectors_per_block);
Mikulas>  			if (unlikely(!dio->range.n_sectors))
Mikulas>  				goto sleep;
Mikulas> -			ic->free_sectors -= dio->range.n_sectors;
Mikulas> +			ic->free_sectors -= dio->range.n_sectors >> ic->sb->log2_sectors_per_block;
Mikulas>  			journal_section = ic->free_section;
Mikulas>  			journal_entry = ic->free_section_entry;
 
Mikulas> -			next_entry = ic->free_section_entry + dio->range.n_sectors;
Mikulas> +			next_entry = ic->free_section_entry + (dio->range.n_sectors >> ic->sb->log2_sectors_per_block);
ic-> free_section_entry = next_entry % ic->journal_section_entries;
ic-> free_section += next_entry / ic->journal_section_entries;
ic-> n_uncommitted_sections += next_entry / ic->journal_section_entries;
Mikulas> @@ -1727,6 +1727,7 @@ static void pad_uncommitted(struct dm_in
Mikulas>  		wraparound_section(ic, &ic->free_section);
ic-> n_uncommitted_sections++;
Mikulas>  	}
Mikulas> +	BUG_ON((ic->n_uncommitted_sections + ic->n_committed_sections) * ic->journal_section_entries + ic->free_sectors != ic->journal_sections * ic->journal_section_entries);
Mikulas>  }
 
Mikulas>  static void integrity_commit(struct work_struct *w)

Mikulas> --
Mikulas> dm-devel mailing list
Mikulas> dm-devel@redhat.com
Mikulas> https://www.redhat.com/mailman/listinfo/dm-devel
