Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629D1C61DA4
	for <dm-devel@archiver.kernel.org>; Sun,  5 Mar 2023 21:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678051722;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QXDw6Ag0stL3xWt24EyO+cGxgVWoxTvwgDvYnZWX2cg=;
	b=DzdknZ1gRTMop8jShU0tY2zwkJFq0XdyGn4bUVhKy2cB4BZfaPwuYfsxhs4xEnHSuDKAx0
	bGcN+m6yfbRg4n3p0326KktVx9nVYTawyDiFpfexzhuwqsDc4qU7biBKOzdHF7CAouU4Ds
	RXyayuGLVQje76WRA9Z2jJhWdazyZuo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-973b89IqOZOQubhkUP9fEg-1; Sun, 05 Mar 2023 16:28:39 -0500
X-MC-Unique: 973b89IqOZOQubhkUP9fEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FCBB29AB3E4;
	Sun,  5 Mar 2023 21:28:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2B8FE140EBF4;
	Sun,  5 Mar 2023 21:28:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE6D21946588;
	Sun,  5 Mar 2023 21:28:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 537151946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Mar 2023 21:28:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 204EAC16901; Sun,  5 Mar 2023 21:28:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1781CC16900
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 21:28:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC48C1C05148
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 21:28:21 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-LECLcf1UOouPTPDdEQolCg-1; Sun, 05 Mar 2023 16:28:19 -0500
X-MC-Unique: LECLcf1UOouPTPDdEQolCg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sun, 5 Mar
 2023 21:28:18 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Sun, 5 Mar 2023
 21:28:18 +0000
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
Thread-Topic: [PATCH v4 10/18] nvme: Add helper to send pr command
Thread-Index: AQHZSHgd2MJJ6g9ezUqZKojk4EqGsq7sweAA
Date: Sun, 5 Mar 2023 21:28:17 +0000
Message-ID: <b4b5feb7-521b-fc5e-8c68-a05bea292ebf@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-11-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-11-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7864:EE_
x-ms-office365-filtering-correlation-id: 3c392887-fd09-4c97-960b-08db1dc08978
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: oFD2Q+jI49t2G5MZAJswVYpRAaNws7RxxyHoCAIchu20mc3T8+n6SGpu3h7ivLQfGaIECijBFeYWRE31vgm6qOPFz3Qun3JoM8/gUoojXJ8uSk3XIy/xor3uxh7cjqbTmkXjk1GSCqEt+778xVgPy1OLaxKFdm1Op3828D92tIckoEHJGrLIIuef+ULhUles+b13oNzT4Ha/+MrdrZIBseTkWtMBQZmPHTgUWAUD7h3IVeJ764q6lyCxomSykt0Uu8v2BsqgGgr2UCL6PJqCqyPb+/dZcf3uMNdm/X1rNmun9Z34ezz3pHKtnHxM4mrvHqpFt5NEUy9YHmq2hdcJ1b0rpQaZCe0nCPzq7YmsSf2pXlML4C3ZEEQQhdLd41mjXJwYPV69uBdVSWIDuozGGty6djD1f+zU91RAaUVxlSb8iDOPoa7Nbh9GfsUhbQBSBGAB/pnyNyvrCEUVEJ0FQFUrLLSyXt1Y8ZJphNTLo9Hu1BCZA8wHN6e5fvzGVhi4KWF8y5hh52NGL5Z42EknxCNCCBJERBHIZMwm7uZ4LU4k3YyPLQEAHIKzQbC8lXinpFV43Kq1hj3mBISdKpV3MJfRv2S0QqJIx6dktfAKVLFloG0zGzQ1AJIGMYHgWtoSfcdd+n2aHx7HYD7L8Ar4RBV9tSul4opMDASbf4VZiifzA55A2jmfjAO+xC17KQ5cWXSWBvtra6OAjw1yNwmGnl8O9+ssVgsEiaVWDXgVxcpQkIePEl32zChO+pnmvaWUZyQTRRCzecT6XzKpNrjJZw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(186003)(71200400001)(6486002)(38100700002)(478600001)(91956017)(66946007)(110136005)(83380400001)(64756008)(76116006)(66476007)(66556008)(66446008)(8676002)(53546011)(2616005)(31686004)(316002)(6512007)(6506007)(41300700001)(8936002)(7416002)(5660300002)(122000001)(2906002)(921005)(31696002)(86362001)(38070700005)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUs3ZU4rNjVaUWxXTVFoQnFjWmk0TjVhRDJyOGJIZXY3VHhIRnZmL2JzZnhY?=
 =?utf-8?B?SEtVeWh2YmhBdWFpUVJTektxSDg2aklrZkVrb2NOcWVsR2hVcFMxTFczdDk4?=
 =?utf-8?B?VTAzelJ0cHl6Sm52c2U3a00ya3U3TlpCOGJwdmtGcnNFbnVUVFdpajVpYi93?=
 =?utf-8?B?K3FGS1NaTndpb1J0aEZGMjZZYWxqZ29RZVZxaExhWmgxMVNyZi95NlFma1p6?=
 =?utf-8?B?WTlsNnhzdHM2bFFmL0dyNTh4eDhUKytRbHM3cHhac2o2NUVVSHBnYVZDbkdo?=
 =?utf-8?B?WGR5TVZKTTFsSTJNWGZINmdzVzJiQzlZU2tXT3JpYUQ1OTczdyt5K3hVd2pw?=
 =?utf-8?B?ZXJzNGRHQUxYQVhOTTNDRGpYOGlBRFdZR01zeVkxbCtjeEVOWUpHK1h3WlNs?=
 =?utf-8?B?L2VlZ1pMaVV1eVZieElzRnV2UWhOVk83MFk4VFN0ZXk4S1Y1THNZWlNLZW9h?=
 =?utf-8?B?N3k3SElKd0VYSXhiUHlTQ25USkpkdzVMaE9lU1U5c2VvdUhrYS9yUktCT3dP?=
 =?utf-8?B?bVFURUpxMFFUVnFPTFV3Zjdjdk5acmtUTkQwOUcyODVRUUVvVFBKSjhrT0NC?=
 =?utf-8?B?eFA0dDIrYkZWNTdRSEh5aENFVncvWVFndmhDVFdCL28yczVwTWcycGJHclds?=
 =?utf-8?B?T2lkckxVelFNWVltNkl6STlsdTVVZjVBTzNOcEdsVnd5RmF2M1RHcnRuRHAx?=
 =?utf-8?B?Z3pnb3g0aloyZUFBTnppS25qb1Q3VmFDOGw2SXd0dDBIOXQyRlZRZGY2cnZu?=
 =?utf-8?B?TUZpMWF0alJZVmxlZ1AyVExKdFgwV1RpNzJMWWRCQXE2RzkyUnpWZzhkdzN6?=
 =?utf-8?B?RmZFSUFPTUhnUGRjWTI3TVhIV0VoWlpUc0NrTHlsWE9HVDUyNEtpTGlPc2cv?=
 =?utf-8?B?U0VqVk5qT3RnSnJIR2xkUjRDWVZvZzN5dkpjSHkyVUF2QmcweUhtMkdxbHFB?=
 =?utf-8?B?OXJRODFJT3BvUVlmeWo1V0luVkpwRlNwUmxVWi80eUo2WnhiYTREMUdvUnYr?=
 =?utf-8?B?WkRGQTNMZDlpVXNBT0xuNGtUMVBBSkszZE1BcUpRaGV5TDlhTEJyY01KZURM?=
 =?utf-8?B?YlN0UUtIcFdoYVV4QTNwS0lBWDZ1TWZKMVY4LzRaT1RRMHRhSUJYN1E5U0ow?=
 =?utf-8?B?NkMyVUhFa014NUFVNjRBTVRJMWFrZXpnRHU0cThIZEhYcVZUdk5La0xYak9T?=
 =?utf-8?B?bGxVcHZPMTk2MVUyR3JCc0VLdVRaNTI3ejhvQ2x4N0krZ3lRSWdHbllnU1k4?=
 =?utf-8?B?THRhZXFPUGQ0SVNKaWVub2RGejlwTUY1Ty92NWdGa3V5SjRGOFVkTEVyN0Qw?=
 =?utf-8?B?TzVzeW1HcmFLTTlCZStwdVJ5aytOOVdGVUtBRVJ3aVVIRmdVU1dZUjJEZzBY?=
 =?utf-8?B?R2pMVnl2S2FlNjM0RDZvWWJVMGFWTFVhS2xzczBHOEZzZUp0Q09xTWZjRHhr?=
 =?utf-8?B?aUtNSWRwK2NuZFg0Y3Q2WXJZeFp0NnZKbWt2R0RiUDJoME5xak1CWXI3NkNm?=
 =?utf-8?B?djFNa1Foc3llbVhvUmhIZG1VK0JKMnZsemtIUHlCSHpxZ3hIZy9tQnRuRGcx?=
 =?utf-8?B?WXVCYmxPNnZQcnNqQlhVN2RQNGRrYnFrdVBWZ0k4S1JBZ3o1bUhXUE16L3A2?=
 =?utf-8?B?T2xhUTEvYzg3MmtQN1duckVsRlRoamtGa0VMVmJ3QXltNlFmMjNzTWI2RTNL?=
 =?utf-8?B?T0d4WUVZZ09tcWxSbndsY0djRFdKNjVkeTBoMkx6VFVFbWU2S1AxMUoyZFV5?=
 =?utf-8?B?OXZwbG5hMHBoOCt5R1NUaEswSUZSS2VqZGN4d2NIMlJhRGFjc1N0bW90c2Mw?=
 =?utf-8?B?MWRQZ3oxcUZRWit3VStLYWNDS0N0OHcrSW5QRklJQ0E5RytGYVBxN2tjbzUz?=
 =?utf-8?B?NnlGQUFFYjhaNi9US3ZSSGw3WFplSUJOUWVtN3NEZ0c3cU5qL3hTWlFPSjJt?=
 =?utf-8?B?ZkV6VUo5UEZCWVozMitqbk1neWM5OGo3NmhLVXorWmxudG9pblY4NVJxZy9h?=
 =?utf-8?B?dy96VlhxekRpcWx5cDhNcUU4MGkwQWl4NTY3UXJLRlQ4RGloRk1VZjArT1lh?=
 =?utf-8?B?TmZETGZyOTNqbzJmeWJxdkczUmNCUHRML3E4YWRLNzZnalZvUGhWSjBOZ1Jy?=
 =?utf-8?B?Y0pXWFdjZEN2TE5aSVhZQmlrWEpCSDA1aFVEOVQwazFMdHZaTGJGRlVQcW0r?=
 =?utf-8?Q?fuW4wDHbYNhk7qrdQww01r+SUTqwf8cVbxSwPiJ+TwGF?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c392887-fd09-4c97-960b-08db1dc08978
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2023 21:28:18.0052 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: odQPkmqF9wWFzD1K0Mqja0u6bgYjOOpLW3h0pN5WWUPGpMENNhUh+XiY5rabS3t2jPCA5JwCs3BwbI/eT4KdxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v4 10/18] nvme: Add helper to send pr command
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <87F437F6FA2D8B43BEF11B000F99E526@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/2023 9:44 AM, Mike Christie wrote:
> Move the code that checks for multipath support and sends the pr command
> to a new helper so it can be used by the reservation report support added
> in the next patches.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/nvme/host/pr.c | 23 ++++++++++++++---------
>   1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
> index 26ad25f7280b..7a1d93da4970 100644
> --- a/drivers/nvme/host/pr.c
> +++ b/drivers/nvme/host/pr.c
> @@ -27,7 +27,7 @@ static char nvme_pr_type(enum pr_type type)
>   }
>   
>   static int nvme_send_ns_head_pr_command(struct block_device *bdev,
> -		struct nvme_command *c, u8 *data, unsigned int data_len)
> +		struct nvme_command *c, void *data, unsigned int data_len)
>   {
>   	struct nvme_ns_head *head = bdev->bd_disk->private_data;
>   	int srcu_idx = srcu_read_lock(&head->srcu);
> @@ -43,7 +43,7 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
>   }
>   
>   static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
> -		u8 *data, unsigned int data_len)
> +		void *data, unsigned int data_len)
>   {
>   	c->common.nsid = cpu_to_le32(ns->head->ns_id);
>   	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
> @@ -71,6 +71,17 @@ static int nvme_sc_to_pr_err(int nvme_sc)
>   	}
>   }
>   
> +static int nvme_send_pr_command(struct block_device *bdev,
> +		struct nvme_command *c, void *data, unsigned int data_len)
> +{
> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
> +		return nvme_send_ns_head_pr_command(bdev, c, data, data_len);

below else is not needed after above return..

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

