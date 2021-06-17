Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E60C48BDF
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 07:13:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3900261057
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 07:13:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3900261057
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-YabcYMpiPYm5vOzWLNeMpA-1; Fri, 18 Jun 2021 03:13:26 -0400
X-MC-Unique: YabcYMpiPYm5vOzWLNeMpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C060118414A4;
	Fri, 18 Jun 2021 07:13:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9545E18658;
	Fri, 18 Jun 2021 07:13:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 148DA46F5D;
	Fri, 18 Jun 2021 07:13:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15H7pgc5003431 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 03:51:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2857B10CD2CA; Thu, 17 Jun 2021 07:51:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2303910CD2CE
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 07:51:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4BCA81D79F
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 07:51:35 +0000 (UTC)
Received: from esa1.fujitsucc.c3s2.iphmx.com (esa1.fujitsucc.c3s2.iphmx.com
	[68.232.152.245]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-73-SNZc06hRNY-pvG0LF4o9rg-1; Thu, 17 Jun 2021 03:51:31 -0400
X-MC-Unique: SNZc06hRNY-pvG0LF4o9rg-1
IronPort-SDR: Mfmeb3+tsZOtU7r8rpLCjkKgKZP7p5hvOS+/j8yxo5yjhHXnT8aJXmRdhDhnTMUMm5kUvKvkPh
	hbIgvvV6i08tSaSFdoVqsLfB8RUgy5lLgBrHyPKC3JNO1aJfpVPigYQa1arRMMJsPyW00ZqaVB
	5tMLj9qeTIze7jcy+zIaarX5oAoboAJKXAjvVr6XScCPx6sBsmKBBe53Z8CZdlz1OK0Cc40vyv
	8HVk+PxfxbKrT7KYACnP27zzYfHbm0e+F/Sw7yOE+PdvXqWPUH3Yk3XZJCrV9IA/LQuhsOpG/Z
	ouw=
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="41477277"
X-IronPort-AV: E=Sophos;i="5.83,278,1616425200"; d="scan'208";a="41477277"
Received: from mail-ty1jpn01lp2050.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.50])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:51:27 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSZPR01MB6765.jpnprd01.prod.outlook.com (2603:1096:604:130::6)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16;
	Thu, 17 Jun 2021 07:51:21 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b985:8239:6cf0:1228]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b985:8239:6cf0:1228%7]) with mapi id 15.20.4242.019;
	Thu, 17 Jun 2021 07:51:21 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v4 04/10] mm, fsdax: Refactor memory-failure handler for
	dax mapping
Thread-Index: AQHXWN/GSrgkRDCn3kC6TSUqXiwioqsWQI2AgAGbqhA=
Date: Thu, 17 Jun 2021 07:51:20 +0000
Message-ID: <OSBPR01MB2920B6CFA80F88EE0740071EF40E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
	<20210604011844.1756145-5-ruansy.fnst@fujitsu.com>
	<CAPcyv4iEuPWs-f+rV=xncbXYKSHkbhuLJ-1hnP9N9ABNzr1VSA@mail.gmail.com>
In-Reply-To: <CAPcyv4iEuPWs-f+rV=xncbXYKSHkbhuLJ-1hnP9N9ABNzr1VSA@mail.gmail.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [223.111.68.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac269a3f-5c0b-4991-1e53-08d93164b273
x-ms-traffictypediagnostic: OSZPR01MB6765:
x-microsoft-antispam-prvs: <OSZPR01MB676592EEB100501E783E183DF40E9@OSZPR01MB6765.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GCB0o5CKRBJ5VlgY0WjkTCum3Jldl6OMR1l9vSIhiFeJ2EQ4TvI/8R4bN4Vs/32JfR/FqWA8RE+DqUgMQDuOPTBDjA/znBrEWy+gerCCzxp7leQ2l4Gg2SD5nD0wG7okoY33lNgFdNtRVvyvpsRpy7U1jO5gADWQqP/wOZRvv7s5ZrjmeJpyWWyvH96Vrs+osIfQu6J/e30buFCUyW/v26DyTeIK5g555Kz41sR8kWd+Zbpi2jyfornf0OWGWV3bJ+udfX2AUNPkQH4kxFPp0jPUfYASeyZzg28wX2fhI0vIETl2PbOYZQVJ81klGRo2/jv3KmDJNKNUhvAV9OV6FriGHkLDqJvssMvaVi2af/oWJ950Rve2iSI1A24Onnw3t2tsRxgZZNPOlMjYnnar2UWnWu+LBwBEntUFoQRud7uo4cxPMY+zaxMcXq8ZayaNZSg7wP+WbpybEcMzCXXV55TiFhsBY+1WqUwW3+oTRHcIjkGgZnNMooPnpEOWvdcI56r9F7Qwep8Ua2vEcyK5cM3CZJtzNTT4IRTfLqpOmueVvm9vuhxYLRoJJdptU+GKSHDsw5U0K6/QS39tN4PHuZLFOLGO6FLx/56SdYUcJZs=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(6506007)(7696005)(76116006)(9686003)(55016002)(53546011)(186003)(33656002)(86362001)(122000001)(64756008)(85182001)(6916009)(4326008)(66946007)(66476007)(38100700002)(2906002)(66556008)(66446008)(52536014)(478600001)(7416002)(26005)(8936002)(83380400001)(71200400001)(5660300002)(316002)(54906003)(8676002)(30864003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWJjRVBtblYwVERROHFzRXBQckJVV2FjdEVxTjdyK2JaaXJ4WDdDRE1BVnJV?=
	=?utf-8?B?QTVUTHdnek5BcmFsTE5EOFl5Unc5dGFUMzVTOUdZT2tnNE9ZRjh6Rkp2cWIy?=
	=?utf-8?B?UXJBVTFNZjJVeGlSWE1uenhhRnNNMTR2RW9GeTl6Slg5dWM3dEM3Qk5RVTBY?=
	=?utf-8?B?ZHNVRTVENHE1MCtXSHJoN2xYRmhhVUU0L2hvdll6ekM5eFRDNjExODBtKzBo?=
	=?utf-8?B?K0Rpdm5WVk9LdHR4c2c4OUw2OGhpZXVycXJpR1dzZnN5VGpiZGgyYUVpZkZP?=
	=?utf-8?B?eElzbFZBTFRIY3ovS0t4UkFWS2NaN0UzUGcxcEZWOVdqUFJlL0xMN1pBczRU?=
	=?utf-8?B?dkNoRTd5MTVqMlM4M2dpTHdjNGNMQmpmN08yQUFlb1VjbnRKa3JDTW5Gai93?=
	=?utf-8?B?RjZDYVNCUEdyTllqakdQZGllSytic2lOeVBYU3FsazVPMnBaVFZ6S2VQT2h5?=
	=?utf-8?B?MVNEZHNHb3JMbENJbGxjUUFmZmVwNmczaVQyUlo4NlNPWlVTU050U3pDRHVD?=
	=?utf-8?B?NDlsakN5RmRBMWtJSlNkTGNKSlZKL3c0SEJsRm4rK3E4K1NOamJJVXVGYUxI?=
	=?utf-8?B?SmVWOWFBQWN5TG5qRnZ1d3Zldm9sc3RtOGpvVTRPSjZCd05zR1hnaHFPWldH?=
	=?utf-8?B?NlFVUVpBRndjcUVjSzBVNlkzbEVLYTQ3UFZ3YkltajVNRm9qc3BTbWZSMHdK?=
	=?utf-8?B?b2NYTWV6VzdvUGYxQkgyQTNzbE4rODBxK0FRanlHL3Nhbk9oSzVWZHdkMmJY?=
	=?utf-8?B?Kzg4M2pDZlQzbkJyOFdWaStEY2xNKzdCQXBCWThFMzR4OUNSbzM1VlgzV2Yy?=
	=?utf-8?B?N3NFa2pCcHBuSzFLSlpiWXNSTWw1WjI1TDFmeDR1OWcxRWdUM1VNejNJQmNG?=
	=?utf-8?B?OCtFMHgvWXNtM0I4RTkzd09CcHd0R2dnVE9tWXBOeVRDTDB1MXhHd0J2UURv?=
	=?utf-8?B?NU01RVVOazFpNnoyTGZ0SmQvODN0bzlST3pJblorTGdUUjBVd29hcFRyNVZ0?=
	=?utf-8?B?bnczWE10clBveVRmSm03aUM5QUE1bUVvYldoS09PR3M0UGVzUVZKWkNoY29L?=
	=?utf-8?B?VWIvNjArUk9WYWZZOHRNUVRwb2J6c20yeDlSQ2xYaXB3VTNBYWhMazRKeUNU?=
	=?utf-8?B?S2EwV0lXL0NXVEFGVWJZQ0pPaGNmdnl4YTNNNG1aV0ZIQjJnSDkxMmlQN25D?=
	=?utf-8?B?d21xTjFVc0Y1K0JkbGpZOGRHMTRqekpvckljN1RxNlVkbEJ4T1UvWmdWVWdK?=
	=?utf-8?B?bUorZncvVEh3S2pjOEtwYTZESFJjNTdMNWMzK3lZcXU2NGdtYWdUeWJSRFlp?=
	=?utf-8?B?bENEbmV3TzhKQU42MDYvelJMNUR3c1NNRUhqOGlySDEydFhqUk5nSXdTdm1H?=
	=?utf-8?B?VEpSS3pBaTJJakpvZ2tUbU1jdjJ4R1F5c0pLRlQ1dDN4MFNXcUFaSUtiQ0t3?=
	=?utf-8?B?NnpIa1Q4VElndUt3bDRTSUxQYnQwc25tRjNHRlMvK1dwQnU1VEFxSnUydGRZ?=
	=?utf-8?B?dnY1OTZEWU5YYXRpclFjdUVrYno5UWxVY2pPQmRnZStLb3NGMFFnRy92WXRJ?=
	=?utf-8?B?U1VNQllCTjRldDAzS0xBcnJ5V0pDR3JNa2pKc1hmNHdmaVB2cGl6cHhNa05N?=
	=?utf-8?B?RHJzcGJLcTQzY05XdlhnY09VTnNQNm1zc3RGRGNDalRwa2RaRm1JZllWenBL?=
	=?utf-8?B?SHZQS2M0Tm5xcXU5SmVja3FGc3V4T1F2Vk8wKysrVGF6eUQxd0MzYVIwVGJw?=
	=?utf-8?Q?2JoXleqZs7FRIuhIBDfbmBakVRUi+BygvppVy0i?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac269a3f-5c0b-4991-1e53-08d93164b273
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 07:51:20.8696 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DZQIPoR4g/AvkSYlg1o80WyriqvyL3/rd/2uIOwkyXdl1BrD+0gFdCddkGUruBPEJ7V4MBFLFQx7aOW9AxLRCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6765
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15H7pgc5003431
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 18 Jun 2021 03:13:11 -0400
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 04/10] mm,
 fsdax: Refactor memory-failure handler for dax mapping
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
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> -----Original Message-----
> From: Dan Williams <dan.j.williams@intel.com>
> Subject: Re: [PATCH v4 04/10] mm, fsdax: Refactor memory-failure handler for
> dax mapping
> 
> [ drop old nvdimm list, add the new one ]
> 
> On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> >
> > The current memory_failure_dev_pagemap() can only handle single-mapped
> > dax page for fsdax mode.  The dax page could be mapped by multiple
> > files and offsets if we let reflink feature & fsdax mode work
> > together.  So, we refactor current implementation to support handle
> > memory failure on each file and offset.
> 
> I don't understand this organization, perhaps because this patch introduces
> mf_dax_kill_procs() without a user. 

Yes, I think I made it a mess... I should reorganize this whole patchset.

The mf_dax_kill_procs() is used by xfs in patch 9.  I was mean to refactor these code for the next patches usage.

> However, my expectation is that
> memory_failure() is mostly untouched save for an early check via
> pgmap->notify_memory_failure(). If pgmap->notify_memory_failure() indicates
> that the memory failure was handled by the pgmap->owner / dax_dev holder
> stack, then the typical memory failure path is short-circuited. Otherwise, for
> non-reflink filesystems where
> page->mapping() is valid the legacy / existing memory_failure()
> operates as it does currently.

You can find this logic in patch 5.

When it comes to memory-failure() and memory_failure_dev_pagemap(), after some check, it will try to call pgmap->ops->memory_failure().  If this interface is implemented, for example pgmap is pmem device, it will call the dax_dev holder stack. And finally, it comes to mf_dax_kill_procs().
However, if something wrong happens in this stack, such as feature not support or interface not implemented, it will roll back to normal memory-failure hanlder which is refactored as mf_generic_kill_porcs().

So, I think we are in agreement on this.

Let me reorganize these code.

> If reflink capable filesystems want to share a
> common implementation to map pfns to files they can, but I don't think that
> common code belongs in mm/memory-failure.c.
> 
> >
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >  fs/dax.c            |  21 ++++++++
> >  include/linux/dax.h |   1 +
> >  include/linux/mm.h  |   9 ++++
> >  mm/memory-failure.c | 114
> > ++++++++++++++++++++++++++++----------------
> >  4 files changed, 105 insertions(+), 40 deletions(-)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 62352cbcf0f4..58faca85455a 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -389,6 +389,27 @@ static struct page *dax_busy_page(void *entry)
> >         return NULL;
> >  }
> >
> > +/*
> > + * dax_load_pfn - Load pfn of the DAX entry corresponding to a page
> > + * @mapping: The file whose entry we want to load
> > + * @index:   The offset where the DAX entry located in
> > + *
> > + * Return:   pfn of the DAX entry
> > + */
> > +unsigned long dax_load_pfn(struct address_space *mapping, unsigned
> > +long index) {
> > +       XA_STATE(xas, &mapping->i_pages, index);
> > +       void *entry;
> > +       unsigned long pfn;
> > +
> > +       xas_lock_irq(&xas);
> > +       entry = xas_load(&xas);
> > +       pfn = dax_to_pfn(entry);
> > +       xas_unlock_irq(&xas);
> 
> This looks racy, what happened to the locking afforded by dax_lock_page()?
> 
> > +
> > +       return pfn;
> > +}
> > +
> >  /*
> >   * dax_lock_mapping_entry - Lock the DAX entry corresponding to a page
> >   * @page: The page whose entry we want to lock diff --git
> > a/include/linux/dax.h b/include/linux/dax.h index
> > 1ce343a960ab..6e758daa5004 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -158,6 +158,7 @@ int dax_writeback_mapping_range(struct
> > address_space *mapping,
> >
> >  struct page *dax_layout_busy_page(struct address_space *mapping);
> > struct page *dax_layout_busy_page_range(struct address_space *mapping,
> > loff_t start, loff_t end);
> > +unsigned long dax_load_pfn(struct address_space *mapping, unsigned
> > +long index);
> >  dax_entry_t dax_lock_page(struct page *page);  void
> > dax_unlock_page(struct page *page, dax_entry_t cookie);  #else diff
> > --git a/include/linux/mm.h b/include/linux/mm.h index
> > c274f75efcf9..2b7527e93c77 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1187,6 +1187,14 @@ static inline bool is_device_private_page(const
> struct page *page)
> >                 page->pgmap->type == MEMORY_DEVICE_PRIVATE;  }
> >
> > +static inline bool is_device_fsdax_page(const struct page *page) {
> > +       return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
> > +               IS_ENABLED(CONFIG_FS_DAX) &&
> > +               is_zone_device_page(page) &&
> > +               page->pgmap->type == MEMORY_DEVICE_FS_DAX;
> 
> Why is this necessary? The dax_dev holder is the one that knows the nature of
> the pfn. The common memory_failure() code should not care about fsdax vs
> devdax.

add_to_kill() in collect_procs() needs this. Please see explanation at below.

> 
> > +}
> > +
> >  static inline bool is_pci_p2pdma_page(const struct page *page)  {
> >         return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) && @@
> -3078,6
> > +3086,7 @@ enum mf_flags {
> >         MF_MUST_KILL = 1 << 2,
> >         MF_SOFT_OFFLINE = 1 << 3,
> >  };
> > +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
> > +int flags);
> >  extern int memory_failure(unsigned long pfn, int flags);  extern void
> > memory_failure_queue(unsigned long pfn, int flags);  extern void
> > memory_failure_queue_kick(int cpu); diff --git a/mm/memory-failure.c
> > b/mm/memory-failure.c index 85ad98c00fd9..4377e727d478 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -56,6 +56,7 @@
> >  #include <linux/kfifo.h>
> >  #include <linux/ratelimit.h>
> >  #include <linux/page-isolation.h>
> > +#include <linux/dax.h>
> >  #include "internal.h"
> >  #include "ras/ras_event.h"
> >
> > @@ -120,6 +121,13 @@ static int hwpoison_filter_dev(struct page *p)
> >         if (PageSlab(p))
> >                 return -EINVAL;
> >
> > +       if (pfn_valid(page_to_pfn(p))) {
> > +               if (is_device_fsdax_page(p))
> 
> This is racy unless the page is pinned. Also, not clear why this is needed?
> 
> > +                       return 0;
> > +               else
> > +                       return -EINVAL;
> > +       }
> > +
> >         mapping = page_mapping(p);
> >         if (mapping == NULL || mapping->host == NULL)
> >                 return -EINVAL;
> > @@ -290,10 +298,9 @@ void shake_page(struct page *p, int access)  }
> > EXPORT_SYMBOL_GPL(shake_page);
> >
> > -static unsigned long dev_pagemap_mapping_shift(struct page *page,
> > -               struct vm_area_struct *vma)
> > +static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct
> *vma,
> > +                                              unsigned long
> address)
> >  {
> > -       unsigned long address = vma_address(page, vma);
> >         pgd_t *pgd;
> >         p4d_t *p4d;
> >         pud_t *pud;
> > @@ -333,9 +340,8 @@ static unsigned long
> dev_pagemap_mapping_shift(struct page *page,
> >   * Schedule a process for later kill.
> >   * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
> >   */
> > -static void add_to_kill(struct task_struct *tsk, struct page *p,
> > -                      struct vm_area_struct *vma,
> > -                      struct list_head *to_kill)
> > +static void add_to_kill(struct task_struct *tsk, struct page *p, pgoff_t pgoff,
> > +                       struct vm_area_struct *vma, struct list_head
> > +*to_kill)
> >  {
> >         struct to_kill *tk;
> >
> > @@ -346,9 +352,12 @@ static void add_to_kill(struct task_struct *tsk, struct
> page *p,
> >         }
> >
> >         tk->addr = page_address_in_vma(p, vma);
> > -       if (is_zone_device_page(p))
> > -               tk->size_shift = dev_pagemap_mapping_shift(p, vma);
> > -       else
> > +       if (is_zone_device_page(p)) {
> > +               if (is_device_fsdax_page(p))
> > +                       tk->addr = vma->vm_start +
> > +                                       ((pgoff - vma->vm_pgoff) <<
> PAGE_SHIFT);
> > +               tk->size_shift = dev_pagemap_mapping_shift(vma,
> > + tk->addr);
> 
> What was wrong with the original code?

Here is the explanation: For normal page, it associate file's mapping and offset to page->mapping, page->index for rmap tracking.  But for fsdax, in order to support reflink, we no longer use this mechanism, using dax_device holder stack instead.  Thus, this dax page->mapping is NULL.  As a result, we need is_device_fsdax_page(p) to distinguish if a page is a fsdax page and calculate this tk->addr manually.

> 
> > +       } else
> >                 tk->size_shift = page_shift(compound_head(p));
> >
> >         /*
> > @@ -496,7 +505,7 @@ static void collect_procs_anon(struct page *page,
> struct list_head *to_kill,
> >                         if (!page_mapped_in_vma(page, vma))
> >                                 continue;
> >                         if (vma->vm_mm == t->mm)
> > -                               add_to_kill(t, page, vma, to_kill);
> > +                               add_to_kill(t, page, 0, vma, to_kill);
> >                 }
> >         }
> >         read_unlock(&tasklist_lock);
> > @@ -506,24 +515,19 @@ static void collect_procs_anon(struct page
> > *page, struct list_head *to_kill,
> >  /*
> >   * Collect processes when the error hit a file mapped page.
> >   */
> > -static void collect_procs_file(struct page *page, struct list_head *to_kill,
> > -                               int force_early)
> > +static void collect_procs_file(struct page *page, struct address_space
> *mapping,
> > +               pgoff_t pgoff, struct list_head *to_kill, int
> > +force_early)
> >  {
> 
> collect_procs() and kill_procs() are the only core memory_failure() helpers I
> expect would be exported for a fileystem dax_dev holder to call when it is trying
> to cleanup a memory_failure() on a reflink'd mapping.

Yes, they are the core we need.  But there are some small different when dealing with normal page and dax page.  So, I factor these two core functions into two helpers.  One is mf_generic_kill_procs() for normal page. Another is mf_dax_kill_procs() for dax page.

> 
> >         struct vm_area_struct *vma;
> >         struct task_struct *tsk;
> > -       struct address_space *mapping = page->mapping;
> > -       pgoff_t pgoff;
> >
> >         i_mmap_lock_read(mapping);
> >         read_lock(&tasklist_lock);
> > -       pgoff = page_to_pgoff(page);
> >         for_each_process(tsk) {
> >                 struct task_struct *t = task_early_kill(tsk,
> > force_early);
> > -
> >                 if (!t)
> >                         continue;
> > -               vma_interval_tree_foreach(vma, &mapping->i_mmap,
> pgoff,
> > -                                     pgoff) {
> > +               vma_interval_tree_foreach(vma, &mapping->i_mmap,
> > + pgoff, pgoff) {
> >                         /*
> >                          * Send early kill signal to tasks where a vma
> covers
> >                          * the page but the corrupted page is not
> > necessarily @@ -532,7 +536,7 @@ static void collect_procs_file(struct page
> *page, struct list_head *to_kill,
> >                          * to be informed of all such data corruptions.
> >                          */
> >                         if (vma->vm_mm == t->mm)
> > -                               add_to_kill(t, page, vma, to_kill);
> > +                               add_to_kill(t, page, pgoff, vma,
> > + to_kill);
> >                 }
> >         }
> >         read_unlock(&tasklist_lock);
> > @@ -551,7 +555,8 @@ static void collect_procs(struct page *page, struct
> list_head *tokill,
> >         if (PageAnon(page))
> >                 collect_procs_anon(page, tokill, force_early);
> >         else
> > -               collect_procs_file(page, tokill, force_early);
> > +               collect_procs_file(page, page_mapping(page),
> page_to_pgoff(page),
> > +                                  tokill, force_early);
> >  }
> >
> >  static const char *action_name[] = {
> > @@ -1218,6 +1223,51 @@ static int try_to_split_thp_page(struct page *page,
> const char *msg)
> >         return 0;
> >  }
> >
> > +static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
> > +               struct address_space *mapping, pgoff_t index, int
> > +flags) {
> > +       struct to_kill *tk;
> > +       unsigned long size = 0;
> > +       loff_t start;
> > +
> > +       list_for_each_entry(tk, to_kill, nd)
> > +               if (tk->size_shift)
> > +                       size = max(size, 1UL << tk->size_shift);
> > +       if (size) {
> > +               /*
> > +                * Unmap the largest mapping to avoid breaking up
> > +                * device-dax mappings which are constant size. The
> > +                * actual size of the mapping being torn down is
> > +                * communicated in siginfo, see kill_proc()
> > +                */
> > +               start = (index << PAGE_SHIFT) & ~(size - 1);
> > +               unmap_mapping_range(mapping, start, size, 0);
> > +       }
> > +
> > +       kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
> > +}
> > +
> > +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
> > +int flags) {
> > +       LIST_HEAD(to_kill);
> > +       /* load the pfn of the dax mapping file */
> > +       unsigned long pfn = dax_load_pfn(mapping, index);
> > +
> > +       /*
> > +        * Unlike System-RAM there is no possibility to swap in a
> > +        * different physical page at a given virtual address, so all
> > +        * userspace consumption of ZONE_DEVICE memory necessitates
> > +        * SIGBUS (i.e. MF_MUST_KILL)
> > +        */
> > +       flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> > +       collect_procs_file(pfn_to_page(pfn), mapping, index, &to_kill,
> > +                          flags & MF_ACTION_REQUIRED);
> > +
> > +       unmap_and_kill(&to_kill, pfn, mapping, index, flags);
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
> > +
> >  static int memory_failure_hugetlb(unsigned long pfn, int flags)  {
> >         struct page *p = pfn_to_page(pfn); @@ -1298,12 +1348,8 @@
> > static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
> >                 struct dev_pagemap *pgmap)  {
> >         struct page *page = pfn_to_page(pfn);
> > -       const bool unmap_success = true;
> > -       unsigned long size = 0;
> > -       struct to_kill *tk;
> > -       LIST_HEAD(tokill);
> > +       LIST_HEAD(to_kill);
> >         int rc = -EBUSY;
> > -       loff_t start;
> >         dax_entry_t cookie;
> >
> >         if (flags & MF_COUNT_INCREASED) @@ -1355,22 +1401,10 @@
> static
> > int memory_failure_dev_pagemap(unsigned long pfn, int flags,
> >          * SIGBUS (i.e. MF_MUST_KILL)
> >          */
> >         flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> > -       collect_procs(page, &tokill, flags & MF_ACTION_REQUIRED);
> > +       collect_procs_file(page, page->mapping, page->index, &to_kill,
> > +                          flags & MF_ACTION_REQUIRED);
> >
> > -       list_for_each_entry(tk, &tokill, nd)
> > -               if (tk->size_shift)
> > -                       size = max(size, 1UL << tk->size_shift);
> > -       if (size) {
> > -               /*
> > -                * Unmap the largest mapping to avoid breaking up
> > -                * device-dax mappings which are constant size. The
> > -                * actual size of the mapping being torn down is
> > -                * communicated in siginfo, see kill_proc()
> > -                */
> > -               start = (page->index << PAGE_SHIFT) & ~(size - 1);
> > -               unmap_mapping_range(page->mapping, start, size, 0);
> > -       }
> > -       kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn,
> flags);
> > +       unmap_and_kill(&to_kill, pfn, page->mapping, page->index,
> > + flags);
> 
> There's just too much change in this patch and not enough justification of what
> is being refactored and why.

Sorry again for the mess...


--
Thanks,
Ruan.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

