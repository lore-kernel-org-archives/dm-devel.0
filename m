From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: dm-cache fails to write the cache
	device in writethrough mode
Date: Sat, 23 Mar 2013 03:00:44 +0000
Message-ID: <20130323030043.GA30269@agk-dp.fab.redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130322201151.GB5357@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 22, 2013 at 01:11:51PM -0700, Darrick J. Wong wrote:
> The new writethrough strategy for dm-cache issues a bio to the origin device,
> remaps the bio to the cache device, and issues the bio to the cache device.
> However, the block layer modifies bi_sector and bi_size, so we need to preserve
> these or else nothing gets written to the cache (bi_size == 0).  This fixes the
> problem where someone writes a block through the cache, but a subsequent reread
> (from the cache) returns old contents.

If this needs doing here, please use dm_bio_record() and dm_bio_restore().
E.g. Look at how dm-raid1.c does something similar.
 
Alasdair
