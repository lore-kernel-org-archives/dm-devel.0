Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18DCDC19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 11:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660043373;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W5BubLEKW3QAwcltQ+P7DRaP0SE4IueKWck+y1icRNI=;
	b=fstisVN71gZOVq20atYm0WmaL/Czjy5TwqNnn+B7gye7hi+HuDGy5qFn3uJ2Ig6y59uroI
	aFnfvkiROR2vTDWCGyflt1PseyFWLAK8H7/39jF/pGbXhwEUGzwMNxH2dTJ4siWpvLrhSf
	GPtAlJnKiKSv/0wDUXdPUw3Jh1ep0eQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-Y4NvTlToMgqz5ruzUGKPGQ-1; Tue, 09 Aug 2022 07:09:30 -0400
X-MC-Unique: Y4NvTlToMgqz5ruzUGKPGQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 885B885A587;
	Tue,  9 Aug 2022 11:09:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38B8B9458A;
	Tue,  9 Aug 2022 11:09:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D0E331946A4D;
	Tue,  9 Aug 2022 11:09:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9A2C41946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 11:09:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7DE5D40315E; Tue,  9 Aug 2022 11:09:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 78997492C3B
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 11:09:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A5C8811E81
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 11:09:26 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-OgWpTeXlOiS9w6bWjUmgZw-1; Tue, 09 Aug 2022 07:09:24 -0400
X-MC-Unique: OgWpTeXlOiS9w6bWjUmgZw-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by BL1PR12MB5849.namprd12.prod.outlook.com (2603:10b6:208:384::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Tue, 9 Aug
 2022 11:09:21 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 11:09:21 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH v2 06/20] nvme: Fix reservation status related structs
Thread-Index: AQHYq4OnQJFgwy96dEGx0Jin94g0eq2mKb0AgABALQA=
Date: Tue, 9 Aug 2022 11:09:21 +0000
Message-ID: <6df45cd7-7824-6676-8ce8-3e6e06838444@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-7-michael.christie@oracle.com>
 <20220809071938.GC11161@lst.de>
In-Reply-To: <20220809071938.GC11161@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3fe32db-db0a-439e-b5e3-08da79f79c3f
x-ms-traffictypediagnostic: BL1PR12MB5849:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: qJP/+QcQb6//uARap75l/qf/F7Qy5PtnNl24fh6TEr+3hYPH27dCYQ9TKqUrTzDyNYturbDWsI4LnYz86E5cDnD/U+SnQNZ8T+0+MwPl0vSrevTIq7opouk6WBCy1nH5QOLwy6fHCp+Uu/EpNsnIHNkBMjyzuROAMCUyfphVAzNm4+1FB4LmyTm+5bPdc4JuNtf6DX/MczIfo/Ew4QhlfbGnkipK9KeZceKP5p52W3DLZHWO6+m5/5LlOZJV6CiUTMsvhkteEFGMRdLKVMKYrVR64JlWC3CXSmoyxEHJmU1uH5X7I4PfcR+IhaMijuFkJslJyE6CwdU/tWlgO1M1TThwmuu2wwuOaeZ6imPuFyXtCx81GzpCOnsDcQzr8WDi9MONZEZiAwUytWjr3TcvcXTYcEtOg/e6eOVf1wg7qWe/Ry3JfxRDpRvnD8McWS8saERJRRXboKZQjcvj9Eb0e4VYBjwNbLe0oO+G1ZslB3UmjxVMT1EeWMIEiPjuHgC2WB4ga074i2eomTswKq48cGeFcFdwNOKZOlGTllKYPXEr0XSw+Lmbt0+wyDrMiMRfEK9FUkMs/oLF55FwhVL1WZ0DiV1/MF4G5CgZR656phdZrx7KqmjHALoXJFyuijzEM3jnlWdbW8cxmT+x8rJDkp2Cp5Kz7YQ/7iBRaCAXGichYXiKHeaAihf+Ofn6C/Z9r6TVNv7/6c/6htp26CtO3PVXtwuG7BSZf4lQyuF4ReO2OkKVhOzSLnX0E5Brt4lpsbuFxoC0YJwWeV4XV1/dGNm3BjjE+jZCd0Pd71H7TVC3zw+GxBC81MJqowLFZNZtlMxeHp4cnGiamK5h5AyP18KIHW2vGDax/b+zm004Gso=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(6486002)(478600001)(54906003)(316002)(6916009)(38070700005)(122000001)(186003)(2616005)(41300700001)(7416002)(31696002)(71200400001)(53546011)(86362001)(6512007)(6506007)(76116006)(8936002)(91956017)(66946007)(4744005)(66556008)(2906002)(5660300002)(64756008)(66476007)(4326008)(38100700002)(66446008)(8676002)(31686004)(36756003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1E2SHF5US9rUFN3UHl0RUxNNGdNcFA5U1hCZFFyRzE3V2FEdkRpVFFac2Ja?=
 =?utf-8?B?ZFNsS1dKSUdYSm5GeU0zeUZxN1IzZDR1Z0E4OEFmVnM2TURqMnJsRkF4cGlR?=
 =?utf-8?B?RnhNaHhlMDZBbTdvSW5xRXhvWEQ4aFMzNVp3Y21ZNnBGVFhpN0I1UkNhU3I3?=
 =?utf-8?B?ZjBTaGszZmMxN3h2VVBGQ3VLOGl6bFM1WEhVaHIzYVNqbXFyeC9VTDVsYldN?=
 =?utf-8?B?V2dWMkpmR2xnOE1SZnVZU1ZNZFl1eDM0UFExdmtQWEhTWDJ0YU9nV09ORmo0?=
 =?utf-8?B?WVIvdnFQM25KUGRZQ3hrOGV1KzBheURKS2lKWGIzcmJacTMwS2kyNWJ4d1U3?=
 =?utf-8?B?a0oxbXk0OUhJcWdwc1NpVS9JNFIxOFBHT05RUlRPVjVCcTVlOEk4ODlLSzFD?=
 =?utf-8?B?aUFVZzl3Z1hKcWJicmJrZEtranAvQnJMR0ZHZ3htM2lUMzcyMXFJVTV0MzlX?=
 =?utf-8?B?Lys5ekRjYXVXYzlFVzNud25UT0xRM0N4aFo4MHNreVpZYktQdFd6eVhpc0lu?=
 =?utf-8?B?elNSZ0IvZ3ZBbnh4SWdDUlVSbG5LTUUxdXFpUUl3SG1zeVFwRzhmL29zVXdz?=
 =?utf-8?B?alo4cjgwcWNZN0p6U3BlekJKczdMd2laSnB4TDJmRXQrR3RuT1Njck9nbUwz?=
 =?utf-8?B?Yno1eEo4bnkxVE9ValpjUTNHblJabitTdUF0THV3QUdFdXMzbmZpcmpMMzRu?=
 =?utf-8?B?cGh2T3h5aGFiK1F1MlJ6cTJVZk5CRWlyb3dNRi90RU82Q1FvSjQ1ZFhNYm1m?=
 =?utf-8?B?ZHBYb0ZXK0JUTFJ5NG8wNGF5VGhrclN3cFh4RDQyMjVveWlWNERNU0Rlb0ky?=
 =?utf-8?B?bGZhL0tlRkZIUGRxdWZlcWxZWWJSMlVaRGdyTVFEUkkyRThJT09ZeGk3T0Fn?=
 =?utf-8?B?dkh1RUp5UWt3MnlBL1VmZjFvUGZKTy9IWlRLdU44Yk94ZWdUYnZCSm9UbG9Y?=
 =?utf-8?B?Z0tmRmo1Y1FoYkovUnVXN291dHJNS2xjVjVsU2pLQkV2eVlTNmJPNWZoMEFB?=
 =?utf-8?B?UnQ1UHNTUFNxVGY1bWwrODNGRWlmem13a2FOc2xyeWxVQy81K0tvb0tKV0xl?=
 =?utf-8?B?czNGdXo1ZURmOHhycDFJbnBvOVJ2S2M3QU9CWU1GazlUOFZFdy8yK2ltRHM5?=
 =?utf-8?B?TVd0RUdkVHdTRmdnbVNmNmdrZHJpbStGU3JvYXdORFF2YUFsR2p0TFJJQmsx?=
 =?utf-8?B?c2Z2VEVNWjhKcThrdG5CdFlLaWIza1lmeHBTT3l0UTZQb3pmTkprdFJINkNv?=
 =?utf-8?B?dHNxdnYwczJ3L3JpRUxzVm5MSXBVMXMwN1JYT2dxazd4R2pTZXVEZVczcFRM?=
 =?utf-8?B?dlU3QUhKT1lrWjFkN2MwSnNWVGtFSzNJcFExdHVlUC9QSkhseWFvSGcvOW9D?=
 =?utf-8?B?ekVhZWpWQUdwcndXWTVseE05NkRuQjIzN0U5Q3czMnFmcTRlN2I3bHo1NmZO?=
 =?utf-8?B?NStBdDhrM0xGQ1EvVVdMbXFLZDUzSTJvU2FaNVZmM2VKdVBSN2NEZ2QwU2N3?=
 =?utf-8?B?SHdDRHg5MHJSM3VtdWZRTzFobTlGVzkvR3NjOXZKUzMySlpsY2p3aWNrZ25u?=
 =?utf-8?B?QUo5ck1QUkJLTTlmMnoxTDBUSkxRRzBYRzhzK3d0Zi81di9iMnVUSkN3eG1Z?=
 =?utf-8?B?c2hYZVMwdDJLUnoyMERuOElXOWZIeW8rQlpMMEcrQ2xIdTJjUFRjMklXSDcz?=
 =?utf-8?B?aFVzWSs5aitLRkUxOGhjVHZoM0EyZHNYYytaMjBBQ01ROC9xcFdSNVRnUDBu?=
 =?utf-8?B?bGd3Qis3b3ZHMWI1RHR5WG5yUnpZeVFFSFpkTEErUTd0eUtvbDJ1cjFCY0Zu?=
 =?utf-8?B?TmswWkYvbkdJMXJ0R2l1RmdCM09BalcxQWNtbXk2RGN2U2dQajc3dmJyejJh?=
 =?utf-8?B?L2R2RHFjTWJ1ZjZzV0VQR25ZcHRyaHZxUUJRYmxmNG9xb092dnl1LzdtdGlT?=
 =?utf-8?B?U09qSlFpNUpKYVJKTWJIN3VaVFRGcXR1dEhkSHZrUjFCVTN0ZmJhUndSaDFo?=
 =?utf-8?B?Q2Q1TlBDbnRVY0xHS0R2bjdaR0ZYTzVTODBjWlVrbWNzbEIyZjRTMkVxRFNz?=
 =?utf-8?B?aXZCdHJ1ZFcyNVZzUzMzMUxnUFhrMkZlejE0NU8vem1QSUpuYnYxN0ZyZG0z?=
 =?utf-8?B?emV1TytySVg0d21uTFUvOVBIQ0pnMUp2M25ocExyKzdUWVdqLzBEbVpZV2g3?=
 =?utf-8?B?Z0E9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fe32db-db0a-439e-b5e3-08da79f79c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 11:09:21.1181 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dGsmueQQrLUIaey02ZKXvT21gXZJ6pPgQ9a92m5CWWAqE97ktOfdmbhuARJFPrK9YsWb6QyOac/fFTS1SMrfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5849
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 06/20] nvme: Fix reservation status
 related structs
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
 Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <53B54AE095576F4FBC26B095C458EA9D@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/9/22 00:19, Christoph Hellwig wrote:
> On Mon, Aug 08, 2022 at 07:04:05PM -0500, Mike Christie wrote:
>> This fixes the following issues with the reservation status structs:
>>
>> 1. resv10 is bytes 23:10 so it should be 14 bytes.
>> 2. regctl_ds only supports 64 bit host IDs.
> 
> This doesn't actually seem to be used by the kernel at all.  Which
> I guess means I need to go back into my todo list and tackle the
> discussion if we want to have non-kernel bits in nvme.h to start
> with.

Having non-kernel bits in nvme.h creates confusion, I've raised this
question in past, in case old nvme-cli (without libnvme) was the
reason to keep them in kernel maybe we can sort this out since
now that nvme-cli and libnvme are spilt ?

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

