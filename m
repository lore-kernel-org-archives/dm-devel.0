Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60DCC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8F79A6124F
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F79A6124F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-jVzs0LxTOEKfxfgv3YH7Rw-1; Mon, 18 Oct 2021 03:35:06 -0400
X-MC-Unique: jVzs0LxTOEKfxfgv3YH7Rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A3699F92B;
	Mon, 18 Oct 2021 07:35:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B2F44180;
	Mon, 18 Oct 2021 07:35:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 445514E58E;
	Mon, 18 Oct 2021 07:35:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19I5r96R007244 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 01:53:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5267DD7DE2; Mon, 18 Oct 2021 05:53:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA14CD7E07
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:53:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BACE18A01A9
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 05:53:06 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com
	(mail-bn1nam07on2066.outbound.protection.outlook.com [40.107.212.66])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-271--Ic2iDt6N6uiXwvRNBz1nQ-1; Mon, 18 Oct 2021 01:48:18 -0400
X-MC-Unique: -Ic2iDt6N6uiXwvRNBz1nQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1885.namprd12.prod.outlook.com (2603:10b6:300:114::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15;
	Mon, 18 Oct 2021 05:48:14 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4608.018;
	Mon, 18 Oct 2021 05:48:14 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 25/30] block: add a sb_bdev_nr_blocks helper
Thread-Index: AQHXwcjkKdwm0t7mp0iS/ZytkYe2sKvYQ+kA
Date: Mon, 18 Oct 2021 05:48:14 +0000
Message-ID: <04beef49-8269-3120-517a-111357ecd2db@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-26-hch@lst.de>
In-Reply-To: <20211015132643.1621913-26-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.1.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bbed4ee-d0a9-4f39-591c-08d991fae0d9
x-ms-traffictypediagnostic: MWHPR12MB1885:
x-microsoft-antispam-prvs: <MWHPR12MB1885B9BBADDA4839CF6512AFA3BC9@MWHPR12MB1885.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hSe2I+m7J6c8A6D6F3+e5roOGz4eMa4Un+ORKKNoe+CH6CmMQZDIk2ZYHSnb2qNA7lm4qTjMmpRZzy+cBB/zOVzkPY3SSwpjOIIuTU1chI2f2btt4SjfcAXL7/ItBpfoX5aMNyoleKBk7D7RIlAf6xKEkrKI5iiKgqXXDaEEsX0uKXZSdATdMUEiM6lQmvDLToMCvdzx4FTnhlBsMaNq0lMAclPI1DgyPudNs8StJlNBvv2qoBEGASV8PUc4HTdO2HYImXj5jg1dYa/AygP+w+tMFoJ0+pGMjjVxDqhknPs00Py11uJGZw6CWIpA4uV/+R37Imxb/mxlCcB9sCmddrxV+LjvES3O71kjmrmbboG3GOFyZRMKQF4S7FB2xzXb2Jru0X9kzxhFAwLM8j6lJVWnxEVMmdZtkUCDyo1MOavNREqow+TUQjx5F0bMGrC5HaFSyKl23kfXEHF2rXr+wT9TZR898BgHJvc8XKtpGk69oEzJgK0BxE5hYI+pOihJ1vFc+glie8tDJi8Bn+wzH6J8XG/8/eIWykBZm8+fiM4LA7jSdYCPo/0oJovRSVQxYhF94gzZZBvXrs6MG+BMgWoZtXGdZyg/C0wEBliLxzt1aFQfLHhgPhWDuBkyEkehCALX57T5tG2ufm8k+wkbdL4PL12vbjzMieyIK4fEY+B66yPo+J1DSxrHtWUqkToE4fd6Mo2WhRvlg/tOC+dlE/29KnaITXo4YLHEhzDkPZW1cGVVUWqC4LMltBWrxMgxJshcAd5Leaas74B+VWbyNw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(4326008)(8676002)(36756003)(8936002)(26005)(4744005)(508600001)(2616005)(53546011)(5660300002)(38100700002)(66446008)(66556008)(31696002)(7406005)(91956017)(38070700005)(54906003)(186003)(76116006)(64756008)(66476007)(316002)(66946007)(6512007)(83380400001)(7416002)(110136005)(71200400001)(86362001)(6506007)(6486002)(2906002)(31686004)(122000001)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFBTcTdJb1lwclZrb3ZHMHJ6N0d0VGdRSlhseEdMeXNNOWRkVWtNaWcyd1c0?=
	=?utf-8?B?MjRObWxVaHJBdVhJN0lRSUcra1ZnK2gxUkYxVFhlK2FBYVJWYk9vS0VMQjl6?=
	=?utf-8?B?NlI3dEQrdlRqVVZjRnZpSFJRa3VSMkdnM0RtU09aakpoTjFWcmJIUDVQTzR6?=
	=?utf-8?B?UmN5ZDJ3TUt0bW0wc2UxbkFNZlVDQVZpMUhQeUY5VDdod2dFaEttMjBWeVF3?=
	=?utf-8?B?aTZ5K3cwZ3l0b2RON1gwQmRpcFl0M1V1YVcwMytXckRpMFFLc09leFZiZmF4?=
	=?utf-8?B?V1BMbE1XT0h5ODlkOWJ5NXFlNDhOQzFVRE1JQVc1VHBrNzFkQlBYM0JXdzhm?=
	=?utf-8?B?SitaeDFNWWVjS0V1NVlpQXdMckJEekhSMkorNTJLeE1xSHpab1FtTnZLTzRo?=
	=?utf-8?B?ZnFOQ3B3ajRGSFYyVTNYd090L2NYRkhaRnc0Ynp5QzBPc2pwMGJCWE9YVHlv?=
	=?utf-8?B?TUpJdmEwMlZzNGY2NTJRTXBBUExpVjlsK0YycUk0QjlXTlNiR1UxVlhnckpy?=
	=?utf-8?B?WFpzV2l2b2ZGRDBLa3ZuSmJoTWtsSEx3dWNuMzc5Y3lUaGN6Ym1ENlE0dWJH?=
	=?utf-8?B?cnZaL0tpbllsSTZtQi9HQUtNMWFkeFJUaFdaSmpMVUMvL25tTTFISGpCa3Q1?=
	=?utf-8?B?alhIN2xscmt6RWJrYnozcHNXQmh2dlp4VlRtZHJpU0Vnd3JjeFZwY21mRjNa?=
	=?utf-8?B?RTk2Rm0zNXMrdUY4NC83MytUY01OdUxFaXVGbjdWRldRTzdod0xKSkw2aUNB?=
	=?utf-8?B?RXJ0NU9TMi9nZzhVMHZNYnJOd1RWZU00MTc5SGZSRGw1WjEwcWJZVUkvSkYr?=
	=?utf-8?B?TG9sTTA4ckY0QWMwSzd0dmk2cmJOT2V2czZUVFlnOE4wV0JwTDMwZlc5UGdp?=
	=?utf-8?B?aE4zMW16clRqRUxaR1NuMHU2L2RzaU1Wc1BKMm9xcXk1V085bC9Vb0RvWFQ0?=
	=?utf-8?B?OVA5bWw0SGhlRkplaDFHU3U1azhORlVZQUJzWERVUys4c1ljWDErdmxVRUQw?=
	=?utf-8?B?NWtZeCtwKytpVVM0WkM4ZnNTZHhBQ3RqSVdaaXdXUERpamIzT3gxWlM3ZTZl?=
	=?utf-8?B?VGdPUEdlLzFhOVpIR1hzWVJUbFd6RUp3RnpSUEYrWWhxZ1NuTmpxVmp2cGpj?=
	=?utf-8?B?M3lxWG1JME9RTEZaekc0aGRDZmgraXduV1Ayb3lqNXhWVDJRUml6UVhnZUZm?=
	=?utf-8?B?dWVVRlFrOVVMaVVsQUo2V2xzSnRZZ2hqcU8xUFZwSjVoNCtYWnZVSkdqOVNB?=
	=?utf-8?B?eEFkVEVOMHhJWmNtTjgvMVBpV2F2YnpMeFhwVEVPVExaZS9pYzd1emliUFFK?=
	=?utf-8?B?bzR3ZHg3T3E0OUNra25PbGsrWkI0ZXhKQVpEdU9td25ocFVVNlgxY1Jmb1I4?=
	=?utf-8?B?UVpraUtmZjIzTzlHd3hseGZSck04MlltdUZYT2NCRU5lYlJlamhtRlBmMGRX?=
	=?utf-8?B?ZitSWlRUTHVxU3BsT3B2Z1lENlhJeHBMM085Ukkxc3JZRFJReEh0SmxvRE5H?=
	=?utf-8?B?aHhmNjNzYXMxWllqOFczTHhka1Y5OUUya1JVWXZMWXZ2Q3NPNDJ1UmVkYVFU?=
	=?utf-8?B?R0FQdUhFeW05cFc3TW9DT29NdmtQeGtEbUJRSG9lZWk4ZVZ2YlVCMktsZThX?=
	=?utf-8?B?cDhBYUNtWk5FK3RHRFhoaUJBeDEyM0ozQnVyaWltaTBBUE53UXZjalppWkVi?=
	=?utf-8?B?SDNJcFFUUXM1clpGMWNKRmljY2U4ak9TcGJUajBqK1ROYXJzWmRwTjhSdDM1?=
	=?utf-8?Q?4yUf7BXWuRRztrJ7+8=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bbed4ee-d0a9-4f39-591c-08d991fae0d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 05:48:14.8688 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lGZyDBf7iL41ojT9aO49rUs19j516JBvfEkX6eJAlHp0O2vCw1t0Lr/q1uiKTUjHoQl80y0EG5z+FPC9owhPsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1885
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19I5r96R007244
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 18 Oct 2021 03:34:40 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, Mike Snitzer <snitzer@redhat.com>,
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
Subject: Re: [dm-devel] [PATCH 25/30] block: add a sb_bdev_nr_blocks helper
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
Content-ID: <E92FCF7DB99A724CBD69B890C7E02284@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/15/21 06:26, Christoph Hellwig wrote:
> Add a helper to return the size of sb->s_bdev in sb->s_blocksize_bits
> based unites.  Note that SECTOR_SHIFT has to be open coded due to
> include dependency issues for now, but I have a plan to sort that out
> eventually.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chiatanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

