Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E2D7C77B6C
	for <dm-devel@archiver.kernel.org>; Sat,  8 Apr 2023 08:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680941489;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HK/tMRVdr4ZQgpnrZdVFSUiVlEfHEsLVYl0LO9n9pzY=;
	b=BphlhqmaXjHx1s98SFBMlnAicFRcyXT04SuCPe9/kDuz5u9/qUI5YZR2VMQDm94+YnOKfq
	LhGK2NTB1UpnPKaX1U31lp1nbJ+RZKGdGaZLfBkfS72uWqZOfI6nwnEG+fwEefCDmI1yRK
	ByjyMw+3fBL4wfSTjXINXIVgtrhsUEo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-mMA__zKkNgGQIdqPTX_heA-1; Sat, 08 Apr 2023 04:11:25 -0400
X-MC-Unique: mMA__zKkNgGQIdqPTX_heA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22C53101A550;
	Sat,  8 Apr 2023 08:11:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1DD740C20FA;
	Sat,  8 Apr 2023 08:11:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 86BEF19465B2;
	Sat,  8 Apr 2023 08:11:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EA9A11946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Apr 2023 08:11:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C947A202717C; Sat,  8 Apr 2023 08:11:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C0B682027144
 for <dm-devel@redhat.com>; Sat,  8 Apr 2023 08:11:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A266585C064
 for <dm-devel@redhat.com>; Sat,  8 Apr 2023 08:11:22 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-tEvXiQhYNw-bXE4xhCPL0Q-1; Sat, 08 Apr 2023 04:11:20 -0400
X-MC-Unique: tEvXiQhYNw-bXE4xhCPL0Q-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SA3PR12MB7949.namprd12.prod.outlook.com (2603:10b6:806:31a::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Sat, 8 Apr
 2023 08:11:16 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6277.034; Sat, 8 Apr 2023
 08:11:15 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, "bvanassche@acm.org"
 <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>, "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Thread-Topic: [PATCH v6 11/18] nvme: Add pr_ops read_keys support
Thread-Index: AQHZaYx/BRiymJpxckaUc2JqxBvkra8hEEeA
Date: Sat, 8 Apr 2023 08:11:15 +0000
Message-ID: <ffba8985-d0fb-8962-5553-262fa2b225fe@nvidia.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-12-michael.christie@oracle.com>
In-Reply-To: <20230407200551.12660-12-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SA3PR12MB7949:EE_
x-ms-office365-filtering-correlation-id: c0aa2ba1-744f-4bc2-4058-08db3808d2ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /PHmxWl3vxWhVamOD/CIK7xhqL3X6WGaD6+igrSxcmKxnWvJ2kZuwPdY0mRKX0Uu1Ir9huIDqz1zL/QAFFTTcPdw78wzcmN64My3jeVa1gVnyld3YXEmufWkDRL7VYaJZIYyZrpyyELq4yLnH52lc1mgJAqShW7bWLC5jgvPOkQnjSpD1E+L9KdnDtK/lwYQElGMIhovHroEpIMceiny0KkGKGlO+/gMmoIcU1A2KpjqWH6urH3019pPktZvCpmWA9OmHST66P4PJv8Ofc9XM3giNE54fjMqUdIICEf32c81ZzZQmmrMGIubqDyS9HwSp583oHs6DYkCz3sxjYv8AfVGWLQLRuIcwUYX+UDswlYXQKNFUFTxllu38b/Um0J8DWO2pBPrJtiSc53v3Cu8OKI+Ufzk5tARHxu3vv/DYCeHRdR4stnnISJ5wC81i0+edggI+2CuZt+7YUfaN0Ft7FzA+J43zS5DtHx7ZyvNEStTsTaE/wibURV49PO4vud2lyFLzlnpdqSdzu8xthQOUCPvBfrg2c9XbDxzQeta9RRco1p5dgdtUOG8XzylTuRDWN60tW7rOudqDEnVzVXvXpCDjLY+9/Jrcvv38w8kL6N+I+y2Mj53WplGmr0+NfS5C39rn4vWHSzglqgz8u53ZeQuNjjHArVnPlgZUGA+L+kB6unDXKq2ekLp6wyohpmTCkGpOgJi/2wWEuPMi/sj4w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199021)(86362001)(31696002)(36756003)(91956017)(110136005)(316002)(41300700001)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(6486002)(478600001)(71200400001)(5660300002)(7416002)(2906002)(8936002)(4744005)(38100700002)(38070700005)(921005)(186003)(122000001)(53546011)(6512007)(6506007)(2616005)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ui9CS21sUnpIZTl3UHJJdXVHejA2T0cvY1VNN0F1dE5BYzJhK0x4Z3gyYndV?=
 =?utf-8?B?UDRTWXhpV3ZWWGFWZ1hNRkxKV3A1VlI0VFVSSFpTMGE3d29Yb1FYdTNzdkx4?=
 =?utf-8?B?MzZBQjhlcWdpZlBtLzZlc3doL3JtaENXTXhZZHQ1Q1VsNXZCMjhhZk0yNnN1?=
 =?utf-8?B?UmNNYVdERjRvSjgyRG4yWlp0Q2ZoUU1wV0JIc1VpVFFKYi92UzVwVVRWekFr?=
 =?utf-8?B?L3FXTUI5eXRhbk9GNm52RGRqeVJhZ3VYNUNheHV6K0ZSTEZOK3lXL3lMV24y?=
 =?utf-8?B?T2ZmYXdZMDFYUUdLL1VNbG5ZTW42dk56U1VoZExjR1FTQllWVVRxZkIvQkdY?=
 =?utf-8?B?OHBFRUlsSDlyRjFoU0JqUGJxZDExWmQwVlZaUkdvSXVnNll2RG5nQmJjcUEz?=
 =?utf-8?B?QjlsMVhkT0E1QVNuUllJMnh1UXNaRUQ0d01yS1VHYWFVWUhaeHppSXlvcXBn?=
 =?utf-8?B?VkVrS2FkM2EwKzVLc25qN3F0MVJ0UllhZ21pR2F2dDdoTnBBbVBPT1VBcE4z?=
 =?utf-8?B?V2NWbStxSE5MdGhOZ3BISzhtM1hXdUFsRXNXRkNBK1hYWkJpNGU4NnlWSmlN?=
 =?utf-8?B?NjlxM2Fjbi91UUVNOWQrUFg0MmFIVGl5Sjk2a0p3K3lNOEVOcTV2eEpvQlZI?=
 =?utf-8?B?bEhkRU5Pclp1S2plZ3hxOWdyT0Npc1dMR1d5Z0JucGdJYVBlYWswblVmZVRy?=
 =?utf-8?B?Z25Vdm1GblRlN1R6SGlhQzlDemxvdytHQ25kTjlsVThxNGs0ei9GYzhZMHk5?=
 =?utf-8?B?MHJONlpLNW9ETDhvVmZhSHJsMWp6Q3pXcVVEblBUZm50ZUZ6L2p1eEFHMVZE?=
 =?utf-8?B?YW9HRVo0NEN5aUF2UTU2MVJJbjZSWlRwaUh6VHlhVnJzZndvekdsQ2VMNkZ1?=
 =?utf-8?B?T2YrdktzTXNSaTRzMklrdDlGTGRJY2FkLzJ5SEExdkxvOGpUOUZ5L2FIMWM3?=
 =?utf-8?B?NHpnMUdXYVR4ZFN2WWhOM1Jabld1Tnk5UDEwRFp3dlJ1VWdTb0VLUnNpK0hP?=
 =?utf-8?B?Um82YytCU1lLUW9iOHNQaWFwMmxEYkVCT3dvREtEUHc2K0poMWNRY05pYkR0?=
 =?utf-8?B?emZzZTBQbEhpMjRQSlNBa1RrUkJtWXQzcExxY21QUlhGdFp5R3B2ZGkrUFZD?=
 =?utf-8?B?ODZoOEN1RFE0clA1QjkvNXM0UjdmVk9JdzhYZU82ZXlhemNUTG5GQ1Y0VmE4?=
 =?utf-8?B?R2xKVjFhdkVENTN2RUFJU2Mxb3JtczVrQ2t0Rm5DMnZpWS8vMTZvc2ZMM1lN?=
 =?utf-8?B?aHJaTnRqMmQ4ODZLRHhKM1N0ZEwyWENBU1RTMG9KMU5UeDBHT0ZoaS9rS2Fk?=
 =?utf-8?B?YjZZbDVWak1zZkMzN0FGWWszaVJrYWg5L3VqcS83UDkwWDJtNWNEeklnY2tj?=
 =?utf-8?B?Zzg5bUlPT1NobzVTNmJVR1pzU3pVcGhQSTk0eDVpUnR6MGI0Y1U3c0xESTNU?=
 =?utf-8?B?LzgzVU1taTFzUmw3NDhZR1FydUl1UXczM1crZWJEZlNYQ1NLZlZwbkdXbHVI?=
 =?utf-8?B?LzM1MzlOQWhjcW5DbW1CUWF6YkxpOEtBd3Rqa21PT1FkSWlaMzRXbjhpeENY?=
 =?utf-8?B?UDA4R1IyNkJWemd0bWtmam5xcWozd3BOTGZzTnpEWGJQMnVKbGFQMkNTRTVQ?=
 =?utf-8?B?TkhyNVZwenh5cjAzV1piSnh0OGo0c0pHeFFtUHM5NU5KZm1SdkNIdFB5Tm44?=
 =?utf-8?B?T3FzazNiUDJHZjgzdHQ5cnlvVmVPelhUVmtLOEpCRlJwM0owY1owRDVXcTNU?=
 =?utf-8?B?aXhKNHVXL2duYkxNY2ZiTzkxUnI5WEszeTVyS3RDampLdDQxRmFOY3JLWjZB?=
 =?utf-8?B?bjlJR2VQZEhhdS9HejJUOXVXL1pCNkhzdjBvWG9kUG5aSHRINUJVcU1lWUto?=
 =?utf-8?B?ZUJGNllpOTM0NXFQR0lmcFErb1hUWWtGUk1WV0gvbVNLSzk2TE82RWdkMXBN?=
 =?utf-8?B?d1VLZEt3ckZVZmg5Ri83YURVc0VoU011eEdlV2JMdUNmYVB3Ym41bmpLQW9r?=
 =?utf-8?B?VGh1TEZqN0dwM1lvQWhlUmszU0VpUDV1a2syRVV0dXVsY0VZYW5HempaZ05q?=
 =?utf-8?B?NUhuVTZCV3hnOElZdE8yYWtNTUtvOHdtcjhUV240dTd1U2o5WkpOaU14WkZX?=
 =?utf-8?B?SW0ybFgwa2NqQkw3M1lIY1RtcElRbS83aVYwQTZRM25sbnIyQ3pjTDRDYnRJ?=
 =?utf-8?Q?4t3gfnAogUKEkeJneMKLiNdYaRymEbqpoxCITOtJ5U3L?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0aa2ba1-744f-4bc2-4058-08db3808d2ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2023 08:11:15.3611 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ZL0MfNqzKZLRoDqpMsFVwAN851ziEF+EYDXkBWuPU6JTecwhgOuof5DKSUGkzAJTw7PrfU+fFaXB9mYGI6efQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7949
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v6 11/18] nvme: Add pr_ops read_keys support
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: nvidia.com
Content-Language: en-US
Content-ID: <87A0EDDB0D07FC499BA23FEAA0C34355@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/7/23 13:05, Mike Christie wrote:
> This patch adds support for the pr_ops read_keys callout by calling the
> NVMe Reservation Report helper, then parsing that info to get the
> controller's registered keys. Because the callout is only used in the
> kernel where the callers, like LIO, do not know about controller/host IDs,
> the callout just returns the registered keys which is required by the SCSI
> PR in READ KEYS command.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

