Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97BB5C19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 19:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660073595;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jdcfC1I1DBUmZmXloyooMjM1hboHGSgNYS/FF7fgpTc=;
	b=FK8l7cCruqNJKonbo5KJ09YR86ayRjvMRYQHkTuyGklm5XKAUltGh9y3f845mlITAR0pY+
	bHv6wsMxU+xwGGeMzIbpcSXjQEFCMNTFBGYqVkpfUTpVuIrASpxeiZns0UY3jKeL7e8Zxv
	U6z5YFA/qQthW9+lWAiUl3PI+pDSMFk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-MwX75sbiPXOY9I2nUBr1wA-1; Tue, 09 Aug 2022 15:33:12 -0400
X-MC-Unique: MwX75sbiPXOY9I2nUBr1wA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 245C71019C8D;
	Tue,  9 Aug 2022 19:33:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12D2F404C6F2;
	Tue,  9 Aug 2022 19:33:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6C1A1946A4C;
	Tue,  9 Aug 2022 19:33:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A38BB1946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 19:33:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3AD7A400F36; Tue,  9 Aug 2022 19:33:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36C4C492C3B
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 19:33:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C405811E87
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 19:33:07 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-zkFRt6CtOcmMsMVOEXbwBQ-1; Tue, 09 Aug 2022 15:33:05 -0400
X-MC-Unique: zkFRt6CtOcmMsMVOEXbwBQ-1
Received: by mail-pj1-f54.google.com with SMTP id
 q9-20020a17090a2dc900b001f58bcaca95so11827494pjm.3
 for <dm-devel@redhat.com>; Tue, 09 Aug 2022 12:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=f+0qvG5LpZ/YCrirnG9rg8hMNbrBXBa71sPfrtvKm9k=;
 b=kcI9PVCb87GwW9AeNxmaDYZj0gEl7Mt4BA68bWBTOv1eJLEK65mgJqs7mbgZNyHUX8
 AKI26LcdQCdFk2rxw7SJ78qfMkCi9RGUIvE9K5chOlj8Ge4KHUQWGcEceJpS1f6xbJeu
 eab5cTCGexnAbVPgPvxjbugdqsOa7R5ecNVJctizEekeCW69doKYZx8CITHxYjSuZGYq
 e/N4lVmSXH4ZfA2kw6Z88h94PoxCoRXlmiuBKzrIIMi5dXvGtzKpS9Pm21/w8tNwodEc
 Z5Y99ylPwtCtiZ40t+RU4FDHR6N6aOChxkmEa/AGjEL3Clm0ZZ4ym3jPL1C3hXOEhmcD
 u80Q==
X-Gm-Message-State: ACgBeo0oZwF2jMllBncGoxggT7+hN27f+LtQo7bW+qQSlw3UQ9/ILalO
 cOqsUbl3LY92QHWeQU03HDo=
X-Google-Smtp-Source: AA6agR5b3k6/3uuXU2uCikVcoZWIFTOMmR2vQDrfIljSBaQQd1XN66Nj9Fx1iPA0NtYy8Ovw7IMVMA==
X-Received: by 2002:a17:902:e891:b0:16f:a8:9b9c with SMTP id
 w17-20020a170902e89100b0016f00a89b9cmr24397129plg.8.1660073583617; 
 Tue, 09 Aug 2022 12:33:03 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d?
 ([2620:15c:211:201:61e9:2f41:c2d4:73d])
 by smtp.gmail.com with ESMTPSA id
 d14-20020a170902654e00b0016d12adc282sm11204466pln.147.2022.08.09.12.33.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Aug 2022 12:33:03 -0700 (PDT)
Message-ID: <4768d11e-06c6-1b74-9822-b2421a3f59bb@acm.org>
Date: Tue, 9 Aug 2022 12:33:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Christie <michael.christie@oracle.com>, Christoph Hellwig <hch@lst.de>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-13-michael.christie@oracle.com>
 <20220809072155.GF11161@lst.de>
 <4af2a4d3-04d1-966a-5fd5-5e443b593c8b@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4af2a4d3-04d1-966a-5fd5-5e443b593c8b@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 12/20] block, nvme, scsi,
 dm: Add blk_status to pr_ops callouts.
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/9/22 11:08, Mike Christie wrote:
> On 8/9/22 2:21 AM, Christoph Hellwig wrote:
>> On Mon, Aug 08, 2022 at 07:04:11PM -0500, Mike Christie wrote:
>>> To handle both cases, this patch adds a blk_status_t arg to the pr_ops
>>> callouts. The lower levels will convert their device specific error to
>>> the blk_status_t then the upper levels can easily check that code
>>> without knowing the device type. It also allows us to keep userspace
>>> compat where it expects a negative -Exyz error code if the command fails
>>> before it's sent to the device or a device/tranport specific value if the
>>> error is > 0.
>>
>> Why do we need two return values here?
> 
> I know the 2 return values are gross :) I can do it in one, but I wasn't sure
> what's worse. See below for the other possible solutions. I think they are all
> bad.
> 
> 
> 0. Convert device specific conflict error to -EBADE then back:
> 
> sd_pr_command()
> 
> .....
> 
> /* would add similar check for NVME_SC_RESERVATION_CONFLICT in nvme */
> if (result == SAM_STAT_CHECK_CONDITION)
> 	return -EBADE;
> else
> 	return result;
> 
> 
> LIO then just checks for -EBADE but when going to userspace we have to
> convert:
> 
> 
> blkdev_pr_register()
> 
> ...
> 	result = ops->pr_register()
> 	if (result < 0) {
> 		/* For compat we must convert back to the nvme/scsi code */
> 		if (result == -EBADE) {
> 			/* need some helper for this that calls down the stack */
> 			if (bdev == SCSI)
> 				return SAM_STAT_RESERVATION_CONFLICT
> 			else
> 				return NVME_SC_RESERVATION_CONFLICT
> 		} else
> 			return blk_status_to_str(result)
> 	} else
> 		return result;
> 
> 
> The conversion is kind of gross and I was thinking in the future it's going
> to get worse. I'm going to want to have more advanced error handling in LIO
> and dm-multipath. Like dm-multipath wants to know if an pr_op failed because
> of a path failure, so it can retry another one, or a hard device/target error.
> It would be nice for LIO if an PGR had bad/illegal values and the device
> returned an error than I could detect that.
> 
> 
> 1. Drop the -Exyz error type and use blk_status_t in the kernel:
> 
> sd_pr_command()
> 
> .....
> if (result < 0)
> 	return -errno_to_blk_status(result);
> else if (result == SAM_STAT_CHECK_CONDITION)
> 	return -BLK_STS_NEXUS;
> else
> 	return result;
> 
> blkdev_pr_register()
> 
> ...
> 	result = ops->pr_register()
> 	if (result < 0) {
> 		/* For compat we must convert back to the nvme/scsi code */
> 		if (result == -BLK_STS_NEXUS) {
> 			/* need some helper for this that calls down the stack */
> 			if (bdev == SCSI)
> 				return SAM_STAT_RESERVATION_CONFLICT
> 			else
> 				return NVME_SC_RESERVATION_CONFLICT
> 		} else
> 			return blk_status_to_str(result)
> 	} else
> 		return result;
> 
> This has similar issues as #0 where we have to convert before returning to
> userspace.
> 
> 
> Note: In this case, if the block layer uses an -Exyz error code there's not
> BLK_STS for then we would return -EIO to userspace now. I was thinking
> that might not be ok but I could also just add a BLK_STS error code
> for errors like EINVAL, EWOULDBLOCK, ENOMEM, etc so that doesn't happen.
> 
> 
> 2. We could do something like below where the low levels are not changed but the
> caller converts:
> 
> sd_pr_command()
> 	/* no changes */
> 
> lio()
> 	result = ops->pr_register()
> 	if (result > 0) {
> 		/* add some stacked helper again that goes through dm and
> 		 * to the low level device
> 		 */
> 		if (bdev == SCSI) {
> 			result = scsi_result_to_blk_status(result)
> 		else
> 			result = nvme_error_status(result)
> 
> 
> This looks simple, but it felt wrong having upper layers having to
> know the device type and calling conversion functions.

Has it been considered to introduce a new enumeration type instead of 
choosing (0), (1) or (2)?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

