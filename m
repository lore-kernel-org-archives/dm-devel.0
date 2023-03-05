Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30230C6FA8E
	for <dm-devel@archiver.kernel.org>; Sun,  5 Mar 2023 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678051862;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4eNqdSb8CFkzKm+qOu6DnSwum+NKxDO4BO6fHjLFbrM=;
	b=SYM6rpG6hSyPnvDZM++w4BcC73dd7D/RQZ0M9dF+f7nLt6lAvuEi2Hv3naBHHPXq0WIPOc
	74OWomuOUWW52I4nHioSRDQjjGdoQoB0yWOCZyH2nyoubJ5F5JqnwRkClU0CKDadwO4Qgk
	vSZH2wqb/VvOspUBbyROQA4SLWSo3QU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-Af7ETuqpPTGRettbBuWboQ-1; Sun, 05 Mar 2023 16:31:00 -0500
X-MC-Unique: Af7ETuqpPTGRettbBuWboQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2C9E800B23;
	Sun,  5 Mar 2023 21:30:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D926A2026D4B;
	Sun,  5 Mar 2023 21:30:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7629E1946588;
	Sun,  5 Mar 2023 21:30:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 527151946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Mar 2023 21:30:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 44FAD112132E; Sun,  5 Mar 2023 21:30:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CF37112132D
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 21:30:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A3953C0F668
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 21:30:08 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269--1fAz1gWOS-N_1yZ9bmNFQ-1; Sun, 05 Mar 2023 16:30:06 -0500
X-MC-Unique: -1fAz1gWOS-N_1yZ9bmNFQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sun, 5 Mar
 2023 21:30:04 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Sun, 5 Mar 2023
 21:30:04 +0000
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
Thread-Topic: [PATCH v4 12/18] nvme: Add a nvme_pr_type enum
Thread-Index: AQHZSHgdE5qrhBqDiEOYJ4pU70wqXq7swl4A
Date: Sun, 5 Mar 2023 21:30:04 +0000
Message-ID: <763d2af9-55b2-24bb-9b92-2e8e5616e3df@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-13-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-13-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7864:EE_
x-ms-office365-filtering-correlation-id: 0e4d015f-75c1-46bf-b07f-08db1dc0c8c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MsBRWGuN5DLODOgDtZiLA8pYpLT6vvKFPIFhZ3UxQZ4FCsodXi4tZOPzOk3DPMsAGMMyNN7k13dBZzRPMACbUsX+/l1gw1rAk+3Jk0c/UV8LOOLwiF8TOgd+pSi3L8TSFGdTqLrnBgbwaxwb1dufN0+fNPEKiEJhlLncdn8OO1XB+3BSHfUvS6mJJEUaKSPfvof8FS9IgVxvgLVYjXRQ3bnsgdzj5/M/Z4wjlD5Ukifyea5PT5xTJgbK+9LMeeicoctQA4bY4MIeKxPGEcCqxBQPF//MxFf0Lb2XLk+MaBXmWFencvokvE2S+wxPLJ/aH4VNZ2zoaWt/ctNV32l6woHCVqx/C7FRwvAYdcAo6k3+KRFJ54bCuh4LKlaDxLSAyEyJQ+evFJC3gEclgiq42GlHaXmENGoKx8hXmsMuKd4VvX6KPxLDy8gCFzBB3zT40Ms2kbAW/7SI2rBfrm64iR0ihx9ziUKdftntz6YsFYUmUSRn5S55V1EzeRaEVaYrwTO43YQ3WrWHyj9ejiGHLVw8M3qHJUcrJy+whZwsUJw7bkcZ01eKFP5jCnH0tv1tx0ABMbiA+VOhTZDH2m8TZK7kMIIMnCPSVtHnaG2cDbq+owl2m2k2VOm7OlbnxfRedSszh0iyPmNs/wZqLCZ/7T5wDkUWa0c2eGEozoa1/5N9J32pu7epsAdMj/QsLLn87HdpU/cWhJFlFNBj6fI8Y+6j5zdCIjmSDHOCk4ZT14VHEYjAlKkWKullAzXNGOKS2UX3/Av0W+KubR1SoNSBQKwVbUvWNEfe7M3b/f6KRN4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(186003)(71200400001)(6486002)(38100700002)(478600001)(91956017)(66946007)(110136005)(83380400001)(64756008)(76116006)(66476007)(66556008)(66446008)(8676002)(53546011)(2616005)(31686004)(316002)(6512007)(6506007)(41300700001)(8936002)(7416002)(5660300002)(4744005)(122000001)(2906002)(921005)(31696002)(86362001)(38070700005)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blZENVlwZVlRT0UzNkw1aDRmUDVJOUtwWnJEcllTWWMzcGlaSFRvUy96QkZO?=
 =?utf-8?B?YUdxQURoN2NESkJVTEJOK1FXTk5PNlpMZm5MUEJrUTQ0Y0xlR0NOR0ROWHlJ?=
 =?utf-8?B?L2o4c1g2OElneUs3cVhCcmJQcXF5TThnZVZ4ZGZTanRORC9GMGRxRlArd0lP?=
 =?utf-8?B?bllBN0drTWlmMU9OdDVLTFhOSzl4eE9oZ2NpVE1kWDNxUmlWejQ2b3g0bW5h?=
 =?utf-8?B?TkxsQVN2R0Vsa1B4YmJvYmN5TFhhOTg1bzY4dmp3allFQTdTTW85RS9oMXBZ?=
 =?utf-8?B?dU5EcDRsSEQrckFLTWhVaExhTG1VQWJpbklEanQ5TEVaYmFmZTR6aVRoSlJH?=
 =?utf-8?B?MWhkckpuY2J2eHAzSWNqUkkwK0xnemNsNEZEVXRsRmhLcWJoZ2x5Z3BGbzBH?=
 =?utf-8?B?dytMaFJ1M0Y2NC9VQXlFWDhYQ1VqZXhpSUNHeHI5SDJHS0ZtWDBmNUpQeE5x?=
 =?utf-8?B?R011ZDd0dHNIa05TdE9idUtDWkpwcjhUbGdmc3JCK3l4a0tVV2FmZ3BpV2FW?=
 =?utf-8?B?V09lZ0duVWZOYmpyd1JKMERrck5NamtKT0VzSzBDQmxsbHpFSjNpbDFoUGdy?=
 =?utf-8?B?dlBCM3YyRFpTVjBHZkVUNVRjUEc5NkFRTXV1ZXNiMjV2M1JCZ1ZRRUVUcDFM?=
 =?utf-8?B?azJKaWxmYWt5bXRteEhVSHBFWFhhelk1TWE2WG00enN1aTFWeTAvV1dybDVN?=
 =?utf-8?B?TGFSdlBSWlpCZENFM3cxOEpBdFR4Z2kzUzNMOVpBVXNGNEVjVWRsMm9uNTZj?=
 =?utf-8?B?SWpkQ0JyWGxjdm9hbEdjUEVYeGhwQkJuVTQ2R1RickZWdHhwT0ZJaHNINEpn?=
 =?utf-8?B?T2hBZStnWmE1ckhGYjFOVlVTdmRmcGF6ZWdmYWlxQ0xrb1dzaUVwSHFKbnh1?=
 =?utf-8?B?eVh2Q2ZEZUFINnBSYmF6ZjJyanpsZ1lwQTdDYlN1eWJjQzBuL3p3VE9EVUdt?=
 =?utf-8?B?Tm5lVmNjekltajRMVDA2NVBZWlRnVXQ0NnZJbWxFRll3UlVHdFN6R3loeGs1?=
 =?utf-8?B?UG5vUmtFUmMwYjM4S1dOV2xGN0twVHFzWUJOb3lTWE1XVWJCVFVaL01HNUMx?=
 =?utf-8?B?MHhlT1IxZzI2WFI1Um1TUnpjRStONzVFalNkMkQ2OVNvNFlpYUhZTXRFK2pC?=
 =?utf-8?B?Y1F0N2tQaUQyV05obzJBNVlueTVkRUg2dVJZZmFwd0M4b3BQVFFmbXRKZStz?=
 =?utf-8?B?YkR2Z29IUkFHY2I2R1JjNnpmc3IrOTZXNlVvb0lQNkJlUVc0Q1czZHNaSExt?=
 =?utf-8?B?NHF0YlNJNUZmZVo3c0JFWStqd0hJWTA4Rk16cC8xYWt1R0Y1d2tsM3pVbStE?=
 =?utf-8?B?dDh1Wmkrb3R6NnNKdklscEZ4TzVtRG83RHMxd05qYSt3WWJwTUJOMCtBNXJn?=
 =?utf-8?B?eVdTZzR5SmxnMGFGR0dIMkh0M3ZDM2RmZUZDSzV4aDV0RnB0aXBNVnRJdTcz?=
 =?utf-8?B?SE1KYUs3UzNReG02Vk1uU3NpY3FYamhncEg4cDZBQk5VQXRybXUyRU1RUmVD?=
 =?utf-8?B?UVByNFNmOE05RldEWTUvdXVOcGROakZIc3p4NC9vSFhlZXFqcmpMNEZoY1VY?=
 =?utf-8?B?ek15RlA2WXNBTnNYNXE5WVhGYmMxSk1yNzNZRmx0NWRjMUt0V3BCRktYYk1G?=
 =?utf-8?B?dGxRU1dmeVRJNzJUV29EQ0FWMXJlQ1hsV2Y2OWZ2SXkvQ0tjejJGaUJaMEwx?=
 =?utf-8?B?SC9zVllZdmo3MFZ1aStvR1pyUGdLZTNTeXQwVTQxbi9lakl0M3gwUlM3N1JH?=
 =?utf-8?B?YzhpNXpVczZDK1VpVzh1L0t4cFY0Y0RFS0N5OTNPa3RoNnlsUitxUndXbWox?=
 =?utf-8?B?emVtTmpZeDdOTTYvTDRNKzFvbGpaUk9wZk52T01IdndmMk92bWUxcWUrZVNs?=
 =?utf-8?B?MXBIUzFmS2ZubUVDbDJKTnRWQ2ttcmxHcEl0aURWR3FGSy91YTdTQmtsYWdC?=
 =?utf-8?B?UXRmWGY1MndKeGVrSXNLV3Y2Z1lPUlFiTEI4c3FkaEErTkwvOTlOMHlZNWFX?=
 =?utf-8?B?MThjV3hxTDNRREsrVjdCMnhrbVZOdVhsRXlZZFhDT1hSVWVXSmU4YTJkWFl4?=
 =?utf-8?B?d3AvMHhSdC9NbTlmUG9DdmdSMEV2YkIxaWZBV1lHbExjVjMzNjY5a1NyL0h1?=
 =?utf-8?B?S2tmZGVuTzdPVGFZQ1BEV0dwZVkvZXlLNGJsZjFtTzFOZG9DVWtDdjk4VDVL?=
 =?utf-8?Q?AY3UzfqwhQaJ0jizr8SN7X5sCgfXwv4whkDIWk5EJcBU?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4d015f-75c1-46bf-b07f-08db1dc0c8c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2023 21:30:04.2332 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qEIH6JkavxNeJG0F4fWYFEcE7sONVFbSAUeTdmt8YYeHIF/yxwKzniKkRhQJG4VocWAPfzWVsiZgONLI/1OETA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v4 12/18] nvme: Add a nvme_pr_type enum
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <EB1121A40C0E85439FEC8276C18DACBC@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/2023 9:44 AM, Mike Christie wrote:
> The next patch adds support to report the reservation type, so we need to
> be able to convert from the NVMe PR value we get from the device to the
> linux block layer PR value that will be returned to callers. To prepare
> for that, this patch adds a nvme_pr_type enum and renames the nvme_pr_type
> function.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> 
> Note for Chaitanya, Keith and Bart. For these patches where we convert
> between block and nvme pr values, it seemed like Chaitanya and Keith
> didn't have a strong preference. Bart had the suggestion to keep the
> switch and drop the default so the compiler can warn us if new types
> are added. This seemed like a nice benefit so I went that way.
> 

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

