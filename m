Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E361C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  2 Dec 2022 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670002330;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ErFPXQRUO4o1XBuBgVoosfeAOFjkh/cz7WAwMiu+0yE=;
	b=Y67Ne4MQ6yQsgc1b5czlteQX/cqqjKvWsx/+5QkyYl6jKZ3FkZ5chtbuK1T71pvSmjeKkQ
	sSYRodK1WmZOLsU7N+uRb9W7h/UfjuabK451uabdqfrNtQZ8pYKuCZubrubO7q/IrxEWZS
	C/GaIgxbLsJ48V64gzrs86Ohrt0VoV0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-EDPTt_2CPxuHf2DO2GtKSg-1; Fri, 02 Dec 2022 12:32:08 -0500
X-MC-Unique: EDPTt_2CPxuHf2DO2GtKSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C25BE85A588;
	Fri,  2 Dec 2022 17:32:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B7C4B111E3FA;
	Fri,  2 Dec 2022 17:32:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E240194658F;
	Fri,  2 Dec 2022 17:31:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 27AC01946587
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Dec 2022 17:31:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 036842166BC0; Fri,  2 Dec 2022 17:31:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0C952166B2A
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 17:31:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D35BF185A78F
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 17:31:49 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-nwICLyHlNXuslLABJ-M3VA-1; Fri, 02 Dec 2022 12:31:48 -0500
X-MC-Unique: nwICLyHlNXuslLABJ-M3VA-1
Received: by mail-wm1-f41.google.com with SMTP id
 ay14-20020a05600c1e0e00b003cf6ab34b61so6978673wmb.2; 
 Fri, 02 Dec 2022 09:31:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=KyQjrNr/mPbQxFzctsfBk6w4T//JwzwVojznV4mqcEk=;
 b=Iov02PNeo7vjLXKTAIU2xqJwKzeIk3Te3WcD2KzgYaIzpPH7vyCjVeGCqe2qx7661J
 odEnBus212xmBXLfgQDP5h4o1nZd271BLn23GnB4EYgZYL9MSzYttyOASmAhoLnC141U
 ZdUD1XZhyjiFgtygjeIk1cFjLOHYTCTVNF/DAe4egKou0MXoXhYvKix+eUtuloUdjr+y
 DsCKwuj74ZstGRLygrKU951k3nq7zDJC3hMrfSztu0f58VlRBXYTLMIJBOf7fJhen/FF
 EjJJNRXZ/AFJUihfUfb5NQaKMrvCUYhpnMONv4yVscgJiY328x83T3c44ByxFLt0xJkG
 aIEw==
X-Gm-Message-State: ANoB5pkuSNLgR60IkNaD9LGbusnSBeXVlsFU17yIEZ25QU3fwzABEO6Z
 E3E21n50PCjLU9z8tL5jOt4YdXnkMvIz
X-Google-Smtp-Source: AA0mqf4W5ou9gjCW+1Z28TjFK36TtvOz8fLnwGgykcXb7v2zOkH+8jI3XVSYnjx2NxpqUx6FdavcpQ==
X-Received: by 2002:a05:600c:1f0f:b0:3d0:2a82:1cb2 with SMTP id
 bd15-20020a05600c1f0f00b003d02a821cb2mr38411966wmb.206.1670002306655; 
 Fri, 02 Dec 2022 09:31:46 -0800 (PST)
Received: from localhost (28.red-88-28-18.dynamicip.rima-tde.net.
 [88.28.18.28]) by smtp.gmail.com with ESMTPSA id
 co16-20020a0560000a1000b00241b6d27ef1sm7768275wrb.104.2022.12.02.09.31.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Dec 2022 09:31:46 -0800 (PST)
Message-ID: <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
Date: Fri, 2 Dec 2022 18:31:45 +0100
MIME-Version: 1.0
To: mwilck@suse.com, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20221201103238.2601-2-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 2/2] multipath.conf(5): improve documentation
 of dev_loss_tmo
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/1/22 11:32, mwilck@suse.com wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> The statement that the default is 600 is wrong in most cases.
> Improve the description of the default and the dependency of this
> parameter on other parameters.

I did change this patch to move "default value" to bottom.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

