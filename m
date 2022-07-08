Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08318C43334
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jul 2022 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657291967;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+kcLaXLXqVRWM61axOLTSCoeSD5rF66RCA0Wh7Hb6mc=;
	b=GvWTCHBae8FnZxEyWKatKuIUqlFOuj0Bx6efIkQu6b2uFPiS44bDb9mFc8wVroIyeu04rl
	xDqZM8E/DS/EwsggvIc0llU7F7j6XKcNiBXka2jfq283gh9SkcU7E2ekkipRnH/pn1W6eP
	fukaERyA5f7cNDBWMSAImGE5hntMAus=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-XHAnf_jYPG2Ra5JZvpuAoQ-1; Fri, 08 Jul 2022 10:52:37 -0400
X-MC-Unique: XHAnf_jYPG2Ra5JZvpuAoQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DD5A1035348;
	Fri,  8 Jul 2022 14:52:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6896B492C3B;
	Fri,  8 Jul 2022 14:52:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 20E1C194706D;
	Fri,  8 Jul 2022 14:52:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 92C7F194706B
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Jul 2022 14:52:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 741541415117; Fri,  8 Jul 2022 14:52:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 706D91415108
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 14:52:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 574C81818342
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 14:52:29 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-Reb9t494PcOf0QexonR6rg-1; Fri, 08 Jul 2022 10:52:27 -0400
X-MC-Unique: Reb9t494PcOf0QexonR6rg-1
Received: by mail-qt1-f169.google.com with SMTP id he28so27672437qtb.13
 for <dm-devel@redhat.com>; Fri, 08 Jul 2022 07:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=bo0K9biKL6GxWuBzzeoWy1wVX3kdrvjU29pDmXT1n/8=;
 b=aPpAB7ewrWChG/JQCIUDM6fkgDRkm65hcixMFkmUSQg1iLtfP4hKOyO2GCEBcJh0D9
 /3j2BPmtkZTGkRPNY+PttP3yQEKZ9reGbP9adzrrSnOxCNqZ/zZQwlcZ8dL1PDbYp75j
 8PFl9oDbWowVc2UIoegXehartvU9Kz5ZIwDtfCHgGJ6BxXMH+vOcHe+LQHLuOrswHHhp
 IjQHiCOWg59tze2VUIFrFXC0r8vYHAoazrqNJONVIOPzvqmajJ9gK60Il1qNUtF/znLc
 G/sOI80B6QwI+0O2pV+RGT4cKOYPpQmn3MSAJvw12ncT5EPHEjD4dQJ/oNYbP10FY+R5
 gsww==
X-Gm-Message-State: AJIora9V/GEFHwvREDUgAqm8o278JQ/FnrJfCuiPJB0VWVQDDoYOCcaa
 QU9CvKJxpgYd6bTkqloJkaFOJC3jN1QeLa59shy4jj+2f+k=
X-Google-Smtp-Source: AGRyM1v/YMHE/pnF2XI7BT30k2Kuu3Vjp7GIVJcVqdR0E2iud5WVmcPRyVXJeecWFqIRKRFT6a81w0SOjWwucetuU0E=
X-Received: by 2002:a05:622a:1a19:b0:31b:8297:bd38 with SMTP id
 f25-20020a05622a1a1900b0031b8297bd38mr3333483qtb.175.1657291947296; Fri, 08
 Jul 2022 07:52:27 -0700 (PDT)
MIME-Version: 1.0
References: <BY5PR13MB3601CBD8C5B444A014F19012FC829@BY5PR13MB3601.namprd13.prod.outlook.com>
In-Reply-To: <BY5PR13MB3601CBD8C5B444A014F19012FC829@BY5PR13MB3601.namprd13.prod.outlook.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 8 Jul 2022 09:52:16 -0500
Message-ID: <CAAMCDecFg6iDEETdojjWkgSAio2hCDBsH3N=hfoLkg3a=8tc3w@mail.gmail.com>
To: Uday Jonnala <uday.jonnala@tessell.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] Regarding dm-clone on RHEL+OEL
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

You probably have to inquire with the vendor support who supplied the
kernel, but checking on a UEK kernel I have of that major version I
see this (mine is el7 not el8, but I suspect the both UEK kernels are
basically identical).

grep -i clone /boot/config-5.4.17-2102.203.6.el7uek.x86_64
# CONFIG_DM_CLONE is not set

So it was not configured/compiled into my kernel and likely not yours.

And dm-clone appears to have initially been added in 5.4 from what I
can tell so I have zero clue how stable/functional it was in that
version even if it was enabled.

On Fri, Jul 8, 2022 at 9:38 AM Uday Jonnala <uday.jonnala@tessell.com> wrote:
>
> Hi Team,
>
>
>
> Looking to see if dm-clone is supported in RHEL based OEL (Oracle Enterprise Licence)
>
> 5.4.17-2136.308.9.el8uek.x86_64 : Kernel Version (OEL RHEL 8 based)
>
>
>
> Which RHEL version has dm-clone checkedin ?
>
> We are getting following error on clone
>
> device-mapper: reload ioctl on clone (252:3) failed: Invalid argument
>
>
>
> Thanks & Regards,
>
> Uday Kiran
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

