Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE679C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-csXMcCZ0MJS4CU9f_rJfcQ-1; Mon, 11 Apr 2022 02:19:26 -0400
X-MC-Unique: csXMcCZ0MJS4CU9f_rJfcQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C087C805F50;
	Mon, 11 Apr 2022 06:19:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97DB34021A6;
	Mon, 11 Apr 2022 06:19:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D4120194037E;
	Mon, 11 Apr 2022 06:19:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E0971949762
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 16:24:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31534401D25; Wed,  6 Apr 2022 16:24:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C5E348FB03
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 16:24:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 053DE85A5BC
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 16:24:51 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam08on2043.outbound.protection.outlook.com [40.107.100.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-_PD0srOOM6G9YZTFHHB1-Q-1; Wed, 06 Apr 2022 12:24:47 -0400
X-MC-Unique: _PD0srOOM6G9YZTFHHB1-Q-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Wed, 6 Apr 2022 16:24:45 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 16:24:45 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 2/5] squashfs: always use bio_kmalloc in squashfs_bio_read
Thread-Index: AQHYSZjNtRgeK0B4G0+ZE2vgbni+t6zjEnQA
Date: Wed, 6 Apr 2022 16:24:45 +0000
Message-ID: <0a23a8fe-c298-3fa5-5d50-55d36d9bd14f@nvidia.com>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-3-hch@lst.de>
In-Reply-To: <20220406061228.410163-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26a24fa8-2943-4c4c-94ec-08da17e9f655
x-ms-traffictypediagnostic: DM4PR12MB6012:EE_
x-microsoft-antispam-prvs: <DM4PR12MB601230E3E5C83372FF12DEEFA3E79@DM4PR12MB6012.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Lih0Fhptg60aQnfpp/kwAO4pd/dk4X8DFJTFzV8dfrfddIHc6e53aClfCUDq7eCnxR7+Ie5aMLcGUG24Ah7ESjtyJLdfwC4hlcrukUSRqondoxNdaKy8rWb/MHdMi/OGFBD5GYlntN1diIQAr+YN+8yFf2YI0xq0dLLnGmvGVCh4N5Ox7pHElUSQ/33JfMMaLDBSzXhzNf529JWIr07IT+zMXL+864zC0xs5s2XHkiibyRGezuDNKYHDbRhSFZdEKJeg6/fgFTD6Nirnxagl/HsmCsBGzicJS89mbUnOPQ0grV6H1pi4HMuc1Au3SnkxaMFEXfTzDFH6q3rBL3Y+ifRp79vCyNRXaYHB40XaXh3F0gZUZ1VzmdMwtJK4t5OIILK+nKmLL1eGknb+y7ncEMb5/WJGedPIYTuHm4HOL4qVmpz9lOiJ8P1o8+CZzzw1ue+4YRQw9bCpFW6wQxRZzA+i/5JlfElkaVhM5TBTBmXCW3pOX4RBaVYpbBgo4AEmTqLN9QKJnb4vRUFoAlIgZmoKue3jgeAb2ZClGKGmMTrZjCdVBYChvTig2NMSATeKXDXPfVgids9GMnPsdUwxu2wndSWYEA9juzKn0BbqyE15g1NefZapzYz9fckOg4vZK9J7Go/QKx7kyo+6OFO/N8BajT0oed6jDkPr0k3Mb2n2oRwmrEq1aVUUAWbzSikYHAfzfm7H3hEHiA2DFaoT45PebmLhCyP2uUIe2E2o00vNZ7oZzuSq95SNo9Yj+1HNGjV4Pi5TQyW1OXJaAA96UA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(2906002)(6512007)(71200400001)(86362001)(31686004)(38100700002)(54906003)(38070700005)(316002)(110136005)(31696002)(7416002)(4326008)(66556008)(66446008)(66476007)(2616005)(64756008)(36756003)(186003)(91956017)(66946007)(8936002)(6486002)(4744005)(122000001)(6506007)(53546011)(76116006)(8676002)(508600001)(5660300002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUdycHFLQ0JYSDRLMnFTU1V2VnNtTko2MThzZGt1Ylo4SUc3K0RVdTN1SjE1?=
 =?utf-8?B?UVVra3RWWjg0OEJTOTZtN0d1TnlDbGNMOEdBYUUxTEQ0ZHZSQXhxY0pHSE81?=
 =?utf-8?B?bTJFYlBpUEtLNjZLZ0pqa2IzY0hkUUVkeDJicVVoR3lwYktjaW1BR2t2N0Zx?=
 =?utf-8?B?cE4xNzV4VEY5RE9yQnFHL1E0Y2kxWlA2WGNTWnppOXY0REZnT2NaSW9zZUQ0?=
 =?utf-8?B?YnNaaktreVRWdVVINndvbnJTMVJvSlFSVHQrZk5aQmtManZJRkxDOVZBUEFv?=
 =?utf-8?B?ZlRtMTl0Y0FERUZqM3ljRkVHU0RoS2hUMlo3bGczMmZSRzFHMWtLQmt1RjlN?=
 =?utf-8?B?WXZLRVIzOVROcUtQaElmS0tmQnRjQzFpUnpPcVludnZUK3ViL2wzQU9Qd095?=
 =?utf-8?B?T3RsZXZYT3hQZlA2T2tkYTMxKzZaUEt2ekpvdmNNN2FTVWdieWYxK0VFeDk5?=
 =?utf-8?B?alFRazgrTytPR0lSUjFBUHplUE9QS2t6aWl6ZXhuMGNDMWh4TE1kcW1qczFS?=
 =?utf-8?B?YWZKQ1l5TTNDMDd5bFppQm5WWnpIZmpWbnFhVjl4eHJGNnRLcTZrbDBjNTM4?=
 =?utf-8?B?bTdLYjdEWE9NaUpuSEZBcHJOMHBvV21qVHVwdXBRSFpZdlpxQk1RWTZnVHJW?=
 =?utf-8?B?a0xBVlhFMG5tUlJCTktJZFhIemg2ZnJQbUNISU5RTlNxUGVmOWpzYjZtR04v?=
 =?utf-8?B?VzIyTDNVSEd1WjIwdHpNbzczOFF1N2F2d2xidERwbWFER1dzeHdGam1PTXhD?=
 =?utf-8?B?VnBpZno1bjJCY2Uvb3RKWjRLUkFadzlqRDFWSWRlUzBRL3dYbkxYQi9SbWZX?=
 =?utf-8?B?cW1Fbisvd291dnZCVzRLbHpuN2pKbFBGcVZwc1pLeUxHS0QrQUVteVJycTRx?=
 =?utf-8?B?dTI3UzVCOW1BYTdIU0NOaFk5ek1OZzNQbWdNUm9PSkNnSmNWa3A2MzJQSG9X?=
 =?utf-8?B?S2kyMTR1MzRBZDZDNFM1WVY4ZXB3QS9rK3VTcHU1QVpLQXdrSkxaSWVBcGNX?=
 =?utf-8?B?aThNZjFPaHBOS3ZtbDVjN3l2NEVIVTVWTUNvbTVVLzBuR3NsVzB1R2NDb1hI?=
 =?utf-8?B?K05QZWU5MlllSTRwNFNSWEhHVmhBUXBwZTZTbE43Z1dDazhYZkt1aElXWTdn?=
 =?utf-8?B?TzJCQjh1bTI3Ujh2SitnNUp5cUhiQ3V2eFZwRHZWd0loZ1BONW0rOExPYkFO?=
 =?utf-8?B?eUpYaHM4Z2VVR1JDYllGQ2wyN3p2TGdKQ3V0RTArL1lZWEMxMDRmZzkwT1dm?=
 =?utf-8?B?YVpsaXpvQlJaQTUyMlcyUDdnVjlNMnFNVFdzd01aWnUyM1FYMTc3ZjZYRG1S?=
 =?utf-8?B?b3ZDY0hpZTBsMmZMQ0Q2NmZzT1dkemdrVTMzSjF5N1NURlR0ZFpNc1RaYU90?=
 =?utf-8?B?SUFGNzllZ2FzeDJtQUhKNzljVVdRbVpyYmEyeEVWRlB2SThNQ2pBZDduME96?=
 =?utf-8?B?cEtITG5Bd1pldzBOdytVZHk3K3Mxcm5yWCtJamdUVHJ1WjFHejZzSGw2dHFQ?=
 =?utf-8?B?K0NENnpwblUreVFIbFhONEF6Q0FuQnF0clNhR2kzd0JDQWNsNUlsSmxSWkVW?=
 =?utf-8?B?RlBEejZwYzYrazM0WFE0eGt5OGYraCtneVJaaW1hdnBoUm9SZHRWUVllamdR?=
 =?utf-8?B?NEdPS3dOWVpJL1Q0ZU16KzJ6aWw2cEMxcHdXMkpTQWdmYXo3TkVWcTRabzZ4?=
 =?utf-8?B?TFN6OTcrcU1EdFJkZ2puallKUThtb2ROOEpoTzQ3aURlOThFWk52TWQ1ZjBj?=
 =?utf-8?B?djcyWWZXV3c2VFNLdUFCZDJybEtjWGhUQTB1bGdrWmZvSDlxZ2MrcXRBYi94?=
 =?utf-8?B?NEthM2JEbnl2dDU2MTBHLzVRdlNlelBMYnB4WXAvdmdoSlk0UmhoblZQd1d6?=
 =?utf-8?B?eE15aUtPWkkzMHh0TW5MMjRwMXM1RndrVCtPdlJXem1lZ0pxdmNqVjZQVXUz?=
 =?utf-8?B?VkwxdDNiVkFweEdFbmpHa3l3TksvaFgycXBSLzlQS29PemJPTVlWNGFkanFt?=
 =?utf-8?B?UmFIWEMwM0haVEUzYVBFdFIrRldTWHlUNXVrRERkTXRRRG5rUnJQc2treVhm?=
 =?utf-8?B?dGllOVIwdmR1dEZwWTlRMkdDdEFjdERRWC9SbUQ3TStzY0paMnYwYzlDdGY2?=
 =?utf-8?B?ck5QMnV3Y0pSMmI0QUM4NDBxblBHVlAvWk1Lc3orc081L01ZZnV2SElGNCsx?=
 =?utf-8?B?QnZOdEllN0QzcGJjRHlRb3ArV01PU0s4UkFXeDlGN2Z4L1JHTG9xbnA4SW13?=
 =?utf-8?B?NHU4K2NFUW96YVNydjhQNG1kbCtuY1ArWEhTV0VCalJha0xVb3hkVWFFWFRx?=
 =?utf-8?B?NFpaWWRXZWZlWlNicVloWWx1NmNRSWpYWjRhbjdWQnk0TXRpczNPTGozZmJC?=
 =?utf-8?Q?ZJuk41gmAUcJIu6E=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a24fa8-2943-4c4c-94ec-08da17e9f655
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 16:24:45.1313 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U/BAfVFG1GV7EpFQMOB5J/nJP9BCszDUtIhMNKcIn9IabiecCYq+72EED58+dOSHFy8zWDa5ksvTqW/JFqBScw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:20 +0000
Subject: Re: [dm-devel] [PATCH 2/5] squashfs: always use bio_kmalloc in
 squashfs_bio_read
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
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <58EA1AAC011815489C0953DC4A7631D5@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/5/22 23:12, Christoph Hellwig wrote:
> If a plain kmalloc that is not backed by a mempool is safe here for a
> large read (and the actual page allocations), it must also be for a
> small one, so simplify the code a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Phillip Lougher <phillip@squashfs.org.uk>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

