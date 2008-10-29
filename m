From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/9] dm snapshot: add
	lookup_completed_exception hook to struct exception_store
Date: Wed, 29 Oct 2008 23:52:34 +0000
Message-ID: <20081029235234.GN31233@agk.fab.redhat.com>
References: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1225109276-16491-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 27, 2008 at 09:07:49PM +0900, FUJITA Tomonori wrote:
> +struct dm_snap_exception *lookup_complete_exception(struct dm_snapshot *s,
> +						    chunk_t chunk)
> +{
> +	if (s->store.lookup_completed_exception)
> +		return s->store.lookup_completed_exception(&s->store, chunk);
> +	else
> +		return lookup_exception(&s->complete, chunk);
> +}

Can we have symmetry here such that lookup_completed_exception is *required* to be
defined for all snapshot types?

Alasdair
-- 
agk@redhat.com
