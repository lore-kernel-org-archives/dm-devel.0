Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C59C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0C7E2610C8
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0C7E2610C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-HiYsU3T-MHm4YO4N9sYz7g-1; Thu, 11 Nov 2021 03:16:53 -0500
X-MC-Unique: HiYsU3T-MHm4YO4N9sYz7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30D77875048;
	Thu, 11 Nov 2021 08:16:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DC2B56A88;
	Thu, 11 Nov 2021 08:16:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D0C581832DD5;
	Thu, 11 Nov 2021 08:16:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB8DLLa021365 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 03:13:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B5CB54047279; Thu, 11 Nov 2021 08:13:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0773404727C
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:13:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9402D1066559
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 08:13:21 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-340-kk4wMXeWNLmtbNZORVlm5Q-1; Thu, 11 Nov 2021 03:13:18 -0500
X-MC-Unique: kk4wMXeWNLmtbNZORVlm5Q-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1821.namprd12.prod.outlook.com (2603:10b6:300:111::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13;
	Thu, 11 Nov 2021 08:13:09 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798]) by
	MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::c961:59f1:3120:1798%4]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 08:13:09 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [RFC PATCH 8/8] md: add support for REQ_OP_VERIFY
Thread-Index: AQHX0UgtOC/Y9KWcw0KV7w/MN4Ma8Kv+BV0A
Date: Thu, 11 Nov 2021 08:13:09 +0000
Message-ID: <d770a769-7f2c-bb10-a3bd-0aca371a724e@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104064634.4481-9-chaitanyak@nvidia.com>
In-Reply-To: <20211104064634.4481-9-chaitanyak@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17eb0860-f29c-46fe-4dd5-08d9a4eb1949
x-ms-traffictypediagnostic: MWHPR12MB1821:
x-microsoft-antispam-prvs: <MWHPR12MB182107D498E164C601BF101FA3949@MWHPR12MB1821.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: pH75awKNVlo0ml1Tdk75CbLvGCVUCAr8UPpsgUOdklviR01KnLkMri3w+aGPhTZqhicAZZQo7L76BVPmEUraaRa2ZQaIvPiKD+ze3udbyW0eHPWhAQnYT1k2FvuwRW7AjESJlXBQC0hfZqDjpOYs+sM/+WEdSG7vhEn9SfGFewVYemjg+NsxELbbzyfOxcA076fMPWTxPlpzNInuW91kHCmvlZCgIkyQDVNfc273hWfMa9vlz5wNiRcQkFPJfys6WafXDdsJp/uQ8ZNlhdYMvk+0ig3PxULcn/ZcJj5UWqnJMmJb+R1mVKKbhgYWZ6EUMCAcgUehXMm64qIa3t1yAA/hoy9zB0vB14PVHtowV1GsgjwQBRSnCmyMTmnyC3DP6mt4POB6D8M/n/Jb+OLk1pRs18LWCdojbd1dbZ4JDbOpo72pfNtB14ZP7Oz1gjKu1adey8H3Tdd8tG51IqgHRQ6J2PQxAqPtP92/zdCe0pjqFFAfqEnZqMZaC+7M2l1nbeaSKs8PxkP8aUM9f8OqIt9mFW3E6lIWA1SqEs5qBLVcdn09hS7A08hOOS22k1F6yn2XpuhRKB85MAy1qxZaI2PiPljmkwkAYVK9wxBVx8TvRdJXtajOlfkbnhdUnTwSrVcgvjvtShgJN0tf06+VvG09MatT41rdMdjklrCLc5FNm8yXuLQW8Wm1d6DDI88mBZuix+tsiQoKVkGGVgXe9m71C1652+yBwZ6xoc6f5Bxr1UY0xs5DNSc8+xJFbgAssqSXXRhlKLP3IZKPhY2TIg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(83380400001)(8676002)(6512007)(66556008)(66476007)(64756008)(8936002)(31696002)(186003)(5660300002)(86362001)(66446008)(66946007)(107886003)(122000001)(38100700002)(316002)(76116006)(6486002)(31686004)(71200400001)(54906003)(2906002)(53546011)(2616005)(110136005)(7416002)(7406005)(38070700005)(4744005)(6506007)(508600001)(4326008)(36756003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2Q2TStPOVpSMXBZNnpHS2UxS3lDWUpuTkdOdVpvRkg2eWtmL1E5WUEyV1ky?=
	=?utf-8?B?bG9PajZDZU5LSlNSUXE3SW5XTitrSFMwbmxncmVocE54VHBVTkRoQm1DL2Zs?=
	=?utf-8?B?U0JyUGU4YXRZRVczSUdqMnBhaEtxTFZBSW5sajd6bzJEb2Z2RHlobG8xUXJu?=
	=?utf-8?B?SlZQZCtZenVlaUxKbUl1TjVtdWNTSjlNTmtnV21QZ1A1aTVHMzlUMzRYa3dY?=
	=?utf-8?B?NWhEUnNkdlhVWjFwd0gxNVJCMjE5SkM1OU1aZ1JuWjdXNVZlL1lVcHBRN1pT?=
	=?utf-8?B?U2JKMHR0STBzTWpYV1FST0lRQkhQUzVHZ2VKNHlJaUF3NUpHbUUxYVBxV1Vn?=
	=?utf-8?B?Vm5tN1RIM0pHVUNacUNjelMwRmE3R0x6d1Y3YnkzKzVMcitWaEpFTlN4ejhP?=
	=?utf-8?B?amtkWDBwZFJidmFnbTNOaW02cVZSZ2R3Y2lxV2hCb0lvUkRGam1aRjVRZndP?=
	=?utf-8?B?MXR1alJUYXpPYTlhSTZtcUgxWE5qNVRZZW5iMHBNZnkxNFBtR1VIc3FIODhE?=
	=?utf-8?B?VUt4NytzdWlUM0F2OWZPRE5EZ3N6OVNBTkhzdmtoY3k3ZC9hanNOUGJ4S29v?=
	=?utf-8?B?UUYzNWhWdjF3QThZYXJreTMwTHN4S0JRYU9wS3ZKSjU2VWREYUovR1JZZXd6?=
	=?utf-8?B?cjM0ZW1ZcjdsM0JOWWRzUVQ3d3BPNjZkalJJRWpkaUNMZlowejlvbFoxTDds?=
	=?utf-8?B?ckU3c1dGMlI3L1Z3TmtZajQzMXlORXdqQWovcC9KZ0hHKzRKTm5QcDlUdmZs?=
	=?utf-8?B?cjJmeURVYno0cXdCb2dXaW9zRGdaVVM4TVR0c0d1T2g0Q3BtTUo2eGZST0ph?=
	=?utf-8?B?Ri9XSlQwdHNZMlQ1VXVsOUtKT3kyclk3ekprQ1RjbGw2UnpSV1BsVk5VYm5y?=
	=?utf-8?B?MERySFpLZXh1QzlmS3dWcFFzS05LeC92WlJHN0xrWFpXRTZncDh4a3ViM0lq?=
	=?utf-8?B?bzhmTDQrZzBUNzFzaXlEdmtBemZqZ1R3MldPbzVaSnV1RlZUWEppY21aL1V4?=
	=?utf-8?B?OXAyMHA3aVRLL2Q0em1Nc0ZqcWRpQ0YxMTN5WFI2N2JUUm50VXQxUU5zVTlq?=
	=?utf-8?B?Vi9QbmFhZDAxNzVqNktzZjZiYVhSa3lJakQxc2FhQUQrOUY1MXBlMTFlMmtt?=
	=?utf-8?B?MGxpZytlSWFnMEpOVHpXNGxYK2trUWo0bnkvMkpTSDVCVm1ISGtXTm1KKzlu?=
	=?utf-8?B?RWNjSERiVlc0eUFKSnQ0aUlKWXpIWFh5M1JadzdIQ2s1cUtPVU5nQkJkYWVa?=
	=?utf-8?B?b2tZOUJPL1grMXUwb3BOak5PdG9Bb0VtZ1RoWVgzWDA3N254U2l5MDU3YTk0?=
	=?utf-8?B?aTBucjhWbnRmL1ZGTDlpejhTQUkwVjFGMFJJcWJid1hPeTM4dHVZdSsrdEF4?=
	=?utf-8?B?aCtoRklPRlI0UzQ5NUdodW5JM0dqUjdnb1ErM2FRYTVwc3hyV0tZa0hEVmxv?=
	=?utf-8?B?RTVYMFVJMyt1aVJKTFVmWGlDN0dPOUIrVnB3R24xUnVIMVNJeEorWEwzTG90?=
	=?utf-8?B?a3l3VDZhS09kRkVheURtbWNuWlRMWmZHWFpMVXhoSVRWeEVVZVBFU0dOQndR?=
	=?utf-8?B?Q2R5eTB2TXNVTXhWSXp4MkcvbWtqSmwyMUY1ZzZLa1g1MlpKNWRvZWo0MUxL?=
	=?utf-8?B?T29ES1lpQlkwRFFQNWViNFBLL3h2YjRjVmFxem1UOFFqNmxEd2liZXlSSEhi?=
	=?utf-8?B?U0l4U2hHQzRFWTlZcVpIZklmenBlVHhSUkJINitmY1JIZ0ZCZU82VkpNV3lq?=
	=?utf-8?B?YVZ4NHJFZTJnQ0xoOTU2bDBYVHh6UkJ2V29lVG1GMkJFTlU1V1l1eU10a1ZH?=
	=?utf-8?B?RWM0ektGYisvYTlreWc4eExaU1NSV1JWNURuMGZKaFA0WGhPd0ZFbzJTVUhk?=
	=?utf-8?B?MFdKdFV4ZHFuVm85TSt4UXNrcS92MVBzOXVUbmxpbEIzSDV0OVRKTUtYa2x1?=
	=?utf-8?B?VWhxT09tc3BqcEt6R1F0RzdJblZxZFlxeGV0KzNOWTVYY04zbHMwL2I2bmdE?=
	=?utf-8?B?UnRkSWdOKzB4SExmVlUvbXB6N0pyUFRyMGpWUVdzeUMvcWZPNTlJNkdCVkR2?=
	=?utf-8?B?Wk1ncDZqQ2tkTnhGOUNJOEkxT1MwV3h6dE9xSnQ4Rkc3TFc0NE9Uam9Rclo1?=
	=?utf-8?B?RExnL001UVNjaUtOYVFjUVpqVnkxdVNNNTVwcUdiTEtoOVRwekJXd2sxditw?=
	=?utf-8?B?RklEWFNVSEFaRmd5UEg0SzIvM0hmaWszck4vd1JRMldZUXFGWkRYMzVtcHpp?=
	=?utf-8?Q?8quyouoRJKM6csLFiMtdpOTJNLvEcsvvjRdOxEp37Q=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17eb0860-f29c-46fe-4dd5-08d9a4eb1949
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 08:13:09.6261 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zpHAt582iIN9zfPag7KVKOO8cnM/wYlkZM0DNg20fZh7P8Otb5RzoOPGDdRuFF4s4Rj5JdoDtDvPOvJEDRnKJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1821
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AB8DLLa021365
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 11 Nov 2021 03:16:24 -0500
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"djwong@kernel.org" <djwong@kernel.org>, "clm@fb.com" <clm@fb.com>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"osandov@fb.com" <osandov@fb.com>, "agk@redhat.com" <agk@redhat.com>,
	"javier@javigon.com" <javier@javigon.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>, "hch@lst.de" <hch@lst.de>,
	"danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"song@kernel.org" <song@kernel.org>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "jack@suse.com" <jack@suse.com>
Subject: Re: [dm-devel] [RFC PATCH 8/8] md: add support for REQ_OP_VERIFY
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C565C333DD93604D8832BCFBCCFCED47@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/3/2021 11:46 PM, Chaitanya Kulkarni wrote:
> From: Chaitanya Kulkarni <kch@nvidia.com>
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>

I want to make sure the new REQ_OP_VERIFY is compatible with the
dm side as it is a generic interface.

Any comments on the dm side ? It will help me to respin the series for
V1 of this proposal.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

