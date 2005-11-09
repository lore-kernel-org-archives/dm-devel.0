From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: memory leak in failed table_load()
Date: Wed, 9 Nov 2005 22:48:08 +0000
Message-ID: <20051109224808.GE26394@agk.surrey.redhat.com>
References: <20051109.170732.41627574.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051109.170732.41627574.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Nov 09, 2005 at 05:07:32PM -0500, Kiyoshi Ueda wrote:
> @@ -974,6 +974,7 @@ static int table_load(struct dm_ioctl *p
>  	if (!hc) {
>  		DMWARN("device doesn't appear to be in the dev hash table.");
>  		up_write(&_hash_lock);
> +		dm_table_put(t);
>  		return -ENXIO;

Well spotted!

Added to dev patchset and will push alongside with some other stuff in a 
few days' time.
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-ioctl-missing-put-in-table-load-error-case.patch

Alasdair
-- 
agk@redhat.com
