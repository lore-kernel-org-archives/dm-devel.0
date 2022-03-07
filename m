Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A43C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 05:51:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-fU4N5tedOQK4uYd_yq2gYw-1; Mon, 07 Mar 2022 00:51:49 -0500
X-MC-Unique: fU4N5tedOQK4uYd_yq2gYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F8E180231F;
	Mon,  7 Mar 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2867B40D296B;
	Mon,  7 Mar 2022 05:51:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D125B1931BFF;
	Mon,  7 Mar 2022 05:51:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 80A0E194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 03:06:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6FAC240C1247; Mon,  7 Mar 2022 03:06:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69274400C849
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:06:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 362871C068C4
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:06:45 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-LS7YcDNwPUigtJy9dJh5BA-1; Sun, 06 Mar 2022 22:06:43 -0500
X-MC-Unique: LS7YcDNwPUigtJy9dJh5BA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:06:40 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:06:40 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 10/10] block: remove bio_devname
Thread-Index: AQHYL/Ha4HPZ3y8yxUiDBfSUyy/AWayvg76AgAO9GQA=
Date: Mon, 7 Mar 2022 03:06:40 +0000
Message-ID: <044fed10-52ad-1409-b73a-2062f4b93771@nvidia.com>
References: <20220304180105.409765-1-hch@lst.de>
 <20220304180105.409765-11-hch@lst.de>
In-Reply-To: <20220304180105.409765-11-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f345977b-4a84-45e4-2d79-08d9ffe78053
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB1853D0F7A1124201245AE166A3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XMUaTTvcCiaLlJYf+x3xRBken034PEOPBEBvMJYECNuiDR7ML6DaOuwOyZCgMcTYFLF+o1Wb0kRicowfv3+gGcAfZyLuMS+/tGZW7ShXH3/gc9FujAtRMG+FAYVGGFOUPmCxjQB4H32h5GYm4pHVNBvY3h8f/6xkn9f8Ar33aJqWnrK2mdpoD5XpUOYM4D7ovxaqWgIRuL2uXTLqt99oSR88rhJo6yiUsSxPxf/J2Qzj85irBc9AxpFotacK5hQp8d5ta3mGvwHx4F1FQD9TRQYHNe0FUV1WZtX/XSFacJa6aZjSxyirBY+wQSXOfEiMLVRyO1GCIyunCH6iZ4gOsHBihtlNu+6B2gPIjbZi/Uyvew8Oe+m/GKikzcgwjCarFqeY6F685i0DukJlGGt9/rTJNuPf2te5npDon9jbp7C1D3Le0RnPKZsGnHh0/rzdnh+1lSsIKU69sSZriaNLeRd4ov8HxlpJEtFrS6WUEU+2wnujdYKHNe0bJXxHtyqpiyjuLJUQFoq4UL5i6su8x7r8RB+3cAy3TMgnAm6aS1Jr9w42fdDiicVqSCIo+pIe0e84743nr6dZpZCOtl3U4wIPeXFLHNndu5ez6V03wpwkOvgB1rZ4qjuMelECwqyo1+SHv3D8hGrh8CrO/3H3cdAQTTDmOl66DfLXTey5R9X0LiJMIxDTEMjkChra7NYGdbN1CkkDJqI4ttd3JEi8207dcV/fClygA2iVeYhiADtskIfAXsjU7vu5w4m0SxkqBzVHYA2M5fWJTqLdohxoUQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(186003)(5660300002)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(558084003)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUlhV0JrVEZ5YW5GeW8rSXZPbWY4WGtWQlgxSCsxb21oYUM0UHF3NGdiWmp1?=
 =?utf-8?B?WnpBSUxxMkVXQ1FRM1MrK1QzMDIwekt0VlFsNUNQTmtBOVJxOXd6S1pYTWN5?=
 =?utf-8?B?NDVtRDBUTXR0RnBGV1NQTk5NdzVQVExyWlBwOGdVV3QwYzI3dllkK0RVVnNx?=
 =?utf-8?B?V2RiMldBNm1hUVhtZFJiY0ZyUHdQN2NwV0VUdUFEVk9SRHdWRjB3T2pTV256?=
 =?utf-8?B?OG1CdW1YT2xUODNRWklsQ1NtVFl4SFVNTW9BMW1hcE1VRnE4Yzl3M1lPYm1H?=
 =?utf-8?B?RjdIZDVZaUgyeFIrRjQ1Mk9NblNIWFl1RTltc1RQUDBjRndNZSs0eVUwdXBI?=
 =?utf-8?B?RzU5Q3JGY29ZUGl0YlZkaEUvcHIzQlJjelNydGordDJrMlNiL3VLK1V4MGNn?=
 =?utf-8?B?d1F2M0JmaEtVLzZqYnNVcm5GckxHUGh2dnFacitRSTF2cmpCd2dINUdlTVhB?=
 =?utf-8?B?SHVvbE5zUGpJL1dqRWo5WG9BWDlWa25QNWRzUXlNOFJ6YTRIOVpSdlhDYTF4?=
 =?utf-8?B?TjFLNDJ6Z0FIVHlvWGs3d0N3UGRNVVl3a1hTUGxhb2diSyt5TUtoSTMzYWlH?=
 =?utf-8?B?NjhxR2s0alMrRFl5eHk3S1hjKyt3Ry9SYzRSTTRsVG8wbGxuSGJ5djdUdVVM?=
 =?utf-8?B?MEJWMjEycGR1Y1NxanlwNzVyU3RoUnhuSXRLbXE3SmpCOExBb2RyWmVOU081?=
 =?utf-8?B?Zkc3KzZ2TW9peXhDazBTTldaV2ZHZjRKNFBLV0g5T1NVaERGSlpqYTFuSnJP?=
 =?utf-8?B?TEZKd2F0V2RVU3ZmWFUzYzZQVDh5SzRLY291RHBjdFpTT2RZR3l4OWoraVox?=
 =?utf-8?B?WW4rQ09XaG9ZT1oyRWdjMVcvS2M2WmlPVE0vV1lDUnQrait5UjBYYk1aU09F?=
 =?utf-8?B?TW5IYWU4VndDQTJtcW0zSXp4cHFPQVJqa0VNSkl4Tm9ScVhZNUJZa2YvL1d2?=
 =?utf-8?B?dEh6b3FLOExNdkY5NTdtNUpFWmhjUzF1NEtCSDFTeDA5QTFWUUZicEJNOUs3?=
 =?utf-8?B?WHBQOHhHTTRJbThkZnBpOEltbjZpSWRMNHdoSXBIZ1laRFFYYlZoajJ3UDFp?=
 =?utf-8?B?NytPMDdwaUpFcnFzeWlRYXV2YWxmTnoydVc2bnpKYUZ5OXViYkhMZko1QXZw?=
 =?utf-8?B?VE5rOGNJWE54NHZwWTVBaWRkZlhkbi9aSXRhYm9CT2dMY0tmdXgvUkErL1dS?=
 =?utf-8?B?ejJ5QUtDcTc2d3k4RGhGdFlsSjlLUHdVNXZOWndrQUJXc2h5N0VVL0JJU2dQ?=
 =?utf-8?B?RVh6Zy9XUStnOTFwUzc2dWo0S3MzeTB0bTlBWGgwV3pteWZwM0R2UzFCN3Rk?=
 =?utf-8?B?WkRkdHZRdGM2aWhLdStKMXpwSEh5U0hib0U0ckF3L2hVR3dYOU1mdmpGSWpp?=
 =?utf-8?B?YlJiUGdyR3E0Q0ZldnlhQ2IzM012Nk5kTEw2c3RsN1A0WU5kSitrdGh3eER5?=
 =?utf-8?B?aW1iY3VTbVppNHVsdnNoRGVmU1Y2dHo5YjNvUm5pU3JZR3VGZVUva3hGUHJP?=
 =?utf-8?B?VWVpVWtRd3FlQjZTUFBmUUVIbXNFb1RxTXRWbS8xUFFFNU5pRTlBNmczZXMx?=
 =?utf-8?B?YXdaNUxFNFZvK2NJTWlZOUdBZ3VySUk5MFBzYTUrQ2RTazBOZ0prT0hVbjFP?=
 =?utf-8?B?Zitlc29GZXo4QXNyT3dhVVZ4SHlSZWRPM1lQQnFWeGQ4UHFsVzJSalFPRHNu?=
 =?utf-8?B?NFE2N05NVU5CL2hGWlgwRVUwSVd5ek1VOWhyQ0NVRFJVdFFZRGVUVU15RHBr?=
 =?utf-8?B?TVU0dkNic0JuYm0vbmsyRUpvVkNQZHo0OHRRWWFwclo5RUllam0rL0toWXd5?=
 =?utf-8?B?QnpZeXpWakNWWHRwZThuNkx2MllJKytnelU0bjFQUS8ybGRRK3lnRG9kZStT?=
 =?utf-8?B?R202Z0hWV1h0Vnd3bFM2ckFoNEpycnN4SUR0VTlhMmxjQlhWamE3WW5aVXRE?=
 =?utf-8?B?SFFXVnBsWDFCeWdxSlV5cmh4ZlZpZ2V5VjVVRWJOT1dKLy9aalVzei9PcUth?=
 =?utf-8?B?cmMvSkM5SldOSm9lYkE0QU5HNVMxeWwxbG1TMjlVRVVjbGs1NW11Vk5PVjBV?=
 =?utf-8?B?NWxZSDNTYW1hMGVJQ0VyRENxN1JoQlRDckRLak9Jazh4d1Z5MFlRZzdQNEYz?=
 =?utf-8?B?Z2ZiTWg4QVkvams5dGNnUkdxQWt4Z29uR0ZSemYxNnREWGhVdFROa1lYNkIw?=
 =?utf-8?B?ZElLWGZLckVwMnNjN1hveVlRZGVNTW9lcHUzeU9PZ2dabFd4SXRyMHlSRVds?=
 =?utf-8?B?VGRES1ZtVnVBT1FsUjlTQVcwYnNBPT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f345977b-4a84-45e4-2d79-08d9ffe78053
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:06:40.3848 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wOxLnm9YYBGwVE+/72wE32kF1sMVtlCp5JEzDD8h8NQqOOIyGlhKwvuJNhE5rbk1v/vuyWaKvGLAOnczDtXyBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 07 Mar 2022 05:51:41 +0000
Subject: Re: [dm-devel] [PATCH 10/10] block: remove bio_devname
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
Content-ID: <D20E32A337E3944E87F992B79236EEF6@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/22 10:01, Christoph Hellwig wrote:
> All callers are gone, so remove this wrapper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

