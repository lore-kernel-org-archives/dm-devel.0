Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328D3C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119406;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zt2ETRZGjzxA1JAdQUNZc4d3+BkYLDTHeG4KnucU9vA=;
	b=J2a6vjKy2pQcHlLDtQDr+FLCQVqBqtyNmmicv1JRmh+sB7MMJ7FrK/SijsnGDweIOLQ5Y8
	RDtnOZIfm5OCrZMiTs6aaww/8FUtr/viihtzbj9EuisNGDvOSqe/mL21j+8we/+WQs8jsj
	ShdDKLhPfh6bwFJIgLDvvgspZqs0QVI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-P_CbcHRFMOSMkqob0HDiuA-1; Wed, 06 Jul 2022 10:56:39 -0400
X-MC-Unique: P_CbcHRFMOSMkqob0HDiuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0399F9693B3;
	Wed,  6 Jul 2022 14:56:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4331112132C;
	Wed,  6 Jul 2022 14:56:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7F351947B84;
	Wed,  6 Jul 2022 14:56:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C5924194704A
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:41:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A6696492CA3; Tue,  5 Jul 2022 06:41:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A135B492C3B
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:41:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89D88805B98
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:41:20 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam02on2080.outbound.protection.outlook.com [40.107.95.80]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-hi19PKMUPGWs9ygO-3IMeg-1; Tue, 05 Jul 2022 02:41:18 -0400
X-MC-Unique: hi19PKMUPGWs9ygO-3IMeg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL3PR12MB6476.namprd12.prod.outlook.com (2603:10b6:208:3bc::8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 5 Jul
 2022 06:41:16 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:41:16 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
Thread-Index: AQHYj6QAa7pakWbCDUSIqUOKWWrFda1vVSyA
Date: Tue, 5 Jul 2022 06:41:15 +0000
Message-ID: <e77e7fe5-18ac-6df9-cec7-aae187c407d1@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-12-hch@lst.de>
In-Reply-To: <20220704124500.155247-12-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37139bb0-3c73-42d0-df64-08da5e515c54
x-ms-traffictypediagnostic: BL3PR12MB6476:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: epAMUppxWMrGZwfcOAy5W5jDFlq+lwfSsuwVlKrzlpY3PQBeRrVK3+XJoPKhShQh/snWf1zhVQlmduGmyZSbuFqXnhi9pOY/h56AGxDU0DYbMZb7w3KKqlXCgJyLuIsTsWFcepCng1T4x8Nz3AJFiB12OxaZVaKyMInAeFQMHh/OspP/Su6efQk5VkLunvjFh7Wj527fyUQ9akg3CbLqYk8Yu+PVPuAstpIe/vbwdFv79DR0FcZ+Zqnz9Vf16gDDz2RHmLNw6mTPxVfJfTi0c1lpUshB3xvNsuBI8mLFkIWRbXgco+A1MsSf22Jm1XpJHg/PUI4spy7spmeEZc6C0L75ehFyUifTPdxJSgjsabLPrI6pLMbq2/N7KNF2R6nSOsQP4AWIZYa+sNRAlTTF07pKIYFiv+velrNWFKsihLzkTITlggSeSUj1klckm9tP6Wlsy8ifxmhfpOT3zJCF44zs0Fc/4RrypSya6I799JA0capToS3TZdj43XUpMpr7XIXKfyr6Xrz9OubwmZzeeOkki+j/+NFCB9pRYPG2YOOUdFlQe9g4irr1NoHHUb6aiKkaieIt8A9+n/lhwG0PqUxEJ22pX9cpcp1QON9X18E8CuU8Ep6xv0efR1wgi9qCr936sEmuZzvbP+CszE4WcVMeKvLEeXYmEKJX1wfh8mCPQjJbuDHKakJnp5AsA+bwi1ITrH0p7hx5hSWcN/qRNp9AWkuqoGH1mgXyML1Z7q+2Jlp231t66ZZ7aBCvM/zdg+QZ7ozTc7zDowhbNX7SlUtmH4ILLwDg3ScSum8kxEsxjU4iGDfDVgg6+EmIr1/XVFUGsWDoELWBC4mB0/oaqntNveD0S9bXy9tIh+iO1kURZHNh0eyNkMkQht/IE6JW
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(6512007)(71200400001)(66446008)(38070700005)(2906002)(6506007)(478600001)(8676002)(4326008)(53546011)(86362001)(64756008)(41300700001)(31696002)(6486002)(31686004)(558084003)(122000001)(36756003)(186003)(5660300002)(2616005)(54906003)(66476007)(316002)(66556008)(8936002)(38100700002)(76116006)(91956017)(66946007)(110136005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGJYcWlKS3RxRENYU3R6ZVJiblpwSm0xK2xZNkF4RWU1RmhEd04yWWVoR0ls?=
 =?utf-8?B?Y1dSOFo4OWVac3BvYzVRcHp3U2lqRVhvTDkrTm1rQ0w2RTBtRTN6S3RLcjZz?=
 =?utf-8?B?YjhXZkFENi95d3FMNk9pQkFIbEtpdEpBMjA5YjJhdUluZjBCTEQwd1BVYjI2?=
 =?utf-8?B?TkdYc2NES3VlajBzQ0lqaVFLS0hyVnlxN2JabTNyQ3Y3L0c5emp0eVVHb2Nk?=
 =?utf-8?B?NmpDWmo0aTVCNEdXdnBKQlBsRlRqc2R3OW1pT2FRY1lyZDhpR0kwV1I1Y3Nt?=
 =?utf-8?B?UUp2dXlYck5hVUFIaVlaSEwxbTZ2bnBoUWlXQkZNRXhrVkFoemNwaVpnemFI?=
 =?utf-8?B?RmZoL1Z5VkZteithVERISkJySVlmajB1MGFXd2dQMmg4WGtIdlpua1A4V0Z3?=
 =?utf-8?B?WTR1ZUYxZVdBK2NkMXYyeG1uOTFFTHZJN3hDNllwRkt2N1k5YzJpbWxLWVZY?=
 =?utf-8?B?UWhvSW9NTFd1azdIajZ5TjhyUmJPYXhkSzNRMEJsWHNzTTVBd3hYZ2ZOSlMz?=
 =?utf-8?B?aE54elJTTHFneWNZK3k3MnE0ZENJeHNmaTF6bW9iZDM3QnFOc2diZUtZeTMy?=
 =?utf-8?B?NUVIM29tUlBGQVdwcnM3MXFzT0dManV5S1FBWXNpQS8rNEhIQUVqcG8xS3pO?=
 =?utf-8?B?T0E5S3l2Q3ZqZHpOcVVWckE4RTY5Y3p1eldPM1owSVFScnVsUEViMXAwMGRj?=
 =?utf-8?B?S3JaRHJFY2piSkxuYTdvQmRCQzJDTGFRQk44aldkRU8zS0pXa21hYkpnb1RO?=
 =?utf-8?B?cUc3eWdLaTgyQ0xXdm0ybngwd3hSQ0U5bXhlNnRJZTgxNG1xejNNY05JV2ZG?=
 =?utf-8?B?bWJyQ2dRVE1SUWpaNmw4Y1ZjNGowVGV1R0R5QzZJZkZVSllaeGZNWjdISFJX?=
 =?utf-8?B?K2NIRElRZ1d2SndNZHI0Z0dpbzdZQWtIbmFONm44M0RzeDJjY24zNWFVbnhM?=
 =?utf-8?B?Y3k0dEs2WWZUUEh3YmtTcDNhRWx2bW1FdUtoR2NCQmd3TTlQUU12OU1Hc0ly?=
 =?utf-8?B?YW85c3ZxK1BJc0hxZlJLSHFUYitkQnF1KzE5UWZrOTFROGx1NmpzQ3JvMmhh?=
 =?utf-8?B?QVFkOHQ0NExZMmc0aTlkbm11eXF5S0lRVkZ4L3ZXMjkwMzdTcnNGYVRPYnRD?=
 =?utf-8?B?Z01HNDVlRWNSRzZpVWt5dFdTUzlKREU3aGFYTUw5UklRRnBtZ213YkhEZndk?=
 =?utf-8?B?QWZJSHI4aHlsQnFJam9XWElvME9icUVOUVpiQitiSmxEUWJMcW5aQzBQc3Bl?=
 =?utf-8?B?ZHZCVU8wZXhNZkRRQ0hWaktZOXgzMXo4R0ZDckZRd0h0eXV3a3dpZmhkK3dk?=
 =?utf-8?B?U0hqTGN0VmdtYWh2OW9KOGpHcCtHOXFuWmFJMFk0K3kwbU5jUW9ZWTVzSERJ?=
 =?utf-8?B?USt3VWRUL0FFQUQ4bTVWT1hYR1g2a2FrcEVjVTZNMW5mNy9EOGE2clFZQ29P?=
 =?utf-8?B?dWZYL05yc3JROFpoTXdxdktVaDBxVlNBYTZGUWowLzNHWVdpM0NUZm1uZi9k?=
 =?utf-8?B?OFhEcGxyZWVleCtRMWYvRWZYQVViTStyOVFtQzBOMkhnOVBWMzluUVp1blhK?=
 =?utf-8?B?K3J3RzNWK1ZEZjkwQ0pEMW1Ma0tYQW1aVFN3ZERZdk5GNlYzVnlpUnp5Z2cx?=
 =?utf-8?B?UUwzaU5ybVVOLzZKQnl3WU5VNnhURGxORkxQeXk5azRRY0pMMm55T3FzODN5?=
 =?utf-8?B?TkdRbmhFejNrWU0zN2pERmRJQWhKeVF0SzJZdlQ1dm1OamQ1MFRDNGUrcUxz?=
 =?utf-8?B?Y1JySENJOW1pbFZhVnU1bG52a2lXeXZpYnA1Z2tuN3oxMzJuTHNqMFlHRDI0?=
 =?utf-8?B?MVd1Tm8wSjVhc0p2TGtoZ0p2NFhuMmFJTkdPUy9kS0E4N1gveXVmUC81Uml2?=
 =?utf-8?B?U2o1eS9HYWJUQkttTU1tN0F1ZVMrNDRSZ2FKM29mQURlY2lBK1NjUjFock5C?=
 =?utf-8?B?eUcwd1ZhTFBvS0NhZHh4UkpEbmFScmZ0aU44d1NhYnM0RUxPbXE5UlpvajBC?=
 =?utf-8?B?cGdFbWpUK1hSZG42RTdMTEtBY1BiYzI1Rlc5cHRlVS9uL21kS0dQcDhCUjNj?=
 =?utf-8?B?N3VqelNhS1J1Z2R6aTZESXVWQjZWTW9LZ0c1Mm1NV3hlL2VQWWtGWEl0WXNC?=
 =?utf-8?B?TmlTT0pxWW44eUJVZWI5aVI3ZkZUNkJNVExpK1hTeEdjWm9NSytsUDVVTVNU?=
 =?utf-8?Q?sJNVxD7+1LBSrkpDcnuAesZOEmhtrY7NYf1qbm/bqF7d?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37139bb0-3c73-42d0-df64-08da5e515c54
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:41:16.0149 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: POyt1CwQcz+/F3BTcT8IAXKKWlmaBRS1CkzZfWUpATZQndlVmALTK79M3HiaO4T8x76MqjwGIfzo33mzSeKS8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6476
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <15DD4FE94A7CEB41ABE772FC197808C2@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> Always use the bdev based helpers instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

