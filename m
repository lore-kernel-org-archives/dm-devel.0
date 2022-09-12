Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4735ECAAA1
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662977073;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=ZPdpzF433/4c4Hm/snGdKQKZj/JcFQX/XG1M3Wr2lzcRm4JMdf7ENWRngrS9MRwzlpL1iB
	/xbH/OV7GFP+vsfKJC7LcFAvIveTbWRCbYiCOgc26DXEghPBpc0coTCIYDSLJ3VRTkYozp
	lSljvJivPHTUsVs4MhvVieN8PhpnsFY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-2yvgxcEXOIiu0rKY4WN2jA-1; Mon, 12 Sep 2022 06:04:32 -0400
X-MC-Unique: 2yvgxcEXOIiu0rKY4WN2jA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31EDE811130;
	Mon, 12 Sep 2022 10:04:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A1D717582;
	Mon, 12 Sep 2022 10:04:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7128A1946A43;
	Mon, 12 Sep 2022 10:04:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA78A1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 10:04:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD62A40C2065; Mon, 12 Sep 2022 10:04:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B859240C2064
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:04:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EA751C14B6F
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:04:27 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-nAIAhoKhM1OgZqt0yMnqnw-1; Mon, 12 Sep 2022 06:04:24 -0400
X-MC-Unique: nAIAhoKhM1OgZqt0yMnqnw-1
X-IronPort-AV: E=Sophos;i="5.93,310,1654531200"; d="scan'208";a="315397059"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
 by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2022 18:03:16 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB4067.namprd04.prod.outlook.com (2603:10b6:406:c8::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 10:03:01 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c%8]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:03:01 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 01/13] block: make bdev_nr_zones and disk_zone_no
 generic for npo2 zone size
Thread-Index: AQHYxoDXfMeyNZSHw0ik/YfXawI+PA==
Date: Mon, 12 Sep 2022 10:03:01 +0000
Message-ID: <PH0PR04MB7416EFB3C180859AD88028FD9B449@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082206eucas1p25336d07279850f7009be6b5d1fccf558@eucas1p2.samsung.com>
 <20220912082204.51189-2-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BN7PR04MB4067:EE_
x-ms-office365-filtering-correlation-id: 74628f40-a7ee-44a5-e28e-08da94a5fa23
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WxridRCG8xjfWHKZWVxwDSlYQC5jMAho3cm5xuYQGqagDNBJhRxTARlp9vQfu/6sqeHc8oCwnm6Q4gOprWCdKuI5OM3tyzUBR8u8LUevqR0blSUXlTOXoP+gQRH1/g/YyLdH+T+aGPBgCDiRDaEbqbWIFHq9e3vaBU9OVQt8aD5NiGzNM1sKQVpw9MMe+hlK6KVWQqvgsBEyWaoyoEC91rrwxwTcGgdLiviYpVXU0nqdGU82N3y0oMv7mPHPnWRPTPnoqfynHu6+OWuylNfeQBZkGFSHYF9XeHcv2AaZ2lIP1cG9BZZigsbNDqCt5KSOValUK+1Cn/uLwlwZwADs9YCoOTurUe5oIzfTu95j4bbZYB8TsSNbLFdFGiP8D+BPoyHgHiRui9Og1R5irOUPALlc07EAdoak2x2mwHgVW3VdaQAi2cOhgM4lXxICHp1ldyQGH+FIbOkItgT4YjNFQvgCZLvcqTlXsajU3wK/cFmtp+m5Lla+cQ1mxcPPXAgNLT5289Mn351XfUFO49tfhscO/jgfny2rrUyLfeEYP3wNvSLLdHmzQf7RLtaqCu955w35NQ18M4n92nps7gimWyhk+nuesO/EAoQ94noe5z9E/muAksQr9GhAex4LT2mUX5HxBMOQuds0kYiFFSZlp02y/M2jRQanUpZ1244iRxhtzd0686kt2QgLAfDJsFAf9RThSj83CDSX0EmvxyfGVJfoG6NgY2jqsBb0JS5XdPlWZQa9ks/pRkhKWNTO3aWGJ9WO7QCmoUy/H0HlNQRtSGAkVrV6T4HiFFVz2g16hUFKR7C/4FJbYYw2pfdqV2UDbXam1h673OZa2g1Aqt0F9w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(38100700002)(8676002)(86362001)(122000001)(82960400001)(66556008)(66446008)(66476007)(76116006)(64756008)(91956017)(66946007)(558084003)(38070700005)(33656002)(71200400001)(41300700001)(7696005)(6506007)(478600001)(9686003)(4270600006)(316002)(110136005)(8936002)(54906003)(19618925003)(2906002)(4326008)(55016003)(186003)(7416002)(5660300002)(52536014)(41533002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?pcruk9z3WqXw+gFXqcJmTTA/9hYwD8x1huC7MKnK5/wtJpXajZBZptJnMc?=
 =?iso-8859-1?Q?djLpC0hIbx4tv8bJ8UQpsntKp0GPZqNDaIqUALr1dOk88BHvKjE+xiMn25?=
 =?iso-8859-1?Q?eyyW/4hou14GARdiQrzNRoW0jOowj0YJtEZDwOyWX0Bm4fasyZntTxJELi?=
 =?iso-8859-1?Q?8Ne+JrkuoVn9/D7KgB6w3Jf7Cjw2OZMEfruJ+RhY0mjab8yW7rAd80LO20?=
 =?iso-8859-1?Q?+7VjV8TynYYab7C7+T8WLOSsm4+ZJ8S5RVwlVwQ6I7El0MmtpbZr1XI+ML?=
 =?iso-8859-1?Q?DX75pApKvK9koWy+5nUK0sgNAww0W4RWFPV3CZbdHm3pCrP1YLOrOQURyp?=
 =?iso-8859-1?Q?nf2L/foxWuPAM1UzTC0jkqYqJi44Z5Kt1FekyNSy3kQ5okTUbwy3iSh29A?=
 =?iso-8859-1?Q?Rln+HcwFlFdwX+S5yryueODt/bjOvN6f/vnQcLij1fBOrSsENEveVZYXq8?=
 =?iso-8859-1?Q?K4T8qoL/eF1Nt/5YkxhZZXsVXTuV4UsQutrRRA3Rj5tiVD/y/P+XGcPtIe?=
 =?iso-8859-1?Q?pHTGvRrVbtSiOSA4ZQQzgKIyAMQ2tMyo8fdO5H2qYrdKmfJLfra84NbRpP?=
 =?iso-8859-1?Q?NQCMfyDH2reqq0JjU/L+4qM211R52cjmbkzy5H29uIDmU0fFfFxADYQRe0?=
 =?iso-8859-1?Q?lCbTw9eQXJk74exP0pHeLHbqOFp2vSdsefscqu/lo5jyVaMz7E3D6kn9wg?=
 =?iso-8859-1?Q?ZBk5v1xnmN4IalWzGLfJKMYpjaV3F8jJ15YwtoT6sHseMDHAcgr1ogno8I?=
 =?iso-8859-1?Q?esHvK+PavKsTXoxZBNv21tvZBvxKH0gnMDFW03D0Hcx1H4ByLxV0mz+eIO?=
 =?iso-8859-1?Q?ajkhuTYkO3hDTh2mSTedyqpEyH7vH4i0TdJ5ncrj/0Z3mESpswPvnED4fC?=
 =?iso-8859-1?Q?zoEOZJTLSHo87aUroNy3VosL9fmXZ9zs+eRWSh5IvWO9kTV6CBGlEODO43?=
 =?iso-8859-1?Q?c2kTUFpAqcOFPUJF/tIk80eLzprTu81/djvKZLmrEW0yKIc4zRFYDiwtI/?=
 =?iso-8859-1?Q?HPbD9z9HmGO1nI6KMcuOqI3m0Uuzr51Xzz0nz5yIXzNikvA5XXxvJiNJn/?=
 =?iso-8859-1?Q?fq9OD3ONFwbKmo0M5/KRh+mSGBi41aqQGZwKa5Opi7+tISwa8zY19fC7pc?=
 =?iso-8859-1?Q?zkDOqgGIf/scTWAD28s+6/fjl+uWRNtWDQAOqvi+wWlRMR1QRHdgV953JA?=
 =?iso-8859-1?Q?W6IllDK3mtg6U8slTXdZLTuRI51buybJXC1f87+wpUl21nVNDIWiRqL5Q8?=
 =?iso-8859-1?Q?EOcIFmh+Vsi1nXNIYp0eQ3ql4rmwSY7QvZRsX9M7kVQxGjuOMdavFSJFDI?=
 =?iso-8859-1?Q?L+92FgKqOjaRkez4ehveVhct25vzKKKBioma/l2/wtnKsZIJx2hvwkSsLm?=
 =?iso-8859-1?Q?ICFLohqX+s8AJdvYlOfyUGHQzCsMME3+CuQfOSgXgOV3yr/LB48JfvMbRb?=
 =?iso-8859-1?Q?Iamtx1gCROqpUmOPjfZCnymxkrZcWJ+hFRpBT+cCROFSzi/u6oHSW+GpjI?=
 =?iso-8859-1?Q?DDpEgDSqSUytt+eIiQBbkkvFOikq9yWdQN4z9M7or6SZXxccA/EOZNPTw2?=
 =?iso-8859-1?Q?Yo4tlZZsIVeADMt9u0oO3wu0OTqi4N2Js+9hWnwzD4OFLXtwcVMHSdC8ms?=
 =?iso-8859-1?Q?FSCmJ8fYz6Mji9Jq/bjPb03BkJgKlC8gfxI87Rw5iCUBczkTf4ZWD9tQbe?=
 =?iso-8859-1?Q?9nJgCrls/r9hUJlRotruWPqBy2BDTVvjwMpx88UYSCRc+m6iCeWX1k1ThI?=
 =?iso-8859-1?Q?zxww5EQ0HXD0O6bCwe2uATPwY=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74628f40-a7ee-44a5-e28e-08da94a5fa23
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:03:01.3360 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1REMzYDpXjOZVh5i37Fuo+TW6pvjnQGbV1zjV24ovAGN138XPy7Z6ug5COSZVOJp88yU89nDKsHveNYFAYMbjorwi7vySKggmOtHxgA75+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4067
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v13 01/13] block: make bdev_nr_zones and
 disk_zone_no generic for npo2 zone size
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Adam Manzanares <a.manzanares@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 =?iso-8859-1?Q?Matias_Bj=F8rling?= <Matias.Bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
https://listman.redhat.com/mailman/listinfo/dm-devel

