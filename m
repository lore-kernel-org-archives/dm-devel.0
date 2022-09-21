Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F731ECAAD8
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 05:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663736444;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tLMXXwzXsttdLRqMgwm3e7rdvs6KCCtHwD7v6u2mwEA=;
	b=jQMTecTlVorIBGKmKMp0+5TYNyzGOQH7hLBCXjGylaO5WRXE/wAwF7LxFJubbTUCILU5k3
	6oxgq25dwFjcrct9u8r9qNViVhr6SPHPOCFLUtEodArv/aAvHEI5cR+3Jt1JBBYGtZW9eH
	/VSuyAzmruPvzkJ6h2WvOZXE44BDOmQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-pPInDMniO3q6B9bi8cKj3g-1; Wed, 21 Sep 2022 01:00:41 -0400
X-MC-Unique: pPInDMniO3q6B9bi8cKj3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A59F800B30;
	Wed, 21 Sep 2022 05:00:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6CED440C2064;
	Wed, 21 Sep 2022 05:00:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D1AF1946589;
	Wed, 21 Sep 2022 05:00:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 90E891946588
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 05:00:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 80A5535429; Wed, 21 Sep 2022 05:00:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 783FA1759F
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 05:00:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5953680029D
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 05:00:35 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-qxsZs3hlO1OVstBO17JDJA-1; Wed, 21 Sep 2022 01:00:30 -0400
X-MC-Unique: qxsZs3hlO1OVstBO17JDJA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW4PR12MB7336.namprd12.prod.outlook.com (2603:10b6:303:21a::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Wed, 21 Sep
 2022 05:00:27 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 05:00:27 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 Zdenek Kabelac <zkabelac@redhat.com>, Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v2 1/4] brd: make brd_insert_page return bool
Thread-Index: AQHYzRoBcQF0rUJmnkWwxj9tGPOk0a3pU+sA
Date: Wed, 21 Sep 2022 05:00:27 +0000
Message-ID: <bcfc8027-11fe-a3e5-f0f5-2ddf1f0c03bb@nvidia.com>
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209201352580.26058@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2209201352580.26058@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MW4PR12MB7336:EE_
x-ms-office365-filtering-correlation-id: e455fea1-5ccb-4b56-07c3-08da9b8e3318
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /I/SN5gnGvjitFhjeqqZADXMnviK8WKUUgAvZYZRBTEowy4gNMwcRQsHGs2i+OTcvK5dnEsOSJDNd+qUrQvYauK/vaZ9j0LfiqTAsoGZhMTahomdMXAiLTiAIqP7BL7extMd0qEY45xnDoF+3np1+L+tNp5NNi4bDIDmPw6GYJuwNAfonhzDGsRzMN5NKZs7bXIrg3o+WOEESjbwZQECVVpDFp6FYI9eK7hd9l293IklKNkW6CQpqHCgIGjnGMDRaZ5s2xSYZj9UkbO/J1dLLyfteCSl2P98Tbn67avVBue+CWBEAuiwynwBIjKfM6AQcy7GGBhd07VfUonJGbV9qNWxMoLnfK5/Vkvf1079l7IFj3C/XHrT2T9XeXKriIKF3Mid8M0kSYePZaeIaUsdcq5NsF9delcLQWq2BkynpF4oQ0DOg7lcvtZAeyAT+F3d4rMH7mH4os/SJL1CBGEQktzn4jvebmYJSbx7YLReKUhOkTrJB8uIZa1t8ZlIQBtd0+wSz/JxhZ++1YNQLxMvoyZJLO0R5/L5rmI94XUXmY5TzuRkRUzCXRbaepbLMYnZB9zhdVjeJj7RdekNQ01/wM/wUPdcbbKOZ85YY3bY2owtRFzbLOpU1o0f1dV6DIGIDMfYB8ab7FXq3Qp9H42x8bz281D/Jtseu26JgHZ5Y4HGetQNtYMNd+DF/8hAs9V5fG6gSO1BLqTNco3V7CyKxY0ddY/TsKW3zRra+DdjFkPFbYaYOSLv5stU1xUU9IGmP8zUaX45JJKau0TtKePCIunVE6j9l67N+5t6Vd7+x6q0kDmQ+vw432Id/qpoilm2cbSH1Nc/fEHqoD1DxnSUmw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199015)(86362001)(38070700005)(31696002)(122000001)(5660300002)(4326008)(4744005)(76116006)(64756008)(110136005)(66476007)(66556008)(66446008)(8676002)(316002)(6486002)(54906003)(41300700001)(2906002)(478600001)(186003)(2616005)(6512007)(6506007)(91956017)(38100700002)(66946007)(71200400001)(53546011)(31686004)(8936002)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUNsRVB6QjFmTm9WNDZucDIzelllTUxGandncm1qZzRZdWlMVnRLWHowbHRS?=
 =?utf-8?B?UGdsdzc0TTdwQ09ERlJ3WE0zT014WXpuNHgrRzNnYUp3SWtyRWxJSTd5cGR6?=
 =?utf-8?B?WldmcVEwUlZHcmVodmYrOGpsTkJUcDd2K1JxM2hqd2tMQUZBbHBHNDlrOHFP?=
 =?utf-8?B?V2FTUzNYcWpCMnBCRVlkeVBmY3phR1UwNEdSMjhTOC9GK1VjbENMK0llbUI1?=
 =?utf-8?B?b1VzT2VWQXRkcEZINE5VTTk5b3lnM0tEMThjeHJWL0NueERRMVFTeUwyQlJi?=
 =?utf-8?B?UndGUWNrNGF1Z29iTmhQK01RcGl0a0JkQUJFYlo2UVJyTk51c0oyRjhUWk1V?=
 =?utf-8?B?WXVOcDhvamt2emhTNzlSNGdWYTNwTnpMcW9vdG9BM0ErdmYzM2dPZWZ5cWpI?=
 =?utf-8?B?UTFBdlVzemFQYWhYalBkd1ZwRkVhK3RHZlhDN3JmQnJzVnRnSHB0SlBDcGxa?=
 =?utf-8?B?RU5lc2NTZlNCWjYwYmlqdi8weHVSMlhXaXMxVGpVWVBXVlNYcU03YjVDQ0xH?=
 =?utf-8?B?RlVlU3BEWWxVcmZVNVM1TUZMK3UvR3AzcVNvUTh6MWdnNjRJSG5wd2dBdmpD?=
 =?utf-8?B?dXdmTEkwOFVQSm9IR1RKclpCRGJzZkpiZHpXTnJNOTZhcDFtNzk3R1YrQUVL?=
 =?utf-8?B?WEwzRUpCV3NhNWVWdFVxZVAwVDVFS2FSeStLM1dZT1M3ZGN4OTRacHhGY1pG?=
 =?utf-8?B?emRMMkdIQlZ0V1VYalRxMlc0MzAyeS9Ma25qeDlwdi9oS0ZuQWN5a3VqQS8z?=
 =?utf-8?B?WlhzZGZ5TXJaN0FTTTlxYlhRSHRLNEo4ZGFoMzkzTHFCVmtlbnFXdHdnUXU4?=
 =?utf-8?B?TDdYU1JVMitMZjNUTXhNYThvaDQ1YU9VZ0k1RzJRZFJCbnp1SFFQZTZFM0NF?=
 =?utf-8?B?UFdPL2NHQkhsY2VXcE0rZUx4blZMWjBBNEZlS0EwWUlyS0hSVjBvZ2dMTnR2?=
 =?utf-8?B?MDY3T3lISStFUndxanJXRWY2TE11V3F1TENtcklZUklDMkNMckFhaWtkSmYw?=
 =?utf-8?B?emhzdklXc1JpV3cyY0dVVmtTdXROSHlKOFR0ZklpSDU5S1VDTXpYQUFteUdB?=
 =?utf-8?B?VWxPb2ZKcTYrc0gvU1Z6cHcrSkZsSmp3UHlQeHR5eFdycjZmUlJBUEV4OGY3?=
 =?utf-8?B?TC9rZ1FNaGJ1UkxnUXJ4MWhGUzdMbFBZeHZ6MHNkN0p6ZDFsTW0wNlZxaHdL?=
 =?utf-8?B?Y0kxUWNKd0krMVdJeHVJdFNLY1pyS0xIMnRKbEpXRDVsZENHa2ZDTW5ZazFr?=
 =?utf-8?B?bWNsK3ErNTVteWUraDFDQVBoV3QzMzNUeUhURGZZbWZQeUswRlBFclZiRVVZ?=
 =?utf-8?B?Y3VXajJaVHVlVDJ4RlBRT0dSTlp6QXdydktsSG5hYWg3bmI1MloySlY4QnNk?=
 =?utf-8?B?aGZKbysrRDRaMVNQRC8yK1ZuRUg5Mzg0MFBTeVRYWWh0K2E5ck9PMEZ0c3B4?=
 =?utf-8?B?N3VndEFTeWVwUnVRaUd6czExcy81WklYNzRocWRBMFNkeVY1VDlUVkFOeUIy?=
 =?utf-8?B?dEVtU3lWU0VXU3dnWTMydGdyd1NVdFp0a2ltZmFXblRqb2o1SmdHNDBaMGxs?=
 =?utf-8?B?aVF5TkdROVMzcUxZcE52UFJwYW1yM09CMFlGTUM4eHVpc3UwQUZFMXkvZEFN?=
 =?utf-8?B?U2lQVlo0QVdSSU5lcldwSVJkUUh1YTRBWVRqOHc2cU8wMVJkVW5yRkM2VElu?=
 =?utf-8?B?OGthRHBPK3FtcDJ0ODhpN1d0Z3oyOCtqdzlGaVdLU1MyYkhtdTgyQmtTdUJL?=
 =?utf-8?B?dGdlVEM3L3dENW92MUVnU25hRHVsWVVyQjlmM3dPbWtSQ29JSTJSWGdBTTFa?=
 =?utf-8?B?QXhSV21pVUw4cldESnhCelFyR3BxY0d2b2pGNWxwOWNEZUgxcHVKbUsvUUg1?=
 =?utf-8?B?aDNxbFM2cGh0b24rRnU1bEJ0MktETlQ1d01YaVFCQVRiMktpemhpLzB6TWR3?=
 =?utf-8?B?RVdtQ2cvMzJOREdtTWYzNUswWG4xSzVUSjhUU21adEhBdmVoWjJlWmwvL3VO?=
 =?utf-8?B?U2RZSUZBSnNtSmIzbTUvVXROY1hqL0UvejF1WFZxWEhIbnNEL1BpTE9MTnR2?=
 =?utf-8?B?bUxyR0ZrZEZvUWJiZnFlNmRqcUl0ellvWTV1enBpYnVpdmtVWjI2NCs5eEJB?=
 =?utf-8?B?K0ZXb2dvT2hlTXFTbHVKc2o4Nlova3djYmU1SkdybGRadlV0cVg2aDZ3WU9x?=
 =?utf-8?B?Wmc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e455fea1-5ccb-4b56-07c3-08da9b8e3318
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 05:00:27.0595 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dn/AltCF5vPZZ2INR6+1N9lK4Jx2eQ4ujvcSNwPEIQVBneThlyfMf4pqHnmw7NhU+Ck2iTqInAKSPVzL15iBuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7336
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 1/4] brd: make brd_insert_page return bool
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E7F8697709A97F47BE8FC75BD42F90BB@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/20/22 10:53, Mikulas Patocka wrote:
> brd_insert_page returns a pointer to struct page, however the pointer is
> never used (it is only compared against NULL), so to clean-up the code, we
> make it return bool.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> ---

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

