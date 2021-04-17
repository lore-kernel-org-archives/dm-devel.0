Return-Path: <SRS0=ANAI=JO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C54C433ED
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 10:43:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5ED97610CE
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 10:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ED97610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-ld-WUuZfPSmfoc47vJXAMQ-1; Sat, 17 Apr 2021 06:43:01 -0400
X-MC-Unique: ld-WUuZfPSmfoc47vJXAMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94D021804688;
	Sat, 17 Apr 2021 10:42:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86DBC5C6B8;
	Sat, 17 Apr 2021 10:42:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E27D1806D15;
	Sat, 17 Apr 2021 10:42:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13HAdmbT001537 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 17 Apr 2021 06:39:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DDCDB2182DCD; Sat, 17 Apr 2021 10:39:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D71862182DCE
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 10:39:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 612C1185A7A5
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 10:39:45 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-466-5ZaKg9FTNpuOxzF5gPRhhA-1; Sat, 17 Apr 2021 06:39:43 -0400
X-MC-Unique: 5ZaKg9FTNpuOxzF5gPRhhA-1
IronPort-SDR: wfWiJcAUiI5ekMHeGwTMIGtZE4gAELrZqcXrFvHrkgwrd4L8pigGdWpIaJxb3x3XlPewXJqBFA
	Fg5cPNDkXNl4v2o5fTT5297XO2LePf4+Tt49Y1ojY/NOxWwuuLy8kAKFxmOVpok0I26zCGus4j
	j5HnDtFIwH4A0nWPUtuBqqITfwZ5NHft/oTCs/UCQkbHsyKKoyMkbj6TCS9iCLhejrfOUvHwtw
	GQcCUDgCYk4O1qoc8J9bo8r5Z/5nbQapaCMhvSV5A4T5CVmLb3pEN8asd27JOm2wmq3M14QG4H
	eEo=
X-IronPort-AV: E=Sophos;i="5.82,229,1613404800"; d="scan'208";a="165238389"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
	by ob1.hgst.iphmx.com with ESMTP; 17 Apr 2021 18:39:40 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7192.namprd04.prod.outlook.com (2603:10b6:510:1d::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19;
	Sat, 17 Apr 2021 10:39:38 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4042.021;
	Sat, 17 Apr 2021 10:39:38 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
	Petersen" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Thread-Topic: [PATCH v2 2/3] dm crypt: Fix zoned block device support
Thread-Index: AQHXMzIRa8gn9aDid0SQEsDAmMromA==
Date: Sat, 17 Apr 2021 10:39:37 +0000
Message-ID: <PH0PR04MB7416A8D3A8A8BC87EF790B579B4B9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
	<20210417023323.852530-3-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:15ab:1:4419:a77b:dc28:73ac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31aad4e9-b7ab-4ec6-480a-08d9018d1989
x-ms-traffictypediagnostic: PH0PR04MB7192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7192B82EC4E8F818607E0E069B4B9@PH0PR04MB7192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: kS+RuRx4BjooxoHQSS+CLjWpUsv87N72gRBWeaC1M8ORapu8isHOFY9tGuRLz/LO9K7InojTlO920l6VL1SLlxJMd63Rqh5C3dwL4m3mqIXFJD94UurS/PJyzlszof7gOqrITWUHiKZ9cTzSe79YeR3cvar4nefyhb8augySbl2uqW3XqU3Yhd3Y6b5ZiQF7zCp9juUG81Q15P9TLssitlxww0quhAfRWIef08MmL7m4uj4694RrEno0rHfQF1ba6SuohAN86wUE11zfcswTvy9teuXA3rmUuHvySkWaC1BEsnEH8WUrtKmKG6JIlfXHkgHrcEFqPcrSFbJomabvEp4zwwUmmCHb/uHeo4B36yMPCU09IxNjVuyQiagG49MEEorjtpp0zmZ+htL5991hKMXVGmInYARBKA/vn9lqAiZ/e7W/GYepw3MZf3czPlNQQIczIwBDDIMPh2dh8cJU+vM6wC5kE5qsGIkAjN87DNUkHtdHLnGjhxPkli9rg5+TBKFHR0O1Fu2WO6rxNK/0skTqm576LCk2eQHYPyJDyu9MSQtdJ4rznrYkWPbHwR2HQH028BC70H9Wo+45U9B4oUC20w+/qN9cT7y0bCrU+K39E0D2FA2CRcgKbaGftmpiKVn6thqP+zfwXZtHK6CO+g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(71200400001)(186003)(2906002)(122000001)(316002)(55016002)(86362001)(478600001)(4270600006)(110136005)(19618925003)(5660300002)(33656002)(52536014)(38100700002)(8676002)(66946007)(66556008)(558084003)(66476007)(66446008)(7696005)(76116006)(4326008)(921005)(91956017)(9686003)(6506007)(64756008)(8936002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uwFyg0DE7Ef4J5NDnJD0/2tNciDu1zqFowlGRXi/BwC95Vi4wPVCayAUfjDA?=
	=?us-ascii?Q?jH4+pFXoQ45ar6Lp4265ermEgX52fZ/qEadcf+RqncAA6sUEceQ/MITFAkqv?=
	=?us-ascii?Q?8Jfo034yRgY2Y02Q7yl38qvO85vPMfmn23PFHwyejOGcCS6Y6TX+qwY10bhF?=
	=?us-ascii?Q?FCtyrgS09RIhenQ5b15IuvjvwM7gOHtp8SBFTzFIByfS87mgcoY6o1v3gmri?=
	=?us-ascii?Q?u3Tjvv7wAfPa6t43vUIAZrfRpTiMv7o/urLKb9+/+lpXToyF5EyR3cukKhVa?=
	=?us-ascii?Q?GWuE7ADF/QiAdM4+X6fzHHQsgm/mbEhXKJ22R9V0axWpYI+NrCRHvaFSQgsX?=
	=?us-ascii?Q?/0x5WpJmmFA0+XKK7ThKiV+ZhZj0bkPtFjuBldD8plThSMroGoZ+WgmgnIfJ?=
	=?us-ascii?Q?9j8Phdo9PrP2nt/8arhDQkEybyNeuPdNAwGRQ/pyrLos2sqwnJ2zFRgXxYrI?=
	=?us-ascii?Q?CNwDOjLgVg5gt+u/0UCWFB56aWoCCFTfoAjk/hu0MlodjH/H91VuVF4fE+n6?=
	=?us-ascii?Q?+PtXsC5I4s7IEd7TUhKTzJhmeEmwBhyo9Zdj8tWvoBfSM1lNs5v1RD5EH/xH?=
	=?us-ascii?Q?ZOWD6bpk8TNvpskVM41yZluba+dqLZGXvDU+es8rhf6NS7wl2++6LP1DfBLR?=
	=?us-ascii?Q?TolgtBX1r8qEDIPan7ARv1lp6Gdln4uQVvTTvRBYp1pknwzneYF+zarC3oU4?=
	=?us-ascii?Q?79Un0zGKCojwXycLK7JV0RkR03KM2IRHLsklqudiHDqP2qi6KTFDlEK3yhi9?=
	=?us-ascii?Q?h0m4uLZoI933acXFMOLqUZie3le2USVfmTI5RLqqVpM8MGSCdidSFOAfImsM?=
	=?us-ascii?Q?zCT4CcVsw9lshgWsrB+D3LBhdflZJfCjoz+WyCe7rlKpo3YBjPF8jTJn4g1I?=
	=?us-ascii?Q?XJKoNsi+hVGIj9tWrB66t/9NbagLYlaUsMNUffraSmUMojeGzZTb9VaTuqV9?=
	=?us-ascii?Q?lvTdIXhQLYQ4qeckueR4gGZC3ThhWmY3g7N8kRrotByxowzhJzxySyk1FJAo?=
	=?us-ascii?Q?vDKXv3CPGPeGQCkmr4Gn4anQQZRghhCdn4AOZsDFPE1cRCu3Xjxt9CwSgaNR?=
	=?us-ascii?Q?fcqBfWIIzV/U6Jv3ZBkL93mQHzzV+dlEYI/eNL7+m3tCtVr3dW6Rrq2+xeSp?=
	=?us-ascii?Q?iTaX7OTFZKYWr5aH7dRdpnAc+ZI7q9Q04JkGEA+mdBA0OjR0p/1v/h0kiIE/?=
	=?us-ascii?Q?faPpYCMxaY+dhfAKdB25p1mWLnTqP8H8bWjRZUMW/Z/S3GyXARvVb7QWhx/v?=
	=?us-ascii?Q?iAbLQix5MkkR8Qs+UncXQk9O0FYys5aVw8z1WhAt9Wiv9eDay1K4BFOSkO9T?=
	=?us-ascii?Q?aygbCOmlkcsRWx48YJLMNu56janYFlFbGYmxtvLqqHtjlboW82h7aAkWCBuw?=
	=?us-ascii?Q?ybjBxazxXlUZXPvfAltkN4z00DOs?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31aad4e9-b7ab-4ec6-480a-08d9018d1989
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2021 10:39:37.9123 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wZHY+K+S4DC9jLzj42Phy6ZWBExplPEzV74U/nwBgeSybmWC1Dl7HSE6cjiC+NTjXhR5Egv9hR9JbRpfxHffo1zePabfBzk2WqWyjwpTUeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7192
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13HAdmbT001537
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [dm-devel] [PATCH v2 2/3] dm crypt: Fix zoned block device
	support
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

