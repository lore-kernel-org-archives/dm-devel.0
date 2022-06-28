Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB0CCCA47C
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 07:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656487869;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tbtSL7au9LAdZ2Dv0pSrObmOyfUWvQn+317V/IvO4ng=;
	b=FH+rkp7HEjnnZt0PmZWnpPcpiIT1dXtzZSc5B5Ber+xi015FiHB4R2NfpCUvZIQC2uHcpJ
	SdU/Bjs10i0UL6eASThJfueaQkOg9YfVuLxps8Zlz7O60SNCdHGMyUeECzWcNGrcQjBFPe
	1dh/KZKjPB/sZ4Rx530N+G6OKPCuDAA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-wIgDwJWXMmqehMrMMTyTVw-1; Wed, 29 Jun 2022 03:31:05 -0400
X-MC-Unique: wIgDwJWXMmqehMrMMTyTVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B3D01019DE0;
	Wed, 29 Jun 2022 07:31:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 754E39D7F;
	Wed, 29 Jun 2022 07:31:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E8CB1947068;
	Wed, 29 Jun 2022 07:31:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 29E4619466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 16:16:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E06C4010150; Tue, 28 Jun 2022 16:16:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A0C540466A4
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 16:16:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E69761C01B58
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 16:16:17 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-qnPIdDz6PmSSrFGVbEmI1Q-1; Tue, 28 Jun 2022 12:16:15 -0400
X-MC-Unique: qnPIdDz6PmSSrFGVbEmI1Q-1
Received: by mail-qv1-f48.google.com with SMTP id c1so20699209qvi.11;
 Tue, 28 Jun 2022 09:16:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fkrHLl+pC0T2wzEqJ1VmdS709M7bO1Mk3oguAYoCHsA=;
 b=24+XVJHzPWp/PMhpWMdLOJOulvWnJF5NL9hSF9w5RnJd8Rz9kfMNWJpgvPcaf6XFwp
 Vc/UlXGqATWQm13d0RBTyjR0w9WYtqP19Gm7+tPGw/djanZS6X8HWFqlP2yr7rWeA78d
 bxZLR+UvLSBCkLvt3cJ4YTrXklte6hpfzi8oz1Uzew784KCtBzi6GPspxz8UOY1eKG6B
 n3zFh7kKEIPOluXRSfXGiXzK9xb48l8AFxIL80AypRaDLvgXu6sbSg+DI7oBs3MdRSzV
 8nX3DcE8bCufX7pIZRPY1GpbNhDI5u0l/GqkVrvNyVMp+jkizb/+qJfO+Hb1fgNKc9g5
 sx8w==
X-Gm-Message-State: AJIora9k5gW6ISNR2wYaPzfKIWLw/2S2Nw3fAuQJvKEjDBjPBsFjJ10Z
 Vs80xOBVhzDcXjL/LrIzz8YgWvnCl0wLvZCa4Q==
X-Google-Smtp-Source: AGRyM1sKkjEL7f9wSHLYpBtisYe/9DkZXLFCV6xhCzLO5Lsi0TS0+cJ3QYNT1nLShEcNWimNSwTK/w==
X-Received: by 2002:a05:622a:58d:b0:317:ca0d:91a5 with SMTP id
 c13-20020a05622a058d00b00317ca0d91a5mr13633763qtb.601.1656432974892; 
 Tue, 28 Jun 2022 09:16:14 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 w11-20020a05622a190b00b003162a22f8f4sm4312465qtc.49.2022.06.28.09.16.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 09:16:13 -0700 (PDT)
Date: Tue, 28 Jun 2022 12:16:12 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20220628161612.ajbyb723zx7w6b24@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <Yrqw/KY94DDtFVfl@T590>
MIME-Version: 1.0
In-Reply-To: <Yrqw/KY94DDtFVfl@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Wed, 29 Jun 2022 07:31:01 +0000
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 28, 2022 at 03:42:52PM +0800, Ming Lei wrote:
> I don't see there is 'queue depth' for bio or bio driver.
> 
> 32 bytes have been big, and memory footprint is increased too since the data has been
> prepared for the future possible rewind. If crypt or integrity is considered, it
> can be bigger.

Put some thought into this, Ming. I think you've absorbed some "received
wisdom", some of the implicit assumptions everyone seems to be making without
ever doing any math to check if they make sense.

There may not be a "queue depth" for all drivers, but the same latency
considerations apply - if you have an unbounded number of IOs in flight, you're
going to be having other, much more significant issues.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

