Return-Path: <SRS0=332Y=MI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CF4C07E95
	for <dm-devel@archiver.kernel.org>; Fri, 16 Jul 2021 07:09:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 34466613C0
	for <dm-devel@archiver.kernel.org>; Fri, 16 Jul 2021 07:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34466613C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-dpEwut5XMX-_jfbIu7D8eQ-1; Fri, 16 Jul 2021 03:09:14 -0400
X-MC-Unique: dpEwut5XMX-_jfbIu7D8eQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5308F824F87;
	Fri, 16 Jul 2021 07:09:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9E1E5D6AB;
	Fri, 16 Jul 2021 07:09:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2A7A84EA2A;
	Fri, 16 Jul 2021 07:09:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16G6XYtO021151 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Jul 2021 02:33:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BC65E10545F0; Fri, 16 Jul 2021 06:33:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6ECD10545D5
	for <dm-devel@redhat.com>; Fri, 16 Jul 2021 06:33:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5A4B800B28
	for <dm-devel@redhat.com>; Fri, 16 Jul 2021 06:33:29 +0000 (UTC)
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com
	[68.232.159.87]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-276-Y24Gj8NUMpGjKIdk-xsbeg-1; Fri, 16 Jul 2021 02:33:28 -0400
X-MC-Unique: Y24Gj8NUMpGjKIdk-xsbeg-1
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="35021219"
X-IronPort-AV: E=Sophos;i="5.84,244,1620658800"; d="scan'208";a="35021219"
Received: from mail-os2jpn01lp2055.outbound.protection.outlook.com (HELO
	JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.55])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 15:32:21 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSZPR01MB6197.jpnprd01.prod.outlook.com (2603:1096:604:ef::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23;
	Fri, 16 Jul 2021 06:32:18 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b88e:7015:e4a2:3d9a]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b88e:7015:e4a2:3d9a%7]) with mapi id 15.20.4308.027;
	Fri, 16 Jul 2021 06:32:18 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Matthew Wilcox <willy@infradead.org>
Thread-Topic: [PATCH v5 5/9] mm: Introduce mf_dax_kill_procs() for fsdax case
Thread-Index: AQHXa7EmrHLpSGG2eEOWO38ftnVtTKspT/mAgAFCBXCAAE9xAIAaXSKg
Date: Fri, 16 Jul 2021 06:32:17 +0000
Message-ID: <OSBPR01MB29201EF10FBF32FF8B3A9168F4119@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
	<20210628000218.387833-6-ruansy.fnst@fujitsu.com>
	<YNm3VeeWuI0m4Vcx@casper.infradead.org>
	<OSBPR01MB292012F7C264076E9AA645C3F4029@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<YNsIGid6CwtH/h1Z@casper.infradead.org>
In-Reply-To: <YNsIGid6CwtH/h1Z@casper.infradead.org>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b5045b9-91a2-4d62-98d8-08d94823756a
x-ms-traffictypediagnostic: OSZPR01MB6197:
x-microsoft-antispam-prvs: <OSZPR01MB6197E43ED10BFFC2CD2362C8F4119@OSZPR01MB6197.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GzS+26NwGxg4d9jZzsN5HTKGfCCu/x9fbpkZvvYP2BETjo6CpicTjGCdL3ebzA7cWui4Qb2G3jcc8we1jApiwNXcnkeQwdo0DyDQNTNrOMX67JYI2swuyYqhN2JZiVzx4mE3jKToowFKK1TV0FEs6qwuCY1KuOD8vvQCuRzfUopSSPtS+J76w5sfsdDNbqp9BGgtjULWATJebNkifi238dPfdjFoYTT8sQ3N8nAs2H1VHR6o85MPizOQ0yuc6CldAaAt34V1wRDiRlrXRk3NP59fn09hVYCdVx+3vU9QKpGeV1YTwlpVeeuN/adwX9VYoK4zANYbowtWn+RPkKlR1nsz1docAUFDqfL3lO0GQKyAYVFlAYGyh2EET54B4g+P1qkTq0UChyfmsdjXIOSqKrFEOq8uhfs8Fxp58j3x7IxCrea0qEui7d0pf/lfF51+kXEsRtXiN0KA5POfZ6U6MzDgU5RQ4zXeUkVFhwuq9uu7hNvzDyfqC7FSHr6WVVLEGKrPDra8+mizy5b2MSVSYadTJ6xtUa+w2R050XsEjTKh44SrCso0GzEshxv/bHBoiWcV1kM4ZtYrkD76dfH6N+noCw7d+T8XieWT+d/IBIiMSCsVn0RGnGueDuxzX8Y31ZNVsOu35ngJhSWlu0p0ShtPa5PMjGuvDHuCWUe2nw87n4327cTdD4yw7mHkmBvnP6vC3LYTFtREZDcOxJQotA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(83380400001)(8676002)(85182001)(7416002)(6916009)(71200400001)(122000001)(316002)(76116006)(38100700002)(86362001)(66946007)(8936002)(66446008)(54906003)(33656002)(4326008)(26005)(66476007)(66556008)(64756008)(2906002)(5660300002)(52536014)(7696005)(6506007)(55016002)(478600001)(9686003)(186003)(38070700004);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?KzJSeWFTMG1tb3hxbFNVb0tJZXdxOUZYY3Y5MGV1TXJ0cmJ1T0VCNHpVVnR3?=
	=?gb2312?B?bDJ4bXhEVy9FMis4Z0RXRndCZHpOWXYxMjlBUFI0cW9sUXhQMWFwc1ViMjVB?=
	=?gb2312?B?ODVHR3p1MHdLYVlEdy91TmFMbVIrTFVGK2NKNTVlRnh1OG1yclB5NVZRWlhz?=
	=?gb2312?B?WTZyK0w1T1RTWkhTV0E0REVyT1l2b0tKYjhnRDF1SmhseUF2dEk1ZmEwY05z?=
	=?gb2312?B?a05vY1hRY2Y1SDNHZ3dyaUhHaUhJc1hTUlNzRW42em5WZlNTcktTYkNNNnAx?=
	=?gb2312?B?VG9LTUtVOEZrck8wcUkzYVMrNjErcUJQcEJkNEFFdHovM3VPb0hyaFNjTDVJ?=
	=?gb2312?B?c2NoeXVRNjc0SStUNnVhdUoxdU9Md1V4cFVPUCtyL1c1V3RXNDhhU2ptZGQz?=
	=?gb2312?B?WGpUVTBwNkFQdXdzMXNrWGRSN0ZmdXh2VytQMG5aSmpMMHp4dnhiYU5lL3JB?=
	=?gb2312?B?bUhJSlZJMGUrSkV5ZVNmMmtIcWtaeWVFZDJMTTJQd0grYVAzV0tTV0E2MXhM?=
	=?gb2312?B?R2ZFZkZzVWpzZXZrL0oyWFdZSlZCSTAzbmttcmdkWGJHVGRlelZQUXpCazhp?=
	=?gb2312?B?NUxGZjh2MFRNNEszTWFiV2ZscmJnNnJ1TDl6RUJVdDZWdlhWWHArUnJvemlq?=
	=?gb2312?B?QXROYnFuZHVkUmdFU1ZHQWErY3Qzem0wZU5sM29lOFB6cldtUC9YMTloek8r?=
	=?gb2312?B?RlY2TTgrTElIOHF4eWVQNnl3cTdHYXg1Rys5MFptdlhLM3hqTUJ2Z1RqUmhw?=
	=?gb2312?B?SmFLRVVHaFNUTS9JV0poeHFzWFBSRGQ3QVNwbUtHQzgvekhhTkNqYld0ZGs0?=
	=?gb2312?B?QUNBUVVrYVUva25taTZleXNtVjBWeEtHcXE4N2RPY0lKSFJXQkh6UU9HWHUv?=
	=?gb2312?B?N3duY0UrZ01RajVHQkw0MVEvM2w5NmFYb2lsdjgrSmZzc2JUMEpmNnNDdVdr?=
	=?gb2312?B?SHhxMUZTMGhEand5c2N6dFo3RU9Hdk85NFdXeUtlUFYxN0kxUkdkbDZXdXRF?=
	=?gb2312?B?SHRpbSsxOW16RHVMSVZRODdoM3grYTRUWmpHNS9XOWJlL3dvVFgrR0pXWHdV?=
	=?gb2312?B?TmZDa3U1Tmxua0pCSTFodmhPYXNsOEV0MW1Td0hLN0JxTlFDOGVzY2wzM3dU?=
	=?gb2312?B?ZnkxNFlzYVU5S1dMV25PUGdhMUIrZ0s3dnJKOUtIbWVVbU1LVDd5dDZqNDRr?=
	=?gb2312?B?ejhjY3RiL3hJTno3M0lYaVhGcmZrWnBlb2wvazhpaEhuOXk5NEdTamdjWHdx?=
	=?gb2312?B?UFIxOXdIVHFramhubnRIZEhLMEZBZHVxNCtESWxxVTVMYTZOSkJyelNFNk9E?=
	=?gb2312?B?Q1lEc0FkWlhQUDFyNHVTS1MyOHdVRFRWQ0l2bFNCcGNjcFJQZ1piaDd6Vjdh?=
	=?gb2312?B?TjJ4a1NoaGFmSDVYeExiNHdDTW5zaVZ4T2tBZ3Npb2szODFJR2Z2d1J5VDVT?=
	=?gb2312?B?VVpEQjVpRmE5QkxMYTRlZm9BZmtPMDNpWkZtN3ErR1VFZ0c5dEp2Z3RzR0J0?=
	=?gb2312?B?NHEwMlk1a0UrUFhVd1ZOd1RhYnBiQmxYQ0lhOGVKSG9CL2I1NWhwMUIya1hH?=
	=?gb2312?B?VERHTWp2akgrQ1FMNjg3aE40WHFNS2ZLMFZuQU9Hc3N5Uk5yUTM3L0JVZWRC?=
	=?gb2312?B?anc4SmZHUFluT1RoUmcwMmoxKzFUMWg5OUxDaUpkRlgwdldjU2tKSFF4eGZo?=
	=?gb2312?B?cmpUeXc3b3VURlVudnpqY0JhR1BtRFlLUFRKTHh2WHJVbWgrZEZRMUJJeWpP?=
	=?gb2312?Q?wc7P+Omjt9VjSkBFFRRx7Q2EkCjjBlSUXlAKPS2?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5045b9-91a2-4d62-98d8-08d94823756a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2021 06:32:17.9242 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Ur7kzhuP7Nyf66n+Ap10UBKipaGIxZibiMbF7I88Wb0pAbSrASfOiCD4KONmwckEXMc7fIBESGgG9te4V+PEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6197
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16G6XYtO021151
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 16 Jul 2021 03:08:59 -0400
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Matthew Wilcox <willy@infradead.org>
> Subject: Re: [PATCH v5 5/9] mm: Introduce mf_dax_kill_procs() for fsdax case
> 
> On Tue, Jun 29, 2021 at 07:49:24AM +0000, ruansy.fnst@fujitsu.com wrote:
> > > But I think this is unnecessary; why not just pass the PFN into
> mf_dax_kill_procs?
> >
> > Because the mf_dax_kill_procs() is called in filesystem recovery function,
> which is at the end of the RMAP routine.  And the PFN has been translated to
> disk offset in pmem driver in order to do RMAP search in filesystem.  So, if we
> have to pass it, every function in this routine needs to add an argument for this
> PFN.  I was hoping I can avoid passing PFN through the whole stack with the
> help of this dax_load_pfn().
> 
> OK, I think you need to create:
> 
> struct memory_failure {
> 	phys_addr_t start;
> 	phys_addr_t end;
> 	unsigned long flags;
> };
> 
> (a memory failure might not be an entire page, so working in pfns isn't the best
> approach)

Do you mean the range of memory failure may less than one page size?  I found those memory_failure* functions are using pfn as their parameter.  So in which case it could be less than one page size?


--
Thanks,
Ruan.

> 
> Then that can be passed to ->memory_failure() and then deeper to
> ->notify_failure(), and finally into xfs_corrupt_helper().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

