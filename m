Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF876C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 01:42:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-uTd3IBG1NWuGXJZPDesGaw-1; Tue, 26 Apr 2022 21:42:27 -0400
X-MC-Unique: uTd3IBG1NWuGXJZPDesGaw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB295811E80;
	Wed, 27 Apr 2022 01:42:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 731789E6F;
	Wed, 27 Apr 2022 01:42:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CAC21947BBE;
	Wed, 27 Apr 2022 01:42:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A67CA19451F0
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 01:42:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 90BAC4047D29; Wed, 27 Apr 2022 01:42:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C10640D282D
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 01:42:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D401380664C
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 01:42:22 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-kz7UV7nUNHaOXC9zAjnpdQ-2; Tue, 26 Apr 2022 21:42:19 -0400
X-MC-Unique: kz7UV7nUNHaOXC9zAjnpdQ-2
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; d="scan'208";a="203779651"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 09:42:18 +0800
IronPort-SDR: 5GtFsMDCVgOuG0++X+BPHAA1e6C08eVmpIU29FvtT/stLTEx4aDCmur9wHZvRZxsdMP7xhSOKT
 +Lhi4UbyC+Wd7gnb25M/H+V9HLTpk56NUcZwJWjGzOhRy51cRVdeC4p4yH/oIQh+MWlIu3IXy5
 orywRov95eB62hUvL6amBF4DgGmetFP7GwTpfR7OmooIYMMXf5Op2sKv5q9iCdmJqSMd43WYAQ
 HJcBq8y0ANMH+NNyfOmKYdDPLhILOdqkhY1zLv69D/dkyS9OihjJXomL2SuG8vENVDq2UZOdA2
 6GKGH1bK+koIw9CehJyXkvnJ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 18:12:29 -0700
IronPort-SDR: ehLfjv4KtZKirehtq/PzDv34xEhH3XISN6S4mShSxyPhMaM7608qGxLiZMVYAZ1aUmo8Q9xCbH
 TWhMJmFs59LHMnBQih1QladjIhnqQsacox5VnNjdAJfNie8wyINLkpehwE6BJPOTU+qQ+sPnn+
 9J0dI+WN/+FlugRiWKzZ6hlHuHkweIByD4wr8iOXdwJmzAylcoOGxuu6io/5mmyYjVORIYkTAR
 U2EwDTy7W+T05JRefWfFeoHQ2ISyv88HFfFWeFzXDUfO42reMDndNst4xlSZbJDmXSM1qo42TM
 hdA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 18:42:19 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kp1hV2YLfz1Rvlx
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 18:42:18 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id UmKdhEhXaRX0 for <dm-devel@redhat.com>;
 Tue, 26 Apr 2022 18:42:15 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kp1hK3pPvz1Rvlc;
 Tue, 26 Apr 2022 18:42:09 -0700 (PDT)
Message-ID: <ab926e49-1fe6-fe10-2377-079268bc2d44@opensource.wdc.com>
Date: Wed, 27 Apr 2022 10:42:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426102042epcas5p201aa0d9143d7bc650ae7858383b69288@epcas5p2.samsung.com>
 <20220426101241.30100-11-nj.shetty@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220426101241.30100-11-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v4 10/10] fs: add support for copy file range
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
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, msnitzer@redhat.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 josef@toxicpanda.com, linux-block@vger.kernel.org, dsterba@suse.com,
 kbusch@kernel.org, Frederick.Knight@netapp.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, Arnav Dawn <arnav.dawn@samsung.com>,
 jack@suse.com, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/26/22 19:12, Nitesh Shetty wrote:
> From: Arnav Dawn <arnav.dawn@samsung.com>
> 
> copy_file_range is implemented using copy offload,
> copy offloading to device is always enabled.
> To disable copy offloading mount with "no_copy_offload" mount option.
> At present copy offload is only used, if the source and destination files
> are on same block device, otherwise copy file range is completed by
> generic copy file range.

Why not integrate copy offload inside generic_copy_file_range() ?

> 
> copy file range implemented as following:
> 	- write pending writes on the src and dest files
> 	- drop page cache for dest file if its conv zone
> 	- copy the range using offload
> 	- update dest file info
> 
> For all failure cases we fallback to generic file copy range
> At present this implementation does not support conv aggregation
> 
> Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
> ---
>  fs/zonefs/super.c  | 178 ++++++++++++++++++++++++++++++++++++++++++++-
>  fs/zonefs/zonefs.h |   1 +
>  2 files changed, 178 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index b3b0b71fdf6c..60563b592bf2 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -901,6 +901,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
>  	else
>  		ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
>  				   &zonefs_write_dio_ops, 0, 0);
> +

Unnecessary white line change.

>  	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
>  	    (ret > 0 || ret == -EIOCBQUEUED)) {
>  		if (ret > 0)
> @@ -1189,6 +1190,171 @@ static int zonefs_file_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> +static int zonefs_is_file_size_ok(struct inode *src_inode, struct inode *dst_inode,
> +			   loff_t src_off, loff_t dst_off, size_t len)

This function is badly named. It is not checking if the size of files is
OK, is is checking if the copy offsets are OK.

> +{
> +	loff_t size, endoff;
> +
> +	size = i_size_read(src_inode);
> +	/* Don't copy beyond source file EOF. */
> +	if (src_off + len > size) {
> +		zonefs_err(src_inode->i_sb, "Copy beyond EOF (%llu + %zu > %llu)\n",
> +		     src_off, len, size);
> +		return -EOPNOTSUPP;

Reading beyond EOF returns 0, not an error, for any FS, including zonefs.
So why return an error here ?

> +	}
> +
> +	endoff = dst_off + len;
> +	if (inode_newsize_ok(dst_inode, endoff))
> +		return -EOPNOTSUPP;

This is not EOPNOTSUPP. This is EINVAL since the user is asking for
something that we know will fail due to the unaligned destination.

Furthermore, this code does not consider the zone type for the file. Since
the dest file could be a an aggregated conventional zone file which is
larger than a sequential zone file, this is not using the right limit.
This must be checked against i_max_size of struct zonefs_inode_info.

Note that inode_newsize_ok() must be called with inode->i_mutex held but
you never took that lock.

Also, the dest file could be a conventional zone file used for swap. And
you are not checking that. You have plenty of other checks missing. See
generic_copy_file_checks(). Calling that function should be fine for
zonefs too.

> +
> +
> +	return 0;
> +}
> +static ssize_t __zonefs_send_copy(struct zonefs_inode_info *src_zi, loff_t src_off,
> +				struct zonefs_inode_info *dst_zi, loff_t dst_off, size_t len)

Please rename this zonefs_issue_copy().

> +{
> +	struct block_device *src_bdev = src_zi->i_vnode.i_sb->s_bdev;
> +	struct block_device *dst_bdev = dst_zi->i_vnode.i_sb->s_bdev;
> +	struct range_entry *rlist;
> +	int ret = -EIO;

Initializing ret is not needed.

> +
> +	rlist = kmalloc(sizeof(*rlist), GFP_KERNEL);

No NULL check ?

> +	rlist[0].dst = (dst_zi->i_zsector << SECTOR_SHIFT) + dst_off;
> +	rlist[0].src = (src_zi->i_zsector << SECTOR_SHIFT) + src_off;
> +	rlist[0].len = len;
> +	rlist[0].comp_len = 0;
> +	ret = blkdev_issue_copy(src_bdev, 1, rlist, dst_bdev, GFP_KERNEL);
> +	if (ret) {
> +		if (rlist[0].comp_len != len) {

Pack this condition with the previous if using &&.

> +			ret = rlist[0].comp_len;
> +			kfree(rlist);
> +			return ret;

These 2 lines are not needed, the same is done below.

> +		}
> +	}
> +	kfree(rlist);
> +	return len;

And how do you handle this failing ? Where is zonefs_io_error() called ?
Without a call to that function, there is no way to guarantee that the
destination file state is still in sync with the zone state. This can fail
for all sorts of reasons (e.g. zone went offline), and that needs to be
checked.

> +}
> +static ssize_t __zonefs_copy_file_range(struct file *src_file, loff_t src_off,
> +				      struct file *dst_file, loff_t dst_off,
> +				      size_t len, unsigned int flags)
> +{
> +	struct inode *src_inode = file_inode(src_file);
> +	struct inode *dst_inode = file_inode(dst_file);
> +	struct zonefs_inode_info *src_zi = ZONEFS_I(src_inode);
> +	struct zonefs_inode_info *dst_zi = ZONEFS_I(dst_inode);
> +	struct block_device *src_bdev = src_inode->i_sb->s_bdev;
> +	struct block_device *dst_bdev = dst_inode->i_sb->s_bdev;
> +	struct super_block *src_sb = src_inode->i_sb;
> +	struct zonefs_sb_info *src_sbi = ZONEFS_SB(src_sb);
> +	struct super_block *dst_sb = dst_inode->i_sb;
> +	struct zonefs_sb_info *dst_sbi = ZONEFS_SB(dst_sb);
> +	ssize_t ret = -EIO, bytes;
> +
> +	if (src_bdev != dst_bdev) {
> +		zonefs_err(src_sb, "Copying files across two devices\n");
> +			return -EXDEV;

Weird indentation. And the error message is not needed.
The test can also be simplified to

if (src_inode->i_sb != dst_inode->i_sb)

> +	}
> +
> +	/*
> +	 * Some of the checks below will return -EOPNOTSUPP,
> +	 * which will force a generic copy
> +	 */
> +
> +	if (!(src_sbi->s_mount_opts & ZONEFS_MNTOPT_COPY_FILE)
> +		|| !(dst_sbi->s_mount_opts & ZONEFS_MNTOPT_COPY_FILE))
> +		return -EOPNOTSUPP;

I do not see the point of having this option. See below.

> +
> +	/* Start by sync'ing the source and destination files ifor conv zones */
> +	if (src_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +		ret = file_write_and_wait_range(src_file, src_off, (src_off + len));
> +		if (ret < 0) {
> +			zonefs_err(src_sb, "failed to write source file (%zd)\n", ret);
> +			goto out;
> +		}
> +	}
> +	if (dst_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +		ret = file_write_and_wait_range(dst_file, dst_off, (dst_off + len));
> +		if (ret < 0) {
> +			zonefs_err(dst_sb, "failed to write destination file (%zd)\n", ret);
> +			goto out;
> +		}
> +	}

And what about inode_dio_wait() for sequential dst file ? Not needed ?

> +	mutex_lock(&dst_zi->i_truncate_mutex);
> +	if (len > dst_zi->i_max_size - dst_zi->i_wpoffset) {
> +		/* Adjust length */
> +		len -= dst_zi->i_max_size - dst_zi->i_wpoffset;
> +		if (len <= 0) {
> +			mutex_unlock(&dst_zi->i_truncate_mutex);
> +			return -EOPNOTSUPP;

If len is 0, return 0.

> +		}
> +	}
> +	if (dst_off != dst_zi->i_wpoffset) {
> +		mutex_unlock(&dst_zi->i_truncate_mutex);
> +		return -EOPNOTSUPP; /* copy not at zone write ptr */

This must be an EINVAL. See zonefs_file_dio_write().
The condition is also invalid since the file can be a conventional zone
file which allows to write anywhere. Did you really test this code properly ?

> +	}
> +	mutex_lock(&src_zi->i_truncate_mutex);
> +	ret = zonefs_is_file_size_ok(src_inode, dst_inode, src_off, dst_off, len);
> +	if (ret < 0) {
> +		mutex_unlock(&src_zi->i_truncate_mutex);
> +		mutex_unlock(&dst_zi->i_truncate_mutex);
> +		goto out;
> +	}
> +	mutex_unlock(&src_zi->i_truncate_mutex);
> +
> +	/* Drop dst file cached pages for a conv zone*/
> +	if (dst_zi->i_ztype == ZONEFS_ZTYPE_CNV) {
> +		ret = invalidate_inode_pages2_range(dst_inode->i_mapping,
> +						    dst_off >> PAGE_SHIFT,
> +						    (dst_off + len) >> PAGE_SHIFT);
> +		if (ret < 0) {
> +			zonefs_err(dst_sb, "Failed to invalidate inode pages (%zd)\n", ret);
> +			ret = 0;

And you still go on ? That will corrupt data. No way. This error must be
returned to fail the copy.

> +		}
> +	}
> +	bytes = __zonefs_send_copy(src_zi, src_off, dst_zi, dst_off, len);
> +	ret += bytes;

You cannot hold i_truncate_mutex while doing IOs because if there is an
error, there will be a deadlock. Also, __zonefs_send_copy() can return an
error and that is not checked.

> +
> +	file_update_time(dst_file);
> +	zonefs_update_stats(dst_inode, dst_off + bytes);
> +	zonefs_i_size_write(dst_inode, dst_off + bytes);
> +	dst_zi->i_wpoffset += bytes;
> +	mutex_unlock(&dst_zi->i_truncate_mutex);
> +
> +
> +

2 extra uneeded blank lines.

> +	/*
> +	 * if we still have some bytes left, do splice copy
> +	 */

This comment fits on a single line.

> +	if (bytes && (bytes < len)) {
> +		zonefs_info(src_sb, "Final partial copy of %zu bytes\n", len);
> +		bytes = do_splice_direct(src_file, &src_off, dst_file,
> +					 &dst_off, len, flags);

And this can fail because other writes may be coming in since you never
locked inode->i_mutex.

> +		if (bytes > 0)
> +			ret += bytes;
> +		else
> +			zonefs_info(src_sb, "Failed partial copy (%zd)\n", bytes);

Error message not needed.

> +	}
> +
> +out:
> +
> +	return ret;
> +}
> +
> +static ssize_t zonefs_copy_file_range(struct file *src_file, loff_t src_off,
> +				    struct file *dst_file, loff_t dst_off,
> +				    size_t len, unsigned int flags)
> +{
> +	ssize_t ret;
> +
> +	ret = __zonefs_copy_file_range(src_file, src_off, dst_file, dst_off,
> +				     len, flags);
> +

Useless blank line. __zonefs_copy_file_range() needs to be split into
zonefs_copy_file_checks() and zonefs_copy_file(). The below call to
generic_copy_file_range() should go into zonefs_copy_file().
zonefs_copy_file() calling either generic_copy_file_range() if the device
does not have copy offload or zonefs_issue_copy() if it does.

> +	if (ret == -EOPNOTSUPP || ret == -EXDEV)> +		ret = generic_copy_file_range(src_file, src_off, dst_file,
> +					      dst_off, len, flags);

This function is not taking the inode_lock() for source and est files.
This means that this can run with concurent regular writes and truncate
and that potentially can result in some very weird results, unaligned
write errors and the FS going read-only.


> +	return ret;
> +}
> +
>  static const struct file_operations zonefs_file_operations = {
>  	.open		= zonefs_file_open,
>  	.release	= zonefs_file_release,
> @@ -1200,6 +1366,7 @@ static const struct file_operations zonefs_file_operations = {
>  	.splice_read	= generic_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.iopoll		= iocb_bio_iopoll,
> +	.copy_file_range = zonefs_copy_file_range,
>  };
>  
>  static struct kmem_cache *zonefs_inode_cachep;
> @@ -1262,7 +1429,7 @@ static int zonefs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  
>  enum {
>  	Opt_errors_ro, Opt_errors_zro, Opt_errors_zol, Opt_errors_repair,
> -	Opt_explicit_open, Opt_err,
> +	Opt_explicit_open, Opt_no_copy_offload, Opt_err,

This mount option does not make much sense. Copy file range was not
supported until now. Existing applications are thus not using it. Adding
support for copy_file_range op will not break these applications so it can
be unconditionally supported.


>  };
>  
>  static const match_table_t tokens = {
> @@ -1271,6 +1438,7 @@ static const match_table_t tokens = {
>  	{ Opt_errors_zol,	"errors=zone-offline"},
>  	{ Opt_errors_repair,	"errors=repair"},
>  	{ Opt_explicit_open,	"explicit-open" },
> +	{ Opt_no_copy_offload,	"no_copy_offload" },
>  	{ Opt_err,		NULL}
>  };
>  
> @@ -1280,6 +1448,7 @@ static int zonefs_parse_options(struct super_block *sb, char *options)
>  	substring_t args[MAX_OPT_ARGS];
>  	char *p;
>  
> +	sbi->s_mount_opts |= ZONEFS_MNTOPT_COPY_FILE;
>  	if (!options)
>  		return 0;
>  
> @@ -1310,6 +1479,9 @@ static int zonefs_parse_options(struct super_block *sb, char *options)
>  		case Opt_explicit_open:
>  			sbi->s_mount_opts |= ZONEFS_MNTOPT_EXPLICIT_OPEN;
>  			break;
> +		case Opt_no_copy_offload:
> +			sbi->s_mount_opts &= ~ZONEFS_MNTOPT_COPY_FILE;
> +			break;
>  		default:
>  			return -EINVAL;
>  		}
> @@ -1330,6 +1502,8 @@ static int zonefs_show_options(struct seq_file *seq, struct dentry *root)
>  		seq_puts(seq, ",errors=zone-offline");
>  	if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_REPAIR)
>  		seq_puts(seq, ",errors=repair");
> +	if (sbi->s_mount_opts & ZONEFS_MNTOPT_COPY_FILE)
> +		seq_puts(seq, ",copy_offload");
>  
>  	return 0;
>  }
> @@ -1769,6 +1943,8 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	atomic_set(&sbi->s_active_seq_files, 0);
>  	sbi->s_max_active_seq_files = bdev_max_active_zones(sb->s_bdev);
>  
> +	/* set copy support by default */
> +	sbi->s_mount_opts |= ZONEFS_MNTOPT_COPY_FILE;
>  	ret = zonefs_read_super(sb);
>  	if (ret)
>  		return ret;
> diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
> index 4b3de66c3233..efa6632c4b6a 100644
> --- a/fs/zonefs/zonefs.h
> +++ b/fs/zonefs/zonefs.h
> @@ -162,6 +162,7 @@ enum zonefs_features {
>  	(ZONEFS_MNTOPT_ERRORS_RO | ZONEFS_MNTOPT_ERRORS_ZRO | \
>  	 ZONEFS_MNTOPT_ERRORS_ZOL | ZONEFS_MNTOPT_ERRORS_REPAIR)
>  #define ZONEFS_MNTOPT_EXPLICIT_OPEN	(1 << 4) /* Explicit open/close of zones on open/close */
> +#define ZONEFS_MNTOPT_COPY_FILE		(1 << 5) /* enable copy file range offload to kernel */
>  
>  /*
>   * In-memory Super block information.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

