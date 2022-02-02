Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C645C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 07:03:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-LIwne3OpOFmqfOvcQQ2UMw-1; Thu, 03 Feb 2022 02:03:29 -0500
X-MC-Unique: LIwne3OpOFmqfOvcQQ2UMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9A071091DA0;
	Thu,  3 Feb 2022 07:03:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 284B01057F58;
	Thu,  3 Feb 2022 07:03:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 13B8B4BB7C;
	Thu,  3 Feb 2022 07:03:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21280LU2027166 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 03:00:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E099A492D45; Wed,  2 Feb 2022 08:00:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB74A492D40
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 08:00:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBDE42A84B73
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 08:00:21 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam08on2084.outbound.protection.outlook.com [40.107.101.84])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-359-usCHwyDrNCCWB4julfW-EQ-1; Wed, 02 Feb 2022 03:00:16 -0500
X-MC-Unique: usCHwyDrNCCWB4julfW-EQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by DM5PR12MB1595.namprd12.prod.outlook.com (2603:10b6:4:3::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4930.21; Wed, 2 Feb 2022 08:00:12 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%4]) with mapi id 15.20.4930.022;
	Wed, 2 Feb 2022 08:00:12 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Thread-Topic: [RFC PATCH 3/3] nvme: add the "debug" host driver
Thread-Index: AQHYF5pGTuc0vK6aW0WDOYv4vbM4lKx/5pmA
Date: Wed, 2 Feb 2022 08:00:12 +0000
Message-ID: <270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdc7089a-8d42-4af5-bab0-08d9e6220a39
x-ms-traffictypediagnostic: DM5PR12MB1595:EE_
x-microsoft-antispam-prvs: <DM5PR12MB1595DEE0E56E4188FF2275E3A3279@DM5PR12MB1595.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Tm+RwM6GB6IxBU4X8jfeb7tEGFmxdNaT/j/H/nIHZQVEQbxIzWhGkmSCPwPyk4SKyXzocCDLtTpBMpFF7fYFZGBo2OUQljOfYdg88MpIbaRPMQbUjOdj6wj2dtkWbz3vwPYFfCXactGYi9/x944i2sItRvIMOGdRq3zvyCxIZcpWnQzjDLXRmAYM6+EBYAKxX0xt6QJbcTE00TbU0KXW8nRKTjIZuvS/TUe0er86JrgCkKzuHSIn1x6WZ0M9FYaiO3xp+yWg2IRA5WDiTOty5kLHxhepjrLs/N5ORsf84m0cmggUk/TRwZeK3lUOq5wemR1qPsjwINgEh/icOhjYQi1GCYXUugrycXsAnqHQ5aD4abhTdcpgO/md8RP3AowmuLIvxRu0HUjYY+DL8f5HwL9WhNxQtnoMOmtty8v0QcGFsLFbgTB2Edyq07C2zdCJOD2VTMWZDXm2GXI6qJHCL1lItnWXzd2Nyiix7aH5SieXcbXCoSio9G+yvxJpxCZ8GaDqmoIlGxaoNk6Wy7r8FCkJl+78sZoHl52sFfH1bwID8f85loO6LkWvCJd5/eN1arpJcgK9OdC49IToE8FGhgxNkZ3xLl4uDps0horW9igdi1aaTLWQmD4cDuJ9a1sT74+FLb6zQTiLmmVMXS99kwxu3Nw8p4x2ZIIMHLmawF2/h/bSnW5+Nv97jUThPy3LaOAnMlwIy02gUocq2KVjNEvfSzRUoJ4ewGGWavKplvG4vAZDXi1TaLLaVSTfEPtaENEmAyINXiiW1NjgOM3zSQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(508600001)(71200400001)(53546011)(86362001)(64756008)(4326008)(66446008)(76116006)(6512007)(6486002)(31696002)(8676002)(2616005)(91956017)(8936002)(66946007)(6506007)(66476007)(66556008)(316002)(38100700002)(122000001)(6916009)(54906003)(2906002)(38070700005)(26005)(186003)(31686004)(4744005)(5660300002)(7416002)(36756003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2hvVmozUTBtQ1pSR1ZFN3gyRjA1emxuTFc4dUNMOGxvT1Z1ZFZQNW5qTHdM?=
	=?utf-8?B?elBoQ0wxM0Z5WWx2eU1iQmlXb3hQdytPSUIzd2dTN3dpRzIyZU9OQTIyYitm?=
	=?utf-8?B?bWszRjRNR3p0NnJ5QW5QK25rcmFlTXZTMW5tKzZWK1FQWmF3blo3NmNlM0tT?=
	=?utf-8?B?cmhrZTRxek1PZHZuODJJL0U4TjkzUDZmQkR6TklvZ3Y1alZlVXB0cStGUWZx?=
	=?utf-8?B?T05wZW4xcGVNYTZaODdVeUI2ZkFuZ3Q3TStENkl0Y2tvSDFER3NZbi9NdXha?=
	=?utf-8?B?RzV5QXM1N2ZSdnZBWWpXVGpjdnZRRTBkS0htZWduR1hZVFFiWmtjMWpCT3Vv?=
	=?utf-8?B?aDdxdG9BRmQvVU9ZcE9sMWtxSUw2bXR5UjRXZlpmL1A0Qk81KzM2Rlcvb0Q5?=
	=?utf-8?B?SGFSaG5vVVBaR01QM25uL2lyWGt5YTN6cmhySHRkdnZPUjRDSDFqa285Q1gy?=
	=?utf-8?B?TnNnQkpSWGNXc1R2OTl4M0hWZ1duNXIvSXV3ZUx6NzQydmt0bTFhd0MwYXJO?=
	=?utf-8?B?OUxKQ1Z0VkxRMm8xcVZDV0dVLzBHWStiRzhNdzQ0dkYrOUh3YktEVENmUnhk?=
	=?utf-8?B?c0ZiNmQzL2kzc0QwZFZzYXViMElBWUMrQnIyTVhuL3N5UDRmV25UM0ROTWxn?=
	=?utf-8?B?Z1laMHdsNnNOei84dUg1TkJhd1FnMmQrWGEvVXBZWE56MWxTZVppUUw4SHY3?=
	=?utf-8?B?QlIwLzFwbnVrRW5odVlwR2JYQ1pvOHJBWnVrZVR0dCs0bURMTUpBMTBycWkv?=
	=?utf-8?B?VFlYT09iV2pGRWRJWXVnVWdPMGwvVDVrWW8xVXRhNjhFSDluQnhMWkdxV2hP?=
	=?utf-8?B?d0VDd1MvQSs1Ykh2WkJaSlhpZlNUS0sxZk9URWM4RWh4T045M0lzenBjU2xZ?=
	=?utf-8?B?bDhCOG00ZFREanVQR2k2M2VIRVpGdFhCZmhaam9JZTVqTll4UFRmZ2ozT1Bo?=
	=?utf-8?B?R1J4MGQzdjF5SkFIb3VGZ3lIdUJpWDJ2dklDNmVuK3VPTEtZdjlvU0dNMnp6?=
	=?utf-8?B?anl2SGdHdi94VDlUOThmSDR0RDFQWkpad1Jydk5XSlltVnd0ZkpSWjVOeHVl?=
	=?utf-8?B?d3I3c2J4UFJjU3V5bW11elJMaXNpcys4MnhCSUpOazBuSUxyOFhLbUNmRzM3?=
	=?utf-8?B?dmVTWm04SkxQcTdQRnJDNk8rSjF1bVN6WDFCN0ZUSm83aXZ5Wk1nMDAvR2Vt?=
	=?utf-8?B?b2NMOSt0U0FXbjBJQnZCcENJVzlSQ1lGb1VNZFpJU0Z4M3lxUVdKWUFvZGhD?=
	=?utf-8?B?bUVKZGdVR3FCRHdGTm95bEVBRVdURCs3RGhpWTZYNXpNNTUrY0twZS9IbXhl?=
	=?utf-8?B?UXZqS1FSVWEzeUZybFNpWE5ZY2Zia2QvMjJGYTJqSDVYcHJVdC9FOEp0bDRI?=
	=?utf-8?B?RzVhYVg4RHRWaEl4NEJ1MUcrWDV4ZVRrc21Obm81TFphd3RTY1E3T1hPbWpo?=
	=?utf-8?B?ZnBLQzhxb0FjQUVJZUJCZ1c4SEJkYzhmeVhUdzRPeHNKOFMyK0xpUzhvWU1l?=
	=?utf-8?B?MVdBeXh5UnlUZm9PU3FyRmtDaXRMaURMWWZMemh0L2NUNTJjQ2lGYmdqMytw?=
	=?utf-8?B?T2VkOVVKbmIxZG9WeFMyYTNmSTFnTk9seGl1TDBIUHVTVDRDVmNKYUtUcGJ3?=
	=?utf-8?B?S3dKekUyaXg1a3pBSFNLSE1EWGJFUHNLYTdEdWFJSDFWYWRySVFaZ00rSFUz?=
	=?utf-8?B?a21YRE9VUFJBUTd4aGdHak9NYnowc2RxWW9kUlRIL0hPVnV1SExtRmFTRnBx?=
	=?utf-8?B?VHZUWUFxSUVGRUpRYlZDSE52STQ4YWRIcWhDZUQ5d2QvZ0lSR2gwVnZvS1Q0?=
	=?utf-8?B?KytKazdCQXZVc1htTmV1T2lSMmhPNUxySjV0d3Z6aWlYUXBFRWhMc3lXb2hN?=
	=?utf-8?B?NEZ1aHJRYjE5UGVTWjFuTDhaL20xenpuZlNvWkszTUxJV0lGa2JjTTU4QXBj?=
	=?utf-8?B?Wk5FSVJsU0Rrckx6MmtBWno2a1AralZ6MjFZQklhc2pPL2taeWNJQk1BSVNU?=
	=?utf-8?B?K0prR0VZMjhvOWI4Y1Q0SjNOb0RDRkM4YWs5ckViMVIxL2Z5b1ZiYm9mYmZQ?=
	=?utf-8?B?MFhYa3RiYzF2QWc2bk1ubDAzZ3Q5SzI0MU5GQlV5Qk5ocjF5ekFubnREMmtr?=
	=?utf-8?B?WUMvVDdFdjZISytPbDVVdEFBdC9kMmFwY0tlMnhRM3NvNFFIT3NldjR1ZGRn?=
	=?utf-8?B?Umc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc7089a-8d42-4af5-bab0-08d9e6220a39
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 08:00:12.3217 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4MaQS0vpARn5mOeaqday7u/Z9eGwsHoVCtsLcQdlL/hQknTlHQQJu5+gfaguLpKq7GKQUb/EcdmRu9qTkjhB/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1595
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21280LU2027166
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Feb 2022 02:03:19 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>, Jens,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	=?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>, "kbus
	@imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9ABBCB9470793C4F894F4F286291C06A@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Mikulas,

On 2/1/22 10:33 AM, Mikulas Patocka wrote:
> External email: Use caution opening links or attachments
> 
> 
> This patch adds a new driver "nvme-debug". It uses memory as a backing
> store and it is used to test the copy offload functionality.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 


NVMe Controller specific memory backed features needs to go into
QEMU which are targeted for testing and debugging, just like what
we have done for NVMe ZNS QEMU support and not in kernel.

I don't see any special reason to make copy offload an exception.

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

