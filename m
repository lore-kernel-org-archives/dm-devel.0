Return-Path: <SRS0=Z7ED=LY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05733C11F65
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 07:26:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C2B461D1B
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 07:26:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C2B461D1B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-D_FNe05AOMe_XLGGTICM-A-1; Wed, 30 Jun 2021 03:26:30 -0400
X-MC-Unique: D_FNe05AOMe_XLGGTICM-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 573FA19057A1;
	Wed, 30 Jun 2021 07:26:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D2E51980E;
	Wed, 30 Jun 2021 07:26:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FD7E1809C99;
	Wed, 30 Jun 2021 07:26:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15T7nf1a018757 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Jun 2021 03:49:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 75A27202F31A; Tue, 29 Jun 2021 07:49:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F35F20341A3
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 07:49:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00070108C18F
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 07:49:37 +0000 (UTC)
Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com
	[68.232.151.214]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-11-LtSCsbsoMQyvKSR-yM3RYQ-1; Tue, 29 Jun 2021 03:49:33 -0400
X-MC-Unique: LtSCsbsoMQyvKSR-yM3RYQ-1
IronPort-SDR: 9ZezAwZbVeAORJ6Qei2ZXxBw4SqY0ZhDJRZdVf8hWP6kcZEQuOQcrbz+bwZ1r9hAuope+kUDHl
	JbHSTtjlpLkrFp6kxlWG6Z9PU5KaRCw8UFXmItGQVucq9MUpqUsqYyJhVMj4p5I+RpQb8cK2js
	V4CJpLbcNiJSPtFWNvUtq3URs2yBX0UDIfxTdfbcxTxHeCvaIl0ZYHDIwlUT+/4J9TcLf6axEJ
	CXzQDaVCy69OFsUD94vxUcdTADcmMVbdA4HUq4sGZ2JgqFSp+oNbSUWeajN8NtjPTAs9yyjfbi
	+yo=
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="41911581"
X-IronPort-AV: E=Sophos;i="5.83,308,1616425200"; d="scan'208";a="41911581"
Received: from mail-ty1jpn01lp2050.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.50])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 16:49:28 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSBPR01MB1640.jpnprd01.prod.outlook.com (2603:1096:603:1::10) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23;
	Tue, 29 Jun 2021 07:49:25 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b985:8239:6cf0:1228]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b985:8239:6cf0:1228%7]) with mapi id 15.20.4264.026;
	Tue, 29 Jun 2021 07:49:24 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Matthew Wilcox <willy@infradead.org>
Thread-Topic: [PATCH v5 5/9] mm: Introduce mf_dax_kill_procs() for fsdax case
Thread-Index: AQHXa7EmrHLpSGG2eEOWO38ftnVtTKspT/mAgAFCBXA=
Date: Tue, 29 Jun 2021 07:49:24 +0000
Message-ID: <OSBPR01MB292012F7C264076E9AA645C3F4029@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
	<20210628000218.387833-6-ruansy.fnst@fujitsu.com>
	<YNm3VeeWuI0m4Vcx@casper.infradead.org>
In-Reply-To: <YNm3VeeWuI0m4Vcx@casper.infradead.org>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [223.111.68.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 745b76d0-9bf2-40df-b028-08d93ad26a42
x-ms-traffictypediagnostic: OSBPR01MB1640:
x-microsoft-antispam-prvs: <OSBPR01MB164009921EE90C9565C9FEC0F4029@OSBPR01MB1640.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2NGk8+wcYfzubbACPAWze6Dtv1Rb86b2Th0qnBGyiWDJ3+P+OjmIQAI/RNYtEB7ipHm/hyYhucz16Visv9tQGL5SMRDdviydfq8Y9j32Yx0fGV3j6ApyUz4X3mPTTW7LkJnGFO0PIU0eJ7RgL0pFwctzixORoB5uMM5HZ2jdkdm4z76EPYiSANTUSwQx9D7OC0u5cXuv18TIMCpOiNOeWxJDi831OyNVE6zXRfutr2PfEtaWKe/BTeMiJpp0QEMndfeZqvSqzAPERAuTs6lwEmI5R8CuetaZoY7YQfEhNwmhLHjbZYVv8qN9IQB5v3ZWKueLV+xIPGX71RikHaZ0aVVx8hfgFDBQB6+xatSiMrUtaHVtDDyKE7IEvh2o0gk9ylKnyVU0yrXR3rKWivxbhNmW9FrE11iIYcy4HTN0ATP7yOmLE2nFfIyHpULijIiwfZKyl81ZVp3h2gOe6g7c6/u1a9jma2hDWbNe7m6Pudc6aSeKzDwKuFWR2QhqHzS3AAjkkvKHPzv3r6LVLJqX1CL4phln9hxLFwHkAK9EyXOqUfFg5asXza099oRTGLvuV4ey+AHAi4yhuJ74ZvUhkQ4mxnF6MGfy9lyWjg1auQT6wicRqMv+q/R1TTLI/uTci2VT0jKBybSquje2vWyTtQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(33656002)(6506007)(54906003)(316002)(5660300002)(26005)(6916009)(83380400001)(186003)(85182001)(122000001)(52536014)(66446008)(7696005)(66946007)(71200400001)(66556008)(64756008)(66476007)(55016002)(2906002)(86362001)(9686003)(478600001)(8676002)(4326008)(76116006)(38100700002)(8936002)(7416002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Q0xlSXdaOVBGM0QzOXVzREczOFhCWWdseVE5MzYrdTNrMFlrQ2I4QWkzQ1dC?=
	=?gb2312?B?TDNIam1RVzNVWHIvWFpCK0Q5cVV4cEowa2dYVjNHTG44OE5DTnZ0d1V5S3ZM?=
	=?gb2312?B?SWFNekU0b09CR3pSNlhzRmhKR1B6MkJUN1MwSXlzNzVFOEVYR0J0M05WRDJT?=
	=?gb2312?B?MmtER3o5SDBmU0ptRWF0MEZHN3RqaG9nUUdMbmJVYng3WFBCN1lRdWxXbUQ2?=
	=?gb2312?B?TWp4VktlRkVmL3lCem5mbG1uNm5kVEgzWVpzSzRGU0NBanlyWHA2Q2dsUWs0?=
	=?gb2312?B?V3RkVnJlTU9PTjVzVFoyNy9mUUJyeUc2SXpnMnpKamtMWlJUWEpLMXlaS2tO?=
	=?gb2312?B?ajhnUFhiNUdTR1ZtaE4yT1g0OXc4R3dTay9Gcmd2cXVFUkMvVGhnZDVGaFd0?=
	=?gb2312?B?eWtDQ2htZ2dWRmwreVNXbTBhK2daOUVnVTZiR0p1WDNlVm5nd0JZbjF5QlQx?=
	=?gb2312?B?eHRNSFZZSElONUVMOWl6bjlMNjR5SjR6R0xLTFFPeFp2YVE4R2h0NXpqOE9X?=
	=?gb2312?B?emZ4dXBoYXltdjJCUHZXRGRnaG9HdEFRSWZlVDBlcEtaOUUyanZyZ2E1ckxr?=
	=?gb2312?B?aEhYYzhHOFJPSy9ZRmtoOTdrVUJZaVNLd1QrQzg3MFl6K3pKdmNYKzZlNWVm?=
	=?gb2312?B?Ry96S2t1OGNZL01vRmN0RmJtUWNyLzRWMEtCUndkTG1mRUFYYjFEeFNUYTdo?=
	=?gb2312?B?b1dlanQ0RjVycHk3V204VzJFbzZTOElNc0MwdTkxNUxaNTByNzJzeDQxNllq?=
	=?gb2312?B?Z0JDREs1VmU0Zkp0Rk5qL3lMdFZTdUQ4RTg3MWc2WHNJbUllUWZwYWxJdGF1?=
	=?gb2312?B?ZW9TYWlGZFF4eGI3SExZOUlSdnNoVnJFTTUxQkdQWW9GR3JkRkVja3FIVkN5?=
	=?gb2312?B?V3hQT3BrcWVHT0hYazZwTSt4WTBBeXBBNzYvelRsdTRCbmVsUFdWWlhvMFZp?=
	=?gb2312?B?M29Bb3p3SENLVlU0cUlDdllqVmVLOS8wSWo5cllicWkzUEp2bHJSa3FYMHZs?=
	=?gb2312?B?Wk5PYnRxaXZ5cklxSnd6Z1RJU0ZNOHA4L0ViVmtTL3NHNXZ5MFhmU2hlNFRO?=
	=?gb2312?B?VnFVamEzZDhsU3ZNeURKT2ZZWW1CQVJLV3BTK3VXbnd0cjRlRC9mTnkvRDdR?=
	=?gb2312?B?c1B6cUxKQ2FjYkVqR1BVNlA5YW96emhHSUordzhmZmlCWFJmR0dIN3FjQktU?=
	=?gb2312?B?Mnljdm8zQ2JaN1lxb05hdnR3YllRTmg2cFRLR2ZQRmcyK2gwMFA3aUJzKytC?=
	=?gb2312?B?YVZqRVgyMU91emRLVTMwbmJvUnFudVdsYXhKM0U0bHlsLzdnd0xwZi9yK2NI?=
	=?gb2312?B?V0VVb1o1WGEyZkY0SWpMUVpTR1RVZXVNelVlZjBCNXdVNzhidFVRRGdBQTNj?=
	=?gb2312?B?WW0xUlZqUk01dTVtWVYyV1plbVdyTThORGtuLzkwTXM4SnNUeVR2N2JCS0t5?=
	=?gb2312?B?Nmx2TVhQK2NaVmZSVmlBWFkvc2lUT0U3UlZ2QjZwNEZHUys5M2NUaFlrd3E2?=
	=?gb2312?B?S2UxREFMSFlJMFBBMmE1d0pTY0xnemZPbDBTMmlqNUVUR2wvZUJjbzAxMCt3?=
	=?gb2312?B?WlRLSGpkclBkTHB3ZnBNUmhVWFRCMDgrNGZ6YVdxNktjZ2YvVU16RnY0WUxR?=
	=?gb2312?B?Nk5INlhrbElkM3pLN0FweXVPRy9qN1hVMHhkZ3VHRTN6U1V5ak1tZ0FWU1ds?=
	=?gb2312?B?ckYyOVhBZHdVSlZtRkh1aE1Pd3VUTTdXakFiSGRtUmZEL1dBc1hWZnhWalQz?=
	=?gb2312?Q?XvqPbtE6NyVL1vofi1mtM3rBdsL0SDAdm3El/aM?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 745b76d0-9bf2-40df-b028-08d93ad26a42
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2021 07:49:24.8825 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ze499s5y02PyM2AZlb3Le/sYwzLrlzeDQ1HsmmTLNQXiXwoGMKr8s+RPR6QHS2GK20x267NmkiChwfzjmSAnuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1640
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15T7nf1a018757
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 30 Jun 2021 03:26:17 -0400
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"darrick.wong@oracle.com" <darrick.wong@oracle.com>,
	"rgoldwyn@suse.de" <rgoldwyn@suse.de>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 5/9] mm: Introduce mf_dax_kill_procs() for
	fsdax case
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
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Subject: Re: [PATCH v5 5/9] mm: Introduce mf_dax_kill_procs() for fsdax case
> 
> On Mon, Jun 28, 2021 at 08:02:14AM +0800, Shiyang Ruan wrote:
> > +/*
> > + * dax_load_pfn - Load pfn of the DAX entry corresponding to a page
> > + * @mapping:	The file whose entry we want to load
> > + * @index:	offset where the DAX entry located in
> > + *
> > + * Return:	pfn number of the DAX entry
> > + */
> 
> This is an externally visible function; why not add the second '*' and make this
> kernel-doc?

I'll fix this and add kernel-doc.

> 
> > +unsigned long dax_load_pfn(struct address_space *mapping, unsigned
> > +long index) {
> > +	XA_STATE(xas, &mapping->i_pages, index);
> > +	void *entry;
> > +	unsigned long pfn;
> > +
> > +	xas_lock_irq(&xas);
> > +	entry = xas_load(&xas);
> > +	pfn = dax_to_pfn(entry);
> > +	xas_unlock_irq(&xas);
> 
> Why do you need the i_pages lock to do this?  is the rcu_read_lock() insufficient?

I was misusing these locks, not very filmier with them...

So, I think I should learn from dax_lock_page(): rcu_read_lock(), xas_load(&xas, index), and then wait_entry_unlocked(), finally get an unlocked entry, translate to PFN and return.

> For that matter, why use the xas functions?  Why not
> simply:
> 
> 	void *entry = xa_load(&mapping->i_pages, index);
> 	return dax_to_pfn(entry);
> 
> Looking at it more though, how do you know this is a PFN entry?
> It could be locked, for example.  Or the zero page, or empty.

Yes, I didn't take these in consideration.  If this file hasn't been mmapped and accessed, I can't get its PFN rightly.

> 
> But I think this is unnecessary; why not just pass the PFN into mf_dax_kill_procs?

Because the mf_dax_kill_procs() is called in filesystem recovery function, which is at the end of the RMAP routine.  And the PFN has been translated to disk offset in pmem driver in order to do RMAP search in filesystem.  So, if we have to pass it, every function in this routine needs to add an argument for this PFN.  I was hoping I can avoid passing PFN through the whole stack with the help of this dax_load_pfn().

So, based on the above, if a file hasn't been mmapped and accessed, we can't get the right PFN number, which also means no process is associated with this PFN.  Then we don't have to kill any process any more.  Just return with an error code.  mf_dax_kill_porcess() can also return immediately.  How do you think?


--
Thanks,
Ruan.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

