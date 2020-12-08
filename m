Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257C3C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 09:53:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7BF2D233FA
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 09:53:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BF2D233FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-QlYaEmA4NzWtqaSylnC-ng-1; Tue, 08 Dec 2020 04:53:31 -0500
X-MC-Unique: QlYaEmA4NzWtqaSylnC-ng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23AF3107ACFA;
	Tue,  8 Dec 2020 09:53:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 518F15D9DE;
	Tue,  8 Dec 2020 09:53:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 53AB65002C;
	Tue,  8 Dec 2020 09:53:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B89rLiJ030210 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 04:53:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D52122166B27; Tue,  8 Dec 2020 09:53:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF43C2166B2B
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 09:53:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E887185A7BC
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 09:53:17 +0000 (UTC)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com
	[209.85.210.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-403-fkCUT2GoOjGU9ynPvDSAmQ-1; Tue, 08 Dec 2020 04:53:14 -0500
X-MC-Unique: fkCUT2GoOjGU9ynPvDSAmQ-1
Received: by mail-ot1-f54.google.com with SMTP id i6so9223400otr.2
	for <dm-devel@redhat.com>; Tue, 08 Dec 2020 01:53:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
	bh=TsMybE9TXF2WMLyfuHIzLyiV09sitPCC/e04wHi26/A=;
	b=cO23hFrPq4GYVNmKDEOr659txR6oeIlfb5b04ms2W1vsRILWd7a+dVfqgROog2PbIk
	hmYXSSe00qGYg5C70lwPj9NDOqSy9SaIn5tncL+Srn/OukHGwpwz1E0AF88EQuPGEadk
	tibZ7dJP0S8p4NtrdEreGWytlghNOONKwBYrvgzBDNufmdrDjRegVOq4pf4dPyCXB6Ct
	iR7Nn5V1mbDyndwDAzpvtpBqSBECm33Ht58aiL8EX0hIgQAna69AHUBWyv12PEuJVfpF
	d4E8UVxGFVacarbFPLr1EOPBbs7gjLJsu/ii1/krBdtQjJofurZQvrkkgoJTYkvBNhB6
	o8aQ==
X-Gm-Message-State: AOAM532U1pLxUpZ2MEi+xqHblFXL/z3RJjHryiuLvZPUDlfkA/jXRogD
	ax3moCP4qgyemJm4QVMTvVeS8Lktk+OZgRTjMKI8oz2EIGLjJQ==
X-Google-Smtp-Source: ABdhPJw9m6fxBQxIJPe3XUslW4Riqo/aJgfNPYrBHRDQto45xYhJxgj3IDGq8ur3kW8zC4bZHMKZ7N0QTtczf76SI2s=
X-Received: by 2002:a9d:f66:: with SMTP id 93mr3147308ott.289.1607421192986;
	Tue, 08 Dec 2020 01:53:12 -0800 (PST)
MIME-Version: 1.0
From: Dennis Yang <shinrairis@gmail.com>
Date: Tue, 8 Dec 2020 17:53:01 +0800
Message-ID: <CAKTMprPoUB90wL3U5yJrPYiNrZNg_eiJqVRUNDuYberM1ogF5g@mail.gmail.com>
To: device-mapper development <dm-devel@redhat.com>
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
Subject: [dm-devel] Performance degradation of DM devices after upgrading to
 linux-5.9 from linux-5.8
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2948934797964280697=="

--===============2948934797964280697==
Content-Type: multipart/alternative; boundary="00000000000036642d05b5f0e90d"

--00000000000036642d05b5f0e90d
Content-Type: text/plain; charset="UTF-8"

Hi, I have observed a severe performance degradation of DM devices with a
simple dd test in linux-5.9 comparing to linux-5.8.

This test contains the following steps:
1. Create a dm-thin pool
2. Create a volume in this pool
3. Run "dd if=/dev/zero of=/dev/mapper/vol bs=512K count=10k"

In my own setup, I use a SSD as thin pool's metadata device and a HDD as
data device. Here is what I get from both linux versions.

--- Thin Volume ---
linux-5.9.11         10.5 MB/s
linux-5.8.18         77.7 MB/s

--- Linear device over HDD ---
linux-5.9.11         77.0 MB/s
linux-5.8.18       136.0 MB/s

--- Linear device over SSD ---
linux-5.9.11        256.0 MB/s
linux-5.8.18        369.0 MB/s

>From iostat, I can tell that DM devices will get a smaller bio with
length equals to only 1 sector in linux-5.9.11 comparing to 8 sectors in
linux-5.8.18. I dig a little deeper to this issue, and it turns out this
patch made the size of bio of buffer I/Os equal to the logical block size
of target block device which is 512 bytes of all my HDD and SSD in my
cluster.
https://lore.kernel.org/patchwork/patch/1264139/

After reverting this patch in linux-5.9.11, I can have the same performance
as linux-5.8. However, I am not sure if this is the right thing to do or
something needs to be taken care of in the device-mapper layer.

Any comment would be highly appreciated.
Thanks for your time.

Dennis

--00000000000036642d05b5f0e90d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div di=
r=3D"ltr"><div dir=3D"ltr">Hi, I have observed a severe performance degrada=
tion of DM devices with a simple dd test in linux-5.9 comparing=C2=A0to lin=
ux-5.8.<div><br></div><div>This test contains the following steps:<div>1. C=
reate a dm-thin pool</div><div>2. Create a volume in this pool</div><div>3.=
 Run &quot;dd if=3D/dev/zero of=3D/dev/mapper/vol bs=3D512K count=3D10k&quo=
t;</div><div><br></div></div><div>In my own setup, I use a SSD as thin pool=
&#39;s metadata device and a HDD as data device. Here is what I get from bo=
th linux versions.</div><div><br></div><div>--- Thin Volume ---</div><div>l=
inux-5.9.11=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A010.5 MB/s</div><div>linux-5.8.=
18=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A077.7 MB/s</div><div><br></div><div>--- =
Linear device over HDD ---</div><div><div>linux-5.9.11=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A077.0 MB/s</div><div>linux-5.8.18=C2=A0 =C2=A0 =C2=A0 =C2=A0136=
.0 MB/s</div></div><div><br></div><div>--- Linear device over SSD ---</div>=
<div><div>linux-5.9.11=C2=A0 =C2=A0 =C2=A0 =C2=A0 256.0 MB/s</div><div>linu=
x-5.8.18=C2=A0 =C2=A0 =C2=A0 =C2=A0 369.0 MB/s</div></div><div><br></div><d=
iv>From iostat, I can tell that DM devices will get a smaller bio with leng=
th=C2=A0equals to only 1 sector in linux-5.9.11 comparing to 8 sectors in l=
inux-5.8.18. I dig a little deeper to this issue, and it turns out this pat=
ch made the size of bio of buffer I/Os equal to the logical block size of t=
arget block device which is 512 bytes of all my HDD and SSD in my cluster.<=
/div><div><a href=3D"https://lore.kernel.org/patchwork/patch/1264139/">http=
s://lore.kernel.org/patchwork/patch/1264139/</a></div><div><br></div><div>A=
fter reverting this patch in linux-5.9.11, I can have the same performance =
as linux-5.8. However, I am not sure if this is the right thing to do or so=
mething needs to be taken care of in the device-mapper layer.</div><div><br=
></div><div>Any comment would be highly appreciated.</div><div>Thanks for y=
our time.</div><div><br></div><div>Dennis</div><div>=C2=A0</div></div></div=
></div></div></div></div>

--00000000000036642d05b5f0e90d--

--===============2948934797964280697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============2948934797964280697==--

