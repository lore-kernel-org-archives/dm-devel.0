Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78030C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:24:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E31C922228
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:24:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E31C922228
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-kG9UKzX2OlmKLfrPaLhSag-1; Tue, 26 Jan 2021 14:24:37 -0500
X-MC-Unique: kG9UKzX2OlmKLfrPaLhSag-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9300ABBEE3;
	Tue, 26 Jan 2021 19:24:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4373219C46;
	Tue, 26 Jan 2021 19:24:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B7D034A7C6;
	Tue, 26 Jan 2021 19:24:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QJ9dRu014517 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 14:09:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BB40D2026D47; Tue, 26 Jan 2021 19:09:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1A802026D49
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 19:09:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E86182DFE3
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 19:09:37 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-7-61E6u_WYOP-AJ0Wmq1GROA-1; Tue, 26 Jan 2021 14:09:34 -0500
X-MC-Unique: 61E6u_WYOP-AJ0Wmq1GROA-1
IronPort-SDR: ZLZpwRVXYXuqucQk4LzjqbsACPMCWjLltDd65uTVUK91NaD6NYa9szG3Yu/xxsLQnUGxZ/Hfxl
	al+ABfpuzPa/RegGoK13Q+Y08Wn3GIgdfRYZlE1re+ChX6f5XY/mfRNzI+9iGzuiI6L9J4WtLP
	xKYvv8UYajhDLdFbZvItVPrDNl0lvRE+mdFFGACL5WVrr/43A/cjIYtqbkwS8WIklV4P+m52ai
	hwtMFEtlVfYls4W7T6KZmqFO6DSbHZkgR1PatE9b9zIYFi7QUmbCYObpLc6futzOIYEXTorU5a
	qK4=
X-IronPort-AV: E=Sophos;i="5.79,377,1602518400"; d="scan'208";a="158378853"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
	by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 03:09:31 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB5895.namprd04.prod.outlook.com (2603:10b6:a03:112::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16;
	Tue, 26 Jan 2021 19:09:30 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016;
	Tue, 26 Jan 2021 19:09:29 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu
	<song@kernel.org>
Thread-Topic: [PATCH 01/17] zonefs: use bio_alloc in zonefs_file_dio_append
Thread-Index: AQHW8/QrNhI8HyLlwU+4pUC6zgQqrw==
Date: Tue, 26 Jan 2021 19:09:29 +0000
Message-ID: <BYAPR04MB496552BD237A2B9388B82CFC86BC9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:8802:270c:4b00:b091:5edc:1473:bf45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f35eef7-24b1-40b5-ac26-08d8c22de84a
x-ms-traffictypediagnostic: BYAPR04MB5895:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5895EA71901A3B2B4198EBAC86BC9@BYAPR04MB5895.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:949
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: N5D1t7fEmZ/vRNsWL3SIMc3Ot4sbmgvQI230Ws9puQQrSkHLU7QdmNi6cGMo6z/AbJK+eQGOSmvl0g0DpEvFCSiacEm3U0OSOfor1kMaTHm2KMXIR+6kbjZGjKo2FO8NFdevDiQwjJ82AVtVBA7fzkpchaEiRp38f0cIzWBXIeR1w9G0ik/lTypoLW50rpeWn/1KfAZ92+UAED1IAoshDwgj/uhsSznutl+YUp0j6FIRTnIyaPGvKnQ2oahnSOKI6UfxNzZyynVTAnW+PqbZxdwTfus6WeultlmVhuXW1N+RSFMXlojqaKUFCueH8/zSlx3xzceb6pHlv9c8DCpaa1fQYpwiNcgCzbE209PFFG4Lcyl9z9BqvzcK0F6CHQJPARNJQGaSy8eQ4/yujPsx1g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(478600001)(53546011)(6506007)(7696005)(316002)(2906002)(66556008)(33656002)(4326008)(55016002)(7416002)(558084003)(110136005)(54906003)(8676002)(8936002)(9686003)(186003)(71200400001)(5660300002)(52536014)(66946007)(66446008)(64756008)(66476007)(76116006)(86362001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eI6rIzFiJ6pedp6gEywHXdT+FYQOv4L4uRq8vwaUazN5LGmbO1EWcC9OHSHy?=
	=?us-ascii?Q?c/c/DjnwUKe0q1TWZbiU2nr3r3nd8CWCRLtgoY4iQOn5w2RmnmNpg5vaUaV1?=
	=?us-ascii?Q?X6B+RQfAqBmd5rgF77e4pU0E6PIbjW7wN9oTi+dFXoJBe+YOZ2Np5s6Hityh?=
	=?us-ascii?Q?djzKvVenO3GOcaz+yVKyxDAgCkZpv19KRm/et3BXfHHgN+bOCpcG9sq9NYB3?=
	=?us-ascii?Q?p1EvfoUeNOxYW0YiffyqGcehEvZoPa7DHpCVKnIaGuERUiocudPD6XBuo7a1?=
	=?us-ascii?Q?ijGncT78qfxBeNhPnzil3nbp98vJBzJd86wn4Stgq4FlKLjpiPwoRD8L7bG2?=
	=?us-ascii?Q?c14D0Y5fqjnMVtm4+6scIMKIZH2zgNDMqJXUnIqwg1Yl/GMIxLgbw7XtV5jJ?=
	=?us-ascii?Q?IVxooGC/QM9jTrBeSryVEkCkgibYzlgUvKrJG8nkvHKseF9phqCkxKzXryTV?=
	=?us-ascii?Q?4wfQXVaswzstXOyuVkO11HBZkr3l812sjAzSPvZz1KX6zCPEFEIgMJotdClg?=
	=?us-ascii?Q?cFb/t/s2edeFlHBLSdrLIPs/cGbDUq80bYZE+7NaBf1Br9P5mf3fJcUShVgS?=
	=?us-ascii?Q?uLnkM6iFXI02D4GySlgQqKE2lIx7V7Vb1h1LGJTPy1z+z676yEkCrsnjSpNJ?=
	=?us-ascii?Q?u1IZRMTY9kvecwUao/V+2CeiFImbwUAfr73PF9ROR8b5xu4oo4PnYT9VFG4/?=
	=?us-ascii?Q?KmNaQmLx8y2wbFmlF+ypcfe4zid6rsiXPJQGWJcwJM5Qkah7wwianLbKQfW6?=
	=?us-ascii?Q?+WI3lyzGlIvqXDoCPufhaodo1w7gTeOrWSD2xHaHcxT6S4z4rlWvO+B8J5Yt?=
	=?us-ascii?Q?liIdUjW4OmbxoioAIpMSY28TMvEPlWgyPI1nkCr+0pFSYxLXc8tOgv0fXm52?=
	=?us-ascii?Q?u7yKcGNzEMvrTbyqdPDHZOqG8VOilSuqBkYtL/zqqP8jScAm8MdE5EwIaUUi?=
	=?us-ascii?Q?JWfRR5NNtWEfdWsGMOIdSqFyXhlM4dYGoeR7Jv+bKqWCOf4zawJ70rz0+EYT?=
	=?us-ascii?Q?PwYk7BYtWdg4utZNrLHUYKieb+8kGloWg+ShRguSxz8FplEMgIJOO0XhtAZ5?=
	=?us-ascii?Q?KlfdbrpKp62cb1whKV/ytqcQMgxfKTIrr7qUBl+1nVdlVPkfWzNBvMeAeNUR?=
	=?us-ascii?Q?MOvDAGfu1lbcFsBdOgeWxMeKDWhw3/SsRA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f35eef7-24b1-40b5-ac26-08d8c22de84a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 19:09:29.8430 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gkoUaWb/WhPq0RyTEnv292YDUor0Pva/RL40BBpOQCTXxnD9rOdFToZ4ixKO5MZqy95nepFUpZvo2MUVDYgPBLJOfNNDqjPVo1cp6us5IQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5895
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QJ9dRu014517
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	Ryusuke, Chao Yu <chao@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@tron.linbit.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Konishi <konishi.ryusuke@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>, Philipp,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Reisner <philipp.reisner@linbit.com>,
	"linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 01/17] zonefs: use bio_alloc in
	zonefs_file_dio_append
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

On 1/26/21 7:01 AM, Christoph Hellwig wrote:
> Use bio_alloc instead of open coding it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ha Ha I was going send out a patch for this :P.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

