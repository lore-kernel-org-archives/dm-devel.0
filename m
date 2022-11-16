Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27CA2C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 21:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668633577;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IJnK67W1RRRGSCPxvepzI9mFTf4SkQK5frZKh7IGUMA=;
	b=VIkNPT6dfl1ejnO0SGDsvpZhrDaqcsF8g/zleLuFo3n8xXrMk+yEz/Z7UCfcMprd1c9Udi
	fmv6+ndLTHeaU/Swt7ZF+maGFONuDYFMgyjJEv2i0K6wONn54OhPUVfNf9gIWo+MRVhkwg
	zZjX+Mw+4eT8m15kUDTCYfQQT+AYCFE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-fnAV3Sy6MiePnhE_k6VPZQ-1; Wed, 16 Nov 2022 16:19:33 -0500
X-MC-Unique: fnAV3Sy6MiePnhE_k6VPZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2030C29ABA18;
	Wed, 16 Nov 2022 21:19:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7DB251121314;
	Wed, 16 Nov 2022 21:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CAA719465A3;
	Wed, 16 Nov 2022 21:19:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ABEB219465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 21:19:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 749772166B30; Wed, 16 Nov 2022 21:19:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D4AB2166B29
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:19:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 498B01C0518C
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:19:27 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-414-1q0j-WlcMK65vqrXjksh0w-1; Wed, 16 Nov 2022 16:19:26 -0500
X-MC-Unique: 1q0j-WlcMK65vqrXjksh0w-1
Received: by mail-qt1-f197.google.com with SMTP id
 n12-20020ac85a0c000000b003a5849497f9so14297269qta.20
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 13:19:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=vCYGmyLDobaOWhMO5cqt6VIfl5tBZ1SXgoRZ3UG9G7A=;
 b=EiDkckdlKc+YeSJmGE2a9UEz/EVfQwbhs9KrKNU8v9dosfLvUYOBbt0HVGNa73ZsKA
 +ytzUi372qGIQlRrv1Zr+V0Mi0LeENGJcxckLXKlxN2M+OiYD9WDQDBae0QlCkJHKr0F
 4kZXQy1NGsPwhkjFAja+n6zpZuhpJ2RbKy9o7usda/sK49Yh5+m0USD9C2eXK0EtqoQL
 XV7cauuJhBZiBxwjiRDdPKjeRLsc8ffJV5jG/j3R4E5eVj/AfNmOZ8emdzzYR3yJbpQt
 lglbqLEjpmENdm1ulCit4LYqtlbadbdgfdUYkMVWUgdZm+uNyY9xDPr9aVvUFpG5OGl3
 Vbwg==
X-Gm-Message-State: ANoB5pkyhmmlWF6WS0BXWCYJx+U8RpjDUnwHYIzYhcF40/W45N4kN82x
 s6iz0h3UlPc5I0ee1Y9PTY1t4VvuGvhU+Cjq8R92vv+TYDo/Deivf5ykfEQKCxh7gaRMpP8fmUD
 gdf6LaGL4+kFBtw==
X-Received: by 2002:ae9:e00a:0:b0:6fa:dde:394b with SMTP id
 m10-20020ae9e00a000000b006fa0dde394bmr20880853qkk.265.1668633565301; 
 Wed, 16 Nov 2022 13:19:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf79d3ufTC3euri2dfEG/6gEWLrTi+hGugOKpv+coUCcCq4MU9SJtMQwDTIFAPdLoCphODrNwg==
X-Received: by 2002:ae9:e00a:0:b0:6fa:dde:394b with SMTP id
 m10-20020ae9e00a000000b006fa0dde394bmr20880827qkk.265.1668633565092; 
 Wed, 16 Nov 2022 13:19:25 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bj17-20020a05620a191100b006cfc1d827cbsm10879419qkb.9.2022.11.16.13.19.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 13:19:24 -0800 (PST)
Date: Wed, 16 Nov 2022 16:19:23 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <Y3VT22zmwOlrxdsw@redhat.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
 <20221115141054.1051801-4-yukuai1@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20221115141054.1051801-4-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v3 03/10] dm: cleanup open_table_device
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
Cc: axboe@kernel.dk, yi.zhang@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 yukuai3@huawei.com, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 15 2022 at  9:10P -0500,
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> Move all the logic for allocation the table_device and linking it into
> the list into the open_table_device.  This keeps the code tidy and
> ensures that the table_devices only exist in fully initialized state.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

