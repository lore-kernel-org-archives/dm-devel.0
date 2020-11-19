Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30131C2D0E4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:38:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 818E4246CE
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:38:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 818E4246CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-pwRAxSpiMf2FRB8vqt4kMg-1; Thu, 19 Nov 2020 03:38:45 -0500
X-MC-Unique: pwRAxSpiMf2FRB8vqt4kMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6751C6415B;
	Thu, 19 Nov 2020 08:38:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A18F1002382;
	Thu, 19 Nov 2020 08:38:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 94A4A180954D;
	Thu, 19 Nov 2020 08:38:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ8cbIZ016318 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 03:38:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AB90F2166B44; Thu, 19 Nov 2020 08:38:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A34002166BA3
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:38:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 012C0185A78B
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:38:33 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-214-gGfiO_MtMO-UfKYUxzKDIw-1; Thu, 19 Nov 2020 03:38:31 -0500
X-MC-Unique: gGfiO_MtMO-UfKYUxzKDIw-1
IronPort-SDR: FXHMCoLsL15+6sOwsJozXMQJ0lALrvI9IL+x+X2crG8/8GPNV5d8ilPUqFgxW3gQzlhCytqPP4
	paw07kWj2A30i4ystN53Nca96hHQVSsXNcoNTP7aTftKoZ99Gd1YF4N69ehve0pCXV/k5NpiCR
	qESF5OKAiESW1N0VJ2wq8o/3niQ+xq+YTcTCbF9iRJnI1JyT5z+bmmZ/PaHxT7f/GbFyQMrjXr
	C1JWLH9LcuytFZOUzKnP8rtzGwFLAsR4HE/xDD2vDjgIlJH3A8hHy5SJ/ocz2e0PiKH0fRzs0E
	3HU=
X-IronPort-AV: E=Sophos;i="5.77,490,1596470400"; d="scan'208";a="157444401"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
	by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2020 16:37:25 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4862.namprd04.prod.outlook.com
	(2603:10b6:805:90::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22;
	Thu, 19 Nov 2020 08:37:23 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.022;
	Thu, 19 Nov 2020 08:37:23 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 01/20] blk-cgroup: fix a hd_struct leak in
	blkcg_fill_root_iostats
Thread-Index: AQHWvYfzdYP5XcxCwU2lKCcMriBnrQ==
Date: Thu, 19 Nov 2020 08:37:23 +0000
Message-ID: <SN4PR0401MB3598AE3DBBB56E8B42A7D3EA9BE00@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:157d:bf01:851e:5636:4e29:3e2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d27a3179-29b9-4f23-a2f8-08d88c66568c
x-ms-traffictypediagnostic: SN6PR04MB4862:
x-microsoft-antispam-prvs: <SN6PR04MB48624BDF06CA1E8797D237529BE00@SN6PR04MB4862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 9WlGvL18XbMQQNFB0M4ZbO6snyh/Q5KyvC7OP0/lbAug3R7W9b/3WrXCPlPHusAEvbr7rUJOMGI5xkXkMdl0amoEa38m/hpSf9WFwoF7GlqD4ZBs9vuqNRr4/1SBJwubKx9V9miJOQ34pnqIIjv1D3dNQOJYWQNh98QVZN7hLTnYCwjcNEawLQjJ2sddSVJK72A1WBVPZfAIRSRFVBh6Mou3Mo5+XSmuRvjIpyisKnKXzbJqJfklEMhdvT9AnAcesxr0v7Csc8ei8AjpWVtX31QFHtm0Frg530vHx24TtdNgJti9bH/+Y9qLzq58fZZMJ5XxYEGm4Jfr1wT3FvCU2g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(8936002)(71200400001)(19618925003)(4326008)(33656002)(7416002)(9686003)(55016002)(66946007)(76116006)(478600001)(66476007)(66446008)(64756008)(86362001)(54906003)(66556008)(91956017)(52536014)(558084003)(2906002)(186003)(8676002)(4270600006)(7696005)(316002)(6506007)(110136005)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: tdPYLl1Uv/jCJ+EAJnAzELPE9akpP6mmhvdZT1DlIVbDKnuJkGXzCF6JzYdIl55o5O8VmvUWtGz1PdeDxN63eGmpkxnMVdYAJZCg68XjlpVFb4yhvuL4b4ljwDtlpdbLp32E7gZ71kZ6HIopAY2Q/uP7fSfiYYIT6grFyeiln4UJtvyqkDCHftFj+ysG0U6pKCLKnt2TTZV6JHfeFmDsdnTo+sDs1bSqediaXwJ1vDFOMpWL/zxJ05sP6wnPnQCWT2uRsV8QVz25z22pcM2Ou+ket8IajLVBn1ygPdoeqRLbyIxNK5kCdbh6p22vqv2Uy1BD1e2zJwxYpfA45Nj/ahCPEIN5/Q7am7t2DEn2BIJBZiu3kD29D/htv+Tq5u/N8xvM/2b3DQnnfOh5vwT1jwVjZHGznAUc6e2GXVIjCD7wLv9cvTGnU+CC2/fYCJKXTk6rpEM1VWmEUjhid9+NnZ+CwceDWkA1dyr29vEAYCXR77z55xCB2Hsp7wKIYZXRS+ja9Ngu3+UQPxX3DOxA7vv89/BDx9e/kP6xy7P/E5tORlLCGUHiASz8MKmUrClzeBzeGqbS/h3se1SoZjYydGEFHGmGNwNvdgUkUw3DUIeBmAVcyypTU55UezXMwUdWczjtNsIddu4ZL3a0TYGWSF8OuSximTRkbz42iRaMrRtKPM0gIRAKmgXA6e1NXCktrhMEbHklHouJTXXqKaASwQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d27a3179-29b9-4f23-a2f8-08d88c66568c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 08:37:23.7916 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /WcEokteTN/qdeIKSXHmL80DipE1H5Rz0S33tmNFVvpxBLt6BgRhEshpIUzrG0YnkplWFQTwOiFnV93VTrI8SLTWYoxkpWQRjyQgnsyJSvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4862
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AJ8cbIZ016318
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
Subject: Re: [dm-devel] [PATCH 01/20] blk-cgroup: fix a hd_struct leak in
 blkcg_fill_root_iostats
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

