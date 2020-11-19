Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5339C2D0E4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:40:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2548B246E0
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2548B246E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-Gg2BI5T-PAGSmaBmEYi1xg-1; Thu, 19 Nov 2020 03:40:25 -0500
X-MC-Unique: Gg2BI5T-PAGSmaBmEYi1xg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7292C809DF0;
	Thu, 19 Nov 2020 08:40:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F78C5C1D7;
	Thu, 19 Nov 2020 08:40:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 20EF0180954D;
	Thu, 19 Nov 2020 08:40:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ8eIBG016719 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 03:40:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B65258A4C2; Thu, 19 Nov 2020 08:40:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF9D9C54D0
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:40:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 977FC85828C
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:40:18 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-582-qXq-BWo5NSqxSlf3M_dhmg-1; Thu, 19 Nov 2020 03:40:16 -0500
X-MC-Unique: qXq-BWo5NSqxSlf3M_dhmg-1
IronPort-SDR: STrC28aPaitQo1E7sxRiqmb6GNJBmBQGnQiachRmpdfsFJGfkwSpLiOX3TjtF143VMo+SCCKhw
	+8ltkfjcLgCi9MignoCLoWJ7uRTKMjxK0UAcRorZALJIRRtOVZ8iTuyteQPCiKhf59C1CjOq36
	POBIcljs/LOOsRWxhLJUcgF5HjwiUjV6wfKPMtBa6rYZN8ygp+RI9zaCzhJQhBAVYNbt1wXYeS
	1w8pNSZT6i9l16GrdE6otQX6/O/qYPVsed/uU9gBly4m8dKdu+Hm9SlGAhCTUXLnWhhzc3KPiD
	VM0=
X-IronPort-AV: E=Sophos;i="5.77,490,1596470400"; d="scan'208";a="256563179"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
	by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2020 16:46:24 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4862.namprd04.prod.outlook.com
	(2603:10b6:805:90::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22;
	Thu, 19 Nov 2020 08:38:10 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.022;
	Thu, 19 Nov 2020 08:38:10 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 05/20] block: use put_device in put_disk
Thread-Index: AQHWvYfygihSbkAO3EqJycs/+eV+qA==
Date: Thu, 19 Nov 2020 08:38:09 +0000
Message-ID: <SN4PR0401MB35985F6360E32F28890703BE9BE00@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-6-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:157d:bf01:851e:5636:4e29:3e2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 92c3f2e3-cc64-499d-51ba-08d88c667205
x-ms-traffictypediagnostic: SN6PR04MB4862:
x-microsoft-antispam-prvs: <SN6PR04MB4862CB19B47022438805E7B79BE00@SN6PR04MB4862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: g42yADA20zKfT09YVXuquvxGh0iZXmsRDe9bklMiBrFQthaK28s1yf2EjTv1uoB0v6pKXfQCrEQVKqstUKmCpAt+rzV4LFtnPPrytVFPPjrsUsT1NY3vw96pHhMN4RK1582QV7b7eUxFSPToG8D+dIGtqOaZcHriUkTB/p55+rWo3EWMFtY3A12CPlhoEOaQ/+o71LMRPBCMrxVsqPjYcyrAdcAM1YTGLz9AdAxyjW4hEirLDTpfYU93z1QYWovqJncjaAhVvgJFG4jATu94xNJ42VcFduKC2UAQ6ZFdsGTs9oxiNNnabE5ylyI0dZwNUyEaT7Y+NUIVmBN/UdjTKA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(8936002)(71200400001)(19618925003)(4326008)(33656002)(7416002)(9686003)(55016002)(66946007)(76116006)(478600001)(66476007)(66446008)(64756008)(86362001)(54906003)(66556008)(91956017)(52536014)(558084003)(2906002)(186003)(8676002)(4270600006)(7696005)(316002)(6506007)(110136005)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: /akJuE1o1z04hMhHtY8YfzGcCbUKkscN5Mk/ueb8x/1TSn28wXiiO/Uv/GeWQNoedJbudgJRSqr7s1xxUx4VG03KSLCLuNolrhv2cujAFucV4dcggqQKcNMDMvkCpIy/aue5UXHRQywDh1svaqswB+/H8Tn34pS51hr06VmgM9H2JkpsMwabvSeLo4NWzKfzxo24o9bEuEuLJP1Bhnjmh5sjWfYZdJrMCuc1ZPQY45j9hGoEL2xM98JsJlBFSP3qSNRMZa1dAUGcVgXSciVoTriuTumU3lkYPebUUQdSoqxkc9Nt+qtM+u+IcrzJI7+uVnfsfeMpUn4vsHbkn7pN8CVThtTjjSwe+9wqtRzHuh0bW8HKVWIlhs572lHA9Jx61ROnvD1OHWSCOTqI1yntTvV2rcaD79UJuQNREfG6mEbzmw80keiyBT9Q4aleLVtMxL/wsfBY6vOkS2MoMDh4xoh2+E6jQcwgea9GQABAp9leTw3iolDV+eo7LwZQs8XKQkvLAu4egy+aBGJ850FhTuZxrYUeCm1ITygSTGy04jvPEjG8rHPCj8KttrDjmB5vRYElkn7kVNjF90IsehoQjFEttUFlH0jZRgEqOZCJHQtFejZHQPQYhiPbyvQDJ4kRvYk0AqcrdpnGhC0cj4/vm17IkTi9xSqtdiafgvsYM+H8NbgWE6KIpyX38rR/Gw59D7VgN6EPBxkg422mROdckg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c3f2e3-cc64-499d-51ba-08d88c667205
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 08:38:09.9609 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /A+nGOFGHVgtcuTmOCVgRAAjJNv7win23VbADbkAEy0+10HCHizCBKfCvlNVPY6m9rus8x3oWitEqAHBqzMgL65YOdUAeLxVGcm7bjyLto8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4862
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AJ8eIBG016719
X-loop: dm-devel@redhat.com
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Mike,
	Snitzer <snitzer@redhat.com>, Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Konrad,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [dm-devel] [PATCH 05/20] block: use put_device in put_disk
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
https://www.redhat.com/mailman/listinfo/dm-devel

