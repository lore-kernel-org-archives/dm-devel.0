Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F4CC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8BF30610A6
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8BF30610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-cUpapeiXMZiUHjkiahokJg-1; Mon, 18 Oct 2021 03:35:19 -0400
X-MC-Unique: cUpapeiXMZiUHjkiahokJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED91C802575;
	Mon, 18 Oct 2021 07:35:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE4B417CD9;
	Mon, 18 Oct 2021 07:35:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9D3C34EA37;
	Mon, 18 Oct 2021 07:35:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19I5n67i006948 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 01:49:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DE4FE2026D48; Mon, 18 Oct 2021 05:49:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D85662026D46
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:49:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F78918A0160
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:49:03 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com
	(mail-bn1nam07on2066.outbound.protection.outlook.com [40.107.212.66])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-271-dl3FSA6bP4i2kZBCjfLFbA-2; Mon, 18 Oct 2021 01:48:59 -0400
X-MC-Unique: dl3FSA6bP4i2kZBCjfLFbA-2
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1885.namprd12.prod.outlook.com (2603:10b6:300:114::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15;
	Mon, 18 Oct 2021 05:48:50 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4608.018;
	Mon, 18 Oct 2021 05:48:50 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 26/30] ext4: use sb_bdev_nr_blocks
Thread-Index: AQHXwcj4vQTXKLQZv0aVSDKRGKA1zavYRBQA
Date: Mon, 18 Oct 2021 05:48:50 +0000
Message-ID: <1e40ed5d-e21f-b435-a4e5-fddceb1aec98@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-27-hch@lst.de>
In-Reply-To: <20211015132643.1621913-27-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.1.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 830464a0-4a07-4339-ffb0-08d991faf609
x-ms-traffictypediagnostic: MWHPR12MB1885:
x-microsoft-antispam-prvs: <MWHPR12MB188504F8BBFE3FFFFEE55443A3BC9@MWHPR12MB1885.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:185
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wHBpUaTTgaDGnI//U15jsw62OzVazRfv67vDtAnAW7TI98WywSXkMnlSyNqY0gGDtfcNovT0jUgN0B4eZXLjW8lxQuuy8UuTr6oiMw62M1mci+VtopwBUVLJYeBAurbmoxquKBMs3E0hpRb6E64+4hdpFno/l4oV+swaHruvw0QQsnbz46rmNF88A1XtdfPSHL7M5g5ILhSfzUBriURkG0WsrlFy00YjsbP/P3oOciWu4jbw+URUjZZtOR1VIt9g2PyFFPTzph+BkMNb/3AC2KIdptxO5T4PnbhByqIlKMUmJPalyxEN5yXzG5VS+URLVFsl60WtlvUIhIjAQ7x5mo4cRI2xrsx9V8MlrR49L6B+UMLlm3Njh+NEQwHMvl3jKTssf00uP64VkBJUCfnkF3aNMlF8dbuILlShn7CKWwsHcs8VYLdRUoyQ82YldF79xI/Ole8AAG0NZ3DiVCEYKYTFA0lqqY4iRgZ9tqURUej53AMAzaJlyWru2+ziW2E/uKumtOycn90o7Y4hR+q2UuhyD9MNdzXpYvmP81unuU4Ix0k36fTq1rJvghbaIayrLItMAqUcmVKlijO0CoQDn6z8bgNjJmVU4bUA0MlH6s1FIUTP38+BDGbLHRKFPHoTBtgq6NOt1Rh6fXiakKQ72W1PfpjwJSMCKn1Qq6c+u/1HqQIQXDYm2UZCK7QebonT81eBdWdOPBGkrj3oQ70cfI1A2T4gnM6U5y1knz5v7x8HovegWVXjUAslA/O/Q2lBsod4rSVmJ/PGhAFwLn1OMw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(4326008)(8676002)(36756003)(8936002)(26005)(508600001)(2616005)(53546011)(5660300002)(38100700002)(66446008)(66556008)(31696002)(7406005)(91956017)(38070700005)(54906003)(186003)(558084003)(76116006)(64756008)(66476007)(316002)(66946007)(6512007)(83380400001)(7416002)(110136005)(71200400001)(86362001)(6506007)(6486002)(2906002)(31686004)(122000001)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTIvaUhtK2l5RU54bmFiYXF1Rm95Q09PSXU4NTVna3lGdllISm5YL0w5b28z?=
	=?utf-8?B?MU5XbVBZQXM1Uk1QNXFMNEtUU2dZbGR5UmFvdVJGZHNCdEc4ZWdhSnZrZXVz?=
	=?utf-8?B?djVobjZweXZvaDUwK3RJVHl4RERmekJqUnRVM0E5R0xFSFpXOGtaa1BWaU9Q?=
	=?utf-8?B?ekQ4OGhFMnBEUHhoN1ZMTG1uaFd5RHRqbnhMb2pOUnVhQVEyMTBTbEd3R21L?=
	=?utf-8?B?aUhyK1hCQTE2UDZTVkVyVVZJOThOek9zTEkwZmQ1Y1B5OWhhTW04SHVndzZT?=
	=?utf-8?B?MHo1dHhoYWFJZnJwVWlCVzlsL3UvTTg4cWM3Vm1DK09sKy9IL1ZJOStlbUlD?=
	=?utf-8?B?ZGV1N0dLbGVLWklSSTIwNTI3UlNNTnZHS0lRaW1SZHdkNkZvN1NwSGZBT01l?=
	=?utf-8?B?aWplZzUrRnh5SVk0VWwreE1mdjQ5VDlGWUJPZ1lRZTU2RGxNRzUxMVRVd3A5?=
	=?utf-8?B?K2JndlNGdk5rNVBRemcrVjZuZGpkYUE3emJvNXhJczdXWkV1d3ZoYjNhY3Y0?=
	=?utf-8?B?N3JkQnlUT3NjSnh2c21MRjMwNFV3QThydk1CUklvd3hYb0x6U1BDVE5RZk5Q?=
	=?utf-8?B?cGU2L1V4ckJoS2xJK1ZJa3IyeG1DYVRYVHY0cWEySTRKaUFiOVY3K2Ziai9r?=
	=?utf-8?B?c3ZXTDhWY2E5WmJtYmxTZjhqN1JzVE9hOTBaV0J1b0IvekF2OHpVMkVoSkFv?=
	=?utf-8?B?M2laN2EvMmlxOXZjMHpVWU96SjBsUFdmZ3k3d09mWTl1aFFud1oycVlJUk15?=
	=?utf-8?B?dy9UZUI0d2ZsdStEaXZIWGZYSzlFL05BOTVFbTVENkxMS3ZTQU1jUWwvRVM1?=
	=?utf-8?B?aW5hdGhOTS9CT0swY05hUENiQVFpNEgwZElHQU1RNGs4U1ROejloNERlWjUy?=
	=?utf-8?B?THMyeSt2U0NJM1ZDV2JGc2tsSlFmS21hRUcvSUxRSzB6cTVWM3VkRmFUWi9q?=
	=?utf-8?B?d2FHUmR0dDloQ3VVUDBTdXh3RnhJUnl3YzF4TmtYb0UxNHBKQ3NSNEtDbmtG?=
	=?utf-8?B?STRyZW40aEFOR2VOSFpoaUVNaElYMDd0dzBLcEk0SDgwZ3RNcUlzdTlBaDVV?=
	=?utf-8?B?NEN0U0p1MmZ4aG92WTJGbm5VVHVEVkFxYXRuNHV5Q2tYeHVSNVRMN1V4OTBB?=
	=?utf-8?B?N2FLc2FnVGFHOThtZFdxbzJIRGptd0dqQk1oY29BbTMvek1yNjB5aUVXbGpH?=
	=?utf-8?B?cDNKTmc3MnpBa3VXM1NvaXB0WnRjdWZxVjFpRnRGcVBWV0puVWswc1hrK29v?=
	=?utf-8?B?aHNTczB1ZEZoR25TSWdKb2VaMjlISHk4L2VMTm5NN1haOVFMNG5nUWQ3MmhD?=
	=?utf-8?B?U2tzQXVvSW9YRFFTUGRYRFk4LzRScW1PZHlMbm5hZVltNis5RzBSeGpRZkwv?=
	=?utf-8?B?cVNnL0d4V1NSdFd4T2x5SjNvaVhGaTMzRUlKN1BpNnhVNkw4SkhzRG1MZ0RC?=
	=?utf-8?B?OTZOY1ZrOWdHV3dHVnloekFldWRnL1dkTkpnSWlFUlJYazJrTnFrYzJwSG01?=
	=?utf-8?B?K0U0bGxYbkFkYmVUd29na21IL0FuSlR5d2cvZXVtY2IvODJqbURuSUo2VVpD?=
	=?utf-8?B?Z0dWVWgyaWNaeE0zZGdaeW1kWDN1dXJocUNOM3hKTE9FUVNDWDJmM2FMeGtw?=
	=?utf-8?B?bWp2OWxjVDNZenI3YUNONklVY1VtZUd1LzEydmtKL0lydDZsRG1EdGliT0d3?=
	=?utf-8?B?cGZ4cUlnbE1MeE14WDh1MFVZbWVrQzBMa1hwczFqQ1V1SmVjbWxxNnlvN0h0?=
	=?utf-8?Q?x0tECZJqXb6mIjw0VY=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830464a0-4a07-4339-ffb0-08d991faf609
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 05:48:50.4178 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ClwBmgBzELKOYexH6VUAXdCzEBfe721/+WVotWwdFYaGb7C9dOLjtZBp1EZ00uK9511RKwMa9+wRrnjunEdWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1885
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19I5n67i006948
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
Subject: Re: [dm-devel] [PATCH 26/30] ext4: use sb_bdev_nr_blocks
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <BCC697D6D15CC447B9C6C8675F0B9C0F@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/15/21 06:26, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Acked-by: Theodore Ts'o <tytso@mit.edu>
>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

