Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87F4C48BE8
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 07:13:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 40605613AA
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 07:13:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40605613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=keysight.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604--WVOILB8NxS-yHg-FRHhzQ-1; Fri, 18 Jun 2021 03:13:33 -0400
X-MC-Unique: -WVOILB8NxS-yHg-FRHhzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F116418414A1;
	Fri, 18 Jun 2021 07:13:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2B9A5D9CC;
	Fri, 18 Jun 2021 07:13:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5F291809C98;
	Fri, 18 Jun 2021 07:13:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15HD9jA7004097 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 09:09:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 453D321144EC; Thu, 17 Jun 2021 13:09:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EBA021144F4
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 13:09:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74C6D101A531
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 13:09:42 +0000 (UTC)
Received: from havoc.proulx.com (havoc.proulx.com [96.88.95.61]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-76-LOVkd1l0OyaPrvHLep0NEQ-1; 
	Thu, 17 Jun 2021 09:09:40 -0400
X-MC-Unique: LOVkd1l0OyaPrvHLep0NEQ-1
Received: by havoc.proulx.com (Postfix, from userid 1027)
	id 2AABC69D; Thu, 17 Jun 2021 07:00:35 -0600 (MDT)
Resent-From: Mailing List Manager <mlmgr@proulx.com>
Resent-Date: Thu, 17 Jun 2021 07:00:35 -0600
Resent-Message-ID: <20210617130035.GA18977@havoc.proulx.com>
Resent-To: dm-devel@redhat.com
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15H0DHAf001308 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Jun 2021 20:13:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 829C41054E70; Thu, 17 Jun 2021 00:13:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D4E310D17BC
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 00:13:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D7ED1825061
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 00:13:15 +0000 (UTC)
Received: from mx0a-003cac01.pphosted.com (mx0a-003cac01.pphosted.com
	[205.220.161.93]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-330-sKBq4e6MNAO_C6YzMc8mtA-1; Wed, 16 Jun 2021 20:13:11 -0400
X-MC-Unique: sKBq4e6MNAO_C6YzMc8mtA-1
Received: from pps.filterd (m0187214.ppops.net [127.0.0.1])
	by mx0b-003cac01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	15GNo0gh023266
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 16:55:07 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by mx0b-003cac01.pphosted.com with ESMTP id 396xtjjkqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT)
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 16:55:07 -0700
Received: from PH0PR17MB4768.namprd17.prod.outlook.com (2603:10b6:510:8b::7)
	by PH0PR17MB4296.namprd17.prod.outlook.com (2603:10b6:510:8::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18;
	Wed, 16 Jun 2021 23:55:05 +0000
Received: from PH0PR17MB4768.namprd17.prod.outlook.com
	([fe80::144a:a1a:dd77:e1ad]) by PH0PR17MB4768.namprd17.prod.outlook.com
	([fe80::144a:a1a:dd77:e1ad%7]) with mapi id 15.20.4242.019;
	Wed, 16 Jun 2021 23:55:05 +0000
From: Yu-Ling Cheong <yu-ling.cheong@keysight.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: Source code for 	devmapper 1.02.110 & 1.02.137
Thread-Index: Addid4TWwOSM5w4PS4GDJFl5McS7TA==
Date: Wed, 16 Jun 2021 23:55:05 +0000
Message-ID: <PH0PR17MB476895D9984D5C945635D90FA80F9@PH0PR17MB4768.namprd17.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [202.183.76.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e0f8a8c-1128-4531-70a0-08d931222a3c
x-ms-traffictypediagnostic: PH0PR17MB4296:
x-microsoft-antispam-prvs: <PH0PR17MB4296CAB790CE2C69BCECD109A80F9@PH0PR17MB4296.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: HkngQfsekvmz8Xf/rdNPvCi2By8qzK/YnKSLgrdM1WNsdvczYzlJVCPRoSwM9FMj3J7AdRnrpZmou81sHeBK20YAdfBz1FcThMFoKO7+FXhSw3gfuo9ie+f1/V5ab3jAwpo4q0VeEeJvYZsv4AraK80EE2S0Sc27HJHoZvYl2L+MV+/ewHuoY3eLb0GboV2P5RAZOwUfrpGIbSkOklCOhmEwyBXsa+33U8L2vI/Ho3XkLl4Gl56TLK8Zn7248KNbcZWtMPOL5nXCQRYKSBeE1sYo7qQmES8XUbgqmbxWoyKC3hsUvz0E14VTa5Xl0oB+bhZFpLz3SyDgmkDWRTRu54YZ+qtIedkItIOqTL2gpkdLGPoAEUDJ6NCutijzYQVJ5QcqHMxqWyUm9WmtxfdyoTMXncSrvy3JK/51Suw2pJsupveaw6AK9y9ON4HzUBqRpmgAEnMC1bV7sCXX0muLsv0ISaJekV1ZALF3OxS2SgdmT+tsUkY/rpH4L7fC/AHscg2Eb+2vF39f6HoKR/DqpHh5TUARxfK2n3j2M6+QZxmN7SOXakHRkoYhxxNHggNLes69h08fY+xTOV5OPZzZ/8dqYiZbHY9kwoI/1pm/dvI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; 
	IPV:NLI; SFV:NSPM;
	H:PH0PR17MB4768.namprd17.prod.outlook.com; 
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(66476007)(52536014)(8936002)(26005)(66446008)(7696005)(66946007)(9326002)(66556008)(9686003)(55016002)(6916009)(33656002)(76116006)(64756008)(558084003)(6506007)(5660300002)(86362001)(478600001)(122000001)(71200400001)(186003)(38100700002)(2906002)(316002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DCcksd2GGRp8McHKT3SHsYCEQ1Y1LTEX5Z9uUZP2R+oLrAJBZ8n0tzO9Si92?=
	=?us-ascii?Q?Gz3MDej/l8+BNXkOdCIQb+x4c0R1Q+eP7HnxF54EtlvW9WLIiEXhULL7Ncrt?=
	=?us-ascii?Q?kOKSOWUG+5KR9743jspWe7Tn5GCtiAnZnDHkqyZlag+VBx43kU5dI+NmLXBb?=
	=?us-ascii?Q?guz+5Ep+tqfv2ofppZ3yPyvi1oqRzrwuAUDEJd62CGMUoqDd33xkdT6LStyF?=
	=?us-ascii?Q?M7KE+FqYwpra9YpEn/GVPvUtUFJptEbbrkLo41xJlUsg0FeZCO6J9OYphXE6?=
	=?us-ascii?Q?osMs7gvPKQxxypPle2NOXr45lusGdyCVSv9JsUvmVnm/zToE0mqsKxpvjDiB?=
	=?us-ascii?Q?9/VcWw8HZkFzcZ+5a9h/TAJBDSVNPmYvB//3+TK9kG4j1Raj741jO+005nzl?=
	=?us-ascii?Q?lIx9VO/iLi9Uts8vpQFlilJqawWrGC2xM9mT+hc8zmUtqqeNTVEZSg296vNK?=
	=?us-ascii?Q?OKZD/tLLevrT4s3qby0kVZo94VIHGiJ+enFOFsrT9NwGrfQ2ncXmCzuedc9x?=
	=?us-ascii?Q?Hktca/qO0DLGLRrWp1ZLzP2ngvQw9Dy57bwWbAjjM3Hygvs/7ihGH5aRo9C3?=
	=?us-ascii?Q?M7GYAf1V/+oeRVaDmBvzUUogyVyHSVRCQ0R2eq0poiIHw1rkPhdDNfh8K0Ld?=
	=?us-ascii?Q?Uxip0gMaMfC2d1pBmtSPNoZdOBkJ47nfnezjZxuTsG028fQoa2E6toY/OI0a?=
	=?us-ascii?Q?f7jE81hdUbhX/1RhCGgGPiS2pmvo/hFAh8p5/buBcF4F2nOB2dyj8SOYjKBJ?=
	=?us-ascii?Q?31fC8b86gKRQO4Hc43MiIegSwn++j/+G26oI6z+ukVLHh6v+52q83E6br2LC?=
	=?us-ascii?Q?z3zCa8u0DyY3Pya049fZghNwErDvro2Qau+gSJuygpLQif59YQPvv17TqgvA?=
	=?us-ascii?Q?lXhmMTvFDlvv4QeFpt4O1gIkxudBJlwXvTM1ygsuQQvY30ieCbZqXEuEJW1P?=
	=?us-ascii?Q?BYn652uQwpBuhaSzHt3hkWBgh/PLgyGNn47dKFQE6YgueRKkkqQWcC7U28+r?=
	=?us-ascii?Q?7muU0KVoiken97ma2t1B18mtWIW61/19/UzHSIXs0mfl8PNQOnvO1oV9WpYR?=
	=?us-ascii?Q?8aLrNZ2Y7RTBP+xVnT34fUYOfOLdjL2q3J/DdUo2Z/GkSmyZTGORAXlaIf/l?=
	=?us-ascii?Q?4s7Kc1HDnSKeR4I6ywqGYTthg9pbdJZhrlCOI7v1pyByHbRSwvhy9vbvBZGi?=
	=?us-ascii?Q?LDhmXFx40G6KL9tAqcFXB8nciYDIwVdPcp7LY8vl0ZdOotVwGJ2OT1gyR+AT?=
	=?us-ascii?Q?rT033GuyhOoqK8RLOOz+34C2vUxx7lB9lQCS1vZcjHX4C82+8PKxnN3+1IT/?=
	=?us-ascii?Q?dPxir/iMkUxMH1/ckzy0dlJJ?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: keysight.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR17MB4768.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0f8a8c-1128-4531-70a0-08d931222a3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 23:55:05.5455 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 63545f27-3232-4d74-a44d-cdd457063402
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PyUJdLZ3CODoHEqQzAU1qobzxck9s/yro8oCKUFBqUknF61ZvlN25DQET66h/3GiLQBzbF44jpVu/LgdOaPrSx0vUR0kXDabmKlLUzWCPr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR17MB4296
X-Proofpoint-ORIG-GUID: sWfwZM5j7wHu93vKxGIKima-7Ah0-4t9
X-Proofpoint-GUID: sWfwZM5j7wHu93vKxGIKima-7Ah0-4t9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
	definitions=2021-06-16_16:2021-06-15,
	2021-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	clxscore=1011
	priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0
	mlxlogscore=563
	impostorscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
	mlxscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2106160136
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Bogosity: Spam, tests=bogofilter, spamicity=1.000000, version=1.2.4
X-CRM114-Status: SPAM  (  -5.55  )
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Fri, 18 Jun 2021 03:13:11 -0400
Subject: [dm-devel] Source code for 	devmapper 1.02.110 & 1.02.137
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============4601944315191868558=="

--===============4601944315191868558==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_PH0PR17MB476895D9984D5C945635D90FA80F9PH0PR17MB4768namp_"

--_000_PH0PR17MB476895D9984D5C945635D90FA80F9PH0PR17MB4768namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

May I get a copy of source code for devmapper 1.02.110 & 1.02.137 to keep a=
s our reference?


Thanks

Yu Ling

--_000_PH0PR17MB476895D9984D5C945635D90FA80F9PH0PR17MB4768namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
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
=09{font-family:DengXian;
=09panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
=09{font-family:"\@DengXian";
=09panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09margin-bottom:.0001pt;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:#0563C1;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:#954F72;
=09text-decoration:underline;}
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
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">May I get a copy of source code for devmapper 1.02.1=
10 &amp; 1.02.137 to keep as our reference?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Yu Ling<o:p></o:p></p>
</div>
</body>
</html>

--_000_PH0PR17MB476895D9984D5C945635D90FA80F9PH0PR17MB4768namp_--

--===============4601944315191868558==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============4601944315191868558==--


