Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E091ECAAA2
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 21:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661464196;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LxnO4M7DZPeFr0Q2MZtfj0Jh6DHgMJdJmLrFqssnE54=;
	b=b3mQf3n9vTLhpMO9/P2IqidvmqjUzBnD1SxVCSPACP7kP6IoxATQ88B0TFmLHAHWTBXE0Q
	H0+4WZWmUdSh+gmGRG2DbxxqaKFyhTLH2sfRQYyJyaKBsdu+b0uUb8L3itWfOS4HgZzfuw
	+iE/G4aFkQhxoEH55BZePheGfdshJM8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-_WYYhWZvPNS1TR3DbsieRw-1; Thu, 25 Aug 2022 17:49:53 -0400
X-MC-Unique: _WYYhWZvPNS1TR3DbsieRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 978863800C20;
	Thu, 25 Aug 2022 21:49:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 860112166B26;
	Thu, 25 Aug 2022 21:49:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7185C1946A5A;
	Thu, 25 Aug 2022 21:49:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFB171946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 21:49:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC9621415117; Thu, 25 Aug 2022 21:49:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A8C6F141510F
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:49:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 910FF8032E3
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:49:49 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-487-1BhwIV3pPKCeroyLV3q2ug-1; Thu, 25 Aug 2022 17:49:47 -0400
X-MC-Unique: 1BhwIV3pPKCeroyLV3q2ug-1
Received: by mail-pg1-f176.google.com with SMTP id v4so18988865pgi.10;
 Thu, 25 Aug 2022 14:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=xfbE5Vo/QzRDekgWPSBG92uSVviACIBSqkJfH4RN/VA=;
 b=SkiSmUKoidH2ODWl+2Hpfer4tarGuKMnoupqBzHcNj6N+G1VEno8SA36MNl6/wixC4
 NBjvSTHx/PrMc0EtFrTwVTX7e1My7funxNQrPwC1n21QY7MmTJ+CRJC6GR8R9QyZ8CyW
 30fLdbEGgvU6fSIZIyOQ23fc1zjXypImFlo+4OY4Iy+OSlUBeBQJ225J1XULdU7YwLh/
 L3EslGvslXGLipZvBRgQ7oMZi/XKYnIKKI4eZTREWr3jaQWljdSe2oz980e46gA8D9R0
 Ca5jLaLvHokFt2l/iVkqO4QDWSaGUWOkQlL/Ttync5zntdlzV2oCOG1Irj94uiJkkE9G
 frPg==
X-Gm-Message-State: ACgBeo34CGd2ACgX3QQJZfYJbf6tTRBQ+ItUmuFCDuHlBNHU8Nkxgrh2
 s0+tZUsK6Rr9woBE02TZtA7RdbyglbMaNQ==
X-Google-Smtp-Source: AA6agR73sSARbZPf4AXnzwJxFf85IRxa5zkDqZRlix4b3E0h6AybGGg3LFAG7lL0NOTwlkG6OZE2SQ==
X-Received: by 2002:a05:6a00:1943:b0:536:2bef:2f93 with SMTP id
 s3-20020a056a00194300b005362bef2f93mr931782pfk.34.1661464186761; 
 Thu, 25 Aug 2022 14:49:46 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:349c:3078:d005:5a7e?
 ([2620:15c:211:201:349c:3078:d005:5a7e])
 by smtp.gmail.com with ESMTPSA id
 ik19-20020a170902ab1300b0016d9a17c8e0sm52556plb.68.2022.08.25.14.49.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Aug 2022 14:49:46 -0700 (PDT)
Message-ID: <d4f7f08a-e55b-c1a3-52b3-210b9f5b0a43@acm.org>
Date: Thu, 25 Aug 2022 14:49:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, agk@redhat.com, snitzer@kernel.org, 
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com, hch@lst.de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121907eucas1p27664a441113cb557af8fce3ef2800e34@eucas1p2.samsung.com>
 <20220823121859.163903-7-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220823121859.163903-7-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v12 06/13] null_blk: allow zoned devices with
 non power-of-2 zone sizes
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
Cc: pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/23/22 05:18, Pankaj Raghav wrote:
> Convert the power-of-2(po2) based calculation with zone size to be generic
> in null_zone_no with optimization for po2 zone sizes.
> 
> The nr_zones calculation in null_init_zoned_dev has been replaced with a
> division without special handling for po2 zone sizes as this function is
> called only during the initialization and will not be invoked in the hot
> path.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

