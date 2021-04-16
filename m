Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B37CC433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 07:13:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 89B2461090
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 07:13:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89B2461090
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-7qPWUm7kOLO5umr_1FqQHw-1; Fri, 16 Apr 2021 03:13:41 -0400
X-MC-Unique: 7qPWUm7kOLO5umr_1FqQHw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAA586DD22;
	Fri, 16 Apr 2021 07:13:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7480A5C649;
	Fri, 16 Apr 2021 07:13:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B3D841806D15;
	Fri, 16 Apr 2021 07:13:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G7DWqc020153 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 03:13:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 85F9A2036617; Fri, 16 Apr 2021 07:13:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CF532075295
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 07:13:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D78F80B921
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 07:13:29 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-449-nX6kpkW-O6y6eQnfYt1xWA-1; Fri, 16 Apr 2021 03:13:24 -0400
X-MC-Unique: nX6kpkW-O6y6eQnfYt1xWA-1
IronPort-SDR: 74dOrqfUSfdQ0Cht0cyh1UdPzUPz9ana57xS4zCIEFS4UQYnmALs671UgUvt+Xq3lW7U88N/Ot
	dgQBB7Qhrl/pkLzDCtXFsz+QY1bKUi1eWEJ51M8Sv6oosOvvJArOjH5oqUvFV4R/7VaD+8q6l2
	9r1joQIG3UGnw5Fb/ZQWUrPwjD9JmvwznWi77QKko6GKxnq8amlDz3S/kO7O5K/hXQX/j+Xp30
	ZeDzDpOvJdDBYH3mH694ImfJGAVCUsQZNpD6tE0w/LQOzwEuK1XxEAlz1PJ7wvRWdb5RmpjLK6
	Wh0=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="275977458"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 15:13:22 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16;
	Fri, 16 Apr 2021 07:13:22 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4042.018;
	Fri, 16 Apr 2021 07:13:21 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
	Petersen" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik
	<josef@toxicpanda.com>
Thread-Topic: [PATCH 2/4] dm crypt: Fix zoned block device support
Thread-Index: AQHXMm1huarhzLzpkk6eySNmcPNHIA==
Date: Fri, 16 Apr 2021 07:13:21 +0000
Message-ID: <PH0PR04MB74165367AACA8F3D9F7B023A9B4C9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
	<20210416030528.757513-3-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:15ab:1:e10b:72a5:d443:5e5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e97de7d-a1ff-460e-d343-08d900a71e3e
x-ms-traffictypediagnostic: PH0PR04MB7576:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7576141DA793D267154FF10C9B4C9@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Sed0fgE2qR55DluVQ4T5DWd9yrofTEjql3R+QBoeKqBsPFd5XLaLT8GjTt27SwdxgRl5EFRWbA/Q4yXjkQGd2XWKl1gLWdxRG5IST3hzVUliZSHcKpHpwu5lMGHDQvV/v0FZbQ9AZTdBD4XtTvW7yFUpv7dlZ0t9eGkkCtJqEC8YwwuOXDDoVBzytnxQz5YxUxfSzJUcdgjBtR4PmvVVfsDbuApDOG+BFGQfhxOtuL/ZVKF0Pk4T4IGLQotnidtTgCwxTCbUgtstvN9tudjrDUmZJscdLUoBeb1hJFv0f+HKAI38f2tQ0RczgA2l8dVZ8zdOLxqic35X4ZrozUu4h+Ml8i88vJZIO7gvWBbooJJf7L+LGkDZYHlsAQskgS99xCNYlQ1jKYEFzzqEvC2IojKY0Rdlm6OsRN2dbP9RJS/I8L4YFBCmmYFE7bs8sU52LPGSPD1TYt10vJ7HDmhr6NCmB/af/vVpRYDC1F7oHsv+561r8tkuTEtnvr0qEY6yBC1mc5xdw+whV4aAdt57XvyIdVUeFahJOgW4RPw4+Fj6PzBvNNw3L6DXA0QhzBmuMP0ruigNNjdIZvV9WT3hrcvvV0O0Ss6u/YxWeVN6R7eCAvQhw7duCsCqXPGY1WO833Mcd0aplHy3CByTjNxOVg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(2906002)(71200400001)(33656002)(4744005)(7416002)(9686003)(66556008)(64756008)(55016002)(8936002)(66946007)(66446008)(110136005)(316002)(66476007)(8676002)(38100700002)(54906003)(478600001)(186003)(52536014)(7696005)(5660300002)(53546011)(76116006)(921005)(91956017)(4326008)(86362001)(6506007)(122000001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WUe4HaF08JvaW3uHTfGKSzjJNCHnuFbDPaq+1h4/ytr+weQrprAm4UPeBHsR?=
	=?us-ascii?Q?nEhNupOlXA7DHKsKTMz/T8bNghCpfJzm9MRDWAhFcorcsBkXDxOwMD4ppfo2?=
	=?us-ascii?Q?I/0GeEx54TUcCu1FV+86t/8mjSjogZ3eWIYU6yL9prIC6CNesIWVUxcvxJVD?=
	=?us-ascii?Q?SXAHIUEVi+Hp+Z3+qfKPWIeUXBQ3FfoTNVQOMgtz7t7LyXI/GYqyR1nL5jvL?=
	=?us-ascii?Q?t4pPhz+EaC2RVRvwSOivUAkES3YBtCSfD6/6Or5g2eDyjueff7C/kna40OZQ?=
	=?us-ascii?Q?yE3kZHYkx0Eaipidz4u4A1vILYW9nGJGFFZYV4SYYw2cO0Wi48nbd2sEKKK/?=
	=?us-ascii?Q?5vWjGqJzw8AgrP7BA2DfshVkLGrM+BxPymVLopETVnVCqrkXXIou78e4FA7D?=
	=?us-ascii?Q?tV3bwXaFnlYvcUC6gkXikmBU3ZcwhkpBXOjJAPJsbMz/c8rnRN9N2/XvVqqs?=
	=?us-ascii?Q?SAT9gyEwX3Vv0R4552taC/w1DgCHEgmmqTybHow6k8rQ1SKZWCrh/lJAr58o?=
	=?us-ascii?Q?qaCa7FqAE+TDi34LDHItX+beZUrpCp1vZBdPNmK7Nlc9uqkKcX/eS/6D4WzI?=
	=?us-ascii?Q?yGgNa/xP2cKYMjcilRr7/pvig5O50dKsmccBoT/ACFxMuHsIcsnfISTrTFUP?=
	=?us-ascii?Q?q8/GCGpuD/g+8oh0YM6da79bNxKyPH4L+7MYyXSsLQSMddyGs1Otv55WWctG?=
	=?us-ascii?Q?cap1/dTXuKc4CyfC+UdkNXXLnJn/r3ktYgvv7URSFEQJCRxS4uWM5tt2Zg3W?=
	=?us-ascii?Q?dzs/QELo9hOEoz5STad9LtEc0IJUKiET8HvSLwaYL7GopNiAf5Toa5IGjl0s?=
	=?us-ascii?Q?HXA+3hXwH8P6gmvqSD1IemfXbV5YyX2ovQnrvo4yCGtbdGC2HcMKIxBFUVxM?=
	=?us-ascii?Q?pcXTfM/ZWuCt6kkLfu2HyId7uvExL0ZQ1F6See88Y+12iOPO6kKDTkCenfkU?=
	=?us-ascii?Q?sdlXJnjoloOn/lrOnklhSFWHpHG1ZLyWfi++jyTmkHTBpwEV9IZuFzunQkc8?=
	=?us-ascii?Q?tUDXFyDo2oh6FXpNQ//tBlKix8VbplaAYJCfLKXBrnf3J/eah0KNBq/oudvk?=
	=?us-ascii?Q?4CzRlaNl8Pj/wzBjQXPtOJPfYqm+YCYzSJhimCtYZ+fvQ4QI5DXM9VUWS+me?=
	=?us-ascii?Q?c4iBC2OhfEkjF/4h3YHc2aCcJZHBabUVCifKeV3Ylb5SzqGMZVacl6uNlyxq?=
	=?us-ascii?Q?wZdzqt9GjdvJDpqZlzpAHoAUM1uRTgIOXSKpewSiBtqUcv9HaMdW73daPgCb?=
	=?us-ascii?Q?fOI4z0u1IUj3kjoNmc650PVRLbNO5jAwR9ko+U+3QjFhqP54avbZbcKBAFQV?=
	=?us-ascii?Q?6GttwIUlyqPeQaYnNqJtndCrd6azjSoxcZ1rmC3Dy7VYxlUULSdOsISSWDVp?=
	=?us-ascii?Q?CWOIjmYFlOlA66l4ZZSVFz5f/ici?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e97de7d-a1ff-460e-d343-08d900a71e3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 07:13:21.5044 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8tbu/Jrt/StPtP/wGGyTKLOEZP7XMnNOtvh02Chk/SdpMo8vZJyGgMKCWRNYFxpI/c3E0Nij+Ek90p3oJFZPaOFdZ3LNZQjZ/PkEPLwsbQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13G7DWqc020153
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [dm-devel] [PATCH 2/4] dm crypt: Fix zoned block device support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 16/04/2021 05:05, Damien Le Moal wrote:

[...]

> +	CRYPT_IV_NO_SECTORS,		/* IV calculation does not use sectors */

[...]

> -	if (ivmode == NULL)
> +	if (ivmode == NULL) {
>  		cc->iv_gen_ops = NULL;
> -	else if (strcmp(ivmode, "plain") == 0)
> +		set_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags);
> +	} else if (strcmp(ivmode, "plain") == 0)

[...]

> +		if (!test_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags)) {
> +			DMWARN("Zone append is not supported with sector-based IV cyphers");
> +			ti->zone_append_not_supported = true;
> +		}

I think this negation is hard to follow, at least I had a hard time
reviewing it.

Wouldn't it make more sense to use CRYPT_IV_USE_SECTORS, set the bit
for algorithms that use sectors as IV (like plain64) and then do a 
normal

	if (test_bit(CRYPT_IV_USE_SECTORS, &cc->cipher_flags)) {
		DMWARN("Zone append is not supported with sector-based IV cyphers");
		ti->zone_append_not_supported = true;
	}

i.e. without the double negation?




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

