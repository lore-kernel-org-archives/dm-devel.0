Return-Path: <SRS0=F9kp=KW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE5E8C47089
	for <dm-devel@archiver.kernel.org>; Thu, 27 May 2021 05:19:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D6871613D3
	for <dm-devel@archiver.kernel.org>; Thu, 27 May 2021 05:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6871613D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-PQxTSHTCOhmfAJqv8nGwTg-1; Thu, 27 May 2021 01:19:40 -0400
X-MC-Unique: PQxTSHTCOhmfAJqv8nGwTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B63C80ED8D;
	Thu, 27 May 2021 05:19:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C55A11002EF0;
	Thu, 27 May 2021 05:19:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6203955348;
	Thu, 27 May 2021 05:19:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14R5JRqM016709 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 May 2021 01:19:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9BF28113B53; Thu, 27 May 2021 05:19:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9568D113B47
	for <dm-devel@redhat.com>; Thu, 27 May 2021 05:19:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03576857AA4
	for <dm-devel@redhat.com>; Thu, 27 May 2021 05:19:25 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-300-U1bS3XotOICDgiXsa8Ht_g-1; Thu, 27 May 2021 01:19:22 -0400
X-MC-Unique: U1bS3XotOICDgiXsa8Ht_g-1
IronPort-SDR: EGNNamtcXnhlsuLY3Wwg5ZNzsCSTHKljbwcA1bUuJkbbabzg+NcK++tioDqcxSp9cvD3o0yVtr
	ItyF7NSUnRHTXLB9tBd0D489k6MYSlMc6yXKx62cQry0LCKEUMbUckYJTfo8KNiTQa26XLCNg4
	9fJGjjb4Vg0f9/I9MvHUp9IaDrtQKVTgB8gCj03VsgQ47DgVG+zk/uGQ0rbZSdHbEb+KZwOUtR
	kkoBhN5pup0pSRoZ1x4ChpNtyz7a0z42wjmVTU2B9FZchlVHdw2PurzTTJh1twyfFI8rJ20ys3
	7x4=
X-IronPort-AV: E=Sophos;i="5.82,333,1613404800"; d="scan'208";a="169599638"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
	by ob1.hgst.iphmx.com with ESMTP; 27 May 2021 13:19:19 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB6777.namprd04.prod.outlook.com (2603:10b6:5:24b::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Thu, 27 May 2021 05:19:18 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4173.020;
	Thu, 27 May 2021 05:19:18 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Thread-Topic: [dm-devel] [PATCH] dm-kcopyd avoid spin_lock_irqsave from
	process context
Thread-Index: AQHXUrfXpmt1HeuvjUWXjCqFWKnESQ==
Date: Thu, 27 May 2021 05:19:18 +0000
Message-ID: <DM6PR04MB7081C1C6370D6730E002B6A9E7239@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <alpine.LRH.2.02.2105261016290.25928@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1077bf56-88db-4b68-533c-08d920cefa29
x-ms-traffictypediagnostic: DM6PR04MB6777:
x-microsoft-antispam-prvs: <DM6PR04MB6777284CD85183EFD80ABC0CE7239@DM6PR04MB6777.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:513
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3oOLanXozwS2fZlcxanHkTUmoa9XVVjacKwiHnxuZQ9k+vXNxGAMw+CPfATOFaIWfvutMkx0WNtZru0F8uznVpqHIr0n+uzTP4Xae1iidi691twqrUQHjNhya/MBHqti5s45fNUD9V8fpvwR+VISsaqd0Aek2RRuooSCIc7AXhbe76Qpyswu3xA5hYjyoc7hx/YTpxuMqqrmcRX2GY8aJpaoZq7K3OkrGH3RhjWH9RrNzDZ8lv+sRtFwPtmYCRv4pzN5LcbsH+XGur2P0P9wZe0l+k3yMvGQivuuafX2a8p66uqRD4bfEeMaqS99J3Trq2ek7qiU6BcIwEHV4QptoaKm+8Tz/enbwc42avNCFuY38+rMiIJ6/Ykp+r6Lccr7d+BrIMgezRJ6nQXfn6YAS8BhOS0d2mApw4wDWV4aEdRQ24BVTSK2zTa/sIg2DQN152wEGC3PxtIJt6qzdGU32gOcKxFbtrGiRPKSo6FSIku86bXzgF8+GCWtiHKk1GhaAdfWqEAkZ7365MOnHQRAhgUUmfLhfcNv8xeGMy/ZxOvwuCzsMGhOp4/zrLEcKO6kBKvfW9VehzFQ3jKbPZv6grR9c2i6VdTciCvUViL69rc=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(66446008)(8936002)(8676002)(86362001)(4744005)(2906002)(450100002)(53546011)(76116006)(52536014)(5660300002)(91956017)(316002)(66946007)(66476007)(110136005)(83380400001)(186003)(64756008)(66556008)(38100700002)(122000001)(478600001)(55016002)(26005)(9686003)(33656002)(4326008)(7696005)(71200400001)(6506007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Y95e3jPTeQH3q93l9QdhEH30Fft66guO0MHZpNYbDhbvkHiNihXXEPkwMbCD?=
	=?us-ascii?Q?NzRIfLOMjpFpSxuoWkm0EynidgQth18aLcgHV2wAkIzwL3MCr0XItN1MLBFT?=
	=?us-ascii?Q?XV6lLpIOzkIPmQhdAG9s/SndzS13PS6GznsxwZbBeCn+Fs7scUhvB8yy4vNb?=
	=?us-ascii?Q?Ee+mI5c0RSYcPeOgiX+ifwfIUMuO5qY8Y5+Mj3ziXILO7lGrM+OPqdYOGhmp?=
	=?us-ascii?Q?gc9LRNZlTfAigBAiT+3iotmdkC20IHIc65MXUljrAzB9qaufu+jYJvVVA8ML?=
	=?us-ascii?Q?rAa40d0TQR8auVSfcNtQvn5B/LGGv2kAO3Ubei0R7lSSA0KBlW+nsk42TiVP?=
	=?us-ascii?Q?kKrChbMZIs2fRJx0RdOaAhksSejtccdUrF1qV+xVl6nHQHWT1sn7zCdhRczW?=
	=?us-ascii?Q?Czrjw9Lqd0kxrAzofvwbF965NFFT6nn5C7ar4RRHHw+w1SNORigXRHUC5RM7?=
	=?us-ascii?Q?SvaLNOiExaraL3a1H8sXzEszJ/Yg/HaFTqkD0n11tWoCjeazsEOdHRLMZs4D?=
	=?us-ascii?Q?iim7iPT7WWuRMjmT7v/0/06W2PukSdyZEDtIQvwfe8T/lSXdcr6AFKT0LkOp?=
	=?us-ascii?Q?U9iBRBIm6/OFLzkev0BcLbfzSZyB166qe1auA7NzDNs0fHU0+E05kfhDqlpM?=
	=?us-ascii?Q?/Lcz/EYjY6sqa6LuDKsQYlbeGA5A69IWQJF1LehcywBTEK7Gtvv5OByZqP+s?=
	=?us-ascii?Q?Eh1j/OorJniyvK+QfVQ7REbA9RV2UjV3DDpI7gsVRFDwlwckEzWcOYhqBXyn?=
	=?us-ascii?Q?pSgAcZ/Cs5iuClzUmmJ9ozosW2XFQ9K2LMddfRqjpVVCl8l3pOO8GdGme7zm?=
	=?us-ascii?Q?KKzgq6IS+qQLQhZuSl83wvZ1CmjXeC0LyYGV2JONXDG+h3McVBs+ygHgBu0x?=
	=?us-ascii?Q?4Rma3N6zzhrprIGgjB4nWeo6kbnZghbkztB27DsdLXGYhIrNlUBJTLlLVFo2?=
	=?us-ascii?Q?W5Ar9AnnO7fsNcv1eQw9uRExcqP4xoAqeW3OrgG2sm8xWO3AuI1efpHYGNp2?=
	=?us-ascii?Q?oL/4EAoBWJzlPoGd4kj6FR2SBXobfRfXcuU+BkEuSeX2poSCP2RRXx/2zKFn?=
	=?us-ascii?Q?wfid3rMbuQWTQZ5W6T3/X7bcaABkdfeZA54j+Rn4XEOzy+/H8tamoDXj0Y6V?=
	=?us-ascii?Q?o3au7cH3pkMi0qktarIAYry/6mZ0u0Gqi9TjM7ap+hvJ3MB7cXceLAxcjo6S?=
	=?us-ascii?Q?lau33LDgKk31d8NvSyJNdtfSVITQZC7KWkyM1rmqote14Sp3uhtfK/+QmknM?=
	=?us-ascii?Q?LGX91GWpbd/cVu8e83/PxTwENO5F+BTl9cTRjbqPJlNwjL38xnNXN5VwYdeS?=
	=?us-ascii?Q?23FXkJIufvsVo+IlgvyACjulagDljhJ06U9HlrWgH4icOA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1077bf56-88db-4b68-533c-08d920cefa29
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 05:19:18.0964 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4jOcdigqZIk9NKowoHdEQStNCguZH1AjtQN6i5ln+Hpe6KAE3V0WykK5Em/9Tl52xpXMCo2SbNE99T02gGzv2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6777
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14R5JRqM016709
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-kcopyd avoid spin_lock_irqsave from
 process context
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/26 23:18, Mikulas Patocka wrote:
> The functions "pop", "push_head", "do_work" can only be called from
> process context. Therefore, we can replace
> spin_lock_irqsave/spin_unlock_irqrestore with
> spin_lock_irq/spin_unlock_irq.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

