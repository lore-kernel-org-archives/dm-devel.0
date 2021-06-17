Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0A3C48BDF
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 07:13:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E11AA613AA
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 07:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E11AA613AA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-zDhJWS3lOUClXj9eNWLsIA-1; Fri, 18 Jun 2021 03:13:18 -0400
X-MC-Unique: zDhJWS3lOUClXj9eNWLsIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BE70801B15;
	Fri, 18 Jun 2021 07:13:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38B8D60E3A;
	Fri, 18 Jun 2021 07:13:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C463A46F5A;
	Fri, 18 Jun 2021 07:13:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15H8E8ph004705 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 04:14:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 726A610CD617; Thu, 17 Jun 2021 08:14:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69D8710CD6AA
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 08:14:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AEA9182506B
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 08:14:03 +0000 (UTC)
Received: from esa4.fujitsucc.c3s2.iphmx.com (esa4.fujitsucc.c3s2.iphmx.com
	[68.232.151.214]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-494-mZddwxPNOo61Bh2cnEl3gA-1; Thu, 17 Jun 2021 04:14:01 -0400
X-MC-Unique: mZddwxPNOo61Bh2cnEl3gA-1
IronPort-SDR: 4TY5TTVDZZmGjDdtmqPm9hXlWt2m2cCLqxtUA3JsWki/I2dyA+xXWtY3d9ztrH2Z1gSakWcW/S
	e2R37M6WNVDt2tqkmZF2YgSN4jTGP88woCcDsvI0c8UxhgXUcd5hRtOQdOy5/SWXxB3Qf7U4fu
	UsV86GgX6RSNNjr8a1ptGMEoX6Hq/Mc6a/lObPnXshiCTt9afqQXcr0rrgUzpIImvcGniacvUH
	onX+vabbBVwA8UwaGp1d7pvbvdf9/hhULw4ih4U7FtwgJYPazqqtekdRqrj0MoS4daKHt8/NP2
	JmE=
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="41210390"
X-IronPort-AV: E=Sophos;i="5.83,280,1616425200"; d="scan'208";a="41210390"
Received: from mail-ty1jpn01lp2051.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.51])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 17:12:53 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OS3PR01MB6039.jpnprd01.prod.outlook.com (2603:1096:604:d0::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16;
	Thu, 17 Jun 2021 08:12:49 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b985:8239:6cf0:1228]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b985:8239:6cf0:1228%7]) with mapi id 15.20.4242.019;
	Thu, 17 Jun 2021 08:12:49 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for superblock
Thread-Index: AQHXWN/AzVDrjJsgmE+2b5OugDUMoqsV4P2AgAHv3zCAAAtaAIAADhSw
Date: Thu, 17 Jun 2021 08:12:49 +0000
Message-ID: <OSBPR01MB292031EC271D4AD843389A3FF40E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
	<20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
	<CAPcyv4h=bUCgFudKTrW09dzi8MWxg7cBC9m68zX1=HY24ftR-A@mail.gmail.com>
	<OSBPR01MB29203DC17C538F7B1B1C9224F40E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4ihuErfVWHL0F1OExQashutJjBdaLn5X5oPm44OkQ+a_A@mail.gmail.com>
In-Reply-To: <CAPcyv4ihuErfVWHL0F1OExQashutJjBdaLn5X5oPm44OkQ+a_A@mail.gmail.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [223.111.68.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 451d5c3e-9486-47a8-9fc7-08d93167b2ba
x-ms-traffictypediagnostic: OS3PR01MB6039:
x-microsoft-antispam-prvs: <OS3PR01MB60398550E55EE9C1FF90F79BF40E9@OS3PR01MB6039.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: B9AnJhF/JQd4bpht4zUuYsiOgrt6wbsLhAS4rkzxFSTsGbhZI+WwXAmP4/cv16uoMtoy8c1Pxwup8OSqTSO3V1jJ/4Ff3j19rdZZcy1du3eDP5RiWlaXLBOUXyz//lvELPWs8GF5TxZiugAg/nUXf4SapezH1Q4q1PO6+LP4iufXy2NJbM7xhHpk7QtskdaDfkHfB/6M+1UiMSq74yqdsROA8HAu7L3JnC80SHHHFdkfnkyDcKg6qEsZ5aRnSfkjO0sGPkEEYibo7lzPAchnbKbse7ThFJBBsPcwfoR5r3jgProZrEG3t/4Sr+pPO/na47qcYCcCiEi2TPrZIgUpn9R2TGEGR2+cM4464qyQTi89aGNaT/cFDxAXvHVEvYCov/jTno+D1qOA+BCSPfM5Y5sW4Egnkm0E7FfNaK+woRNRLSEBX9v5V/sPM8p4PSlP8/HCeYTi9dzNG5+2rwcSDFnTDl2jDfj3iRZFMM4pF5+7MQuLvNgK6hZFSU4Mb/fRxlQzgZOn7OYyAmg7QnXffglulKIAmayXxlq2QiPOna0S515zMfx4A8Ry7itvZAymSWL/A8lqqTfaNzcnBs6KYITMbicij2aC2v/JM2QF5DQ=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(6506007)(71200400001)(53546011)(64756008)(76116006)(26005)(66946007)(66556008)(7416002)(186003)(316002)(83380400001)(66446008)(86362001)(66476007)(4326008)(2906002)(55016002)(478600001)(85182001)(52536014)(122000001)(9686003)(6916009)(5660300002)(7696005)(8676002)(8936002)(38100700002)(33656002)(54906003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVVqMVZ3VDJHcStyQ1dZRFJUQ0Y3N0ZNZkR4N1UvazdDZVFhSW5RQkd2TnU0?=
	=?utf-8?B?RmJsUmxmd0xEOHRVbThCd3F0c0I1elRUYzVhSFNKR1BrTlMwMEhPenRidGhh?=
	=?utf-8?B?YVgxTlVGUG9KTVY3WWlvcFdtNlAyZTJpV0dZTVlYVDEzM0d1L2JaN09YZlE3?=
	=?utf-8?B?ZmZ5MVQwZnJMVDFGYzRxTm44dEE0R2dSTTNPbzNlMkhuRTVhRUd3ZDArQWx3?=
	=?utf-8?B?L1VqcytkV0dGdDd6cEc5b3JXWmQvUk9WNGZiMFJ1UWdxOGdPYlV4Z3lZUCs3?=
	=?utf-8?B?aGI1a203Q2ppVm11c0hmVk9JYWt5UGY1VHNpS0R0SllhUCsrOU1XbkpzMWJ3?=
	=?utf-8?B?N0pKRE43dkprdE1JcGNjeHpvTURESWFRckgreDBuM3VDRlhCRlc5VUp3RGlq?=
	=?utf-8?B?YTRWZ294Z3hhRCs1Sm5xMFRRcnhYeDRBWlRYbjBibHF0OVdoY3FtU1Bjai9Y?=
	=?utf-8?B?WHg4TTVTaVpIYXBZcEJpWENaakNvN1RpbDRXT1doblovdUNGY2NtcU9RcTBL?=
	=?utf-8?B?eTZ2UmV0OVR3dWRBZlNGM1gwWVJEYUZreDdqNU9vKzhXcnBLNk9wWEtXd042?=
	=?utf-8?B?K3VFREZwbE40RDhIcmJMMGNPTnZVNTcxcTVIMk5WOVdTTVVHdEpRODEzT3Iy?=
	=?utf-8?B?WUlwWCt1V21lT3ZtaUFmd1dKRFpRNlpFT0w1bVhmZGViZVRGaXlScEFicVFj?=
	=?utf-8?B?aEw4YnRFNk5ZY29uTit4ZEtWYmdtZDI5MUVJYU9zTHZsTGkxNkUzQ0NkK0k5?=
	=?utf-8?B?TlVRS2w4Z3dwSXhtNEpiOTdSQzF6cStjZmxKUUVMekNDa3orUStlVUpZZ0VN?=
	=?utf-8?B?RHV2SGtoNHJ2QmxUTFNPYlk1QlZDS2tMbmd6UXcvVmpXUWNraVZLd0l4VEsx?=
	=?utf-8?B?SitlRjNUS01HVW1jVTFpSDJCbVZRTHhDTjFON0dKbEJiU3l3UWJvdkRtcE43?=
	=?utf-8?B?ckluR1FkMW5pOTF6SDV3YXNTZzBJTDg5cktkWlVDbGc2OVZWaWxGbzg3SlRD?=
	=?utf-8?B?WC9rZXpER0JYcC9CeHRMaGMwT093eFNSVG9DTHU3Q0N2WUI2TmFLOXVXZzVH?=
	=?utf-8?B?U3pXZmlubFJRZmtGZDhaNnVGc1FXZ2pyMU93ZEZoZE83bG9abnBWN2RMcGVo?=
	=?utf-8?B?eU1vV3FOQWNKRVZOTmJVbzREQ1pMZCtVSlErTTdXdlBRNklEYUlKWDJFK29B?=
	=?utf-8?B?UnNYRFI1N2o4VFRvbFZSWkdINStLdVk1NGRvcW9ZYXhWM1RFYUhyWUN6OWI5?=
	=?utf-8?B?MWUvNU5sdGFjM3orOGtLSllFK3REWnRFUG8xdjd1bkx5M3FPbnd6dzJQNGxm?=
	=?utf-8?B?YlZjcWxKZEhSRW5Ud1ZQbW95SithQUl0VWRnZDdoeDFUUndpeXY2S1hZak1N?=
	=?utf-8?B?L1kzN21EeXppV1dLL09ON3dDTTlIRmhmMjlKVEtVcEQwSkVmb2c4RHZLaGRF?=
	=?utf-8?B?V0F1NnROU2F5WDlYOSsxWVRYNWNQaVBtRWRORHVNeTJKRm5rS0lNM0tEMjRW?=
	=?utf-8?B?VTBoUWRzZlF5VnhMeHFWS090OUFTQ3NFV0toUXZYekpvbzRkV2JUY3pDdlVx?=
	=?utf-8?B?S3lDcnlrbU9vRnluZ1JmZXVNMGMxdFZjQ3poRWJCTE10K3ovN2t3UG41emZa?=
	=?utf-8?B?WktuRlIrb2tuZWZSdFZTcGFHZWhiWXRnREF3N0ZLcmQyOHZhbGg2ckRDMC9p?=
	=?utf-8?B?ditnWE1RNXkxRFdRT2ovNmJ3TzZBc2JKakVBM3czaTRQYVZsSjJnQkZyMUo3?=
	=?utf-8?Q?4ED+NOUUgVMtp08frYgD1G84/nhLdGdtzz6jGK2?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 451d5c3e-9486-47a8-9fc7-08d93167b2ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 08:12:49.8623 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rEmEpeIKrW7JQ1gQVHnyLYfhE+ppl02n66wtf/QFgWjKo4714OBwCxnRBTQ6jPISaZBjtnAi/JaCSYy/VpQt4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6039
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15H8E8ph004705
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
Subject: Re: [dm-devel] [PATCH v4 03/10] fs: Introduce ->corrupted_range()
	for superblock
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> -----Original Message-----
> From: Dan Williams <dan.j.williams@intel.com>
> Subject: Re: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for superblock
> 
> On Wed, Jun 16, 2021 at 11:51 PM ruansy.fnst@fujitsu.com
> <ruansy.fnst@fujitsu.com> wrote:
> >
> > > -----Original Message-----
> > > From: Dan Williams <dan.j.williams@intel.com>
> > > Subject: Re: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for
> > > superblock
> > >
> > > [ drop old linux-nvdimm@lists.01.org, add nvdimm@lists.linux.dev ]
> > >
> > > On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com>
> wrote:
> > > >
> > > > Memory failure occurs in fsdax mode will finally be handled in
> > > > filesystem.  We introduce this interface to find out files or
> > > > metadata affected by the corrupted range, and try to recover the
> > > > corrupted data if possiable.
> > > >
> > > > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > > > ---
> > > >  include/linux/fs.h | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/include/linux/fs.h b/include/linux/fs.h index
> > > > c3c88fdb9b2a..92af36c4225f 100644
> > > > --- a/include/linux/fs.h
> > > > +++ b/include/linux/fs.h
> > > > @@ -2176,6 +2176,8 @@ struct super_operations {
> > > >                                   struct shrink_control *);
> > > >         long (*free_cached_objects)(struct super_block *,
> > > >                                     struct shrink_control *);
> > > > +       int (*corrupted_range)(struct super_block *sb, struct
> > > > + block_device
> > > *bdev,
> > > > +                              loff_t offset, size_t len, void
> > > > + *data);
> > >
> > > Why does the superblock need a new operation? Wouldn't whatever
> > > function is specified here just be specified to the dax_dev as the
> > > ->notify_failure() holder callback?
> >
> > Because we need to find out which file is effected by the given poison page so
> that memory-failure code can do collect_procs() and kill_procs() jobs.  And it
> needs filesystem to use its rmap feature to search the file from a given offset.
> So, we need this implemented by the specified filesystem and called by
> dax_device's holder.
> >
> > This is the call trace I described in cover letter:
> > memory_failure()
> >  * fsdax case
> >  pgmap->ops->memory_failure()      => pmem_pgmap_memory_failure()
> >   dax_device->holder_ops->corrupted_range() =>
> >                                       - fs_dax_corrupted_range()
> >                                       - md_dax_corrupted_range()
> >    sb->s_ops->currupted_range()    => xfs_fs_corrupted_range()  <==
> **HERE**
> >     xfs_rmap_query_range()
> >      xfs_currupt_helper()
> >       * corrupted on metadata
> >           try to recover data, call xfs_force_shutdown()
> >       * corrupted on file data
> >           try to recover data, call mf_dax_kill_procs()
> >  * normal case
> >  mf_generic_kill_procs()
> >
> > As you can see, this new added operation is an important for the whole
> progress.
> 
> I don't think you need either fs_dax_corrupted_range() nor
> sb->s_ops->corrupted_range(). In fact that fs_dax_corrupted_range()
> looks broken because the filesystem may not even be mounted on the device
> associated with the error. 

If filesystem is not mounted, then there won't be any process using the broken page and no one need to be killed in memory-failure.  So, I think we can just return and handle the error on driver level if needed.

> The holder_data and holder_op should be sufficient
> from communicating the stack of notifications:
> 
> pgmap->notify_memory_failure() => pmem_pgmap_notify_failure()
> pmem_dax_dev->holder_ops->notify_failure(pmem_dax_dev) =>
> md_dax_notify_failure()
> md_dax_dev->holder_ops->notify_failure() => xfs_notify_failure()
> 
> I.e. the entire chain just walks dax_dev holder ops.

Oh, I see.  Just need to implement holder_ops in filesystem or mapped_device directly.  I made the routine complicated.


--
Thanks,
Ruan.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

