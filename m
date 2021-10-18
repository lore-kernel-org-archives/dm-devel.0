Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9143C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5311D60EBB
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5311D60EBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-WEOOZjTZORaYg1tpgmvO6Q-1; Mon, 18 Oct 2021 03:35:21 -0400
X-MC-Unique: WEOOZjTZORaYg1tpgmvO6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 978971006AA8;
	Mon, 18 Oct 2021 07:35:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A90F5BB0D;
	Mon, 18 Oct 2021 07:35:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 528391832DD5;
	Mon, 18 Oct 2021 07:35:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19I6Me2L010029 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 02:22:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DFD5FD7DFA; Mon, 18 Oct 2021 06:22:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9DD7D7B3C
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 06:22:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1B57899EC2
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 06:22:36 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
	(mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-125-2A_8dVoaMuuGhZs9ZvOkJg-1; Mon, 18 Oct 2021 02:22:33 -0400
X-MC-Unique: 2A_8dVoaMuuGhZs9ZvOkJg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1469.namprd12.prod.outlook.com (2603:10b6:301:10::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16;
	Mon, 18 Oct 2021 06:22:30 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4608.018;
	Mon, 18 Oct 2021 06:22:30 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 22/30] reiserfs: use bdev_nr_bytes instead of open coding
	it
Thread-Index: AQHXwcjMa97lH3N4IEKZw8BSKviaGqvYTXuA
Date: Mon, 18 Oct 2021 06:22:30 +0000
Message-ID: <16eaa7bd-3f47-47ef-2cbe-ae7f50779e56@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-23-hch@lst.de>
In-Reply-To: <20211015132643.1621913-23-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.1.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3beae86a-d8c4-4803-fe1b-08d991ffa9f3
x-ms-traffictypediagnostic: MWHPR12MB1469:
x-microsoft-antispam-prvs: <MWHPR12MB146922E43E8231B7FF4A2736A3BC9@MWHPR12MB1469.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:240
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Bm1xQodi9Wo6O1N8SoouA/AGi10l+Q4QcMio+B8L93PSW9NM03hCE+iYzbfWN1D6kFeO9dk56lBsss+J9QXSyYKZkob9/B5JUX3L27VD3ltXr4YUX1VPz62oJxjF83WqzKZrhS57cU1MBlsNFesor0VeAi69wLZYbwRL0j9/bRmoAHikPsoN39xomjz5+oYbjT1pcxlbTDdN3kPHcHISJdeiV9mRlBDKJlNfnZzfThpwRJSZkGiAJjhIfEKPg9JaysIjY/E2JSDdcMvQw9XLuyksI9UpbLY1bnqdubrmg3JoHBp5tFXqGTGrshtQTcOhaE6uYoMdxFGARspxvy2bWUDZ68GGVkkLnOqsXOOP9+6bd9urEb2czTn0MfNlKMCjKa+PQJ95dNgXRJIpEYioHvM6NV8ZKA+M9IFI+a2ehMjOYRxMoQdrMwEhVo2QMJ1NA5T5yvQM0TUdFtcuermPWOuhIBSjs5yYTqwjvf5Nosu9rA2XYY/4CNsecUxtoJ8u8x0mTBtysabHe4RGFhc/lI6o9zd6xwfqXBx4khcQDVEyt4T0mfUDl6lTGFKN4bjgiDBSYGUKJ+mBT4azKtu5to+oGNIJKmATC2pjjop1nBuCJC0M3AeDtw0S2uvrT6aJzS3aMOvCVMbBNxtwmpXgEjQvLRV+LfCMQv4v8gBH7vW5ENPg7zXl3/NaDfqC0shuGspvyz+/zTFIs7Zc3zxiZRqOciFBozIc9qAZEwSCZke7jvcjYGh+wdBD7+j24gWjwZfJN29IWrXLWeAQD1Dntw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(71200400001)(5660300002)(4326008)(8676002)(508600001)(122000001)(8936002)(558084003)(53546011)(2906002)(7416002)(6506007)(6486002)(6512007)(54906003)(38100700002)(31686004)(7406005)(31696002)(36756003)(83380400001)(316002)(110136005)(86362001)(66946007)(66556008)(66476007)(2616005)(64756008)(76116006)(38070700005)(91956017)(26005)(186003)(66446008)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWFKOHl1Z2cyaWdjK0FkWUtBN21raHRKUkFCcjAvVEhTVWtPOUVoUDBqWFNB?=
	=?utf-8?B?dmlGZE1tcnFuMW5qRVR1SmJCSDE3Uit1N2d0TG05WHBOMnU5Q1FTQy9YTWZw?=
	=?utf-8?B?QkNLeno2QzVKUVdRWDdSOXRpb3Z3dFlFbVYvZllma3NETUw1UGZUZWRLSFY3?=
	=?utf-8?B?SSsxYXBvbDE2c1UxeG9ocnQ5Qm5TSzQ2ek5wQnlEMHdNU25LL2h4bVBwUjRU?=
	=?utf-8?B?L0tmaDZ6dDZDZk9yVThwLzcybjMrc3ZtOXYzNkErUXUwbVBrYlBrZjlZWDJk?=
	=?utf-8?B?Q2t4Z3ZaUm04ckRwRGg5T0lkSDI0Y2RyUi9pRi9Qd0luQnA1dm9hWXJ1RWlL?=
	=?utf-8?B?anpraEtjUmpQTm10d1ZxU1ZKbWdFVk5xMm5DTFNtOHBvR2Y3cWRLOWFudWJR?=
	=?utf-8?B?bTROWE4yamVmWUczTy9wdTFDZUJoV1VmL1daTFMrR1B0bjllUHNqVGFucS9H?=
	=?utf-8?B?MTF6dUFTMUI1Vzl2eXZXcHF0UVVpaVdaQy90ZDBMSzVJMERLSjhNWXR4bDA3?=
	=?utf-8?B?UCtBZ0JqanozLzVDUmNFc24yNnZ1a3FRUy9XaS9JeEZKL050OUVLSmFrQXNk?=
	=?utf-8?B?ZHB2b3hNeWoxRHV4anBubFNrcDhrN2xQSWRENzdtVEc4NThuOUEzZTk4ZkZX?=
	=?utf-8?B?M0NpdVlyUkhTSW94bFJWeFlEa3hmV29yOThwTFR6cVgvc1VSSG9ZRWhEc0Zm?=
	=?utf-8?B?Mk1Nb1lQbnNqWk5EdHMydEFzckk5dVk1bEpXM004YkRacFFaN2JERDdOOE0v?=
	=?utf-8?B?SmlreTJiUVZ5dXF4ZENvVU92UmhXTEM2dkVsSDVIV0VHT2hMYTU1bXcxUHRh?=
	=?utf-8?B?UUt2UkowTDZLWjdCQi96SnR1Ynd3UW1oSWl3dG5lQ09LMTRGS2RPS0xJaFB5?=
	=?utf-8?B?bk4rR0U0OVA5enhQR2xXRUhFaGZ2N3hSMy9sMFhPUDVLUnVJLzVVNG5Ma2dz?=
	=?utf-8?B?UitUb3NSZ3RzM2dRRTJ2VktMSE54YTFtc1E4Q1NaVUFhMjZycE16Mlk4RnV5?=
	=?utf-8?B?alN3dytqMEpPSS9KTzRWcFE1Q2N4c3ZHQUMxNVV1bzRsc0dCVmRpZHZ2a0ta?=
	=?utf-8?B?VjRSVEw4RTZpb2ZDTmpRNy9oTEk3Tk5ZcDBlMlgyZDltaHd6blg0eFdaZUpv?=
	=?utf-8?B?ZG9ibnVsUldDenBNVU9hN2pZV2FzUEJBbGx6ak5Zak9KSm5yeHp2WWp0UERF?=
	=?utf-8?B?SFRON1BmZzlDUyt1ZVJ3dWtzZjlpQzhYa2NhUUx5ZEpTTzJsbWRFSS8wdlRE?=
	=?utf-8?B?emRkT1hpRWNSUkdlUkZsZUlmdjN5RVFPRFVONno3bnVJaFFCWWg0b1J2TUwx?=
	=?utf-8?B?TFlEQTFOT3M4cmRQb0l6VkRHeUhGWVNYSmFpVXQvZXUrYUFqYnNiRTg0Z0ha?=
	=?utf-8?B?MWhPbmN6ZFJPSkZiQW5HYlBlTDB0VVM0RDZuL0p3MzNNTllHcTh6OXI4THcx?=
	=?utf-8?B?ZXFxMjh5VGxnVjBNczVtOW1VeHZRbFRJdUU0UGFPbUtYWFVzOGZyZWtlRUVL?=
	=?utf-8?B?MUlpZlI2T2orUmw5TGUzejY1dXRBVmxrbUVEYlhVcHYrT2pVRHBraklNVm93?=
	=?utf-8?B?ZWhVRURoa0UyazYwMnJGTHNRZTVkcnR6Y2pBejlzbm5zeHQ4bGRYOUZIZU0x?=
	=?utf-8?B?OVc1OWpva25ha1E4TzFpRDVkWS9obW1zeEFzQnBBclJwUlg0SmNaSjNNWEd0?=
	=?utf-8?B?cHdNYlRPK1FkQVJZVSsyT01LNmVvNThsSi9xaVNKbkJ4Qy9RNDgrMWR2dGVR?=
	=?utf-8?Q?Js80tRzfIxjbLNqCAk=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3beae86a-d8c4-4803-fe1b-08d991ffa9f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 06:22:30.2664 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9DYXg1xgl5Dh05S6iVACmdhqBMmZpyS4LAv7vzEY/lC6u9I1ny6yBCvI5G7y7upEjuQJMKRy7a+NWd4tMKv/4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1469
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19I6Me2L010029
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 18 Oct 2021 03:34:40 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Ryusuke,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, "linux-ntfs-dev@lists.sourceforge.net"
	<linux-ntfs-dev@lists.sourceforge.net>, Jan Kara <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	"ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 22/30] reiserfs: use bdev_nr_bytes instead of
 open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1D52234084563549BE0202AC74D36824@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/15/21 06:26, Christoph Hellwig wrote:
> Use the proper helper to read the block device size and remove two
> cargo culted checks that can't be false.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

