Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE4FC00140
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 04:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660107273;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+9Yhv9rqf0cml3rObAmOeRXx6qsd3fRGx7xQKaBNLe4=;
	b=MyWml8nA4tRHktdPdXKNVtzmPeTMNk2IMJ+UhK53wB/8s7xx3/wYfLBn1H7v/+/sIJcgwa
	yIbNYcEz2p3WgvGALuL1UJ8WNF5RXjX317x6bHo1R8rUajts8C+Tb1rGrpCsGPTO7xpzHa
	XaE9F/Q/9SrAWJzlFatRYRD2Fsq8YhM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-aUA2ZG7ZP_2-b_8yEQ3Q9A-1; Wed, 10 Aug 2022 00:54:30 -0400
X-MC-Unique: aUA2ZG7ZP_2-b_8yEQ3Q9A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 514121019C8D;
	Wed, 10 Aug 2022 04:54:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C6C6C400DFD7;
	Wed, 10 Aug 2022 04:54:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 913B01946A5D;
	Wed, 10 Aug 2022 04:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF75F1946A55
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 04:54:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C8F85C15BA8; Wed, 10 Aug 2022 04:54:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4521C15BA1
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 04:54:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABF4C811E87
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 04:54:24 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1anam02on2045.outbound.protection.outlook.com [40.107.96.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-1XfpvZ6wNuGERd3nIg9gXQ-1; Wed, 10 Aug 2022 00:54:22 -0400
X-MC-Unique: 1XfpvZ6wNuGERd3nIg9gXQ-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MN2PR12MB3263.namprd12.prod.outlook.com (2603:10b6:208:ab::32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 04:54:20 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Wed, 10 Aug 2022
 04:54:19 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Keith Busch <kbusch@kernel.org>
Thread-Topic: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Thread-Index: AQHYq4PmjV2UOnxHHEaZfkf5ZGRZ762mZnKAgABBcwCAABkjAIAAncQAgAAZlICAABsXgA==
Date: Wed, 10 Aug 2022 04:54:19 +0000
Message-ID: <bdb23ae6-8b66-fa50-7c51-7381da9d9478@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
 <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
 <YvJ0Xh61npH+M9HP@kbusch-mbp.dhcp.thefacebook.com>
 <5f55a431-31ce-185a-6ab0-db701b878d82@oracle.com>
 <a0184a51-ef30-dc80-412e-6f754c4d9476@nvidia.com>
 <YvMjQSlFKJE8Cp8w@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <YvMjQSlFKJE8Cp8w@kbusch-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5ab6f64-79c0-4027-6e0a-08da7a8c62d7
x-ms-traffictypediagnostic: MN2PR12MB3263:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1Ztkv77BZ8I2KP9q4kKWEGQFw9fJsf6GaAiKLHFlk16bHvL2faOj5YP17DIuuJAuu9NwbYnmhnNXgDU7Ki3gS1nknoK3W7pBG+SxbU/1Zj6Mi1YQq+9lpAOoQAAJZx81+RxAe3JqX3jBetB07EEJDPLmywP9c0r9xd78os9u3pQ8IeoF3cqZ22lmcEHw3exBEIPauLsrZsBOljRYulgt09K67VlAxLGpWGHr/4tzx7I/Hs0tMBg8a5Jt1C5IDvjHNHceFy3vQUbdGKb04LV+zNaomVcx912ovRcu/CptayS3DJoZGpAfPRh6Qqnx4iuqEF00wF/+7i6EhZp9dHqU6Ya8YP+yBdnaKaSwoPaVGx0EcmI/I8+zBE9ZuP5ymb0BUfgwmSYtr/7A+pNdqZD31FV33O6VEsncUdNci+oDLx0AN150jDyQyCEaDlE1cbAXb+PhpYEY+FYhDYqUsIzhIZqftjXORiBW4nZ/cF/PUab14+BUnF+/BHJb2hdF3+W82B49Wfo4knrX9iDHzhTnLPuB5y/WMm+Hw+hHfNM6gPWALwJ0G1DlF7ASns8jn1B2fpNLSPibnyB8nw42MDovuPTbiBYjShobnKqzgB6qdj1/0Jqk18xK6OLC2dRvqPHDZnwzlW+DkyPbtm147unUHCbMAR4t0sk7bRLYGuUlCAuy6Frz9YrX5RvGGJ3FluLuPIczcBeBQQYMV1DNuYfj34DtvUcaJ6hzrdJS+OcDCotNFSWRn4eVfkDZjvo0It4UgOMH8t5oFr11G8EBzdbsl6iTUJSu8cSJOuj+S0O+fxk8QWwTVzZbdCRpvFt8DCKUi8QYwfQpr7jvIaFyRWwu+WV6Qf25QOLyIrVgXR53dEehWNmBwRO1XgD7PoM2pEnI
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(66556008)(38100700002)(66446008)(71200400001)(66476007)(6486002)(122000001)(64756008)(7416002)(66946007)(558084003)(38070700005)(8676002)(478600001)(5660300002)(31696002)(54906003)(76116006)(86362001)(4326008)(91956017)(316002)(6512007)(31686004)(186003)(2616005)(36756003)(8936002)(6916009)(6506007)(41300700001)(2906002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUc1dUxiU29rR0V6UjlndTNqcExDSGVTOUZiU1l5bk1Jd1VrTWFORVg1SkxB?=
 =?utf-8?B?WUcxeVJqd0Z0QnNwTlNQUkJ0TStRaEZQbHBkeXJ1ZzRGR0xXcWJYOTVaeWRm?=
 =?utf-8?B?SVFWV1BxUU5RSytHV0hhNHFLRmJVb01vM1RYSVZMclNmUmhrY1JtbkU4bnVr?=
 =?utf-8?B?bkM1OUJqL243OGdTZk4rcVFpemJYWGppRGcvODJsOEdlaFIzVFJYMkxEMXhR?=
 =?utf-8?B?QktHaml4RzRvd0ZjTFI2ZWpwb25xRm51RXZhTk5FVGwySnI2YzlJVDRWdmdj?=
 =?utf-8?B?U3g2N05kVW0zbTdadXZtR2lUUFBTcEtGL2x3MnZjeTJxTjVZbEdpaEE3ckV6?=
 =?utf-8?B?VTN4aWkrOTJ6emwzbzhxN3hUdEZLZzRDMjdCcThHUUFBblo1N2RNVkxaam1i?=
 =?utf-8?B?U3dQcnI4ajhldWlBd0lqVVhNQlFxY3F5QVhrRTNUZVM5RXA2cWc3dEY2b21M?=
 =?utf-8?B?UUpneUtKdkU3WHg5VWJCR1VnYVpqR2oraVVWWHRETXh2cFQ2dVovbXBrK2hX?=
 =?utf-8?B?QXR6RTkxNUREeVZDRnprRWN4emlEUjBFODVzOHlYNGtGNWpKdHY5UUZVakph?=
 =?utf-8?B?cTIxcUdrdFhDeEEvWjQ0WGJlTEk1eUZvUXJwa1lVcU5NVW01ZkJaOFFmengv?=
 =?utf-8?B?UG9SZFNyclJ0Q3FkMDJtNU1tV044SzV4eDV4Z1hCbFdwbmYxQzVKdjFuT3A0?=
 =?utf-8?B?dnR2Q1kxZmJIR0VrdzVoWnFBNkxiVnVTN29yZ1F1bzd2NHdFL0JLMTM5UCtx?=
 =?utf-8?B?ditzR1NNRTZ3U2Q5R0xpdEtNd29CTzVSWi9sR24zTnRDWnU0dUpVN2lMRk00?=
 =?utf-8?B?NXpYR1Ftbi8vREZtQkpndVpaY3dyMXFaY0N0ZUovYnZueGNMU2xhYUJNY3Bx?=
 =?utf-8?B?dkdRY1pBMnVMSUxTNnBqeDBzeU5sK3pWbWtSZ3BQRjlMaXJ2dHEyV0RkanEx?=
 =?utf-8?B?VGZNSXBmZGtlNGNaUnVlaGFzTFlwTVdOSDllUUtGQ1ZJVmtFMGZoeHVuY25K?=
 =?utf-8?B?RFU3bVlLUmJLeXkwTHVHYmk4MmdCajY3bmd4UG9HSjRxSE9oNkZDWm1LRUtE?=
 =?utf-8?B?NGc2SFp2ZWhaZWt5ekFwc0ZZRVV3aitGYzZSOTRrb3ViRndDWkdMWU54TU93?=
 =?utf-8?B?cm1pT2xFNE1za3JwcDgvd3hNSTA4bjE3U2R3WmI3Ky84aWxPTFZ4THFyQVQw?=
 =?utf-8?B?YWM3QzQ5YklxeUhUNmxsazdtZEpKRXBzUHd5SDFSY1dWS2tnWWFYUDFvNXRB?=
 =?utf-8?B?VzhqeTU5ZGxMREFCNU5PTlQ1VFVsalNQU2pvNmMvRHdMWmhWa0lacGVlQ1FV?=
 =?utf-8?B?bncvVVJveHdWNHBIdko2UmVSUG5zdmVYempiSXkrYUNaM24rbXpPRVkxWTBh?=
 =?utf-8?B?THp0dkVGRlkxdGRoZUZqZU9ONnNJZHFjY042UlMyZERVajJvdlJEQ2F1K2E4?=
 =?utf-8?B?OVRnMmhiREJISFpROCtvMlNydllGOVIxM1loamdOQ0FLbmJEdVU2VEhveE9w?=
 =?utf-8?B?cTlLYnRYUnBRSERGcnhENXhvN0Q4RWxpN05HZ2pvQ3Izc0R2VnRZSnVTU3Fz?=
 =?utf-8?B?Y3VndUxRcXBCbE9KcVoraFR1c2Vxc0tjVzFBcWtMVWZlVDdKdms4Qno2bVJq?=
 =?utf-8?B?NjVCZlFFWXordkcrMnJjZkNNWlV1STBZRnNDSUxiYjZpRHRJQTFXQ3ZIRER0?=
 =?utf-8?B?UHVQR1dmeVQ2N0tET3daeERFV25LTVQ4RUFpdjZJWDhTcFNoWDQrdlgrcFQ1?=
 =?utf-8?B?R0xieENmZkV3ZG95MG1sQkNZdE56SmN0dVlxOG5PMnZVWTBpVUJ3bjBsTUlx?=
 =?utf-8?B?TGlzOWs4cHQyMTd4YkJJNTI2NnJuT3BSa0hLSlBOcWU3cnArRUMwM3NsZzVF?=
 =?utf-8?B?NTNoMENraHFRTGl1MnNBME4vVHRUS095MDR2d1lxVXVMYkVzVHliUlZmeGU5?=
 =?utf-8?B?cDNKVTdUcmFmSFBlajBsaEovL0tDVGtlaHFtV2VRbHpyVHZ0d3pBWkFFemha?=
 =?utf-8?B?Qjlia1lYTmJDTU9PMWhoZit0Q1UxRDZxTHlNaGtVM1RZQXMxektyK0xmclBI?=
 =?utf-8?B?ZVNrL0p2NVQyMndHQXl3K0hLYjNQZlBjSFVyNHZqSlRoTWRuVWQzVHlQVTJL?=
 =?utf-8?B?Q044anVMbmlDdllzTXdHM2pkMExCcU9HdXBUUUM0YjZLU2VNZ2ZJZ1FVb1A3?=
 =?utf-8?B?OUE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ab6f64-79c0-4027-6e0a-08da7a8c62d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 04:54:19.8485 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0UPfnaoTcJnkUYj9cLoQFcnE71n5yG70gaXGf25Qeb7BfKOHEgd55/yRiCYeMRWuvutVpqps32E7TOnit54XAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3263
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 09/20] nvme: Add helper to execute
 Reservation Report
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>, Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <B1329D89C68561428369DFF7078A0DDF@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> cdw11 is '0' on the 2nd try, and the 'goto' is conditioned on cdw11 being
> non-zero. There's no infinite retry here.

Right I have misread the code, thanks for pointing that out.

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

