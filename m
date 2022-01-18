Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB4EC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jan 2022 08:16:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-gFsNCoiZPlm4a3svRmL-wg-1; Thu, 20 Jan 2022 03:16:55 -0500
X-MC-Unique: gFsNCoiZPlm4a3svRmL-wg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDD241091DA0;
	Thu, 20 Jan 2022 08:16:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0C187B03F;
	Thu, 20 Jan 2022 08:16:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 998B44CA93;
	Thu, 20 Jan 2022 08:16:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20IMEMVI030752 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 17:14:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2253D40F9D6C; Tue, 18 Jan 2022 22:14:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CFE740F9D68
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 22:14:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3A6238011E7
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 22:14:21 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-532-CY0CKsp1PpaZbTUoNHGVcg-1; Tue, 18 Jan 2022 17:14:20 -0500
X-MC-Unique: CY0CKsp1PpaZbTUoNHGVcg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by BN8PR12MB3137.namprd12.prod.outlook.com (2603:10b6:408:48::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7;
	Tue, 18 Jan 2022 22:14:17 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::75e8:6970:bbc9:df6f]) by
	MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::75e8:6970:bbc9:df6f%6]) with mapi id 15.20.4909.007;
	Tue, 18 Jan 2022 22:14:17 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 17/19] block: pass a block_device and opf to bio_alloc
Thread-Index: AQHYDDwKKixcCpXXJkOK/9EcGjgKbKxpWP4A
Date: Tue, 18 Jan 2022 22:14:17 +0000
Message-ID: <8f26d2c5-2ff3-68b6-c883-567f16bf57f8@nvidia.com>
References: <20220118071952.1243143-1-hch@lst.de>
	<20220118071952.1243143-18-hch@lst.de>
In-Reply-To: <20220118071952.1243143-18-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75e5db58-c69c-4913-1bdb-08d9dacfde4b
x-ms-traffictypediagnostic: BN8PR12MB3137:EE_
x-microsoft-antispam-prvs: <BN8PR12MB3137697F3560C2747A23B819A3589@BN8PR12MB3137.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: yIqHevk5Q31Y018/APuyJpjCvc4MuP6L3KNxHsB+Syf8GhPUFnRb4242wipQ1DI1RsTU4V54nGmIo+fAuZjOLjf5Pfn7Ts0eP+oQSv1VFAdxzqLbnWMkgOMg3hwu+EBIy+W68t6lTAjUx80fJexTwkfKez7tAsi9/CRYnlt+ENXdSbxB6wmVNAM14GzEu08fhq8QOptJZLdNTJdBlVuxtO/pXP7W+oa404XHe04q1+ffpqbqdl/LHoScD4jhYJgbUcU0SKuv88xzsagktB+Zsko4RRXAo3ajeOUH3uFx2gGu8m7fjo94WFwC3FSaxrzwRDtaMtlrRUVxdm1aMvtUH3TsmiwUqIMAnl4nq8RQuB6WhPOLqAqp6w2U5LlrPCF9LMIi9jljq89ki9z6vxvhznTyCEMuCjrM+9TkhATWC994BhW5We+zeDPtaLUkyUq4pGTRo8rIzhG4XwIHcUPvS+6efN1aJkptQ4ZeP6HgROe4kXrYOrSyqqy1zdjZaDsM9iD0yGiiEYAVbwWVcRDQdhrleHPYPDylICN9MuNWtczNc45pjpBCsr3cfNt49PLZ/troYdp8G4XZ52ojWPCBdljlg39kyGIwHeyyzQSyItNlFTV3kCD2uUmvrmGb+pXMVN90QMPGo/r5qbYelnGd9H0EUG4Qm7sGID5xaaMROVa/PyAkqwiShdFFwBsp05mTun4OUw2bpu9/VqXltw8ZZz7VOsOCN/DF+has09dU8Dfu6NU5lZGxK4V9UOSVATsL/gS304qwNaZqLnqYwXE5ZA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(36756003)(4326008)(66946007)(6486002)(38100700002)(76116006)(6506007)(7416002)(2906002)(53546011)(66446008)(64756008)(38070700005)(4744005)(83380400001)(71200400001)(122000001)(5660300002)(186003)(66476007)(91956017)(6512007)(508600001)(86362001)(31686004)(31696002)(54906003)(66556008)(2616005)(8676002)(110136005)(8936002)(316002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VDQ5WWdNeGxDeVc5TUd5cnRpejJzT1kyU2grZEwzaHY0YlB5QnJMYUNDZVp6?=
	=?utf-8?B?VitPcHlLZnpSZzV1ZWlVZmRJME9YelN6RytWSGd4K2lvMkQ2MHpJSHZuYzg4?=
	=?utf-8?B?MWwvTlZqNlQ1enV6MEkya2VsbTdyNHdoRFJQMnlsTzRxT015aWV4S3ZYS2l6?=
	=?utf-8?B?WkU0Tjl1YVNIdGJKclZ5UkxVUm5ybW5WT2pIdHNBNVFiUmdyRHN6Unh0SEw4?=
	=?utf-8?B?Z0dNaGkwQk81S1QxZCtKcDVYUHlQZGFZa0xrZndmYlRNdFZvUWN6YUxmaFRn?=
	=?utf-8?B?UklyaFl1NSt2NlZFSzF1VVJsb0NYN0ZETFZ1ZTExZ3dJS2tsOHhyQUxyT2d2?=
	=?utf-8?B?aDMzREkvekhTUlYvOVlYUGlsUk9BK3pRUzFFTElIMkJTWCtiZklSSVUycXhO?=
	=?utf-8?B?YTYreVFCRkV5Ui82UUV1K280VGp2TEVsVFpCaVErTCt6WTZ4blJDMlcxTVhy?=
	=?utf-8?B?UWJ0emNEZHFLbklHVitzRVdlRitMc1VFSDgyeHR5VkZNL2VlLzFVUklSVjUv?=
	=?utf-8?B?cElrVTlWRmZ0cTlFUEtLOWMzSDM5K3JhSHRsWTk1a3gyR1ZWU1ZObkJDNnR3?=
	=?utf-8?B?eTgvcVBQYkNMRjV6Wjd0R3ZMRkhMbmdEWnFibEtBbG1sQSsvenozd21OV3JU?=
	=?utf-8?B?SHlrckNSQzFkU1RzOUpoS0pEYkJsazI4TGE5WVNHcDFXLzZDM2lnTXI1YUUv?=
	=?utf-8?B?b3JUaUV4UnFvWWNhbDhETjZwaGJ5UTJCZlZ4VHNKZE5hVkxzZVMxczI0MGRM?=
	=?utf-8?B?WWhiMElnRHNVYjFoTnMxTWZHMGtrc3RZUWh4SEdBL2NBRmhEUm9tWncvVzc2?=
	=?utf-8?B?NDVDUHNnWUJJd0lBbGsrNW4rUE9QbGhZd1pDNkdRRjFZZ0FiUkNMcEZCbExO?=
	=?utf-8?B?ZTJUNU5TZU4vRUlSbGxBY0ZvemR6VE5pMTE1UGxhLzBtWmJUampnSUE1cXp1?=
	=?utf-8?B?YUx5SUwyVFNZeVNIT2dkU0Nwclp0cHJXSW4zb0l6WWFSckR6eGVxMyttSjhj?=
	=?utf-8?B?TkhhK1d6MjhMNzNiZ1VGNFVUcHFMa2tpU1dkL1RYUnRJRG0vS1pGVm4wbElM?=
	=?utf-8?B?VXpoaFlSazJJekJsYXRjV1h4MGZZejlacTJoeC9JWFVQZW9KeWIrNldudEs4?=
	=?utf-8?B?dUNOYTBMbm1FOXk5S0MyYkxyMk42RkM4RFBXZkRRdG41bVM1Y3ZUYWVuYzdQ?=
	=?utf-8?B?ZE5yamw2WWFyTHBJemlwcnBNRkdQREpkWDEwRVJwMWQ0cmY3dmZxV2d4Y2cx?=
	=?utf-8?B?V2lpa0hSRjJpdXljMUFQelJLWDBnSHlVSDEwbUp4QWlaN3huNGhmb05vejFj?=
	=?utf-8?B?Q0tFL0lvejNvTFNpb3hPUWFNSGlCUWFPT1ZzTFQ2R091WEJGa3Z4azN3SjBu?=
	=?utf-8?B?NXllQjhZVEl4LzJTMERrbXdLZmlEZ3VmcUlTWWk3MDZKeDZpTTM5YWRmQU5V?=
	=?utf-8?B?K0NiVittZDNoR29Rd1BROVNNMlEzbVBOY2RDVjM1TjgzQVhiSUFmdzZtMW14?=
	=?utf-8?B?NXlnQnV5S0FNc0dzTUtqSGhwRFNrOVA0ZGk3K2xheXNpR0dETHU4VFNZcmNO?=
	=?utf-8?B?UGwwaUZtM1RJclNHOHpOVHJpSnFEV0ZGOHhXemV2VWdXZVV6QW83K1ltR2RE?=
	=?utf-8?B?NDBaZW1UcVNVZEZwNEVqOFhpNDRXWTdZQkc3N0E2QWQveVpmNi8vYVhHeFlu?=
	=?utf-8?B?L0ZhMG9jWFUrTHJFOFNYOHc4ODJ3OFdMRDd4aExndlk5elVma3J6NFVrQytT?=
	=?utf-8?B?aE9sOStFK3pHM1Y1TUc5OHpOdEMwQUYrM0tKUnpyQUpoRTZxc2lTRHozSlFu?=
	=?utf-8?B?Nlc3N2pUZTZyMW82YlNLTTVOR0NqU0tGQk4rOXR3aEViZERXcU9oKysxTzhj?=
	=?utf-8?B?andvc2RUYmwxcEJkZDc2MTV1QTFlUWpHTUVwcTFoU1QrK0Jndm5GZWxZbE9P?=
	=?utf-8?B?U0JsZGxyZFlNTFJrWTdzV1ZVNVRTNFRRWnJNY0tNLzZiWnM1ODRCVjJ3Skgy?=
	=?utf-8?B?RExXeGlYNWdMWjhoVVpTTDEvQW44d0ZEaVFXL0hodW1ubU1pbWhsc0dta0FE?=
	=?utf-8?B?ckFqeHl6KytLZS85U0VJTFViV1ZuWURmRVpJZG5lbWNBRU02ZDl6NkVqYTdu?=
	=?utf-8?B?Y3ZCVFE3ZnJQUGRneWFTTWFsLzNsMHhpa1RGTXlReGpGZitqMjRKMW5pWDJQ?=
	=?utf-8?Q?HjS/IsDZ6Eu75zn82osp6jvH6C5xTqqRk5TiS/NKtgVK?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e5db58-c69c-4913-1bdb-08d9dacfde4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 22:14:17.1560 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 41tINHyfYfm00bMWoiZd7KQRHKf/Bl76fGX2jOjsh+lytQSuc7GElpuRjLzOF7Q/yRtVkzBmf9NVJreNENHzOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3137
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20IMEMVI030752
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 20 Jan 2022 03:16:10 -0500
Cc: Lars, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>,
	"ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ellenberg <lars.ellenberg@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Komarov <almaz.alexandrovich@paragon-software.com>,
	=?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.co>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"Md . Haris Iqbal" <haris.iqbal@ionos.com>, Jack,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	Andrew Morton <akpm@linux-foundation.org>, Konstantin,
	Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Subject: Re: [dm-devel] [PATCH 17/19] block: pass a block_device and opf to
	bio_alloc
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C34C2F0A08E43545A50616A425CD9E1A@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/17/22 11:19 PM, Christoph Hellwig wrote:
> Pass the block_device and operation that we plan to use this bio for to
> bio_alloc to optimize the assigment.  NULL/0 can be passed, both for the

's/assigment/assignment/'

> passthrough case on a raw request_queue and to temporarily avoid
> refactoring some nasty code.
> 
> Also move the gfp_mask argument after the nr_vecs argument for a much
> more logical calling convention matching what most of the kernel does.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

