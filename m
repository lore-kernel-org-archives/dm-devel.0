Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E774FC61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 19:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678131122;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CZ2yJK2hobcejaJlnK8ugvfl3DcDTJ170DfpVIcjBro=;
	b=Gkh8Y83DARtKoXuTjlu9zyDTgVjRvdCx2xqcksHmVuclCxineYZAvfBj49CDW7DxeGcoBH
	ba8ikf2i22qluzZnlPoj7+LRvSXOBhEJOCKbndzkax+JhWh7GR/F2D72judt7X8qxKOTmU
	Pi3f8LVjylCaovLmDumlodlVsGqch2M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-cT1QyM7WNvKDITx9dZbu5A-1; Mon, 06 Mar 2023 14:32:01 -0500
X-MC-Unique: cT1QyM7WNvKDITx9dZbu5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE07D18E0AC1;
	Mon,  6 Mar 2023 19:31:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B0272026D4B;
	Mon,  6 Mar 2023 19:31:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77DD5194658C;
	Mon,  6 Mar 2023 19:31:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 06DF61946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 19:31:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB1AB2166B2B; Mon,  6 Mar 2023 19:31:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3E692166B26
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 19:31:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5A1018E0AC1
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 19:31:53 +0000 (UTC)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com
 [209.85.160.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-P_kJ8h6uP_OoknxaiVScxQ-1; Mon, 06 Mar 2023 14:31:49 -0500
X-MC-Unique: P_kJ8h6uP_OoknxaiVScxQ-1
Received: by mail-qt1-f176.google.com with SMTP id cf14so11820603qtb.10
 for <dm-devel@redhat.com>; Mon, 06 Mar 2023 11:31:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678131109;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=FT0gVkmom0UxjUl8vBAZK7+V1WRebb0if8VgviA2UHI=;
 b=vLRUX1rmRQvXHcRQke/N5Yf3s/Byr5G8WfQ2CH6EMwyx5oxu/FoJyPhdFn17e1x3nN
 3Bq2vMXPeIGW7EIzeN20cON316FWmPM2Khy82qtFKONfwKjtDWWRlXkskTPHn5LkRz1V
 /v/AbfE7zp0jBB+gHLwY2OZR8ZlFLXxVGKLhagmdBv1yY/hmRVCdZbTFNH98tHC4aSDk
 rQnyyUl9iNAaWQbrxZl3hTREeugnBbR5fHrfPzAZgKYP0zAxZF9eGPHYjhixP60zwdA4
 3WKsIsPHVu43/HzWZEZqrV9oJS9RIhOxiAQuYqw35OrqT8ez1mZT8AXrf8Na1eCnrNgV
 nKJQ==
X-Gm-Message-State: AO0yUKXCTSMf5G9LTTWm8WG4Xy/EH5Sz2oC3+l2Cq1dsh9WoOy2YX4E6
 fxfQ8/Kk5iYoPg5+2fyRvRVhYFMzwfoTg/rLXgNi
X-Google-Smtp-Source: AK7set+4BUce3voOE0pK4zuN3f8Gsg0kwP96Q1jZXXZBfCpJK4J2hzKd34qRPINe3at3w5PjKmW1Ng==
X-Received: by 2002:a05:622a:387:b0:3bf:c29b:678b with SMTP id
 j7-20020a05622a038700b003bfc29b678bmr18818461qtx.50.1678131109092; 
 Mon, 06 Mar 2023 11:31:49 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 r7-20020ac85c87000000b003b9bc00c2f1sm8057244qta.94.2023.03.06.11.31.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 06 Mar 2023 11:31:48 -0800 (PST)
Date: Mon, 6 Mar 2023 14:31:47 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Hou Tao <houtao@huaweicloud.com>
Message-ID: <ZAY/o9ew9AtrCLE5@redhat.com>
References: <20230306134930.2878660-1-houtao@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20230306134930.2878660-1-houtao@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] dm crypt: initialize tasklet in crypt_io_init()
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
Cc: dm-devel@redhat.com, houtao1@huawei.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, Ignat Korchagin <ignat@cloudflare.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 06 2023 at  8:49P -0500,
Hou Tao <houtao@huaweicloud.com> wrote:

> From: Hou Tao <houtao1@huawei.com>
> 
> When neither no_read_workqueue nor no_write_workqueue are enabled,
> tasklet_trylock() in crypt_dec_pending() may still return false due to
> an uninitialized state, and dm-crypt will do io completion in io_queue
> instead of current context unnecessarily.

Have you actually experienced this?

> Fix it by initializing io->tasklet in crypt_io_init().

Really would rather avoid always calling tasklet_init(). But I can
optimize it away with a later patch.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

