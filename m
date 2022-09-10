Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A48CECAAD3
	for <dm-devel@archiver.kernel.org>; Sat, 10 Sep 2022 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662835613;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=mmLCa8hmhPTlcim7SlPahBgHk0Dzpt9iaP49POJ9poc=;
	b=ZuhNKTuoGpFY71iPQBTS8QQID5uvzCa5QYnrlu2v/8f249CXAGf3DXnO4GfvxmIPnWITSq
	s0o5GYkQ1B4DSQXUTKS64M87UtfMvBFVg+9I5hlfKT11Q8ZW5cAfjucVMxTJ//m7rENDX7
	Cz6+Hbjmj/w21BwhAAsKgVszzlJ2WjY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-0aMi91KpNbWDhAKuFXYt_w-1; Sat, 10 Sep 2022 14:46:50 -0400
X-MC-Unique: 0aMi91KpNbWDhAKuFXYt_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3903B811E80;
	Sat, 10 Sep 2022 18:46:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62CAF14152E0;
	Sat, 10 Sep 2022 18:46:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 247C61946A42;
	Sat, 10 Sep 2022 18:46:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9927A1946A41
 for <dm-devel@listman.corp.redhat.com>; Sat, 10 Sep 2022 18:46:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6C5864010FCC; Sat, 10 Sep 2022 18:46:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 674AB400E88E
 for <dm-devel@redhat.com>; Sat, 10 Sep 2022 18:46:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B1491C05AE8
 for <dm-devel@redhat.com>; Sat, 10 Sep 2022 18:46:42 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11olkn2066.outbound.protection.outlook.com [40.92.19.66]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-aiwjhvGiPS6wa5-wZgF-Ow-1; Sat, 10 Sep 2022 14:46:40 -0400
X-MC-Unique: aiwjhvGiPS6wa5-wZgF-Ow-1
Received: from BY5PR14MB3893.namprd14.prod.outlook.com (2603:10b6:a03:1dc::15)
 by DM6PR14MB3385.namprd14.prod.outlook.com (2603:10b6:5:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sat, 10 Sep
 2022 18:46:38 +0000
Received: from BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d]) by BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d%9]) with mapi id 15.20.5612.016; Sat, 10 Sep 2022
 18:46:38 +0000
From: "Pra.. Dew.." <linux_learner@outlook.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: setting up dmverity using device mapper IOCTLs
Thread-Index: AQHYxUUNjbfApk+Q00iI3gRwF7Bzvw==
Date: Sat, 10 Sep 2022 18:46:37 +0000
Message-ID: <BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [b7YEXxyEnK2aJab+W7q27ezqp3/0mdlT]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR14MB3893:EE_|DM6PR14MB3385:EE_
x-ms-office365-filtering-correlation-id: d151c5a2-c760-4b48-c68b-08da935ccb28
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MhNnLr9xgKpUx3Jqn50lqTSUM1Nzz3WBYfUYF59MNMZ8vH7kcCaDPPhQc+q6Yd+jvjAjwi+FEklEmGiwCF8p1omtJ5RkrKJMgbQ/ssngql9jYVR4tkZJRF+9LGMjKoogzNjASxkqpGoPgDDt0TlGmVvrmRWtdfn4eLGambUsn1Y1I1A3YfJSmv902Qqb7kG3tBjHGGxxs9ksL4xoZVImk1VtIkvhCYSD5D60xSS5pQA6XeCE8XT6qc3FhkEvCYWc4OidkUH8+svMymy0HMWcVWZvLGhb2Kr7ZoGaK2Gw0fWiKPaWXfenDwsZkyxeW2ScN+8yfhN8WcMok+TQPCcW4HwjLiHCv+RjlWF4ziuv29wWp2J0BUUfU0u9eZ/ZnNyoCEgyCecqA046qH3IVBK/aOJbQ0UeyIJb2NNRlP3qPpqrrfkFWg4KuIN81SKNNAZg4E56VcW+t/zpKH7YgHnTMA48xOSWM7AbJUNC7EmKGrLp5GzVp5xOcphLFpsoeC/g5wMHNHDYK7HVJ+mxMRfPok1avUVrb0WH2LDKnK95JwDrEz1gO3bEQBWfJEZLMtEK2H7hM7UZv2YE0y3341+nP4Xv3uCeYa5qj5InyNzBSGZvR7gHV9FMWBwMpXJIvvT7
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WRCwh664IJYfl904QUgfaVxADsRyEoRJlSdaNASHCF6bK2/3EnSnJKV68qwz?=
 =?us-ascii?Q?sm96oX9Piy2NgZXuuCygOXXLW5cKimMikxUrNZHK450/biQxGBvXhY//4eL5?=
 =?us-ascii?Q?GKxobNXNokPm6CiXs360YpD07ZN/X/ljfu95S1uG6AUPfkjXCRpCTHxug/Bv?=
 =?us-ascii?Q?01d/pC9FD9AJNx+Mk1YoIC5FxTqtzjkKQmpR/0Vf7/zZCYlKrDGW+ubtmMRp?=
 =?us-ascii?Q?Bvi3RwSvkAyx0Bm4R085tkdITJaivcxihfLrT0vb1M17K6vpZUKIC878Vrt1?=
 =?us-ascii?Q?aUfWjl5KwcLdhIKL9Dyxq8py9N/NDAdZAFcfXsFxUiXwukt2+6Sy0vVNSBwx?=
 =?us-ascii?Q?sejQcx9bi1dVYtB1vDZP7ntsnFv49SQMHfG2vsaovJ7GW5ioAu6uPC+l+iM5?=
 =?us-ascii?Q?RCw+YHpyF8i/X7/jQFwFiTLJBho82viREMPie9X6V14aZD7/mcmKFgUJK8c1?=
 =?us-ascii?Q?B/gn+Lj7M5QNSUVeCADw3+NxZyenSBJolF7eGAwK7rCnZKLCe0pyX6f3UaQZ?=
 =?us-ascii?Q?nYDF9kZCy8u578lgxDT9DTUkUi7aNz16+aqMQodGkTVZGPguHoUrCN0Wlr8E?=
 =?us-ascii?Q?H6NETRUIkcuIjMJmoP95mb0maTW9Sl7v1JcKBQ0XUlFk5Udlo4+LLE+0nCA0?=
 =?us-ascii?Q?dTJ7sB2pyxc2W3xb4KXhCLeFi8Netcfx82t45YWfNQ7IzgJ07r95H9TcuK16?=
 =?us-ascii?Q?E6XeK2zvvqwa6Hsm1QEjGOnPSyMkmmtVu1lVzArZfwkEDjQKGG9vIRTJf69L?=
 =?us-ascii?Q?B06fe+Y93SFBJ0L4F71hCPi/SbVja09WEmUf+955BBHA/r9LUb8yU9XlOmBB?=
 =?us-ascii?Q?3wF2KuqTOq/n0jLGxMLy9ogtAjcUwLSkvBWKT+5I2G9CzYESTPVBHCeV106H?=
 =?us-ascii?Q?ziDYNXbowgWKDAzfxU2l0NS3vRchm1PKTwji+D1tIYyeZyUib0WevAle4XLN?=
 =?us-ascii?Q?bHO9jofmTGbd1f6zvk8VDe0iplm6ArjQgfMzeoWtawCIgSRbHyy8i1gfJSOg?=
 =?us-ascii?Q?pagiPdj+UxHsvs2/dHROE3PUfoCqnb3WeEHkO5JFlv7Q5LzynQZrVT5izVPE?=
 =?us-ascii?Q?OdCUpsaj2EC0t/RnjpmcaooVRh/qvXjxSe8gLKfnbQvj3VdeBJVWCRg+EcfY?=
 =?us-ascii?Q?lnybl12YRKOd2gxVUGKSHhWpATIhQVHl/dmv2fGMQbmrosgo2GCg9aW228+G?=
 =?us-ascii?Q?PYob6JifXDBwJTSFvONaMDyKaa0Bz/JwjcYBjKuGvj4nKpxPp5F+xU5r4+o/?=
 =?us-ascii?Q?+dgo7j1RxptMiUv49u8XPZgk3mzYJup3i9uDDZiSjNrSHEFqy74Pc1CuNeOV?=
 =?us-ascii?Q?AxA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR14MB3893.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d151c5a2-c760-4b48-c68b-08da935ccb28
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2022 18:46:37.8568 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR14MB3385
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] setting up dmverity using device mapper IOCTLs
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============7433451000112654828=="

--===============7433451000112654828==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR14MB3893CAD48C0E0661811682A386429BY5PR14MB3893namp_"

--_000_BY5PR14MB3893CAD48C0E0661811682A386429BY5PR14MB3893namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

I need to setup dm-verity from my program-basically mount verity enabled fi=
lesystems from my code. I have looked at veritysetup and devicemapper (libd=
m) library. I was wondering if there is some simple C code to use the DM IO=
CTLs directly to setup verity. Any guidance to directly use the dm IOCTLs o=
r libdm would also be helpful. Thank you for the guidance.

Thanks


Sent from Mail<https://go.microsoft.com/fwlink/?LinkId=3D550986> for Window=
s


--_000_BY5PR14MB3893CAD48C0E0661811682A386429BY5PR14MB3893namp_
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
<p class=3D"MsoNormal">Hello,</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I need to setup dm-verity from my program-basically =
mount verity enabled filesystems from my code. I have looked at veritysetup=
 and devicemapper (libdm) library. I was wondering if there is some simple =
C code to use the DM IOCTLs directly
 to setup verity. Any guidance to directly use the dm IOCTLs or libdm would=
 also be helpful. Thank you for the guidance.</p>
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

--_000_BY5PR14MB3893CAD48C0E0661811682A386429BY5PR14MB3893namp_--

--===============7433451000112654828==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7433451000112654828==--

