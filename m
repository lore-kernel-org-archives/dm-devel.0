Return-Path: <SRS0=KYOW=J2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF0EC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 16:33:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BDF966144B
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 16:33:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDF966144B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-9RUxmI1RNG6zvWiOsw2tgg-1; Thu, 29 Apr 2021 12:33:12 -0400
X-MC-Unique: 9RUxmI1RNG6zvWiOsw2tgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21A5679EE2;
	Thu, 29 Apr 2021 16:33:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B62E761D2D;
	Thu, 29 Apr 2021 16:33:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1458C1809C82;
	Thu, 29 Apr 2021 16:33:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13TGX25T015144 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 12:33:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DADA36EF48; Thu, 29 Apr 2021 16:33:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com
	(mimecast05.extmail.prod.ext.phx2.redhat.com [10.5.110.76])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB2546EF45
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 16:32:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FA6C8CD568
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 16:32:50 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
	[209.85.210.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-569-AMHWws-0Mpu_A6dmoM8_gw-1; Thu, 29 Apr 2021 12:32:45 -0400
X-MC-Unique: AMHWws-0Mpu_A6dmoM8_gw-1
Received: by mail-pf1-f169.google.com with SMTP id c17so11851842pfn.6;
	Thu, 29 Apr 2021 09:32:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=72+Cc6T4xP5R5z04O6kd3PBMqN7qS9j9xNJ870+HsVI=;
	b=QhgSt8iMU5VATCVlqzsH24HlDw9PtJKCV3dmnLzyv5AT309A5hB8+ttyK3VL8UKeb8
	YRYuHTkEoO08mdAhEcrl8y3SNktDxCnyAGJ0hXzF/u7X2hRxjEsnAIB4kgtChHxQQGmc
	7RISyOZ5u1FcT9ZrxjSMyZnGV2CeU8VjO5KupEP6dGXaewe/qESqIFDcp7tvc18/9M9V
	G5tWTpnvX0qFQpw994DZI2dkxU91XIHcAJ1e2AQ/dkUustQHql0u73XUs9iFFo3ma/62
	INyTdx48f7AzmXL2cJi7Ka4URvO1K+MXHiHCByV/qKUSglVkUHplgSnMT3wHvQjSuJgH
	11Ug==
X-Gm-Message-State: AOAM530a51P/UF9P+m+dUvnz5jd8TeCe+zR4yInhityeqsQ7Fmdu6BL/
	dIxJREtJ+gOgLvrnw3D+irg=
X-Google-Smtp-Source: ABdhPJxejEeB2ERB9+lgoeX9VzM1IMRWXXqe79GCx+E0bsl7sn43fSOjlJzAt+ysTY9IIm+cHOEGsg==
X-Received: by 2002:a62:86c3:0:b029:261:5933:e47b with SMTP id
	x186-20020a6286c30000b02902615933e47bmr826245pfd.34.1619713963758;
	Thu, 29 Apr 2021 09:32:43 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19])
	by smtp.gmail.com with ESMTPSA id z13sm390714pgc.60.2021.04.29.09.32.42
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 29 Apr 2021 09:32:42 -0700 (PDT)
To: mwilck@suse.com, Mike Snitzer <snitzer@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
	Hannes Reinecke <hare@suse.de>
References: <20210429155024.4947-1-mwilck@suse.com>
	<20210429155024.4947-3-mwilck@suse.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <5d1967f2-8017-c711-dec0-3ffe751974de@acm.org>
Date: Thu, 29 Apr 2021 09:32:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210429155024.4947-3-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [dm-devel] [RFC PATCH v2 2/2] dm: add CONFIG_DM_MULTIPATH_SG_IO
 - failover for SG_IO on dm-multipath
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/29/21 8:50 AM, mwilck@suse.com wrote:
> +	if (hdr.dxfer_len > (queue_max_hw_sectors(bdev->bd_disk->queue) << 9))
> +		return -EIO;

How about using SECTOR_SHIFT instead of the number 9?

> +		/*
> +		 * Errors resulting from invalid parameters shouldn't be retried
> +		 * on another path.
> +		 */
> +		switch (rc) {
> +		case -ENOIOCTLCMD:
> +		case -EFAULT:
> +		case -EINVAL:
> +		case -EPERM:
> +			goto out;
> +		default:
> +			break;
> +		}

Will -ENOMEM result in an immediate retry? Is that what's desired?

> +		if (rhdr.info & SG_INFO_CHECK) {
> +			int result;
> +			blk_status_t sts;
> +
> +			__set_status_byte(&result, rhdr.status);
> +			__set_msg_byte(&result, rhdr.msg_status);
> +			__set_host_byte(&result, rhdr.host_status);
> +			__set_driver_byte(&result, rhdr.driver_status);
> +
> +			sts = __scsi_result_to_blk_status(&result, result);
> +			rhdr.host_status = host_byte(result);
> +
> +			/* See if this is a target or path error. */
> +			if (sts == BLK_STS_OK)
> +				rc = 0;
> +			else if (blk_path_error(sts))
> +				rc = -EIO;
> +			else {
> +				rc = blk_status_to_errno(sts);
> +				goto out;
> +			}
> +		}

Will SAM_STAT_CHECK_CONDITION be treated as an I/O error? Is that what's
desired? If not, does that mean that scsi_result_to_blk_status()
shouldn't be used but instead that a custom SCSI result conversion is
needed?

If __scsi_result_to_blk_status() is the right function to call, how
about making that function accept the driver status, host status, msg
and SAM status as four separate arguments such that the __set_*_byte()
calls can be left out?

> +			char *argv[2] = { "fail_path", bdbuf };

Can the above array be declared static?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

