Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15378EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jun 2023 07:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688024871;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=93YIxgIqY8VudFuZpRXutZQXvWfYnWnfpQFHJFDNp10=;
	b=NB9PRJkspgEXxegnG0XrghWsVnwma623LV5/NNAG2/ky/E0G6NWlkzbxSOKpjZfDUYjBWy
	XTPEymqXs2SHBKOFemH+NrBtNjLpcBdhXC4219vZETchQKZsaH2WEWqWiABoNXnBUaL0LN
	kG+HmWEVvy3AB8hjpYiMj2vGyyZXmLM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-jTK_B0SyPxuIembOxOVfBw-1; Thu, 29 Jun 2023 03:47:47 -0400
X-MC-Unique: jTK_B0SyPxuIembOxOVfBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A89571064A5D;
	Thu, 29 Jun 2023 07:47:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED49140C2063;
	Thu, 29 Jun 2023 07:47:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3E0219465B6;
	Thu, 29 Jun 2023 07:47:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 82EAB1946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Jun 2023 07:47:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7412040C2071; Thu, 29 Jun 2023 07:47:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 61B1540C2070
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 07:47:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ECDD8E4689
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 07:47:41 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-gS3Dpt1uP9iMeOpT7wfZzg-1; Thu, 29 Jun 2023 03:47:39 -0400
X-MC-Unique: gS3Dpt1uP9iMeOpT7wfZzg-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230629074735epoutp04f67c6257915ab225fa606761ae16c4d5~tEamw2qsv1950519505epoutp04h
 for <dm-devel@redhat.com>; Thu, 29 Jun 2023 07:47:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230629074735epoutp04f67c6257915ab225fa606761ae16c4d5~tEamw2qsv1950519505epoutp04h
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230629074734epcas5p4cc802435e65817703a6bfa7a237a6433~tEalXK4Ib2970729707epcas5p4t;
 Thu, 29 Jun 2023 07:47:34 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Qs9XN4QGHz4x9Q2; Thu, 29 Jun
 2023 07:47:32 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 C8.77.06099.4173D946; Thu, 29 Jun 2023 16:47:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230628164314epcas5p43d203daae701b950a2649bb97c0c8ef5~s4E-sqhrT1878918789epcas5p4N;
 Wed, 28 Jun 2023 16:43:14 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230628164314epsmtrp1b4b1b459c8517507dab6d889ddb70aa8~s4E-rV6Yc2914729147epsmtrp1o;
 Wed, 28 Jun 2023 16:43:14 +0000 (GMT)
X-AuditID: b6c32a4b-cafff700000017d3-69-649d37142ebc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 F2.92.30535.2236C946; Thu, 29 Jun 2023 01:43:14 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230628164304epsmtip18665c8edaf0a91b72f882ceb4459921d~s4E2b1J9z2949329493epsmtip1U;
 Wed, 28 Jun 2023 16:43:04 +0000 (GMT)
Date: Wed, 28 Jun 2023 22:09:58 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <dlemoal@kernel.org>
Message-ID: <20230628163958.tgwtlszadsa7zoub@green245>
MIME-Version: 1.0
In-Reply-To: <365d5129-b65e-919a-3ceb-cc2ccf6b7a5a@kernel.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02TaUxUVxTHe9978+ZhO/pESC9ggU5DVQzL1GG4IJtRyWsgLS1tPxgbfDAv
 QIGZySxV2xrBjTiWGVaLI2WpVFlEwtKCLMVAcQSkqMheGkMGRKhIJRUIgmV40Pbb7/zP+eec
 e04uhdtWCB2peIWWUyvYRDG5ifi5bddODzvf7+XexWUuqLLzNo5OpS/jqHzUSKLptucAXZxd
 xJHlVipAvZbN6FFLMGqeuSxAQ7duYqjph0wMlZa3YyiztR+g8T4ThpqHd6Oic8UEamruIFBv
 Qx6JCq6OC9GFgXoSXTOvYKg16zSG6i0pAN2YfkagO8NOqGfZLEBLC3lkiBPT+zCMuWkaFTI9
 f1QRTE2JO9PbrWOqy86TTE3xSaZxKJlkrhiyBEza6RmS+Wt8mGCe/dJHMobaMsDUdH3NzFU7
 M9WWp1gEfSghII5j5ZzalVPEKOXxithAcVhk1P4oH5m3xEPih3zFrgo2iQsUHwiP8AiNT1xd
 jNj1SzZRtypFsBqN2CsoQK3UaTnXOKVGGyjmVPJElVTlqWGTNDpFrKeC0/pLvL3f81ktPJIQ
 d/H3SaCadDj2IOMqlgxe2umBDQVpKWxe6MH1YBNlSzcCWFc/vx48B7CrMlnIBy8A/GleT2xY
 eibNBJ9oBrB7uWPdMgHgbwsvMD2gKIJ2gxNz71uRpHfDrleU1WtH74A5WU3AWo7TehLeKSgX
 WBPbaBbWrRiEVhbRMph920TyvBV2XLKsNbahg2CVqWpNt6e3w9wf/17rC+lhGziab8b56Q7A
 kYa09Um3wSlzrZBnR/jEeG6dj8LS7BKSN58B0DRgAnwiGJ7tNOLWqXE6Dj4t8uLlt2BO5w3M
 yji9GaYtWTBeF8H6/A1+B16vLCR5doD98ynrzMAnFwYBv6A5AEsfVJLpwMX0v8eZ/mtnWmvh
 D8/PnhLwshO8tkLxuAtWNngVAkEZcOBUmqRYTuOj2qPgjv578BhlUjVY+zfuYfVg7NGsZyvA
 KNAKIIWL7UQjf16W24rk7PGvOLUySq1L5DStwGf1VBm4o32McvXjKbRREqmft1Qmk0n99sgk
 4jdF9wfS5LZ0LKvlEjhOxak3fBhl45iM6T/gWquRnvkw/fNI/ZHGPgHt2pK1d99dLOL1L5Rb
 2/ePjQyw3x5jvR77F5Qsuo+NgMOLWn+b9oMNecy+EfmEqKNW2hQfi2j8JRGgDp+qyR60v/5N
 SXD0UsiJCOOvdlPpXR9tyZU13pMiziX+rmtASt3bHQ7HD3kVPhz/+JOxCNm8z6s3dshLd2Zm
 5TTvVb3W7ew3eMXjXftP888MURZ7ERcJQj0DjNTyyaAqvI2D3SFuGVh4Qb/3bEV0y9S9g26p
 uakGYsY5fAshybxfFH3WMJNWNhxa78mZzNONIpdKndCwfSa0YTEU0x1+/J2gosCYfsI++7PS
 /ksDvuWFOj8xoYljJe64WsP+AxNX4wnABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWy7bCSnK5S8pwUgz1rWSzWnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WTA+2MFpef8Fk82G9vsffdbFaLmwd2MlnsWTSJyWLl6qNMFpMO
 XWO0eHp1FpPF3lvaFgvblrBY7Nl7ksXi8q45bBbzlz1lt+i+voPNYvnxf0wWhyY3M1nseNLI
 aLHu9XsWixO3pC3O/z3OavH7xxw2B2mPy1e8PXbOusvucf7eRhaPzSu0PC6fLfXYtKqTzWPz
 knqP3Tcb2DwW901m9ehtfsfm8fHpLRaP9/uusnn0bVnF6LH5dLXH501yHpuevGUKEIjisklJ
 zcksSy3St0vgyjiz/itTwSzxita/nUwNjCeEuhg5OSQETCTOvzjO0sXIxSEksJtR4uCHM6wQ
 CUmJZX+PMEPYwhIr/z1nhyh6wijR+/YDWxcjBweLgKrEs8+eICabgLbE6f8cIOUiAuoSUyfv
 YQQpZxboYZO4dQ1kASeHsECixPZ/fewgNq+AmcSUY7PYIGZ+ZpRombGcDSIhKHFy5hOwBmag
 onmbHzKDLGAWkJZY/g9sAaeAncTGWRvBykUFZCRmLP3KPIFRcBaS7llIumchdC9gZF7FKJla
 UJybnltsWGCUl1quV5yYW1yal66XnJ+7iRGcJrS0djDuWfVB7xAjEwfjIUYJDmYlEd7bb2an
 CPGmJFZWpRblxxeV5qQWH2KU5mBREuf99ro3RUggPbEkNTs1tSC1CCbLxMEp1cB02LL7ZoB8
 v+7nV4u2nG2ewBEYfyx2Jdtl5iP5Wh0vT7VJxrYp2Hlydf/8KXdb4GfWSrW9AVPrZ0vNe9NR
 9/N9h90r+5UXJ9WteBH2jMtit/q1Zn7d0ICALWJJycFTVm2Oe3TO2cX29qLJhuvfaz6t9HMP
 T41syhMsMv048XaozAWFY+oxW7JnLp3j6SvguzdZgGVWnPw8py2Kpw0SfvXvf53+cvvahx8l
 PaSNjucX7jXIt/vInsozy0067Hpa5S7Nu8vzPOZZvC68cHq256f1QjU7L2rqnLb6xtZ1vWdt
 8s+03TtePZ/5q7/W9dPTPT/0YmyufreeJtJ1ZWPQmSedv/8cPp1fd5LrVsW/NIYdSizFGYmG
 WsxFxYkAxFAvgIIDAAA=
X-CMS-MailID: 20230628164314epcas5p43d203daae701b950a2649bb97c0c8ef5
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230627184029epcas5p49a29676fa6dff5f24ddfa5c64e525a51
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184029epcas5p49a29676fa6dff5f24ddfa5c64e525a51@epcas5p4.samsung.com>
 <20230627183629.26571-5-nj.shetty@samsung.com>
 <365d5129-b65e-919a-3ceb-cc2ccf6b7a5a@kernel.org>
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
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, willy@infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Keith Busch <kbusch@kernel.org>, bvanassche@acm.org,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----CHyoCALg6LzvWsSTaVDWulLjyDTSZVBAz8-9IIrQs0inuafE=_9622e_"

------CHyoCALg6LzvWsSTaVDWulLjyDTSZVBAz8-9IIrQs0inuafE=_9622e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/28 03:51PM, Damien Le Moal wrote:
>On 6/28/23 03:36, Nitesh Shetty wrote:
>> For direct block device opened with O_DIRECT, use copy_file_range to
>> issue device copy offload, and fallback to generic_copy_file_range incase
>> device copy offload capability is absent.
>
>...if the device does not support copy offload or the device files are not open
>with O_DIRECT.
>
>No ?
>
Yes your right. We will fallback to generic_copy_file_range in either of
these cases.

>> Modify checks to allow bdevs to use copy_file_range.
>>
>> Suggested-by: Ming Lei <ming.lei@redhat.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>> ---
>>  block/blk-lib.c        | 26 ++++++++++++++++++++++++++
>>  block/fops.c           | 20 ++++++++++++++++++++
>>  fs/read_write.c        |  7 +++++--
>>  include/linux/blkdev.h |  4 ++++
>>  4 files changed, 55 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>> index 09e0d5d51d03..7d8e09a99254 100644
>> --- a/block/blk-lib.c
>> +++ b/block/blk-lib.c
>> @@ -473,6 +473,32 @@ ssize_t blkdev_copy_offload(
>>  }
>>  EXPORT_SYMBOL_GPL(blkdev_copy_offload);
>>
>> +/* Copy source offset from source block device to destination block
>> + * device. Returns the length of bytes copied.
>> + */
>
>Multi-line comment style: start with a "/*" line please.
>
acked

>> +ssize_t blkdev_copy_offload_failfast(
>
>What is the "failfast" in the name for ?

We dont want failed copy offload IOs to fallback to block layer copy emulation.
We wanted a API to return error, if offload fails.

>
>> +		struct block_device *bdev_in, loff_t pos_in,
>> +		struct block_device *bdev_out, loff_t pos_out,
>> +		size_t len, gfp_t gfp_mask)
>> +{
>> +	struct request_queue *in_q = bdev_get_queue(bdev_in);
>> +	struct request_queue *out_q = bdev_get_queue(bdev_out);
>> +	ssize_t ret = 0;
>
>You do not need this initialization.
>

we need this initialization, because __blkdev_copy_offload return number of
bytes copied or error value.
So we can not return 0, incase of success/partial completion.
blkdev_copy_offload_failfast is expected to return number of bytes copied.

>> +
>> +	if (blkdev_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len))
>> +		return 0;
>> +
>> +	if (blk_queue_copy(in_q) && blk_queue_copy(out_q)) {
>
>Given that I think we do not allow copies between different devices, in_q and
>out_q should always be the same, no ?

acked, will update this.

>
>> +		ret = __blkdev_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
>> +				len, NULL, NULL, gfp_mask);
>
>Same here. Why pass 2 bdevs if we only allow copies within the same device ?
>

acked, will update function arguments to take single bdev.

>> +		if (ret < 0)
>> +			return 0;
>> +	}
>> +
>> +	return ret;
>
>return 0;
>

Nack, explained above.

Thank you,
Nitesh Shetty

------CHyoCALg6LzvWsSTaVDWulLjyDTSZVBAz8-9IIrQs0inuafE=_9622e_
Content-Type: text/plain; charset="utf-8"


------CHyoCALg6LzvWsSTaVDWulLjyDTSZVBAz8-9IIrQs0inuafE=_9622e_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------CHyoCALg6LzvWsSTaVDWulLjyDTSZVBAz8-9IIrQs0inuafE=_9622e_--

