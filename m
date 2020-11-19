Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65147C388F9
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:39:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A0A7B246D1
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0A7B246D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-zmJfUcdKMVq0dPyvw0XIQA-1; Thu, 19 Nov 2020 03:39:04 -0500
X-MC-Unique: zmJfUcdKMVq0dPyvw0XIQA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88CBF80EF9C;
	Thu, 19 Nov 2020 08:39:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6675A60BD8;
	Thu, 19 Nov 2020 08:39:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A4CC86C09;
	Thu, 19 Nov 2020 08:39:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ8cwiP016377 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 03:38:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8D0202063FE3; Thu, 19 Nov 2020 08:38:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83CA0206400D
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:38:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D019811E86
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:38:56 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-336-S6_UXLobOzKbvCIYHuPr3A-1; Thu, 19 Nov 2020 03:38:54 -0500
X-MC-Unique: S6_UXLobOzKbvCIYHuPr3A-1
IronPort-SDR: lVYgGj8s/O/AthUUtd8BLwr48Cp2/3Lts7OWFY8l46ecxGJgwGyTEv4SznvpWtoFXPDUmLq46S
	PKl5jTXr2yroQGCOoXR6GLg4IOuQiedGR7+8g2V0WPxkgoq3eA1YN5yrT/U9K/rctJ6WFRYtBp
	9HztdHo8FdhKqxpwXBk6Xg8h2iCjq6rhP0ekHhBdnbb7S7xjZR7U0qyVoAKGSgZk6pZC+Gnowr
	CSs2a4VuTwxteh6JjwZoA7HQJbsmboE1nAUyvDzzgs827uEa+OtkN9Vn/JyuVYzlqP4Q1sXIEO
	ShA=
X-IronPort-AV: E=Sophos;i="5.77,490,1596470400"; d="scan'208";a="157444431"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
	by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2020 16:37:48 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4862.namprd04.prod.outlook.com
	(2603:10b6:805:90::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22;
	Thu, 19 Nov 2020 08:37:47 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.022;
	Thu, 19 Nov 2020 08:37:47 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 03/20] block: add a bdev_kobj helper
Thread-Index: AQHWvYgpPQQYaHo5cUCzCzUTvKQePw==
Date: Thu, 19 Nov 2020 08:37:47 +0000
Message-ID: <SN4PR0401MB3598F34DA0C62243AE70450F9BE00@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:157d:bf01:851e:5636:4e29:3e2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ee06524-e692-40f5-4335-08d88c6664ce
x-ms-traffictypediagnostic: SN6PR04MB4862:
x-microsoft-antispam-prvs: <SN6PR04MB4862C03F8508DDA87FBC44E39BE00@SN6PR04MB4862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cM6Zu8k0lk01FkTpo0twM3+ihg0ZM0fWiBNV2YgNEq57IjliedsG4hdFNcEeWr7gyHPkC8wcmnKwmo6B3s8tfpyVYHRb369EZu5lJp8WgHdKOrCDl8dYh+AoDVZOyHBJAApMKIwuC7ziO+80CWeJMYgP/KjPjWAAmmvtPZpr5T0vHcJ61OqTTQqpm/dAMMvfYKFKyVVrdU6RDU7QvDYf4966kTRcn2fjQAK/lEl83mzI9rCinyGP+fV6M6X1MZDvlQl1fBMPaZYSTHITNHBlN5eH3SpuuTOwrySY8c311ZVBL9e28Qbhi10GesUwg4oIYwFlt3n7YhgV7z/c6qgjQA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(8936002)(71200400001)(19618925003)(4326008)(33656002)(7416002)(9686003)(55016002)(66946007)(76116006)(478600001)(66476007)(66446008)(64756008)(86362001)(54906003)(66556008)(91956017)(52536014)(558084003)(2906002)(186003)(8676002)(4270600006)(7696005)(316002)(6506007)(110136005)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: MPTcc0vfLSyiAnTcb7e0ZxYCdd6X03PO+hkR4w17tnb1Hno0kQos4K2mXREGZgLW8ratrL8B7Yc0xKuz7b23avFfKFDWdAJZ0unQKNigvjqNfnlg52/l4vaB8VnQZB3bpxteL0XUwl5NiaDQSk18o+OUjU6RZIyFhczuuhvrHmiKMZyfEnE8pTXBOd+/9pmy9yKTzOl/EY3xuD3FdC+yKpHGqoQeKme4gD8v1ge8V9vYMQPLRQN4SQUoDaP0Vhgal4WsQ11lCXcin1Sgb/kzAOo6HfpEaNbxuyWxQRqCcOrSZPHv5iOftO9p1YtRY2wXtOWa1sA0KDa+0NgPNmtRLl7gp31EOqfqtNqNh6Ji75jeIcd8MNht16s0FlwCAxlS2P8ZifB1ZytH8GPK1oLJUuBHcDST5AFPfxNo41bS07GjTHsegEcVM/GpeqePqTEK25jhlPUX/8ihe+88T/wAtAe8dOwDwVwq3Ninb1XiaK4VoJrXQAY8ejc4zmH3i83S23c1Fzv9HnNe4uR6JJMG8X6/ACG+ofnt/1lGR8TWaNqhuE4Gi7IGxuzaNvNEg8jY0uvKRJBl9Dda3h/Tvg9GBd7a8Wd5g1EN03Czd4mU+OGBFfY63oZR25JElYnN6XzREmBQGQmrYNBD0aZqccL0wwTasGf4sNjm8alHdyyRXA/Cs8mp3uYnhFcU+sEq2shb/XRcDIJn+LkN+wlrb9jGvw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee06524-e692-40f5-4335-08d88c6664ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 08:37:47.7068 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FtL10fHlsqtF9VKWClE12kvG/4VucNbBlCk7eB3jP86NM/MVKoi5xzwEvgHccVAHfo1Z5D+XGYZM8Ev0yG9YEwoLHBffgmsp1L9OHKub5+c=
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AJ8cwiP016377
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
Subject: Re: [dm-devel] [PATCH 03/20] block: add a bdev_kobj helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

