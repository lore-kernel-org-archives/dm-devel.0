Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 449C4C433EF
	for <dm-devel@archiver.kernel.org>; Sun,  5 Jun 2022 04:00:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-t7ED6h9XMq6eyUqyVaxTgQ-1; Sun, 05 Jun 2022 00:00:15 -0400
X-MC-Unique: t7ED6h9XMq6eyUqyVaxTgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E06B101A54E;
	Sun,  5 Jun 2022 04:00:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8D55EC35979;
	Sun,  5 Jun 2022 04:00:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 792BF1947056;
	Sun,  5 Jun 2022 04:00:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CDCB81947052
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Jun 2022 04:00:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE7D5C3597A; Sun,  5 Jun 2022 04:00:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B8E4EC35979
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 04:00:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A112180419A
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 04:00:12 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-8Mm6rnuEMZm4JenUIKZFHw-1; Sun, 05 Jun 2022 00:00:05 -0400
X-MC-Unique: 8Mm6rnuEMZm4JenUIKZFHw-1
Received: by mail-pl1-f180.google.com with SMTP id h1so9673874plf.11
 for <dm-devel@redhat.com>; Sat, 04 Jun 2022 21:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to
 :content-transfer-encoding;
 bh=u41z4fwr/UUMAFS3+mX3poOxe2IdRXrMg1LQj8AZaCg=;
 b=mJySUMSnx0kmtdnwc1TP3nI7ExIguVpwVDQvHGirsz2QfFvJ/sPAmwMAEiEDGthkMs
 OiVUBT/tMeL1UUzD/jAcChbHKvk0yMuErac952qbrwH22V8+cSiEmTHWS+cCrmrGtJts
 2m7kZ/e2eWtR0SJR2WAYnbjL59QBxA0TZtoQXh2IEIX8q1UPhlhqNZFXlY3MbWPN8RED
 aXr/oORw+9M3QVBY24kIonI2/Rb6LoKCs1kKCCGV892iETqf4FGxZM+XLBvmFa8Ccimv
 o9gUuPs/VAcuzO/b9lZ+lXqH9c9/92oefk1FvtnpNRT+9aWUWbm5NgR27tWk1sybvnfG
 +VOw==
X-Gm-Message-State: AOAM532pjAYJlK9POganKSlU0UWsI3jDFiE+Rpapk4kBHq7Z04aq3gCm
 unN/KCRUgVewjp8pt2zP6fA=
X-Google-Smtp-Source: ABdhPJyHCNfBXsPFIEQqA+e98Z3husOOJOYqpQ8J70F7LC0WRuf++Ip/Fo/IX19u9k26r7v91fC7UQ==
X-Received: by 2002:a17:90a:7f94:b0:1cb:1853:da1b with SMTP id
 m20-20020a17090a7f9400b001cb1853da1bmr18988161pjl.14.1654401604166; 
 Sat, 04 Jun 2022 21:00:04 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
 ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
 by smtp.gmail.com with ESMTPSA id
 k17-20020a170902d59100b0016242b71e9fsm7901182plh.158.2022.06.04.21.00.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 04 Jun 2022 21:00:03 -0700 (PDT)
Message-ID: <c026fa1e-cca1-08c3-5d99-81ec79d8d343@acm.org>
Date: Sat, 4 Jun 2022 21:00:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Mike Christie <michael.christie@oracle.com>, linux-block@vger.kernel.org, 
 dm-devel@redhat.com, snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220603065536.5641-10-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 09/11] block,
 nvme: Add error for reservation conflicts.
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/2/22 23:55, Mike Christie wrote:
> BLK_STS_NEXUS is used for nvme/scsi reservation conflicts and also
> general nexus failures. For the pr_ops use we want to know if an IO failed
> for specifically a reservation conflict so we can report that error upwards
> to a VM. This patch adds a new error code for this case and converts nvme.
> The next patch converts scsi because it's a little more complicated.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   block/blk-core.c          | 1 +
>   drivers/nvme/host/core.c  | 2 +-
>   include/linux/blk_types.h | 4 ++++
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index bc0506772152..3908ac4a70b6 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -171,6 +171,7 @@ static const struct {
>   	/* zone device specific errors */
>   	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
>   	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
> +	[BLK_STS_RSV_CONFLICT]	= { -EBADE,	"resevation conflict" },
                                                  ^^^^^^^^^^

Please fix the spelling of "reservation".

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

