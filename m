Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D004C43217
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-g2iP9upyO-i6Li902wHtrQ-1; Tue, 19 Apr 2022 02:10:44 -0400
X-MC-Unique: g2iP9upyO-i6Li902wHtrQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1682C3811F38;
	Tue, 19 Apr 2022 06:10:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF4BDC53524;
	Tue, 19 Apr 2022 06:10:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03B871953540;
	Tue, 19 Apr 2022 06:10:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6B5851947BBB
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 21:22:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 228C9C5097E; Mon, 18 Apr 2022 21:22:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DCCDC44B03
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:22:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 018731C05B18
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:22:31 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-wrDntJ6JPEmsNTXlsaeC9w-1; Mon, 18 Apr 2022 17:22:27 -0400
X-MC-Unique: wrDntJ6JPEmsNTXlsaeC9w-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB5101.namprd12.prod.outlook.com (2603:10b6:5:390::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 21:22:25 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 21:22:25 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 03/11] null_blk: don't set the discard_alignment queue
 limit
Thread-Index: AQHYUuBbOHZrkZG1wkiLxi5X413wpaz2LwoA
Date: Mon, 18 Apr 2022 21:22:25 +0000
Message-ID: <89b62032-297a-1201-3a35-fa1731a0d620@nvidia.com>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-4-hch@lst.de>
In-Reply-To: <20220418045314.360785-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9cd3ac9-a34b-453e-372e-08da218188bd
x-ms-traffictypediagnostic: DM4PR12MB5101:EE_
x-microsoft-antispam-prvs: <DM4PR12MB5101D98C45971BA44D603479A3F39@DM4PR12MB5101.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: aRpHrH2zfUblOq5eGVmc/JRpRc6KZNhp5dR+XBuco/SHMe93F0bxC2UTJLLOm2T+6EdQ+c4XeV+ul0kQHLz2Vnn1y0V5QEmI103RjJRobjFKKxPfVxaWndfqq6qT3iYhthYrZJT6dIoYhHGYfKyqTlfDZrIGK0R6BiRt4g5uiCf2x0bcl2DWontr5Dr61AmhQloenQKAgsEU5INA/q4qu+9FjAJLos21upgt82THgXyhKD8QSrW8opFfz/Y1+NDrDPaEgRSxXF8RK4/StZnJg1Fom3RNUryA3xXkr+shyyzD+Fv5nl+YITFaersVxhpvxjG6QmQH1kgno3SL9vK0+uHcaaPdOVm4DI/DE8Zm2jPe16n8zhEHPVmzdxmyNaE4rT/U6r4ZlrOrOYEEGiUCQHROMX4m8wMp+sN0nfUCAgOTkNWFxbp/jrUNrL1NrOF3BjOyA7c5ZcaFN0F9cnQ7Eu6PMJDEmRB/sCpGgSEFtFaQap9vAzzBpgIaluqI7qffiUoiiBFV4QO2yqqdGlUl6eoefFlGZTwEqBeWJq887fm0UXYYU3MotTAl+4zbvEZ1wtXpfNM3KX3QcoeuaWGC6zN3GxRx6UYqfCjjdkW9fAgDbBMsse15a+S1BG6yE7SJEiDs0xP7T4Li5r0GN9gD/KajsmHdSpTiCzxmISh6t4H1eQOT0+h8IYRRwH2wYFOACxRDoNc/TXQAXy6iL5I0WnGIFQL8hiNjNez18GCbfLQn1KNFYZ6WzKUvEj1kncFHCTcolnhLCH87Zl2bO/+DTA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(38070700005)(122000001)(4744005)(38100700002)(5660300002)(4326008)(6486002)(83380400001)(186003)(2616005)(54906003)(110136005)(508600001)(6512007)(71200400001)(6506007)(7416002)(66556008)(66476007)(64756008)(8676002)(76116006)(8936002)(66446008)(53546011)(66946007)(316002)(91956017)(31686004)(86362001)(2906002)(36756003)(31696002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHlwcE9FdWtqUDhXN2M1c1lUQ2NEbk52YnlWd1drazN0OXo0NXZMQkhTTjRU?=
 =?utf-8?B?UVp5WDlnN01SYk5VSFlhdmlBRHFLdjNzTnN1ajhINUdsM2RNYkhtZnhqcTdv?=
 =?utf-8?B?TlVQSmtTRGFWd3FWNVpqNERvSnVEUTFvUGloWWRpKzNCbm5KWHJobXVPMzNH?=
 =?utf-8?B?a0kvKyt3cmpJWVF2QVo2Y3dwOUJjNVlRTm50UTVzM010eXdjM01MQWpZVWg3?=
 =?utf-8?B?QUR0c2ZHSFh6N1QrRkU4SHJlMzVBYW1jcGpvdkY0RS9ady9YTFZsUVZDSjBr?=
 =?utf-8?B?VWdLSEtkdGRlbWFreGVSaWNkak1ZU2ZFNFJ5ZjNBN3hDdmpaeGNydUFZdlFZ?=
 =?utf-8?B?eG9JOVRyVlRheG1jNklhZlgwRGEvanBmV2p5MVRncGNZWnhUQ3hNZEVuaEFI?=
 =?utf-8?B?L2VUMzR2TTVwSUJROUpkd2l1blVDelhXcWhudmZRV1d4S05LTGZLOFg0cVhF?=
 =?utf-8?B?RkFiOVU1K0c1eVd5bXZnbGxraE5GM1dMYzdaZTdjbnA3STZPOHYyMTc5MHY2?=
 =?utf-8?B?SVZRdEpRSVNPTjJGc3dqQnhYS25hdTdNMU1wOFlaVmxoNkFrbkJ6ams0c1Zi?=
 =?utf-8?B?VlJqVEI0TlBiTTU4ckhDWVk1RnRhSGJEazRZdFg0THI3d3Z2dkx1bS9rQ2Zo?=
 =?utf-8?B?TzR6Q0g5QWF4VjVFcVZ0ZDdUQjJVMU5ySTdqN1M2UFdvakZhdlZ4enpaRTRK?=
 =?utf-8?B?NHhjVGRNbHA5WW5Yd0x6NkVXTjZoYVV1NGFxY1F4VmlaKzNpL3dJZmsycVhl?=
 =?utf-8?B?NVJ4MHBHczBvMWZNYzFmcmswVUVWSEl3S0N2dkVKVVpwelpFSytzQUU1bVJ4?=
 =?utf-8?B?QmUyTHgvYUtCTWphMnAxSjVlcDcwcENFcGgxQjBPbEVwTkRLZHF1K1hOM2hK?=
 =?utf-8?B?Q1o5cWdsNGRSQ3RvdXZQR3JOcVZLNFNVWk92NlQyNkdPOVFhM1c3L3Viek02?=
 =?utf-8?B?ZGJYRkUzNzd4MVU2WlVxUEtLSXJHSWlOYlcwRjBoSTFzbnZSMFlVWm1yL1FW?=
 =?utf-8?B?ZzI1bEs0MEgydFhtNXBtMHR1aEpFK1dwRHMrRitiUmJYOU8weU04MytDamth?=
 =?utf-8?B?ZFBGNkNrOGhUd0xYMGU5cktxZjI2RWw4Vll4ZEZxSDQxMVFsT1hyZm9EUFJy?=
 =?utf-8?B?NTVCYVF4YkpTdVZDS002UVo0Wk9qQW1EWldBTlZGb1hCV3JrM1ZkU2tkTlIz?=
 =?utf-8?B?Y3k5UmQxMHd0WWFCR0d0b3FVdnlmQUhYUUlXYml5dmJ3NElpVmtZRFhFMkFJ?=
 =?utf-8?B?ekwwR0ZnY3VVazZHZzFBS0hua3RqVkU2Y3J4WnRhc0tWK2t0cE82c3hxWUpG?=
 =?utf-8?B?YkNBUS9vZUg3aFF6R1hiQ2p5ckZTN05EUzFUTXRRamJ3amZHNHFLQ0x2WFoz?=
 =?utf-8?B?SDFuNWkxMzJNK1dVNDNRWHpyM1lZNzJkekwvdVVXRFpiUUsrTmc5ZTcvQUdv?=
 =?utf-8?B?OWZLYkJacWgxbWNCQ3hVbklzTEQxRjNBVWh4TGdjNStxOGdTYUIrdjhvS3Jp?=
 =?utf-8?B?dE5YakJtRVRVQTI3VjF2dUM5RU14eWVpQ3BBdjY5dUovVityNzJzUVBacm1D?=
 =?utf-8?B?VGcyMGhpKzhCd1hwQ3Q5Q2xWSDlNaXZvcFBDL1hlRDhEbjlvdUVNS0phaHpy?=
 =?utf-8?B?ZWNpcjZJTytQTG5yMXFGUCtXYk1MWWNuai8rQVRvTzRvYUkvK0tMRGZVdXN6?=
 =?utf-8?B?WXZJcEk5UHJlNHZyVE1vZzdsS1ZTaGlkRkdqdkc1VzhzTXQ2TzJ1SEY2UjZo?=
 =?utf-8?B?ZmJlTlNSdC8rb3pBVmxmNFNGRWQ4b0NBd3BQZ21EeWFOUnZRUmttdkhic2RU?=
 =?utf-8?B?MlhLYm5WVnZWcU1URlZZZmNCMWZYencvbHJZZGJHNmdLNm1qc0lJdXM5dEcv?=
 =?utf-8?B?dXI4Z1VyM2llU1J0dEhtcFc3SE16NjlxbmxNU2RxZlE3WGNYZGNEOGREM3Mw?=
 =?utf-8?B?elRKL2JmNkNsa0pLNGNySzcwSUlFQ1RTcDh1WStUL0d5MjFzdTNZOUFGTTJN?=
 =?utf-8?B?eDN6RjlnMWd2VnpEdkhLL1dOVkVSZGNWVlNUaEpWOHBpZVBWVjF1ZHVqbjlF?=
 =?utf-8?B?azNRWU9La1VOdXF4SGpVM0ZUVTZvc2p0TFJSK3N3Q2hrRzU0NlVSNmZuYWZM?=
 =?utf-8?B?cnFldThZQkJlU3VaS0lrVE1TbHVoNTlkQks0OXRRWXhKdERMOWh3dTZnSGhZ?=
 =?utf-8?B?QTdPRVRTZExTRGlQU0ZsZnJrcy9naXRJa0RabEwyS05aSU9vc0wwN1MwYnRM?=
 =?utf-8?B?QkxLTzZqdkF2YUxwMlREbHhUQ25PTU81T1hObWwyZ1RnRm9YVUNjMzlzUzIv?=
 =?utf-8?B?WnBqdDMwT25mbXdjdWZQUFZMR05ySUJCUmxsdGM3NHdDbStyWFpGd3BlTWhR?=
 =?utf-8?Q?UaiVDBgSRkbWIBTE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cd3ac9-a34b-453e-372e-08da218188bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 21:22:25.3852 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ocsZWn2s6zKRxvQpyKeFcrsqFtOLj2JpUOEoP9+wJ9xZDYN6R4YaqeL0mZLa1xxmZ3QSO9WGmlE7qcBux2cerA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5101
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 03/11] null_blk: don't set the
 discard_alignment queue limit
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
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, Song Liu <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "Md. Haris
 Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 Richard Weinberger <richard@nod.at>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
 Mike Snitzer <snitzer@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Stefan Haberland <sth@linux.ibm.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Martin K.
 Petersen" <martin.petersen@oracle.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <ED7EE68D9ECC2E45BB1E6AA4E02C1AC7@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/17/22 21:53, Christoph Hellwig wrote:
> The discard_alignment queue limit is named a bit misleading means the
> offset into the block device at which the discard granularity starts.
> Setting it to the discard granularity as done by null_blk is mostly
> harmless but also useless.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

