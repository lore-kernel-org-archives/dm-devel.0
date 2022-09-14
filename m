Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B54ECAAD3
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 17:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663175885;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x9/6YCFwBrbxyNmK8jTUZU9MZv+Cl28bQl8EZv0U1CE=;
	b=d8130+Em7DqeI9JrX+rUMSRz441twNzHNDPhTbvmVobTr826/II74RBdfzQg7Mk7Yw8d73
	JWXTg2JvNfKQU7Imrszs/w0CfioYHNjhlYMfcyIVL5K8kazw6wRd8KJCJyV7DOcP0J14L2
	qs3Afu6HDcax1qTgCImr5AF2ZWKJGFo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-yFf8ALwfMBGDAa7lphLrbQ-1; Wed, 14 Sep 2022 13:18:02 -0400
X-MC-Unique: yFf8ALwfMBGDAa7lphLrbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1607C101A528;
	Wed, 14 Sep 2022 17:18:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F387A2166B26;
	Wed, 14 Sep 2022 17:17:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE3971946A57;
	Wed, 14 Sep 2022 17:17:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B83171946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 17:17:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ADCCA49BB61; Wed, 14 Sep 2022 17:17:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A945849BB60
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:17:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BE8938149AB
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:17:58 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-qpJ-ChzTM-efEajoVKC7Vw-2; Wed, 14 Sep 2022 13:17:55 -0400
X-MC-Unique: qpJ-ChzTM-efEajoVKC7Vw-2
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4052.namprd12.prod.outlook.com (2603:10b6:a03:209::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 17:17:52 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 17:17:52 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 06/13] null_blk: allow zoned devices with non
 power-of-2 zone sizes
Thread-Index: AQHYxoDljeMHl4DWM0+B1R9OJeeu1q3fLtUA
Date: Wed, 14 Sep 2022 17:17:52 +0000
Message-ID: <516fff59-8465-f36e-1399-e08b22e340af@nvidia.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082212eucas1p1032064dd2ac1638d7d18be7e6fe5344e@eucas1p1.samsung.com>
 <20220912082204.51189-7-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-7-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4052:EE_
x-ms-office365-filtering-correlation-id: 6aceb55b-160d-4713-0972-08da96750eaf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XexZQC5MhL3jwgno5hJrUDctY88JAD82C8TEaiEpx6ZcfJZRvatQK8vsPM33gtxNOXdldtYT/3Sbp2iHZDbVxkaK93FelWjYrfxx+LAb3Ov5Du07pxfUTWUipVSYodJF8TbvG+Jgn+F3We4FI23TJ0Fje+7fjlClzo+QsSgEKSfwcqYcY18eelmc9PLdidzIqsKLdHhYjEZWY2Tao4crPj+iwBsEjgrt5peFS+Vn8w0uuYmgT3HJbnDSOzD9HTdMaECDsh6ACZIGohA60m+u4XoI+RygaLTLmbMMD+IwayVMwKtWzgxUVCMTNPyOvRsgeTNy6gKySEGcFq+U5MxRSehxTtc705DjdODKZPAp4/XsN0i5vpPNEFzNNlSmTaWgWucN1nHvHaRPge4lzRQPrBv1bZalzQNCDAZdZWGOofJkA40kwOnTimfXxD1ztR90rkHzn+HBN1L9htZ2D/etNVU4lhGUOCN8YITeXrUqDE0TN7B0c0FXOYTD03//RxQVxGMPHcueKjfX0vNF0Tdkq262r3HRPhvtcfj0Lyp8ntML96UFZnhF+nSTRj5nMJ8fQVVqJBWujtrk0YlAcS7tL4qBFq31qvyeftcxgRk4H2prmBgWlkTKx/8Or6pHb1Q6XFnr//ccB+b7MMk9jtjGj6Vz+Z75xkRnAzTTW8exhkDcJWn+4Lau1/Fdov7WNfCEG3/FeXoGtn7in+m+jJyrLvZBRn/4B4lNp877pNUlrGMFRGjuO2i9fAB8gWEOraycG7feVrkQB6lvO3W7uqxMrcRevr3hfLud7wDGbpX+TYiW3jszPpBxiRuUQNUbVp38p5T4pTD/VI24co+aWYzkYQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(8936002)(71200400001)(110136005)(6512007)(38100700002)(8676002)(26005)(31696002)(38070700005)(478600001)(66946007)(6506007)(4326008)(86362001)(7416002)(66476007)(66446008)(64756008)(186003)(76116006)(66556008)(6486002)(53546011)(5660300002)(91956017)(2616005)(4744005)(54906003)(36756003)(122000001)(31686004)(2906002)(316002)(41300700001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkVMZVV1RUJnUDJ1Wkg3R1NSV3JyVjdwVHFFUmxTTFc1QVlMbVdYdFkxSWVQ?=
 =?utf-8?B?Uy95MjdEa2swLytJcnpYbzZSNTR1NFhUeGZYT211SGdaNkY1b2pWQ3FxM2Zt?=
 =?utf-8?B?cjlBeUVWaFpyZUFQaVUzOUJORkl2ejRiRnlXbWQrZEVFSEd0MVZZY3FJdkY3?=
 =?utf-8?B?RVN6L3A1b0M3L01OSzRtU1NsUEloQjE4bkxGTGFMb01pY1ZMajJWTU10Z0Yy?=
 =?utf-8?B?enZLbzBmYTMraHplSklHUnNKV3hvZDRzTjdYbWI4N0V4NWlpaU1qSGVPZXRi?=
 =?utf-8?B?Nk5lVXkvZDk4cTlpU0psUlF4azllUTNOREltQnRuUVRaVGcyWEpZSDV3QnJY?=
 =?utf-8?B?QUc5YlE5cDJodzVnSzYxTVVOR1JFNS9WUXRjZTlMOG5TMFhMOXFIR20yOVhV?=
 =?utf-8?B?TEpKVXZ3MmlKc3M0TVpMQ21NSEZiYXlSdStBazYvN0FDWENGOFpzN3VDMnpv?=
 =?utf-8?B?WE96TWxKN1FsWVNEZmdnSnpsN3RxbjZEdWdNUHpKQmZwcFlGOGxDcnlUUWRP?=
 =?utf-8?B?Y2tUd3lmWnA3ZVhwNGdtc291czM0WG9uNlBwdUVhcnZraXdEdWlMcHVHcVJn?=
 =?utf-8?B?ZWNybzBLZS8rby9FUjk2TUVCVktKU3BRV1lHaFVIaWJGZmJCWmtJYW5BMWF1?=
 =?utf-8?B?Q09vNXRsdE9IdUp1RXY3Q3FYWW5QUW5tVUw0amdFZnlHR1JrUGtacUVFYkVI?=
 =?utf-8?B?RVp4emxPV2FMb05pMjU1NERjd25IcjR4SUZNSlBzL2Z0QnlJTHJXRnhZVVhq?=
 =?utf-8?B?UEU0N0lSOVRTM1dOeE1TNmlqMHByV0tlbU5uWUR4bS9VT0dnaUdodmEvL01I?=
 =?utf-8?B?MTU2Q2hSVENqMmhQYlNOYjdydENEaC9vWVMrS1RSaVlQQjFsNk9TUkdpNGdz?=
 =?utf-8?B?Q0pMRHM2SWo3bitZWEg0bjUyRjZtVURLcFpCLzErdStFWUQxc1hHUjZaWFNk?=
 =?utf-8?B?SjRyYnNzZkt5a1JDZGVqQjNzVi9Yb1ZqWktmUUJjVU1mOVVjSzJpTG5wYy9M?=
 =?utf-8?B?VFZhQ2l4eUg5RHRjVkU0YUJYa0p4dHBFV3ZZUG1nQTF4NDNlN1lKdHFDOUFZ?=
 =?utf-8?B?dHZVd0R0ZWdZY1ArMzkwL3B1TlZ2aWMyY2ZscmplWlFKUFhkK0hSMUU5eVdY?=
 =?utf-8?B?a2xDWkxMeFh0TXl2QkI2ZzRpS1RGamFKaVFQQkk2OGtiaGxxVGxCb3J0bXhX?=
 =?utf-8?B?emc4MGNOMGt2NTloazBKaEpaRDBkWkM5Vk4wZE9LVm9EVUthUVM5MytialJ1?=
 =?utf-8?B?b2tnd05FMk1pYU9FNEJMSkFlRitRV1I0aElYcDV5N3Z6S1YzZ2FkOEZmYmZL?=
 =?utf-8?B?VDg5ZkpVWW9OT1ZOTzROb21weEpYR3R2WURKOSsxRGJMckJuVUxNSE1aK3RS?=
 =?utf-8?B?dXV2VGR4SmhUOG9kelZFK3NvZHdXTkszYlJYZi9VcGhaMmd6VmdxU1IwV3gy?=
 =?utf-8?B?KzJCNzR6SkZCM2h4REtpcjA2TnNjcmY3enIyR0FUeGdEM0c3L0dKV04xZjJ6?=
 =?utf-8?B?NDVCV3l2TWhaelk3Ui95a1ZGYS9VUlhBaGVva3ZrQjlMcStZK20yZGhUY0V0?=
 =?utf-8?B?YS9QQXRPdS9QVWxpZ1liZmN5Vnc3VHpUNGVlTVQzU0VybkFOZWR3bnhnQXlw?=
 =?utf-8?B?SitoZGpWVXZtVDlIdVRBS1NJc3RQdmN0WUVwS2RzdUZkTVN4NktseCsreHE5?=
 =?utf-8?B?TU93cFVvaUhqaTVHQ1FTL0xmTXRxbm1vMk1WSVVqZWF2VG1LVjJEWEgxMEJR?=
 =?utf-8?B?TU4xcHJvWGJJR2gxdnlKK2g4bm11eWdPSFQ0QkJ0b1BYcUt0WHd2cldEZHpH?=
 =?utf-8?B?dTQrVE9aRUVaajVPWDJIeFJQMDh4dWdwSU5uOThUb3VmY2JPM2xGbHVXVFFh?=
 =?utf-8?B?bVVQaHdZTXk4N2Fha2txWkJVNGxCc1V6M3VRRlBiNnRzQWg4cjFNanMyMks4?=
 =?utf-8?B?QVJjRGFUYStvOVFIaVRQcDVmc09IY0RObFB0Qk9OWkJIYzlrMnJKQlRZM1Zm?=
 =?utf-8?B?Tko4SWU2NHU2TmFPMVpwN2NLelJFak5XdHNWSUhPOWZmM3YydUJuZmRSTWZM?=
 =?utf-8?B?dm81Y0gwK0tNMlJLTFBLaDFPYy9DcklDZmJSQ2s2UWlqNHBOQlpiZ0pnZGh6?=
 =?utf-8?Q?SB/hCgLYewUFLVGQk4UNBtXGT?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aceb55b-160d-4713-0972-08da96750eaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:17:52.7570 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DU1UWSe/FbGpDcE91wJxvfLyimaNj31RDtFfxHH/I2rHxKPkTTcs7hmTpO6cuZOysmfgVIna2U41bcBUDUhJ1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4052
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v13 06/13] null_blk: allow zoned devices with
 non power-of-2 zone sizes
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <905C81B2EA36A647A43E1AE39E595122@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/12/2022 1:21 AM, Pankaj Raghav wrote:
> Convert the power-of-2(po2) based calculation with zone size to be generic
> in null_zone_no with optimization for po2 zone sizes.
> 
> The nr_zones calculation in null_init_zoned_dev has been replaced with a
> division without special handling for po2 zone sizes as this function is
> called only during the initialization and will not be invoked in the hot
> path.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>


Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

