Return-Path: <SRS0=qylv=OV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588EBC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:25:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E092761A58
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:25:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E092761A58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=dell.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-4DxxQw45MR2F-j17Lm6Uww-1; Fri, 01 Oct 2021 02:25:23 -0400
X-MC-Unique: 4DxxQw45MR2F-j17Lm6Uww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D500819251A0;
	Fri,  1 Oct 2021 06:25:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B77515F4F0;
	Fri,  1 Oct 2021 06:25:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 85E6B1806D00;
	Fri,  1 Oct 2021 06:25:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18UEWhep008420 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 30 Sep 2021 10:32:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2E1A820B1DB1; Thu, 30 Sep 2021 14:32:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25C8F204FEC1
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 14:32:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86E70899ED3
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 14:32:42 +0000 (UTC)
Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com
	[148.163.133.20]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-99-1MDY-6XvP9OHbLNg2WoG4w-1; Thu, 30 Sep 2021 10:32:38 -0400
X-MC-Unique: 1MDY-6XvP9OHbLNg2WoG4w-1
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18UDdthN018898; Thu, 30 Sep 2021 10:32:36 -0400
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com
	[67.231.149.39])
	by mx0a-00154904.pphosted.com with ESMTP id 3bcr15w3kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 30 Sep 2021 10:32:36 -0400
Received: from pps.filterd (m0090351.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	18UEPJPK153455; Thu, 30 Sep 2021 10:32:36 -0400
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by mx0b-00154901.pphosted.com with ESMTP id 3bd1kp3rfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Sep 2021 10:32:36 -0400
Received: from BY3PR19MB4852.namprd19.prod.outlook.com (2603:10b6:a03:36a::19)
	by BY5PR19MB4019.namprd19.prod.outlook.com (2603:10b6:a03:22d::7)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14;
	Thu, 30 Sep 2021 14:32:33 +0000
Received: from BY3PR19MB4852.namprd19.prod.outlook.com
	([fe80::d513:3057:e936:c33f]) by
	BY3PR19MB4852.namprd19.prod.outlook.com
	([fe80::d513:3057:e936:c33f%6]) with mapi id 15.20.4544.023;
	Thu, 30 Sep 2021 14:32:33 +0000
From: "berthiaume, wayne" <Wayne.Berthiaume@dell.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Thread-Topic: [dm-devel] [PATCH] multipath-tools: make EMC/Invista config work
	with alua and multibus
Thread-Index: AQHXtI64SCYxEW7nJ0mF1nisHntFbau8pg+A
Date: Thu, 30 Sep 2021 14:32:33 +0000
Message-ID: <BY3PR19MB48522AA6EFF15AC8608253ECE2AA9@BY3PR19MB4852.namprd19.prod.outlook.com>
References: <20210928173121.18081-1-xose.vazquez@gmail.com>
In-Reply-To: <20210928173121.18081-1-xose.vazquez@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2021-09-30T14:32:32Z;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No Protection
	(Label Only) - Internal Use;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=e5cf8df9-290a-4a94-9bb6-094aac65e489;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbf71547-e28b-42a4-74a7-08d9841f23fe
x-ms-traffictypediagnostic: BY5PR19MB4019:
x-microsoft-antispam-prvs: <BY5PR19MB4019CA7B148ACB6578CFA52AE2AA9@BY5PR19MB4019.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lnNh4sXLD3Je+aTfd0Ko4Ink+1ZCR+cSoq9zuvFTkFGi/dGXLGp6lVnI9qKPymYIVC+WYf3o+ESWgBl1AZNIzMja/F1Bvfh+RpiX9R0TIW8HcA8+SKohNFSe5VaDWNfJbist6ZSQiG2sxSGWH2o0+TeW6Tj+0qYjQtTxi+/fg3jPn9h/5NXJ2/twV1G2G5xSAzJ43zGG84lRFRX49JZftbF/0lb046xr/kcbcLJDcTGwsHqtMuaoysqTu0JknKGN89puOWiPQqhZmX2MtolZasafs7mDyaUbwRSjkZm3UTl8HAlEf5CKSEXVog/ShcH3ObeEGjWtWriWUetjeHjKh5LAmdEfIZH9ZYOejq4J0Hkl6zVfBxrmjjQL67/rBGrbqGRqCW6xTTxHUWFEdvhKG9wLltliESbqnai76hi7Kla2+T+ay+wz9tYSZUo3GAtFi4LGdueX+VSbPNLTlgQ2ZLCLNcI5sYEPIfi402ULNkkDiHg2JFFfm99sqwH2Tvx6vbgspHjjcZK4g/O72gJbnRBz0DPY6ECChd9vw8cvBlTOyMaNWsW+WqkXnUzrDhJn6hDAQ1Ja5gnsY//YG9d/4yvZyLJxd3bKvBKSdGZpJs5fyTbpHtodjspUVytCxHM44lmT0W3QDIMi0XCEuqCy6E8YofGm/jjKc7rDFIm3egdQMEoxG/atRz6EgJrFeebM4kuE37BcpBvL6FmNnyyxEMKn2IjnWtYNGS7WKxH7twBKngDsJjA2l9gbhiotOrzVlpbwejIk0SRHRIM2Hay6JWgef7G4o26zKtnCGM8ITupXeCvxS1pqo6gt33L3H2IHSYla7KfMm0dVfbQoR3zTSg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BY3PR19MB4852.namprd19.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(54906003)(55016002)(316002)(71200400001)(83380400001)(40140700001)(66446008)(64756008)(66556008)(66476007)(5660300002)(966005)(76116006)(52536014)(4326008)(508600001)(9686003)(6916009)(38070700005)(2906002)(38100700002)(66946007)(7696005)(6506007)(33656002)(122000001)(8936002)(26005)(186003)(86362001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GTFrHumyobEulArTuaQBZBlmxniJ5IPHMDIGImBGQwegR9ncBL5ymPuThh7O?=
	=?us-ascii?Q?Rk/aLETqe2M/UgY53B939Mr27hk0kDmtKwimQXv1Y7Lma9Rase/6Nw/nBg7X?=
	=?us-ascii?Q?tEnqR9Om9iYk0PEOEBiH7rrfKrRepzPH8Oh9HqCNz62t5BWqciqxzMgC0wBw?=
	=?us-ascii?Q?TlWVXQjP8zP9jpBM8NWhKwWApzDpb0bDBp7ea+bYC/I7iyv1M8MNu98dGQVh?=
	=?us-ascii?Q?TUWeMFIqvma5oVesecN8sYdzxF0m85uFgNk/CmvJU9rzyPUlexUGktkntJIq?=
	=?us-ascii?Q?kZl3asw+wW1T9ykVR/cYUaesh2r3CqpfHZQZq8kSSnv4iMowRbgaTBeJLyyM?=
	=?us-ascii?Q?MU/N/UB9DoHhAxY15xo3AwpifxMjLctrOE8OkYTgjYZ1rtLWWYLesqMcnuJD?=
	=?us-ascii?Q?Z5k0yhEe9CfLvW2+q4EIVBBaJ6Ark+rdmwBjFVBdXbGIb+izmbFy4bm9fqCN?=
	=?us-ascii?Q?kFTfdwyisWIDDmAldjT2Dtht7dt9ycTPpgu4tqOsKdc3l4k4w4zNJ6crykVV?=
	=?us-ascii?Q?Lr21jv83foPPUmHAiMPwyUzIzbo0f77Umgakv/pOLnlYJPOCnMX3DJyDwTJx?=
	=?us-ascii?Q?a0W9sq7rFcYPVj4BtYHEQWyHhMWxi+FGVaWxB+UNBRhdc8RjlBDiuSEdbtdV?=
	=?us-ascii?Q?5pb0386vGhqTrUQUPnTxARROdkGG/cuKVgDeI3Ll1o/B8YDWITJZuxMc6ZDS?=
	=?us-ascii?Q?6s9Ct/OKFMhJgzRACwZQH7LbMIJgiTtmMrzYe4APd2yTTwN3l9YEr2Tw0TO4?=
	=?us-ascii?Q?8EzuC+I7AdshzlXlDBAmDF6U3M2dwbj8w1VEhgmdCOhfuYY1alUss+fEjPFn?=
	=?us-ascii?Q?pVyVCzUlaaGW3PnRGi4TXdP6m2wLasp2zlj0Ys/V3+nWUAJpRq2S5PBk9D3J?=
	=?us-ascii?Q?rQc1NB/z6Avl7tu7mXPnCIvvPrAO6WtSTGXGmy9USJoEfHJCtc1aMnaRy8TV?=
	=?us-ascii?Q?akQ+sGoEKsYw9bQ64JzEXZHGtrI6Vrz4YEjLjGJDWMwohWuGrecG7efz4CeX?=
	=?us-ascii?Q?E5WlQZ1z+xr6h3ghkbus3+lmSqqnjk2GHLBqzSLq9J/4aAHJspSA60SBjfqR?=
	=?us-ascii?Q?5AdQi5XpLMLxcmY3a7+ZFY88+8WGSbd7WrJLa7kjjcL6RA6DEUxogkvAQmZf?=
	=?us-ascii?Q?tF14+XUTlNPvfb0HLWAP6HinFsvA7RCv1i2KNBUZOv7RLOsfMJLlmqMdOaDv?=
	=?us-ascii?Q?YExH9cMd4goosiXua+jiedQ3G7XWWowl0J+lcCfJVh8nhlEinDegsRk9Lfsy?=
	=?us-ascii?Q?PD4YyBkRqB/C3Z2dMihF/K2qV+mTpMg3NMw83kwOlfQcc4Te7nOdRst+uSD0?=
	=?us-ascii?Q?6fkZFY8PR3fRWJCKpApo+kA2?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR19MB4852.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf71547-e28b-42a4-74a7-08d9841f23fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 14:32:33.1759 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fOp6jp0T+NlzwTtcMNdjxER8k4iXMXk+7ndg0kMPwq1LYIw6fe80Z1bmQ4jantL1F1FbI+Zltz3p2M8EEkwOmqHWQmk97tzSFh2k6LQB+ZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB4019
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
	definitions=2021-09-30_04:2021-09-30,
	2021-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	malwarescore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0
	clxscore=1015 lowpriorityscore=0 mlxscore=0 priorityscore=1501
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109300091
X-Proofpoint-ORIG-GUID: BuWmN0LPy37cjdjVuxZSn0Ni-0SKiUNp
X-Proofpoint-GUID: BuWmN0LPy37cjdjVuxZSn0Ni-0SKiUNp
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 phishscore=0
	mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109300091
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18UEWhep008420
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 01 Oct 2021 02:24:53 -0400
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: make EMC/Invista config
	work	with alua and multibus
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Xose.

	OPM is no longer supported in the Dell VPLEX product. If we at Dell had wished to change the default device stanzas for any of our products they would have been done when the product and/or feature is released. Please remove this patch as well. It is not needed.

Regards,
Wayne.

Wayne Berthiaume
Manager, E-Lab Engineering Platform Qualification Team 
Dell EMC | Server & Infrastructure Systems | Platform and System Engineering | Infrastructure Engineering & Operations | e2e Validation Lab (E-LAB) 
176 South Street
Hopkinton, MA 01748
+1 (512) 647-6157 (office)
wayne.berthiaume@dell.com 
"FOLLOW" E-Lab Engineering at https://inside.dell.com/community/active/po/platform-system-engineering/elab 
Confidentiality Notice: This email message, including any attachments, is for the sole use of the intended recipient(s) and may contain confidential or proprietary information. Any unauthorized review, use, disclosure or distribution is prohibited. If you are not the intended recipient, immediately contact the sender by reply e-mail and destroy all copies of the original message.


Internal Use - Confidential

-----Original Message-----
From: dm-devel-bounces@redhat.com <dm-devel-bounces@redhat.com> On Behalf Of Xose Vazquez Perez
Sent: Tuesday, September 28, 2021 1:31 PM
Cc: Xose Vazquez Perez; Martin Wilck; DM-DEVEL ML
Subject: [dm-devel] [PATCH] multipath-tools: make EMC/Invista config work with alua and multibus


[EXTERNAL EMAIL] 

Optimal Path Management (OPM) was introduced with VPLEX 5.5 to improve VPLEX performance. OPM uses the ALUA mechanism to spread the I/O load across VPLEX directors while gaining cache locality, pag #187:
https://www.delltechnologies.com/en-us/collaterals/unauth/technical-guides-support-information/products/storage-2/docu5128.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c index 7095aaf1..4e8b52ff 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -350,8 +350,9 @@ static struct hwentry default_hw[] = {
 		.vendor        = "EMC",
 		.product       = "Invista",
 		.bl_product    = "LUNZ",
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.no_path_retry = 5,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	{
 		/* XtremIO */
--
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://urldefense.com/v3/__https://listman.redhat.com/mailman/listinfo/dm-devel__;!!LpKI!3xx3cBf4_gTYjsFEdPLEd12Uz-4rxuFhn91YEI31Wyhqt-tu-rdX0PIivxsto8wZ0L8$ [listman[.]redhat[.]com]


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

