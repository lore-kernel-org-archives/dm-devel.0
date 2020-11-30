Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B2DC64E8A
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 14:49:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 04E2C207FF
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 14:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04E2C207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-Et07yqRcO_25MqnU9x-1cw-1; Mon, 30 Nov 2020 09:49:10 -0500
X-MC-Unique: Et07yqRcO_25MqnU9x-1cw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3347480EDAE;
	Mon, 30 Nov 2020 14:49:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE4EA5C1BB;
	Mon, 30 Nov 2020 14:49:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C48BB4BB7B;
	Mon, 30 Nov 2020 14:49:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUEn10h018836 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 09:49:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5A4B81111A51; Mon, 30 Nov 2020 14:49:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53CB71111A4F
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:48:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE2AF10580C4
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:48:50 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-500-GYckyf_JPIyqwbhtkxHFeg-1; Mon, 30 Nov 2020 09:48:48 -0500
X-MC-Unique: GYckyf_JPIyqwbhtkxHFeg-1
IronPort-SDR: xOd4TISK0xkluetCHDmoXul/qXbd9ci7S++BduhAyfKDZIfV/bULuI5viOlu8xQNbM7m6y1rV/
	g5IOae/WJA7wvxtB5wFfuHBfZYM/1C2fMaiAwJHAl39hvyMjxo34XSRySx+NzayoSZs/3Oc396
	u29ZyyHvF3/eljbybUyBHW+3boRbFhrUqa22woR4FS1xQpeOuMw2C4hJgJQ7N93Fec5FPXu76X
	e9SknR2ij9oPY0uq3aR4wxrCMQ8wWIXynjHBS5wIQ2326EI0lTXQRr+80xZVX8tarM/RjRiFMx
	83w=
X-IronPort-AV: E=Sophos;i="5.78,381,1599494400"; d="scan'208";a="158284639"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
	by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2020 22:48:46 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB3806.namprd04.prod.outlook.com
	(2603:10b6:805:45::11) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25;
	Mon, 30 Nov 2020 14:48:44 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.030;
	Mon, 30 Nov 2020 14:48:44 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 05/45] mtip32xx: remove the call to fsync_bdev on removal
Thread-Index: AQHWxaGxT8+Usa97aEe5UPCvoZEeqQ==
Date: Mon, 30 Nov 2020 14:48:44 +0000
Message-ID: <SN4PR0401MB3598265AEE37FB55D39777059BF50@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-6-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:155d:1001:2c26:fc00:7c60:29b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ee66a8b-a964-4692-8602-08d8953f0970
x-ms-traffictypediagnostic: SN6PR04MB3806:
x-microsoft-antispam-prvs: <SN6PR04MB3806EEA9EB07753AB05433329BF50@SN6PR04MB3806.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YYEnQg9+rRwNqREHJxXJqv0YR8OMwXqdvCNqP0KA8lM3bd2mv8L4UgT7YIWPwsATlsO1RziAGXXGfmMn4LB+ns95+ZmTHdZN3LXt4nEF3v5bTn3jKz3yFYr5ufb0saUsj8IeTrUkltS1NEEMgru2Zn/bOK7pGx6jd3E/1La7wxamgbLP0aoOV0sh9S6ogMlOuIWLgNTF9SK5bJMinSQHTV+fXFkS7chHpr5vsboB5EzRAS3DGgvBhFb7XXkY0mMXP6+PV/K/A8z6LlC2CC0tMCjjJ1Yp3zaOKvTrh9HbAPYv0TG/Kh0hHIWfGPMgOCg0Z0czZRSV2M59eN81jRzCgw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(76116006)(66446008)(186003)(9686003)(66946007)(91956017)(478600001)(4270600006)(86362001)(66476007)(64756008)(8676002)(7696005)(66556008)(558084003)(6506007)(19618925003)(7416002)(71200400001)(316002)(54906003)(4326008)(5660300002)(110136005)(52536014)(8936002)(33656002)(2906002)(55016002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iDV/pu0QM/HGipyCo5NK7O00i73fYHoiviAp96W6No+bNZ2l08ndTrXVuybo?=
	=?us-ascii?Q?4vB4Jh2bA8yK9gXlu2u8q/5RRkSx0nw4fC0Y8CdBwnAdC1qP+g08yd7/W/Fz?=
	=?us-ascii?Q?VdbVs8IRpVCGsvDuNoSsZoV4vrQpm8pUcIsyga9WlIGdpJSYOiZ5XYmYNT1n?=
	=?us-ascii?Q?H0xSSUR8Xud5sB3UX3MeE0dbHcxjo7zPYYG+x9QT9OHXoAm9HE0sBQyZ4x7V?=
	=?us-ascii?Q?kVMcRLK3WgU+tg0y5UhmtNJKwg80wYq9doKTN+9/9hkJGW3ye6sEBb2Prf/t?=
	=?us-ascii?Q?ShOhZWpHxWHs/vzIIGCgbU7wZ3hU+abehy4Wn8fHcBgC5m9rvSBVmNrHNOgv?=
	=?us-ascii?Q?1L+W6Ge0rA8nAyMWbsBYvS4asTH8S12Kw0Pz0i/WCZqnmqop1wHRje7DSTQg?=
	=?us-ascii?Q?UwxYR9yGcoPnqpQiP9aSYGIzvIwf2GGW38cuh6Gcf5RrUEpAqRgdrElt5K/D?=
	=?us-ascii?Q?AQrz6EptBfTzYPUEN1rXXUKh6W1im+krS61em26SsvgPuRH8I3V3PBmeznxi?=
	=?us-ascii?Q?+RexCFQ3rONS/wzzo9LeDJBssHSoKbeJ8oKloCN28LwoQimN3QMg7oQli1Rf?=
	=?us-ascii?Q?khcDYqD27mTY2xs01IQaW6EIVUuMnYf2ppIHTLqTVVBamJQ/j0kflOjOHvC4?=
	=?us-ascii?Q?pvlDFWNEpLMigr6ELMp1mARrdpA90IVUdy8ejE3Pg5AjU2gkz91HWsqgTigJ?=
	=?us-ascii?Q?qQCzskf/tOSUH32Um2APNpoOZt4GHq7iqUvGi9FtqaeApQ0vb/YX4jWXT3xA?=
	=?us-ascii?Q?SUSgEkHbw9wKUKvafjVKoPlfAiIOGgwR9NlEBAsG7sH0zdIi2pWNxXcthmkl?=
	=?us-ascii?Q?5o2JVMnPKkcvWUBZ6f+xHVZpG5yyljpNL0GJ4rArPHr+7DaGO5EGwS9ZOMjs?=
	=?us-ascii?Q?/IIGxq4T9gSjhU7ephl4d0ha3OmtubcTLK5F0/hYt3a2ZZy2kYISL7k47Gf6?=
	=?us-ascii?Q?oGLXYOv5inwZJ51i23BMFG0MHUsYLwQZMrjSQJXW21Q4hkf91RxDT6lh0pQX?=
	=?us-ascii?Q?fSAbUgayRfwkOBwoguzW/IeeihYw39z0FW+Xb20+1ubFNCV6g/eMNfmI0EuR?=
	=?us-ascii?Q?JqS3UQhE?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee66a8b-a964-4692-8602-08d8953f0970
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 14:48:44.5903 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6CiBuFFF80WtmgoR0vxg0tLdYT+qLns7rM73q201cdgGr8C94Rzgi/ledjm6yjpcgSwFtZHu/TDm9JavMXDTieIUI9Es6CJ4iRaM2zDsDok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3806
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AUEn10h018836
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
Subject: Re: [dm-devel] [PATCH 05/45] mtip32xx: remove the call to
	fsync_bdev on removal
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

