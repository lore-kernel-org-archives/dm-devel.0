Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF94C77B61
	for <dm-devel@archiver.kernel.org>; Thu, 13 Apr 2023 06:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681367314;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ai10KUaK10Lx6sVVfLwgFcgR6AIn7+vw4AI6MPddXO4=;
	b=ZHAmwvoW2yN3mWZqnquJbSmAil09/uQR9iroltKjW/IDIWHul+FFyzSSOF8IBAvaKrmYSA
	6LOxIGlS7AHcqq5cL/pKFEFze6qbdeZ45NxQuQYVX3NqOkIMWMbBNlA3ESykvBhQ1lLrQN
	Aj03cKyKuCJWaSHXd1U9oJWT8PR7Lks=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-6PY7n2DPO960JVmjbmKIbg-1; Thu, 13 Apr 2023 02:28:32 -0400
X-MC-Unique: 6PY7n2DPO960JVmjbmKIbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A98A101A54F;
	Thu, 13 Apr 2023 06:28:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8767C47CE1;
	Thu, 13 Apr 2023 06:28:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52A9D19465A2;
	Thu, 13 Apr 2023 06:28:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 499151946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Apr 2023 06:28:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 396522166B29; Thu, 13 Apr 2023 06:28:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 314812166B26
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 06:28:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E2A4185A78B
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 06:28:27 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-6UifMC01PnStvrSwkW5jbg-1; Thu, 13 Apr 2023 02:28:23 -0400
X-MC-Unique: 6UifMC01PnStvrSwkW5jbg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH3PR12MB7761.namprd12.prod.outlook.com (2603:10b6:610:14e::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 06:28:20 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 06:28:20 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, James Smart
 <james.smart@broadcom.com>, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>
Thread-Topic: [PATCH v9 9/9] null_blk: add support for copy offload
Thread-Index: AQHZbE5nst5YOYqA/020poicHbZ9H68oyaoA
Date: Thu, 13 Apr 2023 06:28:20 +0000
Message-ID: <b8eb491b-ecb6-c559-1340-9984897f2aa4@nvidia.com>
References: <20230411081041.5328-1-anuj20.g@samsung.com>
 <CGME20230411081400epcas5p151186138b36daf361520b08618300502@epcas5p1.samsung.com>
 <20230411081041.5328-10-anuj20.g@samsung.com>
In-Reply-To: <20230411081041.5328-10-anuj20.g@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CH3PR12MB7761:EE_
x-ms-office365-filtering-correlation-id: da22d29b-b61f-40b7-acb1-08db3be84676
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ixTpiDzlma0BGpv0nfJoO54r3/+qAiZtyRMPM2e31890DOafLV/BsVO6f4W0uGPAgMsp+YGxZrOYXFnQONu5HZUFpJJjD70O0PeX9T0fWdh6w90MVXkQSkYQdsiIDfhEbGInhWovQ9NPL3/fgIKau4LEpJTkDquJxOQqlFP/s3MTpr35yEQBbk+4aXxONDFr+sh/Ey6qpYEb13OK1atOjA0pw206utzLqoqlzEtUbrxcDEM12ZCU6Ai5JTQTPsq8t4XLMATYIzv6JBEk9d1K9hiRNPReUtAPsOXcPtv70zp4C0snZJMvlcnI0c4wlMJjRsp+EmhyMZn4rLDi2IKDpI/0x5lQLS1/gr1H/7tEfR9aStKyX/CuEp1CrgDtIlzrnxlJ9/xlTfldnE0aq3a3WwqCrCrud3g59KKdAJ6B/Vj40V7dz+blcbpu3BbSdQzfn1Yv7tTvVag2O7dDuh0fWCVtv2s1fbIjqPpLO2OkKQJa5B5CChCLhD65iUr1PsXcD6tW+qLVItRRf65Ejh+qnP3zN0rUp2jiOj4nSqk6gKaamF3BAY53rWBg69vVZe878YDv0YAPuccv6NXPLW/dxu5STnLKSv5oIH0h2yBWiif9pbCpSvCgSApcF6r6ORw5cafCbmfJBTZLY0Lmg97zOBuoPlbCNHaWpcz7ZDvkP6P73kNM8uG8e4XcIlz/8iC32OEXMO9AoMvN0ozg3+N7JQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199021)(8676002)(186003)(8936002)(38100700002)(6506007)(6512007)(53546011)(478600001)(316002)(31696002)(54906003)(86362001)(921005)(76116006)(66946007)(91956017)(110136005)(6486002)(64756008)(4326008)(66556008)(66476007)(36756003)(66446008)(71200400001)(41300700001)(7416002)(122000001)(2616005)(83380400001)(31686004)(38070700005)(5660300002)(2906002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eExaYndSbXZLcU9SeVJTTVZjYmd1WmhlOEZleFFTU1h4VTJKc2FIZkdnVUsy?=
 =?utf-8?B?cHJRTnY3STIrQjFvemMxOTN3RUQ2SElJN2dqbUxuZW9sL0FCTWZvcTdwejRC?=
 =?utf-8?B?ZVhzM3p0ZjlSRmhpcHpvcDNZOW9wZ1JOY3M0dVU4NW1CL2ZNTU5hMVRYbUgy?=
 =?utf-8?B?K0o0MlFZcDhEQmVOZVVoQlIxbHRHM3ZvR3RDbDlWZkR6RG9EVkZDQUJ3eGtL?=
 =?utf-8?B?TlFOVUQxL3VsL2M1bTlreStsaUY0aGJISG9YZzZCTUhMRGxDbUgyZUk3ZHRp?=
 =?utf-8?B?R0VlMlpwVkVSdEhWdlpJTVd1YVJhZDRHcU5CU0dpVi9GVnJUMnRzd3RQcUtK?=
 =?utf-8?B?Rm42S3dmVjg5Z1oxdndXNUZqdjBXcDRLN2pqbzdvQnFnSnhrUE1keHZKdkVh?=
 =?utf-8?B?a1VOOER2WjhzaDZwMkZ3cFhmNUI3c2RWTnY3bXYyT0pyMmFOK05IYUlqZDdy?=
 =?utf-8?B?S1g1UE1SVEtDL3NiSncyaDVrVys5VjU5VkozdC9Kajh3UXg5Yy9NOXhuUWlw?=
 =?utf-8?B?cUlSMm01b3RhZDFvZ3B2RXBPYzVKekRjcFhNcEpLNUFoQ2xKWXlkdEpNTXdC?=
 =?utf-8?B?VmhZU1lDWkYzd0hDeHVSaE1CdTNJczI3REdFN1RLRnNkZ3pnWHZHR3lBWUJ6?=
 =?utf-8?B?OExrSHlhZEZpVzBVTklGUE9lNGVFUTU4azgwOThiM1NBME41TWRRMTBsajQ0?=
 =?utf-8?B?UzZxcW1ncDhuNjkxbmxtVFRMOExUdGp4ZVpKL200WDFaUXBOL1M1c240Ukxt?=
 =?utf-8?B?MHpJVXpCdmJhbC9pSGt2VVlDM3RPaklPdnMwaGhsLzZoMi9aVjFvWXNLNGVV?=
 =?utf-8?B?RTMraUNnQXJncHZUWU0vQ2p1MWoyVDR3OHFoRlFyZzhCTGF6TVNIMmhGeUVp?=
 =?utf-8?B?UFp3L3VHTnBWcThxTVpFRW8vMHZWZTJ5RVU4SU1lQWxnS1Q4TGhQVm94Ym5P?=
 =?utf-8?B?Y0pFd3Nja0srSWVjaWhUaXlVMUViZVd2Vm9hMVY1UW5IVzlhVmtHdEJEK2hk?=
 =?utf-8?B?VGlYcG5PajVEcytOWkZVRWM1dmt4TitHYm0rdUp3SEZsWjRmbDREeXRCUFpm?=
 =?utf-8?B?OCtCYjFiVFcrWlhFWDdTMDFOSktvanZTNW1ZUlViRXRBUytPUEJ6dW1FbHpp?=
 =?utf-8?B?L0xMSWdRNGQ1MVdmMFE2WEg5WGhEbk5UVHNGVXZFU1pwdG94bFJWa1BtaStv?=
 =?utf-8?B?UWUxM1RHSnpCeVpWSWNrbHJEVmhxSzd5WStDdXZvM0VXc1VwUGlBMk1iNlVD?=
 =?utf-8?B?UVk1UHBhT2ttcFhQKzh6RjNKTWJxRWppSkpDU2I2WEN2Zm5yTGYxUGlUd3hk?=
 =?utf-8?B?ZkhJV3VYdWJhV2NJRnVPbTVTWkU4ZmhLMDlJNFlSc3Fwa2tpUHlWR0NtVlpB?=
 =?utf-8?B?c3Z2ZGJTV1dyc3k2TkJicENncEhBaWxEMFpjVU10UHNjVjc5ZVIyTC9xQ1NJ?=
 =?utf-8?B?Nzdna1NHRkcvVWdxVW1kSVcyaDVCSFNFNm5Cd1MwRGFqVU1VZ1pYaUQ1NEFo?=
 =?utf-8?B?MkNlZjNuWXpjU0FsTytrNi91TE9wWHN2NFgvNVMrREIzdjcwVWN4YkwvbjNG?=
 =?utf-8?B?bUF1RlZqTWVQYXVzY2QxSVN4dnVURDhuSGl6L3pnaFNOc3k4YS9WSkNkOXZV?=
 =?utf-8?B?ZUdib2JkM0xON2hQTnF1VXN4bC9XV2Z1WVdnejhYY2FmYk1RSlhpL25WSkVY?=
 =?utf-8?B?WlB0RFRhR3VYa1Y1WlRtMzFXb2JOWHh2ckh3MzRHdG1hL2xYbnZlOElLTWw5?=
 =?utf-8?B?bmRoVnBOeHZWMEh1ekdoT09qb3dTRUdOWGJkUmUybXptUyszQzJtb3hoamdi?=
 =?utf-8?B?NldvcW5rK2ozaFlXN0xWSlQvNDBwbEtkWk1tS1JMNVJlL0paWFJxcWZDRGtp?=
 =?utf-8?B?ajNLbUlEOXF6SXptVmZhNHFCUHhnQTVtL3h0Yk9FeEM4Z28vZWM2VG54UmRm?=
 =?utf-8?B?Z2FJOHExdG80c3o3czdUd1hTdG1GNndEWk9sNU1xQ3FhSmo0Q0xaM1pVQ2Fr?=
 =?utf-8?B?UlJhN3I4WXIyTzJwc1RTalkxN0pMak12anc1a2pUbWpmOUVjZzdnQURHTHFD?=
 =?utf-8?B?cWg5ajBHeEdmSTJaYklHWWZ4aDF5YlNRQmRZbmdpYUR4NXorYmJIWVNZSlhi?=
 =?utf-8?B?bEVrM2lxZFFSUW8yMkN6cWZ5ajJLSSsyUVVFdnVqYXFXT1ZUd0FXaDVBYUlv?=
 =?utf-8?Q?g924MqpcBdB8tEgDseTgGVkmVIqCw/uhcLuFDmM+WvK1?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da22d29b-b61f-40b7-acb1-08db3be84676
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 06:28:20.3580 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iDTHKweywMDxgXELI23sGRCfPWYzHd3An4QwIAU1HZ3qIUTjtZ+qPLAdBQy82XZla/vQzN+FTCQwxd97842ZHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7761
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v9 9/9] null_blk: add support for copy offload
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
Cc: Vincent Fu <vincent.fu@samsung.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "ming.lei@redhat.com" <ming.lei@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dlemoal@kernel.org" <dlemoal@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: nvidia.com
Content-Language: en-US
Content-ID: <92C70530638E9A4CBFBC230DEA5AF1D5@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/23 01:10, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
>
> Implementaion is based on existing read and write infrastructure.
> copy_max_bytes: A new configfs and module parameter is introduced, which
> can be used to set hardware/driver supported maximum copy limit.
>
> Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
> ---
>   drivers/block/null_blk/main.c     | 101 ++++++++++++++++++++++++++++++
>   drivers/block/null_blk/null_blk.h |   8 +++
>   2 files changed, 109 insertions(+)
>
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index bc2c58724df3..e273e18ace74 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -157,6 +157,10 @@ static int g_max_sectors;
>   module_param_named(max_sectors, g_max_sectors, int, 0444);
>   MODULE_PARM_DESC(max_sectors, "Maximum size of a command (in 512B sectors)");
>   
> +static int g_copy_max_bytes = COPY_MAX_BYTES;

how about following ? matches nullb_device->copy_max_bytes type ..

-static int g_copy_max_bytes = COPY_MAX_BYTES;
-module_param_named(copy_max_bytes, g_copy_max_bytes, int, 0444);
+static unsigned long g_copy_max_bytes = COPY_MAX_BYTES;
+module_param_named(copy_max_bytes, g_copy_max_bytes, ulong, 0444);

[...]

> @@ -631,6 +637,7 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
>   			"badblocks,blocking,blocksize,cache_size,"
>   			"completion_nsec,discard,home_node,hw_queue_depth,"
>   			"irqmode,max_sectors,mbps,memory_backed,no_sched,"
> +			"copy_max_bytes,"
>   			"poll_queues,power,queue_mode,shared_tag_bitmap,size,"
>   			"submit_queues,use_per_node_hctx,virt_boundary,zoned,"
>   			"zone_capacity,zone_max_active,zone_max_open,"

why not ?

@@ -637,11 +637,12 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
                         "badblocks,blocking,blocksize,cache_size,"
                         "completion_nsec,discard,home_node,hw_queue_depth,"
                         "irqmode,max_sectors,mbps,memory_backed,no_sched,"
-                       "copy_max_bytes,"
                         "poll_queues,power,queue_mode,shared_tag_bitmap,size,"
                         "submit_queues,use_per_node_hctx,virt_boundary,zoned,"
                         "zone_capacity,zone_max_active,zone_max_open,"
-                       "zone_nr_conv,zone_offline,zone_readonly,zone_size\n");
+                       "zone_nr_conv,zone_offline,zone_readonly,zone_size"
+                       "copy_max_bytes\n");
  }
  
[...]
  
+static inline int nullb_setup_copy_read(struct nullb *nullb,
+		struct bio *bio)
+{
+	struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
+
+	memcpy(token->subsys, "nullb", 5);

do you really need to use memcpy here ? can token->subsys be a pointer
and use with assignment token->subsys = nullb ?

+	token->sector_in = bio->bi_iter.bi_sector;
+	token->nullb = nullb;
+	token->sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+
+	return 0;
+}
+

no point in return 0 , use local bool for fua instead of repeating
expression and no need to fold line for nullb_setup_copy_read()
makes is easy to read and removes extra lines and indentation see below :-

-static inline int nullb_setup_copy_read(struct nullb *nullb,
-               struct bio *bio)
+static inline void nullb_setup_copy_read(struct nullb *nullb, struct bio *bio)
  {
         struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
  
-       memcpy(token->subsys, "nullb", 5);
+       token->subsys = "nullb;
         token->sector_in = bio->bi_iter.bi_sector;
         token->nullb = nullb;
         token->sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
-
-       return 0;
  }
  
  static inline int nullb_setup_copy_write(struct nullb *nullb,
@@ -1334,20 +1331,21 @@ static int null_handle_rq(struct nullb_cmd *cmd)
         sector_t sector = blk_rq_pos(rq);
         struct req_iterator iter;
         struct bio_vec bvec;
+       bool fua = rq->cmd_flags & REQ_FUA;
  
         if (rq->cmd_flags & REQ_COPY) {
                 if (op_is_write(req_op(rq)))
-                       return nullb_setup_copy_write(nullb, rq->bio,
-                                               rq->cmd_flags & REQ_FUA);
-               return nullb_setup_copy_read(nullb, rq->bio);
+                       return nullb_setup_copy_write(nullb, rq->bio, fua);
+
+               nullb_setup_copy_read(nullb, rq->bio);
+               return 0;
         }
  
         spin_lock_irq(&nullb->lock);
         rq_for_each_segment(bvec, rq, iter) {
                 len = bvec.bv_len;
                 err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
-                                    op_is_write(req_op(rq)), sector,
-                                    rq->cmd_flags & REQ_FUA);
+                                    op_is_write(req_op(rq)), sector, fua);
                 if (err) {
                         spin_unlock_irq(&nullb->lock);
                         return err;
@@ -1368,12 +1366,13 @@ static int null_handle_bio(struct nullb_cmd *cmd)
         sector_t sector = bio->bi_iter.bi_sector;
         struct bio_vec bvec;
         struct bvec_iter iter;
+       bool fua = bio->bi_opf & REQ_FUA
  
         if (bio->bi_opf & REQ_COPY) {
                 if (op_is_write(bio_op(bio)))
-                       return nullb_setup_copy_write(nullb, bio,
-                                                       bio->bi_opf & REQ_FUA);
-               return nullb_setup_copy_read(nullb, bio);
+                       return nullb_setup_copy_write(nullb, bio, fua);
+               nullb_setup_copy_read(nullb, bio);
+               return 0;
         }
  



[...]
  
+struct nullb_copy_token {
+	char subsys[5];
+	struct nullb *nullb;
+	u64 sector_in;
+	u64 sectors;
+};
+

why not use sector_t ?

diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index c67c098d92fa..ffa4b6a6d19b 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -70,8 +70,8 @@ enum {
  struct nullb_copy_token {
         char subsys[5];
         struct nullb *nullb;
-       u64 sector_in;
-       u64 sectors;
+       sector_t sector_in;
+       sector_t sectors;
  };
  

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

