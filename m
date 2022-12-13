Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303CCC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 13 Dec 2022 04:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670907545;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GZ0I+9ZJSEjgIc5Doiltl3pF4FiqG8kj10DuRwP6xOE=;
	b=LhXRiQDiKA8YPfzLpgEZeekgvRnFN8BBfaUx5sU6OYhfCQl2hogSMXaHiJ2w6SiaYGzoiE
	NF4Q4YuElC2tSbljJciBefT8EprL0PoMLopBqslxH/V8Vhh9gh6FQiuN+N2ZKiImobHKMu
	/aGxaAhGkZPErwJlc+TNP06Q8Ycvz9A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-7uwedkPTMKSKpImn9PmlHQ-1; Mon, 12 Dec 2022 23:59:01 -0500
X-MC-Unique: 7uwedkPTMKSKpImn9PmlHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CCBD85A5A6;
	Tue, 13 Dec 2022 04:58:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74893140E949;
	Tue, 13 Dec 2022 04:58:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4ADC01946588;
	Tue, 13 Dec 2022 04:58:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00AEA1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 04:58:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E2AC5C15BAD; Tue, 13 Dec 2022 04:58:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA127C15BA0
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 04:58:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B506886C042
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 04:58:55 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-uwV1BkN6OoWZN70JCafAfQ-1; Mon, 12 Dec 2022 23:58:51 -0500
X-MC-Unique: uwV1BkN6OoWZN70JCafAfQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 04:58:48 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.018; Tue, 13 Dec 2022
 04:58:48 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Thread-Topic: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Index: AQHZCMWIE493Nhwph0Wuxc84G3ju4K5iC2yAgAAudgCAAGdJAIAAQiIAgAhqUoA=
Date: Tue, 13 Dec 2022 04:58:47 +0000
Message-ID: <ccb5388d-4976-31a3-0559-e94c14c90573@nvidia.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
 <20221207152116-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221207152116-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4084:EE_
x-ms-office365-filtering-correlation-id: fc9f4e0e-b726-449e-ae91-08dadcc6b854
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5c2C/jj3PCk/VcBCMbSxJ8aId34uqDeTKsd7c3aNtC00z6wN+SUl6Un6GCqo5pngq7aYcOtD2ofE9Z2f9pbyMVVH/dirpIso66eupOtK56JU4zGvTO2VOnrnhjCeUFWEmXE6TzVzIW+h/jQ+plhWvp0ntcNHrvca4E18Wi1pM8uCkQkZQuJiMaJxJihWb+bxBsF09fBWVGbPJOAGcfYdLtXXPNwoxmmwJ1u+tTRkUw3fpAuAf4dpQaky83gCZQRBd+PeR/9+WJc/Q0nYxYLWMJhNDiCevO8ZGWcjohNa2PPzzmEHn7RkDjXNeePk+DSbjMXm8mvPmN7+ceGHeWXbWBWeQ7IW0ZEgIoBmGHCwi7We4No1o9LBvWlvoZdddgM0HBjPVMB17V35hLP9a0g5TM8nAl3seHeFyG4n+P0Kg+E10ArqNr2vztVRgd1ITDdjyaJ/FuD0DRxg+MprMtvEeJfHZaEoAjnztlFh73fnqJ5NwOtndv86QopcRtGvQTwMwbei/vcx1OyV7X3hUyEtWRQjauSHs95glsaU+i/8OTZsWfW7VAQTGcpkk6uzbkSZTqqZWh6iuP3Bx4Hyc/M4Etevd9Pc2f2OZRm0HVgXMMVHRHM4eu3/aYx+6VIbJzqSjU3JPewJG1VkmamlFsoijgvDdwzlCCQrpjOqmWd6tLoyj+sTPjZqZr21grv271s0VzzFn/EwgnHG73XwObMY+alkG59wc6FfeBY9J4QE1gCHRcnqVMyUXxTXpkR3cgCZ8KxdSf5gW7mRj35zFcLK5w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(478600001)(2616005)(186003)(6506007)(38100700002)(6486002)(53546011)(6512007)(122000001)(71200400001)(91956017)(66446008)(4326008)(64756008)(66556008)(316002)(76116006)(54906003)(41300700001)(66946007)(8676002)(2906002)(5660300002)(66476007)(83380400001)(6916009)(8936002)(7416002)(31686004)(31696002)(38070700005)(86362001)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M25TcmVWcXZtbFE2OWFBTXhZM2JydXFMSXQ3V0k5cHJ4dGpudjV0MVpITEdG?=
 =?utf-8?B?emxBZFVOQ3YyRGZQREplNFpVL2RtOVhDTVVEZUI5WUNqaFZCLyt2eHlRM2JX?=
 =?utf-8?B?M2R3cGF2MXc3Z0ZLUG5tMUNnZ2lXdlkvYUJkZk1LK2FsMjY2NEh3UVRaRHI1?=
 =?utf-8?B?cnpiSU5tVlFLeFp0RzZGMVFMSGcreFlVWWc5bTZKdnBtajRRMGVuZFpmVVE1?=
 =?utf-8?B?SllBbEYxS2VxOWxXZmZPSjNmWWlUcGFGcVZMR1BkMXhFT1dBankzbDA0R0hk?=
 =?utf-8?B?V2MxS2hjYmtYT2ZLSHM0YlJUbDJvYjdaMUo4Um9Tcmk2c3F4Y3J5V21qazZ1?=
 =?utf-8?B?dStQTzlxYVo0Skdhdks4RUZvQ0lwb05VRTJzMitIRWYxdXpKb0xwSjF3V1RU?=
 =?utf-8?B?SHJONmRmazJtVWRDcXlRQ20vZWlPVUU4QzZLQVM3WHlNWG4vMlpkRGdVRGtB?=
 =?utf-8?B?NHhoSE84Z1ZMVy82M0E4OWNHMTZJMSt1cjFQRUl3WG1CSUQrWGY3ZXdsd2Rh?=
 =?utf-8?B?T0c2K0JMb1FCSGlCK0VYR1lGalRiaHZUd1ZnMGFzY0pEREVYT0p3MXBlZHhR?=
 =?utf-8?B?MDBsK3gzWkxiWTJGeU1xZ1hlb1NRNncxUjUya1FkS2JPd21yYlVDektrQXkx?=
 =?utf-8?B?UzJYYkplSW5kQzEycVN5NUVveE5xcE81YjVyNW1CSVRWbWhpNzlKZW9pdVli?=
 =?utf-8?B?R0xNVVFXVVNBMUdxdFFPZXQ0V1dZa3o1dWtuT1pGMmpiazMvKzJYK1c4djBX?=
 =?utf-8?B?aHk0RXFhQVpYaVVkQXJsQThVMjJhL3Z0MnppMllNWHhvRnRTRG5pcjJJMmtq?=
 =?utf-8?B?TVp4M25OV1JsQ3grMkR5M1NHWlJZY3ZIMTZld3RKZFNwNnl3bnZ6TW51aTBp?=
 =?utf-8?B?QXZCa1AxSVQ1d1U1Mm5lQ0RyU29QTTBvcUpkdXVmdlpZOGQ2TDJxWFNTVVNj?=
 =?utf-8?B?UVZnNmROeG5obm5ERSt4WW5RYnc5bGo4UzBqVDQyVEsyVGFVRnhzZkJidEtM?=
 =?utf-8?B?bkNvQnUweGFmSE1yK1FQSXJYWGNXZjJJZENtNTAvcjdyUTFPS3V2R0p4OHgx?=
 =?utf-8?B?bVpFUHRFZXBFZ0MwenoxaXZmbmdyS1dRUzlySHdJZmw3Q1hRTURLRXlQVksz?=
 =?utf-8?B?dXpmUkVpak1wYzVGanQwN1V4dU5GSlYvUVFjVmhpbzJTRHl3MEtGZ2JDMUJD?=
 =?utf-8?B?M1hSL29jQnlOMk1BSXd5M3hLeE42azRkcGtKcmkrRVRCbzkyeWxMTVNZOHlW?=
 =?utf-8?B?WHRoaVNqRDN2TU9yZHdLOUU5NUY5Y2I0NWx6djR0c1plVE5LTU80a0h4VzdR?=
 =?utf-8?B?bTNoTElPN1NWYTQrRHZ2ZkZWMTY4VUgxMGVMTk9tSUxqdVdlTEtkUmFzNTA5?=
 =?utf-8?B?OVJ2cTgvb2k0T3JLWWx2dW9jc0FBOEhCOGZaNFd5L1F3N3RmemxWc3NKU3lT?=
 =?utf-8?B?V0FMZ1RnMncwZWRvcEJnV2RQaFI5b1NyUmxXZ3NoS0hudW9XU2RPWjJ4QS9k?=
 =?utf-8?B?VWo0L3owQU5FNzhyM25qYzJJRll1eGo4b09jSHpTdmlkdjIzWWpvLy9xaTNP?=
 =?utf-8?B?RDB6bUM3OFNPMDcwaGdHa0Z1bGJLMVcyNThFSkNCcDhxOXF6VWZoVWJ3SGRh?=
 =?utf-8?B?V3FsRCtaWStwNE84ZjJHY0lzMi9YUjhrem1qM21vdEV6MEMzdEt1em9hU0hF?=
 =?utf-8?B?YzNDZVBXN3IvbWZBTy9EZkNJNGlJVldsbXJtZGhwNysrZDhXeVdIRTdyTk1o?=
 =?utf-8?B?MDhvVjhQQ3UvVDJQeHIrUlRDV1RReW8yYU51S3NRNDg5cG5URTZxeksrZUJT?=
 =?utf-8?B?RmltUW5sWXFQakJ6L3V3NExFN2pwQUxsZzRXNEgvemM1aTFleG9rWkNMZU1K?=
 =?utf-8?B?NUtoLzA0YkczZkpZTXYrenczWThndDVHeGtyTE5wSVZLZFZvTVZ1a2Y3OVhi?=
 =?utf-8?B?RTVJUVlrQWdJYy9zVEFwZWw4WU44OFE2d3ZTZ2pESzNyV052MzlpODVraXVI?=
 =?utf-8?B?YzRpTFYrc2llQU5CTkxtV0toMkduanFEQ3FCb0htaWhYUGdTZ0NPR0FqMW5z?=
 =?utf-8?B?Q2Q5SUNJWGhoVHY0ZDRqVzhHa2pjVXFtaVlpaUxpRjRIYnQ5Ri9BUHFaUlNn?=
 =?utf-8?B?RzM3YktuVWZGOGp3VEpsRlF1cEJaR2JTcUVJRmhXVFpIQXZxdEY5YlNaUzQw?=
 =?utf-8?B?MEE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9f4e0e-b726-449e-ae91-08dadcc6b854
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 04:58:48.0070 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 95YJvDqpkp620B7eP6xywRSfAjobBGVyVpAsDeq9uoWGFoK4SeVVyWFrw7f9xy5q0HfGALEIj5eRsnKq5Zs4hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <70AC3461D2143E43AFA0EDC75B1C868F@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Michael,

On 12/7/22 12:28, Michael S. Tsirkin wrote:
> On Wed, Dec 07, 2022 at 08:31:28AM -0800, Christoph Hellwig wrote:
>> On Wed, Dec 07, 2022 at 05:21:48AM -0500, Michael S. Tsirkin wrote:
>>> Christoph you acked the spec patch adding this to virtio blk:
>>>
>>> 	Still not a fan of the encoding, but at least it is properly documented
>>> 	now:
>>>
>>> 	Acked-by: Christoph Hellwig <hch@lst.de>
>>>
>>> Did you change your mind then? Or do you prefer a different encoding for
>>> the ioctl then? could you help sugesting what kind?
>>
>> Well, it is good enough documented for a spec.  I don't think it is
>> a useful feature for Linux where virtio-blk is our minimum viable
>> paravirtualized block driver.
> 
> No idea what this means, sorry.  Now that's in the spec I expect (some)
> devices to implement it and if they do I see no reason not to expose the
> data to userspace.
> 

Even if any device implements is it can always use passthru commands.
See below for more info...

> Alvaro could you pls explain the use-case? Christoph has doubts that
> it's useful. Do you have a device implementing this?
> 

 From what I know, virtio-blk should be kept minimal and should not
add any storage specific IOCTLs or features that will end up loosing
its generic nature.

The IOCTL we are trying to add is Flash storage specific which
goes against the nature of generic storage and makes it non-generic.
In case we approve this it will open the door for non-generic
code/IOCTL in the virtio-blk and that needs to be avoided.

For any storage specific features or IOCTL (flash/HDD) it should
be using it's own frontend such as virtio-scsi or e.g. nvme and
not virtio-blk.

Hope this helps.

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

