Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DADBC43334
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jul 2022 14:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657291095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=lfK+ol5U/RQOnsnCae07FQXfWWHrq4zZw4j0pf/6GV4=;
	b=Wmx/ucCpd6Wb+uwfSU/EKvbDu5YQPltuC5QT0FqN0cuAqTvPpNLg5IK4sbsTBNl7ZcB+lZ
	DkONmCB7RH2rMcOsUYa90LMruamIkztYVtXKM0m3cUU0JTLFYdN7swNhUUNwC30RNBBMKI
	QrInXk2bxGIFAB6cW+AJooE0AoDWIxE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-mroJFneRPDeMSQepCz0R9A-1; Fri, 08 Jul 2022 10:38:11 -0400
X-MC-Unique: mroJFneRPDeMSQepCz0R9A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D4EB3806705;
	Fri,  8 Jul 2022 14:38:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A30E29D7F;
	Fri,  8 Jul 2022 14:38:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 474D7194706C;
	Fri,  8 Jul 2022 14:38:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 14B4C194706B
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Jul 2022 14:38:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 057D7400DFA6; Fri,  8 Jul 2022 14:38:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0161A40CFD0A
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 14:38:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC4421818805
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 14:38:03 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-2O6E8fHqP5G4zKK3g9AL_w-1; Fri, 08 Jul 2022 10:37:55 -0400
X-MC-Unique: 2O6E8fHqP5G4zKK3g9AL_w-1
Received: by mail-pl1-f175.google.com with SMTP id b2so16503626plx.7
 for <dm-devel@redhat.com>; Fri, 08 Jul 2022 07:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:subject:thread-topic:thread-index:date
 :message-id:accept-language:content-language:mime-version;
 bh=DhQKOpZ/hmWhurG+tQ8sJGg/yuf4DZYKSE1pmujbU2k=;
 b=UG387IhcK7sF3+BNLukTlITiGiBCQG0ohBiOxGUpQHbVBj5UPYMURlRqrNq94iDmQv
 J6REWD/iip+HwkFKuMXuWsjo0cLjDb2usbtV+Gq3zrkxzyteAO1TOx363FnfY80BPrTh
 B6WM/aI1z4PNg+ztcjbk4cNnMavgJajJgM+UhFR8qTxh7z25ilXkGHuZ8+U0DN85ZTsv
 /EX/ZImpM7r1qEa353SZoP0izL/w8IOji5Q58/9C7752sj+DGJI3uZN/uLKprO7QsQbi
 UreXAEnE5uH9cONRljzwvgAkR4jai6CRTRutp5xabhNayvw8AX1/kyx8k7ia9Lg01AWA
 bvJQ==
X-Gm-Message-State: AJIora/OGKixGGCUczZHbjP35+XmZMhDz5f2ztL68fFGURGI5EgBdOsK
 plSEFgc9cOwYMh0KsKXv05otfRTVcGA3NQ==
X-Google-Smtp-Source: AGRyM1tUf7H9Qz3CpUnUeO7+b+H+qVbq/LViiFeubPWOAaYWXbzGGssVmnrpiQkqRH2inzPFvcacAQ==
X-Received: by 2002:a17:90b:4a88:b0:1ef:e6a1:f2e5 with SMTP id
 lp8-20020a17090b4a8800b001efe6a1f2e5mr160936pjb.1.1657291074131; 
 Fri, 08 Jul 2022 07:37:54 -0700 (PDT)
Received: from BY5PR13MB3601.namprd13.prod.outlook.com
 ([2603:1036:307:4014::5]) by smtp.gmail.com with ESMTPSA id
 q13-20020a17090311cd00b0016bdeb58611sm12173956plh.112.2022.07.08.07.37.52
 for <dm-devel@redhat.com>
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 08 Jul 2022 07:37:53 -0700 (PDT)
From: Uday Jonnala <uday.jonnala@tessell.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: Regarding dm-clone on RHEL+OEL
Thread-Index: AQHYktfy1uF2kMqoDESHDLUViY7esw==
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Fri, 8 Jul 2022 14:37:51 +0000
Message-ID: <BY5PR13MB3601CBD8C5B444A014F19012FC829@BY5PR13MB3601.namprd13.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator: 
X-MS-Exchange-Organization-RecordReviewCfmType: 0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] Regarding dm-clone on RHEL+OEL
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============7671747589446605664=="

--===============7671747589446605664==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR13MB3601CBD8C5B444A014F19012FC829BY5PR13MB3601namp_"

--_000_BY5PR13MB3601CBD8C5B444A014F19012FC829BY5PR13MB3601namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Team,

Looking to see if dm-clone is supported in RHEL based OEL (Oracle Enterpris=
e Licence)
5.4.17-2136.308.9.el8uek.x86_64 : Kernel Version (OEL RHEL 8 based)

Which RHEL version has dm-clone checkedin ?

We are getting following error on clone
device-mapper: reload ioctl on clone (252:3) failed: Invalid argument

Thanks & Regards,
Uday Kiran


--_000_BY5PR13MB3601CBD8C5B444A014F19012FC829BY5PR13MB3601namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns:m=3D"http://schemas.microsoft.com/of=
fice/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;}
span.EmailStyle17
=09{mso-style-type:personal-compose;
=09font-family:"Calibri",sans-serif;
=09color:windowtext;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-family:"Calibri",sans-serif;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style>
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72" style=3D"word-wrap:=
break-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"color:black">Hi Team,<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:black">&nbsp;<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black">Looking to see if dm-clo=
ne is supported in&nbsp;RHEL based OEL (Oracle Enterprise Licence)<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.5pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#1D1C1D;background:#F8F8F8">5.4.17-2136.308.9.el=
8uek.x86_64 : Kernel Version (OEL RHEL 8 based)</span><span style=3D"color:=
black"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">&nbsp;<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black">Which RHEL version has d=
m-clone checkedin ?<br>
<br>
We are getting following error on clone<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">device-mapper: reload io=
ctl on clone (252:3) failed: Invalid argument<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">&nbsp;<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:black">Thanks &amp; Regards,<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:black">Uday Kiran<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_BY5PR13MB3601CBD8C5B444A014F19012FC829BY5PR13MB3601namp_--

--===============7671747589446605664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7671747589446605664==--

