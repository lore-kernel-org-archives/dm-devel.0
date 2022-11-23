Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E512C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 22:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669244203;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VlEodMNSSr1RFTpbh505orVYjtrY3sPULerTjrahpQE=;
	b=FEvIjCQOgrfo2OsoJVXrUrVBcS5vo5WEB1omoDg00gkjw3g483ACxVtIViKdvGKpcFugg2
	QeFBi8AmQeiL26BoyYq/IIpipkPellyAtphI34oYKhwrO8c/lOJXki0wIQs3Kk8GAgN+pG
	pJdeEhEC1kfHiAXvHTd5bXnDKFidxDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-EzHxeEQqNgOWIcph1L1Xvg-1; Wed, 23 Nov 2022 17:56:40 -0500
X-MC-Unique: EzHxeEQqNgOWIcph1L1Xvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05656811E67;
	Wed, 23 Nov 2022 22:56:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EFEF200BA83;
	Wed, 23 Nov 2022 22:56:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDD3D1946589;
	Wed, 23 Nov 2022 22:56:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C01591946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 22:56:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD6E5111E414; Wed, 23 Nov 2022 22:56:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A574D111E413
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 22:56:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8236E101A528
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 22:56:33 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-Vw1xGmfCPIOTADcPI_icnw-1; Wed, 23 Nov 2022 17:56:26 -0500
X-MC-Unique: Vw1xGmfCPIOTADcPI_icnw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY5PR12MB6033.namprd12.prod.outlook.com (2603:10b6:930:2f::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 22:56:23 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::f02:bf13:2f64:43bc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::f02:bf13:2f64:43bc%7]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 22:56:23 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Thread-Topic: [PATCH v5 00/10] Implement copy offload support
Thread-Index: AQHY/wLEUhEocurOikWuV2dsph+j+a5NH5cA
Date: Wed, 23 Nov 2022 22:56:23 +0000
Message-ID: <cd772b6c-90ae-f2d1-b71c-5d43f10891bf@nvidia.com>
References: <CGME20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5@epcas5p2.samsung.com>
 <20221123055827.26996-1-nj.shetty@samsung.com>
In-Reply-To: <20221123055827.26996-1-nj.shetty@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CY5PR12MB6033:EE_
x-ms-office365-filtering-correlation-id: fd5d6bae-c707-423f-64d3-08dacda5f185
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BcTNfeNaGyCRY7FCma5ImA3PnmKcmpWaPpG0wGZYW90QcQ8qcVzzF0pbBI55wqv3rBgRzXUOT4VNWPhqWw7Vy5hgAkrjilo1sAH70q3JYD6gp8CyphvG6c1tYxURXty/noygTZuCdlHp1wYo0TNbNHCTUg+LFLeAXdTJEpLsQi5cTzs7dN8qxNk2dKroRN1XP9Vekvbf3XHBDc2ReeUsN04+TYWYxnFo2blCFeU8lWjrEdMZm3I5FeHV/YNAHSxZEPJAdr3818xGozT2angYYny11yFlmit+tNTZepAMEdRrXJi1yZyu6KJYei4osU5kJ9LUQR64m8jn9oR5kGhkJexqle3xB44PB/kwHpW47CsdXyWkCFgKiT6F9pMllZPfyfjFVBLvZXPXOZLKPfzrYYhckF4lUsdZuJrbSrTQgmksY8HnEh3vyMmNpA9AQ/Nluxx6Q/BksyGQSB1r91DE5g/bcyaYOtu64IhIoPCYEEQReTjDwvaGX9VnVifteytwZaTS1ciXLu63SXmXpAKO90yXCLwV2H65tDlm4TqafaA+Fk9mK3QyeRPa5/6AF95XuBmEkoj0XW3wa4G4EO4XL8r74r06OkeRSrfIDPVA7dWVZlK6wBzpaj4QaPyOpusyuCSHvP6xUUrsET3ZaI069w3rJCwKRNmR7Ug7734KFe+ivoen52ioDbhBZcqIt5bhUUSLlAfaLWsL9R86IjsJp69Vbld0kFw/AZRgNvaqNolYWeqAnLg0N+xjL51u/Tx1o7Jis/c+VoqenOP+RCnzRg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199015)(91956017)(38100700002)(36756003)(6486002)(86362001)(4326008)(66946007)(76116006)(478600001)(64756008)(8676002)(66556008)(41300700001)(66446008)(54906003)(6916009)(2616005)(186003)(2906002)(83380400001)(6512007)(316002)(71200400001)(6506007)(122000001)(66476007)(38070700005)(31696002)(53546011)(4744005)(31686004)(5660300002)(8936002)(7416002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVc3eDRIM1pEeEhuN082VkFVU3hMM0U5RDk2QThWdGkzemUydEp5Q1NzUzFT?=
 =?utf-8?B?YWNjS1Q2bmJQbFA3ZjIrUEx4Vlh4ZS9vOUUxVG9xelViR3VENGtTM041ZDdZ?=
 =?utf-8?B?U0RxZnhjRHU0VHp1QzFZaVlDYTRsVnN4VmU4aWQ1aUl1cXRuMENqNGppMWVh?=
 =?utf-8?B?K0JGc3d2cmc4Vkw2QTVZSFpBLzhYTFdwdVpRU0ZkZ3V5SER3YlpSbXVLNCtC?=
 =?utf-8?B?aVBpaGp4QmRVNkxWVDdHeC9jN2FnU1JJdzBpOW9RTTJ0RGUvKy9oOXFWRU4r?=
 =?utf-8?B?MXVCemF3YTMvWVVVaEM1SUFtRkxEeUJFd0xtK3JoeU5lMmJ0VTNNV3ZSOEpF?=
 =?utf-8?B?UnMzblMrblh1YW5aVlN1SExkSVhMWmpJQisyZXVCZWx0WXNlaGlMcUx3MmxX?=
 =?utf-8?B?Qjk0bzBiZytpSWNiTVpsZ2FxOXM2dkV4UzZyYnNEUlpvY2VPMnVHVzYyUnhI?=
 =?utf-8?B?aVdqcml0QmhKb1lld2s1d1l6Vmc3TFNPVXlYcmZDOC8yRXpHbS8rS3hQTC9S?=
 =?utf-8?B?NllHdXJtWktpWUp4dGlWK2FCUXRrU0t4MmtVR0hYM1dYYUFnZHBNMWRCT0dK?=
 =?utf-8?B?eXpVUFVjODQxTEtNS205b0NuckpMRGJtZXZ5UGhXMWUxckdLS1hDWEM4SlY1?=
 =?utf-8?B?Nk83Um9SaWVHZU9sRTRLT0JVK2NYMlZSYW5oYyt1SDRQQlNEUVdZRitteW82?=
 =?utf-8?B?azNKZmcyUE5oWWcybFcwcXNmUUJUUFdKTjlyMnpEVFdJYXFyV2p0K2RlelJ3?=
 =?utf-8?B?VVdxK2V1VzhDWjRONGNVSzFra0JoUlRQZGZja2NUaDdGSWFFYjdNdmNFY1cr?=
 =?utf-8?B?NHJua0htV1VGZlZNODVIKzNLTDVtSjVOdzlJWFFBVi9zbE5zN01xK0dUaUhj?=
 =?utf-8?B?ZnhHellWeU03UFJ1d2h6SVRVUUEvQy93dXFXMEpmT0UrWHY4Znp4N0U2S3dV?=
 =?utf-8?B?YnVJbjRMa091L1ZtVHc0M1FhRUtMYUVRMndsaXJzS1V0UERGV1NQZjl5RFFl?=
 =?utf-8?B?dVZsYjlUV1JBWmgxMDlaYXA5SlB5a3lSMmVDMmRmMnBiS0Y0QWx2TWE2bVhh?=
 =?utf-8?B?cmVLL0RlUUtrUVJhQmd2TjZ3ZE5CNFZxRGxsOGFkSXY4VTVONnhvSm1TS3BQ?=
 =?utf-8?B?ZWxlNUloeGpJTWxzWVJPYmlYYko0VDJVRmE0UDdTUXRQSGlSemZMWHJya0lK?=
 =?utf-8?B?NWNuNS9JTFdTelRHallZUG9nY21JckUrOGxjRGJFTm5CTDVPSzJRdytHUmRq?=
 =?utf-8?B?S3J1aUJPNTJUSTNRUjRqS0R4a0Y3NE5oRUZObDNJTGk1VUJnSmZGVytBb1RM?=
 =?utf-8?B?MktoYlZtbTlsZjFxaXp0ODdhZ1kySWsyaTdObzh4aGlXYWYxVUwzVUd3Q1JS?=
 =?utf-8?B?bEh2Q093eVlZV3N1ajBNRllpbFZRZy9RcWZSQlIwUWhJUmVNN2EvTmZ0YWxS?=
 =?utf-8?B?L3VUQjNtcXBINWx2NTFhWG52OU1NL3N4MFgxSWpzN1dqKzNCNmM5VmkxVGZH?=
 =?utf-8?B?eXpseVB2VFBjd3FwbFlSclNiYUZXSTQzNForWTU5eGVyRkxTMG1MT0FuQkhN?=
 =?utf-8?B?RHJNeXFaMm5uYkVkZWZXT1FnR2xGajU3dldtV3lGUFB1QTZvM1l2eHFqL2o3?=
 =?utf-8?B?VjBmdms3Ui9xU1NBcWVsUmRQRWUwbzVwbjhhSzY3S2QwZnpMQXUwdTZubDcw?=
 =?utf-8?B?eXd3QTRTVFcxc2h5SGROWFFDRlFRZjNhOUdqbDB0NndyOEVSaEQxUTVnQVlp?=
 =?utf-8?B?SkZEVmhjMXAxT2J6Vy9mdG1oeFZ4MXZKdmF4bmpod29oMGx1VTN2Mlgrd1FF?=
 =?utf-8?B?KzFCSlgrSmJLWFc3RUFWUkpxMjlRQ3l4bFZhYld1UXRCeFBtQnN3U1dtdmZt?=
 =?utf-8?B?aUF0czdGeDdFRlZOeXF0eTMvRkYrbzlRTVZwQjlrYmpNcHdoU1ZaVUJvWkEy?=
 =?utf-8?B?N005MGlEK0Z6dWdjZkxUM3ljMVczSDFuSFAxMDYxMHdjcnN2WklKczhmVzJN?=
 =?utf-8?B?UzZFQlgxbDZ1QWpRRjY1Z3dzL25UblFrR0Z0aEhuWjBodG42aWJnVldoeW0v?=
 =?utf-8?B?Nzh6Z090c1dhVlN1WXhMUFU1UG5MRnE0Zm41QUR3WWYyN0YraExKVjZ3NDhu?=
 =?utf-8?B?YXRzU0E1NDFMZFErajJFQ3hrRHlVeVhmQVB5UmVBOHM5THBTQllyUEhCaVFw?=
 =?utf-8?B?amc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5d6bae-c707-423f-64d3-08dacda5f185
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 22:56:23.1539 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tdLNY1HocNbd1GhZ2pHzlefYRYL6R6hljE7MiwoYwdgZkKY06hkE5xEGe4JxF42wj7NvU/4Kbv4Bi9xl3XH0Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6033
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v5 00/10] Implement copy offload support
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
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>,
 "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,
 "sagi@grimberg.me" <sagi@grimberg.me>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 "james.smart@broadcom.com" <james.smart@broadcom.com>,
 "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
 "p.raghav@samsung.com" <p.raghav@samsung.com>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
 "kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "jth@kernel.org" <jth@kernel.org>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <11DE156DC86B9F40A76435524E1C3AFE@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

(+ Shinichiro)

On 11/22/22 21:58, Nitesh Shetty wrote:
> The patch series covers the points discussed in November 2021 virtual
> call [LSF/MM/BFP TOPIC] Storage: Copy Offload [0].
> We have covered the initial agreed requirements in this patchset and
> further additional features suggested by community.
> Patchset borrows Mikulas's token based approach for 2 bdev
> implementation.
> 
> This is on top of our previous patchset v4[1].

Now that series is converging, since patch-series touches
drivers and key components in the block layer you need accompany
the patch-series with the blktests to cover the corner cases in the
drivers which supports this operations, as I mentioned this in the
call last year....

If you need any help with that feel free to send an email to linux-block
and CC me or Shinichiro (added in CC )...

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

