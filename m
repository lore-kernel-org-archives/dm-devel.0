Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A0DC43217
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 05:51:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-l0uhvAIqMq2ybQqgOCESFg-1; Mon, 07 Mar 2022 00:51:49 -0500
X-MC-Unique: l0uhvAIqMq2ybQqgOCESFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F7DE899ECB;
	Mon,  7 Mar 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0AF2340D2969;
	Mon,  7 Mar 2022 05:51:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 17D7A1954D49;
	Mon,  7 Mar 2022 05:51:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BAC05194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 03:08:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 995371466C41; Mon,  7 Mar 2022 03:08:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 943351466C40
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:08:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A6F585A5BE
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:08:02 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-Upf43JIDOmSLxy7PVzoUJA-1; Sun, 06 Mar 2022 22:08:00 -0500
X-MC-Unique: Upf43JIDOmSLxy7PVzoUJA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:07:58 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:07:58 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 06/10] md-multipath: stop using bio_devname
Thread-Index: AQHYL/HsKgezjb6JFUqFZXzcYBfVG6yzQTOA
Date: Mon, 7 Mar 2022 03:07:58 +0000
Message-ID: <f8ee6a70-0877-132e-9e36-8f6888d13d45@nvidia.com>
References: <20220304180105.409765-1-hch@lst.de>
 <20220304180105.409765-7-hch@lst.de>
In-Reply-To: <20220304180105.409765-7-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6ede960-b9ae-4cbd-43fb-08d9ffe7ae9e
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB1853F2501E6C2C5B7756AEBCA3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1edpQP/U2EZGFEmQKLQcirDKnrilErMZyXNP3cfVdH2DAU9J9hyoqMbxTcj0kLaKEvMZZty1yKxim3Q7lF75Q8B7qmjaMTslVF8ncYzT9f+383Iw0uprH+OWW59jMMoL8stI5Am+RCxUfPRuvaR0WQ9fyHXwAbH/JB2QcEEUDRKS8BvVj0S4IlDZ52cZaeIvkYOdbzqEV11PGeA54esEfi9b4eMbMkyl13xsefSeivvrEf6uCKUHwezUyhBsKfoXLZAm6vzn+7dXBU/6CNyBTLqjK5eCuNjqtU2LXGkiWm5Y+qrzxHdy2B6an8dda0aD8TfPhouBHrasBKVk+T/sp9nrdmjKG6ZcYyjkBKUNWD+cG/zoB59X2JjPgrM84zLniwZhdvFsDEXNYwUqRapy6Ueo+evJg7sTnt2VxyUdBbEE4NCGwFgCPxWgp60oDq0+j2JExe6URDkRcO+ZlZsDVZsikFRKNlF3kvhmywuk1571XbDuFJqstMDlkulF0h8/3WiHG/bLOBdeTzcQLX+p7Ekf6LKpaGl7F/s7d+fmlfWQpdvz5PV4/iI3dWEdaSCu00BgyH9h3apoBDHdeVpYmiWjnYs6lOFEIy/fRnTNojxN8ERsurwunDgNvogQcEKlDnJIBiezWzdx+X548VyXmj9A9EzJ1OtWNeuaHqIdn1YY+xnlCU12vWvHn4t7v0MgpSvsRYAv2go2wvlkQyHsWRsXaaoK5tZxklM2EIH9DaASA7PXU6IanYTtf/zdj82z1nBNZqX8ZhBkYBAY5HW1Lw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(186003)(5660300002)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(558084003)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWR0T3hWTk13YmRKUUM4NDEyL1JhTFg3QkR5di9GWkk5ZEYyZzFBNERXZnc2?=
 =?utf-8?B?MDViUHV5dHBEdzBNMk5JU244N08xOHMxRy9PRE95MXhBa0tZcUgwTFpZd1VI?=
 =?utf-8?B?b3g2djN6SUhPR0lFV2g2cDJybisrREk2Zmg5SDlCSngveW9CWng2a3ExeUdC?=
 =?utf-8?B?R0Z4Q0xocndBNlgvdld3dnJHU0puOE5ZWFEvMEJDcXZWM0hjRWw4b2J2K2Yy?=
 =?utf-8?B?T1FhcVczRWJlRGZHQzRiNTVXTFZ5dUcvUis5MG1FTTRRNmg0eG5nbFFCbzVC?=
 =?utf-8?B?TkhJbG4rdzhQdEtOV1FmWXBCbTh0REZUc2ZzZ2VFa1VnUjIrWHlYL1VBdnRD?=
 =?utf-8?B?UWw4YXBCRkVTTEo4NWp3WFZPbitrVXRqVmJNVFFhZXpxekhNYTJhUHFHWENa?=
 =?utf-8?B?QWNHU3RkRS85M0ZncVJLaE9HZkh4djdVbWRMNERwTm43UDFwanZTU1ZYKzdX?=
 =?utf-8?B?U0syR2w1ZFFhOG8wSURsU3lCcnFra2R6ZEtQaWtuSmltMmJkNE1UUmR0Y1Fw?=
 =?utf-8?B?YjBIUEhxdzM1bkhhbXBtRVpjS0loTjV6V2Z0MDBzMCtSTWRUTzl2SHFudDB5?=
 =?utf-8?B?Y2NTSUVFUlhBZXowM0tRSGJqUDA4bUxPVUV4UnpqL3ZObDFyYWh4OHA1UmI1?=
 =?utf-8?B?dHhJYmliR2o1akdjdWkrOGRrL05HdGtQQzhBcm5kVGdoQ2Iwbm5NbVVGL3l6?=
 =?utf-8?B?MGZaSmxrQnZrMXFyaXowZS9GTGRXMWE3OStpOHRQZE1IRlpDaWx5dXUzRTJx?=
 =?utf-8?B?Sm0xSlY2RmZMMWdYNTJsSDNDWi9WWG9PWVZuVzM5ZzhxbEJoVDdSemhBWnF0?=
 =?utf-8?B?WVJMcHluUDNod09DaVV0V092YisralhTODNUdjZDWUpKeDhJQTI5KzRJTCtD?=
 =?utf-8?B?VFN4M1V1OWhITWxKMml5RkFrN0ZvUk9iaE1VNndNbU90NW1pbStlVE9lYldz?=
 =?utf-8?B?amZUMUp5YllWNng3blhRUnB2VENIazgveHRYSndLby8vMWpBOGtSb05ZVkpr?=
 =?utf-8?B?QnlZMEoxQWRjWXRrdVlTY2s1N3VVQkFkUGxyQysyYWIrS0RzVkp3QUtzRnhn?=
 =?utf-8?B?NVBQK1Qwa1doNWRvdTZhY2hoZVBxYS9mRWk4SzJ6RW1zT2ZDV1B0TnN0YXRU?=
 =?utf-8?B?RzI2MTNjdERPaXI0WjMvbDJTOG5NQTRac0pvNWNuUSs4NDhicjE4d283dkoy?=
 =?utf-8?B?SHBpY3NpdGs1dmtaVFpUOUhYQ0d3bVJ2Mmd5YjhIdmFYUG56dFZUeWRNbUhB?=
 =?utf-8?B?MlNRZjhFR2x3RjJ1NEplN3lvVUVuWUw4aVdtR3lSNDBxbFZ0dTE5ZVF2djVT?=
 =?utf-8?B?aUwydnJNNmU0T01uVnFoMWtwZFJPVXB4RjBZY2NFanBPOVIxV0tjNTYreStp?=
 =?utf-8?B?VGVUb01hVEZoRmxCUktIVWVyTGJIaHg2NWRUZjEvYXNwNnZnbU9MZnlCVWhQ?=
 =?utf-8?B?eDNSNmk0WUJoUk5YMEtXN0w2YzZXQ2d6aHBjdzYxcFN6UVlDUVdxMUZrTWRD?=
 =?utf-8?B?ZlBwNGpmNUQxRkFwSmdtb3pRYkpqWEZNb1RrVnlydkRHcDNpQWlieE55eUxD?=
 =?utf-8?B?c1ArWWNtUlFrdTRYOERkZzZyTlZ6SVV5VUt4QWd4cXZ4NUhHcE1NQ0p4MkR6?=
 =?utf-8?B?Y09JclZONG9VOUZXK2k1VFo1VCs3WW9hT1U1SDFwSTdqcGZJc3FQaStQMkJ4?=
 =?utf-8?B?RHE3MUNuZzEwUWY0cnFDUE40UGFJODJhRTNNMy9JMTd2dFJpVzZyR21lVUpC?=
 =?utf-8?B?RVpjYTBVRURZVzAyYVIvc3RTcG85RVR5OXJHUksvemFHc1J5OUlsNnpNUHlj?=
 =?utf-8?B?ckE0dU9rMUZudmgwZWlybXNkTUVoTnd1blJZUDNSZHhXbWJ3QjZpM2MyZXBH?=
 =?utf-8?B?THBGSnhZU1NUcENYQmhsQW5ib0ZBdnEvK1lQUGRvQ0hjYlpQY3ZNWGtIdjdz?=
 =?utf-8?B?MTl3WGJXMlN2aXFyVUVZOFZwZmV0cFBaMVdOajJOSXpWd3ZQbnpRdlAweEFi?=
 =?utf-8?B?aGkrRW1TVGxqRFEySzliMmp5bjVMOVd3REs4N0p3T1lhM3IxZGJXc2hSaTJq?=
 =?utf-8?B?d0sydlVlMUlvcjlaYUlwbU83WmNTOURPOVFEZTNMZkVMUlVIK0xFaGxhbUZQ?=
 =?utf-8?B?U2JMVUdmNk1paEV5NUtwaWNWaTR4M1ZJcDBvYm9uR01nYmFTWHRQTkhYMFpT?=
 =?utf-8?B?ZHdscW90NnV6M3Q1MnVzUklDdXlXaEt3ZE1ETXFUNUoxZE55Z1dmK1VXQjgz?=
 =?utf-8?B?a1BRNmpLOVlkQW9iSUk3alN2YXlnPT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ede960-b9ae-4cbd-43fb-08d9ffe7ae9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:07:58.0678 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SoMJRVPfn+j8TGEGn6QQ6LwPiKmebQbYkConEk+x8xh3YzfA3jGWOyyGtH5GJuzmXvwD7U9L76DATT7ASqX8TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Mon, 07 Mar 2022 05:51:41 +0000
Subject: Re: [dm-devel] [PATCH 06/10] md-multipath: stop using bio_devname
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
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Theodore Ts'o <tytso@mit.edu>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <235725F709D72C43A75F40A82EF47047@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/22 10:01, Christoph Hellwig wrote:
> Use the %pg format specifier to save on stack consuption and code size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

