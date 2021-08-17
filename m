Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D434C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 02:00:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E1D560F55
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 02:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1E1D560F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-jtK-wiGPMQm-O8EKeB5bLA-1; Mon, 16 Aug 2021 22:00:22 -0400
X-MC-Unique: jtK-wiGPMQm-O8EKeB5bLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E83DA801AC0;
	Tue, 17 Aug 2021 02:00:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AAC81045D1C;
	Tue, 17 Aug 2021 02:00:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1014D4BB7C;
	Tue, 17 Aug 2021 02:00:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17H20E16028740 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Aug 2021 22:00:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 39DB2201B065; Tue, 17 Aug 2021 02:00:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33FB7201B067
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 02:00:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73BCA8D1386
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 02:00:11 +0000 (UTC)
Received: from esa16.fujitsucc.c3s2.iphmx.com
	(esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-316-Dy5ctJXtPdygyxFdKJO67A-1;
	Mon, 16 Aug 2021 22:00:04 -0400
X-MC-Unique: Dy5ctJXtPdygyxFdKJO67A-1
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="36784935"
X-IronPort-AV: E=Sophos;i="5.84,327,1620658800"; d="scan'208";a="36784935"
Received: from mail-ty1jpn01lp2053.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.53])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 10:59:59 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSBPR01MB2261.jpnprd01.prod.outlook.com (2603:1096:603:25::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18;
	Tue, 17 Aug 2021 01:59:56 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb%6]) with mapi id 15.20.4415.023;
	Tue, 17 Aug 2021 01:59:56 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Jane Chu <jane.chu@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH RESEND v6 8/9] md: Implement dax_holder_operations
Thread-Index: AQHXhSopehJgFSDaDkGtTOEeGatGUKtlryUAgBFalfA=
Date: Tue, 17 Aug 2021 01:59:56 +0000
Message-ID: <OSBPR01MB2920473CC67AC99C3947B2C5F4FE9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-9-ruansy.fnst@fujitsu.com>
	<4573e358-ff39-3627-6844-8a301d154d3e@oracle.com>
In-Reply-To: <4573e358-ff39-3627-6844-8a301d154d3e@oracle.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4cb0254-1af2-4fd0-259f-08d96122b632
x-ms-traffictypediagnostic: OSBPR01MB2261:
x-microsoft-antispam-prvs: <OSBPR01MB226182C387CBCD43108E0685F4FE9@OSBPR01MB2261.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VYGjrMLKa95Xr8fP1z1uF3GdghjbHGdZlIindImlKBUMhk3dB5h1F003YBmui1qj3qrCbH+K5vZuWajsL4/VEa8yq/rDBJ/v7PTFsLVHlENg1H/lL+CX68UYMeioDjfFaaDtwH5fdjrn2QcCw4XKfhS6wf1/UA2qM2lrig5ZDvyL7VhH10lbSl7DeeUhnysXd4P+2LgkwY5eTwWu2W3hDS26kEJdjBVeHMautrhHA+sHAbN01DHkHxJvQdKlqIJ6F5dqOh0XJDPd3bUuSOoC4IEj6bFPO56WQXe9zuKRgVAzH4v/wF0EtzGac6DlG0w7nY2B1s5dhyHzzTpwG3TAxib8qZ8PkuvxpN6edRCg/0DjXktwPPnfc1Z+IL4oEtLMxJJcZi1uDcf8zSBbmmQvhtkv9zFUIhHnYu51MJqAW4ecv528GFeI7XjN0XMhd82PFDB/jocD0QscN/PJWaoPlG7GGcP4l4/5J5A5swueJkxRY/zocNuLQthJ/WqWuXYOK2vkXusppCpwXlTMVqM92BtcwrhT/buvm5cRRwYpbhcJPhKlzh3K2/7nHtDPNVHS1h2iT+Qgo3pJFYdM5+gW0Sh/TJQ1BFCSSxzmYYPPdOHrvSCvBpsKzsH2orJ+w4VjfEvvRU1wDf1wZjrlXHW5E+QvSrVaYlssAFpNxmvrUQExL6Fwk9X5dfiSakJo7bsdDpkHRBTp+Bgom/fI4msH0g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(55016002)(83380400001)(7696005)(186003)(4326008)(9686003)(86362001)(52536014)(33656002)(85182001)(508600001)(66946007)(6506007)(5660300002)(71200400001)(316002)(8936002)(53546011)(66476007)(66556008)(66446008)(64756008)(38070700005)(38100700002)(110136005)(8676002)(76116006)(26005)(122000001)(54906003)(7416002)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzB0ZTZPS1FScGhsczF0T3FlOE0vMlN0cllxRk1IN0d6WkpXNTBhU1JpTDRr?=
	=?utf-8?B?TUZ1M3BLSnJWQXdod0p4Z3pCbDdrcWZISHA4RkJ1a3d2RG4yR0N3cFpmVTZO?=
	=?utf-8?B?Y3o5U0Z0OTc1YUJlYlpIVGJqaUxFYWlVZWlRR0Q0VlFtYUZHdFNFN2pQYlpN?=
	=?utf-8?B?cGQwOFB6aDB6T2pTVHpkRDJIYmIyY21jZGxsS1BaRWg0VURjZTRqNy9wSGor?=
	=?utf-8?B?ajlXeFZScHdPUm9aaFRCdEVBS2hMSjhWSXpmV3dCa3FQVFNFQ2FXcVlLVHNE?=
	=?utf-8?B?aGFzblJCNlZWbVlrWmZLRkxpSEY5ZVJ2UVEyNGFiZHJnMTJBYks0a20vUlZE?=
	=?utf-8?B?c3RMV1RPL2pDNkR6OGlXem9OUGxhTUJ1aDdLaTYvM2htNEg2Wm1CL1ptYVRF?=
	=?utf-8?B?QU9UbVBBQUlNWUhSK1dObll5N1JZdnh2MkhBQ1BST3o5ZndDd3pKUDlHOFpi?=
	=?utf-8?B?UTJaa3d4SGhQZEZzSWZuOEcwd3NhdjRvOG0rbjRmZVh3ZmozcysvZmJpS1dR?=
	=?utf-8?B?NFFwVXo3OGJEZExJK1dOZEUrK1FqODcwaXdoZG0wT3I5TGNCK0VoZllCL2wr?=
	=?utf-8?B?WSsvb2RjbjgzdHBiZnhjL1FvMks4Z3duWEpJK0h2ZHRsMmkxTVRXSWdidlhL?=
	=?utf-8?B?Njd4L0QzMFhSc1hoY0szQkVEZGRsUXRnbkwzQVQ3ZzEvbnZtanFVZkpRNlBX?=
	=?utf-8?B?ZDlMb0VoY0FveFBuRkpYUVdEeVpuUWtneWZ3STM4VVJrMkNsWEp0dE8xeWcz?=
	=?utf-8?B?ODhROFJBS1I1TWdPeVhISUp3N244dkJhV25DQitRdTZkUVpEeHU4d1JWbDd2?=
	=?utf-8?B?dk1TMWdlN2RNYVA1a2djdW8yQnNQOGhjeWVJdHJpV0VvcTY4bUNpdkJvSVBH?=
	=?utf-8?B?bkE3RHR0WFJFWVdGTnQwOGErQXhYUkVlWGVUM3lSSXk2Rk1STTVHM0NpTlUw?=
	=?utf-8?B?NGZSWURnV1VBUldEYmoySjFGalBpaDlIOGlRRzNCOHNmYWdDZC9TbE9OTThr?=
	=?utf-8?B?aFo4Q01SclpoMFozUWdVWmxtcEdsNStaeFVkeEIwOU4rR0I4OTNLVVZnb3Rl?=
	=?utf-8?B?dXdYSFNySVAyQzlIbGoyam1ETi9VWHdOcXZSQVI3bGxIaVBHMHhpQ244TStK?=
	=?utf-8?B?WC9iNVZZVkVYb3YxWW1BT3BWR2xVWnM5RDNLcWFwRm03NGpTR0lnMGRGYThl?=
	=?utf-8?B?eFcwaWM1TkxQRW8wa2xBNmlnWXl2QXY1bWtmNkdVQzhYcWVrQ0ozUFdYZmdJ?=
	=?utf-8?B?SXJ3YlU3N3lETlI1TmtGR0JQRjk3TE5nanpXaURmMjZYSHdWZW5PWWFZd3RH?=
	=?utf-8?B?YjBvTlJqNHlkRDZuVWNRZ1lSdXNDeXZ2T1VxQmJWNG9HK1paRHRHK3hTOUpx?=
	=?utf-8?B?cGxrRHc4RUtwK05GYmZ2Vi9lYUZJSTRHTGUvUzZjSUk0U043WEpWODJoMTdl?=
	=?utf-8?B?T3h2N0xVU0xCdytFdzhWYmtKc3R0Z1VQZ095cTkycXBySFNBbUpxUEVHRlhD?=
	=?utf-8?B?cnNvZTdhYk4ybjRHSjVnck85Q2RoNHZERzY4WFV3cG5KSkNSemVaUDl0cnE3?=
	=?utf-8?B?UlJSYXRVT0VGS05icDNTKzZRRm9rQ0tqUG5qREN1ZGQ5WnpFNVRVcEJUUDBm?=
	=?utf-8?B?S3AwZjdTM1ZlZWVtbFFhMXVXYUlEYWRrb0NLd1J2ODE2WHdva1lOY0lCR3dt?=
	=?utf-8?B?SzdPVnlLZWNRMnM2dkROQ0dERU1FOFBvNXR5REtTMmZMaDV4ZGI0N2pBYlZk?=
	=?utf-8?Q?pVgaHGZO/C0eAX0crUJaId8engNYTCN+JeJ7Jan?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cb0254-1af2-4fd0-259f-08d96122b632
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 01:59:56.2248 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DdbpO3aLhwdXCFVjeFWrnOGx16OQaGwGyT4jU8rdsB1h5UHzKGYxzSayt6iRdNUiv3ci90MGO7CNp8AdhHef7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2261
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17H20E16028740
X-loop: dm-devel@redhat.com
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 8/9] md: Implement
	dax_holder_operations
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
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> -----Original Message-----
> From: Jane Chu <jane.chu@oracle.com>
> Subject: Re: [PATCH RESEND v6 8/9] md: Implement dax_holder_operations
> 
> On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> > This is the case where the holder represents a mapped device, or a
> > list of mapped devices more exactly(because it is possible to create
> > more than one mapped device on one pmem device).
> 
> Could you share how do you test this scenario?

Do you mean "more than one mapped device on one pmem device"?

1. Create 2 partitions on a pmem device(fsdax mode).
2. Create LVM(one LV) on each partition.
3. Create xfs filesystem on each LVM.
4. Memory failure on this pmem.

In this case, there are 2 LVMs on one pmem device.  So we should register this 2 LVMs in dax_holder, and iterate them when notifying the failure.

--
Thanks,
Ruan.

> 
> thanks,
> -jane
> 
> >
> > Find out which mapped device the offset belongs to, and translate the
> > offset from target device to mapped device.  When it is done, call
> > dax_corrupted_range() for the holder of this mapped device.
> >
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >   drivers/md/dm.c | 126
> +++++++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 125 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c index
> > 2c5f9e585211..a35b9a97a73f 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -626,7 +626,11 @@ static void dm_put_live_table_fast(struct
> mapped_device *md) __releases(RCU)
> >   }
> >
> >   static char *_dm_claim_ptr = "I belong to device-mapper";
> > -
> > +static const struct dax_holder_operations dm_dax_holder_ops; struct
> > +dm_holder {
> > +	struct list_head list;
> > +	struct mapped_device *md;
> > +};
> >   /*
> >    * Open a table device so we can use it as a map destination.
> >    */
> > @@ -634,6 +638,8 @@ static int open_table_device(struct table_device *td,
> dev_t dev,
> >   			     struct mapped_device *md)
> >   {
> >   	struct block_device *bdev;
> > +	struct list_head *holders;
> > +	struct dm_holder *holder;
> >
> >   	int r;
> >
> > @@ -651,6 +657,19 @@ static int open_table_device(struct table_device
> > *td, dev_t dev,
> >
> >   	td->dm_dev.bdev = bdev;
> >   	td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
> > +	if (!td->dm_dev.dax_dev)
> > +		return 0;
> > +
> > +	holders = dax_get_holder(td->dm_dev.dax_dev);
> > +	if (!holders) {
> > +		holders = kmalloc(sizeof(*holders), GFP_KERNEL);
> > +		INIT_LIST_HEAD(holders);
> > +		dax_set_holder(td->dm_dev.dax_dev, holders, &dm_dax_holder_ops);
> > +	}
> > +	holder = kmalloc(sizeof(*holder), GFP_KERNEL);
> > +	holder->md = md;
> > +	list_add_tail(&holder->list, holders);
> > +
> >   	return 0;
> >   }
> >
> > @@ -659,9 +678,27 @@ static int open_table_device(struct table_device *td,
> dev_t dev,
> >    */
> >   static void close_table_device(struct table_device *td, struct
> mapped_device *md)
> >   {
> > +	struct list_head *holders;
> > +	struct dm_holder *holder, *n;
> > +
> >   	if (!td->dm_dev.bdev)
> >   		return;
> >
> > +	holders = dax_get_holder(td->dm_dev.dax_dev);
> > +	if (holders) {
> > +		list_for_each_entry_safe(holder, n, holders, list) {
> > +			if (holder->md == md) {
> > +				list_del(&holder->list);
> > +				kfree(holder);
> > +			}
> > +		}
> > +		if (list_empty(holders)) {
> > +			kfree(holders);
> > +			/* unset dax_device's holder_data */
> > +			dax_set_holder(td->dm_dev.dax_dev, NULL, NULL);
> > +		}
> > +	}
> > +
> >   	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
> >   	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
> >   	put_dax(td->dm_dev.dax_dev);
> > @@ -1115,6 +1152,89 @@ static int dm_dax_zero_page_range(struct
> dax_device *dax_dev, pgoff_t pgoff,
> >   	return ret;
> >   }
> >
> > +#if IS_ENABLED(CONFIG_DAX_DRIVER)
> > +struct corrupted_hit_info {
> > +	struct dax_device *dax_dev;
> > +	sector_t offset;
> > +};
> > +
> > +static int dm_blk_corrupted_hit(struct dm_target *ti, struct dm_dev *dev,
> > +				sector_t start, sector_t count, void *data) {
> > +	struct corrupted_hit_info *bc = data;
> > +
> > +	return bc->dax_dev == (void *)dev->dax_dev &&
> > +			(start <= bc->offset && bc->offset < start + count); }
> > +
> > +struct corrupted_do_info {
> > +	size_t length;
> > +	void *data;
> > +};
> > +
> > +static int dm_blk_corrupted_do(struct dm_target *ti, struct block_device
> *bdev,
> > +			       sector_t sector, void *data) {
> > +	struct mapped_device *md = ti->table->md;
> > +	struct corrupted_do_info *bc = data;
> > +
> > +	return dax_holder_notify_failure(md->dax_dev, to_bytes(sector),
> > +					 bc->length, bc->data);
> > +}
> > +
> > +static int dm_dax_notify_failure_one(struct mapped_device *md,
> > +				     struct dax_device *dax_dev,
> > +				     loff_t offset, size_t length, void *data) {
> > +	struct dm_table *map;
> > +	struct dm_target *ti;
> > +	sector_t sect = to_sector(offset);
> > +	struct corrupted_hit_info hi = {dax_dev, sect};
> > +	struct corrupted_do_info di = {length, data};
> > +	int srcu_idx, i, rc = -ENODEV;
> > +
> > +	map = dm_get_live_table(md, &srcu_idx);
> > +	if (!map)
> > +		return rc;
> > +
> > +	/*
> > +	 * find the target device, and then translate the offset of this target
> > +	 * to the whole mapped device.
> > +	 */
> > +	for (i = 0; i < dm_table_get_num_targets(map); i++) {
> > +		ti = dm_table_get_target(map, i);
> > +		if (!(ti->type->iterate_devices && ti->type->rmap))
> > +			continue;
> > +		if (!ti->type->iterate_devices(ti, dm_blk_corrupted_hit, &hi))
> > +			continue;
> > +
> > +		rc = ti->type->rmap(ti, sect, dm_blk_corrupted_do, &di);
> > +		break;
> > +	}
> > +
> > +	dm_put_live_table(md, srcu_idx);
> > +	return rc;
> > +}
> > +
> > +static int dm_dax_notify_failure(struct dax_device *dax_dev,
> > +				 loff_t offset, size_t length, void *data) {
> > +	struct dm_holder *holder;
> > +	struct list_head *holders = dax_get_holder(dax_dev);
> > +	int rc = -ENODEV;
> > +
> > +	list_for_each_entry(holder, holders, list) {
> > +		rc = dm_dax_notify_failure_one(holder->md, dax_dev, offset,
> > +					       length, data);
> > +		if (rc != -ENODEV)
> > +			break;
> > +	}
> > +	return rc;
> > +}
> > +#else
> > +#define dm_dax_notify_failure NULL
> > +#endif
> > +
> >   /*
> >    * A target may call dm_accept_partial_bio only from the map routine.
> It is
> >    * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_* zone
> > management @@ -3057,6 +3177,10 @@ static const struct dax_operations
> dm_dax_ops = {
> >   	.zero_page_range = dm_dax_zero_page_range,
> >   };
> >
> > +static const struct dax_holder_operations dm_dax_holder_ops = {
> > +	.notify_failure = dm_dax_notify_failure, };
> > +
> >   /*
> >    * module hooks
> >    */
> >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

