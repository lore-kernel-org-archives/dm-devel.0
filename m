Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C87AC76196
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679583757;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xuZ4WI1orosZsquDsfUY8/s0v9LYrHJatvLesnvHw4I=;
	b=hrvjloHNmrz96Ri0dQQ74v8lXMiYz9xgl3tmZJsCs+KnYh4RUe8LHbNbZoe2ryHU+OFKt9
	zt5zY+p31HncrIpjNckdSJYkJWKZcLFY5KCxzWq48u13WZmHakhQoopfur+eMLV7umOF4M
	XJcGToPXJfA48lyZgkZHlWxqmipt7uk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-HJ0gAGQ7Plqkq6otVW-IGw-1; Thu, 23 Mar 2023 11:02:21 -0400
X-MC-Unique: HJ0gAGQ7Plqkq6otVW-IGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24927185A78F;
	Thu, 23 Mar 2023 15:02:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B90402166B2A;
	Thu, 23 Mar 2023 15:02:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6AE1F19465B7;
	Thu, 23 Mar 2023 15:02:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D484F1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 15:02:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C4C721121315; Thu, 23 Mar 2023 15:02:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE18A1121314
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 15:02:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EFED101A531
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 15:02:17 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-vTlwfSkdPduXWX5tsMHzMg-1; Thu, 23 Mar 2023 11:02:01 -0400
X-MC-Unique: vTlwfSkdPduXWX5tsMHzMg-1
Received: by mail-wr1-f49.google.com with SMTP id i9so20848826wrp.3;
 Thu, 23 Mar 2023 08:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679583720;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=oiTkVrLWsYeCUXMlQdwynOfxvinpve8cBIabYY1xM0Q=;
 b=UrS8Y0JhVLUVwc15l2pIzR64Q8qyAxk6dnvcaEtfVbd+nohtMYu1r2E0g2SIH/i0hV
 QfBV0F27lt3H4hjqj3BKGEu/KrO9+1pCzJ2zJcNuxxzsSWQ24IneZhhKYzVVhzUU2mY7
 /VswNwgGH6TkSoLZaYOZGjrix+4YLpXXaLaUL/sWssnnE3+hXQC2YGH9lETuaQ5VEtrb
 jihkamj+mWMadVm+y61hZETVvcqWmrsovlDn1XP4On506e69q0p/amoFO/10DP/y1gVR
 zn4l5a8CyM2nwmEb41ESmN4TmugJbtGKBpOuMS0NYBfwajtUm8i9wEoasnIVSk5iGWtQ
 2oRg==
X-Gm-Message-State: AAQBX9fub6YxQOTvui0XYr8R+mpM/HsysfCA7UG8fW2PPq3UgaG53nTc
 kjRUfOW1gj2Lp3cnp/au5RULudulXw==
X-Google-Smtp-Source: AKy350ZTevK454JohLx7xov7LCWNyo3yk3Wn4MMQWkj7fhJ0LVDTVNOzR+kPye7H2mIJ2PshjLUXAQ==
X-Received: by 2002:a05:6000:1045:b0:2cf:3a99:9c1e with SMTP id
 c5-20020a056000104500b002cf3a999c1emr2792651wrx.49.1679583719918; 
 Thu, 23 Mar 2023 08:01:59 -0700 (PDT)
Received: from localhost (131.red-81-44-151.dynamicip.rima-tde.net.
 [81.44.151.131]) by smtp.gmail.com with ESMTPSA id
 h4-20020a5d5044000000b002c70851fdd8sm16411311wrt.75.2023.03.23.08.01.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 23 Mar 2023 08:01:59 -0700 (PDT)
Message-ID: <a57ddfbd-1ca6-44e4-74fe-76c04979be7d@gmail.com>
Date: Thu, 23 Mar 2023 16:01:58 +0100
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Sam James <sam@gentoo.org>
References: <20230320155550.7326-1-mwilck@suse.com>
 <66ea3909c6446445a64d70eee0c68a6e1f15b33d.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <66ea3909c6446445a64d70eee0c68a6e1f15b33d.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] multipath-tools Makefiles: handle dependency
 files correctly
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/23/23 12:53, Martin Wilck wrote:

> Xose, Ben,
> 
> when this gets a Reviewed-by, I'd prepare a new submission to
> Christophe (unless someone objects).

There is a pending Gentoo patch from Sam James:
https://listman.redhat.com/archives/dm-devel/2023-March/053587.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

