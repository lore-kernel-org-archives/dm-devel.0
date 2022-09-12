Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F86BC6FA82
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662997057;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=G12TNOE+dWirW3Eg59sUXpCCNv0prk95n2f3EPdljU8=;
	b=PSISOmdIegf4Ymmhw7DVx0V68neWiVhh5UHfsz+nSn6pIUTdZwQAY9u9V1Rbog1hlU7vEA
	AND6fGpnTQ8cQcXAk12UfYdrMQZkJ5LjjX143rm0WAjZkACCed3knp9OUlV5zcrxrVpHwt
	QnRYiKFI5YoWhuqFh+ktuk0MVduRgOA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-JITkAeLJPXW4gR_P5YsLrw-1; Mon, 12 Sep 2022 11:37:33 -0400
X-MC-Unique: JITkAeLJPXW4gR_P5YsLrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22A0985A58A;
	Mon, 12 Sep 2022 15:37:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F93C1121314;
	Mon, 12 Sep 2022 15:37:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BDF81946A44;
	Mon, 12 Sep 2022 15:37:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 89B9D1946A43
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 15:37:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 779881402BDB; Mon, 12 Sep 2022 15:37:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 71CD9140EBF6
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 15:37:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5412F1818235
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 15:37:26 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10olkn2098.outbound.protection.outlook.com [40.92.41.98]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-xMcbFunnN5ysbpnDF-yYgw-1; Mon, 12 Sep 2022 11:37:23 -0400
X-MC-Unique: xMcbFunnN5ysbpnDF-yYgw-1
Received: from BY5PR14MB3893.namprd14.prod.outlook.com (2603:10b6:a03:1dc::15)
 by SA1PR14MB5402.namprd14.prod.outlook.com (2603:10b6:806:22a::5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 15:37:20 +0000
Received: from BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d]) by BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d%9]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 15:37:20 +0000
From: "Pra.. Dew.." <linux_learner@outlook.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, "dm-devel@redhat.com"
 <dm-devel@redhat.com>
Thread-Topic: [dm-devel] setting up dmverity using device mapper IOCTLs
Thread-Index: AQHYxUUNjbfApk+Q00iI3gRwF7Bzv63bxQ4AgAAp4QE=
Date: Mon, 12 Sep 2022 15:37:19 +0000
Message-ID: <BY5PR14MB389395BF1BEB0118582907A186449@BY5PR14MB3893.namprd14.prod.outlook.com>
References: <BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com>
 <c7b61c01-a12a-9ed1-d3d0-f82b765a166f@redhat.com>
In-Reply-To: <c7b61c01-a12a-9ed1-d3d0-f82b765a166f@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [LBuWMPaPQriWI9ys5wS9d7EceayulwHN]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR14MB3893:EE_|SA1PR14MB5402:EE_
x-ms-office365-filtering-correlation-id: 103316e4-ccc7-4656-ec94-08da94d4ae0c
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2wqv71QuLx3eo/q6TIH4ZpyIrd8hZZfGpISF038cLj9wW9WdUHZSWuwgy2pT/ijwhywqkH1kiRjboB28WeP/Xel2XjZcX3hEu19mdVNhi+zNFP4lpkYu82RiH2Z8+Xys9W+mRJKMqUq/aCZwIghE9yIyDm3hoQ1WRJj6baHAWRHnGLdR776pnIcR9WRJ84ao4nctUwWFBrJTRaJ71gMaLwVWBwbmUNqe2RiCYISnrsK4yGOqQBIOZEKtSBtgcIdPGk2XmU8fWFUk5V3vy0s6P/LX6+lXN7vtk1MPTgzVosRmV0KZMOyenneNsqqXvTHEF1dqaQ5kVnIU55sH4BpxjTjO6tTRkcr9nkQab8OiiQrWvIyxs8o5rjXjWiqSA8GqyxhDr0nvWa2JXVZbH319Ej4De+sM1d0yYt31qH/p5GQxo9S1SVWwIa4ZIRYvICLamClsg6NVxob6mJr0NYb9F44CO8dyLdnm/QsrfDMz+hNd5XcVS+lGpNywK3iP134bD6WUYMAU7KZAZwOPdozAaahIQcfQagN5M1ETpvNJIus4665+hmDNcB10Jdtn2CUbm26B2xHuevJmw74/wlfGsEJVb5GeUV8fgWpacdLbZo9icW3ow+6wJKJ/gTBGrTwCZZpaPqFK9jvAvx3Ew10Jl7AJLTEz3iV7hXrQH8XzIIQqLCc8gvvCNsBsSLfNKRaz
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aDVaTnjsU5efndOTGhT3VDGtY12FeVT5PzlzQfyxzz9cFQp62YTHDRMnlGhN?=
 =?us-ascii?Q?B3KEMHQgZx2mUD2rglv84onaO4XMuxsIA5OnaGNvCvmm0AbOvw967zHbuRlg?=
 =?us-ascii?Q?dBTquXl0OuEWtx6V/H4Y+8LSY+8/euTSANqmmqJFz0s3mM3jxyyp/F2q1g0b?=
 =?us-ascii?Q?Jez1xqP9zjsdF+zX3/1gPErKf4GMzxjLUURcTKrEWEkuAWAxT2aiohPAAouT?=
 =?us-ascii?Q?f1C53f5v2jSRV4EN4QaZg6VbaGJMv9GRx6qlsvcJ88Uq1gk8PAj2NxcoCVmi?=
 =?us-ascii?Q?3FiFoQYkwuPoiIPvhiSB/W4BbIYUdy7dSwdKh72kqLGydbIw2LEWzfS4U2Ya?=
 =?us-ascii?Q?uWC9zvRSCPzcRG4OO9nf99YE+GhhPGYl6khHIEDHeG1nuKTUr+GmfZIlCEJ7?=
 =?us-ascii?Q?SXRZZc/upiRRPPf7oEAPIIqv82DUW0krw4FQI19FdaBAYHaM0L8HUUVd7mHM?=
 =?us-ascii?Q?ZjTygAMUo7CC8ijDQhmlIHsaKNkrx2aSTlTmqUlVhwEilmFteosVqr/H8ne3?=
 =?us-ascii?Q?6AdJFR01qF49tECmUc+hwXFVZha9W+AS+Zq+r/xyVW/8EhZYYoGNGxk6hQpn?=
 =?us-ascii?Q?ME+nvJQsmKxMD2JPMB0Gh8Ajn1CbP/OB8xGIYaDyiTHX4kWecuSwAAynUrrg?=
 =?us-ascii?Q?aerZBjSChstNcGfz8ZyTHLWmQqG1+xKEavGgf8gIBKhCEozmgVqtDP8FSSEf?=
 =?us-ascii?Q?ZGtXLAGFtydeSrar7ioyZtUnU73SzidBY/EQW+yh0XzUDsKjDHPipoAyYsQB?=
 =?us-ascii?Q?J8CJAD90cEo3RfNSdk+42tv3R/KBn+LCNELc4vh26p1JI/y2N4gz+6mjBuGg?=
 =?us-ascii?Q?rl7gmAU+y/oJMhaxdhV5MM/3V7xFvnnhFDGMXj1Pyj764AjlSs/B7O7m7msm?=
 =?us-ascii?Q?TKdWPGwbdeLc63mOks99o3r6YFuCEcdV2KoI96Ld1uYGibHxDlo/GgzP4/vk?=
 =?us-ascii?Q?eLN0oxDWEk1YgiDWXuR4W4VnJ7Ecqt8G1M6QYX4Uo2exhCjKKj3sbsW+tV0f?=
 =?us-ascii?Q?CiENQsqQ86vIxqUwPjGMpFh5TYLi8p7GRn/eiCIOIw4vnmAuVo262S0TjA9L?=
 =?us-ascii?Q?tCFAnOq8Fji1QTh0NL+gVg76VIoz7UbSU0+56v7HQvVfLDhTsJlwKU/iUGB9?=
 =?us-ascii?Q?NPWBkUgxe8UatI/kioxPi+X3wFdJwXHlS5M+YwhnEuXgAno+a8YBEiQjK0ET?=
 =?us-ascii?Q?xsmKmcgdHgs8x2S6wzn74v+mO8I393zqtyhVeeV4pmXG45VK1+Bf8aD9Rc5n?=
 =?us-ascii?Q?Lh6VbxglqdB3ECRdFza5KE2wz/ZIETXNnWZKBx00lqhi/oC79o5xN3uQzztx?=
 =?us-ascii?Q?7Qk=3D?=
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR14MB3893.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 103316e4-ccc7-4656-ec94-08da94d4ae0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 15:37:19.9781 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR14MB5402
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] setting up dmverity using device mapper IOCTLs
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============6485655815124881678=="

--===============6485655815124881678==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR14MB389395BF1BEB0118582907A186449BY5PR14MB3893namp_"

--_000_BY5PR14MB389395BF1BEB0118582907A186449BY5PR14MB3893namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thank you Zdenek. We are developing a embedded system with very constrained=
 memory/storage. So we are trying to see if we can combine utilities like d=
msetup with other Rust code for managing storage in our embedded system, wh=
ile only including the parts of dmsetup that we really need. Hence I am try=
ing to figure out what is the best way here.

Thanks

From: Zdenek Kabelac<mailto:zkabelac@redhat.com>
Sent: Monday, September 12, 2022 6:01 AM
To: Pra.. Dew..<mailto:linux_learner@outlook.com>; dm-devel@redhat.com<mail=
to:dm-devel@redhat.com>
Subject: Re: [dm-devel] setting up dmverity using device mapper IOCTLs

Dne 10. 09. 22 v 20:46 Pra.. Dew.. napsal(a):
Hello,

I need to setup dm-verity from my program-basically mount verity enabled fi=
lesystems from my code. I have looked at veritysetup and devicemapper (libd=
m) library. I was wondering if there is some simple C code to use the DM IO=
CTLs directly to setup verity. Any guidance to directly use the dm IOCTLs o=
r libdm would also be helpful. Thank you for the guidance.




Hi

I'd recommend  to exec "dmsetup"  call - as that's by far the simplest solu=
tion for your problem.

Verity tool should supposedly solve 'compatibility' between various version=
s and various capabilities of driver.

What is the idea behind redevelopment of this tool by your  C code  (as cle=
arly you should then do the same thing as verity tool)  ?



Regards



Zdenek


--_000_BY5PR14MB389395BF1BEB0118582907A186449BY5PR14MB3893namp_
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
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
.MsoChpDefault
=09{mso-style-type:export-only;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style>
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"#954F72" style=3D"word-wrap:bre=
ak-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Thank you Zdenek. We are developing a embedded syste=
m with very constrained memory/storage. So we are trying to see if we can c=
ombine utilities like dmsetup with other Rust code for managing storage in =
our embedded system, while only including
 the parts of dmsetup that we really need. Hence I am trying to figure out =
what is the best way here.</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div style=3D"mso-element:para-border-div;border:none;border-top:solid #E1E=
1E1 1.0pt;padding:3.0pt 0in 0in 0in">
<p class=3D"MsoNormal" style=3D"border:none;padding:0in"><b>From: </b><a hr=
ef=3D"mailto:zkabelac@redhat.com">Zdenek Kabelac</a><br>
<b>Sent: </b>Monday, September 12, 2022 6:01 AM<br>
<b>To: </b><a href=3D"mailto:linux_learner@outlook.com">Pra.. Dew..</a>; <a=
 href=3D"mailto:dm-devel@redhat.com">
dm-devel@redhat.com</a><br>
<b>Subject: </b>Re: [dm-devel] setting up dmverity using device mapper IOCT=
Ls</p>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div>
<p class=3D"MsoNormal">Dne 10. 09. 22 v 20:46 Pra.. Dew.. napsal(a):<o:p></=
o:p></p>
</div>
<blockquote style=3D"margin-top:5.0pt;margin-bottom:5.0pt">
<p class=3D"MsoNormal">Hello,<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;<o:p></o:p></p>
<p class=3D"MsoNormal">I need to setup dm-verity from my program-basically =
mount verity enabled filesystems from my code. I have looked at veritysetup=
 and devicemapper (libdm) library. I was wondering if there is some simple =
C code to use the DM IOCTLs directly
 to setup verity. Any guidance to directly use the dm IOCTLs or libdm would=
 also be helpful. Thank you for the guidance.<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;<o:p></o:p></p>
</blockquote>
<p><o:p>&nbsp;</o:p></p>
<p>Hi</p>
<p>I'd recommend&nbsp; to exec &quot;dmsetup&quot;&nbsp; call - as that's b=
y far the simplest solution for your problem.</p>
<p>Verity tool should supposedly solve 'compatibility' between various vers=
ions and various capabilities of driver.</p>
<p>What is the idea behind redevelopment of this tool by your&nbsp; C code&=
nbsp; (as clearly you should then do the same thing as verity tool)&nbsp; ?=
</p>
<p><o:p>&nbsp;</o:p></p>
<p>Regards</p>
<p><o:p>&nbsp;</o:p></p>
<p>Zdenek</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_BY5PR14MB389395BF1BEB0118582907A186449BY5PR14MB3893namp_--

--===============6485655815124881678==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6485655815124881678==--

