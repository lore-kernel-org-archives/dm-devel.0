From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 07/10] idr: Rename idr_alloc() ->
	idr_alloc_range()
Date: Sat, 6 Jul 2013 05:26:08 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E4917268C93@PRN-MBX01-3.TheFacebook.com>
References: <1373087301-23730-8-git-send-email-kmo@daterainc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373087301-23730-8-git-send-email-kmo@daterainc.com>
Content-Language: en-US
Content-ID: <08CD1683A9D2B34AA655A5DD785F23F4@fb.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kmo@daterainc.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>, Linus Walleij <linus.walleij@linaro.org>, Paul Mackerras <paulus@samba.org>, Christoph Hellwig <hch@lst.de>, Alon Levy <alevy@redhat.com>, Jason Wang <jasowang@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>, "John W. Linville" <linville@tuxdriver.com>, Inki Dae <inki.dae@samsung.com>, Alex Williamson <alex.williamson@redhat.com>, David Teigland <teigland@redhat.com>, Joel Becker <jlbec@evilplan.org>, Tim Gardner <tim.gardner@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Seung-Woo Kim <sw0312.kim@samsung.com>, Li Zefan <lizefan@huawei.com>, "tj@kernel.org" <tj@kernel.org>, Guo Chao <yan@linux.vnet.ibm.com>, Andy Grover <agrover@redhat.com>, Dmitry Torokhov <dtor@vmware.com>
List-Id: dm-devel.ids



On 7/5/13 10:08 PM, "Kent Overstreet" <kmo@daterainc.com> wrote:

>From: Kent Overstreet <koverstreet@google.com>
>
>Then also add an idr_alloc() wrapper, without the start/end arguments -
>for consistency with the ida interfaces.
>
>Signed-off-by: Kent Overstreet <koverstreet@google.com>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Tejun Heo <tj@kernel.org>
>Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>Cc: Jens Axboe <axboe@kernel.dk>
>Cc: Chas Williams <chas@cmf.nrl.navy.mil>
>Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
>Cc: Dan Williams <djbw@fb.com>
[..]
>diff --git a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
>index 126cf29..effda66 100644
>--- a/drivers/dca/dca-sysfs.c
>+++ b/drivers/dca/dca-sysfs.c
>@@ -58,7 +58,7 @@ int dca_sysfs_add_provider(struct dca_provider *dca,
>struct device *dev)
> 	idr_preload(GFP_KERNEL);
> 	spin_lock(&dca_idr_lock);
> 
>-	ret = idr_alloc(&dca_idr, dca, 0, 0, GFP_NOWAIT);
>+	ret = idr_alloc(&dca_idr, dca, GFP_NOWAIT);
> 	if (ret >= 0)
> 		dca->id = ret;

DCA portion Acked-by: Dan Williams <djbw@fb.com>
