Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12EEC43460
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:44:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B455613AA
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B455613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-PxlsEOFGOTOlnwYtRzgRJg-1; Wed, 19 May 2021 03:44:54 -0400
X-MC-Unique: PxlsEOFGOTOlnwYtRzgRJg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAF66107ACCD;
	Wed, 19 May 2021 07:44:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C8785C6DF;
	Wed, 19 May 2021 07:44:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 63C531800FFC;
	Wed, 19 May 2021 07:44:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J7cj0K022554 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 03:38:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 89A42FA746; Wed, 19 May 2021 07:38:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82CB81032B8
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:38:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB59B101A531
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:38:41 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-245-aBAAm-XSMCaA4PfOoxpy9w-1; Wed, 19 May 2021 03:38:37 -0400
X-MC-Unique: aBAAm-XSMCaA4PfOoxpy9w-1
IronPort-SDR: Ci/vz2szrqUqETcbiIKJC8z40VSuN0KiiP/vPizigWkTBRnw5yv0tL7dco9BZIdsAevtpBfrYI
	bXCeVMDOS+7OC7AVNvRhkXtpDYjJXqGhMDyknRl4dFZDLGu8TPh3FcTUJw3iPQed6HjA5O+dqt
	cHGbhd++qBCx7bbg4AZvGRsJ0y9ymwW7wj8T0lnPJWuP8EFwKivvMOIu5LMPmO3xS5Ty+V4puh
	5CScc8SAzaZsvgwsc/A+nzUvKWga7GBCiC5VBut/b3ErlWslHzIcNCefzP3ZdUoGUXqSV/88J8
	8SI=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="169221457"
Received: from mail-mw2nam08lp2172.outbound.protection.outlook.com (HELO
	NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.172])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 15:38:36 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7478.namprd04.prod.outlook.com (2603:10b6:510:4e::5) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 19 May 2021 07:38:34 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Wed, 19 May 2021 07:38:34 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH 06/11] dm: move zone related code to dm-zone.c
Thread-Index: AQHXTFp2pvRcCsEC9EaH6f4I5txWSA==
Date: Wed, 19 May 2021 07:38:34 +0000
Message-ID: <PH0PR04MB74164B53E7862284237A47C39B2B9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-7-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:95b:718f:422f:1ec2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3dc2661d-fa3f-4355-df8a-08d91a991bbb
x-ms-traffictypediagnostic: PH0PR04MB7478:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7478E756B6C235ADC9EC89489B2B9@PH0PR04MB7478.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1KGvrMkWmCwnSLcfQx1nFeLXdRqvvQjeG0JWJg+9gtIrFDFRLUTH91U2o3ZgpOmiKcbzqUZItsAzg+4ktr3kEeJiQjrrP+hT6h9ZaZKWcWf13/TrpbHolCaTMhp90B+6xE8oX2QTlMR8qHpkv6DrBjSWs3/rHEEdQOobuFUN8HmD3B5IqN0VXQ0vmn6ZZjqgn2ytDSeGyI9c+NO4X/T9gZPVTEU8W2eFwkyagsGYkoddWu6Hc1rUbch+9ArudzymcBf2S3UfdYPJdV1Ge+8Uvdo2400nfO++hXwerJGiOkvoaQmvtLam+/eVM41icQPZxAS1EfOO32/Vxqan46B9cwxFAg0H/tY0W8bbXHAGtaiSJ3vH0LjdmCO3p7NLZEU8GaDqhOrdQX7PyC6yDjseB1+mPWwqODNWTALJyS4ePMk7lHfQ93jMpKf1XAAyyAdB7tw67NnKG9KA9L0a5DRTWgU9IOtZ81ptfr+Dd8YHfpTk6qKDwETJdJOZ9K93timp3zAkSj+B1VPVcGYivRiMRnVclZh/wyNUbuMCD5wkjdyDsEkKExRvtkVUJwCgnyWWMnv8a6rnFtuGN6JesyAsUj6oye7BilKD1UOkqY2Wpa0=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(9686003)(8936002)(8676002)(52536014)(55016002)(478600001)(5660300002)(64756008)(558084003)(33656002)(71200400001)(38100700002)(122000001)(66476007)(66556008)(66446008)(91956017)(76116006)(66946007)(186003)(6506007)(86362001)(7696005)(110136005)(316002)(2906002)(19618925003)(4270600006);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1VEY/6nMxTtpX4NzquYpixov+uc5vawSquVPFKPkarY6u8nWq4XARxf+Loxq?=
	=?us-ascii?Q?p1NUPzyGBgSRhxI9UDunm2/V3RUSuGg/lxV3jgeBd4pjSwSr42RQMZs/jGC5?=
	=?us-ascii?Q?HZt3PvoUfzgmbodZbWKEUJL2kcGYE/RMxAjaFnLxPFpL+Wsdm+1ZD33bMGd8?=
	=?us-ascii?Q?G7va/VqwLzwS2wwKFbStJ9cLV5uyZBMwL4puZEvqGnvOlhb8BjxSWEqd5IWL?=
	=?us-ascii?Q?yKkMPS6GUMQ5I+Z1KF9g1otdpWc88rg9HHpcfbd30UF8zzprsYLGRs3aV+qf?=
	=?us-ascii?Q?WnN4JLdHTFTkVEGGXahDzhnwv6W+oFbNNrBU+dUaW+3DqcBOCwB4aiKpSDW5?=
	=?us-ascii?Q?YVfhpA5QvCsBVBTcX+uM5BxA+c69st7lfiCuSe08M71UykGRaWtC2ypV1fI8?=
	=?us-ascii?Q?gZ2O+Q9rDpY5rGg+ObzgWdB8r6nBGK7E/1qtUD8sGHSUhoZXXm2Cr47LdKLV?=
	=?us-ascii?Q?QKuVQd4HOWB6c1iMIev8pm8+BnxEgSMP1dBE7C14bWcfC+VL20779lXOOqo+?=
	=?us-ascii?Q?eWtWxg0qmccOjY0IqUJPZDQiJba8075iIQAn15aYH4kVsafaNHulVnyu/eRW?=
	=?us-ascii?Q?gzVo3WDYtTyXBRyqX7cFUqJdxTb4ZxC6AGgaVg1ceos18VCv20P8xVj/0xQR?=
	=?us-ascii?Q?zdkFlKOMFlqZN8ikicV3X+fb5b8hHd2UwtitPaCK1cccqrUdZ9gvUr1laHLS?=
	=?us-ascii?Q?ilosghIU9x2XPr/lxG2R0td8eYfNTzxPnCdYBg+DwkvAiSMVt4BimpKC4tAv?=
	=?us-ascii?Q?gugBLeoIVYRbIkYhcwOSvRRkss6ZwH0A0gblD4Sp8gIhre+jkoMpjz38eKMg?=
	=?us-ascii?Q?6zybJcYuNcnwbIjWjostqKQX9/EGZRwm0bdYSF8xoj8elVqQnq97Y1I7ys/C?=
	=?us-ascii?Q?Hz+9fkPLirGmIXt6ntVoowWok8VST/gFx38RfDlg0Bh6kzCJpbP4fKV1rmYO?=
	=?us-ascii?Q?vW9Jr5/F/kC8mWV1Ymu+WvEYeKg9PxUSFaYj3jA5lfPWlbsJjfcS4RZ+LCkq?=
	=?us-ascii?Q?SIlkwdp85HNYdOj/wWqRK4G+l3q/NlwazjpAFTgHYfCxuR4+qekr+p42l28t?=
	=?us-ascii?Q?mIG0MYpn/yvU+FWhDdqepJ7n1bt7uLFQvROONOn1hi+3thHDjmb8rGfILvgA?=
	=?us-ascii?Q?aRmN/aMjgQebO1ON0fEQkdMVjxMOudhHi8WmnecMGutApL+6QV2pfLo+okma?=
	=?us-ascii?Q?WC8lbZXIDVJJF06Nr0J19OyG2dYRixtIYJl5du5fZ8yxjH8T9pflMZx8o7FJ?=
	=?us-ascii?Q?g86lU7MnzwUk/EqLZTRevG1eUNGqDtwpSYZeZ1UKvwvdntpGebAfaX9Ohnrm?=
	=?us-ascii?Q?NbClASh3Uwd6FlDEFZMaDdywF4l4QSwNIhMlghIwPR7FA6PU0ePQH3fqU2Rn?=
	=?us-ascii?Q?uT2W4Rfwu6M0Cea1vYVrFD3P6N2dH6dTvDi7oLkhfsoKGmP0kg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc2661d-fa3f-4355-df8a-08d91a991bbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 07:38:34.5290 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3nNme4QfYheGXBTc8By8scaoxstlt//y4EFTHGiHYmJBJmAkj3M5iDEOFW9CrdPtbRTDnjtl3hGnKfRC0cRHJdlr2CEdcr+tZt0onLYeLuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7478
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J7cj0K022554
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 06/11] dm: move zone related code to dm-zone.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

