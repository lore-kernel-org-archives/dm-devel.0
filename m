Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAF1CCA481
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119812;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=i4lldjKLcTyaThcQZ8QIYQedbUW+Lv1a587WG83zzIc=;
	b=OtoyGa9xCiRM+SPjCjWvrF4rWAKLzlYl8FF6lpxzwNZoXyYFl7dqFZmsbMhZFM+9z4g+nf
	9ktLEuulUblqaoMTdr0k9uPPwiLEyd9h9vzdqBVS195vmcm6zzIpVk/Lf1jG6sIokWRxbN
	ZZvotZtTeb/cPuO+LtFgrb49fJAj/Jc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-1aHTcXAxPtqviwNOsNcvKQ-1; Wed, 06 Jul 2022 11:03:30 -0400
X-MC-Unique: 1aHTcXAxPtqviwNOsNcvKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DB028339C6;
	Wed,  6 Jul 2022 15:03:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 17808C2812B;
	Wed,  6 Jul 2022 15:03:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A5E06194706A;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E000F194704D
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:45:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C90CD492CA3; Tue,  5 Jul 2022 06:45:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C463A492C3B
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:45:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACB02101A589
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:45:12 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-3lh3n15fOnG_KuzENm70-w-1; Tue, 05 Jul 2022 02:45:11 -0400
X-MC-Unique: 3lh3n15fOnG_KuzENm70-w-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 06:45:09 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:45:09 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 03/17] block: use bdev_is_zoned instead of open coding it
Thread-Index: AQHYj6Pt5Ue956zlMEeN5WNRzyUf1q1vVkIA
Date: Tue, 5 Jul 2022 06:45:09 +0000
Message-ID: <5723dbf7-33fa-00ab-b599-b99523f6c626@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-4-hch@lst.de>
In-Reply-To: <20220704124500.155247-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 710bfb37-6e15-4d2d-d30d-08da5e51e765
x-ms-traffictypediagnostic: SN6PR12MB2846:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eHfb+X9zfppf9PXXyIviJvd2Q/50b+YybNC6fxRo1PF/oNNXbRokCDkzJqMyFBepnfOJm8a4GVDMSJ1edzIqoyfTlf23/0thpfox2CHPmZl7nSzS4OnHln+HwmiiB7N6pI6bT/1UO2U8Q8iJN5NFRHX2UZJPveYEOpHcE51V2j3jMxpplNmaFQ01vnuJGdQwiKAw1K9kwgVQV6M4MllhsWkhGmNW66hdQ7XEwzSMHpazkdYTJyYTcKyBSHC1gmxivMyhHZjFgspG7VihuLquRtHFiu1IHrAuza8zJBTCgRY5XD4c23HyAi4mbJkq6qeJcLuchT+vax2GJQuLWjm5/fnZvxcVIRE0Zrx8vjzMoJyH28UMJNKYiwZms3ASb5f7Ov5Fb2lSxvOICgGKlsYFCzgweC1muyYGc2igm+ty5xTdA/xkpDK/stj+kydsbJ5y2smIVB8oG5ozYYEkGTH3EDmwhq4FZ5bXGYW3NC15BD/EZPxT6L3GE2a4WHCiYY24RD9isHarhPhLXIcCvfHJrUQfZCBtFsOQNdrc8uwvONaZfIiRr2Zgs4fcE76lw40ifRLoooHNR9Q5QxPlur3IxZPflxaglExaQ9yPMVknfil722fqPWkVCJHBCfvWsf2ltKmHjUMYeWJT5i2Hv/jFDNoQMulyZZnVXqfzyj4qi2nEx1GKBQhJDAXRDU2qwaEbdTIX619/f4quMSUauN6qBtMs8neOvgz26MIjPZM0t//w1NeJ3k+8FOcGd2SeMm9lv2mBNEGhXcbvS+nO5f7CJ4B9cuB0ATtSOaYpCh3AIODe0UKLMnDuLxFyhlIshaHfwL+V6Z5S/V8PJf3VXnZkUDpfu+ZelbJYpCJmVwEefQ0wwFPqnPGiy0+PQ85KT6Gm
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(6512007)(53546011)(71200400001)(478600001)(2906002)(6506007)(41300700001)(31686004)(4326008)(86362001)(31696002)(558084003)(36756003)(122000001)(38070700005)(38100700002)(6486002)(8676002)(110136005)(186003)(2616005)(5660300002)(316002)(54906003)(8936002)(66946007)(83380400001)(66476007)(64756008)(91956017)(76116006)(66446008)(66556008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTFrVzhVQVBmTHYzbnVaU1lNRTl2cHJ6V2QzWVJBYUNFYWZ6L0F4YU45R09I?=
 =?utf-8?B?NnQ1Y1NsMk5yazVLMUNYSGwrNE9NdVNIMG5UMkJhMExMTGZHQ1FqSXFRY2t3?=
 =?utf-8?B?eDNpNEk4cXdoZjdtMkNZUnY0bmYzdXd3cVdwVXlwZ3NNRVJidVhvam1KUWlN?=
 =?utf-8?B?YngvU1Y3bTN0RXZ6dk9JRnA2bjcydklnckVuRjVheURIakwzU0RmMU5lZWtu?=
 =?utf-8?B?NVhRaTdUUjhNU281aWJWQUROZENVUE5QdU1TTlRUUGFWMzFaKzZ2b1pkV2cr?=
 =?utf-8?B?c1R2WEU2TTh0UytOMTg5OUdLZCtjMXlkbXQ4c2lqYzdONWxVZTNoaUVLRncw?=
 =?utf-8?B?RGFwNmNxbk1lVWozKzR5L0xmcG1GQUxmcnA1TXFwSHJmSU9qZnN6QzRkSGhQ?=
 =?utf-8?B?YU9OQ2JvT2RQY1J2bDdLVlBjUXkyL2tEY1dNcnVJa3FOeTVERGQ3a3gzVG8x?=
 =?utf-8?B?U0d1L3NyMVU5ZWdZaFk4MDBvbURNZVRIK2swRVh1RXhDZFM0anNZQUx2ai9x?=
 =?utf-8?B?VFVpRjFZOU9Sb285UnU1SkFzUzlHUGlOR1h2M3I3dyt4SFVHM090U0VHeVFJ?=
 =?utf-8?B?czUzUUpBTUV6aGJlUGNnZEFnMW1xUDVhY1BVMVdYWlhtaitFNnExUjdSV3Uw?=
 =?utf-8?B?ZHV4bzZKbjRUa293WS96dDdMd01JUWVDbFNMaDF3MDNrd1VNWUhKY0lkREd4?=
 =?utf-8?B?cmYzdlpXbm5FbEV3SktTek8rUXByb3dzMzMrKzNYb3B3Tllra29iVFFIaEx5?=
 =?utf-8?B?YUpqN3AyOFplRHJXOWp0SnYybERZUnVHczV3ektNVE9lUHo1ZFU4WFVXUE5p?=
 =?utf-8?B?QUVyS3l4ZmRHdjhjSHZWTVRWL0xWN21TWFc3T2l2amdNMGVBbEZMdmtRUGha?=
 =?utf-8?B?Q21ZeHBNMkliOVQxdjNhbUxUYVM4d1RlblpOSmRVZW81RXF1NjdPUTVHQ2JB?=
 =?utf-8?B?Q0I3anRObG5zRS9YU3YrMHllT0VSblBENVhiL0ZKKzdxSm15a3ZXQk9jRy9n?=
 =?utf-8?B?MUozankyQUQyNncxSC90dlFZZzZYMDAzZzlnUjFRR0F2Mm54TjBMcnNEZmNw?=
 =?utf-8?B?V3ZVUHJPRE9GeXZmMm16bjNHTUhrV3RseHBTS2hSVHdRQ0dIeEhxT2w2bnhY?=
 =?utf-8?B?Qm1BRHJjeVlraTFNOFFQNE44MTVsYXVpbTZRUDBUREt0c2ZJckxhN1lhUFVz?=
 =?utf-8?B?ZFVnTTJUVm1VS0krL3NMbDIvaitjNHVzTkRJZGkrOGdhZlpzVmhqZmsvYytW?=
 =?utf-8?B?T0dXa25ia1hacW15TGhGZlcrNmFsU3hHUEhybyt6S040VkZSVWVvU1R5WkVP?=
 =?utf-8?B?VW9mWGdud3RmZmJuVTlGUjMvTHZKZ3B2aVo3MlhlYlRjSjluYUJCSVlRNXZm?=
 =?utf-8?B?Z21zNmNNMklabkhkM09oQnQrUllFNTQ3K1B6cUlQT1BpcFBZQ1N4MkJKRkhL?=
 =?utf-8?B?NS9jNGZEVDZCSXRySk9iMnJ3QjcrR3YwN1hxSTFkb0FlZ3ZmVkZiT0NQOTAv?=
 =?utf-8?B?NnZEa2EyaGFKL0tCcFYwZlFtcGxQb2FibXZaQ1NibFZiTVg2amxXYWJPS0dx?=
 =?utf-8?B?elg1TWpVMEdHUU9EOHkxWUF5eVUrKzVyMk15RFYzTmhEOEhZWGtmeTd6SFkv?=
 =?utf-8?B?T3RLV3g5SGMxODY1ai9hMWQzOFNCc0FBdE1mLzJMcHIxVWJxV1VDc0lTYWox?=
 =?utf-8?B?ZGdVUFJMa0d4RDVwM2toTWNmRlB2MG1VTWp6RFgya1pqQ0hjWUY5ajdFdzlD?=
 =?utf-8?B?dDd0cU9BaVJXeWdkTG9iZDIzbGRPKy91QXViOUVGR1Z5ZmJGaFhuK1JScERN?=
 =?utf-8?B?d1VjNkdPczY1THZIRzJVZ1FmYWpxamFCMUMyMm9FMU1remF3OW83elFzUEU0?=
 =?utf-8?B?bkErVmdaaVVYR2ZDWWlTZ3g2T2hqaHRlWGxVT1RiS3NkbWQ4Vmg1YkxIMmh6?=
 =?utf-8?B?NGNaakJjUElzZHNSd3NWc0ZyNjhUZ0k2RTVaTUxHZkMvb1RZMUg4UEhTZUhq?=
 =?utf-8?B?N2hGRXNTTHEyR1haZmtnTEg2NVY1WVdWNmdKTlRDQ21ZZXRzZTV4VzhEa1c5?=
 =?utf-8?B?c0hJUUgzd2JhRTBtRWdOaWlZQTJVZFdFakRYbVJoanZYalU4T0dXakV4YmxV?=
 =?utf-8?B?WEhEd1h5QUpqeXR4c0llSzRMREhOL2I1OUN6LzN2WEIrRE5ld0RDNUF0UUY5?=
 =?utf-8?Q?4r/C4v5KgKW4Uq08a5wieUOS2QVVjGP+jGvr3dkIwBYe?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710bfb37-6e15-4d2d-d30d-08da5e51e765
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:45:09.3606 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7KszDDUfDtlXu56kTGUPShMa1rEA79DDj8FZB6gtICKVjsC+pgOrONeEwQnAIW1jJinV6IKyxj2JYnAkq/P7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 03/17] block: use bdev_is_zoned instead of
 open coding it
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9864ED06C61E6F4D913047AF914697E5@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> Use bdev_is_zoned in all places where a block_device is available instead
> of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

