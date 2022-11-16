Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81438C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 20:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668629242;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lfekDImIs/xeiQxpYhDi9QRrZUmVDrTVvA4QbXgst8U=;
	b=V5OZ+dadPdng4COB+4cu7F1OvQ/++5rBX52lgzujfRleNLdRtAeh0OfaL7dJFzD0m6vFv/
	zafq32q5oM2k10cPb5Hzo5uAKI37XT034lkzELovq471ZXzuX/582pe0Gz0lcDnRR+Ie57
	YFQNp/ShzZkKZIYCOcobNCHLUB5pF80=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-itlQtqb3MUOQHmKFMXxo-w-1; Wed, 16 Nov 2022 15:07:19 -0500
X-MC-Unique: itlQtqb3MUOQHmKFMXxo-w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A2991C0514F;
	Wed, 16 Nov 2022 20:07:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4853D492B04;
	Wed, 16 Nov 2022 20:07:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF50B19465A3;
	Wed, 16 Nov 2022 20:07:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A8A119465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 20:07:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 451DD112132C; Wed, 16 Nov 2022 20:07:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E61E1121325
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 20:07:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CBFD101A528
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 20:07:16 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-DlmFA0UlNEK35rZzmLPKEw-1; Wed, 16 Nov 2022 15:07:14 -0500
X-MC-Unique: DlmFA0UlNEK35rZzmLPKEw-1
Received: by mail-qt1-f197.google.com with SMTP id
 c19-20020a05622a059300b003a51d69906eso13870840qtb.1
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 12:07:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=pyb9R3Z9t9f8WkvXA0nuu3YJepmBztVFz76Ik7BRpJA=;
 b=njC2YE7btl7xIPBPjqcw989L7KeLJED7HFKCH4TwRpwmeCQ+Ywy83WZiLHSwgKB7pB
 Smn4EvhnY7nVXa3waKkYHquDP+W+3Co7MNckFiANlLB9k1vGXcxAcfp8Z0SHu5MnEryJ
 4l1aZ0jcT+3ITjr2Ho5V/jQdR8S4UuDdMZbXG7SXNFyD5fZTmycoz7p2xfSInWl7f8r9
 UgAA2zXMguYK5ZPBue+NxZBwJFU3OW5kWZBmHkgaQkEIO5Sp5H6c3UHj/rdRWO0287T1
 pXUMRbJKhNdcA3lOATSItr4KK3g0wQmZPl9EM4oKXZvBIcW0NMhyhsTMWY50O59IWr0D
 iexg==
X-Gm-Message-State: ANoB5plbcZ8j5546BySbYzTO39zXcEhOtTZLmY3nteX/rboCi9R/yneV
 iqwIKH+DMqfqQ9h+0785XfJKx4avTbAy7ObwenDv1HctvsfCZ2OWA89MvdNNq41Oz8pDTCtpiBI
 dQvtDm9mRZLRkXg==
X-Received: by 2002:ad4:404d:0:b0:4b1:166:bd26 with SMTP id
 r13-20020ad4404d000000b004b10166bd26mr22167358qvp.21.1668629234531; 
 Wed, 16 Nov 2022 12:07:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7NSDvq8EIsPma17Eq/R3cpKE8X0kD6fDGjVmLxSHuH7Ap7Fm5PIdEa0EcdSMfpGQIjfXQKYg==
X-Received: by 2002:ad4:404d:0:b0:4b1:166:bd26 with SMTP id
 r13-20020ad4404d000000b004b10166bd26mr22167342qvp.21.1668629234296; 
 Wed, 16 Nov 2022 12:07:14 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 t19-20020ac865d3000000b003a527d29a41sm9173559qto.75.2022.11.16.12.07.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 12:07:13 -0800 (PST)
Date: Wed, 16 Nov 2022 15:07:12 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Keith Busch <kbusch@meta.com>
Message-ID: <Y3VC8MQaIN4oc1+V@redhat.com>
References: <20221110184501.2451620-1-kbusch@meta.com>
 <20221110184501.2451620-6-kbusch@meta.com>
MIME-Version: 1.0
In-Reply-To: <20221110184501.2451620-6-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCHv2 5/5] dm-log-writes: set dma_alignment limit
 in io_hints
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, mpatocka@redhat.com, stefanha@redhat.com,
 Keith Busch <kbusch@kernel.org>, me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 10 2022 at  1:45P -0500,
Keith Busch <kbusch@meta.com> wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> This device mapper needs bio vectors to be sized and memory aligned to
> the logical block size. Set the minimum required queue limit
> accordingly.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

