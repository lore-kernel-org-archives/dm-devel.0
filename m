Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7263C678D4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 09:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678095237;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=bnyyv12ga+OOe3iIp+mt4kqceQBinPJahDPCdIZujt4=;
	b=AGmIPIlBnT3091uzvuaKzBE8dmuHdx1mV7zsrpmCnmVbzTqoj0pY3OqaWJMKHEmGO6EAko
	IcPqVNJoq3L4awYjarZ4kgxG+XFWjzEzlGml9zW9JvsxiYofoKj8mVU8dLUgrddW6u9c/2
	9AkZAKiL9gNwJz9VLEDzqbqovKgy/KE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-OXgTexXANHmPsp71b3x4PQ-1; Mon, 06 Mar 2023 04:33:56 -0500
X-MC-Unique: OXgTexXANHmPsp71b3x4PQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FBB83C0F180;
	Mon,  6 Mar 2023 09:33:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5085B2026D4B;
	Mon,  6 Mar 2023 09:33:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07A97194658C;
	Mon,  6 Mar 2023 09:33:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B60231946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 09:33:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A740940BC781; Mon,  6 Mar 2023 09:33:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FC3040C10FA
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 09:33:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C49080D0EE
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 09:33:52 +0000 (UTC)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-wALJxtAnN5S5j8dKXF68yg-1; Mon, 06 Mar 2023 04:33:48 -0500
X-MC-Unique: wALJxtAnN5S5j8dKXF68yg-1
Received: by mail-yw1-f200.google.com with SMTP id
 00721157ae682-53700262a47so95460017b3.4
 for <dm-devel@redhat.com>; Mon, 06 Mar 2023 01:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678095228;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=W7IaPp1TEn2W0wA8sLueViNO8jdryMCKVVODKyAD1BE=;
 b=4rbDylBVU6gtdSArE1wvTmV+Cqzl3b59DbPwJ7o8J+Kgx8M0cs2KmIEfU8dfM+xan7
 rSQYhp2wsW9shoT8XRJgQ7qoZItSJPIV6xSPVdwb7TSNDzEWteIUpZwZw6t3+sDk9i/q
 2TwDCErxEhiuUnSXQg/1qz8KUMK1z2yJrF7YZ6/2xNaxQBhOKXZGLTAfyUiMtnicoWO3
 z4SJrGZwwYPfTGb7XS/Sm4AHm2ZdWV38ZPOwPgJU2Sa1nHfvNzS/YohncdzMplYwaQlJ
 TmKAbGOSK8UIMYfTLDv7b6L+VdB8zafCSE96gM+kgD3KaNb7UQP27+m5vZY4my97leeB
 9r2g==
X-Gm-Message-State: AO0yUKU+mhfAOOzeZSKVk6cqUYdOLNttE2FCLfI4iHaiprmzeBcg8JDO
 7YPlDYrXbewwREag9QiKjZ0P+KfyEU0RgiBk/QkqN5K70YkH1/zYz3XLkqcpy/KeK1sGEHQBRnC
 Fj3LY6fjDBDnjKcOvsm59dDMe0HFk8VAffJDJmE8=
X-Received: by 2002:a25:9082:0:b0:855:fa17:4f66 with SMTP id
 t2-20020a259082000000b00855fa174f66mr6050378ybl.8.1678095228098; 
 Mon, 06 Mar 2023 01:33:48 -0800 (PST)
X-Google-Smtp-Source: AK7set9hCpgkvJ/saly1PB+bDU7GzPc9V6KDb1/6T1542Dua4ExRxVzhdlM3uZfmg9OOcNV/WUeheehQK/Y4FdW4K7c=
X-Received: by 2002:a25:9082:0:b0:855:fa17:4f66 with SMTP id
 t2-20020a259082000000b00855fa174f66mr6050373ybl.8.1678095227899; Mon, 06 Mar
 2023 01:33:47 -0800 (PST)
MIME-Version: 1.0
References: <ZAT+IoCfuZtRnnhm@itl-email>
In-Reply-To: <ZAT+IoCfuZtRnnhm@itl-email>
From: Joe Thornber <thornber@redhat.com>
Date: Mon, 6 Mar 2023 09:33:37 +0000
Message-ID: <CAJ0trDZJW6uXkeCUCBRyJ_wg70wGmqSs+r+5HKACrKETN-Kdmg@mail.gmail.com>
To: CAJ0trDYAyHHh2crMAQuQPMt3FzFmii0nmLnsL5N-cdhfvWZnMg@mail.gmail.com
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] Thin pool CoW latency
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
Cc: dm-devel@lists.ewheeler.net, "development,
 device-mapper" <dm-devel@redhat.com>,
 Qubes OS Development Mailing List <qubes-devel@googlegroups.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?=
 <marmarek@invisiblethingslab.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============1034702905300956322=="

--===============1034702905300956322==
Content-Type: multipart/alternative; boundary="000000000000f56af505f637fdf2"

--000000000000f56af505f637fdf2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 5, 2023 at 8:40=E2=80=AFPM Demi Marie Obenour <
demi@invisiblethingslab.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> Like Eric, I am very concerned about CoW latency and throughput.  I
> am almost certain that allocating new blocks and snapshot copy-on-write
> are _the_ hot paths in Qubes OS.  In particular, I suspect that
> workloads such as building an image in a throwaway VM or installing
> packages onto a root volume that had just been shapshotted are dominated
> by metadata operations, rather than by in-place updates.  I suspect that
> frequently-snapshotted volumes will observe similar behavior in general.
>
>
Yes, provisioning and breaking sharing are relatively slow operations.  As
discussed with Eric
I'm not intending to change how either of these operations is implemented.
If the performance
profile is not suitable for your application your company can either do
some work to improve it yourselves, or
select a different solution.

- Joe

--000000000000f56af505f637fdf2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Sun, Mar 5, 2023 at 8:40=E2=80=AFP=
M Demi Marie Obenour &lt;<a href=3D"mailto:demi@invisiblethingslab.com">dem=
i@invisiblethingslab.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">-----BEGIN PGP SIGNED MESSAGE-----<br>
Hash: SHA512<br>
<br>
Like Eric, I am very concerned about CoW latency and throughput.=C2=A0 I<br=
>
am almost certain that allocating new blocks and snapshot copy-on-write<br>
are _the_ hot paths in Qubes OS.=C2=A0 In particular, I suspect that<br>
workloads such as building an image in a throwaway VM or installing<br>
packages onto a root volume that had just been shapshotted are dominated<br=
>
by metadata operations, rather than by in-place updates.=C2=A0 I suspect th=
at<br>
frequently-snapshotted volumes will observe similar behavior in general.<br=
><br></blockquote><div><br></div><div>Yes, provisioning and breaking sharin=
g are relatively slow operations.=C2=A0 As discussed with Eric</div><div>I&=
#39;m not intending to change how either of these operations is implemented=
. If the performance=C2=A0</div><div>profile is not suitable for your appli=
cation your company can either do some work to improve it yourselves, or</d=
iv><div>select a different solution.</div><div><br></div><div>- Joe</div><d=
iv><br></div><div>=C2=A0</div></div></div>

--000000000000f56af505f637fdf2--

--===============1034702905300956322==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1034702905300956322==--

