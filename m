From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/8] [dm-thin] Fix a race condition between
 discard bios and ordinary bios.
Date: Fri, 14 Dec 2012 10:52:22 -0500
Message-ID: <20121214155222.GA1145@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-6-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1355429956-22785-6-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 13 2012 at  3:19pm -0500,
Joe Thornber <ejt@redhat.com> wrote:

> The deferred_set entries should not be incremented until the bio
> prison cells are held.  Otherwise quiescing a block for discard may
> end up waiting for a bio that's held in the discard bios cell.

This patch's subject and header needs help.  We've already fixed the
race with discards and normal bios in an earlier patch:
https://www.redhat.com/archives/dm-devel/2012-December/msg00010.html

This patch is purely about adapting dm-thin to use the new bio-prison
interface where the memory is now passed in rather than using a mempool
in bio-prison.  Two preallocated cells are now included in struct
thin_c; this allows the map function to not block performing allocations
(we want to avoid the cell allocation that is done in bio_detain).

The thin_c is allocated once in the constructor (thin_ctr).  Because the
thin_c is a shared resource, access to its cells must be serialized
using a new spinlock.

(NOTE: elevating the dm_bio_prison_cell structure from dm-bio-prison.c
to dm-bio-prison.h really should be part of this patch -- rather than
the previous patch).
