From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio: move dm-bufio.h to include/linux/
Date: Thu, 8 Mar 2018 15:36:21 -0500
Message-ID: <20180308203621.GA8133@redhat.com>
References: <alpine.LRH.2.02.1803080421030.9508@file01.intranet.prod.int.rdu2.redhat.com>
	<20180308144955.GA23262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180308144955.GA23262@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Thomas Jaskiewicz <tomj@permabit.com>
List-Id: dm-devel.ids

On Thu, Mar 08 2018 at  9:49am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Mar 08, 2018 at 04:22:01AM -0500, Mikulas Patocka wrote:
> > This patch moves dm-bufio to include/linux/, so that external modules can
> > use it. (it is needed for the VDO team)
> 
> NAK.  That code once merged should just move to drivers/md/.

While I appreciate your interest in what constitutes a reasonable change
for DM, why are you so emphatic about disallowing out-of-tree DM modules
from using dm-bufio?

I'm assuming you feel this type of change discourages external DM
targets from pursuing upstream inclusion.  While it may be the case for
some external _GPL'd_ DM target, I really don't care about them.  I care
about DM targets that want to stabilize while preparing their code for
upstream inclusion.

The less restrictions placed on external DM target modules the more
likely they'll be "ready" for inclusion in the future.  If these
external DM targets are forced to avoid using dm-bufio, yet having a
need for the functionality so reinventing the wheel, it just creates
more problems once they do pursue upstream inclusion.

So I'll be accepting this change for 4.17 because it actually helps
encourage external DM targets to use proper interfaces while preparing
for upstream inclusion.

Mikulas: please submit a v2 of this patch that also changes dm-bufio.c's
few EXPORT_SYMBOL() symbols to EXPORT_SYMBOL_GPL().

Thanks,
Mike
