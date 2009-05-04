From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 4/7] blkio-cgroup: The body of blkio-cgroup
Date: Tue, 05 May 2009 07:43:58 +0900 (JST)
Message-ID: <20090505.074358.226774631.ryov@valinux.co.jp>
References: <20090428.214535.71090234.ryov@valinux.co.jp>
	<20090428.214604.104034341.ryov@valinux.co.jp>
	<20090504120544.GA3986@linux>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20090504120544.GA3986@linux>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: righi.andrea@gmail.com
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

Hi Andrea,

From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH 4/7] blkio-cgroup: The body of blkio-cgroup
Date: Mon, 4 May 2009 14:05:45 +0200

> On Tue, Apr 28, 2009 at 09:46:04PM +0900, Ryo Tsuruta wrote:
> > The body of bio-cgroup.
> > 
> > Based on 2.6.30-rc3-git3
> > Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> > Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> 
> Hi Ryo,
> 
> few minor coding style issues reported by checkpatch.pl:

Thanks for reporting these issues. I'll fix them in the next release.

> 
> WARNING: line over 80 characters
> #138: FILE: include/linux/biotrack.h:67:
> +static inline void blkio_cgroup_set_owner(struct page *page, struct mm_struct *mm)
> 
> WARNING: line over 80 characters
> #152: FILE: include/linux/biotrack.h:81:
> +static inline void blkio_cgroup_copy_owner(struct page *page, struct page *opage)
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #513: FILE: mm/biotrack.c:265:
> +EXPORT_SYMBOL(get_blkio_cgroup_id);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #514: FILE: mm/biotrack.c:266:
> +EXPORT_SYMBOL(blkio_cgroup_lookup);
> 
> total: 0 errors, 4 warnings, 515 lines checked
> 
> -Andrea

Thanks,
Ryo Tsuruta
