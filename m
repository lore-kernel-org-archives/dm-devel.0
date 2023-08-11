Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EA2C0015E
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691752829;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=T3L8nkT83PP4doFNnz4rxF4jFX4R0w68FHSe1MaXYpc=;
	b=U9PisHiIHMhUBGG0t2KnNPCxGvyH0lFhnf+4w/CgfG0SS0RG6kFIYxIumFnxWTmXTJo9fM
	/XYe03cuIHFTWTu+x3QJSySo1vLkERvHLe3W4Mhxrc6LKlZ1VGTqjH66eO4ZXOwf1bq4R0
	FUVG4G93ScbvyRQcoNsBwV1UwrtsWFQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-lqZtIJ_DN8qIJIv8d4Ystg-1; Fri, 11 Aug 2023 07:20:24 -0400
X-MC-Unique: lqZtIJ_DN8qIJIv8d4Ystg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E88185D066;
	Fri, 11 Aug 2023 11:20:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED42740C6F4E;
	Fri, 11 Aug 2023 11:20:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BCAB1194658F;
	Fri, 11 Aug 2023 11:20:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E550B1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 11:20:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D346B40C6E8A; Fri, 11 Aug 2023 11:20:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CB0E040C6F4E
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABD908011AD
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:20 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-t2cHxDysP5mCwxDbMOqNlg-1; Fri, 11 Aug 2023 07:20:18 -0400
X-MC-Unique: t2cHxDysP5mCwxDbMOqNlg-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230811112015epoutp03cfce1ee97c4189b5b8ecfd5097fc9796~6UDjtVANj0704607046epoutp038
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230811112015epoutp03cfce1ee97c4189b5b8ecfd5097fc9796~6UDjtVANj0704607046epoutp038
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230811112014epcas5p3958f8d1967ab15897bb3be62821571ed~6UDjP4Mct0795807958epcas5p39;
 Fri, 11 Aug 2023 11:20:14 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RMhCw0bX0z4x9Pw; Fri, 11 Aug
 2023 11:20:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 D1.F9.44250.B6916D46; Fri, 11 Aug 2023 20:20:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230811105723epcas5p468fa65dc9c5bea39d40359ce55bcd9aa~6Tvmbnr272396023960epcas5p4J;
 Fri, 11 Aug 2023 10:57:23 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230811105723epsmtrp2adcad1d7712db43b279f48d44b4483be~6TvmaM7uj2537325373epsmtrp20;
 Fri, 11 Aug 2023 10:57:23 +0000 (GMT)
X-AuditID: b6c32a4a-c4fff7000000acda-84-64d6196bc3b0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 EA.01.30535.31416D46; Fri, 11 Aug 2023 19:57:23 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230811105720epsmtip243422a725f23ed8a3fb938caebd214bf~6TvivIhqg1483514835epsmtip2E;
 Fri, 11 Aug 2023 10:57:19 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Fri, 11 Aug 2023 16:22:48 +0530
Message-Id: <20230811105300.15889-6-nj.shetty@samsung.com>
In-Reply-To: <20230811105300.15889-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfVRTZRzuvXe7G+g4l2nxbp5kZx5LIGBDGJePoR3N7ik6hxOco9Yf48bu
 AWTcjX1I4x8ppALlQ4OCmQEJ8VVAC3CAExpHJ0sE9AiCqUDslJKQH5GiQIyb5X/P73l/z/P7
 eM+PjwoXMDE/nTHSeobSSDFvTmd/wKvBGtGoWrYiIFpd51Hi49IllGi+UYIRs/33ATHT9ykg
 Jnt3EPa5E1xivK8LIRqbzyHEcccoINxXLQhhnwgiaj6p5RBn7AMc4kr3VxhR9a2bR9Q7lxHi
 WqkbEJ1PqlCiZXaeQ1yY2EQMLTm5O18ih27+wCGvDJpIa1MBRv5Ye4jsGc/FyFPFn3PJorw5
 jLznnuCQ82evYmRxexMgH1g3k9aZu0jC+vcyYtNoSk3rJTSTolWnM6lK6duJql2qCIVMHiyP
 IiKlEobKpJXS3fEJwXvSNavjSiUHKY1plUqgDAZpaFysXmsy0pI0rcGolNI6tUYXrgsxUJkG
 E5MawtDGaLlMFhaxmpickVbX+JCr+0nw4e+/DPNyQcO6QsDnQzwcjtVlFQJvvhDvAfBmxTDG
 BvcBLKu4x2ODBQCLT36PFgKvNcWxpV7Eg4W4HcC20jg2KR+B80dGuB5bDA+CP6/wPfxGPBeF
 bT2ngCdAcQcCr9UM8zzqDXgSnL1exvVgDr4Vni52rPECPBo6VjoA218oLLnl66G98Bg4b72M
 sSm+cKByhuPBKO4P8zpOoB5/iJd4QVvNNMJqd8P6ljS26Q3wjrOdx2IxfDBnx1icDRvLGjBW
 exhAy5gFsA87YL6rBPX4oHgAbO0OZemXYbmrBWHr+sCiJzMIywug7etneAv8rrX6X38RHP37
 I4xth4TNpxPYXRUD+NT2JbcUSCzPjWN5bhzL/5WrAdoERLTOkJlKGyJ0YQyd/d8fp2gzrWDt
 AALfsoGpyT9DHADhAweAfFS6UaBMvKwWCtSUOYfWa1V6k4Y2OEDE6rqPoeIXU7SrF8QYVfLw
 KFm4QqEIj9qukEv9BLP5J9VCPJUy0hk0raP1z3QI30ucixijk/7YufgaF6tMXawuDzTzs154
 5a+OdztH5jm2yqcXxj5Dg7itib3Ls9+k1+vj3lRtVg7EHnTWe49uoyjK+XjBd/zctNTnjVbe
 fveBmsXcsCx/G/pFx63bpbrXXe/Xr48RJS8ef1gaOeR+LB5JVkz75bxzkYnscu3p7usbh9ap
 nMx40fjdR4nrlvbNzRw1J32gYIQDU9EK12B/DveR0eeS6bc2c4GqrhaL3D7ZXHXk0FKDUxTW
 uxynow+f8dvKkUnKq65jRaroEX+m/XZnQfPgHaTy15hNLfFdZ4/uw7z2b7nYcik58UCVKXhB
 uY0wi/eaxRW7agPsRpct7/yNvdlSjiGNkgeiegP1D3PRSP2JBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWy7bCSvK6wyLUUg2vNZhbrTx1jtmia8JfZ
 YvXdfjaL14c/MVo8OdDOaPFgv73F3nezWS1uHtjJZLFy9VEmi0mHrjFaPL06i8li7y1ti4Vt
 S1gs9uw9yWJxedccNov5y56yWyw//o/J4saEp4wW237PZ7ZY9/o9i8WJW9IW5/8eZ3UQ8zh/
 byOLx+WzpR6bVnWyeWxeUu+x+2YDm8fivsmsHr3N79g8Pj69xeLxft9VNo++LasYPT5vkvPY
 9OQtUwBPFJdNSmpOZllqkb5dAlfG0pVfWAsO8la8uHOBvYFxBXcXIyeHhICJxMS/+5m6GLk4
 hAR2M0o8+zOTFSIhKbHs7xFmCFtYYuW/5+wQRc1MEv++TGDsYuTgYBPQljj9nwMkLiLQxSzR
 ufMdC4jDLHCOSaLt0UJ2kG5hgSCJrq1rWEBsFgFVie19h8DivAJWEof+bwUbJCGgL9F/XxAk
 zClgLfF+0yU2EFsIqOTDsoOMEOWCEidnPgEbwywgL9G8dTbzBEaBWUhSs5CkFjAyrWKUTC0o
 zk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI5ULa0djHtWfdA7xMjEwXiIUYKDWUmE1zb4UooQ
 b0piZVVqUX58UWlOavEhRmkOFiVx3m+ve1OEBNITS1KzU1MLUotgskwcnFINTEdnaUsJMFsq
 s/dnczyyquZh15h8Mdbp6KR+ri+FrHcna6tP6rtz5Ued3zFfqYjIA7/mxyZvUpyVwJeqpHrX
 02HXxNlXKvfwKtU/Ps8rYNQ8v3GP/wqRSyqmpyzf910qT5z+J+SyxcX+yUuPbIr8uVS8zsbQ
 66XDjM2Nr47UvBWaYvEmZ/K5s+v/xTxdefH88ezKQ41t/UwfWiu2Tdv+qXxiPU/3bZNN3U8E
 7Lav3PPwYdHdzDdspnWNR2WzFC9V3PoStvnI+uM6xpMrXNXmyD8ynTx/55E5vHXvUrXnfeB+
 Ga4wWbZv6Y4+hc96EfViz1fdda844loWefFckdu1f7p5528ENvgJHE++6pvapaPEUpyRaKjF
 XFScCAB+WHkdQwMAAA==
X-CMS-MailID: 20230811105723epcas5p468fa65dc9c5bea39d40359ce55bcd9aa
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811105723epcas5p468fa65dc9c5bea39d40359ce55bcd9aa
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105723epcas5p468fa65dc9c5bea39d40359ce55bcd9aa@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v14 05/11] fs/read_write: Enable copy_file_range
 for block device.
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 dlemoal@kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Anuj Gupta <anuj20.g@samsung.com>

This is a prep patch. Allow copy_file_range to work for block devices.
Relaxing generic_copy_file_checks allows us to reuse the existing infra,
instead of adding a new user interface for block copy offload.
Change generic_copy_file_checks to use ->f_mapping->host for both inode_in
and inode_out. Allow block device in generic_file_rw_checks.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 fs/read_write.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index b07de77ef126..eaeb481477f4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1405,8 +1405,8 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 				    struct file *file_out, loff_t pos_out,
 				    size_t *req_count, unsigned int flags)
 {
-	struct inode *inode_in = file_inode(file_in);
-	struct inode *inode_out = file_inode(file_out);
+	struct inode *inode_in = file_in->f_mapping->host;
+	struct inode *inode_out = file_out->f_mapping->host;
 	uint64_t count = *req_count;
 	loff_t size_in;
 	int ret;
@@ -1708,7 +1708,9 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
 	/* Don't copy dirs, pipes, sockets... */
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
-	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+	if (!S_ISREG(inode_in->i_mode) && !S_ISBLK(inode_in->i_mode))
+		return -EINVAL;
+	if ((inode_in->i_mode & S_IFMT) != (inode_out->i_mode & S_IFMT))
 		return -EINVAL;
 
 	if (!(file_in->f_mode & FMODE_READ) ||
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

