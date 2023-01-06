Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BEB1C54EBD
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 22:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673044788;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=owvjI3FsE5Nxn2qzFTqALZM61WueYjXUr31WN5jas2Q=;
	b=YR/IX/T1K52YPF3/KH/Arbpd0E43iKhsbzdGkjE1frAshhntaaLLppUGWrl9daYOZz7KCD
	jL4nkb/PKXuxrdTIVWfZuksUJgMh56XH6/nWC5mG+xIcrED8FjMqppJ8FqlnV3xDie69Fn
	MfgbkTjG0uIIfOrjmU8N7Pj8gC7FWwk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-dXJ3AhezPGCzEAq6DtEvWQ-1; Fri, 06 Jan 2023 17:39:45 -0500
X-MC-Unique: dXJ3AhezPGCzEAq6DtEvWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A61D02A59566;
	Fri,  6 Jan 2023 22:39:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93B0C2166B30;
	Fri,  6 Jan 2023 22:39:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 82A34194707F;
	Fri,  6 Jan 2023 22:39:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6F0C51946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 22:39:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5CAA240C2004; Fri,  6 Jan 2023 22:39:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 54E5540C2064
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 22:39:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A47E2805582
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 22:39:42 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-636-J52gsO_0OO-rQGjl6HxSZQ-1; Fri, 06 Jan 2023 17:39:40 -0500
X-MC-Unique: J52gsO_0OO-rQGjl6HxSZQ-1
Received: by mail-pj1-f54.google.com with SMTP id n12so2914025pjp.1
 for <dm-devel@redhat.com>; Fri, 06 Jan 2023 14:39:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=9wllrSnnUtP2lGzMZ5NnJc5XBcURZs1X9kJ2O+mtnmI=;
 b=gIoS++PTpoRmISAj0/BpL+dzGQ0avM9PhhXJhY/Za30MgfI2+JkaJs3JTSTzJbmuBF
 q3FxTNVisgl49eisLC1G6HPeNAz5jgX+M1LgEz2bjTPPlAjit/7FGkTIZptzNXEPHUOp
 Do7uJEjmWD3fMfIeQGxnDOhifiLuoXLxgVtsw/I91AqPx97Yrkl4KA3XQXLCPe3qPZHZ
 udOBnVDu9C/Ql/EbfmFS/20gaWSPqc3RkOEmddwyzyZ83vGzEPHTPf5oB+RD01Vg15Pq
 +n2UVv/7vS9AzgRWxVZY7OWYn3Dtv4n3J5CJoIyrgzqatUYqiZJKuffkOMxWF42toIRX
 n9Rg==
X-Gm-Message-State: AFqh2koJ+aE+s7Wqq7C1UBSvjxaOlKuFfpX8htKFbd9SQU9TYXOQHHgV
 CrKmi9+nLa6yUVAaDq0vAAo=
X-Google-Smtp-Source: AMrXdXuMcgHd17Og+hOTPa7FzU9kTPhBKiF/SMXTbwL3fZXTnntDEJhZH/XSa/hH2zGddJvohv5qng==
X-Received: by 2002:a17:902:f7c2:b0:192:6cc9:922 with SMTP id
 h2-20020a170902f7c200b001926cc90922mr43243418plw.59.1673044779250; 
 Fri, 06 Jan 2023 14:39:39 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:23c3:f25b:a19d:c75a?
 ([2620:15c:211:201:23c3:f25b:a19d:c75a])
 by smtp.gmail.com with ESMTPSA id
 u11-20020a170902e80b00b00174c0dd29f0sm1410874plg.144.2023.01.06.14.39.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Jan 2023 14:39:38 -0800 (PST)
Message-ID: <1484d284-e55e-4e3d-b4fc-5a685002c656@acm.org>
Date: Fri, 6 Jan 2023 14:39:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083320eucas1p1d23de4ad21d0a7aecb74c549ebc7757c@eucas1p1.samsung.com>
 <20230106083317.93938-4-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230106083317.93938-4-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 3/7] nvmet: introduce bdev_zone_no helper
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
Cc: gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/6/23 00:33, Pankaj Raghav wrote:
> A generic bdev_zone_no() helper is added to calculate zone number for a
> given sector in a block device. This helper internally uses disk_zone_no()
> to find the zone number.
> 
> Use the helper bdev_zone_no() to calculate nr of zones. This let's us
> make modifications to the math if needed in one place.

Please use the imperative mood in patch descriptions (... is added -> 
add ...).

let's -> lets

If these two issues are addressed, please add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

