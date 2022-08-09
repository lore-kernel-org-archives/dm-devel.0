Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C5CBC19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 10:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660042550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SL4ZzRfVRzHbhZvGZNO9S13Rk0bcnQuMuf6fuXhM4kU=;
	b=hE7O+mhDpPy0Xc+Oi7dnk5z7rrPmCO7JKjElvUFuZKBRCah/rYHmbDL0+4e4G6h0Cz+W2y
	EOaua2M+occqtn5pmXUSkgcX8VZIa6YQCFF3xSzdc6U23yMDEch5T1OYwFkZYc5i69o7N0
	q0wCytLP7ou7QkhK074UlvJ0HY3FdTY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-3-kg7p2WN3GL10a2myb7ZA-1; Tue, 09 Aug 2022 06:55:47 -0400
X-MC-Unique: 3-kg7p2WN3GL10a2myb7ZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E52F4280D221;
	Tue,  9 Aug 2022 10:55:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66D792166B26;
	Tue,  9 Aug 2022 10:55:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 22D151946A4D;
	Tue,  9 Aug 2022 10:55:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F0481946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 10:55:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0A5F99457F; Tue,  9 Aug 2022 10:55:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 05FD29459C
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 10:55:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFAB98032F6
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 10:55:42 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-4AImxw4VMVaydYzp0FGxVA-1; Tue, 09 Aug 2022 06:55:41 -0400
X-MC-Unique: 4AImxw4VMVaydYzp0FGxVA-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by SN6PR12MB4704.namprd12.prod.outlook.com (2603:10b6:805:e8::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 10:55:37 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 10:55:37 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>
Thread-Topic: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Thread-Index: AQHYq4PmjV2UOnxHHEaZfkf5ZGRZ762mZhQA
Date: Tue, 9 Aug 2022 10:55:37 +0000
Message-ID: <de98be35-c5e9-742c-5d9d-fecefaf3c667@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-10-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18ab9b64-b62f-44ad-f9d1-08da79f5b110
x-ms-traffictypediagnostic: SN6PR12MB4704:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: IeLmC7wJpLkozJQnfTMh/P3TheSQaX42cL3qX+/LnTxHclBwgxCIUP7P/GRfrNdJTifnKTsLkrai0aOv49EdFFTgZvF4xs3TlNW0B8bkSIc9+X8zbh3396sdAw61rP9+hDipc9gkaow/rCcVtP7quqwezzCXmvhwWGeIgHzTZ56s6aTgyVVuLMaL8uf8VoSGIlqadG6DOVmliv33fMDClqBu1Kmem2WLVATyhWHH6DT7u3rM2giJShLxcvRi/KlJaWdcIzfK76v/5LvUVakklWmzpEzZeSl0icKclDduRuEpjX32B1Z3Fp3A0P5itOtfpZSp/EIqCsOPmtD/H7sprKYmkpu44h3xpskbQl7RYYqjfcG96Gf3gQsuXsTEcrnQ9D1ElIyuDGrIQg4gKipLFqHR+0zsL1lNuHQd9/PxYGfLKWI55ZT9NqB1R7p7na1QE5daIO3QwWF0ooyHOD7BSxDasMzr52iNmN8QO24TxTVowrWvv7nXVokGA/wvfeTDv+TWSNovJSNDWdQLWSVXyajblQKoNGqGAhJHYgum3948Ri5F7T2O8MOdJu+kndIMIH2SkiXESJCOxDVD5HYjLgYGRk1X80+VixP/+tKUITZoITRzKSgKiw1eRRbGelhfXCf3JabtyxXo38s0TzIcIV9I3bc4AfjxjBaQOCTZ9lM6WXlT0y1hnDNK3KZXyVuTNcQ/QqYQcTe79pvzj+JD+8QclDsZZRVMLmY9/68ZLt3i/+3YdrOHB9HwNlB/Lqjyc2tmHnsVxtH9hgalZIoAKwc/FpFoFkb0Rocg99XI11JVVymNd2P5oBclzBmwiYaGJ0GZa1kLNHD3KOmgEGIVDLaJVeOlHu4fwEHdrVbF/b0=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(316002)(2616005)(478600001)(2906002)(54906003)(76116006)(64756008)(66946007)(66476007)(66556008)(41300700001)(91956017)(4326008)(31686004)(36756003)(6916009)(66446008)(8676002)(5660300002)(71200400001)(6486002)(38100700002)(4744005)(7416002)(6512007)(38070700005)(86362001)(53546011)(8936002)(31696002)(122000001)(6506007)(186003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFJuMGVUYlY2b0hpOStHMm5DamYzY015aG1WWVZvVmE2RUxhUzlhUDlES2NU?=
 =?utf-8?B?d3lzek1Td2F4MHFVU3ZEWDNSWjQ5dVB0LytKS05RNkxIS0ZIRXAvTWFvMmxh?=
 =?utf-8?B?RXhqQXBuYU11VU13RzRvOTNRbkZySk9FdEwzSTMxb1NRb2tnVjg3bHkzaEw4?=
 =?utf-8?B?ZW00T3VJV3NaaFVOTkc5enVYNHhsdi8wcEdtczBHMkZWaXRuQTN4TzV6UFBF?=
 =?utf-8?B?b3JWM3FKNUd2enlWRFQ0bkFPaDdmSnNnU1Y3NkFib1pDS1A4Qlc3V0hzSmla?=
 =?utf-8?B?VVdiMlBPVEtDREZQTkxqOEtjVzUzaFVKTk5UUHhnREJaREhlYWFxZElzb0V1?=
 =?utf-8?B?bytOcWVXcU1HQXF2cGE1SkpVVXpkd2FkVlZoYW5sUFVHODNRLy85L0ZSb3g4?=
 =?utf-8?B?T2FXNzZMOFR3RGdlY1NSS2dTVnNGc3hxdnpuZ2MwNmp2eW5WWGJveEE4R2JY?=
 =?utf-8?B?a3JCUExRT2lIZEdCN2QwNG9CSncxVk1Dd0w3S21kb1pTWXlpZTF1alRiNWs1?=
 =?utf-8?B?bzZ0V0pWL0k0RWRBTkpKeGl5emdQNWQyQ2ZEcUJYUDAxZHhkVW1XYnBwRHlx?=
 =?utf-8?B?azNVUXMyQ0pJb016SGI1MmE2d2owRXlHaVhrc0wvZGFDWjM1c2hURDkzWkZI?=
 =?utf-8?B?REFJbmd1aVNuVjQ5WCtVcUdXUEd5S2NZKy9WdjFheWg3R1NpaDFaR1V1MG8z?=
 =?utf-8?B?L2o3blZGbjJvWEZORjQzWVhxSDkvVTFTS01QcVBxWnVxcmxUenhud0hOVkUv?=
 =?utf-8?B?b1k4WVJQTWJXK1loZm9RZXJSRmVMSGRhSU1YN2c3dVJwejZON1VCRHVCcGh0?=
 =?utf-8?B?ZElkajB6UmlvaklNNGMwandMN1p2RTNBTGJkOTdpdHFQZ0tlTW9nUlhWcEM1?=
 =?utf-8?B?OXZqNXhMRSs5dzY4cnNaT0ZmU1Q4dTgvZEhIOTU0djlMRzZPckJDbi9tb2Ur?=
 =?utf-8?B?S3Q0MGRaV0ltakJiSzBjQ0l5TFQyR1lpdDJId2ZJa1pVZ0hJSXJuUVFmZ0pK?=
 =?utf-8?B?d05kYWVvR3ZjM2d6bnVyaTcxWXNZa1g0UlhxN0RtbWlOS0s2THlQNC9qbDh5?=
 =?utf-8?B?MS9hZmRQZ1hjbkJabHZ4elV0TXRiamd2Mk9Ub3B1bzZLeW85S0E3UmVkcUwx?=
 =?utf-8?B?ZUNRUGRjK3RkVXdnQjJiRjdaQWozaFdBdER1VkErSzlVWHBZdUUrdkxEYm1z?=
 =?utf-8?B?bURVNC8vQVArOFpwcFVNNzNzWFpPQndsUmxrRnNjZXllSTBLeTJUZzkwdnZW?=
 =?utf-8?B?Z2JqUHE3eGFYaDgzbjI1bnFZcmlSb1A5a2FrMjRWeXE3UG9xWGZjczVRNHNM?=
 =?utf-8?B?Q3VQZHRlSkhTNzlEbzFpV0dXeFliU2RKNVFHTG1nZENOUGpEc3QzZ3NOZjZ6?=
 =?utf-8?B?RExDeGhRSVV2dW9yL1RPTWYycWs5TzNCRXBsMU9GaGtkeG5ONHpZMEN6OU9C?=
 =?utf-8?B?UTMrYXJXQW1IUjlqN2dHUjdSUElmMnN4ZW5NdE95dFBVYW12M1UxbzJhQ00z?=
 =?utf-8?B?UFpZaG5PemZhenJWOXZhQUxsNCtNV0RzMUNzb1RLQ0Uzc3Q0K3BnNnVkZmcy?=
 =?utf-8?B?dEVvTUhSU0M3OHJPWURpc1FqWnJkeE5kVlB6NEMwdWNIY3NNN1VlaFpWb1BI?=
 =?utf-8?B?TFdML2ZDKzJIV3g5Z2l0aWRSQjh1eURVTFRsdE02QnlKNCs4R2loK3hkejJh?=
 =?utf-8?B?Vm5QUHB6blY3dGJIL1ZyeWpQYnNMZ3FmcWdZeGloL21sOG0wb0VDTEFuUkhx?=
 =?utf-8?B?OW5ZRCtUZGhkQnhuZ3ZhUkl0eFh3QTc3OWxnWWRQTjRsejZjNW1PRG1UeGxl?=
 =?utf-8?B?UXM4cWxPNUM0NnhaTk5WQitWQ3B0RzZ3QU15YWRzWmZqN3g0dFVHS2k5MFBx?=
 =?utf-8?B?QTZJUFY3bENZVXdwRS90Q3duTXdSaXcxbmdhNklnbzl3VzZoN3JFemF3MFcw?=
 =?utf-8?B?R0tTdXBmaU01UStIbzF4RnMxMlFKck96bkwxUzY1U0RhZUZGVEkwb3BtZVhF?=
 =?utf-8?B?Z2JjaGs3Y0RXL0ZDcVFPS1VGdVVqRG9xQ2dGcjh2clNOM0tUei83eHBZWGhE?=
 =?utf-8?B?KzJ2eGc1YlNua20welBjMHRObFVDcGdlalkxMUFsdGRmMk00YVFWQkdlRk0y?=
 =?utf-8?B?Z2NGU1BRT3dGQ3h2L3FJYXhSbDdtMC9RNWF6Y0xMUmQvVXdCMTFsdk8yQnYy?=
 =?utf-8?B?Z2c9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ab9b64-b62f-44ad-f9d1-08da79f5b110
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 10:55:37.0505 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJ8nIffL+0hgFYtsRnjaU0tFBg3h3+2QOmPjmi3llOefcMjkNQOuWmoow6pSiFUPsTgXVeHRBg7tORSXYsLU4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4704
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <166F20E83C97164DB337E7BED2C534F1@namprd12.prod.outlook.com>
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

from the comments I've received in the past, please add a function
in the patch where it is actually using it.

Also, please consider if we can move pr code into its separate file
if others are okay with it as host/core.c file is getting bigger.

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

