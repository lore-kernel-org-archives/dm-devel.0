Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86268C77B61
	for <dm-devel@archiver.kernel.org>; Sat,  8 Apr 2023 08:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680941145;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EWF/MStRLokYReMwsoCdU7BJZ6fQ95dYcyYOo+C1fMU=;
	b=fooDh0W8dkKd72d9qXNrHHgiyW8i7p7RcMYvtwGO//S77XP3U2M/KkHtNfNF4znBijAyoO
	qIbcLGcJaqotcbpEelcaNs+QI9yw5GI3vom7rLOXK0LWYlICgg/igix46+6SVDAYBT9dZN
	ERyeaAQMA9PPaF6cK/vfj6GZk9UWcXo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-hawk5P9FOsuDAm7BAex_ew-1; Sat, 08 Apr 2023 04:05:42 -0400
X-MC-Unique: hawk5P9FOsuDAm7BAex_ew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F363185A78F;
	Sat,  8 Apr 2023 08:05:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 176841121314;
	Sat,  8 Apr 2023 08:05:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF01619465B2;
	Sat,  8 Apr 2023 08:05:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 565E319465B2
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Apr 2023 08:05:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B4FD492C1B; Sat,  8 Apr 2023 08:05:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31875492C3A
 for <dm-devel@redhat.com>; Sat,  8 Apr 2023 08:05:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E91BF185A78F
 for <dm-devel@redhat.com>; Sat,  8 Apr 2023 08:05:29 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-4Nbppto-MXufhrCCeol3XA-1; Sat, 08 Apr 2023 04:05:27 -0400
X-MC-Unique: 4Nbppto-MXufhrCCeol3XA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SA1PR12MB6920.namprd12.prod.outlook.com (2603:10b6:806:258::5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Sat, 8 Apr
 2023 08:05:26 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6277.034; Sat, 8 Apr 2023
 08:05:26 +0000
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
Thread-Topic: [PATCH v6 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
Thread-Index: AQHZaYxrwFmZ/Fcz9kCsacyH6PEO4K8hDqaA
Date: Sat, 8 Apr 2023 08:05:25 +0000
Message-ID: <6373054b-b7d4-6cb4-1a88-35f69d1e9cc3@nvidia.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-3-michael.christie@oracle.com>
In-Reply-To: <20230407200551.12660-3-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SA1PR12MB6920:EE_
x-ms-office365-filtering-correlation-id: 636594a8-36c1-446c-3de5-08db380802bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: iAgi9tc05pn9JZSUL69GM4Ch+bUrvIqLX74uXyb3AFVCOPOgUVyn9GWgiI77PfFV/umC2m0AD8ghzeUU4d44qrd7JKYGtERLZHQlEVlF3qWzbLd2pPeELfqGz4vsbWdbnddlndq62lgrA+pO3m20VnD9uE8DdQi9zCHR3nzz+udrL5XCXckZoVZ5R70rXgz7aM8XbgoBBnlaqHtddC7UQSccW/a73hVzWio5e275uZyqOSGm1suT7P6FdKfaTwsONAwDizaQ/l/HqsYF/V2ORsLlKVIzxW+OFgyNBxq1C88RIjnnnP8wHk+qenH+KWVSpDJswua7voLUqjNC0iISHY1nxIJGDvevi0vyF/k+BHLyFVEXFIfXn1BEDx835mPu5BoDmzRRVvfg4MwPki9tDErNrJDrLUw05a7TWi+RClJu4U7qGJYVSNDJSWWFC58M/ZIVQDaefFdXQDjXNqO4B1ia+mTBBnoUk+v0yFCU60Y7or+Br4Jnqzq/hzNK2NQjeblUXFG2dihm8gPXIuZJJmQXQ2Qgvyjvb+ZkNmASFHoMsQyrFyOd+a76G/XBk0ipYe8XijSc4QhQ6554P6AEW0pBJihNHebT/+DvEsFW+TuEY1pA7IBW+xdPsOT5JKZLzToWdMcufdfnq76/wFiqLbyMWPAI/KlTnI03oxfXcWN4+Xk9U0FqJt2nLJp+NqEGhDiNbasQqzpsosgP0I15Wg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(921005)(122000001)(38070700005)(36756003)(38100700002)(31696002)(71200400001)(86362001)(6512007)(6506007)(53546011)(2906002)(66946007)(4326008)(66556008)(41300700001)(66446008)(66476007)(8676002)(64756008)(478600001)(7416002)(5660300002)(31686004)(8936002)(316002)(91956017)(4744005)(6486002)(110136005)(83380400001)(76116006)(186003)(2616005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0dMbXBkb0F5SXdvMWpZSW5Ydyt2VVNGZEtvcHhjRmNKUjh6enN4bWdkT2lO?=
 =?utf-8?B?blRqTFhXSGw2V21Nb2xwWk11cGVHSndxV250Ri9mU0w0MThCbFk5bC8xWmJQ?=
 =?utf-8?B?WUdvODJmay9VeEZLRFhLVTh0Q2ltL2VuSmF4bjBDY1VHT3YyTlgyeXpXTlhD?=
 =?utf-8?B?NUFlNHBuaUg5R0I3Y3NnTFkvdE5PeFp4MVhKck0rU0lYTkg1cVNnOFp2Yngv?=
 =?utf-8?B?RHBNbXB3WFZHYWdpZEEyMUF3My9VSm5SYm1wdnViZEIxd0ZjYlovWmNvL3lB?=
 =?utf-8?B?VzBqWWw5Q2x3bGRTdXdRbkRhQ1RBUzh6N1dVd056VElSbVpoNnhkZW8rc0t3?=
 =?utf-8?B?c1VyanV4N3NDMk03b3pUY3VuQnpBODJRQW1xQmRUVWU1UjJmeG5NZkFWNkEz?=
 =?utf-8?B?T0thcXJkc1NzeG0ra2ZkRVNqeTMvMms1bHhpN2xVTVN4ZExzTUNVOU56Vzcx?=
 =?utf-8?B?eHBkaWloT1ovRSt2TjNlZUlWd3AyYzN0cDRtVDZ3VnRuczM0ZitFaTErR2hz?=
 =?utf-8?B?SlpYT3p2c09Lak9VMEdMTjFjVGc1VitnZWNkYXN6dytXU05IOGRtUU1kRHpt?=
 =?utf-8?B?Q0l0TXRzaFpYN3dySHcxeVplUHJVWFUzVVRlTE9MNG45RmRCQktZaFE3NExi?=
 =?utf-8?B?VFl6MnNYdnZSaEJLK1FtU3dSaS96TDFIbUkvZlNVNlFMMnRLYUJremsrMVpp?=
 =?utf-8?B?YnhZSzhOSHhrTEh6Mno3cGdIN3AyaXRpUEpIa2lMQmp1SDk3NG8xY2V2ejVa?=
 =?utf-8?B?MENoUGdaeExySTBIa3pMMmFFSVo0endhSUIxMGl3a3ZPTGxrQUoxa0lOOGN3?=
 =?utf-8?B?YXdweGtkN2l6elZvbDRvbEpxemJFQ1dTVHJDVm5VMDkyRWk3cGNaSm1tUnlI?=
 =?utf-8?B?dGluWkJFa3dZRkJTemdQcjZtVldiTTFQYWF2ZE5ubVhhdU5mRjBiM1p3Nk12?=
 =?utf-8?B?dnEyS2JPT1FUL3dLSy9ydXI4d1ZMQXNwTlRJRlVmbktuRGY4bFNKS0VFQnRw?=
 =?utf-8?B?d0JORE1EZVBaWGdQcnF6Y3pIU1FoTk9JRjl1bUk2Y1dsUmE1WEtYWG9FMUNo?=
 =?utf-8?B?ZVFiZDl4cFRQS3FUZ1N1YU9nZkhQSnAyNGk3b2hrRGkwQUp0WGNMZ3FWWUhs?=
 =?utf-8?B?RWwydTBkTHArRTFXYU9OMmgrdndDbEV5YXBiS3hLUVBjODlZNDJScDVnYkxC?=
 =?utf-8?B?OE9PZ3NsdGVhWVplRlpLNHVYemwvcnlmVUlQdFQ1VGFNb3VkRkNJeWRxY1BJ?=
 =?utf-8?B?ZVJxRW9mTFpLbDBuRWlncVNLRVd4M2E0eERTa3J1WFF2Y2c0SEFSWUNZVWda?=
 =?utf-8?B?dUdNMDZJSy8yNitsMThDaXJWdHVwd1Flb21CQk1pOXhEUmtLUHRPWmZ2cHJ0?=
 =?utf-8?B?dXBFVjhZbUU3TUh2SnVzb0gyR0l0U2dlbzE5NWRJbWo1bk1GbXAyVjAzVnZV?=
 =?utf-8?B?SnZYTjllVmZJVGlzcVo5UXpGUTdUSzBLQ3RNcUYveHZ3NE5vQ3B2bkxSZGVo?=
 =?utf-8?B?YzRFSUFyam5mVlZIWkZZRGJqTlJ3Y3k2RmRISVYxdit4enZtdE9CZHlXNDRG?=
 =?utf-8?B?Y3FzMlJPemFWcHBsWXJGU2NjVUVaclFTOXFtZllsd2pyMFBoUUNocGlHS0dm?=
 =?utf-8?B?Tk1GN0xEU3ExY3pjWnN4TUY2RTNDSjNRa3lVcG43MUJXZUdHbXloaE9UUlZB?=
 =?utf-8?B?OFRCTXREbld1MDRhQUFsUXh6bzk1SWRVdGlmdGw5aHN2TFo3ejRaa0tmU0dH?=
 =?utf-8?B?L0ZVVEhld1VFOGw1UERqYlhvMkhTSFhhZUFURVZ1WUIvd2ErUFNoZG8xZjd0?=
 =?utf-8?B?Nnk3a1c3dVU5UXIzRmtmYmZtUkNra3p1aHRCSytJQzRLTnVJbytCU25wZUE0?=
 =?utf-8?B?TXJKcDR2TkFmTHgrWWEwbWxYVHNYUC9mRzJ4N2VkeUVGMUlPRGlBTEpLTEl2?=
 =?utf-8?B?NElyaGFzZVV3SkVFakh6WVJxbnAwM0RMaVdJa0JwNkIxU3ZOdFdoclBONXJN?=
 =?utf-8?B?djF4U2o4QkVJc0F4RTJoYlVxaHcxdHY3Q3R4dGs5OVFzY0trQWI3N0ZSWUdQ?=
 =?utf-8?B?S1k3ZVIvZVpZMnh3RjlFajJJQ0tVMjhTZlFJbml3NGg1UGRqVVZuVXFFYXVN?=
 =?utf-8?B?bGJ0cnZMTTlhdFBrVUxIc3VoNzFxbzcreG5uQ3QyZDA3MGRvQ1k2ZEppYkdj?=
 =?utf-8?Q?3TwKfLuJNuGfaVMrmt8btDvOvQZycXuaeb9MLnd771p6?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636594a8-36c1-446c-3de5-08db380802bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2023 08:05:25.9585 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mm9zIpS1vx8FMv0s5cfy7XCioZH/W3uU30HCOmT0lGV9PuBA5InvBxMBMqz6Qm2Ho6bfAdUnATdvYV7bnn4pFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6920
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v6 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
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
Cc: Stefan Haberland <sth@linux.ibm.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: nvidia.com
Content-Language: en-US
Content-ID: <BB7FE23BCE74BD4182FB6A0CFF66F14A@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/7/23 13:05, Mike Christie wrote:
> BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts and DASD's
> locking feature which works similar to NVMe/SCSI reservations where a
> host can get a lock on a device and when the lock is taken it will get
> failures.
>
> This patch renames BLK_STS_NEXUS so it better reflects this type of
> use.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Acked-by: Stefan Haberland <sth@linux.ibm.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

