From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH 4/7] blkio-cgroup: The body of blkio-cgroup
Date: Mon, 4 May 2009 14:05:45 +0200
Message-ID: <20090504120544.GA3986@linux>
References: <20090428.214423.193684619.ryov@valinux.co.jp>
	<20090428.214457.226801820.ryov@valinux.co.jp>
	<20090428.214535.71090234.ryov@valinux.co.jp>
	<20090428.214604.104034341.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090428.214604.104034341.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

On Tue, Apr 28, 2009 at 09:46:04PM +0900, Ryo Tsuruta wrote:
> The body of bio-cgroup.
> 
> Based on 2.6.30-rc3-git3
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

Hi Ryo,

few minor coding style issues reported by checkpatch.pl:

WARNING: line over 80 characters
#138: FILE: include/linux/biotrack.h:67:
+static inline void blkio_cgroup_set_owner(struct page *page, struct mm_struct *mm)

WARNING: line over 80 characters
#152: FILE: include/linux/biotrack.h:81:
+static inline void blkio_cgroup_copy_owner(struct page *page, struct page *opage)

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#513: FILE: mm/biotrack.c:265:
+EXPORT_SYMBOL(get_blkio_cgroup_id);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#514: FILE: mm/biotrack.c:266:
+EXPORT_SYMBOL(blkio_cgroup_lookup);

total: 0 errors, 4 warnings, 515 lines checked

-Andrea
