Return-Path: <SRS0=+Jjt=MN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE216C12002
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 07:54:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1727A61009
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 07:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1727A61009
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-611U9f4JN6qQvO9vu8GGrg-1; Wed, 21 Jul 2021 03:54:26 -0400
X-MC-Unique: 611U9f4JN6qQvO9vu8GGrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D8FF1005E41;
	Wed, 21 Jul 2021 07:54:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F13DC2C015;
	Wed, 21 Jul 2021 07:54:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 080354BB7C;
	Wed, 21 Jul 2021 07:54:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16KAbdbs018155 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Jul 2021 06:37:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2D71B2039D3C; Tue, 20 Jul 2021 10:37:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 273572039D40
	for <dm-devel@redhat.com>; Tue, 20 Jul 2021 10:37:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EB8F80B735
	for <dm-devel@redhat.com>; Tue, 20 Jul 2021 10:37:36 +0000 (UTC)
Received: from esa2.fujitsucc.c3s2.iphmx.com (esa2.fujitsucc.c3s2.iphmx.com
	[68.232.152.246]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-369-Ws-WCeJpM-eZno6wyFleAQ-1; Tue, 20 Jul 2021 06:37:34 -0400
X-MC-Unique: Ws-WCeJpM-eZno6wyFleAQ-1
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="43431570"
X-IronPort-AV: E=Sophos;i="5.84,254,1620658800"; d="scan'208";a="43431570"
Received: from mail-ty1jpn01lp2051.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.51])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 19:37:30 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSBPR01MB2277.jpnprd01.prod.outlook.com (2603:1096:603:25::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26;
	Tue, 20 Jul 2021 10:37:26 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b88e:7015:e4a2:3d9a]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::b88e:7015:e4a2:3d9a%7]) with mapi id 15.20.4331.034;
	Tue, 20 Jul 2021 10:37:26 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH v5 2/9] dax: Introduce holder for dax_device
Thread-Index: AQHXa7EcF510jwaUhkun35QO/tU+OqtKixAAgAFBEMA=
Date: Tue, 20 Jul 2021 10:37:26 +0000
Message-ID: <OSBPR01MB29200552738339C054E70A1FF4E29@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
	<20210628000218.387833-3-ruansy.fnst@fujitsu.com>
	<20210719151744.GA22718@lst.de>
In-Reply-To: <20210719151744.GA22718@lst.de>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8804f12a-9c92-48e5-b2e1-08d94b6a5e24
x-ms-traffictypediagnostic: OSBPR01MB2277:
x-microsoft-antispam-prvs: <OSBPR01MB2277352EC589EDF174AE1928F4E29@OSBPR01MB2277.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PCyejWLTDZ7dOwJrNa7QyPi4BjvuD9h9EhIhlxL+6W0cmfmajXUUVyzsuu1H9RmWUqjfTT+A1cekx9TUSD/6n945nwL4GIKEdZBWz2UsqnhF3mnV+JBraYktKdQA2rq1y/jjwBoXRo5tda1cwqUBuIP9vuazLyDUBsr1ew3OGhxVkZ3dlj/taMoW2gC04WuG5x5DHbyuOXUs9HVSOLhFEl3BCpcDvDxlKqGBzhH6APY3lk2vVEPur8tFtr/cPJCIQkCPkWcNglscH3kVcqo02eKxF3Gp1JzyotpkgaOb4lTDs/w+w8xrrffGY6fdvehPMuH2WDH87m+uScvqAQP2vo5pFkefEJeEWvsMFhbJjTloeOYhkytaARsUteii71RU2oKWOY9TYYuvsciYJB0+8bcJVGCzt6/sd3LiV6fvnC9lZ4WfiSZAQlc1rm4WRmREhzHarOfp/Xbe3E3YJ7XTOT8fbwktSqTBQFITyDJarlODg4s7poyXKtNU0ToMb3UrPycA1vk4vXokhy/O1yMwKB15pu9hMyAS0Qnl8KCapPraZzCSuIUia8qAOk+B+1X2m77uEJqt+1NXVCcZhf3WpuYxJTiuyOlPQpYHyEoy4PmqDx/6ElzKeJc0Wj4CYhvH9SmG0R+3y5bHPSZdPYtiPqWWQ66TvWDzLu7hePLiXQW9Oz1U1bCUqYW8MqVheP5AeK/khmjy6MQa8kipgHze9A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(71200400001)(76116006)(122000001)(478600001)(66556008)(55016002)(66476007)(66946007)(9686003)(64756008)(316002)(66446008)(54906003)(186003)(33656002)(38100700002)(83380400001)(8936002)(52536014)(85182001)(26005)(6916009)(4326008)(5660300002)(6506007)(2906002)(7696005)(8676002)(86362001)(7416002)(38070700004);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?V0o4ODhhcGZsQzZpeER1bjM1NEFtRHEvb3ZRZDRSZUFHNGUrbnJlUzNJVGxD?=
	=?gb2312?B?cEozOVoyMytRenRWZlZNRG5lRHFqZGNsRUtkelMwQmlvekZCby80MU0vK09C?=
	=?gb2312?B?ZW9MVlcvOGNhczdRT0VzUnhzUHZQVEExU0NQTUdqVkt3b1B5dldTcGRBb1NE?=
	=?gb2312?B?RW1EbGtuZWlMaW04NWFGL2dZb3ZXY25xdm1mcFJyNThWQTUxT2hHQk5PNXht?=
	=?gb2312?B?c3RXeE5nbXdVZzRidlVmS1Iway9iWXNhcSt1Ti8zYUFLbGFhMTA5UHp2cGdl?=
	=?gb2312?B?Qkpma3UzOGlSbXdPRVIrRnpXQXo3bXZrU1dxb2J4L3hrYkdiM2tVOXFpaE1N?=
	=?gb2312?B?T0RFYUdvMWtrOUhRU3l1QWJBbC9lRVViL2JCVGdKOXlQdkYyV0RqOWw0L3dJ?=
	=?gb2312?B?TGN4SG0wZTUvTEZxTWg3ZlVGaVVGQmVmc2ZZQW1lUG9RbHVmOWV1S3JCdnpD?=
	=?gb2312?B?QktLM0MzV2RFYmZHcWdTTVZPbnVRNmpBSlVpU1IxRU5yNDJtNEs3Y012dHcr?=
	=?gb2312?B?ZGQ5c1RZZ1R2dGo1NzZsQWx6c0lqOWcramVLcTRydE1GUFg4OU9KYzdNU2N3?=
	=?gb2312?B?dDlrVGhKb3VKbUh4M0xsYklDVHhaLzF4UU1WSk1aT1FUZHc2MU5lQU1qZU9T?=
	=?gb2312?B?Z1pTQkJ4ODFBQlJpdkJyWGhtcE05OE9kcjR2TkZyakNabzZvdnBjVDQ3K3p5?=
	=?gb2312?B?cFMyWkdVWFFwUE1Dc0p6Q21OM1RpQUQyNTBSMTBNVHBmdXY3RVc0NlFYWDM2?=
	=?gb2312?B?VXEraEpiY1pkdzJDbGNxUEFER096Yzlrcm1jU0JQVU5UcmFPV1dpdExUclNx?=
	=?gb2312?B?ZGZDbGVNK2RaaklBeUl4SEx0UWRDYmtCdUxma2JtVE5TdER3S2kvTm5GMDB5?=
	=?gb2312?B?MVpFajZ0V05vd1R0QVZFcGJBK2FLV2FXLzlhSkxOMnRYenAyVG9jbyt3QW4v?=
	=?gb2312?B?VGtwbS93U1NHQUlkd2R5T3EwMGJPdXZxVEI3TlQwT2JCRHdrZHpWMnpvdWVV?=
	=?gb2312?B?MFJsWmtUMi9nVzFmdHBPSmdxVDYyYkFCZkxrZTlhL3JkR28wS1NoajNpeHhi?=
	=?gb2312?B?b1VOWUdGWFhhL2p1OWJCSjdKSUdTeDNsdUh3Q2s4VURnbm44VnVIQXllOHV2?=
	=?gb2312?B?MXRVaUE4OVRXRFZWbitWUWxFc1hmU3M1ZzF1TFlqSExvOXA0bGpEK1l3WnZz?=
	=?gb2312?B?RGF3bzQwSWl3VS9wd3dROXV6N1ZKT1dnMjl6N3NHU2U2d09xd3poWDZCWm5j?=
	=?gb2312?B?Rm0zQUdxdWlreStJRWdTb1pFbWMwdVlBS09QQUNRRnRJK1lUQ1ZUZ05CZmhT?=
	=?gb2312?B?NE5mQUVReXVjaHBURC9IQ2NRcUNPeW1IbHptZ1pXdVJzeU9QSDMwRCsrUmYr?=
	=?gb2312?B?bmFNMEIxZk9jK0k1dXZMZkw0V0lWWDdCc3poeE8rNXJhbURPbS9tNkdYczVn?=
	=?gb2312?B?UlU4TTVUdUk5L0NOK3h5TFZySnp2ejN2OW92MkhTQ1hBR1FOY1lnbWFHbVF4?=
	=?gb2312?B?V3A1T3drc2EvUGxZczc0MjlyTEJyOTRJVkNkV282c1FPeVljakJmVkVWa09K?=
	=?gb2312?B?T1VVeGNXdURacm5IQ3ZYVWczcjE5SHRPNFZXdWpSUmgzeTZESjBMOUxjNDVD?=
	=?gb2312?B?SlBMU1NtbHdjbS9YaU90YnVNdVRoQnhHK21vNHU1STVGYm1adUUxUzd4Z1JC?=
	=?gb2312?B?NHBEdXhnRmNMclkvU3J5RlZ2OW5CNTBaUnV4WjRTenlETWZVZ05XVmxFbW5N?=
	=?gb2312?Q?mtOR7JMhG5o+KAjKzRYmyNpu3nuWKLCH97wi9KJ?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8804f12a-9c92-48e5-b2e1-08d94b6a5e24
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 10:37:26.7376 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bmGRijcGaSez1zdktXPjmb7POq6o2vZYcgmCvKNBY8fuf5e1Hosp4j0fvdq4a6FsbojHV3BKhKvkMo62sadLog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2277
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16KAbdbs018155
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 21 Jul 2021 03:52:50 -0400
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
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 2/9] dax: Introduce holder for dax_device
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
> Subject: Re: [PATCH v5 2/9] dax: Introduce holder for dax_device
> 
> On Mon, Jun 28, 2021 at 08:02:11AM +0800, Shiyang Ruan wrote:
> > +int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
> > +			      size_t size, void *data)
> > +{
> > +	int rc = -ENXIO;
> > +	if (!dax_dev)
> > +		return rc;
> > +
> > +	if (dax_dev->holder_data) {
> > +		rc = dax_dev->holder_ops->notify_failure(dax_dev, offset,
> > +							 size, data);
> > +		if (rc == -ENODEV)
> > +			rc = -ENXIO;
> > +	} else
> > +		rc = -EOPNOTSUPP;
> 
> The style looks a little odd.  Why not:
> 
> 	if (!dax_dev)
> 		return -ENXIO
> 	if (!dax_dev->holder_data)
> 		return -EOPNOTSUPP;
> 	return dax_dev->holder_ops->notify_failure(dax_dev, offset, size, data);
> 
> and let everyone deal with the same errno codes?
OK.

> 
> Also why do we even need the dax_dev NULL check?

Because this dax_dev is obtain by fs_dax_get_by_bdev() in XFS and dax_get_by_host() in MD.  According to their definition, NULL may be returned.  So I check the dax_dev here.

> 
> > +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> > +		const struct dax_holder_operations *ops) {
> > +	if (!dax_dev)
> > +		return;
> 
> I don't think we really need that check here.
> 
> > +void *dax_get_holder(struct dax_device *dax_dev) {
> > +	void *holder_data;
> > +
> > +	if (!dax_dev)
> > +		return NULL;
> 
> Same here.
> 
> > +
> > +	down_read(&dax_dev->holder_rwsem);
> > +	holder_data = dax_dev->holder_data;
> > +	up_read(&dax_dev->holder_rwsem);
> > +
> > +	return holder_data;
> 
> That lock won't protect anything.  I think we simply must have synchronization
> to prevent unregistration while the ->notify_failure call is in progress.

Yes, I misunderstood the purpose of the lock. I'll fix this.


--
Thanks,
Ruan.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

