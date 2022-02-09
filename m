Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 814B8C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 08:18:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-sssxivzvPNiuYXNv3-x9Ig-1; Thu, 10 Feb 2022 03:18:32 -0500
X-MC-Unique: sssxivzvPNiuYXNv3-x9Ig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 940DD835B4B;
	Thu, 10 Feb 2022 08:18:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71DA273155;
	Thu, 10 Feb 2022 08:18:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C55C24CA93;
	Thu, 10 Feb 2022 08:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2198hZNd019462 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 03:43:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD4BE40F9D6B; Wed,  9 Feb 2022 08:43:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B863140F9D68
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:43:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A01643C11C65
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:43:35 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
	(mail-sn1anam02on2057.outbound.protection.outlook.com [40.107.96.57])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-480-dsXASNdVPb2-NvmJiYvSTw-1; Wed, 09 Feb 2022 03:43:33 -0500
X-MC-Unique: dsXASNdVPb2-NvmJiYvSTw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by DM6PR12MB4910.namprd12.prod.outlook.com (2603:10b6:5:1bb::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Wed, 9 Feb 2022 08:43:31 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.019;
	Wed, 9 Feb 2022 08:43:31 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
	"lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"haris.iqbal@ionos.com" <haris.iqbal@ionos.com>, "jinpu.wang@ionos.com"
	<jinpu.wang@ionos.com>, "manoj@linux.ibm.com" <manoj@linux.ibm.com>,
	"mrochs@linux.ibm.com" <mrochs@linux.ibm.com>, "ukrishn@linux.ibm.com"
	<ukrishn@linux.ibm.com>
Thread-Topic: [PATCH 1/7] cxlflash: query write_zeroes limit for zeroing
Thread-Index: AQHYHY8QM/uAF/9rJU2uXlr6tMxNBayK5xsA
Date: Wed, 9 Feb 2022 08:43:30 +0000
Message-ID: <eea79469-a9d7-b80f-ef72-da9b4f4ecfff@nvidia.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-2-hch@lst.de>
In-Reply-To: <20220209082828.2629273-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c1cefde-e8ec-4a9b-1571-08d9eba84000
x-ms-traffictypediagnostic: DM6PR12MB4910:EE_
x-microsoft-antispam-prvs: <DM6PR12MB49106BCACA9EBDEF793950C7A32E9@DM6PR12MB4910.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: E3dYK8VHYi/7CR0QybZDDlLnhRy59Co5DeyfByop7w7NtDvauhViYePIEQ24rqH/0S839Av9hwT0nQmghkALWM8NfRAGszDQV5AmIkOIQDiO0rqKn+FKRAjoEDMKvqlZZ0HZlU7Hf/7+wFjBm0mQCyZ1csOinh05f9LpT0BGmE5dyP69KtgWrsQKqraB3Y/Ao3q/rZXcqw9CthCw55l8vTsoSTFlgFkpkTqPCS9zqjqLrOe72Pw4lNzXt7KMay2yJHSp216KwmB2Ms2y6dEm2pMCumPCuDurJemiEUGLS5lZDi7KQRqt2p++f2xzgEEEYfmgp9BPjb7gxVfzyXVIqibd5EOSdCMupSDlv0MbLMB0E8bPr4Zjsk20SZqsr1OVw8NhkQD1MIo3rkuBtW+kXqy2Wez3kSzdRfIGmgTn4/Wh8V9TNvm8NVYhTnrolJKAznIJB5I9C8GEUkdmANLHHqCn1fF5Xrn3L6nPI1G1fygZUFCgwzr9u6RJNUX9IJBj4uFkfIz6e7EA2NEWTZ3kLse8s7C80wW2WHIffEa7AADvg16+fsrhyY97tvBJ6S1i4pv4qBVl+j0YoBfhku2z7A9qZzp+9rrf9B1tGcWvC7ESfkY/5d6ZXzdiOcPrnrQVxzOZ+bltESiRyLUfkTCwUSTBagAujvH+HnBT0XS9kp4I1jROv2Bu+Ae71Li8Cl9gWMC7cXVoJeq7wDp46qWBvFUHDYM/7qIJeRYrosNrsPRx5+FdPG3n8wrwXgQEfv2qk0vG4IJKIPr2HSaohNZsuKqy4S50ESf81/mRZOEoSyg=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(6486002)(508600001)(53546011)(2616005)(83380400001)(36756003)(31686004)(71200400001)(6506007)(76116006)(316002)(8936002)(4744005)(31696002)(7416002)(38070700005)(5660300002)(186003)(122000001)(921005)(110136005)(54906003)(38100700002)(91956017)(6512007)(8676002)(4326008)(64756008)(86362001)(2906002)(66476007)(66946007)(66446008)(66556008)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak1NMjArK085cFJHMHRmL1d4a0RiS3Y0c0ZlNXh2Q3VQZGJwSTYzckdIUGN4?=
	=?utf-8?B?UFowVDJIVEw4NmRIYkFkcG9TaXpCM0xSZERqM2k5RE0rNVJOWExpandKM0wz?=
	=?utf-8?B?QWxDYnZKQzRXV2t2bGpYeXEyblZxM25NTVNpQVlOMDJvWFJMNGJNTlJBSHJt?=
	=?utf-8?B?dktIREUvbEFXTzdtSXJzVW1KZm1DNUduancxOGNsYzRXbTVtcm5nWnljRlF0?=
	=?utf-8?B?MC9YNVVSZnMyNUhRaStZODNFNDJrZDBaMmsrVXF3WlAxa2MxUStKVWpTWHhK?=
	=?utf-8?B?MGQ3emJKRURoaHB2YWZKbFlHZElEc0ZaaG1SNXJndXVUSVlMQkpkWnFsQW1p?=
	=?utf-8?B?dzZOV3ltaFJzL2Y4c2graWF5WUhmVHYvYXg3dXA4eFFFUWdRTXJYVjZ4dkp5?=
	=?utf-8?B?UEdHNzkwbUdPdzRPN2FOdTdNZDBmMzB2UnFzWXhYRXlpbDE5anZzNDR1V0Rn?=
	=?utf-8?B?d2pkL3RlZjIvNlJuV3lnMjhUcDlCWFVEdGFUcVlITjdWNURuQmVoUEpEQW5h?=
	=?utf-8?B?OXJ0ZVhYT2VJbFZtVzlFdkhqV0hTdnRLcm1FbDNpS2VqSEx4dTVuUmZ1Vml1?=
	=?utf-8?B?NG5NaFpTcDRHbm5Ld1hucHpWVkFTOWtTN2dkelplSjlPQzBOQ1NlSzF2SGht?=
	=?utf-8?B?cWhGTGlwVkNVRzlrd1FxMmRjd1R4cTZvbkw0VFNCNzFBaTl5VEcwUFFzbHIv?=
	=?utf-8?B?VmRZZitzWkhkNnRsTE5FSjNpSFVFdllOMkdjNEE0bzN5YjR4d1ZuQSs4KzVp?=
	=?utf-8?B?UTR4YkRhajFtMU9LSEV6NHR2eGczQmZCRGNKYWpEdWFyU1FZZXlsWTNZbG1S?=
	=?utf-8?B?T3g0WXdKUzJob0o1c2ErZVdmUUxlRDlWcW9mZjdIeG5pSFhHTWdPYW0wZm5p?=
	=?utf-8?B?YnFDaGJhOHR3MHR5SFNBYUdtREx2dXVLazFYb2NyVXk3bGlvMVRPSlRpaTNj?=
	=?utf-8?B?T2R0TTNGQXJWVEZud3JQa0xBaWpLUjEzbUpsTXRSMDl4clNPamtNMVRQNmJl?=
	=?utf-8?B?cU1YSnQ0dWtEdUR1U2JxMjZTWkd1bzZDMzMwWFgwV25sRUJnY0dpNzlLZExr?=
	=?utf-8?B?ZG52d1BQZFU0TUtNaS80TkxndElvUTgrYmtsOUQ4U1hIK0tkdnBzL2lqK0xB?=
	=?utf-8?B?blowWWRsU093N3czeTZpNDRPTGxiSHZCdFJKR2paN0lMNkUzWDhHMGpDSXBO?=
	=?utf-8?B?NEIyUmVwSTh2eVJTMTZNbG5hQ0plaUw0bjV0Z3VpL1BueWlvZklUd0JLd1Av?=
	=?utf-8?B?S0MyZ2ZNa1k1ZEJqMGNLUTVZeDYzbWVZT2IrU1lRaU8vMTdiZjVGa1kvQWtU?=
	=?utf-8?B?bWtqQXlqc2ZWODJ6K2pxUTRHeVYraFptdFJRYnFlOFI1NmsrUmlkYzhBRzV1?=
	=?utf-8?B?c2RlcXQzdjZieWplSWZqYnphRDVhTGFuYnU3NmlyNkhiMkJHb0EybU1rSzYr?=
	=?utf-8?B?MjlnNUtMUDFmaGhsL2gyNU11UnRnOWRkQnJYM2F6NU5Ga3ZQRjUxNXV5Nk8w?=
	=?utf-8?B?VWpJUFZRZVI3UE90SHRTeGVhdjJuUEkyMFFXMlovVHFTcG1tanU5b1IzV2xq?=
	=?utf-8?B?SGlmbS9zSUhMdCtvV3JCQTZ3c2dJV3lHcnhab2UzT3BMRkFSbGVLRGJzaEVw?=
	=?utf-8?B?bjFzNTVra3hHaWlaOHJySXVUem0wN080eGh1WC9tQ3lmSWFFK2FmVngyUWhi?=
	=?utf-8?B?aGJvdFVFRTBlY0VpSzFmYUhhWGEvLzNtMFIxYVMrN0FTQjVoMVhVejVVVkVU?=
	=?utf-8?B?bFRlcjdZMVRVOFl0U3FZWElDQ2UvZnorR1h0VHY3djV0RjVhY0ZaU0gzQkpK?=
	=?utf-8?B?VldRY0EzbzdMeXRJOEN6M0VnYWNRclA0UG9EdFNTaHZBSmYvL000S1czTTF4?=
	=?utf-8?B?MEVIc0ZaKzRBc3IyUmJ0R0lvR3NiVkpQcVRja3lRWlZkb25WaEc2cUFMSU1t?=
	=?utf-8?B?Wnk3ZmlhWUNXNnZFcGJNWm5yWlYzRHJUWjU4T1U4SktxYUhyMWFtZGtPaGJ6?=
	=?utf-8?B?ZlhHN3hEbmNHTFpNdmsvTUpJc0R5NHNSeHNnbWxUdzhIYTBiZFRpTDEvQXJX?=
	=?utf-8?B?NGhKMmlERDVjRUhIY1VWM2FzSGNuWUZSUkRHQnJsYlN3R3RIV21OcitqdjlE?=
	=?utf-8?B?aUdLanJTV3Vkamg3NG9TRDdLSHh6cDFna1pkWWtzTnNHNGJJRTBnbVduZ2lI?=
	=?utf-8?Q?HeYpDc0YlfkWQ1PHi2TlLzQ+kCrxXSjjS0iOObPqzxoz?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c1cefde-e8ec-4a9b-1571-08d9eba84000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:43:30.9635 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o9XIwn5bPHr5xJ+Vwxg48S/Q77AULe0t2p8dWv22AMoa0tTgiAZcbcL20faZ3nZbIklqTabXJEf23EnTBseOjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4910
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2198hZNd019462
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Feb 2022 03:18:24 -0500
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Subject: Re: [dm-devel] [PATCH 1/7] cxlflash: query write_zeroes limit for
	zeroing
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <CB74BD47A71E634E956120B732D5F90A@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/9/22 12:28 AM, Christoph Hellwig wrote:
> The write_same and write_zeroes limits for SCSI are effectively the
> same, so the current code works just fine.  But we plan to remove
> REQ_OP_WRITE_SAME support, so switch to quering the write zeroes
> limit for a zeroing WRITE SAME operation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

