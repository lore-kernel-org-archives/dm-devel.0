Return-Path: <SRS0=t7n3=MW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6CEC432BE
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:55:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 63BD661058
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:55:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 63BD661058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-188s_CbkPCeQtTsBf7JUCg-1; Fri, 30 Jul 2021 09:55:14 -0400
X-MC-Unique: 188s_CbkPCeQtTsBf7JUCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4B011006C81;
	Fri, 30 Jul 2021 13:55:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 992FF5C1D1;
	Fri, 30 Jul 2021 13:55:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 58930181A2A7;
	Fri, 30 Jul 2021 13:55:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16U9R5nW017694 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Jul 2021 05:27:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9ACD721DE70C; Fri, 30 Jul 2021 09:27:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9302B2062C1A
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 09:27:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF6B38D138A
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 09:27:01 +0000 (UTC)
Received: from esa14.fujitsucc.c3s2.iphmx.com
	(esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-15-uPYw_m-KNAKJKvX28tWRsA-1;
	Fri, 30 Jul 2021 05:26:57 -0400
X-MC-Unique: uPYw_m-KNAKJKvX28tWRsA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="35766196"
X-IronPort-AV: E=Sophos;i="5.84,281,1620658800"; d="scan'208";a="35766196"
Received: from mail-os2jpn01lp2053.outbound.protection.outlook.com (HELO
	JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.53])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 18:25:50 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSAPR01MB4610.jpnprd01.prod.outlook.com (2603:1096:604:6e::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21;
	Fri, 30 Jul 2021 09:25:43 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b88e:7015:e4a2:3d9a]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b88e:7015:e4a2:3d9a%7]) with mapi id 15.20.4352.034;
	Fri, 30 Jul 2021 09:25:43 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: David Hildenbrand <david@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH v6 6/9] xfs: Implement ->corrupted_range() for XFS
Thread-Index: AQHXhSBovZIp2W/9YE+rhx/Wuicgv6tbPLOAgAACERA=
Date: Fri, 30 Jul 2021 09:25:43 +0000
Message-ID: <OSBPR01MB2920E338AE42C6696EEFD3AAF4EC9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210730085245.3069812-1-ruansy.fnst@fujitsu.com>
	<20210730085245.3069812-7-ruansy.fnst@fujitsu.com>
	<f0037d29-9402-6357-ce91-ef6e2e5b7c04@redhat.com>
In-Reply-To: <f0037d29-9402-6357-ce91-ef6e2e5b7c04@redhat.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff270130-5630-4402-dbfd-08d9533c018a
x-ms-traffictypediagnostic: OSAPR01MB4610:
x-microsoft-antispam-prvs: <OSAPR01MB4610508471B0D588B1831A36F4EC9@OSAPR01MB4610.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XWPP4udVU/wLzG+Cp7l/nQJrb/YgJi/AihPMuGkwcXE/kLnVhkw8pfR7hjPCTFuf6nUDWQE5dVCZnndznZ/r3Yo41tsZApGjpp+w8tyemj3TIDIL6Ca8dTnnHBc9tvnJwn+w4dvGjAYmEosKullIiiMRRB+wLtb3WKYM1iIFxVg65EU2o9zFcmdpRdwSl1FJB67mpXjcuLeDA5aIG13k+hyNY5c/pJwHUx5utGlx+QmKxDlne+aGdXNepP7n3RS75HDcXv7JtkaBaaw9Fj1wIFd+e/2a378QKrpbQR/6NTo5Hi/A8SeDiAInSdvKGfCmc9Hn6HnkF73T16BVD6GwNvAPCFAkkwmog/U9AoY9CxhWFkEqt3pFp601B52fTd1WQZvBWrE18Tl+ezN5I+PtEc5k/n9plKxfYE4Cm5XOSwtytSnnOoiGX7OusuGK2Zka6nDIAJj4M1wbWEw4m7qPquVg+seYNiN3zC6yQKAqUDopdPh7MMVVDra4jXD2TiLU6jPkwT2wpcQQR8dpKl4noyS8VtjJH72JxwbQ6G+u/jBCVuH2oKYQpzvRuvfW1rcYHCPGZQUEPamntYqkqPnZQWE3Ovw5nPMpYLMLWUhrwSYzNCLiIRl4YdkkFVd0fDnK5iQeehQEInAOLGk94EXyCOYfq5s14cRgl74mQNh5tAydkF6/tWwkWrNTKfARwDHa5rd5jRfG3KfGdiT/TzY9dg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(2906002)(26005)(316002)(86362001)(7416002)(6506007)(186003)(110136005)(71200400001)(4326008)(5660300002)(122000001)(85182001)(38070700005)(38100700002)(8676002)(478600001)(53546011)(9686003)(7696005)(66476007)(52536014)(83380400001)(55016002)(33656002)(8936002)(76116006)(66946007)(30864003)(66446008)(64756008)(54906003)(66556008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFVMSm1GVlRsQzZMMG1KbXZuaDVGSXh4UVd4MTlOZzdtY3dFbnB4V0g3b0Jl?=
	=?utf-8?B?SjZrVTVFR0YvM0Y4S0NJd0EzM01idXF6V1VWTFBOL3ljU0krSzhtdkp3Smx2?=
	=?utf-8?B?NTlaaGxGSXRUc1BWb0VaWVgvbWpoSTdiWFBmeGgwNERmWTZGUE9vRENGazJM?=
	=?utf-8?B?MGc2cEJmditPd1RvL2NTTHRZNGlOajFsbE9ubzlaRDVmbTBaU3dwTWJqOHBS?=
	=?utf-8?B?ck9nb2NtTmdKdFRRTHZqRGJqdS9jcDlwbXMxd2YweFNSTnJFejRjclJrVXRz?=
	=?utf-8?B?Y1BvSFdYdmxnOTBtN29YSWxvMUlTcmkzOXlQUExZTTZNN1dMNTY4Q2FUZytT?=
	=?utf-8?B?c2pMUUp6N2ttRFg3UGVab3hmeVVVbi9Ld3paM2FDZUZ2ZmhvTE1BdVhCNDhm?=
	=?utf-8?B?Q0RDWjJtS3ovbnl5SXY3SlZodGRFZHU2VDQ5RmZ6NW0vYXhzWnpETnFMVmVD?=
	=?utf-8?B?QUY5RVg4QU9ZaS82eW9WOEdtcW14WU9nNEwyYk5XR1BvTjhhTUhWbHJjNS9N?=
	=?utf-8?B?WWZEeWJvandaNEo3dWZRck9pRDRTNUdZcDhTVjZJbW1jMFBLWVUrRzlBaUg2?=
	=?utf-8?B?K1dxalBrcndzZXgyNjA3ak9WNU12czhZd0F4UG1jRFFiZm1KSTdRcXdlMnBi?=
	=?utf-8?B?UStCckVqaWR1WlBYdmN6NlQ5bVhRelpWMXBsVlduaTZFTzdlRENxSjBvOU5s?=
	=?utf-8?B?TzNUamI4d0NPWmR6Y0xsVHFFTDhTKzkxZ3lqcXN2dVFPOExuOWpka3RrNUNG?=
	=?utf-8?B?RTF0ZUxHRG1FR3RDT1FZOTdlb3l3VHpiRmNMTUtpOTJFbTUrQW4wWHJoS1lw?=
	=?utf-8?B?VDdkTHlGQTNnZ0xuSkZBUlR5bXlYRFFTK05WMmE2aUNZbnRnR2liVk55Y203?=
	=?utf-8?B?ampaQ1JNMGlkUXZ4aDQ2ZXdQTjBBaUNoY3U0ZlB1eTMyOEp6NDZydlh0SjZt?=
	=?utf-8?B?RUNON3d3U0xxaktUOW1WeUdkc0VQanZGM21wVnVjOU1HaEVFSFNhYlBiUVFW?=
	=?utf-8?B?aktYakhyRXJTVVEveVhLSVlOMjV2Y0kyZTUvVm9jRFZiTVJFZzhxYlc5bldI?=
	=?utf-8?B?ZU16MytUbTRmUFZBMlYvUjU0dzdhYkZ3VW5kbFFrbEZyWmxQVXNRTXUweXlS?=
	=?utf-8?B?QWc0U0hkUjFNdkNWcEFtejZpc3ZCY1VIS3c5c2t6dmJ2ZDdyMGladDh6SHFS?=
	=?utf-8?B?S0ZYSlpDamZKWllkaFhwa3ZEUENROXFEQXB6ZjMvUWQ5bisrbXp4Yyt1cE5u?=
	=?utf-8?B?TnlkUjR5cWhiRWg4Q0dKeDlaZ21iOEExTWtodjQ2R0ZKM1ZWaStPd1ZBSkp6?=
	=?utf-8?B?VGtaQ2Z4OXRFMVFFUC9IbTl3bzZSOEhZcVMzWDRhTEo3Vkh3VnVmSTlXVjMv?=
	=?utf-8?B?ZTJMRUlBd1lSMk9rbllqS1U3SkxDa2duMU5xaHBWbmw0RWNHSnRwdzdWOTZ6?=
	=?utf-8?B?aWtOQWQ4NGo3bGpqczVrOHRkTDdlREVEbHZXaHJwakh5cTRwOWRGVEZKMlRh?=
	=?utf-8?B?MHphYmxtVzY5V2Y1b3M0QzJoTEZyOUJKL3BrdTFRWExyZjlzbWkyWklpbGhp?=
	=?utf-8?B?enZPVHhVYmtoYzlqWUpVR3gxbnBObGhDVXFBeEV2akh3Zm5GVHBGZUhoUjVP?=
	=?utf-8?B?bUpDZTZVNmovU2VrVUh2Y25SVDJ3TmxwRHNyQ29ZUm9UZmZhcWJ6ZUJRLytU?=
	=?utf-8?B?M1kzb1U3QzZIZ2Z6UnpiWVV4R25TcXVYTlFsU0RZM3lYZ1lBQzVsUUlkemdZ?=
	=?utf-8?Q?S2E8/w0SQo3ylg/+FIJ1WFOPpsYNns4o4DloRC0?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff270130-5630-4402-dbfd-08d9533c018a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2021 09:25:43.7477 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qf53AchwNYjk0dl7MSrNOsYq86Aa/WJLEk3iIFLfgpXnL6qFRFhsdBNvbo/C4tm7aYNDBroIRJnHuReu6gPFGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4610
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16U9R5nW017694
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 30 Jul 2021 09:53:42 -0400
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v6 6/9] xfs: Implement ->corrupted_range()
	for XFS
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
> Subject: Re: [PATCH v6 6/9] xfs: Implement ->corrupted_range() for XFS
> 
> There is no ocurrence of "corrupted_range" in this patch. Does the patch
> subject need updating?
> 

Yes, I forgot this...  Thanks for pointing out.


--
Thanks,
Ruan.

> 
> On 30.07.21 10:52, Shiyang Ruan wrote:
> > This function is used to handle errors which may cause data lost in
> > filesystem.  Such as memory failure in fsdax mode.
> >
> > If the rmap feature of XFS enabled, we can query it to find files and
> > metadata which are associated with the corrupt data.  For now all we do
> > is kill processes with that file mapped into their address spaces, but
> > future patches could actually do something about corrupt metadata.
> >
> > After that, the memory failure needs to notify the processes who are
> > using those files.
> >
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >   drivers/dax/super.c |  12 ++++
> >   fs/xfs/xfs_fsops.c  |   5 ++
> >   fs/xfs/xfs_mount.h  |   1 +
> >   fs/xfs/xfs_super.c  | 135
> ++++++++++++++++++++++++++++++++++++++++++++
> >   include/linux/dax.h |  13 +++++
> >   5 files changed, 166 insertions(+)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 00c32dfa5665..63f7b63d078d 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -65,6 +65,18 @@ struct dax_device *fs_dax_get_by_bdev(struct
> block_device *bdev)
> >   	return dax_get_by_host(bdev->bd_disk->disk_name);
> >   }
> >   EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> > +
> > +void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> > +		const struct dax_holder_operations *ops)
> > +{
> > +	dax_set_holder(dax_dev, holder, ops);
> > +}
> > +EXPORT_SYMBOL_GPL(fs_dax_set_holder);
> > +void *fs_dax_get_holder(struct dax_device *dax_dev)
> > +{
> > +	return dax_get_holder(dax_dev);
> > +}
> > +EXPORT_SYMBOL_GPL(fs_dax_get_holder);
> >   #endif
> >
> >   bool __generic_fsdax_supported(struct dax_device *dax_dev,
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 6ed29b158312..e96ddb5c28bc 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -549,6 +549,11 @@ xfs_do_force_shutdown(
> >   				flags, __return_address, fname, lnnum);
> >   		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
> >   			xfs_stack_trace();
> > +	} else if (flags & SHUTDOWN_CORRUPT_META) {
> > +		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
> > +"Corruption of on-disk metadata detected.  Shutting down filesystem");
> > +		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
> > +			xfs_stack_trace();
> >   	} else if (logerror) {
> >   		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
> >   "Log I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index c78b63fe779a..203eb62d16d0 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -277,6 +277,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp,
> int flags, char *fname,
> >   #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the
> log failed */
> >   #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from
> a forced unmount */
> >   #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt
> in-memory data structures */
> > +#define SHUTDOWN_CORRUPT_META	0x0010  /* corrupt metadata on
> device */
> >
> >   /*
> >    * Flags for xfs_mountfs
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 2c9e26a44546..4a362e14318d 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -37,11 +37,19 @@
> >   #include "xfs_reflink.h"
> >   #include "xfs_pwork.h"
> >   #include "xfs_ag.h"
> > +#include "xfs_alloc.h"
> > +#include "xfs_rmap.h"
> > +#include "xfs_rmap_btree.h"
> > +#include "xfs_rtalloc.h"
> > +#include "xfs_bit.h"
> >
> >   #include <linux/magic.h>
> >   #include <linux/fs_context.h>
> >   #include <linux/fs_parser.h>
> > +#include <linux/mm.h>
> > +#include <linux/dax.h>
> >
> > +static const struct dax_holder_operations xfs_dax_holder_operations;
> >   static const struct super_operations xfs_super_operations;
> >
> >   static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> > @@ -352,6 +360,7 @@ xfs_close_devices(
> >
> >   		xfs_free_buftarg(mp->m_logdev_targp);
> >   		xfs_blkdev_put(logdev);
> > +		fs_dax_set_holder(dax_logdev, NULL, NULL);
> >   		fs_put_dax(dax_logdev);
> >   	}
> >   	if (mp->m_rtdev_targp) {
> > @@ -360,9 +369,11 @@ xfs_close_devices(
> >
> >   		xfs_free_buftarg(mp->m_rtdev_targp);
> >   		xfs_blkdev_put(rtdev);
> > +		fs_dax_set_holder(dax_rtdev, NULL, NULL);
> >   		fs_put_dax(dax_rtdev);
> >   	}
> >   	xfs_free_buftarg(mp->m_ddev_targp);
> > +	fs_dax_set_holder(dax_ddev, NULL, NULL);
> >   	fs_put_dax(dax_ddev);
> >   }
> >
> > @@ -386,6 +397,7 @@ xfs_open_devices(
> >   	struct block_device	*logdev = NULL, *rtdev = NULL;
> >   	int			error;
> >
> > +	fs_dax_set_holder(dax_ddev, mp, &xfs_dax_holder_operations);
> >   	/*
> >   	 * Open real time and log devices - order is important.
> >   	 */
> > @@ -394,6 +406,9 @@ xfs_open_devices(
> >   		if (error)
> >   			goto out;
> >   		dax_logdev = fs_dax_get_by_bdev(logdev);
> > +		if (dax_logdev != dax_ddev)
> > +			fs_dax_set_holder(dax_logdev, mp,
> > +				       &xfs_dax_holder_operations);
> >   	}
> >
> >   	if (mp->m_rtname) {
> > @@ -408,6 +423,7 @@ xfs_open_devices(
> >   			goto out_close_rtdev;
> >   		}
> >   		dax_rtdev = fs_dax_get_by_bdev(rtdev);
> > +		fs_dax_set_holder(dax_rtdev, mp, &xfs_dax_holder_operations);
> >   	}
> >
> >   	/*
> > @@ -1070,6 +1086,125 @@ xfs_fs_free_cached_objects(
> >   	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
> >   }
> >
> > +static int
> > +xfs_corrupt_helper(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xfs_rmap_irec		*rec,
> > +	void				*data)
> > +{
> > +	struct xfs_inode		*ip;
> > +	struct address_space		*mapping;
> > +	int				error = 0, *flags = data, i;
> > +
> > +	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
> > +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK |
> XFS_RMAP_BMBT_BLOCK))) {
> > +		// TODO check and try to fix metadata
> > +		xfs_force_shutdown(cur->bc_mp, SHUTDOWN_CORRUPT_META);
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> > +	/* Get files that incore, filter out others that are not in use. */
> > +	error = xfs_iget(cur->bc_mp, cur->bc_tp, rec->rm_owner,
> XFS_IGET_INCORE,
> > +			 0, &ip);
> > +	if (error)
> > +		return error;
> > +
> > +	mapping = VFS_I(ip)->i_mapping;
> > +	if (IS_ENABLED(CONFIG_MEMORY_FAILURE)) {
> > +		for (i = 0; i < rec->rm_blockcount; i++) {
> > +			error = mf_dax_kill_procs(mapping, rec->rm_offset + i,
> > +						  *flags);
> > +			if (error)
> > +				break;
> > +		}
> > +	}
> > +	// TODO try to fix data
> > +	xfs_irele(ip);
> > +
> > +	return error;
> > +}
> > +
> > +static loff_t
> > +xfs_dax_bdev_offset(
> > +	struct xfs_mount *mp,
> > +	struct dax_device *dax_dev,
> > +	loff_t disk_offset)
> > +{
> > +	struct block_device *bdev;
> > +
> > +	if (mp->m_ddev_targp->bt_daxdev == dax_dev)
> > +		bdev = mp->m_ddev_targp->bt_bdev;
> > +	else if (mp->m_logdev_targp->bt_daxdev == dax_dev)
> > +		bdev = mp->m_logdev_targp->bt_bdev;
> > +	else
> > +		bdev = mp->m_rtdev_targp->bt_bdev;
> > +
> > +	return disk_offset - (get_start_sect(bdev) << SECTOR_SHIFT);
> > +}
> > +
> > +static int
> > +xfs_dax_notify_failure(
> > +	struct dax_device	*dax_dev,
> > +	loff_t			offset,
> > +	size_t			len,
> > +	void			*data)
> > +{
> > +	struct xfs_mount	*mp = fs_dax_get_holder(dax_dev);
> > +	struct xfs_trans	*tp = NULL;
> > +	struct xfs_btree_cur	*cur = NULL;
> > +	struct xfs_buf		*agf_bp = NULL;
> > +	struct xfs_rmap_irec	rmap_low, rmap_high;
> > +	loff_t 			bdev_offset = xfs_dax_bdev_offset(mp, dax_dev,
> > +								  offset);
> > +	xfs_fsblock_t		fsbno = XFS_B_TO_FSB(mp, bdev_offset);
> > +	xfs_filblks_t		bcnt = XFS_B_TO_FSB(mp, len);
> > +	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
> > +	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
> > +	int			error = 0;
> > +
> > +	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev ==
> dax_dev &&
> > +	    mp->m_logdev_targp != mp->m_ddev_targp) {
> > +		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_META);
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > +		xfs_warn(mp, "notify_failure() needs rmapbt enabled!");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	error = xfs_trans_alloc_empty(mp, &tp);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
> > +	if (error)
> > +		goto out_cancel_tp;
> > +
> > +	cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, agf_bp->b_pag);
> > +
> > +	/* Construct a range for rmap query */
> > +	memset(&rmap_low, 0, sizeof(rmap_low));
> > +	memset(&rmap_high, 0xFF, sizeof(rmap_high));
> > +	rmap_low.rm_startblock = rmap_high.rm_startblock = agbno;
> > +	rmap_low.rm_blockcount = rmap_high.rm_blockcount = bcnt;
> > +
> > +	error = xfs_rmap_query_range(cur, &rmap_low, &rmap_high,
> > +				     xfs_corrupt_helper, data);
> > +
> > +	xfs_btree_del_cursor(cur, error);
> > +	xfs_trans_brelse(tp, agf_bp);
> > +
> > +out_cancel_tp:
> > +	xfs_trans_cancel(tp);
> > +	return error;
> > +}
> > +
> > +static const struct dax_holder_operations xfs_dax_holder_operations = {
> > +	.notify_failure = xfs_dax_notify_failure,
> > +};
> > +
> >   static const struct super_operations xfs_super_operations = {
> >   	.alloc_inode		= xfs_fs_alloc_inode,
> >   	.destroy_inode		= xfs_fs_destroy_inode,
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index 359e809516b8..c8a188b76031 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -160,6 +160,9 @@ static inline void fs_put_dax(struct dax_device
> *dax_dev)
> >   }
> >
> >   struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
> > +void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> > +		const struct dax_holder_operations *ops);
> > +void *fs_dax_get_holder(struct dax_device *dax_dev);
> >   int dax_writeback_mapping_range(struct address_space *mapping,
> >   		struct dax_device *dax_dev, struct writeback_control *wbc);
> >
> > @@ -191,6 +194,16 @@ static inline struct dax_device
> *fs_dax_get_by_bdev(struct block_device *bdev)
> >   	return NULL;
> >   }
> >
> > +static inline void fs_dax_set_holder(struct dax_device *dax_dev, void
> *holder,
> > +		const struct dax_holder_operations *ops)
> > +{
> > +}
> > +
> > +static inline void *fs_dax_get_holder(struct dax_device *dax_dev)
> > +{
> > +	return NULL;
> > +}
> > +
> >   static inline struct page *dax_layout_busy_page(struct address_space
> *mapping)
> >   {
> >   	return NULL;
> >
> 
> 
> --
> Thanks,
> 
> David / dhildenb


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

