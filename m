Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0669C25B08
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 19:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660073191;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BZrZnMTri0IH8h6EwN2N7rdurspSpE/IpjP7LP15FXs=;
	b=IVKr1y5t8wBLnv4+MNpFborYF7mfBkMmFKo/whU3+9S6QMKS+Gt1FMrZ3uJ8uYpJUYdk7z
	VK6/HSd1hcGhWKN5Rr7ofjSP1kMW2P5J1vCJJ9cjl98UeaXDfwY9khBJJsipPQNtcTpJJr
	U7IJYcZbUy9lrxzZaN19XyoKQrD9ypQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-EIVQdFiLPB6balVAsv-qIA-1; Tue, 09 Aug 2022 15:26:28 -0400
X-MC-Unique: EIVQdFiLPB6balVAsv-qIA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B338685A58A;
	Tue,  9 Aug 2022 19:26:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 733942166B29;
	Tue,  9 Aug 2022 19:26:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2540C1946A4D;
	Tue,  9 Aug 2022 19:26:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 437AA1946A4C
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 19:26:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ECB6D1121319; Tue,  9 Aug 2022 19:26:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E8C491121315
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 19:26:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDF8F29AB40E
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 19:26:24 +0000 (UTC)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-ud4H5VMWMx6849toOsKrrg-1; Tue, 09 Aug 2022 15:26:22 -0400
X-MC-Unique: ud4H5VMWMx6849toOsKrrg-1
Received: by mail-pg1-f181.google.com with SMTP id f65so12234593pgc.12
 for <dm-devel@redhat.com>; Tue, 09 Aug 2022 12:26:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=+xNHl7PxIkebq0wdnJhmzor8UqQwWVZACiymdJlxbdU=;
 b=6V0FBu/0eoH4E98zsQo1bejIIFBnJ6fYmmSQYg+FzLysMlhjC5EtH791Va54Q2q0F2
 P50a6cK/qRVpm9eM/LkdZmrjdKKgAEQzhMmxKjVeVayjKGsszwr3VO9FxJo1u9IMMzjr
 sQkFcjXzq26z+L0MDreup7cktzHSpYBQOtjLb2pOntwrMVr5XNkAk31zSbDok//illxd
 RvFtOi9M6EKwA98Rm/l+HTied9n4UA7St9WDKQKCR5m7TiPUH7othE1wYxtUo4taI+Nn
 I/C/zl/D6guJ1Astr9+JBhNG743RSizm/O4Fwx9M7EwEamBsnSVjb7a33yXobf4ogjyW
 gznQ==
X-Gm-Message-State: ACgBeo34lwX7dV5tqjjVDp7siMsWmk+h/zIbimrkD0qDWhBeSP4rviZr
 U/orlvHXdKBnHnLAKy+pAw0=
X-Google-Smtp-Source: AA6agR5+riNI8OSebOu0oK1S+2g9jxFt9EqMM52CmaUet8riLT+K1RsKhbZTtmktwZP+gN3LNaDlCw==
X-Received: by 2002:a65:6d98:0:b0:41d:d9:a338 with SMTP id
 bc24-20020a656d98000000b0041d00d9a338mr17501281pgb.421.1660073181028; 
 Tue, 09 Aug 2022 12:26:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d?
 ([2620:15c:211:201:61e9:2f41:c2d4:73d])
 by smtp.gmail.com with ESMTPSA id
 d6-20020a170902654600b0016a3f9e4865sm11221917pln.148.2022.08.09.12.26.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Aug 2022 12:26:20 -0700 (PDT)
Message-ID: <a3117849-420b-65fb-dafa-c2a464482f7b@acm.org>
Date: Tue, 9 Aug 2022 12:26:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Christie <michael.christie@oracle.com>, linux-block@vger.kernel.org, 
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-5-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220809000419.10674-5-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 04/20] scsi: Add support for block PR read
 keys/reservation.
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/8/22 17:04, Mike Christie wrote:
> +static int sd_pr_in_command(struct block_device *bdev, u8 sa,
> +			    unsigned char *data, int data_len)
> +{
> +	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
> +	struct scsi_device *sdev = sdkp->device;
> +	struct scsi_sense_hdr sshdr;
> +	u8 cmd[10] = { 0, };
> +	int result;

Isn't "{ }" instead of "{ 0, }" the preferred way to zero-initialize a 
data structure?

> +
> +	cmd[0] = PERSISTENT_RESERVE_IN;
> +	cmd[1] = sa;

Can the above two assignments be moved into the initializer of cmd[]?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

