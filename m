Return-Path: <SRS0=+RIL=GM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDD4C433DB
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 20:15:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE1E423AA7
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 20:15:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE1E423AA7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-B81nhnplM9aIRuNGStTTMw-1; Sat, 09 Jan 2021 15:15:40 -0500
X-MC-Unique: B81nhnplM9aIRuNGStTTMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92BAD800D53;
	Sat,  9 Jan 2021 20:15:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1919F10013C0;
	Sat,  9 Jan 2021 20:15:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2660F4A7C6;
	Sat,  9 Jan 2021 20:15:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 109KFRB1010574 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 9 Jan 2021 15:15:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3AA101003332; Sat,  9 Jan 2021 20:15:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35736111285A
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 20:15:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00BCA8007D9
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 20:15:25 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-352-boEIK32AMcuU_pTpMsjysQ-1; Sat, 09 Jan 2021 15:15:20 -0500
X-MC-Unique: boEIK32AMcuU_pTpMsjysQ-1
IronPort-SDR: PvvqJk4relNj3XwhWCYU2YqOl98sp1f0Upr5983aEnn8cG6boSnJrYTB2tW050nnZpyxQPnFAf
	B42o1EtSNC/1waPd29LVdxkIllU77DcORmSzD6sDJ8/fesf/WePUECLLqKWzh/oIvFOYpzpknX
	TYjAWV01dvAcwoZkcveoCl6F839LqZRyMZeXUpIQfKKypJmjomrFT35yDINsnXMbGz3jnJbi59
	D2BZoK32oklI9zjHcWLiiHPfs9deECLDNBYpc2V3KT35XoMMPamWj7Qnu3elXIrC3fTc7BZj1v
	E34=
X-IronPort-AV: E=Sophos;i="5.79,334,1602518400"; d="scan'208";a="157042328"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
	by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2021 04:14:13 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4871.namprd04.prod.outlook.com (2603:10b6:a03:4e::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12;
	Sat, 9 Jan 2021 20:14:12 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::716c:4e0c:c6d1:298a]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.009;
	Sat, 9 Jan 2021 20:14:12 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 2/6] block: remove the NULL bdev check in bdev_read_only
Thread-Index: AQHW5nUARX/fpWP0iEiSGjKZobcLZg==
Date: Sat, 9 Jan 2021 20:14:09 +0000
Message-ID: <BYAPR04MB4965B6AC1FAAC270F636F7BE86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210109104254.1077093-1-hch@lst.de>
	<20210109104254.1077093-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8fb53c66-fb7b-4a57-94fb-08d8b4db2134
x-ms-traffictypediagnostic: BYAPR04MB4871:
x-microsoft-antispam-prvs: <BYAPR04MB48712A5FCCA99373D3D3201486AD0@BYAPR04MB4871.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 7oZkUxkxVyoFipLgsp9UbOFpsF/tSlNuEkSJhwYQk7QcHNgpGkqLSUGchtqvEkCyT4zyUO/pRkahIOisKaTSx66mLY88MHRcnRCZOhk+7Otpm8T75OdGVhuvft5qGshvLSMeCBbyeMd7rDsxxb52lLhHOqSidODGVu/Ze/VJCC/qVj2PJgPbBrM2AhEt7E2URxSGV/4t6Q2hEf624wR1npy1s6haNRRiuyQ190aOoqAajFhSeQc9DsAuLvHcH8N2GYY5xs7F+Llyscy9EuLjPo1vuEr1CUsfBi97ZZwcs2u760JgdJZxmJ1hGmVnd4aeAazjPNbmTUxwHKktOKPH9I4jNF8yEpUvfWsxseXjiWRIity0S5TmFXwQSfchdKLATFkAV/obBDcrwdRM2CNDxw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(6666004)(7416002)(52536014)(8676002)(2906002)(316002)(110136005)(66556008)(66446008)(66476007)(54906003)(64756008)(66946007)(5660300002)(558084003)(478600001)(9686003)(7696005)(26005)(6506007)(4326008)(53546011)(76116006)(8936002)(33656002)(55016002)(86362001)(71200400001)(186003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QKij9sd/Bt6PfCE8fE8UdZaFOkMnEMhA8sW3k9Q9wU/bIUy1MeBfOOaPk9dk?=
	=?us-ascii?Q?c9CACvTv6Jq6mPSL799jA3NHgp4wN6hlqQt/ZApz1zaVWcBpBdTPsdi/x1zD?=
	=?us-ascii?Q?Wepbi5k966rvX6LLVBsufpu8TcwatQyyjgPT+VxR7tNNeiZaDlhWeUKGqq7R?=
	=?us-ascii?Q?BC1LBOdyIxFlVH2ssXcCUGi7CZk4K4ngoARWUCaqC82Ho5Ku+R2GhIvPNLj+?=
	=?us-ascii?Q?ywx2sC5x+qoF6oYyppdrVulDZDISHy3jYJVFUO+nIwtfHgTe0ceIbKAxHqGD?=
	=?us-ascii?Q?HvBmvvyoQ5+RCrgk6CMMiNzUgmG2p6VGxPPi3dJCn/JWE50Aqx/opDip8SKT?=
	=?us-ascii?Q?h0y1e+Axbh++1gY5RAJyqCpCNHC4vK5nZqowPGGhqPczb9mHS+sHmHGYyUsC?=
	=?us-ascii?Q?uU8DrX7ematvUT76DE/40lTQi+lmwWw/FdAdYsCZ+bxvMDOCfUW3EIjwnKJt?=
	=?us-ascii?Q?RVS2nrlHMloiCZzGPYAa2ORbARWr/EaRBTUd9JNFcGRDy2qHKX8loj4IAhgd?=
	=?us-ascii?Q?gDzsSDy4+d81FDOf/GSNtVquiL6Ygtld3rOefUQ8IdHBChg6sK8JHzxGTJgm?=
	=?us-ascii?Q?i4s4/xJJMfIVC5K8Xw3gexzjCjuCjapJQYI/uAX3nbcsnp+B5kSRWHCco3w3?=
	=?us-ascii?Q?jfFqRwiGZP/3smra+9zRivLouccQ0TV9gCpRTj9J25byzLTQgzcepJHJagzA?=
	=?us-ascii?Q?mqWt+SYk0eSFjnWeHD747LyF5d4CW5AMx0fJ6IZTIhxlSiWPKo+5X9jB7b0g?=
	=?us-ascii?Q?lVr4dWJddJXpnQvDw6MTgXZLRuFUv6n+Pj71HNROsrSMIkTJfAEFBSwP10Ca?=
	=?us-ascii?Q?dOk4MCAGAzsSHGUqw11ptUBqylf+/29nyVBqwRn3ihJ31UUb+ohE9iWZ4r1x?=
	=?us-ascii?Q?7aH2dVA+2dn2OwvPtUQkEob2XNZmxTosftCwylo8OsAZrNarBq34dQ0OVFJC?=
	=?us-ascii?Q?9TFjKKv1FwURNbsSfAvgf50NR1cJPdxEZMTC1uAIe314SMTwUVqFxXj83XIy?=
	=?us-ascii?Q?uAJq?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb53c66-fb7b-4a57-94fb-08d8b4db2134
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2021 20:14:10.7871 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8euVf79BlGS6rvGZCtLDknXZ5/NhRi7GjebyP34cSbb9SyJASKB9edWBwdG2QzejrRwJmcVpMtZgeYenY/mYwlK0H+tPXKJcZe7Oed+iKOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4871
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 109KFRB1010574
X-loop: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Ming Lei <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 2/6] block: remove the NULL bdev check in
	bdev_read_only
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/9/21 02:48, Christoph Hellwig wrote:
> Only a single caller can end up in bdev_read_only, so move the check
> there.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

