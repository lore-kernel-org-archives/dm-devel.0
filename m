Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB806C6379D
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:38:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2ADA8246CE
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ADA8246CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-AJ89jRj1PlGgr1UDwA3iPw-1; Thu, 19 Nov 2020 03:38:54 -0500
X-MC-Unique: AJ89jRj1PlGgr1UDwA3iPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4D101005D4E;
	Thu, 19 Nov 2020 08:38:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F00760BE2;
	Thu, 19 Nov 2020 08:38:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 585C614B2C;
	Thu, 19 Nov 2020 08:38:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ8cmP9016345 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 03:38:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A5F1CC77C6; Thu, 19 Nov 2020 08:38:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EA1CC77C8
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:38:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E7B080018B
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:38:46 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-390-l3183bxmOkOPseSfYOM9cQ-1; Thu, 19 Nov 2020 03:38:42 -0500
X-MC-Unique: l3183bxmOkOPseSfYOM9cQ-1
IronPort-SDR: StdrIOMCYswRZg6jQ2lIawKj4Nb51SsYNOaUKn3yYM4pK8EmKRcYoe4YYh+hOReAxYVxjRQyD3
	zH2YHQ41lsKGs3R6Pqb88ZMyny80vimXpqMFaLq5SJmhDbcY87lJAH4mrboq+PWUYwxx7BSO0V
	r0JP/AZbiuYHtrWwMGTI+UsH0S0WOEYOXo7X22T6amLT/QB4izs34Moyfjiu5zCH5Xtak5PlhB
	FV08lz9n2XXzhhsm8NChZ1aoZy8V3KVHcty6N/Trw8XN0R4n6oHmb2sOfrkVfuOXMyc5CHWYRA
	GeA=
X-IronPort-AV: E=Sophos;i="5.77,490,1596470400"; d="scan'208";a="157444416"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
	by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2020 16:37:35 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4862.namprd04.prod.outlook.com
	(2603:10b6:805:90::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22;
	Thu, 19 Nov 2020 08:37:34 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.022;
	Thu, 19 Nov 2020 08:37:34 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 02/20] block: remove a duplicate __disk_get_part prototype
Thread-Index: AQHWvYfztpq6w/pFC02UtIWdUqy7dw==
Date: Thu, 19 Nov 2020 08:37:34 +0000
Message-ID: <SN4PR0401MB3598F94B66D20E767C5AD4C29BE00@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:157d:bf01:851e:5636:4e29:3e2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 98cdfb1a-7b94-4350-579a-08d88c665d0b
x-ms-traffictypediagnostic: SN6PR04MB4862:
x-microsoft-antispam-prvs: <SN6PR04MB48628F2FA5D18715BA01A5D79BE00@SN6PR04MB4862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 9EU6zsu5wfqN3LzwpruHOA3vp8P7XrQotEGqEig19wHTBrjlE1ohLK+ynonRdF1W+UL5wUOVT7vKCtAIQt1dSmxkpZy4DwcLO44FjnTrjbNXSNUI9Mq5wH4rrR8XdBKih9KoY4v1it7GZ4WesFQhZZ5dBKUzP5pmgwnmt0WtD5bIKtK5htwauYpXl8TH4sg6j0HepHhcs7hep71FbRp4+8+nbJpt7IIBzHakBKpMSVoqQ8BhUxMKvxr4VZlyjthyXgTgH9RQ9rYR0A5fg+h6P3vM04AI1LUtG8AD6oJeYvLkuNL9IfWg1mZIXI71jhfByHqksAhEDVkCYrfz51ndNA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(8936002)(71200400001)(19618925003)(4326008)(33656002)(7416002)(9686003)(55016002)(66946007)(76116006)(478600001)(66476007)(66446008)(64756008)(86362001)(54906003)(66556008)(91956017)(52536014)(558084003)(2906002)(186003)(8676002)(4270600006)(7696005)(316002)(6506007)(110136005)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: csjjfoFZMdOUtjbQ7Aps9atodfrldZAbocrPpoPa9WuJ6wwSi7DnrL0jTbsl05umbEp5VVC+Yq+5KPyuvTo73nFFa0glxCUD3NqLFMLFCRmAqwzZ6jfwtuTOm1PGA+XNbnO2OBj5W8MgTuXPoSWugEuyBfyseXeerfvuPkcSGFyKN9wp3mddZY7FbFTQEBHdMb0j+HS7xJzjSmA7NBmmQwz5xyTPiYeoH2ga3rmicKdGPs+RkI0tc0bPk1q75G0FK3zd845mg1pA9gJoNCLF7sggrc7oZRshwwBzwahklVTj7UJRr8HiThJRCYgTVJwe9HSVhbVLjCB8fMTf1tFS01qJwvO7QRf5aiCsoSWY4BczKY+KevZvPRJeWcZKXZgWVP1fKakfbsuLMw0G7xu9h1+eOoypobiMkCp4KcJx4HXDIgJErir4uclycSdDgiCfNT58C8WSyGX/pqfKrXhFHSMjbg1zhQFlwLwmq+x4IVXunCLV+I/9vd/d1Xm1mZySuKEKxJX0X5kaxoc5ikUAsNXYZ2Qol7RsOAPY1XB2juhmbsYkVoEPCFliPFtr/McdEff0Y3lH9nbRLV2Fvx8F2elFq3wxIwNwKYRtzIEwafd8M5cLZt0SpoQl2w+Lc99wWYWrIchHiWf8tjaK1z0uxisWXgD48i7rr+9UZP7j5qsbKCrq/rkzjE9rrzRkXhzm8jX/DLvmDT+skKSPQRxSig==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98cdfb1a-7b94-4350-579a-08d88c665d0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 08:37:34.7562 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YNE1HeeUNLBOJT8P2aBEjcGVvGD9E2iGPxFIV8+WaWcaSCFxON7IDGhjH0CQvhEpzGLK8RUwPduSaG/uVJ3gocebzXpV1camyawT1yPVJOY=
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AJ8cmP9016345
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
Subject: Re: [dm-devel] [PATCH 02/20] block: remove a duplicate
	__disk_get_part prototype
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

