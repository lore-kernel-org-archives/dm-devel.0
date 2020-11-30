Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF97C64E8A
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 15:01:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 735FE206D8
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 15:01:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 735FE206D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-s5dAF8nCNtCtGRdFastg6g-1; Mon, 30 Nov 2020 10:01:04 -0500
X-MC-Unique: s5dAF8nCNtCtGRdFastg6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA2DB10A0BA8;
	Mon, 30 Nov 2020 15:01:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 966C160C62;
	Mon, 30 Nov 2020 15:01:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE0D15002C;
	Mon, 30 Nov 2020 14:53:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUEriPQ019202 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 09:53:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4F8052166B2B; Mon, 30 Nov 2020 14:53:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4957C2166B2D
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:53:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2A99802A5D
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:53:41 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-255-M7tJDmWtPuGeQqeaRFtulA-1; Mon, 30 Nov 2020 09:53:38 -0500
X-MC-Unique: M7tJDmWtPuGeQqeaRFtulA-1
IronPort-SDR: FnHzlgx2YoQZHs8ddqBxeUk7QRvOTn00f2y3oWw8CIZfcnlgna2xWlY5cfl/Kn8K2fkm9F2Mne
	cJ342k2ooYe2D9XRAuye0RJRxfdm9mmZ4BgeOLxFMwe2Sc2tRBeAo0qcDFv3hEgmIIPYhFKN8C
	43iI2d+kjEZm0FaKF5N9wDdgL795AlNFIHHwltqkP5HIWpH4L7gzxFyIB2Fs3ZjZyq4DerViBU
	BHrv7MueD3/5GGBthYq0SfxbxqcZ2WhFPxQym9Q5pgs4WM00r5suRY8qc/UrOiwfoZFp2YvhyN
	Ogo=
X-IronPort-AV: E=Sophos;i="5.78,381,1599494400"; d="scan'208";a="155018471"
Received: from mail-sn1nam04lp2059.outbound.protection.outlook.com (HELO
	NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.59])
	by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2020 22:52:34 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4927.namprd04.prod.outlook.com
	(2603:10b6:805:93::26) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25;
	Mon, 30 Nov 2020 14:52:30 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.030;
	Mon, 30 Nov 2020 14:52:30 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 16/45] block: switch bdgrab to use igrab
Thread-Index: AQHWxaG7mCeKo37kOkm/uk6ftU/pPA==
Date: Mon, 30 Nov 2020 14:52:30 +0000
Message-ID: <SN4PR0401MB35984402FF62259631F178A09BF50@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-17-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:155d:1001:2c26:fc00:7c60:29b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 669144bf-890b-4421-c399-08d8953f901f
x-ms-traffictypediagnostic: SN6PR04MB4927:
x-microsoft-antispam-prvs: <SN6PR04MB4927E44374573975A0CB3FC89BF50@SN6PR04MB4927.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ofyRCdhfnZWlX3fZSfsHkfvfeLrxaRoVaVTYTvg3WsmHhLF/vHoS3Q1Xk4RvUDYq3yq11f5850vA0SWIbF8OJyDl3pXqcbc77cBOODA0bxhCtCVX6+WPam9hDB+1k47Y4DLS0BAitdaHPT3aNoCl7hkzLnjzc+MnM9/4VPZWxJvLGbUI2H/bMDcttJnOiAR2FIxFFGrYgtkQESgLFuilE03zN1c6YtBShsSzJQJnrfhj7PiYNPZD5BR368u11o99eeMPPayhc0dp97ysPbZyzzQ4tz64/nAU9mEF9/tAeR6XnCnhFcAwJFqss8y+L2themWYmSR8Fux1uuOj756mmw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(4270600006)(8676002)(2906002)(4326008)(5660300002)(6506007)(558084003)(8936002)(186003)(76116006)(86362001)(91956017)(55016002)(33656002)(9686003)(7696005)(52536014)(19618925003)(66556008)(64756008)(66946007)(54906003)(71200400001)(316002)(110136005)(66446008)(478600001)(66476007)(7416002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?y2DzVk9PF4LHvHeFuTJBnxcd96WXbu0Uzab+SjAlkrHx1h7flDepdFB5AMaK?=
	=?us-ascii?Q?VFUCk5ZwSipScRyNkDffYfQ/34dsWmkYzfEiqBfdkhmRT4+HtH8wLXFtfH6U?=
	=?us-ascii?Q?mm1/4i23xhFvXv07sJDp59MpkSd3uiUUgGgJlEh7W5SYRhq0PMC1GSSeIiQb?=
	=?us-ascii?Q?waqDFfKx8cUD6KPonzG+ULY8b27RiPwLbg/G7rSzbxQIeVBtV3LNhsf0Ni8s?=
	=?us-ascii?Q?rBJl3AH7fNpPKT9XRJ9ynTUslivf+cK4m56xH0zo/FxGQ47pzSXCdNGElXK1?=
	=?us-ascii?Q?u2DAa8YKIFT2lWXyOXl4SGSuoZ5S+ZMeHBMQtJtbUtEA/ojDAGhQDrsQTxAN?=
	=?us-ascii?Q?BOTT2eOF4fA9+FdKbAVKWu1WPbPzDUyL2MJgcMsv6STWbybkT73mGtutrBR3?=
	=?us-ascii?Q?4OvM5RxRqkiIpP7c7ufU7Kvl3TrCSsb+0pPo3o681JrGQchpnNC6iozXzowE?=
	=?us-ascii?Q?9NxnlpdHPaNPxEWs4ojTAU6lNjux28U7K0GLv8SvLow3sGMpmxiHXbBI/sgI?=
	=?us-ascii?Q?pl30gdhXO/9UAJLk+bIkzdGJwFrhHt27AItAmYSJJL//R8MX+ilpGAKcMGIR?=
	=?us-ascii?Q?FfI3GgyvGgxzJZ06yDjA/8epfUNtq0ZiIsGGiYSeVzJNL++XIM3zkTIM+zLq?=
	=?us-ascii?Q?7kbU53RSN6cRMVc4kKivy4qJaXkuX5uCU3NTT+gI0XwaxEiAAlbmY2+61ukE?=
	=?us-ascii?Q?I57Ea2HXYCPRE2YvcZTTHK0tNIzba7T1s7ge/bar0qqWqHzcMqzropiQC5rj?=
	=?us-ascii?Q?V3+WthI6MHNZFdMdnuexhbdGnCpMCM2mOYD/lU/p+F7ktV+IM6zYOBHwaZEk?=
	=?us-ascii?Q?uIDasbzchVZTx+hxXm+CHsHXYfhJOj1rBVocjjBkzmpCO9dRmLBwNIYrGIuk?=
	=?us-ascii?Q?MAuPpHxc55lmnKoyrArglPiIXk0VNf30DT7rj3s2FIi+a3+u0I5k+cwq5BzG?=
	=?us-ascii?Q?sh/KqM50N7INgJnGmDbfdCmwl19H1gj4ghI0qKaiLs7hwyhqU/yTNwp9uqkY?=
	=?us-ascii?Q?4vOds73o0tHx4Vh2g5HhurjIKb07trejk9OyAo0cJtFRhFswH69aFmZG7IPR?=
	=?us-ascii?Q?bOFIFnTB?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669144bf-890b-4421-c399-08d8953f901f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 14:52:30.5774 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vBCTSjwnFG0YCjVi+xMBBfMlLOrnn+Bc4HWWQ4nL7n0gLLjDpaYZl+xEtTsKglrJ2pIelydu6/P0vAuVaEyolqSdx27yF01EEM2M7ErckrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4927
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AUEriPQ019202
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
Subject: Re: [dm-devel] [PATCH 16/45] block: switch bdgrab to use igrab
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

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

