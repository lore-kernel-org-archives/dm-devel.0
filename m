Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C65C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 23:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658964687;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vF3FZEGuiQFNckcCJu7BK9S3j6PZuMp+wqahaeGBElc=;
	b=X4O8SdNt4tby0xFKv7Ttw09MayboiTjZ30C7b8vuwOcugorumnHdzLQIDne5zKKHDI8jHO
	V62gVGLEB+ijaSIHnn28WesXsdbfgQsFYwTFdI0TeC9g/wxkPyDzLK+wFEGaQ+CYNJic+y
	ix1l2ejHheQh4sMSpekxxHde7AglUaQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-9E-iMlESMaaoeX22hXqpZw-1; Wed, 27 Jul 2022 19:31:26 -0400
X-MC-Unique: 9E-iMlESMaaoeX22hXqpZw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BD2F3802121;
	Wed, 27 Jul 2022 23:31:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2BDD42026D64;
	Wed, 27 Jul 2022 23:31:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E21FE1945DAF;
	Wed, 27 Jul 2022 23:31:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C1351945DA7
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 23:19:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F65E1121319; Wed, 27 Jul 2022 23:19:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B5C41121314
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 23:19:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71B91800124
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 23:19:44 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368--b585lq6PJWEix27SWQNlA-1; Wed, 27 Jul 2022 19:19:42 -0400
X-MC-Unique: -b585lq6PJWEix27SWQNlA-1
Received: by mail-pj1-f48.google.com with SMTP id e1so422975pjl.1
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:19:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=kOepgtwcdLQRP/qRZeoxPArZsGP7iFtltMUiXWZxlTA=;
 b=VFInpzsNmdDMygQKWQScgqheZIkGq1sfyfJXqWjl7nAgpp+8yAm9H7pFS/Hswe+Rcv
 Dp5iNozJFp/ESqsLZFzMDBSfNxnlDb4Maigqv9ueUled/cHJSguFbYCHbVH+pexXqRk6
 yddsvqZsdIXYAR3tv/eruKqIQN0pLcwMxPxAx3NMi+EVUtgWkF0PFT/0MoBYO3sz3ter
 ZN18e9L3qW8wlXLT44ZRTl7ou1y/gmVQKVfb4Exud41odtR6pw1v0pyMoHH/ijukh76N
 ExTLhKiGfTEpkvyYmdxgs6n4zSfZjb2ct0OAOWI5+H02bP5aZ851GZG8xOo4CnHrl+tJ
 +ZQQ==
X-Gm-Message-State: AJIora+stsmk55GfLF1E7e+NtP6C3YPFFvBXetVlKx1bL+8XVP/E8M/G
 rfzRMctk79xT86UoqlU18iQ=
X-Google-Smtp-Source: AGRyM1v4arIrU8OrBsKV8oknRZWNQ7p4sPrLDkPKFw6Y11E+aVKagxx/UxaZflYaD5XeZX1L1eA7ig==
X-Received: by 2002:a17:903:2282:b0:16c:500f:b78e with SMTP id
 b2-20020a170903228200b0016c500fb78emr23736794plh.49.1658963981476; 
 Wed, 27 Jul 2022 16:19:41 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a84e:2ec1:1b57:b033?
 ([2620:15c:211:201:a84e:2ec1:1b57:b033])
 by smtp.gmail.com with ESMTPSA id
 q13-20020a65684d000000b00419cde333eesm12516908pgt.64.2022.07.27.16.19.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Jul 2022 16:19:40 -0700 (PDT)
Message-ID: <51255650-ddc2-4f3d-52e5-14007b9ff538@acm.org>
Date: Wed, 27 Jul 2022 16:19:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, damien.lemoal@opensource.wdc.com,
 hch@lst.de, axboe@kernel.dk, snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <CGME20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754@eucas1p1.samsung.com>
 <20220727162245.209794-1-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 00/11] support non power of 2 zoned device
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 7/27/22 09:22, Pankaj Raghav wrote:
> This series adds support to npo2 zoned devices in the block and nvme
> layer and a new **dm target** is added: dm-po2z-target. This new
> target will be initially used for filesystems such as btrfs and
> f2fs that does not have native npo2 zone support.

Should any SCSI changes be included in this patch series? From sd_zbc.c:

	if (!is_power_of_2(zone_blocks)) {
		sd_printk(KERN_ERR, sdkp,
			  "Zone size %llu is not a power of two.\n",
			  zone_blocks);
		return -EINVAL;
	}

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

