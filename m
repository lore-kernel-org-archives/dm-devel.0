Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61CDCFA373D
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 05:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667280841;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eYOltNXBQrT+LsFEwsJ3sITqFH27/wAZC3uxzKarL/U=;
	b=GMVE796G0+NCQ8iz01MUHkdQxdau5ffRZMq8h1Qt35ejV217HQv5K0g0dq4504XO9tjQoW
	bvJLean4qdV8c4CJupbvxFh8zVXUqzbnOcuv4RunaZBR4UCTJbNWN4W92ITNqrkGt4H8+F
	2seiFY4Wwte7RDKvKvTe+aipGF9LIUg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-_p2Qb4mFOkOEB30j63botg-1; Tue, 01 Nov 2022 01:33:57 -0400
X-MC-Unique: _p2Qb4mFOkOEB30j63botg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91EDA84B05D;
	Tue,  1 Nov 2022 05:33:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4B83492B17;
	Tue,  1 Nov 2022 05:33:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 579E619465B3;
	Tue,  1 Nov 2022 05:33:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1E3B1946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 05:33:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AA53D40C94EE; Tue,  1 Nov 2022 05:33:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A195640C6EC6
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:33:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 424A386F12F
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:33:24 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-frHaisfwP52N42BHuMleXw-1; Tue, 01 Nov 2022 01:33:17 -0400
X-MC-Unique: frHaisfwP52N42BHuMleXw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7011.namprd12.prod.outlook.com (2603:10b6:510:21c::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.38; Tue, 1 Nov
 2022 05:33:14 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:33:14 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, "hch@lst.de" <hch@lst.de>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Thread-Topic: [PATCH v3 02/19] scsi: Rename sd_pr_command
Thread-Index: AQHY6ZGB0y/7jYYoWEirC4MSbfG/a64pk7uA
Date: Tue, 1 Nov 2022 05:33:14 +0000
Message-ID: <cb95f562-32a0-299c-a74c-7bd50a0cbea5@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-3-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-3-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7011:EE_
x-ms-office365-filtering-correlation-id: ff4c0d98-cc08-4f35-d987-08dabbca9290
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ZUupsOu2/ZnXhWy9xnLTKxQAEz29BC0AmMTX5P2pSnX+tXHAEj02i5uvpUeAd7WdaX1pLj9bwMZjrc9hXG+dwyPCa9EpHovrS7v6TCGDNMAj/4QIxrL6UjlHQKxMahwobwp1EHBj5uxMLjQ+3/Fr46wp0n3Al2RSG5ezkB1nShYzl9YyeraDpkZVkekK9vKvuENPDxmBCHYn9HWGmtDVKCL+vYL/KS+zk94ovCMW9Qr3j+0VTjsu5h/xENTQDOk3xa7eTqceAe8Sj2KPMr/09BBkyzpDpvLR7faL5qKrcg6NjRvuFxOrQoF6mlU/6iFcuT4nXMbBxlEVA1MUXdwjZsiID2pIpMBD/2MO+IUOdxfBwMThjjOGSCEsVkxNZSsjxCoMqIQQbVU43ubQyEahyHFVPQBkt1IY8AvsQR3IiYRI2nxPvSDaRhKofu48YcsmJrwB5x9kTAtS10NL5KO66omy8+nud7RFQ21DC/L4RsgnBdZE+kJP1nZyFKwEOYt00fqUYfBVfJjuqcJd3VjCqqmfu2pKLgv1uSuVw686Z3qF5OyOqYTAgSjCmc2frTJNTLOpvfZ6P1E1SCDCotf/qxWwakComd8OrkGa6K7qYLRHg5nGUzxhFdKtq3wV2mpa0wEA7w2LfKhuVtWkcFG+pEr4GqxzUb9M4DCByBoPt0LHeQIDgp7dlxgt3EGdfMvHgSva1OciKt+uMPN7cqIZt9U5KItlEyQhpYY1HKH/ZdTe/dJmtdlIQP/6bMcYvj0SOL15nirnjoHw6l/qYckJTMFg0GcjPMX5VekwmNCiMq2WOqpvu9ZqQJlTgD9YqXtoGrYPkW5UczHa6OgU645ZPg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(31696002)(6486002)(86362001)(71200400001)(921005)(38100700002)(31686004)(66476007)(5660300002)(64756008)(41300700001)(110136005)(122000001)(478600001)(53546011)(7416002)(2906002)(6506007)(558084003)(91956017)(66446008)(66946007)(76116006)(38070700005)(66556008)(316002)(8676002)(6512007)(8936002)(186003)(36756003)(2616005)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXdUL3crRjJXdHB2SERKNEsvenN4MVpJQlFrY0Zld1JLaUx4S2NLVmlaWDRB?=
 =?utf-8?B?NXFBc1dUTml3VzhsdHhJWHUrTG5wSk5SQjB3RWxFSlNhdW1aZUNBV01qZmxy?=
 =?utf-8?B?dnlVTldrSWE4STMwTmtnQldNdDNDRGtOZTlVT0pkbCthK0lXTVpEekVIdDRv?=
 =?utf-8?B?Wnpia1NsRTdYdXlmVmFJZ2hhRnVKdTFiT3RoZnR4a1RpbW02RnF3NHd0dmFX?=
 =?utf-8?B?ckpuUzlwNU5rVUdtTzBjMUFUVGxHcHI3WjJJZGxsczJ2dHpPWE9WZEJJV01L?=
 =?utf-8?B?QUpkK0IxVjBvb282ckVYVXZEVkVmT1g0SVBzNEVJTFF6SStWMkpzYWNYdUJu?=
 =?utf-8?B?SmJrOWRVb1Q2Vlg3OGlyelU0T08yeklZc2xtcWJJcEVNa1NyWkVNRkp1YWtp?=
 =?utf-8?B?bXBNbmFTTzVSNEttbW9JT2ZNWFkzQldITHV1aUdxeVgvYU5BbS8wTmcvd0Rj?=
 =?utf-8?B?SHhUSGhveGZrSGpMY2JwQnBVUk51OWhrdlFPZFhTdlRXM21kck5IYzA1L2lI?=
 =?utf-8?B?dVJzc3BXb1FkMVV6aEo3RFdSQjFQSU8yTEgvY0JpZEJYM0crYVpURGVlYURt?=
 =?utf-8?B?RFc4dUtEYldMWHkzeFRoUXV3VUg2ZDg3aVhuZVRUVXE1ZmttT0RaV1ZZQkor?=
 =?utf-8?B?bFozY3FyOTgyaG9md3RkWDdLeDZObWlrWDhkYWEzbVZhQjFmTnRCUjNZTmkv?=
 =?utf-8?B?WGI2YkxzVjc3QTMxRWIzRlFVUGVNbUJTQnNxbGlHNjNWejFod1EvYWR4VGRz?=
 =?utf-8?B?dElGOEdtRTA4ZFNKbTBSVkFlKzkwczhJbmZMRUpvZkc4Z1lQQWE3M2U0WWZM?=
 =?utf-8?B?Y1lvV09kOFpNajVQUmMrd2JBQWdGVUZlazhaRjZJQUxqd0MrKy9uR3F0dmZW?=
 =?utf-8?B?cEpubG9taW1qeHRzYmNKOTF3R091T0I3anVnZUNwdEluWHNpOUVwY3hBSmMz?=
 =?utf-8?B?Qk9HSzBSaTRmMEZPdFRRNmhPSUVxTE5FdGFnRWV4QVIzR3JGUTcxeGpjdFRq?=
 =?utf-8?B?ckpEV0puR3lvOEVuNFVuektmc0hJRGcxZjJYQTVVSUlXclNNaUJKWllpdFdh?=
 =?utf-8?B?cnlPaURsb1FvcW5kaDdqRDJjR3VmVDBRQmZ5SVVnSzRlUm1YeG5lcjVMNUJ0?=
 =?utf-8?B?OHM1QStseFEyelJ0Ym93RzNmZFNnY2lKRHJCcnNMV3Q0T2tXT1pvNHpKZ2tK?=
 =?utf-8?B?dVBldW9QS2p3RDZ4L3JJUkx1a3dBVFR5L1BUeWtSRmhIWXBqTjRONm9ibFJv?=
 =?utf-8?B?ZWtsZmxUak8rVG5VaHZOd0xuRlVUbm5PWFYralRLb3cvVE41dW1sSXkveno1?=
 =?utf-8?B?azVpY2pGSEtIdjNzbmw4NVhPNitVTVJ2dEk4V2hXaUdCUm44NVhvMC9QbDZo?=
 =?utf-8?B?RFlRQ3FrVlE2NWdvSm9YUzlnWUlkMTBINmhONGlJUkFqZnlxRi9QZmpRR0xn?=
 =?utf-8?B?RHpLWmpsMDNkRU0wSjJXQS85NDVXVW9jQk9WTmtSZGFNdkx3VUpCS25IeHU4?=
 =?utf-8?B?ZjRiczBCdGJsUEhuVUYyNHZ2SDB3aDBhNWtTTGRrMVM0OVBXZGNtS3NUd2dq?=
 =?utf-8?B?ZFp1WGdnODA4Tng4ZlR6VHBzL3RjZXZBNSthMTdmOVlPK2t0TjVpczRkV2F2?=
 =?utf-8?B?dGpNSzFrR1EyUlgwYzZtTUlFcEU2ZjNqY296NlpJQnYxYUUyMWJqK0VBWlJW?=
 =?utf-8?B?UTl3OGUxdDlJSkkxV1N3dXk4Y05xV2JPMHBGd09VMitqL2tXc29YNkdGWW1m?=
 =?utf-8?B?clBDTS9kUk9EazltZEpEeUI5NG5NL294N2tKdk9xTTZrM3c1c1M3bG04Snkz?=
 =?utf-8?B?aHFNK3BxNDU2cmRTUVY0bTJuMmVKb1pFQ0t5SUZnUHV1c04wNjN1a1lqRDN5?=
 =?utf-8?B?bmNTN3NLUXFGcVVBb1hzUThMNEo2Z0tsaHNUYUdydUllTXcvT24vVGhjMXR3?=
 =?utf-8?B?K3VlZmxoV0RDeVN2S3VXNEdoR1NoMWZKSVlyUndHS1lzdGJIYTY3cGp4TVE0?=
 =?utf-8?B?VlAwdWt5SXY4ZEhLMm9hSWVzYVVRa2xHVXlkMU9GSU9oUitXSTZ5bDFzb1Vo?=
 =?utf-8?B?a1NYQTk0OGxob0t2VndrbGJMamZCdkRuT0kyZjlUd2g1eFVhRnJSNVBJVHF0?=
 =?utf-8?B?S3UzaGhuRDA4dXYxQVNHU3ZsYnNjVXl6TlVKa2llRWkrOC9Ta2ZlZk0zb3g2?=
 =?utf-8?B?dVE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4c0d98-cc08-4f35-d987-08dabbca9290
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:33:14.2944 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R4yYa//tVK3kQtp8RK44PG4+Sm1jg9qrM/r33YocJRPktC1UKcKzaX1zp4D6DWYIAymFITjjDz7hEtfDv7eMEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7011
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3 02/19] scsi: Rename sd_pr_command
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <79B9D7962E875D4394CB8368FCFA26B6@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/26/22 16:19, Mike Christie wrote:
> Rename sd_pr_command to sd_pr_out_command to match a
> sd_pr_in_command helper added in the next patches.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c | 12 ++++++------
>

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

