Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC43C7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686163343;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MRkA+nCDaI0Ld61AhlTIXOT8NomsMnmwPrImFw+ZQI8=;
	b=JL83j2xF2uSerR3EJ06lkVR4XDbdvp1fPtPDyTjx7tio6PJVl3al5aFo5vJ0zNPaMolnUM
	ZQuRsafkm4zlSUN6KEzwZLKfzYKkkWF9QDu9uSnPAzX0GOgNFjkUfJTwFkdY+nL1EiZV9l
	F+fufoZGln6zIu8QOkXFkAiuPpV8GZg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-8dHHCPMYMMiNYuhjY8Ihgg-1; Wed, 07 Jun 2023 14:42:20 -0400
X-MC-Unique: 8dHHCPMYMMiNYuhjY8Ihgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AED308030CF;
	Wed,  7 Jun 2023 18:42:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BA3040D1B68;
	Wed,  7 Jun 2023 18:42:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F8C119452C3;
	Wed,  7 Jun 2023 18:42:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E6E0519465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 18:42:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C163AC0004B; Wed,  7 Jun 2023 18:42:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B8074C0448E
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:42:16 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9969F101A53B
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:42:16 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04on2082.outbound.protection.outlook.com [40.107.8.82]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-Alxf8GaQPtCL0fVCXNUe-g-1; Wed, 07 Jun 2023 14:42:14 -0400
X-MC-Unique: Alxf8GaQPtCL0fVCXNUe-g-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DUZPR04MB9967.eurprd04.prod.outlook.com (2603:10a6:10:4dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 18:42:12 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6455.034; Wed, 7 Jun 2023
 18:42:12 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 00/11] multipath: Add a group_by_tgp pgpolicy
Thread-Index: AQHZmLNXKG21etlSWUmXA5Hem5m1yK9/riIA
Date: Wed, 7 Jun 2023 18:42:12 +0000
Message-ID: <7daee84937d0d2ec2f1cba92969b0c90733b0925.camel@suse.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DUZPR04MB9967:EE_
x-ms-office365-filtering-correlation-id: 709a71ec-18d1-4393-9595-08db6786e82f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3I1wenEoxWAOf4FHWTocXH7Oz7spOAPxMnuJn8jk+gf/u9R2OkwA5KBZ1h9PBNDbweV4ZigxE3VPut3acc/LM+RCk9Ih0E1yRkAC3RsnKbbT17y1rDZgiVF9sPZAj/ev9lWN88MCYXor0txsz74Y0q8ehWV7KdUzvdFuV9OPqY6TThfrWDK49H/93s1EOdp2bZ/J+U3N68408cJOUiMOlhI9tZssmAvrw2GPjnWPi4Dg5VaG1iloNdgHaQNAhtNgdab0QTe1VL5vhmbDwSEk3fvoCWWt7ZD8oHyjRlTTQFJLEvZ1i3qmL8bBCVklDsxUls2swSVfFYnff4OAiKXVq0urDIRNSP/c0a4OJjo1Rx7GZk+Hx1H5dVyWrcNZQHcYH1PrWFAPMxJHJC/VOgtUG/omRPwcYbBO/6PhrwXeRaPH5NA9OyX1x+xXiK16XsgB1592tj+8FVnYsL+6VtamnuGJm2bSYysCu+3kiYu+QBwuI0R9yZLn7It59pXxMB/M/zSM+MB9fbthAwJJ+9wM2BIaw9xa/QrVxVEqqoWiR7TQHhnMS/xGIb7kQyA4ulW5xd0+vpBZ8YsmyMwyrgTIE8JtjnMdyHmdcJ5S7bLrLoRihaDBJXRpkqOB9+QDYUEj
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199021)(36756003)(86362001)(2906002)(4744005)(38070700005)(44832011)(5660300002)(66476007)(6486002)(6506007)(6512007)(26005)(186003)(478600001)(91956017)(71200400001)(110136005)(66556008)(76116006)(66446008)(38100700002)(66946007)(2616005)(4326008)(122000001)(316002)(64756008)(41300700001)(8676002)(8936002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?tMGZVIabeZZGhW6m0hx6z8MB/+JN5KuUeUS1psQeNHJOXfcLomQeVymHr?=
 =?iso-8859-15?Q?jr91syEkq8n7r2g/dJFYdadHRSCkcd+OvSOVRvNVdFNho6KxEG6vcPbzR?=
 =?iso-8859-15?Q?SN9NPdXivm2M1HseT2jJZffpNoYeDMLOnE95irC2w/yIhRTUc8Gjpg9zv?=
 =?iso-8859-15?Q?M/svLOtYZzeprgc70IUVD1r4lh7QA6sHuSRUhHAfn86TS6/LsUEZEyhy1?=
 =?iso-8859-15?Q?zdAsgUX5oGMYqrKdMOzgVgSg67UHfxIB+vn0OT7xjshgoL2S3W5ReBBS2?=
 =?iso-8859-15?Q?F5m8IzT3Cz4xQknclX/OjYP0NIMc1z4OQTzC2yJpJ89ywNb+awYR8Csil?=
 =?iso-8859-15?Q?9bKcojrFlhfn9bhQhqpbJm3TJ3BSQAqfGsu3MVR9mP5Cmqgn4/f4AltlT?=
 =?iso-8859-15?Q?hdXe1bT+bvOTouqdP7jJLlRqk8N3HTZ66UhJcD2Dyz8KOtbnpYgFJmPeW?=
 =?iso-8859-15?Q?fyCeyP6H8VRoZOhK8qmH/4chTDkFeO8QVOHb0mxbZtApfh2P69gili5Dh?=
 =?iso-8859-15?Q?+ogML83zINJJrKxSwhvTDXosNtfbIsn6pjuLFomar4lgm+dnNX/V3aUPO?=
 =?iso-8859-15?Q?nLtzNvGX9z3xAbwAq+G0AnFbG9XZLjJjuzIj1uWm+gXWucBWAF65ikL9F?=
 =?iso-8859-15?Q?Gjgq1miZGElg/COAyWVUAL3n0g0/LuR6hjcWhsbwGI40D4NVxgF8G5Z/j?=
 =?iso-8859-15?Q?pWq+i4wrzK8pMx3nJ+b+nAHC2ecZlqOWITHfSgn285UUJU5m1334p+wT7?=
 =?iso-8859-15?Q?LKaKmWpZ0JI964WgejVAEefgnGSOX9SHZFWrUgAGLVgGYEFeo2sPOphz5?=
 =?iso-8859-15?Q?gJ5ZEcYxBga++YaOP6yyPacvwvx2egi9nZXMYI8BZ6oU6zw53qPVitF8v?=
 =?iso-8859-15?Q?tUdN7YMnY/OPgzqzE6NfwUjHOjgU9MYCBzQA2YE3Nv7uARtzRE+7Dii4M?=
 =?iso-8859-15?Q?rg7T2/PX6yM4kRmq3x2UbE9Ekh7JIAfDh7C3ujuaKEa2VUXpl5mY6ZOhG?=
 =?iso-8859-15?Q?d10TR9xl0K7rkuWKSu5PprkE3EZMfmz1x2fTW2Ek04ChvBm3tLtvCzB7J?=
 =?iso-8859-15?Q?US3eB+yrwKn+XZdnVdlVdjTXRLxWOm/qlPjpHakmy4KyETObG8OTPg2vr?=
 =?iso-8859-15?Q?LSNZrOq3F73exa8To4qa3PwzxtD+cX2jsrPOVvtBiBP26s+8m2glLePaf?=
 =?iso-8859-15?Q?0q9DBYeLaxqt0hW5QY2vlAHg5W9fePMos78+CDOA50UdRTMAXLU0yMOJg?=
 =?iso-8859-15?Q?+iopf5aYW+8lVp4YxBjHK8wziWEdRbxZsttBjOxArQlVOjp/wxxveZW6r?=
 =?iso-8859-15?Q?IrtRw9ENeEzT+JjUFDw0rgxVLPSRWW7WY0cO61a4eL0QN2PLxrRZrVCOU?=
 =?iso-8859-15?Q?s3Zx+gbNORmPnTTaBdVNxOgDjCekJ5hqoJJeJJ7JNfid/bKAv7uiKapad?=
 =?iso-8859-15?Q?p5CMDc9UbNHqdGGYrwCIUZyyr+i6sI0RJp2C3LgvE2AyYfGkVZuUzuxWW?=
 =?iso-8859-15?Q?L0xcWy6QnjIhNzXhNDNxzz3DkxKKjOjwX/VLpoGGj4Qi6U/EMJDXstpCg?=
 =?iso-8859-15?Q?8DFkB8zb9mUXzHonB2glMmES7NG8Jjyp8Yw7hPNPhe+njZ7VL8Sa/g2FY?=
 =?iso-8859-15?Q?/fA4THw5yt4Z9SnFPCOhlpxTvsHrlKy9AUg1NYWfG01WtRt8mnL4Dcxlf?=
 =?iso-8859-15?Q?N/dO?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709a71ec-18d1-4393-9595-08db6786e82f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 18:42:12.1602 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nM6grg9mbpB/RlTPVDbb+7iIcRakOm3ceUPP8NBMKLJCXJOM8Y9tXnH/A33yOJe3+OW/BXuhsm5yQmV1BD3NWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9967
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH V2 00/11] multipath: Add a group_by_tgp
 pgpolicy
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <97C843F30B8CD64FA5B388B6F6E9A82A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> This patchset is a combination of my previous two patchsets
> 
> [PATCH 0/5] multipath: Add a group_by_tgp path grouping policy
> [PATCH 0/5] priority and pathgroup switching changes
> 
> The first part adds a new path grouping policy that can be used with
> ALUA devices. The goal is to avoid the temporary incorrect path
> groupings that can happen when paths change priorities.
> 

Lest I forget: it'd be nice to add functionality (in a later set) to
print the TPG id of a pathgroup in the topology output if group_by_tpg
was used.

Thanks,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

