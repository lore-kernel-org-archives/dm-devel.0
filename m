Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74460C56201
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:40:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B8D56246D1
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:40:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8D56246D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-JzfftrKuOUWZWbgNw0YqOg-1; Thu, 19 Nov 2020 03:40:21 -0500
X-MC-Unique: JzfftrKuOUWZWbgNw0YqOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6440364083;
	Thu, 19 Nov 2020 08:40:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C69F35C221;
	Thu, 19 Nov 2020 08:40:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 961ED180954D;
	Thu, 19 Nov 2020 08:40:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ8eEgA016696 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 03:40:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 856CDC77C6; Thu, 19 Nov 2020 08:40:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DEAF8A4C2
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:40:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 914E3101A540
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:40:09 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-231-hgnfVIUANUK7dCOzr4kGdA-1; Thu, 19 Nov 2020 03:40:05 -0500
X-MC-Unique: hgnfVIUANUK7dCOzr4kGdA-1
IronPort-SDR: zh+Lhm4c30+A6tWFjBpJqqqvKXTtmLx/uJxb+Ey5pvk2XxNNdYhISVqynLPPLKekz+HqTu/i0N
	MBrZjlJKSXBsEm90b6+ege7WWcorjsTazp/tDTMlbHOdT3Afcd72/ADGryrhPx8Yp0Tez7QBvQ
	tJlpo5W/KpnUlQr/tfe9MPfmQS2uGznEdG99qLX9DT5RP27jMufJlsZu/CXVM9/7yupYnWPC0A
	/DtOKou0OTjtZ0+ljAW2xXukli+KF+T2Pu2eeDFE+tXFJyXimYQmCcv3VQimYs5bQMCHI7IegW
	dps=
X-IronPort-AV: E=Sophos;i="5.77,490,1596470400"; d="scan'208";a="256563159"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
	by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2020 16:46:07 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4862.namprd04.prod.outlook.com
	(2603:10b6:805:90::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22;
	Thu, 19 Nov 2020 08:37:58 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.022;
	Thu, 19 Nov 2020 08:37:58 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 04/20] block: use disk_part_iter_exit in
	disk_part_iter_next
Thread-Index: AQHWvYfxuab2eSi9v0+4Jul0cvRVrw==
Date: Thu, 19 Nov 2020 08:37:58 +0000
Message-ID: <SN4PR0401MB3598E8CCC6C453F977898B9B9BE00@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-5-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:157d:bf01:851e:5636:4e29:3e2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dc2f26b1-8a58-4df2-8db1-08d88c666af0
x-ms-traffictypediagnostic: SN6PR04MB4862:
x-microsoft-antispam-prvs: <SN6PR04MB48621A61F4471E2E89E82EF59BE00@SN6PR04MB4862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uM2A3PDmoKphIU4Fc16ogOp1M1rJ9+SLzvD0ZJkt68L/IbRqSIUJqleWl+jCNt8TGI7ZmCpjwSocgOZV5VkS2EMgz/nmv23hcIJhfdraCKUxH+nxb4ms0G8rm7HM+j3Vfro/l2b5oLe/IkFNCzBzjAMfxAUFmF82G7eV5I8T81ZfueCoS4SRCg/mHOZYIeqFhWdBjg7VaU05to+VFT5LaghV+Rjpy10mfkuvQk+lTiIXynjQ28WY52i0wiKk6EZz8L2MWpDs4bZYI+USuWxmYmjQLQgm8i0XSpl/k6axg7m8BdY+MPDgRmw+nBfqGZs/cInTtjx338CMyw1UEwzIwA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(8936002)(71200400001)(19618925003)(4326008)(33656002)(7416002)(9686003)(55016002)(66946007)(76116006)(478600001)(66476007)(66446008)(64756008)(86362001)(54906003)(66556008)(91956017)(52536014)(558084003)(2906002)(186003)(8676002)(4270600006)(7696005)(316002)(6506007)(110136005)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: IQWuh4ntmvjG/gqSF5MJQgN08Z6bkNozQweAEIGm/1mQo5R9TCC3cBtseCzb3QmJGQUiE1o54sobNLwSAWX/6oYmKaYDSH7cSH/q3MRUBXK1zMR9M6v1o9qf7W2zYWLcRaubUP88D5MNNVd33oqUf57ice3N/gDvDPltYue/PewJ5xrlecE7FjFNdOsTGym46YNDFl8vhZODWw1vcOKu/eyKQdw6/eCxq6Mapoj6V1w+fkEmMxFMwJA6vwbltHsKO3O6dQdrDEyC02kihOx77Q++4J58jatC3poVI/GqDeje3MjPGwoMGqAVxSVday3r2IpTUIBvunpWHM/D5tcZBtzLR/x6trX7T3UyDzXA7ZcY5PpI/x8Nr5PYK6rmiPggyNBZyPofbe/gLOus8r2qEu1wT8GtpjruCMicI72uiUhRwBIdMzCB23r/N1mHyPdjjTBJfnpXOgWBjhJkPK5aBWyE5cOalePDkgSLqUwDJEJhnEr3CAN+K4P2j1ENBGpdUk2SyQ1PpkgPMkauNbv5fW/IFg8f3HIi56U1o6lpIZTkaV4jXGwhQyLNuSstSjwwkkt5gRjilo+jOskqL45r0nYQy+rtt37OJLx1QNj2yYzp9Qp/uylqrH2drYzLR6OTofT98heAoAyjRO+VAVG5RN2/TFIwQOavTtr3udCtTYLoys/rz1plvkWksJHLNmTXMYVXlh8rU59KUiizMBADxQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2f26b1-8a58-4df2-8db1-08d88c666af0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 08:37:58.0568 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbgWyuKmpIgY3doUcSCJcrP096yLZcBzyRT5z9TiavwjsyTmsIh3cD8YMX5Ad0CTeluy+4pfJXdZTUvG83+xcAFmk9bYEROGcdWgsdhRth0=
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AJ8eEgA016696
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
Subject: Re: [dm-devel] [PATCH 04/20] block: use disk_part_iter_exit in
 disk_part_iter_next
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

