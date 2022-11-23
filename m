Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E10C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 08:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669191968;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K3Kzle5f6pq013G906ZPr+i8QhqA4j7N8mw8IQG3UFs=;
	b=NIqufzPa0qYktGMasFZAfgamqBFybbOssCPdY0H4eV6sUbytxi03/WDsVeFpBjzgGlCHHU
	xnM5+d7xobJbh4KFq9xDCgpZq9dXAL8VAZpUJGOJT99Rb0n2cgoZeOndkJx4aPyMjLhybs
	L2nAlxWJ4kxAKVXqq0jPtKe7dpXRqzI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-5VxRSh0ROvOp3fP1FmYgww-1; Wed, 23 Nov 2022 03:26:05 -0500
X-MC-Unique: 5VxRSh0ROvOp3fP1FmYgww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1FAE85A588;
	Wed, 23 Nov 2022 08:26:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E08762166B38;
	Wed, 23 Nov 2022 08:26:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF0C319465BA;
	Wed, 23 Nov 2022 08:26:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 45AFE1946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 06:53:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3272F2024CC5; Wed, 23 Nov 2022 06:53:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2ABEE2024CBE
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:53:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 073DB3C0DDD8
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:53:29 +0000 (UTC)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com
 [209.85.217.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-316-uSRBmRfyM8SQYLqOXHe_jw-1; Wed, 23 Nov 2022 01:53:27 -0500
X-MC-Unique: uSRBmRfyM8SQYLqOXHe_jw-1
Received: by mail-vs1-f51.google.com with SMTP id q127so16625723vsa.7;
 Tue, 22 Nov 2022 22:53:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=zb+b/kQNpZ1iqoMRAgUR5SFjg/VsZKZLzWh53TxILaY=;
 b=elbogjW+jhfC3wRCVlUFWr7OxiV7QvJhJn6GfTm8UOkmblIFCkm1C3sdo4mUK2kWAb
 asuHIF0yBD7fs6C2U3ULRzGoScP4eTQmCp2YuM/U/Fk4CqakDhm+p830d5V7q5gTontm
 i38h5sMIPShKrJtdvS0jeRxpaJ12kwa7Pyeo29wyuHIz8a+iFzbZNhqHY0bpUqA6MAto
 mhMmJXXWFfD4pN1JkIK7SaQbU8cHt3rI/DUh42/PPxx+lyoh4WQJXdHNF1isM5v5teDa
 k9s39eRW1XvuawscqEXP/C14tU56l6bCui3ep5UEJgtfpvfSjHlmvGegyLvFmqToLcEV
 3Trg==
X-Gm-Message-State: ANoB5pm+6FurBfSpR9NH47lvN9nQhCjpFe6XpNyrmAXWBcbgtS/qubNI
 69izGcd0utuVcCpIQ36V6pUeeqrOI/FpS6kZxCE=
X-Google-Smtp-Source: AA0mqf55Qvs1RVFZgpUB9hHpNmee060lzqmCf3GfjJCl+IAQ8LG2Guwv4fTQaouwtHsAyvEWcII2JptzlFh9ndmXW3Q=
X-Received: by 2002:a67:f60d:0:b0:3b0:6bb1:3168 with SMTP id
 k13-20020a67f60d000000b003b06bb13168mr2537799vso.36.1669186406338; Tue, 22
 Nov 2022 22:53:26 -0800 (PST)
MIME-Version: 1.0
References: <CGME20221123061044epcas5p2ac082a91fc8197821f29e84278b6203c@epcas5p2.samsung.com>
 <20221123055827.26996-1-nj.shetty@samsung.com>
 <20221123055827.26996-11-nj.shetty@samsung.com>
In-Reply-To: <20221123055827.26996-11-nj.shetty@samsung.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 23 Nov 2022 08:53:14 +0200
Message-ID: <CAOQ4uxhMX9MF0+6DD7NO5QzqDRwESkhiY5f9CB7DXFVa22Za+w@mail.gmail.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 23 Nov 2022 08:25:56 +0000
Subject: Re: [dm-devel] [PATCH v5 10/10] fs: add support for copy file range
 in zonefs
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com, hch@lst.de,
 agk@redhat.com, naohiro.aota@wdc.com, sagi@grimberg.me, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, james.smart@broadcom.com,
 p.raghav@samsung.com, kch@nvidia.com, anuj20.g@samsung.com, snitzer@kernel.org,
 linux-block@vger.kernel.org, viro@zeniv.linux.org.uk, kbusch@kernel.org,
 axboe@kernel.dk, joshi.k@samsung.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jth@kernel.org, nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 23, 2022 at 8:26 AM Nitesh Shetty <nj.shetty@samsung.com> wrote:
>
> copy_file_range is implemented using copy offload,
> copy offloading to device is always enabled.
> To disable copy offloading mount with "no_copy_offload" mount option.
> At present copy offload is only used, if the source and destination files
> are on same block device, otherwise copy file range is completed by
> generic copy file range.
>
> copy file range implemented as following:
>         - write pending writes on the src and dest files
>         - drop page cache for dest file if its conv zone
>         - copy the range using offload
>         - update dest file info
>
> For all failure cases we fallback to generic file copy range
> At present this implementation does not support conv aggregation
>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/zonefs/super.c | 179 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 179 insertions(+)
>
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index abc9a85106f2..15613433d4ae 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -1223,6 +1223,183 @@ static int zonefs_file_release(struct inode *inode, struct file *file)
>         return 0;
>  }
>
> +static int zonefs_is_file_copy_offset_ok(struct inode *src_inode,
> +               struct inode *dst_inode, loff_t src_off, loff_t dst_off,
> +               size_t *len)
> +{
> +       loff_t size, endoff;
> +       struct zonefs_inode_info *dst_zi = ZONEFS_I(dst_inode);
> +
> +       inode_lock(src_inode);
> +       size = i_size_read(src_inode);
> +       inode_unlock(src_inode);
> +       /* Don't copy beyond source file EOF. */
> +       if (src_off < size) {
> +               if (src_off + *len > size)
> +                       *len = (size - (src_off + *len));
> +       } else
> +               *len = 0;
> +
> +       mutex_lock(&dst_zi->i_truncate_mutex);
> +       if (dst_zi->i_ztype == ZONEFS_ZTYPE_SEQ) {
> +               if (*len > dst_zi->i_max_size - dst_zi->i_wpoffset)
> +                       *len -= dst_zi->i_max_size - dst_zi->i_wpoffset;
> +
> +               if (dst_off != dst_zi->i_wpoffset)
> +                       goto err;
> +       }
> +       mutex_unlock(&dst_zi->i_truncate_mutex);
> +
> +       endoff = dst_off + *len;
> +       inode_lock(dst_inode);
> +       if (endoff > dst_zi->i_max_size ||
> +                       inode_newsize_ok(dst_inode, endoff)) {
> +               inode_unlock(dst_inode);
> +               goto err;
> +       }
> +       inode_unlock(dst_inode);
> +
> +       return 0;
> +err:
> +       mutex_unlock(&dst_zi->i_truncate_mutex);
> +       return -EINVAL;
> +}
> +
> +static ssize_t zonefs_issue_copy(struct zonefs_inode_info *src_zi,
> +               loff_t src_off, struct zonefs_inode_info *dst_zi,
> +               loff_t dst_off, size_t len)
> +{
> +       struct block_device *src_bdev = src_zi->i_vnode.i_sb->s_bdev;
> +       struct block_device *dst_bdev = dst_zi->i_vnode.i_sb->s_bdev;
> +       struct range_entry *rlist = NULL;
> +       int ret = len;
> +
> +       rlist = kmalloc(sizeof(*rlist), GFP_KERNEL);
> +       if (!rlist)
> +               return -ENOMEM;
> +
> +       rlist[0].dst = (dst_zi->i_zsector << SECTOR_SHIFT) + dst_off;
> +       rlist[0].src = (src_zi->i_zsector << SECTOR_SHIFT) + src_off;
> +       rlist[0].len = len;
> +       rlist[0].comp_len = 0;
> +       ret = blkdev_issue_copy(src_bdev, dst_bdev, rlist, 1, NULL, NULL,
> +                       GFP_KERNEL);
> +       if (rlist[0].comp_len > 0)
> +               ret = rlist[0].comp_len;
> +       kfree(rlist);
> +
> +       return ret;
> +}
> +
> +/* Returns length of possible copy, else returns error */
> +static ssize_t zonefs_copy_file_checks(struct file *src_file, loff_t src_off,
> +                                       struct file *dst_file, loff_t dst_off,
> +                                       size_t *len, unsigned int flags)
> +{
> +       struct inode *src_inode = file_inode(src_file);
> +       struct inode *dst_inode = file_inode(dst_file);
> +       struct zonefs_inode_info *src_zi = ZONEFS_I(src_inode);
> +       struct zonefs_inode_info *dst_zi = ZONEFS_I(dst_inode);
> +       ssize_t ret;
> +
> +       if (src_inode->i_sb != dst_inode->i_sb)
> +               return -EXDEV;
> +
> +       /* Start by sync'ing the source and destination files for conv zones */
> +       if (src_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +               ret = file_write_and_wait_range(src_file, src_off,
> +                               (src_off + *len));
> +               if (ret < 0)
> +                       goto io_error;
> +       }
> +       inode_dio_wait(src_inode);
> +
> +       /* Start by sync'ing the source and destination files ifor conv zones */
> +       if (dst_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +               ret = file_write_and_wait_range(dst_file, dst_off,
> +                               (dst_off + *len));
> +               if (ret < 0)
> +                       goto io_error;
> +       }
> +       inode_dio_wait(dst_inode);
> +
> +       /* Drop dst file cached pages for a conv zone*/
> +       if (dst_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +               ret = invalidate_inode_pages2_range(dst_inode->i_mapping,
> +                               dst_off >> PAGE_SHIFT,
> +                               (dst_off + *len) >> PAGE_SHIFT);
> +               if (ret < 0)
> +                       goto io_error;
> +       }
> +
> +       ret = zonefs_is_file_copy_offset_ok(src_inode, dst_inode, src_off,
> +                       dst_off, len);
> +       if (ret < 0)
> +               return ret;
> +
> +       return *len;
> +
> +io_error:
> +       zonefs_io_error(dst_inode, true);
> +       return ret;
> +}
> +
> +static ssize_t zonefs_copy_file(struct file *src_file, loff_t src_off,
> +               struct file *dst_file, loff_t dst_off,
> +               size_t len, unsigned int flags)
> +{
> +       struct inode *src_inode = file_inode(src_file);
> +       struct inode *dst_inode = file_inode(dst_file);
> +       struct zonefs_inode_info *src_zi = ZONEFS_I(src_inode);
> +       struct zonefs_inode_info *dst_zi = ZONEFS_I(dst_inode);
> +       ssize_t ret = 0, bytes;
> +
> +       inode_lock(src_inode);
> +       inode_lock(dst_inode);
> +       bytes = zonefs_issue_copy(src_zi, src_off, dst_zi, dst_off, len);
> +       if (bytes < 0)
> +               goto unlock_exit;
> +
> +       ret += bytes;
> +
> +       file_update_time(dst_file);
> +       mutex_lock(&dst_zi->i_truncate_mutex);
> +       zonefs_update_stats(dst_inode, dst_off + bytes);
> +       zonefs_i_size_write(dst_inode, dst_off + bytes);
> +       dst_zi->i_wpoffset += bytes;
> +       mutex_unlock(&dst_zi->i_truncate_mutex);
> +       /* if we still have some bytes left, do splice copy */
> +       if (bytes && (bytes < len)) {
> +               bytes = do_splice_direct(src_file, &src_off, dst_file,
> +                                        &dst_off, len, flags);
> +               if (bytes > 0)
> +                       ret += bytes;
> +       }
> +unlock_exit:
> +       if (ret < 0)
> +               zonefs_io_error(dst_inode, true);
> +       inode_unlock(src_inode);
> +       inode_unlock(dst_inode);
> +       return ret;
> +}
> +
> +static ssize_t zonefs_copy_file_range(struct file *src_file, loff_t src_off,
> +                                     struct file *dst_file, loff_t dst_off,
> +                                     size_t len, unsigned int flags)
> +{
> +       ssize_t ret = -EIO;
> +
> +       ret = zonefs_copy_file_checks(src_file, src_off, dst_file, dst_off,
> +                                    &len, flags);
> +       if (ret > 0)
> +               ret = zonefs_copy_file(src_file, src_off, dst_file, dst_off,
> +                                    len, flags);
> +       else if (ret < 0 && ret == -EXDEV)

First of all, ret < 0 is redundant.

> +               ret = generic_copy_file_range(src_file, src_off, dst_file,
> +                                             dst_off, len, flags);

But more importantly, why do you want to fall back to
do_splice_direct() in zonefs copy_file_range?
How does it serve your patch set or the prospect consumers
of zonefs copy_file_range?

The reason I am asking is because commit 5dae222a5ff0
("vfs: allow copy_file_range to copy across devices")
turned out to be an API mistake that was later reverted by
868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs copies")

It is always better to return EXDEV to userspace which can
always fallback to splice itself, but maybe it has something
smarter to do.

The places where it made sense for kernel to fallback to
direct splice was for network servers server-side-copy, but that
is independent of any specific filesystem copy_file_range()
implementation.

Thanks,
Amir.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

