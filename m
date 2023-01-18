Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB4BC32793
	for <dm-devel@archiver.kernel.org>; Wed, 18 Jan 2023 19:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674071229;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/Fh4uFs7bK5inMx33w6aM/zLJL1pfMIRx3o+LJ2VfQ4=;
	b=a0Lq2FIYP7JCFMNpgq7cV9eQzDIgbdMkwQeS4r/ahIBfNe7gnfbftHKFNVxSpNZiM+v+6R
	zBN8sgr+EjcLNBZMbjWbeiu3Oatzet7gQQKzD9BXP6H09xqX6Ft6tHzdKeiYpRJPNHpq0g
	qIgDmka99uvB4q3SvPgxH2VOg6aPjPQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-dRgqSjk3MZGjq2BDTmeevQ-1; Wed, 18 Jan 2023 14:47:07 -0500
X-MC-Unique: dRgqSjk3MZGjq2BDTmeevQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF4A287A9E0;
	Wed, 18 Jan 2023 19:47:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F071E2026D4B;
	Wed, 18 Jan 2023 19:47:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD9181946A6B;
	Wed, 18 Jan 2023 19:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D0CD1946A45
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 Jan 2023 19:47:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FC89492B01; Wed, 18 Jan 2023 19:47:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07BD7492B00
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 19:47:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDB4D280558A
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 19:47:01 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-sRRdWONpNw-m3l_KLygHWQ-1; Wed, 18 Jan 2023 14:46:57 -0500
X-MC-Unique: sRRdWONpNw-m3l_KLygHWQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW4PR12MB7360.namprd12.prod.outlook.com (2603:10b6:303:22b::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 19:46:54 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 19:46:54 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Enrico Granata <egranata@google.com>, Alvaro Karsz
 <alvaro.karsz@solid-run.com>, Jahdiel Alvarez <jahdiel@google.com>
Thread-Topic: Virtio-blk extended lifetime feature
Thread-Index: AQHZKLbSmDz3opX+ik+cSQeZMItVzq6jNSIAgAFkqoA=
Date: Wed, 18 Jan 2023 19:46:54 +0000
Message-ID: <a9cbed84-330f-472e-0cd7-90c6623bb5b5@nvidia.com>
References: <CAJs=3_C+K0iumqYyKhphYLp=Qd7i6-Y6aDUgmYyY_rdnN1NAag@mail.gmail.com>
 <CAPR809uYp6vGvCk4ugWOjbmd13WTm8fRg0f2Mdq3pxj6=d1McQ@mail.gmail.com>
In-Reply-To: <CAPR809uYp6vGvCk4ugWOjbmd13WTm8fRg0f2Mdq3pxj6=d1McQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MW4PR12MB7360:EE_
x-ms-office365-filtering-correlation-id: 3305904b-f1a8-4ace-c124-08daf98cc049
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4i9bk37wdxmzjPI5eiAzp73CL9QmGI+1XoriFpMxdsBLnfl7xNDCldR1rJZ7RsmEzG0nhXkSE6estmWjww8+qmuH/SjdkMIO6lbPCN4HMydJZYLPMbr0vW829xL2pc5XkHcmDVWASuddF1s7Af7EyU0ddXfdyEdAdBbVYEdcBut13aUf2b4HTGiMT4LT5P5sWYeO09ClfW+mn0zWAz0JlpFQB+gBjrslwknfR7NQ1DHoXCeXToz+Gw96s1NRR+gD06us1RrT8kkQ46LVGaEQ5gkgQoBmaneG0jgkJTat5xEduXrMpZyu6ohnbTwjR2Yqk3D2diXU3TA7V+y4C6qxSHtOWQRSelTh4R6r7tP4m1CDoYrGa+WSLtkqvjmn+JTmRG/KXET6VjmFVNKrmMjrmXkWSjRGbiLQCKIQsVyB1MkIfVSdqskfqMLYE+ifbkO+qtWteiq+GCDO2Oh6iJGYCatGGVT1WAJ0bSRDO3hR1lOzmMyahr/axPKHnu5rGgYct6n0bQJTE0sFRna2qD7wNFli2JoZE+WeASL6caRjYDBvRARkKkBmv4m4vhTOpcYunsrEexh3NMFGXLXylc9fVsVfffdSsa4vXvhyN7SgjW0+rosdm+nJwBvbZ8K350y21y9am7UAD27p69jFn91LDEdTiq+tKjFAa6vbpBevVnWn0sIZkzKDupO6pT+p+lLpvXObnoNz2UlTUPfQkUdgg3BTfjKnAZk49rShFL/LDN04sQGep2EJoeuLIqLouJrO75yYmMFxbqtFqcNgYrRpv9a5LMNMdi7p42L9KsvMPiAalAT6X24AbZPHwdfhiRDzyHK8A1zJ9q6Tvw8VBtlCE8cu2NNgi4xd/X9Bb06Ep1ufYbjJzpEDkIOVyzj0nBxf5kJ9VwIgkovqNE2ceH92+A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(31686004)(86362001)(2906002)(7416002)(66946007)(66556008)(76116006)(91956017)(8936002)(5660300002)(3480700007)(31696002)(122000001)(38100700002)(66476007)(316002)(71200400001)(110136005)(54906003)(53546011)(6486002)(6506007)(38070700005)(478600001)(36756003)(8676002)(66446008)(64756008)(4326008)(41300700001)(186003)(83380400001)(6512007)(2616005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkJvUmk0NWhhVkU4K08wZ2s3TXhQb3pyaTRzKzJEOVBUaHh0QXZyV2RnUjNV?=
 =?utf-8?B?aGxFM3pmWFoydy85Q2VtSHl0OGdiOUFaZVhIQUI2c0RQbGVzWTZ3NUttdmhJ?=
 =?utf-8?B?Z1ltNmJ6NStYQXdKV0FTOFdvNG1xdlB0N0lzUlVOOW5XekM1bGtVM256ajdv?=
 =?utf-8?B?TWVQVko3Vk9QWkVFQmY3Vk82WkpCNzEvcmQyOW5va01xaldkY3R1aXVPd3hK?=
 =?utf-8?B?bUdScFFpMFh3N2RUT25pMlBUcm5LTTdCQU5hczVDOGNsT21IbWdvV3FZeTg0?=
 =?utf-8?B?U1VxcEpjaVJRam1CTFkwL2Jlb0liMW96YUFBazRibVdnTHVxbC9OS0hVc292?=
 =?utf-8?B?YnZaRU9TZEs2bkRZWEd3dHY0QlZBR2poMkhNSVFpR0FDTkJrNy9BM0xXNG95?=
 =?utf-8?B?dGN1cFo5aHhHckl5d21nQmZwL093b09jekJEL3ZUUWZIT1RINHQ0NjlqdFcw?=
 =?utf-8?B?Zy9aOXNWUXVUL3BMeHo5ZlpENklvMDRwSUIvRG43VGJIa2NqVVpPakF3aXV6?=
 =?utf-8?B?b2tmMGpUbTd0VkpPaWV4M01SMS9wTis5WHJUMDZYRWRGK0FQK3hMdzdIaEZU?=
 =?utf-8?B?eE5VangxNE5PUUx1dmwySHhxaTYrNlhPMFd6QXlLc2QyNGpmQ1dQc3FZTG5J?=
 =?utf-8?B?cmxIQWZFZU1LcG42STdxWTBDMStVaE40RVJmbm8xSXlWbHVwQ2pWenlxV2px?=
 =?utf-8?B?VWZBU0FpcHA0alNrbC9JMDJRbFdxY1llcWhtaXQ0Wk40dFd2S2xGNTlSOEtR?=
 =?utf-8?B?QXl5NEJqeEdNUWltb05mV2wyQnVua1F6TzFncUtaY0swU1g1Q3Eva3VadG1I?=
 =?utf-8?B?RVFocEF0SkFxellUY1NwN0dwMHA1ZEhGNzYrcnBMSXdURjFIbU5BOGtUS2dM?=
 =?utf-8?B?RlFaSXJsUTNXcGhoNk9YZWJTVU1Cem1OS20xeTRmM3dxQ1lUbkNYQzZvY0Rh?=
 =?utf-8?B?U0J3NWF3VnNSZ0tZRFlYTGZYM2s2MlovSy9xbSt0aUJKMDdkNnFCdDVkc1BH?=
 =?utf-8?B?cjJKem8wYnU1cDRLYWU5aXVWYi8wVHRlZFJhbmZuU2xab0RrdUFyRjJCODNh?=
 =?utf-8?B?ZkVzdFdZclZlbkRBOWVGTjRjajZFU0ZtNlI5K28yYzh5NUdIWXdPWlhiKzh0?=
 =?utf-8?B?NWVOUWNkMHhUSG02WmxUMzBkbi9CWUZENWR2d2tad1RjRmhpcDZpNDVnSGUr?=
 =?utf-8?B?M2ZINnUwMUJUMjhnY3pqVFRPQi9oZm5pNU0yckRjK2NnUEFzL1BQbndUOEh2?=
 =?utf-8?B?UGNjeUVUcWNDNnNseE1GMWVkNE00WlJ2VDZSK2RPZExkQURlOUpWYVBZSXQx?=
 =?utf-8?B?RmU2cGhlZkVibzMzNVZUTTczUi9DS2lkeDRtS3ltRFhvWCtWUWpRaUxXUksw?=
 =?utf-8?B?VjBlOHBvY01YdEg4c1hIOHo3WjNUbm5UNGhNTXRrUis2amMxQUxPZUFXV0dH?=
 =?utf-8?B?QXFDRjJncVJNTU1pNjZ5bU5yYzlrajFKcTNneXZ3UFdDTHBZMVlPR0NpZVZx?=
 =?utf-8?B?ckx6cUVKODZGV1RIUTMyL09FY1B3UVNvQ2U2Mk80V2Z4WEpURnBCZ3NBRXBB?=
 =?utf-8?B?d2hTYmRsUlcyNVJBMnZVeEFraGxvenMvemp3L3htME5aSk1pY1R3VzNuZmh3?=
 =?utf-8?B?bEFaYVFTQzVDNnZabXV3SWFxd1o4eUM3MUJwTHBKTTJjVkxsOENOY21DSWZR?=
 =?utf-8?B?Vk9JRWVRQzJCSittdmw1SWp6KyszanpnRDVhTDI1MFlDemxzZEh0dS81di9H?=
 =?utf-8?B?V3hGSzlqL0RuUnc1OXNJbWxaTENpUzhjeFJSYXdUT2Z5ZUZVS0phNDZMbFFV?=
 =?utf-8?B?cFNIOGdIdVdDcmNabTljUmtNa0tWY3NuZW9KS0pjOXNyYjYySUltZGxyVEkz?=
 =?utf-8?B?eUVHK1drL1lKWEJkTXRzZnRRQWZTbDc0TkpwR2tlcjRFbEFFWmJaUnEydVhC?=
 =?utf-8?B?RWJUaTBqUFNGYVZuR3pCRHlGWGdVaFhPZC9sY1NSYkRTdHNDR0N5czR1Z3Ro?=
 =?utf-8?B?Zm4xUUhjTFY4emtjYmIzTVY2RzVuZFFwQkNmVjdEK0NlcGgxa1VyVE1jQ216?=
 =?utf-8?B?K1RBS2tIek9ES1FTczJCTFNKcDc0YjZMazhUZFFFd1U5bWxIaFY5MXJpcytG?=
 =?utf-8?B?a1ZNKzVuYjJid0QwL1BTOVFWQVA2dUR4WUN5ZGFtSzN0T0kyZ2hCVld4Q1Jx?=
 =?utf-8?B?RWc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3305904b-f1a8-4ace-c124-08daf98cc049
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 19:46:54.2518 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: apZCG8eAMw4y+5oD1P2lhGeXjufHfn647H2Y1X9Uog58aj9htFoDPYUV5cO4vrHyyWp2fS2y9pRieuD2dnuGiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7360
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] Virtio-blk extended lifetime feature
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Bart Van Assche <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 virtualization <virtualization@lists.linux-foundation.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <B1B0552373D580469EACA45D60F79361@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/17/23 14:30, Enrico Granata wrote:
> Hi,
> I am going to add +Jahdiel Alvarez who is also looking into a similar
> issue, and also I would like to hear thoughts of people who may have
> worked with (embedded or otherwise) storage more recently than I have
> 
> One thought that Jahdiel and myself were pondering is whether we need
> "type_a" and "type_b" fields at all, or if there should simply be a
> "wear estimate" field, which for eMMC, it could be max(typ_a, typ_b)
> but it could generalize to any number of cell or other algorithm, as
> long as it produces one unique estimate of wear
> 
> Thanks,
> - Enrico
> 
> Thanks,
> - Enrico
> 
> 
> On Sun, Jan 15, 2023 at 12:56 AM Alvaro Karsz
> <alvaro.karsz@solid-run.com> wrote:
>>
>> Hi guys,
>>
>> While trying to upstream the implementation of VIRTIO_BLK_F_LIFETIME
>> feature, many developers suggested that this feature should be
>> extended to include more cell types, since its current implementation
>> in virtio spec is relevant for MMC and UFS devices only.
>>
>> The VIRTIO_BLK_F_LIFETIME defines the following fields:
>>
>> - pre_eol_info:  the percentage of reserved blocks that are consumed.
>> - device_lifetime_est_typ_a: wear of SLC cells.
>> - device_lifetime_est_typ_b: wear of MLC cells.

For immediate comments :-

It needs to cover all the flash cell types.

Using names like type_a/type_b in the spec and in the implementation
adds unnecessary confusion and requires extra documentation in the
code that needs to be changed.

>>
>> (https://docs.oasis-open.org/virtio/virtio/v1.2/virtio-v1.2.html)
>>
>> Following Michael's suggestion, I'd like to add to the virtio spec
>> with a new, extended lifetime command.
>> Since I'm more familiar with embedded type storage devices, I'd like
>> to ask you guys what fields you think should be included in the
>> extended command.
>>
>> Thanks,
>>
>> Alvaro

-ck
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

