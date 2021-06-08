Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D554C47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:25:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DEA0F61380
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:25:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEA0F61380
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-64WX38u5M6-V6Z2S14fqUQ-1; Tue, 08 Jun 2021 14:25:13 -0400
X-MC-Unique: 64WX38u5M6-V6Z2S14fqUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F5F2107ACC7;
	Tue,  8 Jun 2021 18:25:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E51D91899A;
	Tue,  8 Jun 2021 18:25:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AF9851800BB4;
	Tue,  8 Jun 2021 18:25:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158IP6Em032141 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 14:25:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E17D200E66E; Tue,  8 Jun 2021 18:25:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 021E5200FA68
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:24:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A070280D0E1
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:24:57 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-264-9MFlpIXROt-0_e7CoNc73Q-1; Tue, 08 Jun 2021 14:24:52 -0400
X-MC-Unique: 9MFlpIXROt-0_e7CoNc73Q-1
IronPort-SDR: v1JV5LizWRZGBl2sJR3HB2h/j6FrT35BFvpCMYIHkAdDJ7DxJJx1MpCPTZDrefQady178WoOU1
	e4t2FEmcw3elDmn6BBwCL/MAz/NggtiwN0twsWB6xbrXocuLXyPT73RRUE4hoTRJ67DG2f5wTL
	bhuXm15GobNxImLJFT5rjjG+zEZyE2KWnYVFPsv8By4507TzgwwhWR76ilSmNh9rMt3IrUl1eB
	eNO2u5xfjhgHVac12lqort/zA/HJBnseZYaqQfxJY9yR6zNYie3R6FGHCe3DctX3RCbHEhWCoT
	2hY=
X-IronPort-AV: E=Sophos;i="5.83,259,1616428800"; d="scan'208";a="170470222"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
	by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2021 02:24:49 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM5PR04MB0299.namprd04.prod.outlook.com (2603:10b6:3:70::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4195.23; Tue, 8 Jun 2021 18:24:47 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f%7]) with mapi id 15.20.4195.030;
	Tue, 8 Jun 2021 18:24:47 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH 12/16] block: use memcpy_to_bvec in copy_to_high_bio_irq
Thread-Index: AQHXXIB9t5FIM8uwxUadNIOUcakDaQ==
Date: Tue, 8 Jun 2021 18:24:47 +0000
Message-ID: <DM6PR04MB497278CD0294B519C995A2DE86379@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-13-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e10918a-570f-466f-48da-08d92aaab28b
x-ms-traffictypediagnostic: DM5PR04MB0299:
x-microsoft-antispam-prvs: <DM5PR04MB0299B0BDB367B89B488349A386379@DM5PR04MB0299.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1051
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EvoO7hDVWlHWufXNdX6flaSi2IMFe1LgLIG15X2VwuETZ9JOzJySGmbpi6qM51yY3MDukChEcfjtxBSAyGOiAprQjWw6ANAUudpZNzyyji5L2QhNZppJxTgbDaX+LhPsxNgwyR4pDWCvsoWPEjJRUYAE9rcU/DgltYw8jaLZx5cnnhibOfK1Fc7yKlzs/F3zwtFIGz4Ipp+xkjx/J+bguumgf5uCV8E6XuNxomVY7wwLCgBL14V3duDv7iT+cr8hLyKTYRn7TFQyZvH+XangRqhOutye6YHRSrv6cjGgUZOTSmb4YllZLfVRujI+uPQUXAyUxZC5/a2rrkWAxpqKcyF3P+bhUXhdWu1PV1vW19sy3w2LSoBiijmuWJbetWf1eYn5Rx/uLxGHjGwmrsRU7XT7sznMutg7NAJHBSqizSF15q5a4aFeUAvgGnpcvxyGc5xWrf5f5VSxRJ3mQWSLs2M2TDQYfZe4vpg0YgvqmTqncxnKEe7RLVVSrcJqVmEcqVAhdKzR+pBcboA02FWSNuNx/UOd76T5zPQD+xPdiJ5GqTlI4t0HXdg/30jtnTBtqMYPvBgmy9kXyWR5mzyjmu76pilfoLvy1917DZjmaP4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(9686003)(54906003)(55016002)(86362001)(558084003)(71200400001)(7696005)(2906002)(186003)(6916009)(52536014)(478600001)(33656002)(4326008)(66446008)(66476007)(53546011)(91956017)(76116006)(8936002)(66946007)(6506007)(26005)(8676002)(38100700002)(5660300002)(316002)(7416002)(122000001)(64756008)(66556008);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w06D9yw/kDDV2M1fKtQK8wYfGlK6THH1PyWf5eCUwlq9tTUlKFMZfshmt5++?=
	=?us-ascii?Q?E4Ju/utQpQlTy6rKNNsXJK3wWAEbSHze98PDXVwC4UrazOvTCCAUK8JLVU0Y?=
	=?us-ascii?Q?hV08VIeww+1Tkyrw+JB4qpG4lQqtVXKIHRikw3Krws2YRJpLG1BedHc0Tghi?=
	=?us-ascii?Q?2pdetK8uPAB1hgJkj8Jrmv1JEi2PJiN8bW9wmu9O8NBebgq1u7tFqatV6EAQ?=
	=?us-ascii?Q?DlZ3AMdHgk9/Yd+yinR/6qNTkeUBLElXdxG3sotGpBkV2aAlJxrSykB/VOpy?=
	=?us-ascii?Q?CioqhuWOgi32jbenywzGa9/pJJhYnj/zGOMlFBoSoD9px4C11SAaP2fM4YX/?=
	=?us-ascii?Q?mbABra28U5PYVCrQKUn9Hjce1PHxpUsc5v1iF/jEUcGsbOJs6wB0A9QlV/TZ?=
	=?us-ascii?Q?I30czyw3FWbzLm05cybUGDEUlB8JWtOsKZaGvX3kk5ck2G5ue/oFLKAoCqsf?=
	=?us-ascii?Q?AY4+hHJWRljA3yLcyqM1cvH3TmFdBZXzJxpaxl8nJ82G98VDrII1i5eB63F4?=
	=?us-ascii?Q?rDzCsMvALNNH+nynFQxnHVOWXZNc7B2bamGnfdeu7ux1ECr6EuDrboI/09i/?=
	=?us-ascii?Q?IAtXQonIefthnkl7qO8Ba/vrBD7zmrkyUrNn2RuUCBkhIQvtIDawPUGIlFQK?=
	=?us-ascii?Q?YMD4VLLVA3vfPHvbO5tLJzyZWCIvtilEqiC6RGYphCCfSalKrRWJXPUyznPa?=
	=?us-ascii?Q?3xqMQPjORyNeJuI95hg6GzZA6O8eSAHAi8CMccDhHp8zsLRa0FihYaZxpCX6?=
	=?us-ascii?Q?PkUMTc4K2WrB1IGlssuRxrUnAZsuCNuM820CBWuSEvOjBtIQNjSYrENCsLPs?=
	=?us-ascii?Q?dEQrCLiVhVdts15FewBo/5TM2fVctnJBiFkm+gZGKcDymVtXNFetSHSVai9O?=
	=?us-ascii?Q?oUcw5mQ9pXpy5ec7CnKEbPlLprePhlDrkASfzxosc7I7bLgMp2+LkvD+tu7B?=
	=?us-ascii?Q?yX6fLYaC/CWAE40ETMg48e5Ry4pelJyWdvM4S/+d/5ucFQ4evpVdlJQpkc9K?=
	=?us-ascii?Q?BIXMrImTnrz55wWcb5pPJQx40DIUdfN2OYgzQI2/svpEPSZOSTmIjVOWZsGH?=
	=?us-ascii?Q?/yiEVBxm7yzgemMWKbozEbp4trsS/ca/Rhh0cAtVyoA/8L42Dib2vwLoCyld?=
	=?us-ascii?Q?yxCuIIax+aLgqIBTmKvZVL0zX9bonCfguDfkL6mBlcRU6JcSoPFlXxU98ekJ?=
	=?us-ascii?Q?1CjKLVARLG3utNG1tg0uu/ahp3KYzEyh7MhxMbyfuKZlKfjkis7EImQo5N/N?=
	=?us-ascii?Q?6dc6n1wRGEeSVmmfwO1dAjqKjCwrBs4lQglPPw1b/EC/DaYHNclGEg0S1wM7?=
	=?us-ascii?Q?y7g9zyIRAOi+j2Xc2QX8MccF?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e10918a-570f-466f-48da-08d92aaab28b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 18:24:47.6356 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PHbSwkQn49DyXDiDK2ZUT21u806ZErMLUuismuWrRg6Jog+OY7+ydIsqlYOq6hdCUUzgNvSQlcPvkT9Lu6XefQLAOMD+ADv1EVMO5rXT2IM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0299
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 158IP6Em032141
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Ira Weiny <ira.weiny@intel.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 12/16] block: use memcpy_to_bvec in
	copy_to_high_bio_irq
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

On 6/8/21 09:08, Christoph Hellwig wrote:
> Use memcpy_to_bvec instead of opencoding the logic.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

