From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Check region size during dirty log creation
Date: Wed, 29 Oct 2008 13:56:07 +0000
Message-ID: <20081029135607.GF31233@agk.fab.redhat.com>
References: <1225285328.3974.5.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1225285328.3974.5.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 29, 2008 at 02:02:08PM +0100, Heinz Mauelshagen wrote:
> This patch adds checks to the dirty log creation for region size to be
> larger than 2 sectors and to be a power of 2.
 
Interesting we didn't validate that, but the userspace validation is
tighter.

        if (lp->region_size % (pagesize >> SECTOR_SHIFT)) {
                log_error("Region size (%" PRIu32 ") must be a multiple of "
                          "machine memory page size (%d)",
                          lp->region_size, pagesize >> SECTOR_SHIFT);

The validation should be consistent between userspace and kernel.

Alasdair
-- 
agk@redhat.com
