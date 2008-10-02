From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Block integrity patches for 2.6.28
Date: Thu, 2 Oct 2008 12:56:32 +0200
Message-ID: <20081002105632.GF19428@kernel.dk>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753360AbYJBK5D@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: neilb@suse.de, agk@sourceware.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 01 2008, Martin K. Petersen wrote:
> 
> This patch series contains block layer integrity updates for 2.6.28.
> 
> There are a few fixes to the core bits, including a switch from
> block_device to gendisk in the integrity compare function.  I also had
> to add a helper to access a gendisk's integrity profile.  This is used
> by MD.
> 
> The DM bits have been cleaned up and a separate dm_table_set_integrity
> function has been introduced.  This allows us to avoid changing
> dm_table_set_restrictions() and its callers.
> 
> The MD patch now correctly handles devices that come and go (as
> requested by Neil).
> 
> The patches are against for-2.6.28 and depend on
> 
>     d7533ad0e132f92e75c1b2eb7c26387b25a583c1

As far as I can tell, most of that commit is still fine. You want
bdev_get_integrity() in blkdev.h, the 3 other moves and the unused
bdev_get_tag_size() do not look like they are being used by this patch
set.

Correct?

-- 
Jens Axboe
