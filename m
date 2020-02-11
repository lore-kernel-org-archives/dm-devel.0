From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 15/17] libmultipath: make directio checker
 share io contexts
Date: Tue, 11 Feb 2020 09:42:21 +0100
Message-ID: <2c4135621e915a436919b5c6c32acd2c8ef179e3.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-16-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-16-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> On systems with a large number of cores (>500), io_destroy() can take
> tens to hundreds of milliseconds to complete, due to RCU
> synchronization. If there are a large number of paths using the
> directio
> checker on such a system, this can lead to multipath taking almost a
> minute to complete, with the vast majority of time taken up by
> io_destroy().
> 
> To solve this, the directio checker now allocates one aio context for
> every 1024 checkers. This reduces the io_destroy() delay to a
> thousandth
> of its previous level. However, this means that muliple checkers are
> sharing the same aio context, and must be able to handle getting
> results
> for other checkers.  Because only one checker is ever running at a
> time, this doesn't require any locking.  However, locking could be
> added
> in the future if necessary, to allow multiple checkers to run at the
> same time.
> 
> When checkers are freed, they usually no longer destroy the io
> context.
> Instead, they attempt to cancel any outstanding request. If that
> fails,
> they put the request on an orphan list, so that it can be freed by
> other
> checkers, once it has completed. IO contexts are only destroyed at
> three
> times, during reconfigure (to deal with the possibility that
> multipathd
> is holding more aio events than it needs to be, since there is a
> single
> limit for the whole system), when the checker class is unloaded, and
> in a corner case when checkers are freed. If an aio_group (which
> contains the aio context) is entirely full of orphaned requests, then
> no checker can use it. Since no checker is using it, there is no
> checker
> to clear out the orphaned requests. In this (likely rare) case, the
> last checker from that group to be freed and leave behind an orphaned
> request will call io_destroy() and remove the group.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/checkers/directio.c | 336 +++++++++++++++++++++++++--
> ----
>  multipath/multipath.conf.5       |   7 +-
>  2 files changed, 281 insertions(+), 62 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>

(some minor nitpicks to be fixed in follow-up patch)
