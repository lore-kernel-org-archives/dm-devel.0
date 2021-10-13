Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1A4C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0F39D610F9
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0F39D610F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-fAYUJbSjNbiCkTMeiWEUSA-1; Thu, 14 Oct 2021 03:53:38 -0400
X-MC-Unique: fAYUJbSjNbiCkTMeiWEUSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59AAB1018722;
	Thu, 14 Oct 2021 07:53:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D41A5F4EB;
	Thu, 14 Oct 2021 07:53:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 113D24EA3B;
	Thu, 14 Oct 2021 07:53:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DMZWeb003267 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 18:35:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C91FE114B2E6; Wed, 13 Oct 2021 22:35:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C26AA114B2E4
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:35:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C784C802A5E
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:35:29 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-435-7ckRpE12MdKfTQrjNWxysw-1; Wed, 13 Oct 2021 18:35:28 -0400
X-MC-Unique: 7ckRpE12MdKfTQrjNWxysw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MW2PR12MB2379.namprd12.prod.outlook.com (2603:10b6:907:9::24) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19;
	Wed, 13 Oct 2021 22:35:20 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4587.026;
	Wed, 13 Oct 2021 22:35:20 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 08/29] fs: use bdev_nr_sectors instead of open coding it
	in blkdev_max_block
Thread-Index: AQHXv/JvSmYjaLLNDU6tdxHW3kjL0avRhU6A
Date: Wed, 13 Oct 2021 22:35:20 +0000
Message-ID: <9d9cfa90-9fe6-23a7-ba13-c12d6fd59a0c@nvidia.com>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-9-hch@lst.de>
In-Reply-To: <20211013051042.1065752-9-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2e0c861-2d2f-4959-b152-08d98e99bd2a
x-ms-traffictypediagnostic: MW2PR12MB2379:
x-microsoft-antispam-prvs: <MW2PR12MB23796C9F89717482180CFF79A3B79@MW2PR12MB2379.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eHFSlRuhUHQ8IDX6BcDeRXbGTH8wwX7M0SVD4YXXb3HFK/HbK2U7RWGZQK/zqOGKUlEHyrU5O3+6x9pjkKtj10jU3xI1T5JdpyrOUUWDPND4tAKdEiUSitdpacTU0srpPIgGG4dpxJiqS2KJIrbA45x8kTXB3NCCvsLz+iODPBpL6WJf0sxUhk3S4Ve6RsrXAsDWNunxgudwLBf/nC9KpZ7Cr+PY4NLqxOWHs8Nl6yLfTaP3bdD5jmwz93UwAREywv+VTGvaesanR1PKBzD+i7z32QuReAhZARRVZh6odt8l8W/JqkQ3oPVzhawn3z//OtlHa9brUqvFfFkcs9INV9VkApfDg6c9UriW7fcBUhGVJubJF2DZ7xmwraXo6UbPC5tUbY4xo3JumySYtm2TEOtjL5O9b1R2IGSnIur86h+g5IwehDkU322Ja7fMkuJQNVr1P3iZsXQ4KxC0hItYjUw6rLqT30PKcBvCKKJWcGNwhm5PzgX4TIqTAFHLQedtNXWVSkItnOeED9Ch4fl38gS3+B5opdaY3RHD/eJbV2h1fGbfQGTFQDamnNqoc1a7NYChT3pTW/pVLNVqAulzIaU8Wf0V9S9HMQa7SMtjvr2/JQul7JmYWiKPgzp9WCYNlE6p03KEQfi7cTZx68SHBrhgUgHqEQ+wyFNbjvm6xp8iPxwVQhUPf0TZHbXtQGKoM9CwnDmjDPPVXn6021BmoEdRm5oEaJbDskS6HJXMKHCNc8JnZHS258D2kOeCkvDHo7BdsxVi7SGhJWDo2nXlCg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(508600001)(122000001)(38100700002)(36756003)(5660300002)(83380400001)(316002)(6506007)(91956017)(66476007)(76116006)(86362001)(6486002)(8936002)(8676002)(66556008)(4326008)(2616005)(2906002)(110136005)(54906003)(66446008)(6512007)(64756008)(186003)(66946007)(31686004)(53546011)(71200400001)(38070700005)(7416002)(558084003)(7406005)(31696002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3Y4dXJ0ekZUbGdWa3VIdlJVZU1TaVBFWEd5ZUJkeGZzUUZENytnaGc5bW5I?=
	=?utf-8?B?a1FOOEtvbjhmU0NGRHZIZWxJOE1qZ2VmOThRYWhWSjY0ZTViNjgvMlNYM2NZ?=
	=?utf-8?B?cHV6K2xTaTRNK2hUV1lxQWUwcDJGZ1JSclM4NktveStrd3F4T1ZBemVTYTll?=
	=?utf-8?B?dzA1TUhCM1Ixb3d1WkhyS2VIVkplNVZ1di94b0FlN0tDKzNzVzhybW9lM1dt?=
	=?utf-8?B?aFd1aEtYRnF2cG8zcTlJQjdoam81WGpmbFh0Y05vRjc4a3ZBNWJZSEFnNEVl?=
	=?utf-8?B?UHFZN29XSlp3NWFWWFlUTXpFK0Z2Y3lKQXBqZStuMlorR002MkUvNzdoWW1I?=
	=?utf-8?B?d0t3eWNzcStubHVEOXNEcWdmZ1hUWk1pM2kxaXVXSVRNTCtLM25TenlrcXhw?=
	=?utf-8?B?R0Jzd2xkVTlCY3RHVW9iNGs1WUZlWWd4bCtDRS9QVXhxUFJ2cXBUMi9GRHJu?=
	=?utf-8?B?eG1BV3hzbGhPODhOYnhaYmNvMFJvbU5OQWM1bWU5UzFMRUdXK0trMEwveHJL?=
	=?utf-8?B?YU80cDBjRFI4NCtuQ0w2cU94M1cwZkRPWVVuc1NPUitHdjY3WEQwVXB3QkRv?=
	=?utf-8?B?TWZDNnppWVFMLzZDdjlWNUZhb0Z0RWF5c3NwVzI1VEZqRE1tZjlnRXl3MWJU?=
	=?utf-8?B?VzBkclJlMVQ2WWpkbmlKcThFMkZWdjE2Z1hOVnhaQ0JGWmZXRkdjTEI1bHdj?=
	=?utf-8?B?RkIzamxzMkhUbGIxY2ZFdzBGUmVOSUo5REUvTmJpRS94NDZVYk5pNUFIZkpi?=
	=?utf-8?B?ZDhiVm1TKzFVMDRtV0FGSlh3WkprbnEweE0rTGltcHpReUdxV2tNeWhlK2Vz?=
	=?utf-8?B?Q2VQdzRzMmg0eStGY3B3a3hTZmJHeEtOM0RTbkltSFprRzVWS2ZmcmRyOGIz?=
	=?utf-8?B?TnFZNDkyOGFKMTdnUzFjRExrVENwNjQvRVVRZEZTdEFJTTNETU1sYlM1VExV?=
	=?utf-8?B?NGxQOVRQbWE2M1BVT09jc0Y3SWNwT09XMTFPdHZFdmhiWGNvZ2xKSGdwTGtM?=
	=?utf-8?B?WEdESjM0N0xrUEZHdHc3RXB1RWNwTzFub2xMOXpVMGpqbXJvSEhIS1duc1E2?=
	=?utf-8?B?dm50OERmQmo4Z0pNRHgvUDk1UTZxVG8xSHZzWTdtRVduRldtdzFxdVhLREdW?=
	=?utf-8?B?YWMyek9BRVNrNnNJb2VmcFJnRktnU013VG9jenVzaHM0V1hBQSsvTm41Ymo4?=
	=?utf-8?B?L2dLYkY5QjJJYjJUbzk1Tnc4bzBaMXVRdUF2UXFmUXFDUlV6T1lmdXpPdUwv?=
	=?utf-8?B?ZGRRL3JIZ2k4WUFGVi9WLzZKMy9HK0NFUnQvSlVhVkx2R0RTWHBQSGZTOVIy?=
	=?utf-8?B?R0NHbnpGcktOTldOZDdXRk42bk92NEIxWnorbjY5cTFqZWJCTGJreE11R0xt?=
	=?utf-8?B?MitIUG15aktrZWRRSnBia29wWkVRTTdadkR5c1c3Qm93WUxoRmR5bzBjSis2?=
	=?utf-8?B?RTNwNTZjSVIzL0EzblNRQXdTSzVEak5tMVdiYXZ2WVVFM0pGMjRQZU1FbWor?=
	=?utf-8?B?VXRUcXM4bEQrUCswVFlidFUzRERUQ29HRW5LUysySEk4bjBKaDhyQVNRdkxs?=
	=?utf-8?B?dDNSV2l0cTJ4NjJ2YjFZak1SQWR3cmlTa21tTmJ3d1RsSmRyLzBCN2xZckhr?=
	=?utf-8?B?aHZDdjBpVTMyUWpKd3RVY0tYOHhEdE9aTENVNmh1cGxuR1MwWGNqMXhJOENy?=
	=?utf-8?B?cFZVZUYxWkdyaDhZY0h1dnY1d1VvY1V5clc3cnBSY0h6cVVTVkpQQWlIMjgw?=
	=?utf-8?B?d1RUdjdhWmhXWVpKbEM2Z0lsRlZ2WVdhcDVObWJoVVRVTUU0VmxOODZPWUM1?=
	=?utf-8?B?VXJpTmUzdUwvTldkdm4zQzFnNUNGeUkwTURMYUVROStFWUg4djRDZjdHelZT?=
	=?utf-8?Q?CikUM/tCM+L+G?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e0c861-2d2f-4959-b152-08d98e99bd2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 22:35:20.3118 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfUYllkAJP2VhDJHr8FujDMwzcpd7R5DkTQqaR22BDbS+G/VzSdwL4PQAxAyGOmmeuL46k1Xq+kSWhSv5MhL/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2379
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19DMZWeb003267
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 14 Oct 2021 03:53:04 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
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
Subject: Re: [dm-devel] [PATCH 08/29] fs: use bdev_nr_sectors instead of
 open coding it in blkdev_max_block
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
Content-ID: <AC053E27003B5D4BB866AE7BB26E4310@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/12/2021 10:10 PM, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

