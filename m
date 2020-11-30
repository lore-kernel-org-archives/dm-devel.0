Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A59C64E8A
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 09:20:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8D0C020825
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 09:20:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D0C020825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-8PuyN352O0i0pWcCTPWwTQ-1; Mon, 30 Nov 2020 04:20:34 -0500
X-MC-Unique: 8PuyN352O0i0pWcCTPWwTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94A0718C8C0D;
	Mon, 30 Nov 2020 09:20:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6658D60862;
	Mon, 30 Nov 2020 09:20:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB96E180954D;
	Mon, 30 Nov 2020 09:20:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU9KMuA010188 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 04:20:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 844392166B2B; Mon, 30 Nov 2020 09:20:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CD7E2166B2A
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 09:20:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 177FA80018D
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 09:20:20 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-252-8jLyYPQmNYOeLmUvTD61ww-1; Mon, 30 Nov 2020 04:20:14 -0500
X-MC-Unique: 8jLyYPQmNYOeLmUvTD61ww-1
IronPort-SDR: 30dmv2GVw9omZk5nScyBE94RWc12Y6/AOrt36CDVDgm3EJZT3g5dfep61PdsUYnfs+gLNwEczG
	lZorKKiN2ARJKbt8FOICeEW4tn+CN47ZNOJCiOAGrc9VH8axE3v1ryfp+3IE0lJZtNUQcUD8pA
	8TaIDArIFcdAJa4H3rY/29b+Bsn06eTF9SG/Xptw+RIaILqN7SK8SCauWcTf5lwVZElD7fYMAZ
	NNNU95ZQaFrs1UR+v9D7A6SZAdY4p871MkXTf68cL0+XrFp1Ah/liuArU3T21ErM8j68Rly6Hr
	FDQ=
X-IronPort-AV: E=Sophos;i="5.78,381,1599494400"; d="scan'208";a="257475519"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
	by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2020 17:28:42 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SA2PR04MB7594.namprd04.prod.outlook.com
	(2603:10b6:806:136::15) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25;
	Mon, 30 Nov 2020 09:20:08 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.030;
	Mon, 30 Nov 2020 09:20:07 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 11/45] block: remove a superflous check in blkpg_do_ioctl
Thread-Index: AQHWxaG2R4tyW2DDf0eoMvMUHA4YTw==
Date: Mon, 30 Nov 2020 09:20:07 +0000
Message-ID: <SN4PR0401MB359840636BA2F57A26F159E79BF50@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-12-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:155d:1001:2c26:fc00:7c60:29b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9d631229-9cb0-48a3-34ed-08d89511215e
x-ms-traffictypediagnostic: SA2PR04MB7594:
x-microsoft-antispam-prvs: <SA2PR04MB75949460375CD1052865D6069BF50@SA2PR04MB7594.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GzeUkmGPfSYvr0GQ/DW1fyEW3zzaETC4h/ntDEp/lAVe8ZTTwR5Vo5fZedO/796kdj175Fgka8vPLc7d/sHvZ9AS9Ob0tv6kLCys1rnboFxltaVN1eg3VrFMt64ciQFvmwfZ9KLb3GcF7beMzIo7M5augKw4GMoWf6yRRRkY/Xmvw8Pufis1JbFTulz6+dMbXgt8sRRXN23U4IAh/a27pf3kOobxhN887eD0sYr48y1XgYlBJKVUzsNWDrb820DTJpLTXxRuspFcApQoSeFT13e6CWgiOPuo+b/fQ2egNDJsgIO/iT4lPmjnfxc5GHWtyyVvIMFRnIDau0sqTa4y9w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(5660300002)(6506007)(478600001)(186003)(4270600006)(558084003)(55016002)(66946007)(66446008)(91956017)(8936002)(9686003)(4326008)(2906002)(64756008)(76116006)(33656002)(19618925003)(71200400001)(52536014)(316002)(110136005)(66476007)(66556008)(86362001)(7696005)(8676002)(7416002)(54906003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sBwgiRi8HFz91hVZPsEH4xofEUZ84B2oNLt24n94w5o7lK6S7/E8mNiOHVKE?=
	=?us-ascii?Q?W6sW3acQp2VPp7BmZ9a9S2AmMj4vCKjBOF39ms6IvnQb6ecCCfMRN5xIOL6z?=
	=?us-ascii?Q?al76fcfciTE56Db49P2aoVzSWV/Kj9fT7XbVQrebaiRxR0HtvwY301QPxV2b?=
	=?us-ascii?Q?2PuWaxrKG0sY5ZsL/iC8lVta+Mp6RaRFYjnDJ4lHo2l1RcHv8GhUKPLANbrv?=
	=?us-ascii?Q?frSL2A6R0wzzTR5Krwlv6sx2mkaMua4sQNGGfa/KH2V8mEBrd6mX3FrDJxOn?=
	=?us-ascii?Q?36iT9cuPvoyXpMzhsh4pZaXyhiTDd1FaE3VRHhqcDEdYrN+vzXi0Z9kbykT/?=
	=?us-ascii?Q?t+ZdOmKouYfeC2h0bHwydsm1DTWImrk5/SiclJrEx523Dgct/NnKmP57G6fe?=
	=?us-ascii?Q?FR2OvbheXDMTmrALZF2UWN7ll8MlAzTjSecSR0HcSLVcFEb4Qjj9K+/6c8bp?=
	=?us-ascii?Q?EuwKMGcqJV7WptUbqPz+AHCszfUiOFoXZQvXWz47cQPhgAtJNQT5z3k79c5p?=
	=?us-ascii?Q?42vAnAqqwdmG/W07Oc4NGxeDDR5r9kkwaFUiUEGe01nXonqcySw+pKlDsMq8?=
	=?us-ascii?Q?s+p0sjEcBAtLyVe7VJA9UZspCiSyeh9HwcOAgX/OvmNFGGCHFoG5qEgup2UP?=
	=?us-ascii?Q?q6PFQbyRMJbJAG1oKXWSzD90C8quOYGk8qrRluL0N0rg8au6nul/O/+RPHF8?=
	=?us-ascii?Q?QYnX6HVk69lw+GD+e0r7J17Y9Xcumgisx3VJhJ0DopmXsne7lOq7afNU8BRi?=
	=?us-ascii?Q?7HfEaxNtMmMtu9mdQ2BvKwtpUMViIVXYWHVwcdIQTyluJ+WHaLiQshTJIXIU?=
	=?us-ascii?Q?US6ucXZw7VXbrzAT7iptzDMxI4n+tpowKAoFfOu8rbgMY6raDQB+GpD8lnfW?=
	=?us-ascii?Q?P0C2/oh6lwjcKBMuQcViN97RC77/xZfjCz5awsaDaBhbHCYMxav3P9E37Ed4?=
	=?us-ascii?Q?yyDvEFryRLsCmKq/zXyESXx0bS0duZF/x5+6QJF1I5E8OtypWbcuLtk7xWnh?=
	=?us-ascii?Q?yGrGm0lAozanuFx9X/uHJri9aKPbM2lPv4qQQV/IBJ+T3WUuPlcAgBZZIybS?=
	=?us-ascii?Q?y5QxRKaC?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d631229-9cb0-48a3-34ed-08d89511215e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 09:20:07.9070 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oCCId/TlCPrFtQtXgAAKu6GD7sV8O1Yxb7MHMs04oekt4TNyHsAgXL7kCnq5SEsna7hLI9cetZxvuL96hmRqCglMCCZFHXUZuI1b/8NNon4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7594
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU9KMuA010188
X-loop: dm-devel@redhat.com
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 11/45] block: remove a superflous check in
	blkpg_do_ioctl
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

