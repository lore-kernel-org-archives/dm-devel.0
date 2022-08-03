Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB79FC19F2C
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659547368;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e0LNc+UKfJCJg6RiDOrp8YybMceS1WXr5FYNXckNYnE=;
	b=DBkpPzR/5nGn+lJSs4mdfp4fGzhQJSuTHG9SwAXRX/oumw+ryslYxyF0Vcb9Jq5M9caQM9
	gnpl1sHRFvBlSo15DatXjCHgz8RNt5/pOqWOaLb857Aix6WecHE1oViedjKWUBrgVl0fBU
	uzZtWbVIPYS39twKyPKAzNJ6EBSmH98=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-VaERomKhPHSp8gnOlzPijQ-1; Wed, 03 Aug 2022 13:22:47 -0400
X-MC-Unique: VaERomKhPHSp8gnOlzPijQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E2E8185A7B2;
	Wed,  3 Aug 2022 17:22:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 795531415116;
	Wed,  3 Aug 2022 17:22:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 063031947B97;
	Wed,  3 Aug 2022 17:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D31E1947B97
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 17:22:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3DA840CFD0B; Wed,  3 Aug 2022 17:22:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF6BC40CFD0A
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:22:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6B6338041E4
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:22:42 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-gOam6AQUMgivJgdJAPV4oQ-1; Wed, 03 Aug 2022 13:22:37 -0400
X-MC-Unique: gOam6AQUMgivJgdJAPV4oQ-1
Received: by mail-pj1-f42.google.com with SMTP id b4so6974713pji.4;
 Wed, 03 Aug 2022 10:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=81PY4yBEEjUXxYOBG5CambynNE+HXFQDS99frEnDmrs=;
 b=kztufo3/PdgzjB9kmP5pKKMVA0cOL8AlxhoIWsj7tDsLPpTE0QlhQgzK01PeZBIeEB
 XTShC5TVmxZxZTJ8OKkWx+zHTZyvyB1WyO19JZ1Y8uIGjuwdpnWmUy0pZVTVH5V6YqQk
 0ftEwzDO8905Png/KfaQJeN9u6kAkDjD64exEfbiZQH2s/FAqiP04xzXl7Caz/ijLqtE
 vTswyaGaEn7HvGZaeZHNfRVWuSLrzsUUZtUVmZsbCll7Y/v3SwO6DtXE3cWN8QSiNhCj
 U8f67jImzL46AkjmAuQZGjqVQrE1xxBoxGSMwhr8hFfpFh8H2U7zaI5c+O32Xi9juChg
 WgMA==
X-Gm-Message-State: ACgBeo3fz/r2lUyqAC0Cp2W14E23rM8aWJ9vXUTXlOhCukexUbRLKIYl
 qqU5Xym3bUFjWXXSYlzY01Y=
X-Google-Smtp-Source: AA6agR4qAuR4iHmzSPdpkQ3mxXc1SGakIYA1aA7y7JsrpsmrjJ0SDtdisB5YYBMJ0qKrjfikQnBjiQ==
X-Received: by 2002:a17:902:f54e:b0:16f:206b:74cc with SMTP id
 h14-20020a170902f54e00b0016f206b74ccmr1132384plf.170.1659547355934; 
 Wed, 03 Aug 2022 10:22:35 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:db71:edb7:462a:44af?
 ([2620:15c:211:201:db71:edb7:462a:44af])
 by smtp.gmail.com with ESMTPSA id
 l7-20020a170903244700b0016cd74dae66sm2275344pls.28.2022.08.03.10.22.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 03 Aug 2022 10:22:35 -0700 (PDT)
Message-ID: <2616b59b-8c6b-a482-a396-d9408fa461a3@acm.org>
Date: Wed, 3 Aug 2022 10:22:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527@eucas1p1.samsung.com>
 <20220803094801.177490-6-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220803094801.177490-6-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v9 05/13] nvme: zns: Allow ZNS drives that
 have non-power_of_2 zone size
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
 dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/3/22 02:47, Pankaj Raghav wrote:
> -	sector &= ~(ns->zsze - 1);
> +	/*
> +	 * Round down the sector value to the nearest zone start
> +	 */
> +	div64_u64_rem(sector, ns->zsze, &remainder);
> +	sector -= remainder;

Could bdev_offset_from_zone_start() be used here?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

