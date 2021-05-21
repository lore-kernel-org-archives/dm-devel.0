Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E52C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:11:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6852613AC
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:11:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6852613AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-lRGEuMeLMUGbZapuXjsKSA-1; Fri, 21 May 2021 01:11:09 -0400
X-MC-Unique: lRGEuMeLMUGbZapuXjsKSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91914107ACC7;
	Fri, 21 May 2021 05:11:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67D1E10013D6;
	Fri, 21 May 2021 05:11:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 34BCD44A5A;
	Fri, 21 May 2021 05:11:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L5B3g2023927 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:11:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0A89E2142F1B; Fri, 21 May 2021 05:11:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 049BA21111D4
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:11:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2DCB800B26
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:10:59 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-192-0N-BsVt_MwGTf71kAAc1Mw-1; Fri, 21 May 2021 01:10:56 -0400
X-MC-Unique: 0N-BsVt_MwGTf71kAAc1Mw-1
IronPort-SDR: GJwPQQnvHH7uhgVSBoYtV4FOnAFg5ITvLjgEz46Isf9HyCMUP4EHc9tZ4Smkeo/CtOPnc8bJmd
	AN1vliAmCH1b6oPQw/YXtBqsLw1ozh44GO5viMrni+Y45NBi8Q9+IFI/BQ5/apURFjoweIsf4m
	u41LsSlbDCH7sMYKFm8toyw6+058YSK7O9Fe+bg1kus0N3uZUtOKkLpczZSvf6bWw4UAa5dZ4z
	XF6OSADnc2KzCdyATJuBRvdaWZpIfHhdX/qu5GLw7OGw3WAb1eakBvviNTgFLsmy6vHlhYhvBW
	nyc=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="173604640"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 13:10:53 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7544.namprd04.prod.outlook.com (2603:10b6:510:59::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23;
	Fri, 21 May 2021 05:10:53 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Fri, 21 May 2021 05:10:53 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v3 08/11] dm: Forbid requeue of writes to zones
Thread-Index: AQHXTe2jJOdlUthNFEychyxSq0vQtw==
Date: Fri, 21 May 2021 05:10:53 +0000
Message-ID: <PH0PR04MB74167C27A5E2E12C7CBC950C9B299@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
	<20210521030119.1209035-9-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:f8bd:921e:9aa5:6d21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa3b4c59-c5af-42df-504f-08d91c16cef8
x-ms-traffictypediagnostic: PH0PR04MB7544:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7544D7368EE025464DC381979B299@PH0PR04MB7544.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: W4H7JRv/8XlCN+6ez5RtznIT4elbTt4ynVMGNwklMAgrUIzYYBJTH36Qx9535Pmb8asDbSXQf9yGdWpGcqo2LbpQUkqu0xmPNh5yitbv2a8z5RUdHbaxrdNkYlD+owKBVvZVnwQotCcKzxPsawCALhkN/7DftnkghWxuONc14Y+AzsVDAVxbBD5GLXUfD4btybLiDMH38bExVNCgj16tOmTVoafmRihA7MjAFKwbE1rrNg9l1LHbZJcklmfd8VVvkdJVAWO8delrAczkU+Nle6Do1vAC35LqhwH6UGvkAV8a2d7GIa5/oxau8kA4DIG0t4IBgkN2RAFz5GlnZgi2IAsqis7Uqe/J//NpXwFri1sxKJbElMKPzim51NrFVtRDR2Wh3U492si984oYBsP00cKgYhfvyg+feXvbgY+wAFLjQAfDWX1slCUI9D5fxGgdc66ZfDVfQ4cUEEeP1N1yTNX+xULZuENWQ9KzEJ77WqxhiVC0aHRIjBzzdctnlpXLWKxArknB5OTvUG8O5JrXpP8eySzats3Q2/H5jMnmWNgx9bJlWxWw9jgElhjjPLq4ILHYYQZFrYrewo8D9EbvaARPGkXCfiC/0xauMOjIAHg=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(8936002)(8676002)(2906002)(55016002)(64756008)(33656002)(9686003)(66946007)(186003)(66446008)(66556008)(66476007)(122000001)(6506007)(91956017)(76116006)(19618925003)(316002)(7696005)(38100700002)(110136005)(478600001)(4270600006)(86362001)(71200400001)(558084003)(52536014)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rJpQ3jgvoi4miWYGNgKM3E9GVBnO/BYoZaMdSLj7q7U8zy/2B+oobDKRXQh3?=
	=?us-ascii?Q?npmin6tuvUCkR8ESjfLYAGsgLWWu5rHLWLBZ0H9nNvMGx1gdpXYyx/S24OTa?=
	=?us-ascii?Q?1fxlmtzEQiPD9Peedd0/w8kINgCLEr60kUT5hMhowkO4lJZE+LA0gy8weu5X?=
	=?us-ascii?Q?1dhfCQoduaKbT/6ILNnLeingc/Z0tOti/+3kIaTITHbfA+jpcnjI+8X3FHOx?=
	=?us-ascii?Q?YnN7w6Xt0Ly4K7qMO3AtHQRK/mmhcuaGWklB5Vc/hW365ATD//8FdhW6uGdq?=
	=?us-ascii?Q?295LgiTNNUK6+DqU38hk8SleQvKG9G48+gygwZOWvp+6qyw+mLWRS7C8qKgV?=
	=?us-ascii?Q?GG1n1dikeaiNt9gNV5EZrSgGLrimfoewt9y3oxBWFewCMB5wd0TFH5+eaLF2?=
	=?us-ascii?Q?7PmxTDgHyVYcKsCdF111muHOfMQYu+b8pn2WtlQ7POu2mrBX2n5wK7g/Yc6n?=
	=?us-ascii?Q?mv3CVDw92ps43QBvfn8wcfJ5t7A7nmo6p+9yKaRkzdtqnt3+gi4MBl8FrxF2?=
	=?us-ascii?Q?oiYhHUWG/d5E8h36n4+uO7jjtS+p9v+uiixu15PaKsVX/nVgRlZCNYO7GJ5M?=
	=?us-ascii?Q?zi8S4GLktWXm6ax0puni1kQ3FKZq37GX2HbEXCEX3YMdBY2KIqIeITi/FxHm?=
	=?us-ascii?Q?zVNOQOWs1PX44f4k+PmUS1OM9w6ZQ3cdjocAKUXu1fLTaENGb3zXgyL7T3Qx?=
	=?us-ascii?Q?c8YgJMrqdT4RGz4OQnwnVRM72zDp08IH3vgStQotOQ6wbYN7rWEBq89zZ45Z?=
	=?us-ascii?Q?VP1KY6g96NN1WbmSFF9PE7ukO+vERyFYUCxlTBsqfLmS1H+9lB25QTEFMmbA?=
	=?us-ascii?Q?PvURl6ewcM07+aIXnYN+uAUaSe3iiMU4Ps0ZV8v51eSedxPZAsKqUfKP3GH8?=
	=?us-ascii?Q?I41leUywb6MS3YbkNRf8XVNq42HPDL9ZhbT9x7tBhEA4U6S3T3Qf70fPGcvY?=
	=?us-ascii?Q?1FsmQ0jiDnhVdS9pecwsqYoNi7NK5JvZqsZZthT1DYLTA4t+XYfZDOu4NGY4?=
	=?us-ascii?Q?ihwWJJ2mJ8FIrniok1hhCaGm84O4hPEW/FMIh76NIEuPN0VvsrrM+lIlqGYZ?=
	=?us-ascii?Q?XaFFCBpU4WYR7IBg+STNL8x58dHFXu60CksjBY24XR7PkuxmasiXQdL3OXHm?=
	=?us-ascii?Q?9tzeH+MixNjbeRCUdiVbwu74o9ozWozgbKE7tshEA5NUeVK/2lt33ybwL7PG?=
	=?us-ascii?Q?Js9toXf+F98CZxum1QZsArje1KQZDF+IDJQTmO7EdeBUu38fPQIt+6bOSCWC?=
	=?us-ascii?Q?iS67XMxADF5hQpxvFebsJFg/4+t9YQei04rpHdPplGpiXVozdlk8DLcUHft8?=
	=?us-ascii?Q?LUVEbbzRkd1OonrM2x1ac16GTqn9MkuBvXgIZYfRtk/2EG0Gz3/jdJuBMKoc?=
	=?us-ascii?Q?K4G4251TzpsDKFX/cOvXvj21+dJCwiq1LQ2TbppiCKvMMNd+vA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3b4c59-c5af-42df-504f-08d91c16cef8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 05:10:53.5649 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZ7tacaBXgeu7XgdIkK4FV+avVW3I+DK6MLDngwHgFLxSKCq/SVbb51lAKuBQeJiR/ejRfAX/umm2WZBNTI8d7xVVkm2AROaCU76Yzl6Qxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7544
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14L5B3g2023927
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 08/11] dm: Forbid requeue of writes to
	zones
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

