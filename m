Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E61C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 07:13:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-F853GjruN6SvDyx5e6O3Gg-1; Tue, 03 May 2022 03:13:24 -0400
X-MC-Unique: F853GjruN6SvDyx5e6O3Gg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF60229AA2F3;
	Tue,  3 May 2022 07:13:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BCF997AE4;
	Tue,  3 May 2022 07:13:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E32521947042;
	Tue,  3 May 2022 07:13:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9D8F61947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 07:13:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31069416385; Tue,  3 May 2022 07:13:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C1FB415F5F
 for <dm-devel@redhat.com>; Tue,  3 May 2022 07:13:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 117BA802819
 for <dm-devel@redhat.com>; Tue,  3 May 2022 07:13:17 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-wi2mZn3kPBSk7ypJGTg6aA-1; Tue, 03 May 2022 03:13:15 -0400
X-MC-Unique: wi2mZn3kPBSk7ypJGTg6aA-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2056.outbound.protection.outlook.com [104.47.6.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-ZW6U5gShMlm2Y7jKhjPVeA-1; Tue, 03 May 2022 09:13:13 +0200
X-MC-Unique: ZW6U5gShMlm2Y7jKhjPVeA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB8PR04MB6923.eurprd04.prod.outlook.com (2603:10a6:10:114::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 07:13:12 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::21aa:a826:f438:827f]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::21aa:a826:f438:827f%7]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 07:13:12 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH] update HPE MSA builtin config
Thread-Index: AQHYXBXF8ZWLcvy5HUadA+386xOhQK0Lw7vOgABLGgCAALN9gA==
Date: Tue, 3 May 2022 07:13:11 +0000
Message-ID: <a66b0ccd977339af9da5f46f084c1ff279b9e706.camel@suse.com>
References: <1651270144-29953-1-git-send-email-bmarzins@redhat.com>
 <dc486bce737a9784543af9d910cb4f4ea15e5260.camel@suse.com>
 <20220502160140.GR24684@octiron.msp.redhat.com>
 <20220502203046.GT24684@octiron.msp.redhat.com>
In-Reply-To: <20220502203046.GT24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f3ea915-2db3-4fea-97bc-08da2cd46243
x-ms-traffictypediagnostic: DB8PR04MB6923:EE_
x-microsoft-antispam-prvs: <DB8PR04MB69238EB59288CC367EC523AFFCC09@DB8PR04MB6923.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: USBvzhtJMO0QKXKuON2RPaCDI1fk/dThqbHE+IDV0hIfEJUDuhX6b8BsRWH7sbZk+iHtjezO2iOyA1ijNhRrM8J6jm4OCJoGaWK2pSBWd1OUq8ZeeNpy7NwAsEQt5/fAbLnC7az4sT5UQcwx+pqV7Kq9LWR0jsGXcZhqNFdO7lBfHlmXREF2Pd7ml7v7+FzczbOkbx6mNdevILNDmt0MvznAKMO1dFKocsohHr3/a7K+ExhuUgUP53Mid7nyPz+TJjYU02Se5GYWunRzjCI/G1MqDgZQ9yvuAJHbb9w8RrJSIxpZy2qO5md8SRQZNMfqLi5KbdNYW6ESGWvs3fKkT8MlVgSN4pzrQ4T3Oz21g7GCjzR2k1HK+seUQw4xNIPfNdD7GBC35CIXulR0uNQ2cBQo0L8lmK2iJaq/9NRTmbLhMxPyC+4mucsdWkO1AgKgKKFzFZYr1EauRSF4yNYWE0Useo+TCzqNCgdniEgm3+9837m0s/qWooSXMhSfuGwAxQO9xZkii5lTqPj7g6PmTdrfiK4LHQB80aLeRD6zp0qi73XoKsJZhwEdOzUBtxqlbq5A6SBMg/RrcfausJTZV24fkt2J0WL1BPodC/U4tCUwKoySMwW/ncO+no05Bj9F3IrLr7qonTpJkDkA4uHj/m/mxOZqcJ1W44tCG9/Yo7mQVHw11ggI2At5iSPei9Ggu3c/JBqPOr1pulJDsvYS8Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(4326008)(86362001)(66556008)(76116006)(83380400001)(8676002)(66446008)(64756008)(66946007)(66476007)(186003)(2616005)(71200400001)(2906002)(5660300002)(6486002)(508600001)(558084003)(6506007)(316002)(8936002)(38100700002)(54906003)(122000001)(38070700005)(6916009)(6512007)(26005)(36756003)(91956017)(44832011);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?z3JndJPMqN3PbdoWb2Zf2ZjU/X91y9n3QOYpTXw5Ud4uev19Da1ZJH0fn?=
 =?iso-8859-15?Q?DjNhOBds57FUGbrgGI/7CWU5ATF80gJqhfT/zCf58o4M5ppg3CcpqO6aA?=
 =?iso-8859-15?Q?CapGxxJMnVQzOCrvg7lPVEl0wMkfp0vvOXxinIV/ZF87c3Z/+7I2xr+Y/?=
 =?iso-8859-15?Q?lOma2xWA8IMgc/aB6jCuticOp/kabyKhIOnW8qdCGZ6rJ6GUbt/2zDLSf?=
 =?iso-8859-15?Q?BjkRKN0Rrm9z18F84DSxVH408DKhyfIHbej/aDLwOu3F26LE6BOGZzzSy?=
 =?iso-8859-15?Q?UmNJoefsVL6WyU/qFgCxXjmvY/sKTjiTCTnPjvYuwBBqaMvfqnw3YLppF?=
 =?iso-8859-15?Q?g5OOliLjkVpXd2sdn0pd76HXYNayGxneTPx189xhwpptfs4nN2MEhtq33?=
 =?iso-8859-15?Q?qZR+0GPEGh59sglXuC1Y/NryIM30uVgK5psZFqUVSKLg/hATR+cowbVFy?=
 =?iso-8859-15?Q?la1Fcr/ZduA/gckt0LorpM2z8VJei9mprcuVZkzPYXv9Ps/kjI9VxUNeO?=
 =?iso-8859-15?Q?XBmR1zAGPSed0XFs7GPPIIqkNldGST8JRvd71CrqITo6TeC+L7ktHgbZh?=
 =?iso-8859-15?Q?///zoVYOEscuJ3pUFRd6cj0hKrUNNQuZSk6jBx7PkA83qTIXn6RDKxgmI?=
 =?iso-8859-15?Q?xFl706eBrSCTdjvdzDz40YaudcmP4R2RN4C7V6I7C9MFOf/SurSTaXrHn?=
 =?iso-8859-15?Q?0UMIxZXBKBrb67QqhRwt9FuPqZM9Gx1NwaUH3BQSIjOn0l8JCT7qwo2p/?=
 =?iso-8859-15?Q?T/gJbh5xvGUv03aMg/cW+tgWiiDwT1Fs7LOqazWDDu2teOXG7fqLgX5nv?=
 =?iso-8859-15?Q?NkJshT/3iEUOshEY4xLswYnaJFqXNG3ktOvOYtawWxR5Xm5fBGNIFigzW?=
 =?iso-8859-15?Q?ErfnmjNoSxdRJ6Se/FipE6M5Dr2O64p7hvst+qjkKC5x6anRDz33lC4nP?=
 =?iso-8859-15?Q?SjPTxh09wWwhH4z4b2TgwYlwD4RhekZGx6x72sU3eYHDQFMC8Uj3i9lE5?=
 =?iso-8859-15?Q?5pigK0AdXia6fWP9bBE2zsJfmGk5tm+9/utr3AYWGdU5i7nDsHThbPOAX?=
 =?iso-8859-15?Q?t+P5xPpbdJqNEvpaILGmi9zs2Vjt+QiGGHslxCwrdp+xRfDUucGRktP0j?=
 =?iso-8859-15?Q?yAzycN71INoS2XinF9VttNty+eZOisEm8J1a7y2jXFZqDmV9lwJjSjdlQ?=
 =?iso-8859-15?Q?s44qbDG6fHqa042ZEWJKhlsGJBGRy7GuRWYMSWqgrWyRCAUDLYn++fgAa?=
 =?iso-8859-15?Q?SMhmqlsFW1Vv/7+eWo6kNz1koLGi1rN0rHNqDwwIll0qj4vY1OCba2w/W?=
 =?iso-8859-15?Q?Dg2daiKgU+mfNg+Bhna0Li3D7tPIZaC1jFfpbCjU+Dy3CU1TUSozMyt1W?=
 =?iso-8859-15?Q?CvbdcSpSinraAN4P1aHcycpsXZB4zkClZo85PPCj3ZTCAi/cMsdmOcm9t?=
 =?iso-8859-15?Q?uekzjiLml38wVWwWW8tErwe+e4sPUkIsQ1kBczGPCjoBZX6R65+SAd5hU?=
 =?iso-8859-15?Q?PThrJ7hhGjsR8Xc3cqZDRrofWUnvfuSKVVVEnTDJ5J2Hqkw8REEI1nLxC?=
 =?iso-8859-15?Q?Vd9/MsSKaH/wEAO89nKS961y/LW3doifl4rRaCz+xOXFwkmcwVX3FeXCQ?=
 =?iso-8859-15?Q?6E+98pfTKax46ReU4J0SSgYpoX06sE2n9Jdp8U1D7vgmuAkpvDPvGk0kR?=
 =?iso-8859-15?Q?2mPdlSKieerrHPR9ocE/4V8xi2pdrDTBFipCNIq2+Q901fl60Ck57GRzr?=
 =?iso-8859-15?Q?skxJ/iKOVl39IGOwVnmCiDkKEb0aQ11Thz80+UC6PN/V+UgR8y0ugEmkD?=
 =?iso-8859-15?Q?uL2gaxuhI6P6xqjBlzoSzryKDWAWJySkiZ2JcTsn+PLY15Ok1NujKEhVD?=
 =?iso-8859-15?Q?POOI=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3ea915-2db3-4fea-97bc-08da2cd46243
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 07:13:11.9163 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yg04A1gga0GAMP/youLS7LcKHkLst6hs9BDb4wL1MykbLXK8mDzlCXjfshmNWOh5KgErwPwJVILsG53CJCla5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6923
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] update HPE MSA builtin config
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "Jon.Paul@hpe.com" <Jon.Paul@hpe.com>,
 "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D9B3D1F03BC70E47A1D2C50B5A6FA1B8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2022-05-02 at 15:30 -0500, Benjamin Marzinski wrote:
> 
> Do you have a strong feeling on this? Otherwise, I'm fine with the
> config as they gave it to me.

Ok. No strong feelings.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

