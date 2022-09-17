Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E67F9ECAAA1
	for <dm-devel@archiver.kernel.org>; Sat, 17 Sep 2022 21:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663451668;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=QeeVqj99zwEM3CaBuHNYfPRrq/ivehFI04wNBJnvBmw=;
	b=bngEN7PRByUlLPuTk6ghwoeOJuDib+up6MbOGUoFB1w21vHMdkwxo2Xz37xvPgYPbFj5QQ
	/Gsvpxg+3jjjAT3+mqMmjHTFdwfqBm3esu6pogO1dhMve0f8lr0k7rDMSC40+LFhIdTJxh
	X4QG2O03UPx9+Xf0iK6PM0GGaKwRXRI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-z_4JkCRXOCi8z_xU9Xcqhg-1; Sat, 17 Sep 2022 17:54:25 -0400
X-MC-Unique: z_4JkCRXOCi8z_xU9Xcqhg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE95F811728;
	Sat, 17 Sep 2022 21:54:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A04C5492B04;
	Sat, 17 Sep 2022 21:54:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 80466194658F;
	Sat, 17 Sep 2022 21:54:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D3FC1946586
 for <dm-devel@listman.corp.redhat.com>; Sat, 17 Sep 2022 21:54:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6AD7823176; Sat, 17 Sep 2022 21:54:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62AC517585
 for <dm-devel@redhat.com>; Sat, 17 Sep 2022 21:54:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D5213C025C3
 for <dm-devel@redhat.com>; Sat, 17 Sep 2022 21:54:16 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12olkn2073.outbound.protection.outlook.com [40.92.23.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-BpJWv6sHNfiLS2_VCM9gxA-1; Sat, 17 Sep 2022 17:54:13 -0400
X-MC-Unique: BpJWv6sHNfiLS2_VCM9gxA-1
Received: from BY5PR14MB3893.namprd14.prod.outlook.com (2603:10b6:a03:1dc::15)
 by MN2PR14MB4142.namprd14.prod.outlook.com (2603:10b6:208:1d5::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Sat, 17 Sep
 2022 21:54:10 +0000
Received: from BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d]) by BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d%8]) with mapi id 15.20.5632.018; Sat, 17 Sep 2022
 21:54:10 +0000
From: "Pra.. Dew.." <linux_learner@outlook.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: dm-verity with GPT
Thread-Index: AQHYyt8ji7+F7zo1TEqoOzC6k0hz0w==
Date: Sat, 17 Sep 2022 21:54:10 +0000
Message-ID: <BY5PR14MB389354D6BB8D1161E57B3FEA864B9@BY5PR14MB3893.namprd14.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [sb+B/kuU13aG16hTB5VqddyTj9jEfY+6]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR14MB3893:EE_|MN2PR14MB4142:EE_
x-ms-office365-filtering-correlation-id: e24e4cdb-fe9c-4683-0ed0-08da98f7272f
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 0ssCAXvqmz9MwNZoWDxEZBNjgsbAGqggpMgn4yCQsifML3T5q0HTzy5PdEag3K4BpQe+3YR3e+naDA2MrRaXJR46IBpz/o983O9jvKU+nuBUXf+H0Xvx2vWRfO3Id7o6YxM12kh1NaeFp4PSq7PZbWrc/PTltMYue4PkyLzZzG1pta5DcVjNAsTaKtYzYDJ0sIwtMTBy6N2hZyIUuUUDvSSsJJXk6oVfeZjjuxJYySTXvgkWNpF64lMOZWAqdd8v94doSFeYpsbLF6pMVu76Wo7GQuv73AsI3y6tNXANdVGBBMKIIeOv3s2QtBz3srWwgtH6Z9ixfdtsaYcdaqYs9g9SysjnHs07OKla6DHLRO2JzO+TWbWpjV+mzCAlb26mBhr/ngDHg5FZqajR2WQgBDdtkXyEScXuURW5hmZWl3z11zEzoDKFQb0MC6narVfqkNCZ9rmrJHWqdWzQsBnXPRL6rg/Xpt5oEQAmy2c3YXKDbjRy2cbl3W+d5CDnAqewSzKpSp17HJE8k2cIGblELKlqpNvovPbxq8x/6H4l/TQDiP7y3DW2Cx8KaT7RGgaCD2KXOtp257Yoo2U7GoldFahM37W23OPsc2a+3udyZckhxu5trubVi7YZmfcdmpSP
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AKMYNQ4axYY++RQp8yrTAbwLtEO8K9OzpESt+8ydwSEZljgQxzX2xP3G64KF?=
 =?us-ascii?Q?yK/sxYcLwjjN/phUIMbMcdV9Spvg7FFG6qadfYO3aUR+vXbpOQu13D1gNC98?=
 =?us-ascii?Q?SFIF0rtxyHZpLMiVxNtuhhgz8wk5OHuEuCHil7DLmGAPMfxTkoxN+r8wN+z+?=
 =?us-ascii?Q?kDo2wxo199gP2M3xpDYhUr2zda9V2xgabDTGnN3KKG6L+fa0mU8+qyctw+Pn?=
 =?us-ascii?Q?8orTMA4eQZdcmqpIuaOM7YiechsAJ7o50uIJDD9ExcDOFg7/qVrf/SGNGahO?=
 =?us-ascii?Q?490IMwQImyObop6gZwyMyY1ih7az4RIEVJuJyIvvent6dxWU/XdLzwwJQHac?=
 =?us-ascii?Q?1lJL+J0H9Y+pW1WOkJy0gdoYscMTJTJ/aejmKBHm2xby4qkm4H8DcYNFfjuZ?=
 =?us-ascii?Q?fhHdWcxKb+H14KPiWK+38k10RjcZMQNKQAk0oN+d7VST9+QupxXb/SMZTxEJ?=
 =?us-ascii?Q?vT9bsX+jjwd7TBf6E3on3gCatf23wwb0UkJIvRZjj7CxJYrLaUl3wJfMjGqD?=
 =?us-ascii?Q?tN8w/naGXn/fp6qQptTEhotNGHvAL/Du5QVEkXTzL8aHyeeeftPDRruAWA3n?=
 =?us-ascii?Q?sXMbHTtOaG36teO43q7ueL3FL7vLwklsMhng+/j3ePx3jvzhfZC1d6tzS06g?=
 =?us-ascii?Q?nqCWbYel4wdr7httzyA4gK0qX7CCaob3VBE/wGJRrdWEp8EMVW6xqOjeml13?=
 =?us-ascii?Q?lAJTV3+hymGbzlOswGnhX4EzaBdWElRVVUllSxx9ejVn+mEZrH+VnmuUjOu8?=
 =?us-ascii?Q?Pb5FaTSlSf+L/YoA+cJGkil39nlfYuL2qYZKbuBLOZ+z3B25lIUXxNNI1WnU?=
 =?us-ascii?Q?Ju3SQ69G9TxC4I1kiw9cLjl47IABwYwGV/ND3hDPioKybaBVM46a+79mLBmz?=
 =?us-ascii?Q?Ngxe8I5efQacN3bEIf1xD6yyhsgSbN3gVavz6zo73axVBRrpA0Y35+VufsAN?=
 =?us-ascii?Q?JEI+iKAsjN4jDJxH/YjWIxhUAXwBLVidGDk9ykFXYtEr55TAf0YQfBqibgP7?=
 =?us-ascii?Q?LbC8P4jJhDi+egd3rBvL78lawy8umPWzyldCY4eeUY/JBYJhLkr3mzlzI6ST?=
 =?us-ascii?Q?iqh8Eitjuy1QemrGTfO1tsO349Sb4MaGutbBiKn3UU7kCbsLtRqhYjJI2/vj?=
 =?us-ascii?Q?ZxuBoZz4R6BzeOxCnbKiHvD3J+ej4WRfewsRTwwXCcRafZdaVTfQHizQIsNh?=
 =?us-ascii?Q?cCnGgyl02EmZm7jmpZpd138OjHto8kBiv0ZoBF8edPqVSe8QTiU3TF3W3RMR?=
 =?us-ascii?Q?cIn5TIvrwOKPrpQENRZGDddI44W2n70iSpOOQNpGLvEa3WYqcH2GIyfkAOeS?=
 =?us-ascii?Q?Lj4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR14MB3893.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e24e4cdb-fe9c-4683-0ed0-08da98f7272f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2022 21:54:10.7773 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR14MB4142
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] dm-verity with GPT
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============6223939271314194687=="

--===============6223939271314194687==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR14MB389354D6BB8D1161E57B3FEA864B9BY5PR14MB3893namp_"

--_000_BY5PR14MB389354D6BB8D1161E57B3FEA864B9BY5PR14MB3893namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

We have a scenario for a VM where a VM is running in the host Linux using K=
VM. We want to expose verity protected rootfs to the VM. This rootfs clearl=
y needs to be RO. However, we also want to expose it as a GPT partition. In=
 order to do this we are attaching two small files before and after the roo=
tfs. The files use linear mapping and get mapped to the same /dev/mapper/XX=
 device that has a verity partition. These two files contain the partition =
mappings (primary and backup) for GPT. From the VMs perspective, it sees on=
e device (/dev/mapper/xx) as a GPT device with rootfs.

The challenge we are getting into is that dm-verity kernel implementation e=
xplicitly prohibits mixing linear and verity mapping and forces the /dev/ma=
pper/xx device to be RO and our needs are exactly the opposite.

Has anyone seen this scenario before? Any suggestions?

Thanks


Sent from Mail<https://go.microsoft.com/fwlink/?LinkId=3D550986> for Window=
s


--_000_BY5PR14MB389354D6BB8D1161E57B3FEA864B9BY5PR14MB3893namp_
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
<p class=3D"MsoNormal">We have a scenario for a VM where a VM is running in=
 the host Linux using KVM. We want to expose verity protected rootfs to the=
 VM. This rootfs clearly needs to be RO. However, we also want to expose it=
 as a GPT partition. In order to do
 this we are attaching two small files before and after the rootfs. The fil=
es use linear mapping and get mapped to the same /dev/mapper/XX device that=
 has a verity partition. These two files contain the partition mappings (pr=
imary and backup) for GPT. From
 the VMs perspective, it sees one device (/dev/mapper/xx) as a GPT device w=
ith rootfs.</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">The challenge we are getting into is that dm-verity =
kernel implementation explicitly prohibits mixing linear and verity mapping=
 and forces the /dev/mapper/xx device to be RO and our needs are exactly th=
e opposite.
</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Has anyone seen this scenario before? Any suggestion=
s?</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Sent from <a href=3D"https://go.microsoft.com/fwlink=
/?LinkId=3D550986">
Mail</a> for Windows</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_BY5PR14MB389354D6BB8D1161E57B3FEA864B9BY5PR14MB3893namp_--

--===============6223939271314194687==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6223939271314194687==--

