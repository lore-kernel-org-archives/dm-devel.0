Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF4BC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 22:14:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-xuKlIAb2PaO1KHAeIpXKXQ-1; Mon, 18 Apr 2022 18:14:23 -0400
X-MC-Unique: xuKlIAb2PaO1KHAeIpXKXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 224E63C02B83;
	Mon, 18 Apr 2022 22:14:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C597540FF690;
	Mon, 18 Apr 2022 22:14:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6ADC91947BBD;
	Mon, 18 Apr 2022 22:14:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D404A1947BBB
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 22:14:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE9C9537BA2; Mon, 18 Apr 2022 22:14:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BAB01537BA0
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 22:14:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2A2A1C05B07
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 22:14:18 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-FnGFb7bGNDWotAcN_s8oLg-1; Mon, 18 Apr 2022 18:14:16 -0400
X-MC-Unique: FnGFb7bGNDWotAcN_s8oLg-1
Received: by mail-pj1-f48.google.com with SMTP id
 s14-20020a17090a880e00b001caaf6d3dd1so510511pjn.3
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 15:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=l9iX3O76iQ19mxLdkIRQWetqHCUUN6Yl8wyXvju+L58=;
 b=ck72Sylz8oigzU4jGqebixhVFopMI+pBoLdDuxGEHjHjo/rWOXvAiRd2vhu4tTVEaP
 D7Nk0hoS97jSgVhbkFya7JUSyufSsJQeWusmlWFtBcJ60bXbuvtaLyRNrxTaEzOu/axU
 L5Qr+79G6rpnFP28qdtEMhBpfdDAtN4lcjaV84thPKAWMbne8ZHGlHhPseGVNdkFJpmS
 3pEeL8FD9LZjVt8XILeYbUYKABDlMleS5FobvsNrHtIzHd4QPcN+XC7k7SJNWv6ptJFc
 uZHYoftuCuJ8JbNwuArPYvFvDhuK+4aC9Z52Lae0RGFldIN2M3Lba3jBTq9QHsbYhJyn
 W70g==
X-Gm-Message-State: AOAM530frGLSKlUOq2Glbl7FRjd688RDym4PoevGMVbq8POaEu8rfzfv
 bt9offYNaVlaFBOb5V/fTej8fw==
X-Google-Smtp-Source: ABdhPJxYWfaYuUfmsuYBP9tAVt7Q9FdYPOiskmz/BKG5SMVEEro5fUdapj1n24fWgg8kEKZu+KWh/g==
X-Received: by 2002:a17:90b:3a90:b0:1d1:7733:a6a2 with SMTP id
 om16-20020a17090b3a9000b001d17733a6a2mr17042453pjb.79.1650320055731; 
 Mon, 18 Apr 2022 15:14:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 b25-20020aa78719000000b0050a4b5cf892sm10676304pfo.60.2022.04.18.15.14.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Apr 2022 15:14:15 -0700 (PDT)
Date: Mon, 18 Apr 2022 15:14:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <202204181512.DA0C0C6EBD@keescook>
References: <20220418211559.3832724-1-mka@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20220418211559.3832724-1-mka@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 0/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: Douglas Anderson <dianders@chromium.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 James Morris <jmorris@namei.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[oops, resending to actual CC list]

On Mon, Apr 18, 2022 at 02:15:56PM -0700, Matthias Kaehlcke wrote:
> This series extends LoadPin to allow loading of kernel files
> from trusted dm-verity devices. It adds the concept of
> trusted verity devices to LoadPin. Userspace can use the
> new systl file 'loadpin/trusted_verity_root_digests' to
> provide LoadPin with a list of root digests from dm-verity
> devices that LoadPin should consider as trusted. When a
> kernel file is read LoadPin first checks (as usual) whether
> the file is located on the pinned root, if so the file can
> be loaded. Otherwise, if the verity extension is enabled,
> LoadPin determines whether the file is located on a verity
> backed device and whether the root digest of that device
> is in the list of trusted digests. The file can be loaded
> if the verity device has a trusted root digest.
> 
> The list of trusted root digests can only be written once
> (typically at boot time), to limit the possiblity of
> attackers setting up rogue verity devices and marking them
> as trusted.

Hi,

Thanks for working all this out! Where does the list of trusted
roothashes come from? I assume some chain of trust exists. Is the list
maybe already stored on the rootfs?

It'd be nice if there was some way to pass the trust chain to LoadPin
more directly.

-Kees

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

