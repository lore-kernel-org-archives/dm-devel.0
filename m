Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1ED6C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 14:06:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E492E22B3B
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 14:06:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E492E22B3B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-GblWIy9DNQiV5DXyOVpTYQ-1; Mon, 25 Jan 2021 09:06:19 -0500
X-MC-Unique: GblWIy9DNQiV5DXyOVpTYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C21C981CAF7;
	Mon, 25 Jan 2021 14:03:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CAC619C78;
	Mon, 25 Jan 2021 14:03:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 29ABD18095FF;
	Mon, 25 Jan 2021 14:03:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PE3utM002554 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 09:03:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5B61C2026D46; Mon, 25 Jan 2021 14:03:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 548052026D37
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 14:03:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E916A811E84
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 14:03:52 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-202-ouWYbkvpMDycq7kr7jKlQQ-1; Mon, 25 Jan 2021 09:03:50 -0500
X-MC-Unique: ouWYbkvpMDycq7kr7jKlQQ-1
IronPort-SDR: V3N7ZrSNWeXTX+/dvYszCBh4E/pXfqshqmFMQiMDWHwAOGTJLRcZyxI7cUo0ne28UotquITEKB
	hnQwqn/jFVOVtBJJoaTeOUBFGDZ5/ZFyrhIj+VIsmE6lUg1fhJwQ1XV9HpOq3eyypOn+lrR42W
	FNq8SmU/8wKOP+cwLSCO+abdeSsPtD1YM+6BGllHSO7Wo6lqKk9ys0tIxZPaL6+kJp1FVrleH3
	s2CLpO2JgDRD2q2cVeg/mxi6xsXZI/4HkZ6+GgxKMC5Sxpfiwe4I+HsoIfaeGP6XKvrzcHdc5G
	kJE=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; d="scan'208";a="268618223"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
	by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 22:02:43 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SA0PR04MB7212.namprd04.prod.outlook.com
	(2603:10b6:806:ef::16) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16;
	Mon, 25 Jan 2021 14:02:42 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017;
	Mon, 25 Jan 2021 14:02:42 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 04/10] block: simplify submit_bio_checks a bit
Thread-Index: AQHW8jixUFjfNZP8d0CYJnK7p9X8jw==
Date: Mon, 25 Jan 2021 14:02:42 +0000
Message-ID: <SN4PR0401MB35984AC9DFB6DD0A76E1D70D9BBD9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-5-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 663f6028-63f4-4c21-dbfb-08d8c139e21e
x-ms-traffictypediagnostic: SA0PR04MB7212:
x-microsoft-antispam-prvs: <SA0PR04MB7212FF2C79CE723C2C66ED789BBD9@SA0PR04MB7212.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3z+t9zY+VtyQRVr6x2e728wxrgOx8Z1LU8v2ZTfhEyKJV5EJZa9wXklT+6x7v/Rpx06TnTCc5M7quAZqxbulQc2YjI+zwcBRAgs2aFAABXGIApSYD/YpkUUsBKvPsjH4CDe/meID2menHRrNVYTbg0ivQRi7ViWNjJ8cczsvBX5v8BiJ0St5f4hF/52lvSWk6X/Y5Ujov5hajxKPAXr5b+wEEzamhUScP5ekVhFbs27+V1FPi++DIyONVBU2p3FOF9xc7dv5QSzQDKZL9QV8x7KuaKH8vRrIeVdfOp67kmjypLaR1VwIjJp94jJ2aTgRx96v2o873FFBDswTaPWKgUnhjUffwKiuk3+wJ6TKKtdghTjH5uSlMiI2yF3sDdpwHByxZW4YJVpkeg7dkHK76w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(8936002)(26005)(8676002)(478600001)(66446008)(4270600006)(55016002)(4326008)(91956017)(76116006)(5660300002)(2906002)(19618925003)(316002)(33656002)(66556008)(9686003)(66946007)(71200400001)(52536014)(54906003)(7416002)(558084003)(6506007)(7696005)(86362001)(110136005)(64756008)(186003)(66476007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?v+KZhFzsc9vL0pMjFctD/Kc+LQPY1mH7rMEVZCQxzqvGZHos/FBc5dt4qqmX?=
	=?us-ascii?Q?8G6urzTZDq99meQ25U7cWy3ck1Kh0weXZqD+PTERKuBiWX5v2wm6e1lObFdw?=
	=?us-ascii?Q?0pNulamlrVka219ThF+QGBZLaDqXWb/UOvuKdX1Mb5dcRVm6EY6ZainjG4Hi?=
	=?us-ascii?Q?fyeKwVY2HPq3ysq6MlKmth3p2nqyYPcK6ZjEcvrwujmrzg8QvwndUe4Y3JrI?=
	=?us-ascii?Q?4gwr4N6CLCcXB3mvr+onujNgvzuj9mkWNnseao52/uKc//zWfUaL7ip0FkPV?=
	=?us-ascii?Q?fI5678ALh0ITCAZXHFywPbfjAELzW7InbKkif374TqBVxRpPMHj91ZzsP8Qu?=
	=?us-ascii?Q?l9inPvKZUnhKdceb4uz82QD01+DSIo0NCVxeEr6u95PNW3D0fI2w2wR7pnmh?=
	=?us-ascii?Q?rcNFJsIGLy1+j/ZKkRx/gLhqD0zWzxAKliMO+q1pN7pqdqBA/g3T0NaGuu/v?=
	=?us-ascii?Q?2t04krV6s9HzBMZVLr/ApGAHaa8ZQyXAyi/Mwqi+WRonR8TZ7WtE1kqEDlUc?=
	=?us-ascii?Q?kzflIx+pRtB8qM5DNxYoqv2GJlk4vkw2Ht7NbGFlwffHO3zzjFkA03IsqB7T?=
	=?us-ascii?Q?Djoo7cPHPaFzZJbQ/qRP866AVIaSDgBPfwM0ZXwKPBf0RxthWa2/QbFgRPT8?=
	=?us-ascii?Q?lBxqFPkpEOU+GWE+u1xDYEXh+VSRhnver6pJ93Tnn0B8Gw82s6T/qpkRvM1W?=
	=?us-ascii?Q?esgQdO4GD69U79d0Iy9kma4vTcKODHLqDp/baeuvf00jQWMlFT9pO+6Wqvq9?=
	=?us-ascii?Q?TUcBzSpuVqyoJgjRGbaCSbI5CezgmnYNjPY9uFmOipDkRhWCXkaPvZGjYiFQ?=
	=?us-ascii?Q?SCuca5lbcZWBTfVX7EkdoVHjZXzI/KZOHXylvFor1feGxDpcu5SpFHs6vVrl?=
	=?us-ascii?Q?s9w+NHvAQFJcX5mYmGjuheoWfaq5/kNMsAwSza+V6T4Sijs4LQndUQMmB0q4?=
	=?us-ascii?Q?hx2p1AtDFDvg33W0HWSFtaIDw74DOdYR1GmxuyqRlf/PaACQ4VntjeknRCEk?=
	=?us-ascii?Q?NFpBu45Um8n+ullPbPdnCDlzweKPM3/TKiIFi+yGdC16DFB9q7H4zkINgGp1?=
	=?us-ascii?Q?P170RebQYjRvZMRCYUBR0J9LPoLOJA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663f6028-63f4-4c21-dbfb-08d8c139e21e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 14:02:42.3355 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fecisb+yikKWREgRIW50+ya6NJK+A8bZWz/Eb5F1pseTJMZRl00cGDVDkHaUMTFuuJTLJWBXdzr5zQN863D87daA+RyOKYEuyk2QWI8UqMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7212
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10PE3utM002554
X-loop: dm-devel@redhat.com
Cc: "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 04/10] block: simplify submit_bio_checks a bit
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
https://www.redhat.com/mailman/listinfo/dm-devel

