Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 785D5C61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 05:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678079021;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VrvSCy6v5mPNdioZupBw1bbIgaRAguhsvFwPGtmkXeU=;
	b=EVaAthTGgT4hMr4ShcvgGsgPjPOzCkppFMDWp3NiQMrYWOydR/DkwVeNN7LDK57yqRcMwX
	FC5xYVE6waXyv2SKy5XjgR19cFiNCsklfic7twpZk93W6eRT6IvcfEy0sOPP4kbOLXOvNm
	MT15CUJwC0DF5kb2ZlzcM+hYlS8XJ1Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-GTYV_GrEP6mQlEJMQYJvuQ-1; Mon, 06 Mar 2023 00:03:40 -0500
X-MC-Unique: GTYV_GrEP6mQlEJMQYJvuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3833580D629;
	Mon,  6 Mar 2023 05:03:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C226FC16029;
	Mon,  6 Mar 2023 05:03:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A29511946588;
	Mon,  6 Mar 2023 05:03:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A8A431946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 05:03:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8D962175AD; Mon,  6 Mar 2023 05:03:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8537E440DE
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 05:03:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F4883810788
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 05:03:34 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam04on2053.outbound.protection.outlook.com [40.107.102.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-H3bN_Ak7Mk68CAwHW7rB7Q-1; Mon, 06 Mar 2023 00:03:32 -0500
X-MC-Unique: H3bN_Ak7Mk68CAwHW7rB7Q-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB7453.namprd12.prod.outlook.com (2603:10b6:510:20a::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Mon, 6 Mar
 2023 05:03:29 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Mon, 6 Mar 2023
 05:03:29 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, "bvanassche@acm.org"
 <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>, "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Thread-Topic: [PATCH v4 01/18] block: Add PR callouts for read keys and
 reservation
Thread-Index: AQHZSHfKc5+sVD4VfEG7FVd4DI6xNq7tQQ6A
Date: Mon, 6 Mar 2023 05:03:29 +0000
Message-ID: <ab2910d4-ce73-340a-458d-1c9644d1c292@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-2-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-2-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB7453:EE_
x-ms-office365-filtering-correlation-id: 2d0c0311-2f57-4ac8-1eb9-08db1e00205c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nFgCNoF6JaTsm1CW1XfiCRaocck42QxfFrjR9NN1Vc3FxQ83BiQ37dqunOeJkSdz5RavXWWLOLCr+PCLu22KlLYfyaoDgsX+/6e/4mugiVH90IHJbRXrXXBQtgLvmDEClTkC40LujWoKqAv5fWs3Bc+joA3yyTvKYZSKGFPc6fvlltEDZdAmNjb+QxFwoDUcCKXkJ022U++NNFcvvkTS1HmSsQaTuQfnklaXRpczDKf5t1L2e+4QB3m3o6wEVFIvHQbUyfwxfZGGATgs2Vczlv5eCwuzp579E6Yk4VNKrTrRchFNGTuie+bmSkDivw0GpCWhkW0rmPiEP9KKnfAw2F4Kf7QGZSMWraIo8/fnmG9EJOAQKxIMZmUc6OkytWMzFHBUhKKw8jlY2F7vk6168PRDZFxMr+pbDB1wTYqqNmJAWvTaFWeL6NrNc5oTCiEAscqX5FU3ofQkMTZ8rbt7rXdTJIuxIFizBofjJtanW2kvNJIYd0BEcehHNA6O+jvUk1TSEoge5RkYBzjd/O0B7nV/wtP6ZrtHrR9BWvUoKUzX9FuhXBltO2vcO8YS682TebQG8xxCPuaTgLO8Rbi9QPFJIqi4tAuxriHzS7DoRCBb2cipEflzwOqyyXrj//q+FBDhbU5W+r1EmSiAgKfrVBj3bEj4cR3ARCgSSeLv8YquciDCbSN1mYtDdbhIntRJ5+7cHfZ5ScBAKaqjMeFGcfHSSyv5TyKOJRoPQISP5vRB74nmNOi3tP4f4h3m9hT2NKQNLskbSz9CcVT8BxiExQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(186003)(122000001)(38100700002)(91956017)(38070700005)(921005)(8936002)(64756008)(41300700001)(66556008)(8676002)(66946007)(2906002)(4744005)(5660300002)(76116006)(7416002)(71200400001)(478600001)(53546011)(2616005)(66476007)(6506007)(6512007)(6486002)(316002)(110136005)(36756003)(86362001)(31696002)(66446008)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tlo5NjZmRHVPcFlRbXl2Mm9FTUJiVnh1bGJyZTBQWk1Ya1kyYXllVmpzYmMw?=
 =?utf-8?B?WmI0TVlRdjdhZUtzOVR0TFlWMDlOVWtFaU16WVo2bzU0ZUpTNkp3Uk9TMG4z?=
 =?utf-8?B?RmRDWU1kZVROVGJTbVVuLzZpY3BaZnp5RWtpZXlDbGdyNTU4ek4vRThyOE5v?=
 =?utf-8?B?K3hmVTJmTjBWZDNvelZaN1ZGRXh5SDNSQzk4RlUxOUFQL21OZEo2NnI0YW1i?=
 =?utf-8?B?b255Z3hHdktYRHd1V2tVTU1BSmRFMFhtUitzQjd4T1VQQ2p2S1h6aEtUelAw?=
 =?utf-8?B?YmE1T0I5NWkyR0dEa1BzRmFjbFdjdlRzKzMrUFNqZWY2dGx4aXBqeWRORjlS?=
 =?utf-8?B?VytPVHJMNW9sYW84Z2kwTWwyN3ZFWmFiam5lcldrSTJCWXJPTk05Yng2YWFU?=
 =?utf-8?B?ak9RRkVjQ3pqOUxkekVISmwxSHk4WVRWaHVta2djb3dkK04rZXBLZVFybVg4?=
 =?utf-8?B?UW80SVBMTjNzbEozd0UvT2lSVXBhak1lU0FlZFExMW1rdWJld2VsYUdMQ0R6?=
 =?utf-8?B?T0FHTEQ5SFBmTU1qV3R1blp3N0FPZDBzNVVINWRaMnhHSU54TnA1eHVJVDJ3?=
 =?utf-8?B?N01QakN0WnZ1eVZlb3NIblBGUmdnT1NPbDN0ZDEvYzR1SThhQThqa3ZnMytl?=
 =?utf-8?B?SkJXeWNmdk5RWmM0QlVBNE9NcmZlUVhBOFpWdzAvU0VGcVhKanlmR3pWUVc3?=
 =?utf-8?B?S2lsZVZkUlBKcEFqME5uYi9sU0d6cXdnN0drdDltVFNZMDQycnVBMmRqV0RW?=
 =?utf-8?B?a0tOZ01vcnNXWHBUWHN0Q3VuT2ZhRjdWajVEdVZVcHdPcDlxdjRXYnNsRVNT?=
 =?utf-8?B?bHJ1WXV0MWhrMllIalk4RHROSzFaaVdKSTRZWEVHVzBkVlBvUFN4eTUvYWpK?=
 =?utf-8?B?c3lpN0s5WkhFdGNYcHpDRmZLYk01K3ZtSnZSNmswS0JHRzVkM3J5L3E5SUd6?=
 =?utf-8?B?Qm5rcmRuekwxR2o5elgzUUNVQVRobmQvVkViNjNqVTVuM09tVHZ5Tjd6MEhE?=
 =?utf-8?B?OTlZREpnODlXN3lrNEU5Y3JjR1QxeHhLSUwvQ0JUZVd3M2tNeWg0OHQzYWU1?=
 =?utf-8?B?THhLbWgwRGlDV0xDL3JDdi85c1BqeUNzd0JXUUY2R2dPTk50TTB2RzFWa2t2?=
 =?utf-8?B?dFp5dEVOaGt5WDEza242VWh5S1JzU3Q5aVVEdDBqTXhkZ1JmaHREQk5QWTI5?=
 =?utf-8?B?bWsrVHhtc1JucXJBNmErRUUzN2c1MEthS1NsZG1JUW51Vi8wZmM4ZE1seW9H?=
 =?utf-8?B?NjJqbUhMc1QrL29URFNRVitIN3JSYVZQRHl6cGh6NEdpYmxsVXNUdzBYTjdy?=
 =?utf-8?B?TDJyRk9Ob2xHWW9uZ3l0WFlOTmxuRmxJSm9NdzI2bWR6YnpCQ0Z6UlNLcUZa?=
 =?utf-8?B?NjhIOTZOZ1dKbFk1U2hramJnOTYreGVFWmF2TzhoVk1nSDRBa2F6cEFRVCty?=
 =?utf-8?B?bjMvSU54SC9tRVFKZFplTG4yMkUxdmwxVDFrNHpQLzl0eVdnNHdGR0ZyTGVh?=
 =?utf-8?B?SWwvOVh5UHNKUmt2cU5KNk9RTWdVeEprdmZuZ0U0QXZMNkszOXZ2SCtjQTdN?=
 =?utf-8?B?OXhETWNlbDhSaHhCNGJoeVpobzg2ZDFjeW1mY1JJOFFDYWN1dHIxMjNMNXZU?=
 =?utf-8?B?aWRvUHoxUkRnZ3BEN2lvckJ0bjhRWjlSWjNBQlFYemN1MDdRRUdpTFZqM29u?=
 =?utf-8?B?QTFtTk56dlo0RGM5VXFHczhtSnZhaVk5eVJWL3F5M1BySld1dFNGS0RrTWk2?=
 =?utf-8?B?VXNqczdVUk1XUnFxRldBK1BQbnp2S0RrR1BodXd2VVlqbUtJSEJ4MGdTSTht?=
 =?utf-8?B?NFFyU1dWc2l5d3NWdEtxcitwOUpldzRpWWc3SGdOZy9WN1RzeDJiRTExK2JF?=
 =?utf-8?B?dXFZRys5NFVWOVRMZ1VqdlY5YlRFNVVlU0E1Z2tZTzgxZnJNcHJKSUZ5ckZ3?=
 =?utf-8?B?ZWtCOTkzd0NKOVdJYlpzUVErS1N3VXR2bjl1RllQbFJrV01NYVpMZm1VSXN2?=
 =?utf-8?B?VFd4MGFOazdTMGxtZ0ZZTTlBNXJsWmdTOEdQcVAyZkw2MXR5SmtEQ2NNQlFn?=
 =?utf-8?B?bkh5d2RGN1F0VWFYeTJ2M0p4SmRVZzFpbzlRZzJweVpBL1pHTVpuUTUrQmpZ?=
 =?utf-8?B?WGZlMTNvcHhmMFlBb1diY0JjaEp0Z3hmcTc3WjBMN3o1a2p2N2cvcnFZRzJP?=
 =?utf-8?Q?pBS1mwkOoC+NwV53a3j5AepA4Ha39DXkDEYK3bPv5ChZ?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0c0311-2f57-4ac8-1eb9-08db1e00205c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 05:03:29.4486 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /pStLDqD7o8UNlRwLxOHFGZMkwK/T0/lL0q3vleshi5QNezP7BvLfr55MYiD4txXQS/kVN+cKCgDtj8HDRFMdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7453
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v4 01/18] block: Add PR callouts for read
 keys and reservation
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4694B2FA86EF8D45981CDDDEE6D0F76B@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/2023 9:44 AM, Mike Christie wrote:
> Add callouts for reading keys and reservations. This allows LIO to support
> the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
> to optimize it's error handling so it can check if it's getting an error
> because there's an existing reservation or if we need to retry different
> paths.
> 
> Note: This only initially adds the struct definitions in the kernel as I'm
> not sure if we wanted to export the interface to userspace yet. read_keys
> and read_reservation are exactly what dm-multipath and LIO need, but for a
> userspace interface we may want something like SCSI's READ_FULL_STATUS and
> NVMe's report reservation commands. Those are overkill for dm/LIO and
> READ_FULL_STATUS is sometimes broken for SCSI devices.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

