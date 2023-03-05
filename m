Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9202C61DA4
	for <dm-devel@archiver.kernel.org>; Sun,  5 Mar 2023 21:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678051600;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f5Llpg5WvEags0Cm5belrf6jd9KwVFnb6/xY6K43p90=;
	b=DU1XtgGjojvZIL6exXQB1MI+855PTl5W7XzQ1k/LoxOvbEWuF4cZMEXvugNguT+pl/tt8Z
	ucFh0tKgCpeQ14atvFdj0C2i3ySOST9+jJaSkJVVBANaqUj1H+1QnpxYwiqpWZ4U/uXEdS
	KZX/j7btDWDIdMgq5prSiOVH2UXoDxg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-NvGaT27_N3SK51UtxWtEjg-1; Sun, 05 Mar 2023 16:26:38 -0500
X-MC-Unique: NvGaT27_N3SK51UtxWtEjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CDE429AB3E4;
	Sun,  5 Mar 2023 21:26:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7FAE24035713;
	Sun,  5 Mar 2023 21:26:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 298D11946588;
	Sun,  5 Mar 2023 21:26:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1ED571946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Mar 2023 21:26:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F2264492B00; Sun,  5 Mar 2023 21:26:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E9A53492C3E
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 21:26:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2C463C00088
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 21:26:31 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-lMJzRnBdNsepkTLQw0yT2Q-1; Sun, 05 Mar 2023 16:26:29 -0500
X-MC-Unique: lMJzRnBdNsepkTLQw0yT2Q-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sun, 5 Mar
 2023 21:26:27 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Sun, 5 Mar 2023
 21:26:26 +0000
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
Thread-Topic: [PATCH v4 07/18] nvme: Fix reservation status related structs
Thread-Index: AQHZSHgaeFqAy/2h+E2H8v5iQqIgd67swVoA
Date: Sun, 5 Mar 2023 21:26:26 +0000
Message-ID: <20f34709-0a44-5e14-2be5-f4aa7da24cab@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-8-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-8-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7864:EE_
x-ms-office365-filtering-correlation-id: a96c306a-7842-4cd2-5ddf-08db1dc046f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ZJS4+msYfNJdo90W6ilRTHv9Y3X1qxvEx3cdDdW0WhzE+eDG0TMUnpeq9GrU0siIHcmwbuio1uqVAdYkoI1Z6NFaWSoGt62vC7VnFavvm66ieYIYmmQJYEZC6l5b/fqD4KXeW1ARHMEyp0FIAK8knJMySOwe4aQ1v47thipFDNzIEu8FXioCcYzNJjcHvwq/hTh+04KG8OV6DAA1dqhlDbrLtxYmWTMar0PnAbgqg+7v0OzB0Ww5V2ki1H4j/IYBmQkNMszxENiBOhWruE41YrLRzKBb6OgoGQ9yGJ/9/RHwTLr0qglAV6Ib04icdOotIBuKYR4Prb0kWcBSH1jnIJl1AftRsvAROdDvKtFirWG+StyJNR/2nS2NVX9+J6HjpgDaDg+DkwBAoBNGv+mGGF6C1CXCYrXbrH9IYsC+gu1zUp4sJeHyF0/+Jamts6aZol+MOHvQftV9dW8qWbP7Wt3Aluw2uxRl8rzJf/Y3qsqGtVvBYH7pwV4PfNc/O2iaY/ylM/+0wQo7iW9ivhWfwLTvkY4dKzj2+HvDeJ6W2PvZD56Yt1MyVt6CG7vLYVbex1ggFyrrMcMIh6fFfaxw/h/hZVdYZljzw6E0pcBWILtkZ1seD+S6X4VGBtyBoAOGpvvdjjbrTyR6PTW9PnZ/mghUm+s0TgDPEIR7zMhB5qJOheuXu/OsXAfptzXidGkUfxIzsxeahOUYUahN41h/Vy2p+pzOQvDL3PNmsMUyWzoEU2gSPtsQw90+qnNBqJWEuX0QYLAiKT/mPPcHJ1U9Zg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(186003)(71200400001)(6486002)(38100700002)(478600001)(91956017)(66946007)(110136005)(64756008)(76116006)(66476007)(66556008)(66446008)(8676002)(53546011)(2616005)(31686004)(316002)(6512007)(6506007)(41300700001)(8936002)(7416002)(5660300002)(4744005)(122000001)(2906002)(921005)(31696002)(86362001)(38070700005)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlFXQUV1NmNwdGhPQk10YmR1SFVlcU84QkpsWUtKczJ1TzU2Z2xjRUd1ODFo?=
 =?utf-8?B?aWV6ZEV5L2NUR1ovY0VLZ3dRK01hc2tnbjZURE9zMW5GZHV0QURjSXk1YzBH?=
 =?utf-8?B?VGdvbHlsRHV3ekRRWFJ2aFdZRmZmNTVKYVhYdG55Q3NlVUFlWVArcWl5U3R3?=
 =?utf-8?B?ZDQxTWpOb2VoUVplSXZwWksySjIwU1Z2WTRGck8va09VMDFNUkFpZW1tUWR1?=
 =?utf-8?B?SWhQNHpJM3BscEl5NHpGaGtBTzR2UUY1UnRnQ0xpTEhrRC9VYzVaZVFaM0VN?=
 =?utf-8?B?MmZPYWNIR0VOOHQ1eTNLbWNvRysyY1JUL3FGMjNRL1VVWDdRTDc2VE94TDBK?=
 =?utf-8?B?QkNWT3BndlpFVW56VmJwOCtYQzZNUUp0WGkzM1JjUElkTVVOSW1CZjJjN3Ay?=
 =?utf-8?B?bmM2MXlaREp0bnZyQy94ZXh0RHJyNDdYQWZXR0F5L2VEcHBMVTVheDQxVFRF?=
 =?utf-8?B?Y2daNnNpd2huYnRaUDZwVTI3R1pRQTNjaTRzN3o2UjNiU2dYOGpJR2h3UjR5?=
 =?utf-8?B?b3V2aTFzTGNXTGxBSjQ4ajJDYjg4SXJUSUE0L0ZoaVhzaEsrQ29aQkhSQWRo?=
 =?utf-8?B?MU0rRGhNMEpDZk5SQU9jeXFrNmZJNjJlZGhPZGNndHZwa1ZjV21yNFFid2JR?=
 =?utf-8?B?NC9RaS93Q0NpcnhLUWRLRjRMcDhSbnlhOHFKTUpuNWc1Q0V0Y3N4RVZHellC?=
 =?utf-8?B?NmpBZWM4WXNOOWZISS94RmdZazdJWkVVZS9tZmJHMERkQmdWL0hESzMyQkhL?=
 =?utf-8?B?T1lBUnA3aGZmN2dvcStQUk8vS1VyQ0N5SkR3MnZSMFZNMDdnM2xFMUZTNFpC?=
 =?utf-8?B?UnpXNFgzK2hMWFVGUE50RE55L0VvR1VCZ25zNnl5cmZucThZbm9YS3hTQ0wx?=
 =?utf-8?B?SDRSRnVvYXp5NGV1eThvMUNKRjhhZzhaUVRudUY1SGFxL2RkczVzeGxiQkFC?=
 =?utf-8?B?VEI1ZDBhYnpYWUVWa05yMTVISTFBR2tGd2N6dGtMcGJnbmYxaHc5dlRqVmhG?=
 =?utf-8?B?a3JJajBSSXRzbG45SERlZm9jWGVtMUc0T1NSOTFGSzFLS0F4b1lQa21nUmtY?=
 =?utf-8?B?MjZFbEQ4djFwTFdKUzNsTmlNcjBCTm8rZFg1V0ZmSEhvbXVVQVlNbXg5YnNV?=
 =?utf-8?B?TlV3d01nZHZ1Vnd5SkRWVERzcXBpMmVPaCtDMmFCWXdlRW4rRVRScDFrVlhP?=
 =?utf-8?B?RnlQRVhPWHo1T1c3Wnl2TWRJcXQ5akJiVTZ3cDE0U3AvTGtJZi8rS0d1aU5T?=
 =?utf-8?B?U2cvWDBIaVFqd1VYTVVGK21hcHdKVG9mYnJpaGtHVU9ON3h6NDRmMnhUS3NG?=
 =?utf-8?B?enZJeU1qclM4M05VYXNSVFRvZUNTR1o3TkQyN3dzOHV0ZFY4ZVVpcjl6TkNQ?=
 =?utf-8?B?S21VM0MzbnhCUjFWdks1VkkzZGNBVHFlQ3ZMV0dHNjdUQmpkandsaHFmOFdp?=
 =?utf-8?B?c3AxejhVckJWcGlRYmhwOVhydzl4YnVEVVNPS0RUMThpdGRPRDFORmxqY1FZ?=
 =?utf-8?B?RVE1MCtwQ0R6d3Y5eFJjcVM1aTJTdGhqc29Pa09pSkp1QTJGNFpZU1N3VWlJ?=
 =?utf-8?B?dm8vVGdGdkYvK2pvQXBqY0IzMWZXR0dQVFVxaGNOZE1lWEMrU2Vrdzd4UG1I?=
 =?utf-8?B?ZzFQalFyVVg2UzliZW1ZUTVNa2FHN29UakVJMVdlNkFxbkxpcHZCQmV6Q3I4?=
 =?utf-8?B?KzNzcm5WdVlubW5jWUNGbTJiQUxDUmJDYmZvOFFHdkljN3FwZUNDalhYTTFI?=
 =?utf-8?B?NlpBdTllNm5Iam1UT3ZIRlVUbjN4cEFxZTNTVzUzUGJ3eUFNaGJSNmlSRUsw?=
 =?utf-8?B?UVJuSlpDRXovbkVaVDVTMk51OWFhbnlhaHFaSmhBalQ2MUxCSncxWC9oTlE1?=
 =?utf-8?B?Qjk5MUJBMFE2amdHN2R1VlRFUzF0aDd1YzFyTkNIb1RVSWJzODdqM3piZjBs?=
 =?utf-8?B?VmIzZEI4T2E1clRmeFJkYkJMbFh1TUZHK001a1k4ajlyaDRWdGRMY3dJbUxB?=
 =?utf-8?B?RnBCazdQQjdnTFd3Zk90ajZhZUg3MkZjMEcwQ2JKY05rMFd3M2gyTWZDVFc0?=
 =?utf-8?B?bVJZcEIrRDcrV3Z5Z3B6ODQwU0xQdmNZQmEzQnA4MlpoVDBQUVlmOGs2RUpG?=
 =?utf-8?B?YWgvM2E3T0JybHpVWDA2VUE1OFNOaGZiTUw2b0h3Y3RJOTdCTW42bnFVUVp1?=
 =?utf-8?Q?/mXAEl/KjWkNxq4bf5c1duv5GrQFGD7c851Mq1dYBdv6?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96c306a-7842-4cd2-5ddf-08db1dc046f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2023 21:26:26.4025 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjH7+ZvEKFKuCTBnaC7+lkVyhWi/2DFqeSjDGSKr02TFjxLmwJQu+qPiMZPRxRPo3E+mWaIxHPjpyHIIIQAmyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v4 07/18] nvme: Fix reservation status
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9795C1DFB7905F468E6A0C799D934CFA@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/2023 9:44 AM, Mike Christie wrote:
> This fixes the following issues with the reservation status structs:
> 
> 1. resv10 is bytes 23:10 so it should be 14 bytes.
> 2. regctl_ds only supports 64 bit host IDs.
> 
> These are not currently used, but will be in this patchset which adds
> support for the reservation report command.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

