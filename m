Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A87C001DE
	for <dm-devel@archiver.kernel.org>; Mon, 24 Jul 2023 06:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690179095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=7TBQPg7YqAQA8v3Q2oghYKYZwHNY3MeVH3Qa3FOEj7Q=;
	b=JJQ6WRkpI0uqKb7qUsXoispAQb+jKTsT0OAc2b3ST+GIZ2N1tCaTt+q6ItyXoVUaDsGchH
	3JH0DxgN2SAEzMGiaFDa4LQbhZMUvcROvCOhYIX6X2qxEuqLxs5a2SydqthR0mCDlgw9H9
	q9/aG1RpFBuVImh4CrD5ZM3dSdNfN3M=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-iDx_KjQGN8eF5wFgcOTCNw-1; Mon, 24 Jul 2023 02:11:31 -0400
X-MC-Unique: iDx_KjQGN8eF5wFgcOTCNw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B25F03C0DDA1;
	Mon, 24 Jul 2023 06:11:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A5081121314;
	Mon, 24 Jul 2023 06:11:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C0B9194658D;
	Mon, 24 Jul 2023 06:11:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 087F81946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Jul 2023 06:11:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E661940C206F; Mon, 24 Jul 2023 06:11:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEF8940C2063
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 06:11:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0ED2803470
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 06:11:17 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-BKv0YENZN968qlSXyjP0Cw-1; Mon, 24 Jul 2023 02:11:14 -0400
X-MC-Unique: BKv0YENZN968qlSXyjP0Cw-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230724061111epoutp026bc9528bca51bc378f5c2c20ceead96d~0uOkCV9SU0315303153epoutp029
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 06:11:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230724061111epoutp026bc9528bca51bc378f5c2c20ceead96d~0uOkCV9SU0315303153epoutp029
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230724061110epcas5p2503ac4c4ac74bf7d8c202484a6932147~0uOjZHrS53020830208epcas5p2e;
 Mon, 24 Jul 2023 06:11:10 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4R8VCc0BLhz4x9QK; Mon, 24 Jul
 2023 06:11:08 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 8A.B5.06099.BF51EB46; Mon, 24 Jul 2023 15:11:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230724054922epcas5p4cdcf4bdb7ddc57eac4d687b40d9633b9~0t7hBWhw70396703967epcas5p4_;
 Mon, 24 Jul 2023 05:49:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230724054922epsmtrp1589ea7b455f628dab9e4898d7d32032a~0t7g8VLIR2266822668epsmtrp1C;
 Mon, 24 Jul 2023 05:49:22 +0000 (GMT)
X-AuditID: b6c32a4b-d308d700000017d3-66-64be15fb2893
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 1A.24.34491.1E01EB46; Mon, 24 Jul 2023 14:49:21 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230724054918epsmtip2e23bc6255b974fdc88465d963a53ae7e~0t7da5FbA1810118101epsmtip2U;
 Mon, 24 Jul 2023 05:49:18 +0000 (GMT)
Date: Mon, 24 Jul 2023 11:16:06 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20230724054606.y6ibtn4mwupmziii@green245>
MIME-Version: 1.0
In-Reply-To: <20230720075710.GC5042@lst.de>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0zTVxTHvb9f+2vBFX8gZBdwSso2Awzk7UVAmRr9GRaHcZGMZWGV/tIy
 oO36QDfH5DFwgjwrwhCEqeO9Eh6RZxmUTAbqWIJUJYOVWdx4isgEBcpaCov/fe73nO+5956T
 w8ZtVCwHdrRITktFvFguYcm41ePi4r5s18n37C4IQHX9t3GUnLOKo5qRbAJN9cwDdGXuJY70
 XRcAGtRbId3PB5B69ioTPepqxVDH9TwMVdX8gqE8jRag8aEiDKmH3dAPaTcZqEPdx0CDbcUE
 Ki0fZ6GMBy0Equg1YEijTMFQiz4JINXUUwb6ddgRDaz2MtHyUjER4kgN3g+lWotGWNTAaD2D
 aqx0pQbvKaiG6osE1XjzPNX+KJGgbmQpmVRmyixBPRsfZlBPO4cIKqupGlCNd85Rzxt2Ug36
 GSyMjIgJEtI8Pi11okVRYn60SBDMDT0ZeSjSz9/Ty90rAO3lOol4cXQw9/AHYe5HomONjeE6
 xfNiFUYpjCeTcffsD5KKFXLaSSiWyYO5tIQfK/GVeMh4cTKFSOAhouX7vDw9vf2MiZ/FCAv/
 XCIkw7Znr313n5kI8q3TgQUbkr5wvqqGSAeWbBuyHcDBxb+ZpoANOQ9getMGvwBQP/r+pqEs
 UwvMBjWA/9TlM8yHJwDmXl7ATVkM8h2YVZxsLMtmE6QbvLPGNsm2JBeOT95bN+PkChN26VQs
 U2A7yYPNhqx15pD+cCzpD4aZrWHf9/p1tjDWaSg2ABPbkTtg4Y//4qZCkNRawIKk2yzz8w7D
 W30GzMzb4WRv04buACey0zb4DKy6XEmYzd8CWPSgCJgDB2Bqf/b6D3BSCMvWcplm/S2Y36/C
 zLoVzFzWb1zAgS3XNtkZ1taVEWa2h9rFpA2m4ETGw41+6QBcUfeycsCuotd+V/TafWbeBy/O
 JRuZbWRHWGFgm9EF1rXtKQPMamBPS2RxAlrmJ/ER0Wf+n3iUOK4BrC+Oa2gL+Es356EBGBto
 AGTjXFuOQNDGt+HweV9+RUvFkVJFLC3TAD/jtHJxB7sosXHzRPJIL98AT19/f3/fAB9/L+6b
 nKnUEr4NKeDJ6RialtDSTR/GtnBIxHCWOm1hx/GVj1+uvfc4jyNICFl0vZB6vEDn9vm2uBsl
 22q5swYifMtC3vmjzhrlifmMsZHcoyFqZFknvxTfXsZrVZ4mXhW7PMyoYTXz8U9P5lSJG3da
 frgQ99yn4OLXuu6+SmX44Ee7I0ruHns79QV/fzbLetoqRNVcypgejZ4OrV7kDBysfKVl2v/+
 jEXqV9sSjukC1bXyptSfRr0jQpQ559asl4IStgi8w8McXGaY7m/s0paf6p2cqAqcU36Rdvrx
 oY69nb9lpxxMKZ/55En41qsK58Ka4Qj+qbOl7wYG7earvHsyhfr4KItL3elHZk4kfTNUX3H9
 rtX82NjWegssSq3iMmRCnpcrLpXx/gMaI2auwQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWy7bCSvO5DgX0pBl1frSzWnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WTA+2MFpef8Fk82G9vsffdbFaLmwd2MlnsWTSJyWLl6qNMFpMO
 XWO0eHp1FpPF3lvaFgvblrBY7Nl7ksXi8q45bBbzlz1lt+i+voPNYvnxf0wWhyY3M1nseNLI
 aLHu9XsWixO3pC3O/z3OavH7xxw2B2mPy1e8PXbOusvucf7eRhaPzSu0PC6fLfXYtKqTzWPz
 knqP3Tcb2DwW901m9ehtfsfm8fHpLRaP9/uusnn0bVnF6LH5dLXH501yHpuevGUKEIjisklJ
 zcksSy3St0vgypi6Yyt7QY9QxZ5nW1kaGB/ydTFyckgImEgs6L3G2MXIxSEksJtR4tG2g2wQ
 CUmJZX+PMEPYwhIr/z1nhyh6wihxe+E2VpAEi4CqRN+cJqAGDg42AW2J0/85QMIiAkoST1+d
 BRvKLNDAJtFz7zVYvbBAosT2f33sIDavgJnEw8Y7LBBDHzBKTJ+3nREiIShxcuYTFhCbGaho
 3uaHzCALmAWkJZb/A1vACbRr05x/YOWiAjISM5Z+ZZ7AKDgLSfcsJN2zELoXMDKvYpRMLSjO
 Tc8tNiwwzEst1ytOzC0uzUvXS87P3cQIThRamjsYt6/6oHeIkYmD8RCjBAezkghvevquFCHe
 lMTKqtSi/Pii0pzU4kOM0hwsSuK84i96U4QE0hNLUrNTUwtSi2CyTBycUg1M83ICDkiefP1R
 w3f+1xd/hGd6HXtQsEm0IlftwdFXJTXxMbynCjoevkpv/Z+yL/fX+Xy3zNBcBsG0c9rfTgTn
 tu9bPWtlULFBbthBSx5H/wPP57FE/GbcvHZ18AOpW1xznmXzXas74aSqV6tVd9Hw7+2bFVKS
 x52Nb87efqBxB+PD6wd9ZJ4uvH7JYEFD/P/UmfP+rHSVi9/za064KZ+SZTqra0rvtpPN7csD
 bv5R2mD9Z9qswDDm3mmJh9XrW9pEufOmPZ2xu5Ct5ayEgUXN8/SOZOb0eXx692fz6so0Xb87
 d1np/yNawmaGBxY1PVBt+le0OjWMbVex1n0R3Q8zvR/fusHw8tZT8yx7ic1CSizFGYmGWsxF
 xYkASAGQ3YMDAAA=
X-CMS-MailID: 20230724054922epcas5p4cdcf4bdb7ddc57eac4d687b40d9633b9
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230627184029epcas5p49a29676fa6dff5f24ddfa5c64e525a51
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184029epcas5p49a29676fa6dff5f24ddfa5c64e525a51@epcas5p4.samsung.com>
 <20230627183629.26571-5-nj.shetty@samsung.com>
 <20230720075710.GC5042@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v13 4/9] fs,
 block: copy_file_range for def_blk_ops for direct block device
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
Cc: linux-doc@vger.kernel.org, djwong@kernel.org,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, nitheshshetty@gmail.com, willy@infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_dd00a_"

------PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_dd00a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/07/20 09:57AM, Christoph Hellwig wrote:
>> +/* Copy source offset from source block device to destination block
>> + * device. Returns the length of bytes copied.
>> + */
>> +ssize_t blkdev_copy_offload_failfast(
>> +		struct block_device *bdev_in, loff_t pos_in,
>> +		struct block_device *bdev_out, loff_t pos_out,
>> +		size_t len, gfp_t gfp_mask)
>
>This is an odd and very misnamed interface.
>
>Either we have a klkdev_copy() interface that automatically falls back
>to a fallback (maybe with an opt-out), or we have separate
>blkdev_copy_offload/blkdev_copy_emulated interface and let the caller
>decide.  But none of that really is "failfast".
>
>Also this needs to go into the helpers patch and not a patch that is
>supposed to just wire copying up for block device node.
>
Acked.

>> index b07de77ef126..d27148a2543f 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -1447,7 +1447,8 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
>>  		return -EOVERFLOW;
>>
>>  	/* Shorten the copy to EOF */
>> -	size_in = i_size_read(inode_in);
>> +	size_in = i_size_read(file_in->f_mapping->host);
>
>generic_copy_file_checks needs to be fixed to use ->mapping->host both
>or inode_in and inode_out at the top of the file instead of this
>band aid.  And that needs to be a separate patch with a Fixes tag.
>
Addressed below.

>> @@ -1708,7 +1709,9 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
>>  	/* Don't copy dirs, pipes, sockets... */
>>  	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
>>  		return -EISDIR;
>> -	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
>> +
>> +	if ((!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode)) &&
>> +		(!S_ISBLK(inode_in->i_mode) || !S_ISBLK(inode_out->i_mode)))
>
>This is using weird indentation, and might also not be doing
>exactly what we want.  I think the better thing to do here is to:
>
> 1) check for the accetable types only on the in inode
> 2) have a check that the mode matches for the in and out inodes
>
>And please do this as a separate prep patch instead of hiding it here.
>
Agreed. We will send a separate patch, that enables copy_file_range on
block devices.

Thank you,
Nitesh Shetty

------PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_dd00a_
Content-Type: text/plain; charset="utf-8"


------PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_dd00a_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_dd00a_--

