From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm ioctl: fix hang in early create error condition
Date: Mon, 13 May 2019 21:37:16 -0400
Message-ID: <20190514013716.GA10260@lobo>
References: <20190513192530.1167-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190513192530.1167-1-helen.koike@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Helen Koike <helen.koike@collabora.com>
Cc: dm-devel@redhat.com, kernel@collabora.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, May 13 2019 at  3:25P -0400,
Helen Koike <helen.koike@collabora.com> wrote:

> The dm_early_create() function (which deals with "dm-mod.create=" kernel
> command line option) calls dm_hash_insert() who gets an extra reference
> to the md object.
> 
> In case of failure, this reference wasn't being released, causing
> dm_destroy() to hang, thus hanging the whole boot process.
> 
> Fix this by calling __hash_remove() in the error path.
> 
> Fixes: 6bbc923dfcf57d ("dm: add support to directly boot to a mapped device")
> Cc: stable@vger.kernel.org
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> Hi,
> 
> I tested this patch by adding a new test case in the following test
> script:
> 
> https://gitlab.collabora.com/koike/dm-cmdline-test/commit/d2d7a0ee4a49931cdb59f08a837b516c2d5d743d
> 
> This test was failing, but with this patch it works correctly.
> 
> Thanks
> Helen

Thanks for the patch but I'd prefer the following simpler fix.  What do
you think?

That said, I can provide a follow-on patch (inspired by the patch you
provided) that encourages more code sharing between dm_early_create()
and dev_create() by factoring out __dev_create().

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c740153b4e52..0eb0b462c736 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2117,6 +2117,7 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 err_destroy_table:
 	dm_table_destroy(t);
 err_destroy_dm:
+	(void) __hash_remove(__find_device_hash_cell(dmi));
 	dm_put(md);
 	dm_destroy(md);
 	return r;
