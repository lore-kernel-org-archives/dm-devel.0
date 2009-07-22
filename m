From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 5/9] blkio-cgroup-v9: The body of blkio-cgroup
Date: Wed, 22 Jul 2009 11:11:20 +0900
Message-ID: <20090722111120.e4fe974f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090721.231004.226793074.ryov@valinux.co.jp>
	<20090721.231211.71098738.ryov@valinux.co.jp>
	<20090721.231313.104044139.ryov@valinux.co.jp>
	<20090721.231405.189716609.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755623AbZGVCNL@vger.kernel.org>
In-Reply-To: <20090721.231405.189716609.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, agk@redhat.com
List-Id: dm-devel.ids

On Tue, 21 Jul 2009 23:14:05 +0900 (JST)
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> The body of blkio-cgroup.
> + * blkio_cgroup_set_owner() - set the owner ID of a page.
> + * @page:	the page we want to tag
> + * @mm:		the mm_struct of a page owner
> + *
> + * Make a given page have the blkio-cgroup ID of the owner of this page.
> + */
> +void blkio_cgroup_set_owner(struct page *page, struct mm_struct *mm)


> + * blkio_cgroup_reset_owner() - reset the owner ID of a page
> + * @page:	the page we want to tag
> + * @mm:		the mm_struct of a page owner
> + *
> + * Change the owner of a given page if necessary.
> + */
> +void blkio_cgroup_reset_owner(struct page *page, struct mm_struct *mm)
> +{
> +	blkio_cgroup_set_owner(page, mm);
> +}


> +void blkio_cgroup_reset_owner_pagedirty(struct page *page, struct mm_struct *mm)
> +{
> +	if (!page_is_file_cache(page))
> +		return;
> +	if (current->flags & PF_MEMALLOC)
> +		return;
> +
> +	blkio_cgroup_reset_owner(page, mm);
> +}
> +

Hmm, why pass "mm" not "thread" ? Do we need to take care of mm->ownder ?
Why "current" is bad ?

Thanks,
-Kame
