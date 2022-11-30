Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 864BBC4167B
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 00:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669766720;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vGwpXJvMJoywvtD2L8SZGzddfY+yvOmpeK6D82J8LJU=;
	b=PYDa0QOm9/kyf0iHW/u8pByNnZVQWOk6TC0B2uvJoc+KT9tn4tFATBpFQfAo3yb+bRoFjB
	WBPpqHk5OlOQgg9eOwYP1oY9XJvZdI6u5quRMuNp23TjQFMTEY3uG2qiaRuzCBBO046A+F
	9EPwZ+KDF5ACUtFBxnlzJFz09JiutNg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-R4BTLJGgMueI-RkCa4n5IA-1; Tue, 29 Nov 2022 19:05:18 -0500
X-MC-Unique: R4BTLJGgMueI-RkCa4n5IA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01BBE8039A5;
	Wed, 30 Nov 2022 00:05:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F65640C6EC4;
	Wed, 30 Nov 2022 00:05:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5BD3E1946594;
	Wed, 30 Nov 2022 00:05:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 94D00194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 00:05:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 687C840C6E13; Wed, 30 Nov 2022 00:05:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6011A40C6EC4
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 00:05:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4213185A59D
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 00:05:15 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-b6cX5ipTOpmt1mYkQ96JeQ-2; Tue, 29 Nov 2022 19:05:05 -0500
X-MC-Unique: b6cX5ipTOpmt1mYkQ96JeQ-2
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN7PR12MB6888.namprd12.prod.outlook.com (2603:10b6:806:260::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:05:01 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::f02:bf13:2f64:43bc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::f02:bf13:2f64:43bc%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:05:01 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Thread-Topic: [PATCH v5 00/10] Implement copy offload support
Thread-Index: AQHY/wLEUhEocurOikWuV2dsph+j+a5NH5cAgAi7OwCAAMXvAA==
Date: Wed, 30 Nov 2022 00:05:00 +0000
Message-ID: <a7b0b049-7517-bc68-26ac-b896aaf5342e@nvidia.com>
References: <CGME20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5@epcas5p2.samsung.com>
 <20221123055827.26996-1-nj.shetty@samsung.com>
 <cd772b6c-90ae-f2d1-b71c-5d43f10891bf@nvidia.com>
 <20221129121634.GB16802@test-zns>
In-Reply-To: <20221129121634.GB16802@test-zns>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SN7PR12MB6888:EE_
x-ms-office365-filtering-correlation-id: 616bbd5a-214d-46ae-2d62-08dad2668674
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3FnlmPXME3oMTZeBJ9XQni9kLGFc/0E+gZ52gK1btth5L9afAMIqssPBoOvN/zlUpu/apg//Pi9BBCJ6TY04yEgXTCGU5nMNL5MO0j8gZDW7VN1Vv2z45HYtFGdc8fNbWpWPebk+Ev/F/IaoGMTtC57otFw2QFqpSa+xs5fgIlsRFE1bcCd+GenzbC5A9bklKvGZYHeFapRweazg7pv6HL+TcmXsOU5Szh9CnnmkvUq7vm1Sxv81M4X09LJZr6gTV41igNqiH5KQnTR89xD4Kc71Rb2H5lCLkCbyoCOLJRiPOdmBl4PQ6YYOfTYSrqRE+ge2pSzt+qwSXYk2Mulwqf400pI8IHVbefNxX/G0rNOD1PhR9fz1utBSIgVsXzxD+Yr9cz186T6Df6x+/zMH2qMf21f6UhABv9szYFardQVtglhaWwhVzdXGQ4SWYxkvwT+A6Y9L5lKa5i3JLCKDRHlY2W6Gm9jNzj2NkMDNRUvW9rACXehSPABO3vYfsuUBCyIe7HeZSsmj4VE5sU9Knb7D6hLxPPOUDKn4Vv08Oue/zHCO5nxmlJG7Ve+2OMsyuv2bJv3sWbGkmZ9oRJQAssbwqj62CsQm3xWKrGkC4eEp+BZ9DlFXs6QSeZ832wRHntZfv20emYYyYvZZK38HMyhNV7wZmQIVVSUkTYwuvLAXGjZd3MfDYfOFeTOW7GZ6sD+IPOW08okPUkaYLiIXpQGIKln3gzD5v5W+vurof4EjJg+M5FDsBFc3bOdfIgNpz/EIoXvR7cNY61NfAogQYQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199015)(83380400001)(54906003)(86362001)(31696002)(38070700005)(2906002)(38100700002)(66946007)(7416002)(41300700001)(66476007)(8936002)(5660300002)(186003)(53546011)(4326008)(6506007)(6512007)(2616005)(66446008)(122000001)(316002)(6916009)(91956017)(76116006)(6486002)(8676002)(478600001)(66556008)(71200400001)(64756008)(36756003)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUFSMDF0T2xsVXUyOEM0Y0xJT3FzMk1kaE0rMnVsNmpyL2lrY1F1MUd0Y1px?=
 =?utf-8?B?Mm9kMkROcFBpbzJPbzUwSHNxUFRudGhGazhaVUpZU1lrT01iS3JIaFhabllp?=
 =?utf-8?B?MFB6K013UVZ6NnRTTTkyT0Q0anpNVUh6TE0ySVpYQXNxR2d0a2RqbWpQMm93?=
 =?utf-8?B?SmlwVER3OXpJdjFIaC9ZRTBBQnIvREloTjJGNDJ2VnRsaHFlOXVQRSttVEdj?=
 =?utf-8?B?YWhLbWNwcXhSN2hzV1JJdVdjKy9aRTQra1VCaERoRktpcytENVd1YnN1N0xS?=
 =?utf-8?B?dmEyR0lsQmI4L294and1VFBjTUQxeTVObDR0dnVtTHNSakZUV1hVcFhpMkxq?=
 =?utf-8?B?MmlWT2ZXQlh4dUJtUUh0TzNtLzh3WWJIZjhyOWI2Q0FLQkpXS1dIR0srcDJa?=
 =?utf-8?B?OWxsNnVJRGNCWnpiWlVuN294K3VBTEVaRUt1NGdtNkZCYTJDbFBkUHZFREM3?=
 =?utf-8?B?b0ZVTnk3azZRMmppY0xqOWN6SVEwd3R6K3dBcjdod3FMU2czQW9pajcrSE5r?=
 =?utf-8?B?MnNWQjhmMExYLzh6YnFvRzUrT1FsUHdEUjNTdzY5VGs5NVdiWkNWM2E0Vkpo?=
 =?utf-8?B?UXEyS0xJaVZjSkxDWlRnR3FsQ3h6S24wRFFmQWVnRXlLYkV6VXhEeDlBbyt2?=
 =?utf-8?B?N3BYZEI2OEJLNFpaSjJwWFhSbmhEV0hkT01uRGJSeFY0MElXcU5WdytnNWhF?=
 =?utf-8?B?QXl6bXFkWldhU2lhWS9ya1hXMHJVZEdOdDlQYS9rR2wyOTArMkNnN21EWDJ4?=
 =?utf-8?B?Y1k5V1JRclVCckVUWk4rVTBVeGZLdXhHZkhqY2djT2lXdm5kRUc1RGVUdkIr?=
 =?utf-8?B?eTJZSVo4SmdXRDBtM2s1TWNvcFE1ZE9wL0dxZC9GWUpNaFkvMHNzcFZpZlVu?=
 =?utf-8?B?YWkyMUdINVBvQS8yMTl1dXJKU1h2cDNWTTFEajBEN3owMVpZdnJsOWhNQ2Yx?=
 =?utf-8?B?MzExaU9BUmJjZzFEZVZJYktzdnpxNFEyM2hKM1g4aDJEQndaQnQ5MGhBdGN4?=
 =?utf-8?B?NEg0R3phVnB0Q1Z5S1hMb09iY2NTMXNCYjVPSWFBQlZuaW9FOHkyQTloU09t?=
 =?utf-8?B?VHpSNUE1QTBGeDFENG43emlwNzUya0IrTjFjVytzbmhuVVIzN1FUWGQ3YTEx?=
 =?utf-8?B?YUdXSjk4bmt3UFVuYkIzb0w0bEVCQjRIYlp6RnYvNmVsOHNQVmppeDdyV2FQ?=
 =?utf-8?B?MDB4RCs3NWFobi83MXFNVVRzaGFSay8xWUdxVVJEbExMbHdzRXpZc1pmY3Mx?=
 =?utf-8?B?S0JYQWFXY1Q0V0V1S0RxUUZreFNuTkZJWlhsODByajlmQjdITlNVcVVIakcv?=
 =?utf-8?B?aE1YV1hTTElTRnlMWGZRQ0hXYlhaMXFvaHppTHdVeGRtUE96dHR5UjNZZW9D?=
 =?utf-8?B?Q2VQU1F5R2IyWlN2MjdhUmRMemhjci9oY2tWeHlzbTFnQjl6RjRheUpQWVVW?=
 =?utf-8?B?aFRuZUIxMVZ3NVhmbmlZQ3VMaDY0Q3d1a2x3OGdEaXB3Q0JXeXFSNGZVS3Nk?=
 =?utf-8?B?ZmV2OWV6ZlkzK09zZXRhTVU3aENMK3NFeVFqSThOek44NExXaW1sZ0hxUDlt?=
 =?utf-8?B?NlBSd0l0WGs3WDcySU5keWs3dVBuQkJubFJGMWJLVjZadTJyenhMOGpGR0U2?=
 =?utf-8?B?aHh3RVNLQmRvZVhTaE9jN3d6UnhTdGRJMXRjSnJkcXhwakJSMnEza1FxZ2VR?=
 =?utf-8?B?am9nRmdnY0VxRy85aHdkQ0ZqMEVNQTlXRlIzUlNVZk1aUjkzcS9CVURQSTls?=
 =?utf-8?B?OEN6KzFDMXYrQzM5Q1BvWkM3TFdmUE5Ic3ZVOStZQWkvVW95Sk9ZblRROEh5?=
 =?utf-8?B?WjlwWkw2UUY0bUtsM2JsUUdoWktybWlLUTVqVlIyVFJoT3QveXFnQnRCa1g5?=
 =?utf-8?B?REliVDN3YmxBK25VNTNoTTNUNkQwcy9PZkZDclpHSG9NRVRCeGp1MEs5a3Zr?=
 =?utf-8?B?NXVyNHpnWVI1TFNQckF0NnBVUXIwMTg2NTF5aGtTOHVmcCtzMjRWUmZ6RE4v?=
 =?utf-8?B?RmhXQ2w4R3p3ZzkxVmhOV3ZiQ0owL3hoeERONW1FSGtuNmNYRUN0SDVlc2ZP?=
 =?utf-8?B?b3h2V214enNvWjRKRlI0ZFoxTGN4VlZLWVRhR2hjaXd2aC8wSGhSNUtBSG9H?=
 =?utf-8?B?MnR5ak9ZYnR2SS9oSWZiSWdIeENrN2IxM2gyZXJQa09hNVlCZC9yREMyK0Ir?=
 =?utf-8?Q?gxVWHCsNdidGDu7XdIZCs8tiB9v0CMT6KvlLp1LB5sPL?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 616bbd5a-214d-46ae-2d62-08dad2668674
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 00:05:00.9979 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaDO6UBIVs/cLtT7BNu/nEs/4tf8Wf6bPbhv7Xttv1o0Ok1wvApPX9kwhBr7ZCCfICLfhtg7gkAWemShJVA9ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6888
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v5 00/10] Implement copy offload support
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
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>,
 "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,
 "sagi@grimberg.me" <sagi@grimberg.me>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 "james.smart@broadcom.com" <james.smart@broadcom.com>,
 "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
 "p.raghav@samsung.com" <p.raghav@samsung.com>,
 "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
 "kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "jth@kernel.org" <jth@kernel.org>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C7D76B178A2A5C4B83085D5EBD91E1B0@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/29/22 04:16, Nitesh Shetty wrote:
> On Wed, Nov 23, 2022 at 10:56:23PM +0000, Chaitanya Kulkarni wrote:
>> (+ Shinichiro)
>>
>> On 11/22/22 21:58, Nitesh Shetty wrote:
>>> The patch series covers the points discussed in November 2021 virtual
>>> call [LSF/MM/BFP TOPIC] Storage: Copy Offload [0].
>>> We have covered the initial agreed requirements in this patchset and
>>> further additional features suggested by community.
>>> Patchset borrows Mikulas's token based approach for 2 bdev
>>> implementation.
>>>
>>> This is on top of our previous patchset v4[1].
>>
>> Now that series is converging, since patch-series touches
>> drivers and key components in the block layer you need accompany
>> the patch-series with the blktests to cover the corner cases in the
>> drivers which supports this operations, as I mentioned this in the
>> call last year....
>>
>> If you need any help with that feel free to send an email to linux-block
>> and CC me or Shinichiro (added in CC )...
>>
>> -ck
>>
> 
> Yes any help would be appreciated. I am not familiar with blktest
> development/testing cycle. Do we need add blktests along with patch
> series or do we need to add after patch series gets merged(to be merged)?
> 
> Thanks
> Nitesh
> 
> 

we have many testcases you can refer to as an example.
Your cover-letter mentions that you have tested this code, just move
all the testcases to the blktests.

More importantly for a feature like this you should be providing
outstanding testcases in your github tree when you post the
series, it should cover critical parts of the block layer and
drivers in question.

The objective here is to have blktests updated when the code
is upstream so all the distros can test the code from
upstream blktest repo. You can refer to what we have done it
for NVMeOF in-band authentication (Thanks to Hannes and Sagi
in linux-nvme email-archives.

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

