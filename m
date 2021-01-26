Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9154AC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:18:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0761B2079A
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0761B2079A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-xE-vEuZ4N12cY-FzdZGWhQ-1; Tue, 26 Jan 2021 14:18:10 -0500
X-MC-Unique: xE-vEuZ4N12cY-FzdZGWhQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC8A6107ACE3;
	Tue, 26 Jan 2021 19:18:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85B8A60C47;
	Tue, 26 Jan 2021 19:18:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 207864A7C7;
	Tue, 26 Jan 2021 19:18:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QJI1wF015807 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 14:18:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A313B112131B; Tue, 26 Jan 2021 19:18:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D0AC112C076
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 19:17:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FCD3801229
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 19:17:48 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-269-hiObj-XcPQ2hNC2t6myucw-1; Tue, 26 Jan 2021 14:17:44 -0500
X-MC-Unique: hiObj-XcPQ2hNC2t6myucw-1
IronPort-SDR: MkrrKskcV1WCZ9sRLm5GvfQSNMyMiNKUr1QI3VzWSqnuxi5q9G3zxbnSrh1WGwC3vp5ntXv0hV
	lTQGJiFtNudJeeDfdTDwoAyTdZcfGMeGWSMig83Wvvvzx9m2Gzy3QXAhlC9nNfq+kDdtQXpreF
	KYDEBdtcV4O1YdFlihQZPqOrfGUy5mvdp7x5g+8ENOGXGjNhLqOg/jxO+QtXRbko2H52oPe74W
	ohqIL5ZbKFMGGbZssCuHlgoGtaQCziX9lRwKguNzf+KvQldCe73vX2LyG/s2qLI0j8alPCNQ/z
	84k=
X-IronPort-AV: E=Sophos;i="5.79,377,1602518400"; d="scan'208";a="162826611"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
	by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 03:17:42 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BY5PR04MB6600.namprd04.prod.outlook.com (2603:10b6:a03:1da::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13;
	Tue, 26 Jan 2021 19:17:40 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016;
	Tue, 26 Jan 2021 19:17:39 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu
	<song@kernel.org>
Thread-Topic: [PATCH 16/17] nilfs2: remove cruft in nilfs_alloc_seg_bio
Thread-Index: AQHW8/fDBJWm5TF4/kKRwgyzgGtVFA==
Date: Tue, 26 Jan 2021 19:17:39 +0000
Message-ID: <BYAPR04MB49655561B914F4157914AE7186BC9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-17-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:8802:270c:4b00:b091:5edc:1473:bf45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d908b84-6353-462c-e998-08d8c22f0c58
x-ms-traffictypediagnostic: BY5PR04MB6600:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB6600677E49D6AA148742CDAB86BC9@BY5PR04MB6600.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:234
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: fuzGW4LRAHmL8S0OHwCY59zlusWLshOmeLh6SPdXrXTS8rka6NRr6yWqvRx7TKiabt7iA/f+DwjUGU37wo7656Nvc55HhlyPXiEyNraAAc2P5GTJfsiPkP1ZWs5kJibiGvexWu+Wt50TxlmnAx+Bn5ySNGez2lqSQolxuOEmJunyMiE8pIU/73BKGnx3th7HoRXE5BAof9r3Yi7gDXZvoliCKuSYj/swgmELvXe2IBPqS9WpuPTXWbRmciXGFBN+3HWVhfRZzgaD64ObS0/r8RmnGEMTJryTc5Z9KjHXatImo1KxAUCkFSrkmI/ewWo2sAuJZasc/3W9HzVKDNVc0XxQwfGc6sFNUFMYppGjliHdFdnqrqp2GlGvCIDJDfK6J2dW6y2xAheZQvfpFajcnlf9/vG/Z0QZoK0WbytgPcF1DfMyCS7dDes5sUQui2YTHi/8IT3hUdIBOMLfWSogEr2egs2a9MIGJBk0yvnpqwy97I0HNxWF7ILdOZwqN3Siyyc8eCpYhmAhUplYcCl5eQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(558084003)(33656002)(66556008)(91956017)(316002)(2906002)(8936002)(86362001)(66446008)(52536014)(66476007)(64756008)(66946007)(76116006)(7696005)(5660300002)(110136005)(186003)(9686003)(478600001)(54906003)(53546011)(7416002)(8676002)(6506007)(4326008)(71200400001)(55016002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ve5opoRjDFFdcqmNB2hzDHTNo3Ul7Tqk8ocfPq2CcJxXUW/hQyeEx/BlrT0i?=
	=?us-ascii?Q?mHy+cmR111hI2iHYUSWz6zz3sRRcrDcBcvojNOjSOhB3Y4c0xAcxJup5wep7?=
	=?us-ascii?Q?2hkr/0IOPSLmxQ5Odf+0xTuw8IKcT3wk2YTXvClZIicUJynIARMDtrukgkSE?=
	=?us-ascii?Q?HOIthERZwLAL8+AXf3DM1x6Rb87uZmugNsphfZmwd/ZRRfuYSvNGMAO+s9+T?=
	=?us-ascii?Q?Py6YYEodXJy4kRM9EDRhO+ES/4RMgd27sbrqSfm0XsLf7OhpdY3h3J9DGQ20?=
	=?us-ascii?Q?OUQdpktPnwJvbg+CAU/s295+SQ3ADGWMB36TvbY8C0qIHnbsPDS7PsDWs/Tq?=
	=?us-ascii?Q?UAEDdwG3GXtbXrNhr0BkV3MYcCIA/YMs2W7ZuUbQJbNF9ajPKmXRfsHdP1fw?=
	=?us-ascii?Q?WL8Rjv3+4WOK8CGN06S0H1fenl/pvLTrlJmMNLVPylivBCvJeSjzkj13pGGN?=
	=?us-ascii?Q?7gUqLcSm9WjjDaAJMg8uOPRksicH4Pl7hdKJgg80UETjGTA45ddQH54jhgYL?=
	=?us-ascii?Q?9mGEJMrYa5sIclzLFv0fM/uWkvzLXZ88g5GmXaGWgvo8oMm4lsI2r/s76d4z?=
	=?us-ascii?Q?ETP8cC/uuJCmH+LcnZVdRuYvtxpc/m48IF3MVCDI1xMO2XUmDDa0nnQYJr8i?=
	=?us-ascii?Q?ljN59rbpKScUr51ePKW/MK+6upVH9kwGiat8pX9JCLiVQHK+fXlUsz9uaBU4?=
	=?us-ascii?Q?AfMsY6aNDzALvA0CHWxURX+a089F2eEOSrRZkZwTtyftB0oQN7erGee/JvVk?=
	=?us-ascii?Q?3F4yjT02E94tVVDzxnhEFj8N6JbtiiU2+BuyAEn3diH8eUrkJDWc4/P5qgHp?=
	=?us-ascii?Q?n3XYsC5EL0nTEXIxnCspet5Z8WASPk8UbZRidQbHxcTWzRdLlRmxxX8vfsuY?=
	=?us-ascii?Q?yi48acGbbi8x/KBEudXJ8XbnFGc0kdaLiuJq2wFww8tXfV9dwgzPri0ku+4v?=
	=?us-ascii?Q?diQCXRSZbddO0kS551m/eLOuybuhSWcRqk7LGoFg8ACQMybfU2jelCI3lpNp?=
	=?us-ascii?Q?weBXzReMbiEAVs7XDYhy+8REnBYjHgozMPhRClrFIzcGMLG1F6B2s2lE1s6Z?=
	=?us-ascii?Q?C//12g5YLtqnp24DJb6j5rLMFn1kKdbjJbzMUnDiG3ZqDyn5A9TMo7SWW63p?=
	=?us-ascii?Q?h15i1SWt7buFFQlw47O1TfgKdnx+NjdTHw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d908b84-6353-462c-e998-08d8c22f0c58
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 19:17:39.8430 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CAeguBAaV/yyuZcEX/cI1RELh49y5vPKGx37qy7L41Y1cYfRnUIGyC6A7WL1HrXgXa4d73n4xmNex/Vb4gKeqdyYe4e+xcXvkcgmbBFq/jY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6600
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QJI1wF015807
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
Subject: Re: [dm-devel] [PATCH 16/17] nilfs2: remove cruft in
	nilfs_alloc_seg_bio
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

On 1/26/21 7:27 AM, Christoph Hellwig wrote:
> bio_alloc never returns NULL when it can sleep.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

