Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECFDC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:55:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-_6sNZQDjMV-HL6y4Cuiexg-1; Mon, 21 Mar 2022 02:54:56 -0400
X-MC-Unique: _6sNZQDjMV-HL6y4Cuiexg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8C5A1C05AF2;
	Mon, 21 Mar 2022 06:54:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B54174010A03;
	Mon, 21 Mar 2022 06:54:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F0111953572;
	Mon, 21 Mar 2022 06:54:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4C97D193713A
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 15:27:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7047403171; Sat, 19 Mar 2022 15:27:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2EE1401E6F
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 15:27:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C835C80005D
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 15:27:51 +0000 (UTC)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
 [209.85.167.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-XOdYhcqGO4WzJYpD8BHpeQ-1; Sat, 19 Mar 2022 11:27:49 -0400
X-MC-Unique: XOdYhcqGO4WzJYpD8BHpeQ-1
Received: by mail-lf1-f47.google.com with SMTP id w7so18377002lfd.6
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 08:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=JrOYZqIYiScdxhSdrlzCAZz50uqk0lX/3tLEjKT2YfU=;
 b=ZP64bfwcexCNRhu6BA4kkot2dOTI1Tiq5ERlfovjobbNzbFC2IkpOn0xdHI+4n5Rpi
 x6F5Gi5GyfSaRWc1UVFUG3Xq/NWUv7ndx4OJDaUhJlm7l+RR/HPcSRmHb+g/VtMqA8aj
 WJN14sROlXw9BVRPSxR2HqxunnbxDx/zZIihsobNX6lnuoESnUP+WUgeFWx+xEldED0E
 B16C3D6rBnnB2AbeMVrrvDgOnIMGX+XmyRCk4Ji+3y0a1cFJ+IRqWNDA2xGefxvESRgY
 RZ7AFYGyW6MJmjfOjrV1cC8nNHFEfPts++KsRUgl6F6kPA0nH4m0dncV5bYGmiFy1gVi
 ppxA==
X-Gm-Message-State: AOAM530/xiO26+g74Wr5MQCgnxT3Wz/WDGWDPQ/x/dW3EVlrPtVQnTSU
 6SHnc9JurAHkGWAnPnTehrE3PJAT30+XXy9JUkoBOklhDA==
X-Google-Smtp-Source: ABdhPJztcS9vvBTG2Q9UIKzK/QxZqdZ0Cnyy7J2o0pNAB82PZJ5CRVQ4I+vqAoYYeSlP/UqLKGFRLIAKV43aukxPQvE=
X-Received: by 2002:a05:6512:96e:b0:448:4bd7:fff7 with SMTP id
 v14-20020a056512096e00b004484bd7fff7mr9257313lft.605.1647703667505; Sat, 19
 Mar 2022 08:27:47 -0700 (PDT)
MIME-Version: 1.0
From: boli sudha <bolisudha@gmail.com>
Date: Sat, 19 Mar 2022 20:57:08 +0530
Message-ID: <CAEgic_HjomW1WbB+XFzN2t_kJJr=-2P-zrNi2p0EqqMo2pc2Lg@mail.gmail.com>
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:50 +0000
Subject: [dm-devel] libmpathpersist: Getting undefined symbol during
 compilation
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8525539942566215086=="

--===============8525539942566215086==
Content-Type: multipart/alternative; boundary="000000000000cbfc8005da93e794"

--000000000000cbfc8005da93e794
Content-Type: text/plain; charset="UTF-8"

Hi,

I found this mail Id on the Git page, I never used libmpathpersist or
libmulitpath.
One of our applications is using these libraries. Compilation was working
fine on RedHat 7. I am trying to port our application to Redhat 8. During
linking I am getting the following error. Can you please help me?

/usr/lib64/libmpathpersist.so: undefined reference to `put_multipath_config'
/usr/lib64/libmpathpersist.so: undefined reference to `get_multipath_config'
/usr/lib64/libmultipath.so: undefined reference to `udev'
collect2: error: ld returned 1 exit status

These symbols were not present in the RedHat 7 version of libraries.

On RedHat 8, these symbols were undefined, I downloaded the git code,
compiled, and observed that these symbols are defined in binaries, not
libraries.

I also tried to remove these libraries from linker command, but so many
symbols are missing.

--000000000000cbfc8005da93e794
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I found this mail Id on the Git pag=
e, I never used libmpathpersist or libmulitpath.</div><div>One of our appli=
cations is using these libraries. Compilation was working fine on RedHat 7.=
 I am trying to port our application to Redhat 8. During linking I am getti=
ng the following error. Can you please help me?</div><div><br></div><div>/u=
sr/lib64/libmpathpersist.so: undefined reference to `put_multipath_config&#=
39;<br>/usr/lib64/libmpathpersist.so: undefined reference to `get_multipath=
_config&#39;<br>/usr/lib64/libmultipath.so: undefined reference to `udev&#3=
9;<br>collect2: error: ld returned 1 exit status<br><br>These symbols were =
not present in the RedHat 7 version of libraries.</div><div><br></div><div>=
On RedHat 8, these symbols were undefined, I downloaded the git code, compi=
led, and observed that these symbols are defined in binaries, not libraries=
.<br><br>I also tried to remove these libraries from linker command, but so=
 many symbols are missing.</div></div>

--000000000000cbfc8005da93e794--

--===============8525539942566215086==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8525539942566215086==--

