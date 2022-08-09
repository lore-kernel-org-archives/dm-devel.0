Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39747C19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 10:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660042626;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9L+SLQdihV+X3y9VHU+wqvxp+94ui9v+AcSucQe90yA=;
	b=fWpggCiTexXOADWFgW1nG+Jrbh1Si2J8L8c5AUJj9f8AQXz5XqJQlJff/VIRHsuzAa8eOS
	3WqI110aypBAEMeYUoRaa4EVU5iKnLaT90sjT2cIoG/4udmk2GOfIDBDmMt13XPYW0e5EH
	4Pb9CpzEx+WTOiQ59sLInL6VVSCq3ys=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-hSnGqzepOsu9d9ksiuLQ_g-1; Tue, 09 Aug 2022 06:57:03 -0400
X-MC-Unique: hSnGqzepOsu9d9ksiuLQ_g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A776C811E81;
	Tue,  9 Aug 2022 10:57:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 938691121314;
	Tue,  9 Aug 2022 10:57:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59A591946A4D;
	Tue,  9 Aug 2022 10:57:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E56551946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 10:57:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9B14C15BA3; Tue,  9 Aug 2022 10:57:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4E0BC15BA1
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 10:57:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82C732806AB4
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 10:57:00 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-3OBbXmtGNpWVDNL7Y60gCA-1; Tue, 09 Aug 2022 06:56:58 -0400
X-MC-Unique: 3OBbXmtGNpWVDNL7Y60gCA-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Tue, 9 Aug
 2022 10:56:56 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 10:56:55 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>
Thread-Topic: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Thread-Index: AQHYq4PmjV2UOnxHHEaZfkf5ZGRZ762mZnKA
Date: Tue, 9 Aug 2022 10:56:55 +0000
Message-ID: <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-10-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dd8b323-e501-49f3-f9bf-08da79f5e009
x-ms-traffictypediagnostic: MWHPR12MB1248:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jlcXd4BF1Mv5L7olsdpngJ6l2JrDiDK32Nf+Am4BqyFsMRIsuzj2sGKGjJXNA4vDw41JPDp7IAzWrNv6Kjldk6tasRaia3ZIDAYCGYhaEMl0VRaOtQ85HmjgOSNZ0WkiF1byGRaoVSm/+gyAqZgSXigYrDLW8GXgBCe2ym3EOnvYS2hjLojgBl8E9tn02uDT/zGAEsP/tKhbsa7Uo9msJsXCEerKHlMLXzn8mkyBT5luzfwiTGpSX2Kr+q2PGnK2ETA0HJLPpQNGu/Ou7jYJ0wwI7IJlqZZ/5TAADkBBycTW9ZdTQAfVrWOc7inLLEB2zL2Z6iA9fPB3GKmNAMk7i8gr3aXm43f/bKMNWQodmy9CU2MUh5ia+uU3cQJDWiVhvmGSqwb4LnSgsFxTPdLPZDY2EvBSj9cCUKO6LevFU46HaQX6/8tUm4KB4wmORZO1Q9GhO/NgdOaxk4VVuavB0we54tgnm7fDWynJ28ckMdrPDobXLV78pML+cXvDs/6Q+N5/UF2yUVeGwKhcmvNpDuaU8Yst/9VTsMcucAlY0xo1Eu0xa+HLu9LrFi3V1L/kWaHtl0TR/i3tgCU3LbwyMIE5o+QDMgQGF+UjRbd0uSWj8l7Nx4iwFCZJBctze5JwgyGuQxC8Iy35gZPupfWG5zq0TMSRpib9BRjUW5v8jzywmufl1+RpMEaYOFUtCQo3Xt+zdP6rKhwjUWvQ+prX3VPgBXd7mkcU1WWaboB9kfSOGClIR7dRRzKOsEx73udAfY0Z0faDZXwyr1YZK/3Gtn+KHbZohgkNyVSh26GWOS8mFZBRGbBqkwE/U8DqXaQanv9BgWt+ZSYprciWhoP6e+RiyAyLy8Rm5v25AnRpEms=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(186003)(36756003)(41300700001)(71200400001)(8936002)(5660300002)(31686004)(122000001)(2616005)(83380400001)(2906002)(86362001)(31696002)(7416002)(38070700005)(66446008)(66476007)(66946007)(66556008)(64756008)(38100700002)(54906003)(6916009)(6486002)(316002)(478600001)(4326008)(53546011)(76116006)(91956017)(6506007)(6512007)(8676002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGtvNWs5eDNQSWExUjdxMVRySWtWOUVEL0tzZ0ZyaDA0Q1drQzN0YXBnN2tR?=
 =?utf-8?B?TjRLelpSZXQ4QkJsb1hsOHlpOEYzaHZaRlUwWTZra1dXeXBuR1MvNndvTFFD?=
 =?utf-8?B?dFJtWXgvN09kZHhTcDFHN2gzWjV3bElTSEd2Y2dYbGFjaldOUlJxdW1BNm1K?=
 =?utf-8?B?YmMxU1ljbmVJMStsalRIeitGWkdhZ1V0RkxaalVmTVBPNFpZaGJDWHFTWVo5?=
 =?utf-8?B?NmsvbldGOW05RnhLWlpwN3J2dFVYWXk1dDdlQUVlK2pmNmlzOTQxZ3dGVTZ1?=
 =?utf-8?B?ZmsxWVJ2SWZxUm4raUkxMjQvczV2RmxwT1VwSWE4ZUZoTVliTkFMN2V0SjVO?=
 =?utf-8?B?Q2Qzb1phTmQ4TURTbGRhbjVCcjhKdzNla1JjVW5SSTFvTjkwZXZidW53UDBr?=
 =?utf-8?B?M0t6T2Z5dS9IalN1OVZjWEVPcFFXa1Q3TkRqT1AxeW1MNmhGUUdCMEJnY09p?=
 =?utf-8?B?TTlGMnNpN2w0a24rY1RKdzlrTTByREpwT0pLSVRZazlYZVpkZ0p3TXB3WFR0?=
 =?utf-8?B?SC9JdVBnNlN6TjR4VmF1ZFFYdDRQVTFOa1FtQlg2cm1YOXVLeEZSM0czTXVK?=
 =?utf-8?B?ME9CWHdOaWxkVjVLTGNyVDg5aHVsV3JZaDhqblZPcjJ5ZUZPNG9uck9RQUFq?=
 =?utf-8?B?aGswNGtVRU53NjlNYWk0TTlraU1CZmtvTTJnV0ZCNlhWT1Uxd0J6eE9sbk1r?=
 =?utf-8?B?NUhSSFNKNHlaOXlvRTgzQlQxR2NLRGdCaDNxSGVJdVRtS2d3RlZwdTZ4bC9N?=
 =?utf-8?B?bWI2cGU4VTdiMFZRZkxEYmdWU3RMS3YraEJBSGNQbFJ4WWxNZ1p0U1ZhYlVo?=
 =?utf-8?B?cVZmcEU0L2RDeURiZUlhWVV1WFJDejdaWm95VnFCVWxHRjgyUmcxaS9tQzNQ?=
 =?utf-8?B?b3JMbGEwcWtLa01GeXovbU16citnclNEOVljUmpHTGdMbnMyMlBrcmlGWjlU?=
 =?utf-8?B?NXVMWUhETno1V1ErVng3RDdGNWhqYmt4cWpDZ0Z4ZlZlZmJJVlZWNlU1Y04r?=
 =?utf-8?B?YW5hRkhCRnFjVloxMGY1dmMzcFRlNG95Mm05TUJsakZXWXl6S2xPNjBNREV0?=
 =?utf-8?B?clVROVRxbldRdEl2YlV5aFVRRW9FSmdSSkpNb1BJaGYraEpCVmsyM2Rkbkhl?=
 =?utf-8?B?LzZnVE5DL3I1WVFmT0F2djRGeUhpQzIxSWUwQm5qTGZNcUdwOUdhTklLczFT?=
 =?utf-8?B?RlFEU0NzcEJMbVdGTTlZb0JMVVNtUGFpUXhkT3NUV1lKSUt5bnViK2dScVl6?=
 =?utf-8?B?OFpNVWpPYU1qekFMMk9QckZJTXpBMUJIZ1psTFZCMmVGZlI1U29RUHByelFh?=
 =?utf-8?B?VTZIZG84M092WFp6SmlSTllpZlBLV2VNU3Nma2FjczFYVC82MkVUdWV2ZVRn?=
 =?utf-8?B?WXBqNFoyWnUzNXFja0FpMkZJaVdOSTJKQXVTQmZuc0JiZlRqQ0k2Snd3ajRs?=
 =?utf-8?B?MHBYZWpjZWd5Zml5VkdPWXBYa3hxdkt1RW5FWnp5aWQ1bHhlakhzMVVZY2pW?=
 =?utf-8?B?RlFOTkc5VVpJcWJQWUpnKzBPNWFsdmJoMkxOUk9lYWJyeCtlampmWjRGVzRw?=
 =?utf-8?B?VnQyTDZLWFJrWDZzUjV1dXRzOHdsNUNheTVHL29IZ1ZOOFlNdmpneDg2L2Z1?=
 =?utf-8?B?SGVULysveisxTXVQK2ZaMDVmd3VSTmJ3NjR6QUwrZWhKLzJIT0kvU3Z4UHV6?=
 =?utf-8?B?WnhXM21LZnM2TytsV01xYmFiZ0tsOGFtMjd3cmF1dWVXdG5BNGZSemJna0Np?=
 =?utf-8?B?YndaMDNHMVpxMTRONXBOcTBDVWxvdEVOZXZvMXVHdHBHRFNtUmtBazF3ZGF3?=
 =?utf-8?B?ajJpeDNpY282c0EwVHNCbGtnQ0YzTGgrMVN0MHdWM2V0TUZGc01ldnFQcFdi?=
 =?utf-8?B?Q3Q3VnIwWTMvQWxjSlBwK01uR3dmSUFuYkJFejlyTGZaYkhDTmFjVzZ3YWJD?=
 =?utf-8?B?Q0tZUFFuRTFwclZwRkdMYUR6VHNMMWhBd0JuUmNrMjhZRUMrclJtTzJwQnQ2?=
 =?utf-8?B?M2xaRGt0VUtPUXIyNk9GSW1qVFZ5M28rRFV0UTg1LzRwY3Q4V3pmVDRIUlVC?=
 =?utf-8?B?R0JIQ2lMZm5GR2RWZCtyczBWeHVnM3dXekNWZGlOaDJDalFZczZMREJYK1VH?=
 =?utf-8?B?YlZtM3g3K0ZXNGhqTUZTMEFycmxjZDE2WGFuaVovbDRVVTZNakw1YTd3WUhL?=
 =?utf-8?B?TEE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd8b323-e501-49f3-f9bf-08da79f5e009
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 10:56:55.8576 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJDCHhqomGw+VqzXeAtetvre9qeXWY9ekcS3VWsecoHC09MBOzgf2ttrcQ1K5cTxXGxY2lXxs/bIrC/4n6xuMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1248
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
 "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D730F7F27B5C23459200EDFDFBF771B0@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/8/22 17:04, Mike Christie wrote:
> This adds a helper to execute the Reservation Report. The next patches
> will then convert call it and convert that info to read_keys and
> read_reservation.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/nvme/host/core.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 0dc768ae0c16..6b22a5dec122 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2196,6 +2196,33 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
>   	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
>   }
>   
> +static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
> +		u32 data_len, bool *eds)
> +{
> +	struct nvme_command c = { };
> +	int ret;
> +
> +	c.common.opcode = nvme_cmd_resv_report;
> +	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
> +	c.common.cdw11 = 1;
> +	*eds = true;
> +
> +retry:
> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
> +		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
> +	else
> +		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
> +					      data, data_len);
> +	if (ret == NVME_SC_HOST_ID_INCONSIST && c.common.cdw11) {
> +		c.common.cdw11 = 0;
> +		*eds = false;
> +		goto retry;

Unconditional retries without any limit can create problems,
perhaps consider adding some soft limits.

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

