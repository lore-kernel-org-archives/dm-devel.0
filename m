From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Check region size during dirty log creation
Date: Wed, 29 Oct 2008 20:51:32 +0000
Message-ID: <20081029205132.GJ31233@agk.fab.redhat.com>
References: <1225285328.3974.5.camel@o>
	<20081029135607.GF31233@agk.fab.redhat.com>
	<1225292850.1196.4.camel@o>
	<20081029154357.GI31233@agk.fab.redhat.com>
	<1225295622.1196.12.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1225295622.1196.12.camel@o>
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

On Wed, Oct 29, 2008 at 04:53:42PM +0100, Heinz Mauelshagen wrote:
> I'm arguing, that the kernel should only restrict to prevent against
> programming errors.
 
Indeed - but I'm asking where the existing constraint is coming
from and if it is still/was ever correct?

Also, this patch duplicates existing checks in _check_region_size()
that should be removed if the validation moves.

static inline int _check_region_size(struct dm_target *ti, uint32_t size)
{
        return !(size % (PAGE_SIZE >> 9) || !is_power_of_2(size) ||
                 size > ti->len);
}

Alasdair
-- 
agk@redhat.com
