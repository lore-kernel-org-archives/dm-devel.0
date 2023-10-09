Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD2BAE95A91
	for <dm-devel@archiver.kernel.org>; Mon,  9 Oct 2023 07:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696837386;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=5hL3ZzniYOCUgqXwcQfLWahyPXgxgVzSH2k7vwD8JfU=;
	b=Lo2RsEyUG+njQ0B9BQ09EiLvxVC6jJJ/DkV2mywifzifyQLopZbQYUZfMyERzC9ALIg4j/
	vMwQZFyfCzS13oT2pE0ZiJG6jj0i12mV/vxNDeN7Yh4+0Ba7SjfzMU8Avh/5gfa+c1pcw2
	tSCSiZMVir8HM5o4VxTxrlJi7TFuR5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-pIxuK_MEMum_cV92IrgWHQ-1; Mon, 09 Oct 2023 03:43:05 -0400
X-MC-Unique: pIxuK_MEMum_cV92IrgWHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48E2485A5BE;
	Mon,  9 Oct 2023 07:43:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1685C154CF;
	Mon,  9 Oct 2023 07:43:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6B8C819465A3;
	Mon,  9 Oct 2023 07:43:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 11D201946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 07:43:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D12F22027046; Mon,  9 Oct 2023 07:43:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C50772026D37
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 07:43:00 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4A7029AA3B0
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 07:43:00 +0000 (UTC)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-0g2vO4H2PT-nyID9EiyUaw-1; Mon, 09 Oct 2023 03:42:48 -0400
X-MC-Unique: 0g2vO4H2PT-nyID9EiyUaw-1
Received: by mail-wr1-f69.google.com with SMTP id
 ffacd0b85a97d-321f75cf2bdso2761211f8f.2
 for <dm-devel@redhat.com>; Mon, 09 Oct 2023 00:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696837367; x=1697442167;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=hqKLuzymsGkzUOUIxrLEm9X9HVQCfdC6SQyGrG6uC3k=;
 b=Bp2BoTpCNm6f83GAC/GbVNcS8Va9PAuq7hRp6e7x1RWJW84bPIbTkIVmYdyHAaRdkS
 CSkpAKKOpVozSuRj+C21Dhvf3YZAMkjBMN9Fq4JfxD5r1er/IcjsbBXrsu61QrS4Zqms
 fGLuQMjyi5/mDp37eEah1iA3k658moiSiwz0rpiIVB0wXKxHlG+97Ws9Bzvwb9fr9XQg
 pjNuKASC9OX9RRX38RM473fy8137XXWi87cbNoZx7qlU2xe5983PWzgZ2Rx1Tpb32SNH
 9HQ7ZWuA/fbqE8+rd2zpslAB8pE2gmnNcV52Yd92+I1E6ONNJWEHKIAJmZoHnhsgxN+S
 8OBA==
X-Gm-Message-State: AOJu0YwKSXea8be38WrnXDeVI/Fdz8v3+GDhzio+O6myNn9NL2eOwV89
 QzmuwMseT7wjNh4272zYiNigwR+lu+GbaSQWxCidLayTqV2D+PHBLQGOy/MuDiv/uS6jhkJFPww
 YL8aPeIbpxA1BMqXjyiT/0V7ux64694c=
X-Received: by 2002:a5d:680d:0:b0:319:83e4:bbbf with SMTP id
 w13-20020a5d680d000000b0031983e4bbbfmr13756609wru.20.1696837367788; 
 Mon, 09 Oct 2023 00:42:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQc9CM4lskgPTL0Ai6LXBx4j4Zel4nYNPDI8cHdGLtF6EAeSiqWvMqoV5am4mQ5a3D5ktzsUZ0hi7MruDCeT0=
X-Received: by 2002:a5d:680d:0:b0:319:83e4:bbbf with SMTP id
 w13-20020a5d680d000000b0031983e4bbbfmr13756598wru.20.1696837367514; Mon, 09
 Oct 2023 00:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <20231007013314.3055426-1-sarthakkukreti@chromium.org>
In-Reply-To: <20231007013314.3055426-1-sarthakkukreti@chromium.org>
From: Joe Thornber <thornber@redhat.com>
Date: Mon, 9 Oct 2023 08:43:00 +0100
Message-ID: <CAJ0trDbJPBSOUT3FD+ssZyj4qqTYWfWVvn7tZTDgKVYnMN+cKg@mail.gmail.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH RFC] dm thin: Add support for online trim to
 dm-thinpool
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8904608736339103834=="

--===============8904608736339103834==
Content-Type: multipart/alternative; boundary="000000000000886131060743bc16"

--000000000000886131060743bc16
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 7, 2023 at 2:33=E2=80=AFAM Sarthak Kukreti <sarthakkukreti@chro=
mium.org>
wrote:

> Currently, dm-thinpool only supports offline trim: there is
> a userspace tool called `thin_trim` (part of `thin-provisioning-tools`),
> that will look up all the unmapped regions within the thinpool
> and issue discards to these regions. However, this can take up a lot of
> time, specially on larger storage devices.
>

I think this will work.  Give me a couple of days to do some testing, then
I'll get back to you.

--000000000000886131060743bc16
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div><br></div></div><div class=3D"gmail_=
quote"><div dir=3D"ltr" class=3D"gmail_attr">On Sat, Oct 7, 2023 at 2:33=E2=
=80=AFAM Sarthak Kukreti &lt;<a href=3D"mailto:sarthakkukreti@chromium.org"=
>sarthakkukreti@chromium.org</a>&gt; wrote:<br></div><blockquote class=3D"g=
mail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204=
,204,204);padding-left:1ex">Currently, dm-thinpool only supports offline tr=
im: there is<br>
a userspace tool called `thin_trim` (part of `thin-provisioning-tools`),<br=
>
that will look up all the unmapped regions within the thinpool<br>
and issue discards to these regions. However, this can take up a lot of<br>
time, specially on larger storage devices.<br></blockquote><div><br></div><=
div>I think this will work.=C2=A0 Give me a couple of days to do some testi=
ng, then I&#39;ll get back to you.</div><div>=C2=A0</div></div></div>

--000000000000886131060743bc16--

--===============8904608736339103834==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8904608736339103834==--

