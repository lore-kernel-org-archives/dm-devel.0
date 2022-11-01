Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 507D9FA3743
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 05:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667281429;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jv756PXCqIF0MgtYo0N5v09N9q1zjw1xV2eNPJdQ4VA=;
	b=VS9JQyXlrwDDnDnkw5DwYjOBvNbRLHbFsDJT7fLetMk+6tOMiLjwl3r37EujMwmSd1TwpA
	QGnHD++BNpNEwaq9iEHzMQACx8ii1f4eyWG005jRJVrsIKDvEQ9EJ7jN7D3/IKhatfCIIJ
	3bQTJe1GlsDCeMU1ED+pNaFFaUEG2zY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-b__E3ZKrNP6snhmIi1gTeA-1; Tue, 01 Nov 2022 01:43:45 -0400
X-MC-Unique: b__E3ZKrNP6snhmIi1gTeA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 069AF101A528;
	Tue,  1 Nov 2022 05:43:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9F12440C2140;
	Tue,  1 Nov 2022 05:43:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 670E619465B3;
	Tue,  1 Nov 2022 05:43:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 769791946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 05:43:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6630F17583; Tue,  1 Nov 2022 05:43:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DE471731B
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:43:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A685800B23
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:43:42 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-YpOGzhYbPLmot2BDmeBoGA-1; Tue, 01 Nov 2022 01:43:40 -0400
X-MC-Unique: YpOGzhYbPLmot2BDmeBoGA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7080.namprd12.prod.outlook.com (2603:10b6:510:21d::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Tue, 1 Nov
 2022 05:43:37 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:43:37 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, "hch@lst.de" <hch@lst.de>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Thread-Topic: [PATCH v3 03/19] scsi: Move sd_pr_type to header to share
Thread-Index: AQHY6ZGAv9CnhsUB1UmHhamCFRvwaK4plqOA
Date: Tue, 1 Nov 2022 05:43:37 +0000
Message-ID: <7f837cb5-8439-a1e6-48c5-d1df039d77ef@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-4-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-4-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7080:EE_
x-ms-office365-filtering-correlation-id: ec8ca20a-a1d8-4c15-fc6e-08dabbcc05f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /plEg2KBmcf6zYO2rTbZC30Gq4AZ3NjvmenQVGKTL0AeJnLRVtJtoo3CICWzLzJt5kqxoGPUefr3jTCxJzDxZThwnUOHf5mV6qVCxS+OM3PO1GSGfHgWSue/GhJJ2miBu45LaZG4xz837tqxM2HWpQBfW0t5DMR1QPIWhq5MtPUecFlYkHyoJ7INEn5mb1lUOb8mxnkXOMydcwLPYSSh/Rwp/KWqXrAWK5wvCuLDsffMDuzPmxTHw2MHGH4lB54ohGHEia0ekSyBdwYua4njusv32hYtccXyCV/HD00JLQDjQUbWA/1XvLmRZd4t9Lq5AcWjeDtuo5H6nDIF37bV0y99gcjhVGt6uB4XmUHqt2cn8iNI+UN5Q34xhQQGC9THTHaXoVk1yltpdxvdx0G5KMDvIeXtHUPJfTkJqFER6BhVYVzcMssKvnjEXB2hJsfehwgAgd0O/bZbeXEbZ22ubki7WpqsazMxS0ev1qcL4pFUGBbMAFXn4hJp1bAfN8qshqoFfdQ/e385RErdOEVHfXyXjR8/6ZJyW/Kurs5YzZyG2n+ReA1cEy2JxZe1xQElSOOAxz3MpCoUww8sC1XylSVMri0CLtr8yN/Zf3XSx9hxRdnOzHDEojjLiDF0ro5gYa+TLUMMajQrb75eNMLiOmdKV4dcAJIdN/FFR28QzXJBKxJViNKwd0emY2gAaV56mBBI/GwQDiMgkFCYN25n0QXI07fAj4VJ0DWEA6RnpQXu0j9Ka4rJLFfpwiA1CCqPDFVZn6Cxh0BQUwJgijgU47MxljAwcEs0y2dXKd++ZFGJLScTW+yqA4IpYUeXKbeyL185r4wGo+lp+GxEkoIqYA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199015)(5660300002)(2616005)(38100700002)(91956017)(122000001)(86362001)(31696002)(7416002)(83380400001)(8676002)(8936002)(186003)(36756003)(66946007)(6506007)(64756008)(66446008)(66556008)(41300700001)(53546011)(66476007)(6512007)(2906002)(38070700005)(6486002)(921005)(31686004)(76116006)(478600001)(316002)(71200400001)(110136005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3NpZEtmZ1RkZUdZck82a2YyOXladnRGQjRJRjVJSklqSjNvMGsyN1V4U2FP?=
 =?utf-8?B?N09vbWUrbWRTaVdYaW9Sb2NKZEdHNTZVVmJVeUVROGJ3ekRkTFlTRkhvbXdC?=
 =?utf-8?B?VlpxSDV2eG56UU9KSXZGVURyWGM1ZjI1THR1czcybmtzWUZpWDhWUTNLN0pF?=
 =?utf-8?B?M2FXNUZWamNkY0QycDVRclh6SG9hemt4WmovZEFLWVd0RGtna1VIU2Y5eXkz?=
 =?utf-8?B?NHVTd0pSUVNDMlVmL0xEeUl5M1E4NEVod0JoL1F5dFFXNkVNSWJnbmw1ZytH?=
 =?utf-8?B?Z3dxeC9jaERmblJGcDU4b25WTnl0cys0N3FGZmVVWHF6Wi91WFRlZDFwNGlZ?=
 =?utf-8?B?Z3NBRDNmQ1lhS2NOeExNaG9JN3JIZmdNVFpqcDgvQmxVSEIzVE9Kc0hIc05s?=
 =?utf-8?B?b1FhQzJPVzB1NnhXSzFBUXRDN3RwSTJXQ1VRaGVNTFMyQ2kxcC9teEZPYUdK?=
 =?utf-8?B?bFdOa0l1eXltdVFjZnRmWEZsc2ozZ0IzVVNRblVPeWNTTTF4YUd1eW5TSDJV?=
 =?utf-8?B?Mkd6c3hQVklPdmJKM25jOG1xTkw2TUtmUXpIOUNjN0tPeHlnWFBmaVdBTll2?=
 =?utf-8?B?MkFlM2xGSWFDa0NzME9iUDlKanhyc3VKdndXTFRpTzY4Si9YaXJHcGh3bG4z?=
 =?utf-8?B?VVd6emkzUDhsOXhGa0VjSVVKRW5MR3dGVlhvMjk4WGZnaEVkTnUvV2pLUVVy?=
 =?utf-8?B?REluL0lrZEpBTldiTkhsTEF6c3ZTa3lYOUsvbUxPME9xU29IblZEMWpVblFi?=
 =?utf-8?B?QXhMS0x6ZllmRTZ4WklxSmVYeHdPa2lGTE9SY3lvQ3pCYkR6M1JVSnhkaVd6?=
 =?utf-8?B?SUhpYkpCNWl5RWVpV2psNnR2TlFPT084dklKUENNMFMyQzU5UXVKVmwxQk1L?=
 =?utf-8?B?ZHJSaVdiSFVqbWRSaDBRSjBnL00relR3aTVCLzNSaThwUEM2Y0hsc1l6ZXFG?=
 =?utf-8?B?RXdhNXNLMDRPQUtTNGJFVEZDWDZHSDl6YXBlRURzcEpIREw4ZjZXajZZVVJU?=
 =?utf-8?B?ckE3a3F1K0JZcGhTL3Y3MVVzNTh1WU1vWDlHRURLMlE3SklxWU90UlRBdWVD?=
 =?utf-8?B?cjRUZU9OWS82WVpya0JublF3MS91MkVyOW0yK0dxUnVLNGw0cWJXekxMbWt1?=
 =?utf-8?B?YmpQWHEwRXNjVFNFS0J3V3dJY1R4U0s5Y21DWXh4N3kzeTZGeWRLV2RMQ3g2?=
 =?utf-8?B?aENiVmVBaDg4Yzg2Zk54d2FGZ0xxN1Nsd3pmQy9ocTR4elZTT0k2VnBlRDBV?=
 =?utf-8?B?NG5BZjg2WkdRVVJHTU96OVkyNXlzVjlhdVB2S2doQ2hvS3BYNXhmd1g3RENE?=
 =?utf-8?B?N2xDN29Dd1ZHY0NYbXBZM3dXc3NpSkpwRnYxU2kwOTFiOW8wTEFDMzdGaHcv?=
 =?utf-8?B?cDVCRTJReEdPY2pDUVRZeFEwUGR1c01SRENBQ0w0bUpoVk5kd1RjWG1aOFV2?=
 =?utf-8?B?Q1doSkp2T1FTYy9tZ25RcmJFYXljMm5BTGx0bDZZbG5OajNBVE1uS3pTeXBB?=
 =?utf-8?B?VERlVVFlZHFKSzlocFc1K25kUFFpY04vck1XMDBaVzZyZ2xzSVVPcWlaei9D?=
 =?utf-8?B?R1VOK1E1KzFiUnJnYXpEazNzYUxJMFpVK29ZanVqV0NHdWhvWWs0UlVMcS9B?=
 =?utf-8?B?VTdBZkx6YlhCelBpWmFoSHBGVUdMM29MbDgxZWxnVktLVjZxaXMya3lMaVpC?=
 =?utf-8?B?L3hqdkVMNU5uWXp3eGEwdTdvYm5zRzYyanQ4SlNKa0RyOVo3ZWJGeGJPR3kv?=
 =?utf-8?B?R05DNHREOElad2Z3eWoxSW9hYjk3b3JGRUZ5TnA4UXI1OVpaMFNkYUlrNDI5?=
 =?utf-8?B?Qnk3R25SZHU3OTcyZ3BjK3BrRlA5RUZOZElNN285alVaaUtIYVNJaTVuaVBB?=
 =?utf-8?B?TldIRVMwbTRFQVJBWDloc0hxV01HYzUzbkJtam9aNHA5Umw2YmRqZE04alZ4?=
 =?utf-8?B?MWRON3p0RjNZVyttSEVwdDBoYlZzU2l3TGtmUkVMMEROKy9LQ2duV1c1ZVpM?=
 =?utf-8?B?Vnh3NEovRXJtY0FDS3dNdld1ZGlUYzhjVTJpMXRBSG9JL2ljRzNsMUlDVWV4?=
 =?utf-8?B?QXBhWGN6eWdMT0Q3QWgzNUhQYU9nUURaZWJsZ29SSWRGWDBaU1BsSWNBbDVm?=
 =?utf-8?B?VnRnUjAzYnducElMejQ1cFVCQXdUdmk4aXozYllkSmRMaHZkc3g5ODI4TUZh?=
 =?utf-8?B?RUE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8ca20a-a1d8-4c15-fc6e-08dabbcc05f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:43:37.3516 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z7KUR13G2b75F3V1neu/ajvCSxLwgAxA63ooiz+fG8dYUvavGKZwzLFBILGckz4ComwXRLURzGpVx8dsZiHzHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7080
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v3 03/19] scsi: Move sd_pr_type to header to
 share
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
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4A420432A36C854AB69934C753AE03F8@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/26/22 16:19, Mike Christie wrote:
> LIO is going to want to do the same block to/from SCSI pr types as sd.c
> so this moves the sd_pr_type helper to a new file. The next patch will
> then also add a helper to go from the SCSI value to the block one for use
> with PERSISTENT_RESERVE_IN commands.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c            | 31 +++++++------------------------
>   include/scsi/scsi_block_pr.h | 36 ++++++++++++++++++++++++++++++++++++
>   2 files changed, 43 insertions(+), 24 deletions(-)
>   create mode 100644 include/scsi/scsi_block_pr.h
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4dc5c932fbd3..ad9374b07585 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -67,6 +67,7 @@
>   #include <scsi/scsi_host.h>
>   #include <scsi/scsi_ioctl.h>
>   #include <scsi/scsicam.h>
> +#include <scsi/scsi_block_pr.h>
>   
>   #include "sd.h"
>   #include "scsi_priv.h"
> @@ -1694,28 +1695,8 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
>   	return ret;
>   }
>   
> -static char sd_pr_type(enum pr_type type)
> -{
> -	switch (type) {
> -	case PR_WRITE_EXCLUSIVE:
> -		return 0x01;
> -	case PR_EXCLUSIVE_ACCESS:
> -		return 0x03;
> -	case PR_WRITE_EXCLUSIVE_REG_ONLY:
> -		return 0x05;
> -	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
> -		return 0x06;
> -	case PR_WRITE_EXCLUSIVE_ALL_REGS:
> -		return 0x07;
> -	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
> -		return 0x08;
> -	default:
> -		return 0;
> -	}
> -};
> -
>   static int sd_pr_out_command(struct block_device *bdev, u8 sa,
> -		u64 key, u64 sa_key, u8 type, u8 flags)
> +		u64 key, u64 sa_key, enum scsi_pr_type type, u8 flags)
>   {
>   	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
>   	struct scsi_device *sdev = sdkp->device;
> @@ -1778,19 +1759,21 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
>   {
>   	if (flags)
>   		return -EOPNOTSUPP;
> -	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
> +	return sd_pr_out_command(bdev, 0x01, key, 0,
> +				 block_pr_type_to_scsi(type), 0);
>   }
>   
>   static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
>   {
> -	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
> +	return sd_pr_out_command(bdev, 0x02, key, 0,
> +				 block_pr_type_to_scsi(type), 0);
>   }
>   
>   static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
>   		enum pr_type type, bool abort)
>   {
>   	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
> -			     sd_pr_type(type), 0);
> +				 block_pr_type_to_scsi(type), 0);
>   }
>   
>   static int sd_pr_clear(struct block_device *bdev, u64 key)
> diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
> new file mode 100644
> index 000000000000..6e99f844330d
> --- /dev/null
> +++ b/include/scsi/scsi_block_pr.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _SCSI_BLOCK_PR_H
> +#define _SCSI_BLOCK_PR_H
> +
> +#include <uapi/linux/pr.h>
> +
> +enum scsi_pr_type {
> +	SCSI_PR_WRITE_EXCLUSIVE			= 0x01,
> +	SCSI_PR_EXCLUSIVE_ACCESS		= 0x03,
> +	SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY	= 0x05,
> +	SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 0x06,
> +	SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS	= 0x07,
> +	SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 0x08,
> +};
> +
> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
> +{
> +	switch (type) {
> +	case PR_WRITE_EXCLUSIVE:
> +		return SCSI_PR_WRITE_EXCLUSIVE;
> +	case PR_EXCLUSIVE_ACCESS:
> +		return SCSI_PR_EXCLUSIVE_ACCESS;
> +	case PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	default:
> +		return 0;
> +	}
> +};


do we need above semicolon ?

how about not using switch case pattern totally untested below ?

static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
{
         enum pr_type pr_to_scsi_pr[] = {
                 [PR_WRITE_EXCLUSIVE] = SCSI_PR_WRITE_EXCLUSIVE,
                 [PR_EXCLUSIVE_ACCESS] = SCSI_PR_EXCLUSIVE_ACCESS,
                 [PR_WRITE_EXCLUSIVE_REG_ONLY] = 
SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY,
                 [PR_EXCLUSIVE_ACCESS_REG_ONLY] = 
SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY,
                 [PR_WRITE_EXCLUSIVE_ALL_REGS] = 
SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS,
                 [PR_EXCLUSIVE_ACCESS_ALL_REGS] = 
SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS,
         };

         if (type > ARRAY_SIZE(pr_to_scsi_pr))
                 return 0;
         return pr_to_scsi_pr[type];
}


-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

