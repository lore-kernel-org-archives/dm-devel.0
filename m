Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A3F4C352A1
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 16:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670431777;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lNXqfxmZwMv0Fiue/lftREUrk8erwIJoGDVIc2mHAFw=;
	b=EWZlW+8kmEebGQy6ZtYXGm5v8eIyvnWeb//cW1Ejt30olH/fAkzq7+HJeQcbF97OByBrQx
	x97apmXoJzv50r9GN3qoRXlI52QLSk8Z2c6ysGM12baZ2ZoLZDH3phMsT3+YPjC7lCGa0x
	ql0PlNmE4W+oKr1TtRzyuRqczbaY9As=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-NoMasKbHOoeEcNqRlpEH8g-1; Wed, 07 Dec 2022 11:49:35 -0500
X-MC-Unique: NoMasKbHOoeEcNqRlpEH8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA000823F6E;
	Wed,  7 Dec 2022 16:49:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDC032166B26;
	Wed,  7 Dec 2022 16:49:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9819B19465B9;
	Wed,  7 Dec 2022 16:49:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 976CE19466DF
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 16:49:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 41AA740C2088; Wed,  7 Dec 2022 16:49:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 393AE40C206B
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 16:49:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E18A51035346
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 16:43:49 +0000 (UTC)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
 [209.85.166.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-j-zvLkTTOWarubAuGZXU_A-1; Wed, 07 Dec 2022 11:43:48 -0500
X-MC-Unique: j-zvLkTTOWarubAuGZXU_A-1
Received: by mail-il1-f172.google.com with SMTP id x11so7232966ilo.13
 for <dm-devel@redhat.com>; Wed, 07 Dec 2022 08:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kJ8Ay+PB284aY3NVmhw3n5NaBjbrOxQtEAJy+RGXMRM=;
 b=HCSpjFIMBZPwgXNo3BWOkgt8DryLDmz43mTxJpyr1BEIf9KlSskxS+dnZPrcd3xPQx
 UbgBZofMdpjEqmVLf6LjXzlzyHN4vrhq/cbpE5hvXpEKv/AYFdyXb8Jl2rm2hxa6KEDe
 f6CedS6Km6UtdYdczcmaRnNcFlJknUfjovCqo1xOEMqJrUH+2Zu7tP8Pt1a0UzrA/63G
 B+IYYRWEmrqIJoNGy+WXk2Je4LpDkKQ4uEM14YGG19emKGgteCPX2IuRF2OV6XI5Bi72
 uJ4dm1u/k8zYO+YCCNtCj1B/FgIHlgnK8bg1jSAs5nyb7bkDe0uGx+ncGJc0MEvpX1ru
 kmMA==
X-Gm-Message-State: ANoB5plFssuioEH8bzWDCXgbjklAtqeGGCj7wJkofsXrk+oMvAXHYX6T
 EPYlcgyqbF14SWIjJMUtawUAPA==
X-Google-Smtp-Source: AA0mqf7tWpWZtUh0xPnGJO9AZcQHA021bUAhGGmdDCkM2tthnOVB7XOHehMq1xO+VcDumIv8Vf9cvw==
X-Received: by 2002:a92:cc84:0:b0:302:489c:669 with SMTP id
 x4-20020a92cc84000000b00302489c0669mr34208447ilo.135.1670431427024; 
 Wed, 07 Dec 2022 08:43:47 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 e12-20020a0566380ccc00b003728cd8bc7csm7802731jak.38.2022.12.07.08.43.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Dec 2022 08:43:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: snitzer@kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20221206144057.720846-1-hch@lst.de>
References: <20221206144057.720846-1-hch@lst.de>
Message-Id: <167043142630.172966.3660102879335248846.b4-ty@kernel.dk>
Date: Wed, 07 Dec 2022 09:43:46 -0700
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] block: remove bio_set_op_attrs
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, colyli@suse.de,
 linux-block@vger.kernel.org, song@kernel.org, linux-bcache@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Tue, 06 Dec 2022 15:40:57 +0100, Christoph Hellwig wrote:
> This macro is obsolete, so replace the last few uses with open coded
> bi_opf assignments.
> 
> 

Applied, thanks!

[1/1] block: remove bio_set_op_attrs
      commit: c34b7ac65087554627f4840f4ecd6f2107a68fd1

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

