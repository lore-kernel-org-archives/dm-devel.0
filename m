Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D98ECAAA1
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 05:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662962146;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=cmAbTwn/3eeXDwiNkMvBU9+UdRtwYN+0yPMjpw04cLU=;
	b=i10XZqIxW2S/RHXvuIlq587AZTGx8bLCkZyLkGnPMJGL77ihqdaraIHhRuRVMXlU6+aePC
	uUilTC3F3CVERJNuEpPPS4r4WHB9Tgv6mK8B/BmaeE6OiIG6NF5D7Zo42Gop79TcFznnn7
	/qmhe2tzaSLxxjPlIXn08a1SWcakoro=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-Wqhk8dsFOk63CK8h9t8QBQ-1; Mon, 12 Sep 2022 01:55:43 -0400
X-MC-Unique: Wqhk8dsFOk63CK8h9t8QBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D61871818340;
	Mon, 12 Sep 2022 05:55:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 950431415102;
	Mon, 12 Sep 2022 05:55:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6ED741946A42;
	Mon, 12 Sep 2022 05:55:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A30951946A41
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 05:55:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 81997141510B; Mon, 12 Sep 2022 05:55:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CC411415102
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 05:55:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65C388041BE
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 05:55:37 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12olkn2025.outbound.protection.outlook.com [40.92.23.25]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-4XLIJhfIPbadc1P_Yp6iMQ-1; Mon, 12 Sep 2022 01:55:29 -0400
X-MC-Unique: 4XLIJhfIPbadc1P_Yp6iMQ-1
Received: from BY5PR14MB3893.namprd14.prod.outlook.com (2603:10b6:a03:1dc::15)
 by DM6PR14MB3680.namprd14.prod.outlook.com (2603:10b6:5:1bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18; Mon, 12 Sep
 2022 05:55:27 +0000
Received: from BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d]) by BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d%9]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 05:55:27 +0000
From: "Pra.. Dew.." <linux_learner@outlook.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: Location for the definition of dm_task
Thread-Index: AQHYxmxCLNz35ps1e0m17HgOxE6+yA==
Date: Mon, 12 Sep 2022 05:55:27 +0000
Message-ID: <BY5PR14MB3893D6625238AD41746A53C786449@BY5PR14MB3893.namprd14.prod.outlook.com>
References: <BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com>
In-Reply-To: <BY5PR14MB3893CAD48C0E0661811682A386429@BY5PR14MB3893.namprd14.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [Lk+MgT56Zcg97b8Qczj07Nq3WYtczQ/V]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR14MB3893:EE_|DM6PR14MB3680:EE_
x-ms-office365-filtering-correlation-id: 18cd3cad-006c-4fdd-436a-08da948364c1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3Rkw+fzkWnjLOlufw6A2PbowBKy7ruRH6LQLmbTS7/pqo3WnG7CGs5fVI0F9dBfwVIoYMztR7w8g1rgEK5gKzIb5jjq9P+MNDBdTf3WkuCD1Fz+LlKrOHW8+5qVE0q4+gNJOpQYW6fNlapRnFYKZu1agzY/8x8w5Rm9yC1OUJ+uwqLtIiDlbL7LmtuJWokBf/V0YUWyNLZFpR3sQWwSGh+OVn8Lv7qdDKJ09mHerZ+rWC9vqqzyGm4V/jSib3NJ5i4OUlZy96mjYtDO7aIkTxU6+C0PDTYW9M1QsnAuuWoS9TZX1duNIEnEo8PqAYxkF94NKG/iigkQh5nPnLdz9Kei8rJ03eEjATlDSP4dGt+zDU0UvlM4I58xFw6DOj8rcdBvNFcxitAitcstI9LrvNmlsgpR2ma6nziizCN5MnS8WeWlrto3YA60P1Wpo161ewCjGB5/Tvklf+iWFt8dUyv6erF4ZMSpoVL+/BSov8+QC16Su/ZyiXemLpPcI0u1T4yb34/noel+u290Ihc/fI/IGiebbvIDp3VZDZxFCILj9P7EQvauqYpK7fba9UJnYVtPV4DIeIr1Oc4fV0gjdQQOOV2B2H5YNhI49GT+y7rCg5mdRF0uOIajaloga7v/V
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sxQ8brK52RSY3fQ7WnLq1ojfiwG5pT+DRD2+/C4cLjh2auXuLBWwMmba9OsE?=
 =?us-ascii?Q?17myIr+tNrfxTOHoTjoX/IJIgnx0uuQYvTYFRKFe511lewVpP5nB0B03aUeo?=
 =?us-ascii?Q?YrbbJnaz8vr6zv93h4ldHZzUVy6w6tJZHDgK1qzva3Mv05Wab0K6y+DjKx+w?=
 =?us-ascii?Q?TNaBLCL48jinWfVdDlfwvXwEWEeI6vDvOQBv+2JlTTfkl/MrYpDKULCsBFTM?=
 =?us-ascii?Q?g7l5x0QRZ5ByDtX7CYga7N2wuKuP9qEyQ5Rwuk0ZogpWJZKcKcHje+cYFqnj?=
 =?us-ascii?Q?E/1WGaSUCOyiwy85X6LHVmzBy+Rxkcm+OFjLCFiCrAvRpp6H58LHbV8w6p0S?=
 =?us-ascii?Q?mSV0DcozsysM6kKzEQn6x8pjkkgcoDtul8ZW+yjrEmtEfpkSBcINEq/0lUqr?=
 =?us-ascii?Q?xfFxMudz+AiyZFHMqmbgfh2QV0OTCXtLUfW+QpnhN0hKwLWzP67iMSvwWRqF?=
 =?us-ascii?Q?er26eVdmyGP3Ripl7vJijdwx82zWbpbgmyord0m42M2NgDpqTbtHoTraM+/r?=
 =?us-ascii?Q?S2ZTLeG9/dIL7rkeVYHBy2xvsJpytfZR+1xDDxhpoX8GbMT3ify9ViEOcMiU?=
 =?us-ascii?Q?X1BfcbGbVUyzIzTO8tqnkgahJbejLpyMZOwfp2qU0+LqGU6eH1wrmq6IsIGu?=
 =?us-ascii?Q?oKjmwv8MSsYAvbjihYIHUwuXPkh3dgemRlX5bRWxiZHH/OYAkoE0OvUdawXx?=
 =?us-ascii?Q?07H7IqjSYUQveh7a143JPYdFn3Lv9+5i+SAh1/WF28Jl3hSGp2ffQBwrL9T5?=
 =?us-ascii?Q?XCl6FqbVnJK7d2sGJHCN/owpEX+vx07b2E8VHlOT+I5l9keKI7Fr1sBmel+d?=
 =?us-ascii?Q?nOmu0T49XDcppghl6c4ZWC6AH/H8FMyX9RHm1Z131L0YIcM5evfI8M7Xx5R9?=
 =?us-ascii?Q?+3cQou7EvX4IUTAb3N9XvEH6CwbzGkp4dM/B90OSiFfqqoeLWFQljz9+BxXm?=
 =?us-ascii?Q?EqPs6J03uKuwGRohUrhdG4zROo9QULaAarmFE+nWaI3/8UI6+/PZdSsS6/Y7?=
 =?us-ascii?Q?Vs0QLBCODafFHGE72wtmsNeUJPVxutnRepstItQvvoa7TIRtoRnyLH1ErDrT?=
 =?us-ascii?Q?nNExVH6syEi2ZZ3kWEe8AdeT8XnCY1Nzghdq0x64KepequChecsyvmFPcGP7?=
 =?us-ascii?Q?yqXTdRORJ8udsrU4Il4N5m+yLXF220DNJu/XfBwiQJBNiWL47W6x9bbzHWoB?=
 =?us-ascii?Q?EsSK5Ud+0CKKWB+J9lncDZm283F0izRqMwhmXb47cia1Nfb71lCYxAFyRLBj?=
 =?us-ascii?Q?ueZYW1NP3rLuEBgDQUhjTLlS/XZIYmSo1A0ed054wEf5pWdLjwhF5y+Apq8w?=
 =?us-ascii?Q?YBE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR14MB3893.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 18cd3cad-006c-4fdd-436a-08da948364c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 05:55:27.8047 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR14MB3680
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] Location for the definition of dm_task
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
Content-Type: multipart/mixed; boundary="===============8905253274721586404=="

--===============8905253274721586404==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR14MB3893D6625238AD41746A53C786449BY5PR14MB3893namp_"

--_000_BY5PR14MB3893D6625238AD41746A53C786449BY5PR14MB3893namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I see that in libdevmapper.c<https://gitlab.com/cryptsetup/cryptsetup/-/blo=
b/master/lib/libdevmapper.c#L266> following line is defined

struct dm_task *dmt;

I cannot seem to find out where is dm_task and associated functions are act=
ually defined? I do not see them in the libdevmapper library headers and .c=
 files. Thank you for all the guidance.

Thanks



--_000_BY5PR14MB3893D6625238AD41746A53C786449BY5PR14MB3893namp_
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
code
=09{mso-style-priority:99;
=09font-family:"Courier New";}
span.hljs-keyword
=09{mso-style-name:hljs-keyword;}
span.hljs-title
=09{mso-style-name:hljs-title;}
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
<p class=3D"MsoNormal">I see that in <a href=3D"https://gitlab.com/cryptset=
up/cryptsetup/-/blob/master/lib/libdevmapper.c#L266">
libdevmapper.c</a> following line is defined</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span class=3D"hljs-keyword">struct</span><code><spa=
n style=3D"font-size:10.0pt">
</span></code><span class=3D"hljs-title"><span style=3D"font-size:10.0pt;fo=
nt-family:&quot;Courier New&quot;">dm_task</span></span><code><span style=
=3D"font-size:10.0pt"> *</span></code><span class=3D"hljs-title"><span styl=
e=3D"font-size:10.0pt;font-family:&quot;Courier New&quot;">dmt</span></span=
><code><span style=3D"font-size:10.0pt">;<o:p></o:p></span></code></p>
<p class=3D"MsoNormal"><code><span style=3D"font-size:10.0pt"><o:p>&nbsp;</=
o:p></span></code></p>
<p class=3D"MsoNormal"><code><span style=3D"font-size:10.0pt">I cannot seem=
 to find out where is dm_task and associated functions are actually defined=
? I do not see them in the libdevmapper library headers and .c files. Thank=
 you for all the guidance.</span></code></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_BY5PR14MB3893D6625238AD41746A53C786449BY5PR14MB3893namp_--

--===============8905253274721586404==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8905253274721586404==--

