Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF66C4708D
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 23:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670454176;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B2MCP6N1dwAqzw4gmB0r6m9Y/TaGBa9z0KHc8JQvYeE=;
	b=Jwvn6ljZ8O6ChzaTy4tQ/muTx/ZfDEdB9ulQYRERcRUF1fHd4A37WB5QccORcCH2ZNUeN7
	XpviySdu0EOcyGXSJ8kC2grGSCISXhoGWXL8JBlPYR5Mfxc/CgkREw1SM98skfgiM7vhZ0
	LWobQ/WY/+kkmRtHgXDWYDHLzK6uaAw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-ktqqxJd7MnGbd-cqNCSLTw-1; Wed, 07 Dec 2022 18:02:53 -0500
X-MC-Unique: ktqqxJd7MnGbd-cqNCSLTw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89BA386C043;
	Wed,  7 Dec 2022 23:02:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80365492B04;
	Wed,  7 Dec 2022 23:02:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18D0E19465B9;
	Wed,  7 Dec 2022 23:02:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 42D5919465B1
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 23:02:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D8131121315; Wed,  7 Dec 2022 23:02:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0597D1121314
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 23:02:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D57948039A1
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 23:02:42 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com
 (mail-bn1nam02on2087.outbound.protection.outlook.com [40.107.212.87]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-gQhcIyIGOyykYbVlQs9hkQ-1; Wed, 07 Dec 2022 18:02:40 -0500
X-MC-Unique: gQhcIyIGOyykYbVlQs9hkQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW4PR12MB7015.namprd12.prod.outlook.com (2603:10b6:303:218::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:02:38 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:02:38 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Gulam Mohamed <gulam.mohamed@oracle.com>, "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>
Thread-Topic: [RFC for-6.2/block V2] block: Change the granularity of io ticks
 from ms to ns
Thread-Index: AQHZCovJdMlm6wlSxk2x2f41eVikla5jCueA
Date: Wed, 7 Dec 2022 23:02:38 +0000
Message-ID: <7a658866-c7b8-00de-ab82-4b8212cb2603@nvidia.com>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
In-Reply-To: <20221207223204.22459-1-gulam.mohamed@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MW4PR12MB7015:EE_
x-ms-office365-filtering-correlation-id: 82626d82-52ec-47b9-fb02-08dad8a722cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Kx5+1OsqY45gvH0ex7U3LuUgkAHs2ZhKM+1Pd5Fm+ljstY6hS3346YF1fsq00QXLdZYLUNJZwG6gaOB1k6uxJ3V+0iJvrI6GoFUtrF1LDgzMfOEHI7TFmFAZS7iNOrsR9YZmfQgBr0GJjNnvIBuGIL7qvxHSqdSAFcMXlDCfal1P1NJgAr4dy273iWZoE5uGRWvxZPVsVTVwhs5KEn92n14+WdUhvwrMsx6XNLqqMSkCyzVsBlyYLF3rRl0hSMk9eSYfPmXjXFP1bUXBXd6FpE+3Y0RqQIWfqigHTo25Wc1WzVxWANKuOXWTMrUXFmhoR13j++4U/QG+hWyeZBMBQlNj1x/t2vGlhC8IaMw5UNSpLRuc3yvjm+jXSU94VRnJGsA6eebIbAs4PoL0jbXXbvh7S/KzM4k5wSH13DAU/Qc/ZOiPYgUys87rjSzw7NPyjNJn4AxE9i5nZP4lMav5CxhA+H/W4mNmJwZoYnAtXgG9UYLuVyaSu954hWOfCLKM/AOKqT45FwOD8L6n/8kSkiCtv+dgyOAa1zKcJ886XkeW39TkouQzDsWyY0bpxCwRN4CMO9io6lEU5REpqoYsCrfsdELO7++rCsF/YvC1CkgLwzBZ7WKuNxmkpgh7DeM5u/b/rVLm71RbP0sZ3+C12oFby649Uy0rHNzcSqHStPNnhNGxGQRSZkj6oluyRI6Z2b/xIzV6mtC2YWOBrtyZxysW4q8WH0FwPGGB/jf8o53+DGJR4TA1G8qYjky6g+sq4JnWZQ0W+vhbsg7q7XIPcA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(36756003)(31686004)(38100700002)(86362001)(31696002)(5660300002)(41300700001)(2906002)(4326008)(38070700005)(7416002)(8936002)(66556008)(83380400001)(122000001)(91956017)(478600001)(71200400001)(66946007)(66476007)(316002)(66446008)(6486002)(110136005)(76116006)(54906003)(2616005)(8676002)(6506007)(64756008)(186003)(53546011)(6512007)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzhlSWUwWUNzRnhHbE42TVdkdWd0azRUN2lmZ2YrcDB2S2dmdG1OeS84THlP?=
 =?utf-8?B?b0dvZ2xSOCtHUlQ1aVJ3a2kxRitISE5MR3JxZExEMjZLc1FEOGsxU1RUVjMy?=
 =?utf-8?B?Vmp1TW1NTmpLczQ3S241UEVCZ2N4UkhKREl6NjBYTi9Bak8wRVRZa2ZlNUs1?=
 =?utf-8?B?akFtb1VQU2hQbE1GWWFScnFVRmFjTCt1SzErVm5PUlQ3YjFBZkVEZm42Qk1V?=
 =?utf-8?B?STNXWm91d3RVTFVHYlJhdUdRSDZrbVZnZUsyRm9iUEFVV2w5dThQK2pUVmxL?=
 =?utf-8?B?bUdQYVFyL2YxUkJHUk00YTJPQS9Majk5T0pFdXY1em8rSnI3elhzdHppRnda?=
 =?utf-8?B?UFZ1U3gwL1ZzbE9laTkrREttUU55ekxnV2krUG5ZdGgvRWxYUW1IT1FFMVZ4?=
 =?utf-8?B?anZJMHl6SVZSdlF4NFJtNlR2MGhYUFkzbWo1RTlVZzJjMmpZRGxPUjJROFEy?=
 =?utf-8?B?UzBWVXhBMkRkZXVVTmRqa2ovSmVJaG1Ydnc3b3VKRk1RbVpLRzBHYlZ1L2g1?=
 =?utf-8?B?U0dBS20xUFlGRU03RVh2S2JjNm5ON0dWbkl4MFdPdXdwSDYvSGE4c0RUQnZk?=
 =?utf-8?B?UmFYdGtNK3BpWlRmQjJKL3JuOGdlbmJBNUR0QUkza2dyZVlWbzJCMEtyN3FM?=
 =?utf-8?B?SUFmSWh4QlM0ODZIR2FXRTZoZ0xaSXR1REI3czJ6N3M3cnlFZ0dYK0Z5Njlh?=
 =?utf-8?B?WldsRjRMRmRrQnMxcEd1VWE4a2FsQmY0d3lhaDhjeU5weDYyeFNJNXk0dXFP?=
 =?utf-8?B?SlNjdWFBUjhBanpjU2xPT2F5RjJZZU1qcVRCbjJKQm9zOG13RSs0SjJER1Fj?=
 =?utf-8?B?WjV0bmNFTHBMcUJ2OUtuNmp1bzZUWTBtMGRQeEhzZklrd01LVnBGazRXUnZT?=
 =?utf-8?B?cHNTQW9JeWhSNEhQTHNJVlpYRFdmVUZoSm9OQ2xESkpoSlVZaW5Hdlc3OCs5?=
 =?utf-8?B?cEZkS05oWlg4aHBuRHVLdXV6WG42WUZYYVpFb1l5ZXY3VUFQS3AyME5uSmZV?=
 =?utf-8?B?RkRyd3dxN1ZlanVtMFhhT1lzY1dRaFhHaG92ODhlVEtSUzNtbWQzRFlKWEdk?=
 =?utf-8?B?KzBqZWhwemExKzl0aGpMWmt4d2dRL1J0YzQ3aDFqbWZHOXVHUlBGcWpBc3Vm?=
 =?utf-8?B?VFVZL29sK0s4QmpoVlpxRUUxZWRnM3VrcjBpYzloUGZWNG9ZVlZxSlBvQlpp?=
 =?utf-8?B?WFBLRHVOdThhYkc1UlU0TDNJeUVvdFR5UmlYWFF5dyttNG16RXJyeC9hYkF4?=
 =?utf-8?B?UVZIbmF1a1hCWkNDSlVUOVFGVWFYZVAxdjFzaDc3bUJkZXFnQnBVMXFGbzVq?=
 =?utf-8?B?MTN4TGg2RlNZcDErMXUzMmdpMGxhYkZwR3hMOFBxQUZzMjRzNmR3dVErMXFa?=
 =?utf-8?B?akptMGx0Z0ZCdWcwTk1tRm4vY0xadURWTzd6bDkyQ0FXZ05OKy9GazN1ZDN6?=
 =?utf-8?B?Q2VWWmFBRVRtVDhWNloyYjhFL2VwNFE4VmlDYWdQODI0WmxsTy8yaGR3eXgv?=
 =?utf-8?B?bDBYclBFTU5iaHh3Sks2aWNmaWpWODhIaWxGczE5dHc3aG9LVzlPUUZhVVMz?=
 =?utf-8?B?VEF5Tjc4T2tGaXV2cGUyelJaTFhncmhNOGJoY2pRMVNVS1VwdDdlQmxacElw?=
 =?utf-8?B?Q2ZIUUkremdVWjZWWmhBZzkvVTd6K2lCYnZXeUFQenlZQUNCNDB2VUhxV3Js?=
 =?utf-8?B?UW1VbGNGZHd6UlZNTXVBeGlEV2c0aGtKV2Zwa0o0UVZXdVNJK3ZweVRvNmpF?=
 =?utf-8?B?d0RocXo4WUYrbzZDVFNBR3dUckIxeE1OL21XVFR5c0FmcTNpS25wR0liV3J6?=
 =?utf-8?B?SFdIa1pGUWE1eE9qSGdkV2drczltVzNrOEkzOFFpdmRYZ1hUSDlxdVRFbWxt?=
 =?utf-8?B?b3B1bkNWRU54bzEzS2szVEtOYndMd1dEOHFabS9wRnpDYnZJRXFUdHFoNDln?=
 =?utf-8?B?ZGoxMS9OaWdUTzMzUFFrWmRZQ2pYN3EzMmpsVUVuVUxSa3B6NGY3MjlaREQx?=
 =?utf-8?B?dmU1Z3VzSTJucm02Z1ExdXJqenVOM2RLenRpS1hwS3c1WWhwQUMvSUt5MGpn?=
 =?utf-8?B?TFNpb2FzU1g3VXlIN01xY1o3azRDaTNITHRTb1A3YXlXOXdCQklSMUxFRGo1?=
 =?utf-8?B?RmMvWDlISVJhSnYyckg2UzZKRmZickczMjRXc0dadG1kWWRsRHJyMFlrMktl?=
 =?utf-8?B?QXc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82626d82-52ec-47b9-fb02-08dad8a722cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 23:02:38.1031 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QdC7Z8tZF3p1Ldr0onDPjaAi7EFmfLr/GZcBY2qVJwqBRxuHHxkxLM4rOQwAXTsobFQP8jhsCk4s5oeG+wxdZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7015
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [RFC for-6.2/block V2] block: Change the granularity
 of io ticks from ms to ns
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "song@kernel.org" <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
 "joe.jin@oracle.com" <joe.jin@oracle.com>,
 "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
 "ngupta@vflare.org" <ngupta@vflare.org>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "colyli@suse.de" <colyli@suse.de>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "axboe@kernel.dk" <axboe@kernel.dk>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
 "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>,
 "minchan@kernel.org" <minchan@kernel.org>,
 "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <80992709039F884A97659819F8B9D6A9@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/7/22 14:32, Gulam Mohamed wrote:
> As per the review comment from Jens Axboe, I am re-sending this patch
> against "for-6.2/block".
> 

why is this marked as RFC ? are you waiting for something more to get
resolved so this can be merged ?

> 
> Use ktime to change the granularity of IO accounting in block layer from
> milli-seconds to nano-seconds to get the proper latency values for the
> devices whose latency is in micro-seconds. After changing the granularity
> to nano-seconds the iostat command, which was showing incorrect values for
> %util, is now showing correct values.
> 
> We did not work on the patch to drop the logic for
> STAT_PRECISE_TIMESTAMPS yet. Will do it if this patch is ok.
> 
> The iostat command was run after starting the fio with following command
> on an NVME disk. For the same fio command, the iostat %util was showing
> ~100% for the disks whose latencies are in the range of microseconds.
> With the kernel changes (granularity to nano-seconds), the %util was
> showing correct values. Following are the details of the test and their
> output:
> 
> fio command
> -----------
> [global]
> bs=128K
> iodepth=1
> direct=1
> ioengine=libaio
> group_reporting
> time_based
> runtime=90
> thinktime=1ms
> numjobs=1
> name=raw-write
> rw=randrw
> ignore_error=EIO:EIO
> [job1]
> filename=/dev/nvme0n1
> 
> Correct values after kernel changes:
> ====================================
> iostat output
> -------------
> iostat -d /dev/nvme0n1 -x 1
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.05   0.06   128.00   128.00   0.07   6.50
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.06   0.06   128.00   128.00   0.07   6.30
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.06    0.05   0.06   128.00   128.00   0.06   5.70
> 
>  From fio
> --------
> Read Latency: clat (usec): min=32, max=2335, avg=79.54, stdev=29.95
> Write Latency: clat (usec): min=38, max=130, avg=57.76, stdev= 3.25
> 
> Values before kernel changes
> ============================
> iostat output
> -------------
> 
> iostat -d /dev/nvme0n1 -x 1
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.06   0.06   128.00   128.00   1.07  97.70
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.06   0.06   128.00   128.00   1.08  98.80
> 
> Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1              0.08    0.05   0.06   128.00   128.00   1.06  97.20
> 
>  From fio
> --------
> Read Latency: clat (usec): min=33, max=468, avg=79.56, stdev=28.04
> Write Latency: clat (usec): min=9, max=139, avg=57.10, stdev= 3.79
> 
> Changes in V2:
> 1. Changed the try_cmpxchg() to try_cmpxchg64() in function
>     update_io_ticks()as the values being compared are u64 which was giving
>     a build error on i386 and microblaze
> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
> ---

I believe it has no effect on the overall performance, if so I'd
document that.

Based on the quantitative data present in the commit log this
looks good to me, I believe you did audit all drivers and places
in the block layer.

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

