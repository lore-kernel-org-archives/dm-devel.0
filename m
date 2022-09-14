Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4353ECAAD3
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 17:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663175857;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5GlC8BIdfntfPwy/GOD0XlgoXguM4oRBQKHPxsCMXXc=;
	b=WjYpbIzN4bGAJHTCDWWJ/Iy51h4IoCl4Bwv3ec0AvcA2nOtvjiaOS7TJ02sNeXasClRNOg
	fWX29zgAKX3NyukjYQr3ViG8zNyrC5kcKHYdzR3H8PpG/zdDce2hin5FHb3MBCdiIQznd6
	Xdx2YPtbwXI4TTQKH95JZGwsDVKcES0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-AA_pLNDwOiao10g_1g_P0A-1; Wed, 14 Sep 2022 13:17:34 -0400
X-MC-Unique: AA_pLNDwOiao10g_1g_P0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 730388001B8;
	Wed, 14 Sep 2022 17:17:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E84040C2086;
	Wed, 14 Sep 2022 17:17:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D7AA1946A55;
	Wed, 14 Sep 2022 17:17:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4232F1946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 17:17:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3372A492B04; Wed, 14 Sep 2022 17:17:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EF5B492B05
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:17:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 188E2185A7AB
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:17:31 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-q5Ptak0TOzuNS1WO0ixZnQ-1; Wed, 14 Sep 2022 13:17:29 -0400
X-MC-Unique: q5Ptak0TOzuNS1WO0ixZnQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4052.namprd12.prod.outlook.com (2603:10b6:a03:209::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 17:17:27 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 17:17:27 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 07/13] zonefs: allow non power of 2 zoned devices
Thread-Index: AQHYxoDuZVRHGaI6eUyTaRXyz0v6063fLreA
Date: Wed, 14 Sep 2022 17:17:27 +0000
Message-ID: <9595fdee-44b3-e210-a650-3c67875bef22@nvidia.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082213eucas1p239d6095dab9b042f05efd3a6e82bac9c@eucas1p2.samsung.com>
 <20220912082204.51189-8-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-8-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4052:EE_
x-ms-office365-filtering-correlation-id: 1f955e0b-61be-47e2-3401-08da9674ff69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /DIpJ4IKipyx537WFEgKvaX7Lrv1v6EAafAhVp4D0j+YtDUcq40aUaY+qIQuf8IlucE1jZKCtxNzSl1mImpZ8D5XGrSHoPjh3uwkC/4lhskCvjkP4nV0946PR5aPRvtW5O4TbXpI7MLMP+I9Ce8nJCL2LGGPxUZG8V9t83FvOia5pasfexiLJlollhgWUTPz3gs1GDBiVEinIRJpFCsShRE3apm8JEibvpEmdRHGDa/lduz9QeSfZ+Xnkn7KZ6TYwnp/WUr4CFV2XpLePQjW8sBAVPWxvyWyaCOzmPLYVn2mu4LuFFmHWHs6fd6Rmd0AC+GZq1u5Xe4i8bcpYuYFba22Y7uSnhS7orLRwbzSQzAKfV14RmHgefVDS7aQldzPHw+ufcVNL91KKx4DtnRDMIT0PnUXWks8K8z+22QphQfF19qY1vVSzCD/BhVG6eVZbC350Unhbv8OQuLVfve1N3mfQZDndXu0t5pIrfXE3bXy6+Ebm6rAkSZrajubYnsp31r7ngcwvQHGnn+iHcR8ikXAjvoD7bZQgrMsjUt9Yx8h3XTkrycz7V6ha4r0Gu7MMjRR+akxnr3l4IE1lRE+Ymc30/Q1ahum2MNTC3/JlOu7Yv+eON7bTUtCddRPYBzbzgq+12En0pty/dYNf98EY0yMHHZBpvXS1rlj0Ym7qhWh/r0CY5WBxKGgtMgicrSnNnGvNRhvH4bILNwxQk7+IaavpanRDARiTB7RZdnM/TQZ7bl8y4VOpOhY2xVxRLVG9WLzhQ426cayYjDEBtPtS25xypccHOx9hQ6LimM2q3ax4o5hNcYpK2cfCP3uPCzRpcM3z7pBouzjWK/LyjQXVg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(8936002)(71200400001)(110136005)(6512007)(83380400001)(38100700002)(8676002)(26005)(31696002)(38070700005)(478600001)(66946007)(6506007)(4326008)(86362001)(7416002)(66476007)(66446008)(64756008)(186003)(76116006)(66556008)(6486002)(53546011)(5660300002)(91956017)(2616005)(4744005)(54906003)(36756003)(122000001)(31686004)(2906002)(316002)(41300700001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjVlWFNZVXEzQktOL0lNV0l4WTRQNzM4SHBLQXhoWWx3cm5ib3FUeUFaNUtn?=
 =?utf-8?B?NnREV2FBV2E4eERrQmhyTDNCUE1tZndtelV1a2QwczZCeUdlR21pRHpseFlZ?=
 =?utf-8?B?cE50U1V3M2ozRVRYRXhNTUVob0wyekNHZlRxeWNKZnVQZnVLZEdiSGx1VU9S?=
 =?utf-8?B?MGZPU0pPVldPU1JrdWZTTmtRNlhxOWsrYlZRRlI1ZDlOS3VaYm4yczcyaFE1?=
 =?utf-8?B?UlNlYk8zaXJocWsxNGo2Q2Jhc3puNDF2K29tcEo1ZkFDRlE1cUNhUThkdVU5?=
 =?utf-8?B?Y28wUTRZK0UwcllTODA5cHJuTEYxN0RBa0xQVFArYWdrMkxxaTc0Q2tnbnZq?=
 =?utf-8?B?bnl6N2F5TytBdEN4VmZUVExOdG5kTGFsaXZSTkZTSXY4Y0VTbWlRS1lTTVhp?=
 =?utf-8?B?ODE3eDN3clJiV2hMZTBDdE1PbEY2R3A5c0crSmo1alJmRytEVGV2ODQ5OU92?=
 =?utf-8?B?N2lHV3FuRGYyem9UeklxWC9SNG0yNldKQ2RmQjVDQm9NVzMwQWpRdXRNdnpN?=
 =?utf-8?B?N1ZLdTZ4SzNHN3dsdDVZajJUd3c0ZFBJSkUzMmpYUnVtTklKblg4WUc2M0Yr?=
 =?utf-8?B?K21vaEo4a0hPbHFtS2YvSllGNTQ3RlhoancrQm9JOG1BcTZPd0h5Zml1bkVv?=
 =?utf-8?B?N2U0anA3ak1Lc3pHV2EwSVIzU2UzWlJOckhWcVZYTkhSRFZ6eEIyT29TRVJt?=
 =?utf-8?B?QTkzOGlkUkZUeXc1eVVDVUp4T3F0NGZDTmRsaHV0YWJHdlhYQmhVQndSTnJl?=
 =?utf-8?B?MytLUXRhckw4SUlYbkFrMXltV3FGOFk2YlQxWCtSRVNoVWJRRHNuUnNsZmVt?=
 =?utf-8?B?Z1ZISUtnaS9XTVU3emcyWUxBeXZRZ0VVdGZWckZLaTdRSUkvOHBEWG44Zjd6?=
 =?utf-8?B?UUQyeUhXYWJuclZqRFdRSXMySE53TlNkVVVtc0xxa0lsRzNXdGh4MUoxNng5?=
 =?utf-8?B?QllzWTFvRTh1OXRIN05ub0FSRkdWVnF2b0FpS2dUSCtaRHZaRG5ocEpqQ3Ju?=
 =?utf-8?B?b0ExQTl1cG5wZDNoSnJiVXFTZnpTdHVVVmFDYmJLM09sbjd4dzZOUkxpcW4z?=
 =?utf-8?B?VlVSZnhqcnlkczVGdDRwdTNvd2kyWWRFQzBqajQzWnQ4UWQrVjBQUU1ydUcz?=
 =?utf-8?B?Z3hSTTlCNVRpbmwzUXRqZnJuWk5ZQ1VFMEs3YWZIMDdtRjF3T0lmc3ZydkEz?=
 =?utf-8?B?OVF6aVRjNEVIRTRyWTZ4aWtIQmEyczNWcTVSNWlQNXNOZlBodWFPT0tXWHVP?=
 =?utf-8?B?V3ZjU2NJTlgyVlYrcEZDN2U1WjA4d0xUVTZLY0FVUnJVSmFZRDBwcmdXNFh3?=
 =?utf-8?B?OEVRMEdyczBneEd0Q2gyNkpyY2RMcUVOTTZvUnhhUzkxbUlKbmhEQWRmeDNY?=
 =?utf-8?B?T3gzUWxzT0dXTlVXcVNKNzhuUFdCT2w0R1BOaGMvbEVnc1JOc0tLWUMrTlhx?=
 =?utf-8?B?NXVNNXNPZzFoZEZxeVpvT1FqNWliVXp3MEJnYWd3ekdaU0l1clNCS0xZaXZ4?=
 =?utf-8?B?SkprTEEyMDJDN3BFaEdQN2xVbStoY1BpcFd6NjB6a053ZWxEeXdOOCtkV1E2?=
 =?utf-8?B?bEllcDAvTzBrdDJLbWF3c21oSTgxdWVXaEpwaU11cHBLREM5bFk0T2tiVWlN?=
 =?utf-8?B?MTByOGoyMWw3NjBJdnlPelNodi9GMHdpNElCT3hxL0tJeFNMa1FqUExhY3FE?=
 =?utf-8?B?RGpaWWJwYkZLT21lTTk3UThYbkEreFpsWkxISFF2QjlNakxhWnVuakJHemtl?=
 =?utf-8?B?c2t4ZGpIczRqUVNPdWFsMmh0VllpeDZQTE83QVJCV0l1aVlSNXFxNHZZdmZu?=
 =?utf-8?B?RS90UGNYb0V1WExMbTRWZ25Pd2xQdmlYRWNka202MzI3Vnk2emV6ZW1yN1JW?=
 =?utf-8?B?aGhTd3ZFNm5XcGhuM1RFdnhTNnN6VmtZN2ZxcWd2a0F0SU1JMXJ3ckI0M1dw?=
 =?utf-8?B?TmZxaHN2QkszcERZRGF2T1BwcVRiWlNNZEtnWW9kdE01eDRDWElvN1RUQ05p?=
 =?utf-8?B?RGJXSjVid0cwajdVWm9yUU9Ha3hQVVdkNlV0a0JsWmxCOWkveE5uaXJDUktY?=
 =?utf-8?B?OFM0S3NJWHUxd09jWUlGRnBiWjZYU1gwMUVIczFvQWJYNEVPdGNoeXFQSk9w?=
 =?utf-8?Q?iKe9nXh6i0iu96TlvPpMocIfp?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f955e0b-61be-47e2-3401-08da9674ff69
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:17:27.1647 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: InJVXHJfeu7sT4VKzdHR75F2C4umdHPKQQlTCHCzaM6RTgwTaSChBvtkX9SnkhcM4qfuof5zTdwxYMws0cGAHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4052
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v13 07/13] zonefs: allow non power of 2 zoned
 devices
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
Cc: "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "Johannes.Thumshirn@wdc.com" <Johannes.Thumshirn@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <10D92307C87A7146AC0BF8425E524B65@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/12/2022 1:21 AM, Pankaj Raghav wrote:
> The zone size shift variable is useful only if the zone sizes are known
> to be power of 2. Remove that variable and use generic helpers from
> block layer to calculate zone index in zonefs.
> 
> Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---


Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

