From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm: dm-cache fails to write the cache device in
 writethrough mode
Date: Mon, 25 Mar 2013 10:28:38 +0000
Message-ID: <20130325102837.GB6340@debian>
References: <20130322201151.GB5357@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130322201151.GB5357@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Darrick,

On Fri, Mar 22, 2013 at 01:11:51PM -0700, Darrick J. Wong wrote:
> The new writethrough strategy for dm-cache issues a bio to the origin device,
> remaps the bio to the cache device, and issues the bio to the cache device.
> However, the block layer modifies bi_sector and bi_size, so we need to preserve
> these or else nothing gets written to the cache (bi_size == 0).  This fixes the
> problem where someone writes a block through the cache, but a subsequent reread
> (from the cache) returns old contents.

Thanks for diagnosing this, as you may have gathered none of the
hardware we're testing on does this.  I've pushed a patch to dm-devel
that hopefully will make it's way upstream very quickly.  I used
dm_bio_record/restore, since there are many more fields that
underlying drivers make tweak in the bio.

- Joe
