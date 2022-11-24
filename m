Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25614C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 24 Nov 2022 01:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669253608;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Vy4RoRkgNpD10mxtknib3n9Djkas3XwMhr35cEhDiTg=;
	b=GrQ0JZCtb0srRpyTWtgip2vA6+7jqLCo2ajBZz10oWY5+PgqLcqkhWzsSDfQKb7jUvTm7U
	K3gokMt0Ur5otp1CUck/kJwD88cvMyMAnE/RuKiKk33ad1HJ6ED47m1/lTc7TCv04ZMoAN
	8l9x4aFddUUXZo7SrZtTJmokZKVeiQw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-S38ZcYLBNayk-bC6qWqKdQ-1; Wed, 23 Nov 2022 20:33:24 -0500
X-MC-Unique: S38ZcYLBNayk-bC6qWqKdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25C3E3C0D84B;
	Thu, 24 Nov 2022 01:33:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6DF0B2024CBE;
	Thu, 24 Nov 2022 01:33:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D33E1946589;
	Thu, 24 Nov 2022 01:33:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 78BFD1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Nov 2022 01:33:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4915E4EA5C; Thu, 24 Nov 2022 01:33:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40D7B4EA55
 for <dm-devel@redhat.com>; Thu, 24 Nov 2022 01:33:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CD89811E67
 for <dm-devel@redhat.com>; Thu, 24 Nov 2022 01:33:19 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-gISPUZkKPaWMG5abju7yxg-2; Wed, 23 Nov 2022 20:33:17 -0500
X-MC-Unique: gISPUZkKPaWMG5abju7yxg-2
X-IronPort-AV: E=Sophos;i="5.96,189,1665417600"; d="scan'208";a="217040645"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2022 09:32:12 +0800
IronPort-SDR: HDldzPxukqIikjsrCi8CCj+hdEiZgL1CGUl3YQ3poQBa6CzuA2b/aWMfmEuPDFe3xsYvCIDTV+
 s+V8tULw967lRO0F5chOtYS33c+VoyZx1fv3BhyBZ87/ggoDeRm4e2jTKiW4tQBIOzzswN7kKz
 /zVtZjQULREFfwZITCP5k1cOvujZVsbsp22yWtYAhB3UDsFXzIimnW/sZGb3XWCjrjF2kmdoDr
 4FeFOOduDIF9bXPNgrDyhkLXPVJEgygEJC1wKhc3/wJKcfEKaqZltvLLKB3/bpwTqEA4ye0PA5
 ATU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 23 Nov 2022 16:45:14 -0800
IronPort-SDR: NPmmFYtpLyZ2UmJaOxPDTy+Oo7tZgEaGTXiHUnQWkYQGOYYsv+/SdW8t3vnLg56/k8ukbyV72m
 FFr/h5H7UFzvoa+3WQl34oBN151c9kqGIlwik4E/knobklYrRYUrBekp3fa2R7ZRzMUqAPMfhN
 9KA32LUFe1ZhavZNWIarExRFp0o7t5lzHglleR8YMUM3I/+S1jByYFTXM5pXIy3BM2+1cw2+ve
 GblCSaiX78pncmy5EANxGIPv7K6lzaQ+cErEU6SQWicC4hWRazuszHrc2tKo9EVWvpd4lA7X+8
 /U8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 23 Nov 2022 17:32:12 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NHgTR6qMfz1RwqL
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 17:32:11 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id z4AnolEvLUrB for <dm-devel@redhat.com>;
 Wed, 23 Nov 2022 17:32:09 -0800 (PST)
Received: from [10.225.163.55] (unknown [10.225.163.55])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NHgTL2TNbz1RvLy;
 Wed, 23 Nov 2022 17:32:06 -0800 (PST)
Message-ID: <729254f8-2468-e694-715e-72bcbef80ff3@opensource.wdc.com>
Date: Thu, 24 Nov 2022 10:32:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Nitesh Shetty <nj.shetty@samsung.com>, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, james.smart@broadcom.com, kch@nvidia.com,
 naohiro.aota@wdc.com, jth@kernel.org, viro@zeniv.linux.org.uk
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061044epcas5p2ac082a91fc8197821f29e84278b6203c@epcas5p2.samsung.com>
 <20221123055827.26996-11-nj.shetty@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221123055827.26996-11-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
Cc: p.raghav@samsung.com, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/23/22 14:58, Nitesh Shetty wrote:
> copy_file_range is implemented using copy offload,
> copy offloading to device is always enabled.
> To disable copy offloading mount with "no_copy_offload" mount option.

And were is the code that handle this option ?

> At present copy offload is only used, if the source and destination files
> are on same block device, otherwise copy file range is completed by
> generic copy file range.
> 
> copy file range implemented as following:
> 	- write pending writes on the src and dest files
> 	- drop page cache for dest file if its conv zone
> 	- copy the range using offload
> 	- update dest file info
> 
> For all failure cases we fallback to generic file copy range

For all cases ? That would be weird. What would be the point of trying to
copy again if e.g. the dest zone has gone offline or read only ?

> At present this implementation does not support conv aggregation

Please check this commit message overall: the grammar and punctuation
could really be improved.

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
>  	return 0;
>  }
>  
> +static int zonefs_is_file_copy_offset_ok(struct inode *src_inode,
> +		struct inode *dst_inode, loff_t src_off, loff_t dst_off,
> +		size_t *len)
> +{
> +	loff_t size, endoff;
> +	struct zonefs_inode_info *dst_zi = ZONEFS_I(dst_inode);
> +
> +	inode_lock(src_inode);
> +	size = i_size_read(src_inode);
> +	inode_unlock(src_inode);
> +	/* Don't copy beyond source file EOF. */
> +	if (src_off < size) {
> +		if (src_off + *len > size)
> +			*len = (size - (src_off + *len));
> +	} else
> +		*len = 0;

Missing curly brackets for the else.

> +
> +	mutex_lock(&dst_zi->i_truncate_mutex);
> +	if (dst_zi->i_ztype == ZONEFS_ZTYPE_SEQ) {
> +		if (*len > dst_zi->i_max_size - dst_zi->i_wpoffset)
> +			*len -= dst_zi->i_max_size - dst_zi->i_wpoffset;
> +
> +		if (dst_off != dst_zi->i_wpoffset)
> +			goto err;
> +	}
> +	mutex_unlock(&dst_zi->i_truncate_mutex);
> +
> +	endoff = dst_off + *len;
> +	inode_lock(dst_inode);
> +	if (endoff > dst_zi->i_max_size ||
> +			inode_newsize_ok(dst_inode, endoff)) {
> +		inode_unlock(dst_inode);
> +		goto err;

And here truncate mutex is not locked, but goto err will unlock it. This
is broken...

> +	}
> +	inode_unlock(dst_inode);

...The locking is completely broken in this function anyway. You take the
lock, look at something, then release the lock. Then what if a write or a
trunctate comes in when the inode is not locked ? This is completely
broken. The inode should be locked with no dio pending when this function
is called. This is only to check if everything is ok. This has no business
playing with the inode and truncate locks.

> +
> +	return 0;
> +err:
> +	mutex_unlock(&dst_zi->i_truncate_mutex);
> +	return -EINVAL;
> +}
> +
> +static ssize_t zonefs_issue_copy(struct zonefs_inode_info *src_zi,
> +		loff_t src_off, struct zonefs_inode_info *dst_zi,
> +		loff_t dst_off, size_t len)
> +{
> +	struct block_device *src_bdev = src_zi->i_vnode.i_sb->s_bdev;
> +	struct block_device *dst_bdev = dst_zi->i_vnode.i_sb->s_bdev;
> +	struct range_entry *rlist = NULL;
> +	int ret = len;
> +
> +	rlist = kmalloc(sizeof(*rlist), GFP_KERNEL);

GFP_NOIO ?

> +	if (!rlist)
> +		return -ENOMEM;
> +
> +	rlist[0].dst = (dst_zi->i_zsector << SECTOR_SHIFT) + dst_off;
> +	rlist[0].src = (src_zi->i_zsector << SECTOR_SHIFT) + src_off;
> +	rlist[0].len = len;
> +	rlist[0].comp_len = 0;
> +	ret = blkdev_issue_copy(src_bdev, dst_bdev, rlist, 1, NULL, NULL,
> +			GFP_KERNEL);
> +	if (rlist[0].comp_len > 0)
> +		ret = rlist[0].comp_len;
> +	kfree(rlist);
> +
> +	return ret;
> +}
> +
> +/* Returns length of possible copy, else returns error */
> +static ssize_t zonefs_copy_file_checks(struct file *src_file, loff_t src_off,
> +					struct file *dst_file, loff_t dst_off,
> +					size_t *len, unsigned int flags)
> +{
> +	struct inode *src_inode = file_inode(src_file);
> +	struct inode *dst_inode = file_inode(dst_file);
> +	struct zonefs_inode_info *src_zi = ZONEFS_I(src_inode);
> +	struct zonefs_inode_info *dst_zi = ZONEFS_I(dst_inode);
> +	ssize_t ret;
> +
> +	if (src_inode->i_sb != dst_inode->i_sb)
> +		return -EXDEV;
> +
> +	/* Start by sync'ing the source and destination files for conv zones */
> +	if (src_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +		ret = file_write_and_wait_range(src_file, src_off,
> +				(src_off + *len));
> +		if (ret < 0)
> +			goto io_error;
> +	}
> +	inode_dio_wait(src_inode);

That is not a "check". So having this in a function called
zonefs_copy_file_checks() is a little strange.

> +
> +	/* Start by sync'ing the source and destination files ifor conv zones */

Same comment repeated, with typos.

> +	if (dst_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +		ret = file_write_and_wait_range(dst_file, dst_off,
> +				(dst_off + *len));
> +		if (ret < 0)
> +			goto io_error;
> +	}
> +	inode_dio_wait(dst_inode);
> +
> +	/* Drop dst file cached pages for a conv zone*/
> +	if (dst_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +		ret = invalidate_inode_pages2_range(dst_inode->i_mapping,
> +				dst_off >> PAGE_SHIFT,
> +				(dst_off + *len) >> PAGE_SHIFT);
> +		if (ret < 0)
> +			goto io_error;
> +	}
> +
> +	ret = zonefs_is_file_copy_offset_ok(src_inode, dst_inode, src_off,
> +			dst_off, len);
> +	if (ret < 0)

if (ret)

> +		return ret;
> +
> +	return *len;
> +
> +io_error:
> +	zonefs_io_error(dst_inode, true);
> +	return ret;
> +}
> +
> +static ssize_t zonefs_copy_file(struct file *src_file, loff_t src_off,
> +		struct file *dst_file, loff_t dst_off,
> +		size_t len, unsigned int flags)
> +{
> +	struct inode *src_inode = file_inode(src_file);
> +	struct inode *dst_inode = file_inode(dst_file);
> +	struct zonefs_inode_info *src_zi = ZONEFS_I(src_inode);
> +	struct zonefs_inode_info *dst_zi = ZONEFS_I(dst_inode);
> +	ssize_t ret = 0, bytes;
> +
> +	inode_lock(src_inode);
> +	inode_lock(dst_inode);

So you did zonefs_copy_file_checks() outside of these locks, which mean
that everything about the source and destination files may have changed.
This does not work.

> +	bytes = zonefs_issue_copy(src_zi, src_off, dst_zi, dst_off, len);
> +	if (bytes < 0)
> +		goto unlock_exit;
> +
> +	ret += bytes;
> +
> +	file_update_time(dst_file);
> +	mutex_lock(&dst_zi->i_truncate_mutex);
> +	zonefs_update_stats(dst_inode, dst_off + bytes);
> +	zonefs_i_size_write(dst_inode, dst_off + bytes);
> +	dst_zi->i_wpoffset += bytes;

This is wierd. iszie for dst will be dst_zi->i_wpoffset. So please do:

	dst_zi->i_wpoffset += bytes;
	zonefs_i_size_write(dst_inode, dst_zi->i_wpoffset);

> +	mutex_unlock(&dst_zi->i_truncate_mutex);

And you are not taking care of the accounting for active zones here. If
the copy made the dst zone full, it is not active anymore. You need to
call zonefs_account_active();

> +	/* if we still have some bytes left, do splice copy */
> +	if (bytes && (bytes < len)) {
> +		bytes = do_splice_direct(src_file, &src_off, dst_file,
> +					 &dst_off, len, flags);

No way.

> +		if (bytes > 0)
> +			ret += bytes;
> +	}
> +unlock_exit:
> +	if (ret < 0)
> +		zonefs_io_error(dst_inode, true);

How can you be sure that you even did an IO when you get an error ?
zonefs_issue_copy() may have failed on its kmalloc() and no IO was done.

> +	inode_unlock(src_inode);
> +	inode_unlock(dst_inode);
> +	return ret;
> +}
> +
> +static ssize_t zonefs_copy_file_range(struct file *src_file, loff_t src_off,
> +				      struct file *dst_file, loff_t dst_off,
> +				      size_t len, unsigned int flags)
> +{
> +	ssize_t ret = -EIO;

This does not need to be initialized.

> +
> +	ret = zonefs_copy_file_checks(src_file, src_off, dst_file, dst_off,
> +				     &len, flags);

These checks need to be done for the generic implementation too, no ? Why
would checking this automatically trigger the offload ? What if the device
does not support offloading ?

> +	if (ret > 0)
> +		ret = zonefs_copy_file(src_file, src_off, dst_file, dst_off,
> +				     len, flags);

return here, then no need for the else. But see above. This seems all
broken to me.

> +	else if (ret < 0 && ret == -EXDEV)
> +		ret = generic_copy_file_range(src_file, src_off, dst_file,
> +					      dst_off, len, flags);
> +	return ret;
> +}
> +
>  static const struct file_operations zonefs_file_operations = {
>  	.open		= zonefs_file_open,
>  	.release	= zonefs_file_release,
> @@ -1234,6 +1411,7 @@ static const struct file_operations zonefs_file_operations = {
>  	.splice_read	= generic_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.iopoll		= iocb_bio_iopoll,
> +	.copy_file_range = zonefs_copy_file_range,
>  };
>  
>  static struct kmem_cache *zonefs_inode_cachep;
> @@ -1804,6 +1982,7 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	atomic_set(&sbi->s_active_seq_files, 0);
>  	sbi->s_max_active_seq_files = bdev_max_active_zones(sb->s_bdev);
>  
> +	/* set copy support by default */

What is this comment supposed to be for ?

>  	ret = zonefs_read_super(sb);
>  	if (ret)
>  		return ret;

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

