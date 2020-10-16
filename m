Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A002C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF53520848
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF53520848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-IUENaoFwOe-JbwKzXA1c6g-1; Fri, 16 Oct 2020 06:20:17 -0400
X-MC-Unique: IUENaoFwOe-JbwKzXA1c6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0ED316409C;
	Fri, 16 Oct 2020 10:20:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E0D8D5C1BD;
	Fri, 16 Oct 2020 10:20:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B64E444A60;
	Fri, 16 Oct 2020 10:20:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09G8NJfS002961 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 04:23:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 953B72156A37; Fri, 16 Oct 2020 08:23:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 901BC2156A36
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 08:23:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 523E1182360B
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 08:23:17 +0000 (UTC)
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com
	[209.85.166.174]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-278-5RUc4ZOeNkut3yv0N0IIwA-1; Fri, 16 Oct 2020 04:23:14 -0400
X-MC-Unique: 5RUc4ZOeNkut3yv0N0IIwA-1
Received: by mail-il1-f174.google.com with SMTP id t18so1641580ilo.12
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 01:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=SpTOuXliwXJxpSTzhwTM4Ei7E7FDPQod5ub1sh3nucw=;
	b=daSqZvKpqWsjrlywh5RIgpCyvwPKVaweAdB9BAMoczyF9yPL13TMwXzAQJzQmQKV7x
	IzJKvPhl0aGujCXc8TZFNGb3KDRAF9s2lEbeRPQ0pEbOfY2e+vTjD8M1d8u+5BDA+QOQ
	0BSeV6zS6BJF+kwCtgOrWrIrm91Fq1pZ+U7OXqjQNaChKJ10CJnMy7mtoblJUDUsF3VT
	n+0Y2y8Q20m4XXWCiSsze/ivgUmPlxKO0FVF+rQ+3s9WnAi+pU9I/oIO0gFpD8WwKT2S
	xcVEAva/Qd2GuOSlG4i3Z1MW6jYoH7rKb+YzLkiK6fbnzzWkBiu0369TbJ2ZaUBGEkHZ
	jAog==
X-Gm-Message-State: AOAM531EzgMmYyjgNCzqDK9Sy4QSc0r58HFo+UWOz5Jy9KBuENoReqf6
	V2K5PHW5amE0IU+ZKzwumJdCNOOyyNaJ8zFhEObX5hjrrcU=
X-Google-Smtp-Source: ABdhPJxMaGl/zXyxCVLsdWZh66cF9m211v+8Yg8CHMVZnWYbJcbZ+eCpOLPl+UHuFWRco5xh3rSwDzDg/6XIFhLK5Ek=
X-Received: by 2002:a92:ccc5:: with SMTP id u5mr1928369ilq.178.1602836593321; 
	Fri, 16 Oct 2020 01:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <CACc6y5s7JYDq24fHvtbEsV1Gjhqbbunw8iGhgdK5VNh8JVo_Sw@mail.gmail.com>
In-Reply-To: <CACc6y5s7JYDq24fHvtbEsV1Gjhqbbunw8iGhgdK5VNh8JVo_Sw@mail.gmail.com>
From: "Shawn D. Henry" <mrshawndhenry@gmail.com>
Date: Fri, 16 Oct 2020 04:23:02 -0400
Message-ID: <CACc6y5v82wgM5WnjYGAZ4QvhVq=uK4Xaf_+KhPMbtfuCDx5iBg@mail.gmail.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 16 Oct 2020 06:18:44 -0400
Subject: [dm-devel] Fwd: SDHCID Information
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5640422338205666650=="

--===============5640422338205666650==
Content-Type: multipart/alternative; boundary="000000000000c72f8905b1c57918"

--000000000000c72f8905b1c57918
Content-Type: text/plain; charset="UTF-8"

I am User data -16384 mmcblk1pl

Can you tell me about your device mapper protocols?

--000000000000c72f8905b1c57918
Content-Type: text/html; charset="UTF-8"

<div><br></div><div><div class="gmail_quote"><div dir="auto">I am User data -16384 mmcblk1pl</div><div dir="auto"><br></div><div dir="auto">Can you tell me about your device mapper protocols?</div>
</div></div>

--000000000000c72f8905b1c57918--

--===============5640422338205666650==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============5640422338205666650==--

