Return-Path: <SRS0=ZDE9=LL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F73C2B9F4
	for <dm-devel@archiver.kernel.org>; Thu, 17 Jun 2021 07:05:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C74EA61369
	for <dm-devel@archiver.kernel.org>; Thu, 17 Jun 2021 07:05:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C74EA61369
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-s_KZn-OBOpCE28JFmvSrtQ-1; Thu, 17 Jun 2021 03:05:43 -0400
X-MC-Unique: s_KZn-OBOpCE28JFmvSrtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 957B71012586;
	Thu, 17 Jun 2021 07:05:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B4B45C1C5;
	Thu, 17 Jun 2021 07:05:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE2B71809CAF;
	Thu, 17 Jun 2021 07:05:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15H6qGkH031279 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 02:52:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6333020FE6AE; Thu, 17 Jun 2021 06:52:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E50020FE6A2
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 06:52:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 152ED101A531
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 06:52:14 +0000 (UTC)
Received: from esa2.fujitsucc.c3s2.iphmx.com (esa2.fujitsucc.c3s2.iphmx.com
	[68.232.152.246]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-190-24LBvLSdPMeDyW98l1e50A-1; Thu, 17 Jun 2021 02:52:12 -0400
X-MC-Unique: 24LBvLSdPMeDyW98l1e50A-1
IronPort-SDR: AuDTIrPqhhn5FGoDfRNZPlWCYwFCZt4BlwwM4q/eVoiAurV4LvZRbHGt+HEmRE5RUJBv7kyJbE
	EO0khuLelaOPhVC9m5BLTHJFbcGXS9AS+2ThY3qDCqOgFrTleHlg5+Ab1QMWcGuFfsDGGUNew8
	NS7zhuuw5rDF4zM401KmT2UIq1PHvq3URBcqytEcpDco5kxy730/UfkcH2zoxAfYhzU7FnwZNC
	mDHn1l/PUtYauUu0DkvuGhGEIOOm5Epme9UnGjsGExZLxiVp6GRX1DG2+bi7C1h3ro6WQ+uxre
	pPI=
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="41442165"
X-IronPort-AV: E=Sophos;i="5.83,278,1616425200"; d="scan'208";a="41442165"
Received: from mail-os2jpn01lp2052.outbound.protection.outlook.com (HELO
	JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.52])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 15:51:05 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSBPR01MB4856.jpnprd01.prod.outlook.com (2603:1096:604:7c::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16;
	Thu, 17 Jun 2021 06:51:01 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b985:8239:6cf0:1228]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b985:8239:6cf0:1228%7]) with mapi id 15.20.4242.019;
	Thu, 17 Jun 2021 06:51:01 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for superblock
Thread-Index: AQHXWN/AzVDrjJsgmE+2b5OugDUMoqsV4P2AgAHv3zA=
Date: Thu, 17 Jun 2021 06:51:01 +0000
Message-ID: <OSBPR01MB29203DC17C538F7B1B1C9224F40E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
	<20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
	<CAPcyv4h=bUCgFudKTrW09dzi8MWxg7cBC9m68zX1=HY24ftR-A@mail.gmail.com>
In-Reply-To: <CAPcyv4h=bUCgFudKTrW09dzi8MWxg7cBC9m68zX1=HY24ftR-A@mail.gmail.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [223.111.68.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bc86cc8-d9ee-4736-37ed-08d9315c44f3
x-ms-traffictypediagnostic: OSBPR01MB4856:
x-microsoft-antispam-prvs: <OSBPR01MB4856A89FF3579D50D3422FC8F40E9@OSBPR01MB4856.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: tYl0grprqRz+W6fT1QjtUggeWce5+pK/AHly/LYAfJmrvhqlNtcx+JaHfJw2SZmpcfHQFdOw1cegHG4MuYiXaryM10FXIOaRraX8OImoVEbrXWycrCF47gXmSaxEm4Y1xvJ79pHo2sDIHz7b6g7cRj8jw2jMu+x4zCYL61vYVV4lUBHc1nLfLAeIO+nfpRn8SRh0SpEMB6YiGvZHdSl71s3HFtWK3Nwq1AF5rgGJvxhM7R4VXopmcvak7p2B91tWHg/L3GShc2veEpTVt2Bme7omt7wmY6glxBZDtAkgVhBH1WK9DY8uZ38ImosVX4RYNqr/yELO/ldabbPaObjoqunRWedf1Y6OpbMo+HX4y3aEjv91fQDvsKXH+u7iTo/lLcpYrZ17MztZkDHQIC7q1rcybgeJQrcWuuP+qI9IlR0qqobSyiocJAsJeVAuJYSiXogF5Jk+sRaDk6fpwJiDo7AsG16m7s3HGOlsZrd6TpCysN1SO+zDSWB7vzUyouF1ZaoFP6DaWacfIAQQ3LJCglEgA/m29WNZmuKbKJwqWGsC/jTllEjgAXcBJ2tj5/yufN9vES1Cez81oW18/Rxf/yDhdo1WRPKOLX8VYnAI4SQ=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(39850400004)(376002)(346002)(366004)(396003)(83380400001)(316002)(7416002)(66476007)(478600001)(38100700002)(5660300002)(86362001)(7696005)(2906002)(8936002)(54906003)(6506007)(186003)(9686003)(66556008)(55016002)(26005)(71200400001)(52536014)(8676002)(6916009)(33656002)(66946007)(66446008)(85182001)(76116006)(4326008)(53546011)(64756008)(122000001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGNGa1pCek5FR0pNQjZtci8zMWQ2SmRySnJ0NDNjcmxlZUtmcm5EeXkwV0xp?=
	=?utf-8?B?VjUxZ3dKc0VNa3d5bWtxejczY09DWVlmd1dpYjJIdHpYZ255S0ptcXBMa011?=
	=?utf-8?B?ekZPeG9hTE1HTlJGQ3BOanVSZmFvbW1KMC9qQUh3cXdQVU5HRU53Sndwc0Jo?=
	=?utf-8?B?czN3ajdFRjBldE5rZW80VWdqeHY1L0gxRVd0SFErZk50a2hiUm9CZGw3R0dV?=
	=?utf-8?B?VnE1MHgwTTgrMFFMcmUzR3lwWXJUMUhWeG9jOFR3WkIvWWNEK2ZFOXB0TCsv?=
	=?utf-8?B?R3MyWmJvR3ppcVA5NWIrZnVabTdzb0FWL0lBTUhFWW0wK0ZYTTlyL29PZi9P?=
	=?utf-8?B?ek4yeVFwdWJlNlBVSGFjSUpwbDJ2MUVuck5rWitiK2RLekUvYjRCTVBDeWdS?=
	=?utf-8?B?bWxPZVJwdElaMTJ3Z0JyaEJYclBqZWFxNVo0VGFBcUQ2SXpzL2hxSkFCTTlj?=
	=?utf-8?B?U092clJ0QjdHK0JBVllGNk1pVlRMN0FHdW80YjFQVzIxWnpjTWEyeHJzRkN3?=
	=?utf-8?B?cE9OeDQ5RVhaWUttVXBQbjlhQURwTXlKQ0JxNW90VndNZ25OOHhLS09Kc0RN?=
	=?utf-8?B?aGt3SnhscklLRSt5SndFSFk5SGFwR2FLUm43bUFnVGFQNVRnSm9WU1ZrbG1D?=
	=?utf-8?B?RTVtMXlnYTJkazFUY2VPOS9tMnJKNTVsWFVQT2pyVzlWdVVpcDZsYi9vcDM4?=
	=?utf-8?B?L29vNnZtWHF4RW0raUUybnhtNlFkOHd0MEZ4WnZqOUU0R3ltdkgvY2VqcXBU?=
	=?utf-8?B?Y0VjSW50S3VITGR3WmdNN0VKM1Y2dCs0d0U1ZmI4NHE5aFFnSm5sUXJXa3NQ?=
	=?utf-8?B?WE5OZDV5cm9RWERFU0dVd0g3S3dXemxHcWxCRUJqOUFLdXRycm03L2VqaEVv?=
	=?utf-8?B?dDM0cFl3b3VqdVZ4OW5vcHc0MU1sZmZKdElVYjhLZ3NLRStsYjcwaURYYnFy?=
	=?utf-8?B?ZHBNaGo4NTJTQU5GRzJRTW9EK0pqR2IySDdDUXd1NnpjOWYvYnp2ZVpRNXVu?=
	=?utf-8?B?ZktGR0w2ZmdySnFLUEdCWDlEZjNHTUxEYjJjQ1ZhU2lWTVNJTThhWTVhLzdF?=
	=?utf-8?B?bEVOeUJWMUYwNWVUdjRVR1loSWFNdk42K2J0Z2FNNjY5REQwUHRkaUZMdVUv?=
	=?utf-8?B?ay9RRE12cUJHWjc1NktkZ0FndzVZT0srdGw5QWhpUnBoYjVVdVdWRGk5VDlM?=
	=?utf-8?B?eFpPOTIyWjFWaG9wRENCWlYraWxwcnNIVzdPQkQ2MzZISzYxdmgwMkRRQlo0?=
	=?utf-8?B?Smd3WllMdXNVcG4weElXdHFFWE1WZEJmeEcvakVHeGVYYllseFNwY2Mvbzkx?=
	=?utf-8?B?UW1DczE4OHJKdXY2UHVaUWZlY2tiRkNEbFlhNXpZeEZJYmZES1RrQld6cGZt?=
	=?utf-8?B?cC9mUnluNHNKZnNGNmtEUkFUdXRnVjkwQi95TU03Z3hqUDV0amdUalVjbFhm?=
	=?utf-8?B?aDluV0RrVlY0b3cxUWowOWpOV2l0d3IyalFIQVp5VldYMjdFbnEvRXg3NnNm?=
	=?utf-8?B?SFIzcmZrdEVJZkNyTXlIQnhiMlJkbk5tUW54bXBwbnZocS9CRk91a0lkMTBW?=
	=?utf-8?B?RFo3b0lMYmpPR2kySk9iYTcwdFVabUxEeDFrcHlUMW5QbHl3OU1ZUVRZbmIy?=
	=?utf-8?B?aGZja1hPd3dFalYzMEQ0Qno3K1BJZHphT2VkZHJva1ZhRG5iVE9rTk9LREcz?=
	=?utf-8?B?T0oxd3NxRlBNVldLbGZvZmtZb1VyNW1OdXM4ZFV1czdZREtwSUJ6QVcwYkZX?=
	=?utf-8?Q?xKgrLvvn98zJ+7/l/E/nlm2QRA0yEYD0ETrBs3y?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc86cc8-d9ee-4736-37ed-08d9315c44f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 06:51:01.2138 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZNyeEpxnh2h2NQPVuaOkbKiYSDw2095Z24xBRfNevIfCBaZDaLNG0jLJ2hrGzsmX/it518RqkD7VhyWT6aWFkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4856
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15H6qGkH031279
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 17 Jun 2021 03:05:36 -0400
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
> [ drop old linux-nvdimm@lists.01.org, add nvdimm@lists.linux.dev ]
> 
> On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> >
> > Memory failure occurs in fsdax mode will finally be handled in
> > filesystem.  We introduce this interface to find out files or metadata
> > affected by the corrupted range, and try to recover the corrupted data
> > if possiable.
> >
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >  include/linux/fs.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h index
> > c3c88fdb9b2a..92af36c4225f 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2176,6 +2176,8 @@ struct super_operations {
> >                                   struct shrink_control *);
> >         long (*free_cached_objects)(struct super_block *,
> >                                     struct shrink_control *);
> > +       int (*corrupted_range)(struct super_block *sb, struct block_device
> *bdev,
> > +                              loff_t offset, size_t len, void *data);
> 
> Why does the superblock need a new operation? Wouldn't whatever function is
> specified here just be specified to the dax_dev as the
> ->notify_failure() holder callback?

Because we need to find out which file is effected by the given poison page so that memory-failure code can do collect_procs() and kill_procs() jobs.  And it needs filesystem to use its rmap feature to search the file from a given offset.  So, we need this implemented by the specified filesystem and called by dax_device's holder.

This is the call trace I described in cover letter:
memory_failure()
 * fsdax case
 pgmap->ops->memory_failure()      => pmem_pgmap_memory_failure()
  dax_device->holder_ops->corrupted_range() =>
                                      - fs_dax_corrupted_range()
                                      - md_dax_corrupted_range()
   sb->s_ops->currupted_range()    => xfs_fs_corrupted_range()  <== **HERE**
    xfs_rmap_query_range()
     xfs_currupt_helper()
      * corrupted on metadata
          try to recover data, call xfs_force_shutdown()
      * corrupted on file data
          try to recover data, call mf_dax_kill_procs()
 * normal case
 mf_generic_kill_procs()

As you can see, this new added operation is an important for the whole progress.


--
Thanks,
Ruan.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

