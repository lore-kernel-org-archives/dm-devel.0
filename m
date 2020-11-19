Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1875C2D0E4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:39:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 230EE246D1
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 230EE246D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-EFMrIBTRPxS1s1_1P5XAhw-1; Thu, 19 Nov 2020 03:39:38 -0500
X-MC-Unique: EFMrIBTRPxS1s1_1P5XAhw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 179681005D4D;
	Thu, 19 Nov 2020 08:39:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7C1560BE2;
	Thu, 19 Nov 2020 08:39:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B925A180954D;
	Thu, 19 Nov 2020 08:39:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ8dWfq016505 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 03:39:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F182D218DA50; Thu, 19 Nov 2020 08:39:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBC54218DA36
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:39:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7238185A790
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:39:31 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-289-WRNZzmvTN6aPVuOuMhNUBA-1; Thu, 19 Nov 2020 03:39:28 -0500
X-MC-Unique: WRNZzmvTN6aPVuOuMhNUBA-1
IronPort-SDR: vAoAVeJm1/5MEtcMU/kFHtNBbrm5JShpR7BiZqP78Dha/TKDLv3ZCyYmdM+YVahaE7+p4jGq6D
	irSWb7OFiFT0ng9oh8j5mY4+80e3SIWSdTjOOvxPHG9dU8+bqaFoNAU7P8QoNyetXzhr3mdsKa
	SbHZIrsBDMNPmMKym3v9RujfhSvVjfv+oBT9BOmxe2QJgx7aS1OAsySwZ/QxLrFDCdkKoBdYdl
	i03cjz70h+etnh0VznvYAmwNo+yAj+susaHipAF3iyZu6pUiZ8MjAAqTLx3QJn9V03RUCZLns5
	/Oo=
X-IronPort-AV: E=Sophos;i="5.77,490,1596470400"; d="scan'208";a="256563234"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
	by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2020 16:47:15 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4862.namprd04.prod.outlook.com
	(2603:10b6:805:90::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22;
	Thu, 19 Nov 2020 08:38:43 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.022;
	Thu, 19 Nov 2020 08:38:43 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 09/20] init: cleanup match_dev_by_uuid and
	match_dev_by_label
Thread-Index: AQHWvYhocOE/KFj+qU6m8HXUxgOagg==
Date: Thu, 19 Nov 2020 08:38:43 +0000
Message-ID: <SN4PR0401MB3598D6B584FD73A97E3681AE9BE00@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-10-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:157d:bf01:851e:5636:4e29:3e2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d44d37f7-3e46-48b6-5716-08d88c668629
x-ms-traffictypediagnostic: SN6PR04MB4862:
x-microsoft-antispam-prvs: <SN6PR04MB4862D36B009D3979BBCC93EC9BE00@SN6PR04MB4862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: vhLfugirm/LBJVDQVEhG83CPym6FDM00kZxCXB0hqndJRE48vo97PGXQ0wPUx9XAR9SJuLVJkqdGd3lL8YCK8RsFy5SnF83vRnxC/BPusxZAymKlBel38EcuEHJd6QjR4Kz31sEMe8qcVSd+0pGApw2l9m3HbURdau7tZ5I+8kmOr7uz6LrzBSsU32UcSnrjD8NPYG4r3AjYWMwzhhnF9CWFdXCDOa75pHsYFCwWhQEiEghykYxLd31FfmTFusr5YAVD1qlZC+QwYG5Jzk/vfrdT6lyEsy02HCuPQIF0NisRD3YdoFcIqgD52iCiY6dIBwy7cq8NPlBxGYslflnbMQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(8936002)(71200400001)(19618925003)(4326008)(33656002)(7416002)(9686003)(55016002)(66946007)(76116006)(478600001)(66476007)(66446008)(64756008)(86362001)(54906003)(66556008)(91956017)(52536014)(558084003)(2906002)(186003)(8676002)(4270600006)(7696005)(316002)(6506007)(110136005)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: 88nmOM5+EWcTP4MQ2A3An3tXN9wV0en98gGW/l7Mp26Nsg1CXZRXzntWhvD3UXdE2DUij2u+4u4xFcuRndUlxAcOr35K9aUPDmlpPNQa7Za++EWjmdrRWHK2XrtEDCBpLQ8L6IkVMFT0AMwdYTEZr9A5gDSg8RUWyranfcCvVniTCysKqWaaHxJQRK96f4bI47cNE5YSp8IRdG/MULgFkl3KmRpfZ8Xvixx+/KHvI5xqfppbc4Pntr+1RfwPW2m+xfgowibFPyX1IZcq5keRVL0Hz7kE/WYlLs4qSUhy8ftZSG8weuwSfm1XO6Biyn42XDb0QFRJOe0dMlqMQXHZUIQzFgRE4SzU2b4s1dgk+XZVZN6RryjfGOY7IcoNjR3ixggU6a4UEoMsoUyqh1dau7WWKWe0LiCziU3FfcvHXbI5U4hz2DSW751XQLOstKdXGhXGIVccGAL5wkmHvgBJ7PHjk0ucQ5ldk7kR2+HgOiVgffBl5cvXm2pHFHMINAtpOjP/Lj2oVE9To6fFpcn4F5xfNU1Bcy7VOiNoYphQXJOmzNc8qwkCRXYCmwZCUNG9WmuTMP2O+yDKDPtQ1r86gNh2p/1ADkfFWZJAS4BUFZqZL5gmi8uCA9K+hA4AHLCPQ/ieJtv35QDTih9HjWJ6uMm6CONTCswAkdnbbRo2SRl17wCd65388Ojf3tAmnrBHZ517A38ZiACklU367LG6iQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44d37f7-3e46-48b6-5716-08d88c668629
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 08:38:43.6815 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +lLmbh3EUsXFC6D744TZ/ixltcXZZdJdq/76z3I//Re4QhH9XcIZeGLJayetrzTUbYsWZPdAf1w6xEJPAXVxQz9sQiR9y892Xuadh57IlW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4862
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AJ8dWfq016505
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
Subject: Re: [dm-devel] [PATCH 09/20] init: cleanup match_dev_by_uuid and
 match_dev_by_label
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

