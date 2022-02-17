Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D139C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 13:31:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-mAmE6NKnMqu0_M5JHbKgQg-1; Thu, 17 Feb 2022 08:31:37 -0500
X-MC-Unique: mAmE6NKnMqu0_M5JHbKgQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 189BB814245;
	Thu, 17 Feb 2022 13:31:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B632070D2B;
	Thu, 17 Feb 2022 13:31:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 24DCD1832DA0;
	Thu, 17 Feb 2022 13:31:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HAGR3A019757 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 05:16:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6A8004010A14; Thu, 17 Feb 2022 10:16:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 65717400F3FE
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 10:16:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 493F41C05EB9
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 10:16:27 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-512-j9r5l-TlOhCN6jUYIluvOg-1; Thu, 17 Feb 2022 05:16:23 -0500
X-MC-Unique: j9r5l-TlOhCN6jUYIluvOg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by BL0PR12MB4724.namprd12.prod.outlook.com (2603:10b6:208:87::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15;
	Thu, 17 Feb 2022 10:16:21 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4975.017;
	Thu, 17 Feb 2022 10:16:21 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Luis Chamberlain <mcgrof@kernel.org>, "hch@lst.de" <hch@lst.de>
Thread-Topic: [PATCH v3 02/10] block: Introduce queue limits for copy-offload
	support
Thread-Index: AQHYIX3XHL9e7GOdFkmJOxrEFUhCJ6yXeHUAgAATXwA=
Date: Thu, 17 Feb 2022 10:16:21 +0000
Message-ID: <f0f9317f-839e-2be2-dec6-c5b94d7022b7@nvidia.com>
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080605epcas5p16868dae515a6355cf9fecf22df4f3c3d@epcas5p1.samsung.com>
	<20220214080002.18381-3-nj.shetty@samsung.com>
	<20220217090700.b7n33vbkx5s4qbfq@garbanzo>
In-Reply-To: <20220217090700.b7n33vbkx5s4qbfq@garbanzo>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1a1b84c-f0d8-4872-61b9-08d9f1fe8b6d
x-ms-traffictypediagnostic: BL0PR12MB4724:EE_
x-microsoft-antispam-prvs: <BL0PR12MB4724CEDBE5856A6200C3BE8CA3369@BL0PR12MB4724.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6Z2W2wzGF0dUKXoe8V/PLOCWOIuMlgKpU5gl8Pwl6MCfuWCN8GbKrZhj3+tkHr/NXWl4aXzmuAVFpWTFDdjoA5eHGYMoIT7MoJMNxFjCgmChl2pZ51+6jhLkh9hXtYnklZjcbkdAWYHFMYHJa//bQWwPcDkP0T7gAlBbtEunI9GOOYcsXUjIg0qbqC72gpDyicngffJOqe2FGJeQKbZHT7kas6h3NXGvOQ6at1qTBBXM0fNxgfWjTHJhStuP+VsAgNIHWCT2zx69ARWu3SU0OHnM7A7m5H6vdBZDbLWXyQJTgWp3yOdbrtFwYtFhDwfMH+NBajtQCxQfr7X7lEP6mb3hWHfJXISN1R1e3LsCl1wQ1IU3Yx1TmLIbfGHaPpR0GcrDyHBujf4cbtslcoCCFbVENAg7XvKfNBkuXwtSUnokCT+dUBDGTadlya9n1d/htTcSt1izAI8Emrt1o5qbYDO1opySeDmMSa6nvjqxVNou9oKrHP1JrRBuMPTtUuQq+NrhmJzk8+OU+6vrr9gU1S3InhBQpr3w9YXIeSWOR3om6ivPJ4I/thEPa9GZo8mKIl6dlj8AIs0eVGyyCiZi21WV91zDXf95Xd3EskUtBEdKc1XbwjjKnFTs8DNhvV0QHROpuS6X3JoiiSkmYCLGIjw6SfBrKR7/mAnqTYHhd8Kf/FIuaVcY9x2kl92rMpG5lWdiYTaZxz/izqE9bp29XCaLgV26Jydn/cxStSJ0sODDswZOuSxmsGGzZyBF5J/VcxGUub9Q4wl6X0BexxsDsA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(71200400001)(7406005)(66946007)(64756008)(66476007)(66446008)(91956017)(86362001)(4326008)(7416002)(6486002)(2906002)(6512007)(8936002)(66556008)(38100700002)(508600001)(8676002)(5660300002)(110136005)(54906003)(122000001)(316002)(76116006)(83380400001)(31686004)(38070700005)(53546011)(2616005)(186003)(36756003)(31696002)(6506007)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUtEZUh2OGVJdzhZWVVtQVhyNkZuTDFrSldVVlNoWWgzd0YwNzBIZVhZaEhv?=
	=?utf-8?B?MjdXNFMwU2FTVWtaVGlCb3U0eU96NjRJYjY4cXA1YkR3WUJxYXRxcjBWT3VN?=
	=?utf-8?B?Y3dlYnU0b2RETngrbkZjK09qeWZCYjJCSVpTRlUzaEVrd3JuLzRrQ0N3YVVQ?=
	=?utf-8?B?cVgyY01kT2lqQ3V4RXpkSzRBaEl6cnhJWHVUWSsvcTdYRFNKSGxXUTRhVDln?=
	=?utf-8?B?M3dNeEdPTFFZQXJMMm52UDJrZ1dtQjBlaThQWWdYV0JBSEVkeWtZazVyZnNI?=
	=?utf-8?B?ZWkyNXR2OTl6aXVKcHdjVlArWEtJNkNudCtHQnAyMGFFdnBRYklrQXdXK2NM?=
	=?utf-8?B?anpIN3kzNmlKRGljUys5TmlGZTc3V3MyK3I4V01YRDcvYURaYUJFeXVFb2xF?=
	=?utf-8?B?elMwbkVUR2lia2xOZ3RrczZLcjgva2k3cFpvZmtLcm5oOTlicEFpRWFPKzZP?=
	=?utf-8?B?RTV3RDRHejhWenlSajR4U0pRUG1OUmhPMW80VTUvNzNFa2RVeUFTMlI4dWRC?=
	=?utf-8?B?OCsrYXVEVEQ4akZLR3Rlc1A1anZnWFFhL0dLVms4UXBNWkJPbldVbnhVNDMz?=
	=?utf-8?B?VnYwdytFZnRuQzlQV2FFMzBPRHFkbEZKUXRVaEtjZjZuZGQ0WkNpTHMveWdz?=
	=?utf-8?B?QmNtWmVIMWVRd3lwSkgyKzE0RnNqNnEzY1BTU3djRlNyRERRQWhXa0pUNjJj?=
	=?utf-8?B?ak54WTNXUnFVUENVZGh2STRWaDhsT1cwV2NnT1p5WnEzNW9Od2hTT2ZjeERl?=
	=?utf-8?B?UWVLS0Y1VFRydXI1TDRtMVRSNnI4OStJd1JqK1B6bkFLdXFCeFlxVWJiRU9B?=
	=?utf-8?B?TG81cllTNndUYkhBdFB6aEkzOGNPUW15MUpJSDJiWHR4K05wdGhCRzgwZHpT?=
	=?utf-8?B?MUZkUGF1QkFvQm5uT0dPNWhLMkIxa04wSTYrUnJuMngza2syWjRsNHNkT1Vu?=
	=?utf-8?B?bDZjSHpmbldEeFN3dnNiZnpGS211VDdiK2RjK1JLSWJIeVordEZGNlFrZjVJ?=
	=?utf-8?B?dlg1NEN5WnFwSExNNXQ4NCsyL0p2MkYyejhVbnZPOVJKOGZZTWMyZ3A5aWp1?=
	=?utf-8?B?TXhOQ1JBRjRLYU5uTEZrV0laOEVFTVBDdjV5VitsaFEyVmI5SWJnbi90cW5V?=
	=?utf-8?B?T2dvMS96T0doODlSb1M0MzhvZkdKVDBGZExRUXEybVFQd3JBUXdRa255cmln?=
	=?utf-8?B?L1Jaa0x0ZXZFcGRVYVYzMHNjOEtVSTF1QnpxTzh4RWI2OFBTSzVsZS9vbUEw?=
	=?utf-8?B?UzViYkVqWEY4ZjQ0aE16dmliQTFvUmFIZlV1SzAxS2lkeGVlWGlBQTdNZGNh?=
	=?utf-8?B?OEtoMWFkTi9LbTdmQTdRVC9UNFVIMjZlRllZeUZFNUZ0QW1XYVU3bTNrNUhQ?=
	=?utf-8?B?QXM2SWJPdTBBTmh1RFR4Q2ZQbnJXVGpoVWpTUVJaTFV6QzhnZ3c2STVPN0RX?=
	=?utf-8?B?NjVtTlV6RE5HS1c0UytubFhVK2ZjN3JMcW9FdEFHbmRYWExldGdJcnl3QklG?=
	=?utf-8?B?TGFERDZkR0krMTBFc1dzdkNvYzg0UVp1dit1TWNoRVlEbEJveFUvcVBvWGtp?=
	=?utf-8?B?SjJYeENUblA1eVVraEVlZ3hPalV2cWxBbUMrOU10Mk9wVktTeUZoL2g0cHZt?=
	=?utf-8?B?bnZoNm9ubHhGRU53M0VtalZVTEtUeDJpbFExUWFPMlhKRDlXRDdPcVo3RG9Y?=
	=?utf-8?B?MkJDNm1FbmFURkxDSi9UR0I2QTR4RUFxdXczZGJNeDlHVnRvTHFmYU1BOEd1?=
	=?utf-8?B?dWlmeXRhVWFGcE5DWkl0VHpIYzl6b0N5Ky9yRnBKUkR5eE54M3pNcVNndEF2?=
	=?utf-8?B?WEhYam43bTFtazlNL3FzY1ZyeVRZSkxHVEpSOWxEM0FxMDF2UUVUVjIxdEZD?=
	=?utf-8?B?OVNSV1V2UmI5NVVja1lwNjJKcFJMK0xBOUJyUElqUmNwaHJPNTlqZTZHWFZi?=
	=?utf-8?B?cWhVU3RWQmk4R0tJd2NrNENrS3pObmo0dUV5K3ltK3V0ZWdzSC8wU2dycklV?=
	=?utf-8?B?Uk5ldTF6V09wTVVqeTA1S1JKdE8vNGVkdXpIUWN3T3QxZENvL2JFMGFqV1Qx?=
	=?utf-8?B?QnR2SVRiOWozK1lDc2ZVcnNZSC9hSGxtODE3NmQ2V3ZYNTFzUWEzeXluaU13?=
	=?utf-8?B?c1RBTUVRQVJkRFBtVytIbFhlVHpvN1AzYjc5c0ZMc0hucHk1ZkJESGZQL3dv?=
	=?utf-8?Q?/ZP6IG4hSLaoX4cTPLBF5yo2G6c6LkusoAacJHs0f/T/?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a1b84c-f0d8-4872-61b9-08d9f1fe8b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 10:16:21.1574 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: meGMcDWO4GHdInb5gwSpsB1ykzvj2VMwEtrwv7nc1iLYS4BbHuyOOGCx3L2XN+DrhlGRpRe3OhTHYKh1e8op9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4724
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21HAGR3A019757
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 17 Feb 2022 08:30:58 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>, Kergon <agk@redhat.com>,
	"javier@javigon.com" <javier@javigon.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
	James Smart <james.smart@broadcom.com>, Chaitanya, Alasdair,
	Nitesh Shetty <nj.shetty@samsung.com>, Kulkarni <chaitanyak@nvidia.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Sagi Grimberg <sagi@grimberg.me>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"arnav.dawn@samsung.com" <arnav.dawn@samsung.com>,
	"jack@suse.com" <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 02/10] block: Introduce queue limits for
 copy-offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3C7747923854C747A3CF9C4661B64B1E@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/17/22 1:07 AM, Luis Chamberlain wrote:
> The subject says limits for copy-offload...
> 
> On Mon, Feb 14, 2022 at 01:29:52PM +0530, Nitesh Shetty wrote:
>> Add device limits as sysfs entries,
>>          - copy_offload (RW)
>>          - copy_max_bytes (RW)
>>          - copy_max_hw_bytes (RO)
>>          - copy_max_range_bytes (RW)
>>          - copy_max_range_hw_bytes (RO)
>>          - copy_max_nr_ranges (RW)
>>          - copy_max_nr_ranges_hw (RO)
> 
> Some of these seem like generic... and also I see a few more max_hw ones
> not listed above...
> 
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> +/**
>> + * blk_queue_max_copy_sectors - set max sectors for a single copy payload
>> + * @q:  the request queue for the device
>> + * @max_copy_sectors: maximum number of sectors to copy
>> + **/
>> +void blk_queue_max_copy_sectors(struct request_queue *q,
>> +		unsigned int max_copy_sectors)
>> +{
>> +	q->limits.max_hw_copy_sectors = max_copy_sectors;
>> +	q->limits.max_copy_sectors = max_copy_sectors;
>> +}
>> +EXPORT_SYMBOL(blk_queue_max_copy_sectors);
> 
> Please use EXPORT_SYMBOL_GPL() for all new things.
> 
> Why is this setting both? The documentation does't seem to say.
> What's the point?
> 
>> +
>> +/**
>> + * blk_queue_max_copy_range_sectors - set max sectors for a single range, in a copy payload
>> + * @q:  the request queue for the device
>> + * @max_copy_range_sectors: maximum number of sectors to copy in a single range
>> + **/
>> +void blk_queue_max_copy_range_sectors(struct request_queue *q,
>> +		unsigned int max_copy_range_sectors)
>> +{
>> +	q->limits.max_hw_copy_range_sectors = max_copy_range_sectors;
>> +	q->limits.max_copy_range_sectors = max_copy_range_sectors;
>> +}
>> +EXPORT_SYMBOL(blk_queue_max_copy_range_sectors);
> 
> Same here.
> 
>> +/**
>> + * blk_queue_max_copy_nr_ranges - set max number of ranges, in a copy payload
>> + * @q:  the request queue for the device
>> + * @max_copy_nr_ranges: maximum number of ranges
>> + **/
>> +void blk_queue_max_copy_nr_ranges(struct request_queue *q,
>> +		unsigned int max_copy_nr_ranges)
>> +{
>> +	q->limits.max_hw_copy_nr_ranges = max_copy_nr_ranges;
>> +	q->limits.max_copy_nr_ranges = max_copy_nr_ranges;
>> +}
>> +EXPORT_SYMBOL(blk_queue_max_copy_nr_ranges);
> 
> Same.
> 
>> +
>>   /**
>>    * blk_queue_max_write_same_sectors - set max sectors for a single write same
>>    * @q:  the request queue for the device
>> @@ -541,6 +592,14 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>   	t->max_segment_size = min_not_zero(t->max_segment_size,
>>   					   b->max_segment_size);
>>   
>> +	t->max_copy_sectors = min(t->max_copy_sectors, b->max_copy_sectors);
>> +	t->max_hw_copy_sectors = min(t->max_hw_copy_sectors, b->max_hw_copy_sectors);
>> +	t->max_copy_range_sectors = min(t->max_copy_range_sectors, b->max_copy_range_sectors);
>> +	t->max_hw_copy_range_sectors = min(t->max_hw_copy_range_sectors,
>> +						b->max_hw_copy_range_sectors);
>> +	t->max_copy_nr_ranges = min(t->max_copy_nr_ranges, b->max_copy_nr_ranges);
>> +	t->max_hw_copy_nr_ranges = min(t->max_hw_copy_nr_ranges, b->max_hw_copy_nr_ranges);
>> +
>>   	t->misaligned |= b->misaligned;
>>   
>>   	alignment = queue_limit_alignment_offset(b, start);
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index 9f32882ceb2f..9ddd07f142d9 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -212,6 +212,129 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
>>   	return queue_var_show(0, page);
>>   }
>>   
>> +static ssize_t queue_copy_offload_show(struct request_queue *q, char *page)
>> +{
>> +	return queue_var_show(blk_queue_copy(q), page);
>> +}
>> +
>> +static ssize_t queue_copy_offload_store(struct request_queue *q,
>> +				       const char *page, size_t count)
>> +{
>> +	unsigned long copy_offload;
>> +	ssize_t ret = queue_var_store(&copy_offload, page, count);
>> +
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (copy_offload && !q->limits.max_hw_copy_sectors)
>> +		return -EINVAL;
> 
> 
> If the kernel schedules, copy_offload may still be true and
> max_hw_copy_sectors may be set to 0. Is that an issue?
> 
>> +
>> +	if (copy_offload)
>> +		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
>> +	else
>> +		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
> 
> The flag may be set but the queue flag could be set. Is that an issue?
> 
>> @@ -597,6 +720,14 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
>>   QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
>>   QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
>>   
>> +QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");
>> +QUEUE_RO_ENTRY(queue_copy_max_hw, "copy_max_hw_bytes");
>> +QUEUE_RW_ENTRY(queue_copy_max, "copy_max_bytes");
>> +QUEUE_RO_ENTRY(queue_copy_range_max_hw, "copy_max_range_hw_bytes");
>> +QUEUE_RW_ENTRY(queue_copy_range_max, "copy_max_range_bytes");
>> +QUEUE_RO_ENTRY(queue_copy_nr_ranges_max_hw, "copy_max_nr_ranges_hw");
>> +QUEUE_RW_ENTRY(queue_copy_nr_ranges_max, "copy_max_nr_ranges");
> 
> Seems like you need to update Documentation/ABI/stable/sysfs-block.
> 
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index efed3820cbf7..792e6d556589 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -254,6 +254,13 @@ struct queue_limits {
>>   	unsigned int		discard_alignment;
>>   	unsigned int		zone_write_granularity;
>>   
>> +	unsigned long		max_hw_copy_sectors;
>> +	unsigned long		max_copy_sectors;
>> +	unsigned int		max_hw_copy_range_sectors;
>> +	unsigned int		max_copy_range_sectors;
>> +	unsigned short		max_hw_copy_nr_ranges;
>> +	unsigned short		max_copy_nr_ranges;
> 
> Before limits start growing more.. I wonder if we should just
> stuff hw offload stuff to its own struct within queue_limits.
> 
> Christoph?
> 

Potentially use a pointer to structure and maybe make it configurable,
although I'm not sure about the later part, I'll let Christoph decide
that.

>    Luis
> 

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

