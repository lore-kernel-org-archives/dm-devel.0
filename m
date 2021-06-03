Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A0AC4708F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:09:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F85C613BF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:09:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F85C613BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-AVjXDdr4OVix9bS13MuZ2w-1; Wed, 02 Jun 2021 20:09:35 -0400
X-MC-Unique: AVjXDdr4OVix9bS13MuZ2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 449558049CA;
	Thu,  3 Jun 2021 00:09:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28A4B19C97;
	Thu,  3 Jun 2021 00:09:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 975BD18095C4;
	Thu,  3 Jun 2021 00:09:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 153062VP011275 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 20:06:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D6B98209A501; Thu,  3 Jun 2021 00:06:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1976209A505
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:05:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DA81802A5E
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:05:59 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-11-66u_q0xZMISsAvfDcetzUg-1; Wed, 02 Jun 2021 20:05:57 -0400
X-MC-Unique: 66u_q0xZMISsAvfDcetzUg-1
IronPort-SDR: yNidBVFfwP0++LZUETizwUBWEU+SN5FJSRje8d9L3HA9a4QVTuJ3JBJOnr3MIi9gFTJe/8eecu
	HStTZQKFFUCbQwS4FUr96K24Njy6EXoKXzzXdWil6RMp1mlvcZyH5L6EDrJGcuEI01DwcwTsMT
	pRAfIqTK9lzGNov0fGAd7mAjRIWGxXGtRygQBcLpHsPQyNrNh8eAPm4B6p63N0/Pve4ZLw44Aj
	5F+OH4wmt0QavYeTsh/8Wr2SfC0JwqhvrqLnTzBDcRmyBvK+vFVgn0C8tK5FZvqYFuYnCi5Zm1
	nbw=
X-IronPort-AV: E=Sophos;i="5.83,244,1616428800"; d="scan'208";a="175227080"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
	by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2021 08:05:49 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB5333.namprd04.prod.outlook.com (2603:10b6:a03:c2::27)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22;
	Thu, 3 Jun 2021 00:05:45 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4173.034;
	Thu, 3 Jun 2021 00:05:45 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 18/30] loop: use blk_mq_alloc_disk and blk_cleanup_disk
Thread-Index: AQHXV3xaE0d6OBaU4E62oTiV05BSaQ==
Date: Thu, 3 Jun 2021 00:05:45 +0000
Message-ID: <BYAPR04MB49659E527FE3E41660BF8589863C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210602065345.355274-1-hch@lst.de>
	<20210602065345.355274-19-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39591f5b-3ff9-4e4f-1e41-08d9262355df
x-ms-traffictypediagnostic: BYAPR04MB5333:
x-microsoft-antispam-prvs: <BYAPR04MB5333C6D28F1EA2185F1A07B4863C9@BYAPR04MB5333.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:949
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PgVZpMqfBZsayGo6qHKvJ/SMB0aIT/hImnkZMDwIUFSs6fwOxe2azCZGsLYYbvBVkWrtWNrUFQJJzeMe3yYffc8YIVjA4vJhqd1Caf+JQrgRrW8iANW1Fa/HwaSNBqVMprKX3CCOr3cy1gDErClF4rDG2tsRuQIz2DZ3wl4lpipsRdWqfqfDlvSHTzPfY8HoDivgfEAPOqwhWAHjZq+glqlqQNx5ZuMHtvR23EDC4vpH/CigaR+TRxEQ1bhZnCzeXwSFOfClGAgqWJfg/YHx/QfV8bngLaMNrTL2snvIV7C4DvRbbyIzJWr1cYbirk42HHX09WrOtimpQWxEpl3MisB8trOfqX2JC4rdBvIjkUaD0Gu3Vd4tNq18VIg+f9BmBccbQ2EtncSTV4CHGdMbjwxBRIamRH6tg8R50QDEz0qRt2ydIbwr9cXW2KR46pgExiN/N5aOQNkcSCw02up2UrfqPreq+/AlBpqOOFH0QCZjF3KTAPdUTp8qjmEkDht0hhnuAIkkoYSevA85lQXGgxc8PooKuHlGX+GrZERL5amiEUT9pgFbBzsgSZjY3DhUCUiugbACiQpYZej9ts05kLxaCUEKkshvgopZWtO9nZk=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(52536014)(8936002)(55016002)(9686003)(8676002)(478600001)(110136005)(54906003)(83380400001)(76116006)(66476007)(2906002)(64756008)(66946007)(38100700002)(122000001)(5660300002)(66556008)(66446008)(71200400001)(26005)(4326008)(53546011)(86362001)(186003)(7696005)(6506007)(33656002)(7406005)(7416002)(558084003)(316002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?5if6RR5+OJsZpshEstylBHTMiQTdBTwGqtBjzZ62XGcAt8S+WMU1R6WAr1?=
	=?iso-8859-1?Q?a51eNNNlEJ+VJlKHkoSqcgo2gIBhqaOpnahoP2sexcbCNSfIQ/mT23Hhrc?=
	=?iso-8859-1?Q?CcZvGJdjc6rYcwPcGxufFVIXA4VuS9ph3bVkXwT1KWFzecVa9v7sRZjstV?=
	=?iso-8859-1?Q?M52hDeZD+OF2CXi5MCN0ahoxnPtEEWQo3uJ627FGCuiWRxi9hBI4zHAyQD?=
	=?iso-8859-1?Q?n4L880UPigYemTZh2skZ2GRBM3EuXNgIf5eMrwx4/9GRA3thA3Vs6/Srr5?=
	=?iso-8859-1?Q?mGAI4xuVrUjS5kqBdndpNixJAX1SDSM/c5pjrP6MwNVZHaAJQaWiqd/HSt?=
	=?iso-8859-1?Q?qjXLVs9eg3uXezDIMZbbFb3XlhgYLwr4Kg+u+oojFoO86BfCoFfj1SZaLK?=
	=?iso-8859-1?Q?3Bh6HvFLoxKb6fnftF5GncLxb2klSGgVkwEBvxlUdRyF5hLfy0GDhWEiwn?=
	=?iso-8859-1?Q?yvPwGUF1+TCCnVDjIV4TQiM/anB4IJYj7Pz6AgJfWV68HWhWQrmXTYHpFh?=
	=?iso-8859-1?Q?CcLN8OXPeqiXrlUWuJSE+dkeXO0N/nWPs0Ztuv7AkzgDScv3MyeGOeHz3Z?=
	=?iso-8859-1?Q?Ao7F5TJClVo4s6Ru7csKZuy6fY4JU8hhN96B8/sDqt2aBqhr72Hc2stfoq?=
	=?iso-8859-1?Q?cWadzIwd6WVVg+F9M77H9ekG9yiSizSPk2biwRViJxMsn4pztStuwmqKi1?=
	=?iso-8859-1?Q?t83Qs/txRM7vkASOivFSKQe302k3TlOukOSYea41yEa1Pz3i6oIZnZefgv?=
	=?iso-8859-1?Q?NSQw9pYu9oSKGJ25XiFKSTq/j7vSbzks171YHmv9mcMt6wP8yl4LLXxCen?=
	=?iso-8859-1?Q?JXD+BD+GKbVnjs7pZSk99T99q+VCUnMr02tJUq6IfIA+Cq6AX93Q0L3v0A?=
	=?iso-8859-1?Q?qDn95YKDo18n5brnbC8adwYqFb9BWS7i9plCtUA5iAEgQG7cWDB/J/zCCE?=
	=?iso-8859-1?Q?6bE/YfhBuXNi264x616FmYWOFFz2gRTXVHBrqOmgFcjq+xeiwfUiLM3iIc?=
	=?iso-8859-1?Q?vQ1xF8dWT4I98ziJWB64LXJLu3oqZn592OlCv+12XP7AcL+hRIAMmaOLMh?=
	=?iso-8859-1?Q?+DjXC7TFUoHipM+C9D1rO1BB4cTG/35uwiag5HrH7/d45WzZmSsapFV0/+?=
	=?iso-8859-1?Q?eJTfrX8aYrolI4CV0AKZjhKyK1qJrHy2Iy3J4immKeUbAWIyN75+vD6817?=
	=?iso-8859-1?Q?SqCiq4gw9a0EywODdNX5I5vEzTROvlrHITNzRWZn3S0uJZceVLoeMQyUCr?=
	=?iso-8859-1?Q?1vuXs9xwNnyBoHWVfCBl3SNUv4bBHzezF7+hWC4DnOm+Vdn6CRvP+5sOy8?=
	=?iso-8859-1?Q?lJJ8x7HTy3feCkYVRWQwWhhN2a0eI7ohaqFaqoodESTjPUs1PcbecmVk6E?=
	=?iso-8859-1?Q?yOGxfM+lRI?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39591f5b-3ff9-4e4f-1e41-08d9262355df
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 00:05:45.3613 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UZUf1SLT6UbGI1jPGaANmbjvJ+IN4ZVHUWumZOErHa4bTyMMnyBgRVRLyXW59SgP4r+36OBdgMCcwGD5GqSUCjl5bim8WN/7KVvAoUqr5pk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5333
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 153062VP011275
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S.
	Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Geoff, Konrad, "Md. Haris
	Iqbal" <haris.iqbal@ionos.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	Ilya Dryomov <idryomov@gmail.com>, Gorbik <gor@linux.ibm.com>,
	Alex Dubov <oakad@yahoo.com>, Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>,
	"nbd@other.debian.org" <nbd@other.debian.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Vasily,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	Levand <geoff@infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Vignesh,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	=?iso-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 18/30] loop: use blk_mq_alloc_disk and
	blk_cleanup_disk
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

On 6/1/21 23:56, Christoph Hellwig wrote:
> Use blk_mq_alloc_disk and blk_cleanup_disk to simplify the gendisk and
> request_queue allocation.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>






--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

