Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08F8C3F6B0
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 21:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661375937;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dJ/0kf3847f31j5IS2Yeq5crTASnftXEvjXb3GjTmIg=;
	b=QUIDbaKHBCshPGH8d8NSbgqjxDRbjSfYCJjYFBNenxV1MK5sAY5phwlGPk/Kw9kwzHbGQF
	zOlJ91su5LSEzq5pR1e18VApJJh/Ncv+bhu76uW1E3nw3ouEXHwKpJ5mDYIadBI/gm5PPX
	PorMJWOV9uiCnkYHp9HAVKhxo8o4P74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-0B8bl89IOJ6o8TASp6btaQ-1; Wed, 24 Aug 2022 17:18:53 -0400
X-MC-Unique: 0B8bl89IOJ6o8TASp6btaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 093D28032F1;
	Wed, 24 Aug 2022 21:18:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7808F2026D4C;
	Wed, 24 Aug 2022 21:18:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 42CC41946A47;
	Wed, 24 Aug 2022 21:18:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4CEE21946A42
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 16:02:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E8F542026D64; Wed, 24 Aug 2022 16:02:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E41152026D4C
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 16:02:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5B361010362
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 16:02:07 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam04on2075.outbound.protection.outlook.com [40.107.102.75]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-VF_UndEBN8yDqZ8lXU3Viw-1; Wed, 24 Aug 2022 12:02:05 -0400
X-MC-Unique: VF_UndEBN8yDqZ8lXU3Viw-1
Received: from SN6PR06MB4495.namprd06.prod.outlook.com (2603:10b6:805:92::24)
 by DM6PR06MB6665.namprd06.prod.outlook.com (2603:10b6:5:254::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 16:02:03 +0000
Received: from SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::1d29:171f:86ab:60aa]) by SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::1d29:171f:86ab:60aa%5]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 16:02:03 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Martin Wilck <mwilck@suse.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Thread-Topic: [PATCH] multipath-tools: add more info for NetApp RDAC arrays
Thread-Index: AQHYt5LSvJ5cmMvt1E62wPgYQ2130q2+NKAQ
Date: Wed, 24 Aug 2022 16:02:03 +0000
Message-ID: <SN6PR06MB4495DCA7A61EDB90AC32B2DC8C739@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220823233352.70881-1-xose.vazquez@gmail.com>
 <29e34267dcf29ec1936a0cec095f483cdec65386.camel@suse.com>
In-Reply-To: <29e34267dcf29ec1936a0cec095f483cdec65386.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.600.2
dlp-reaction: no-action
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9de6ffad-cf77-44d4-29b2-08da85e9fc9d
x-ms-traffictypediagnostic: DM6PR06MB6665:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nde0TgSP7x9hREZRv8b36UHbUSDqTRrXB4kr8VKmXKKh2ygSXLKTZgFV9PL1pLTNdiciB4SOA3GEORopqIoBegB8+zpsSP+gVxjEBskIHETFhdYMIK/qoT4xt70ABWzRZiEwz0uz6ePWckmAAzdtvUASFubUtgKH/O7YI1kzADKXczRCW2U1gThyRc4EnafWNUVOu883Rto8+LuQOVaBoILeKPAkmE1WFe8cl30Rm9sOMZxiYo5KhUZg16gcyRKl4a+sf8WkCAVN8zBRW7Tv9QoaVHIVY9btDWLFFQt3pGiZUYhh30X0dcQc6mxjs1Ogog2Q4IIeLCBqotfN6nimdyRj1DusyG1XpWowfpC7uFNuE7lerPI9+DO6kLqk7Y3OXZ8mdF49A0cV5A5BEub6J3xuA9jJyTEQGk18zNfW7EjKTrb76r7zfigLNd+4h8yGVJyBea+blLJD52TWVOEVoKUookf4ZyKMdT6iZ9vWJO8qoa6dxFyoQWiFeSKiuy6PkApRdPBsoXiluLM/o2EIYav0dovsG4cHhGGFyIXyA4nQRUST58H59gMFyIToMs7yl0frOTE3LOe7OoBSaNNv+lWy50uh/EqiWWBKmwjew5SX5TrQzkbe5kGhS89wBdiNf/yFh6Esem91x9+JlY/P3aQIsEet3ieHoTshqCY/1vicA6vNhVOCTt4W/BIOY1LNUDw5ma+dfHXrDOfqaWgT4MeCSQAJE9iOiwIcSVV29qfDzNqyNQTLeFdrOcXMfi6/01gKwLZgmnB/v3p+SgvP+DXSkscO7uUpByNfnycG+/lh9sjYUqdB/MKm7vFMkJUg8iZngIVPd8z4F8NH1/xtDJEEfMTrjoNiIT8oGuBQUNo=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SN6PR06MB4495.namprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(2906002)(38100700002)(122000001)(33656002)(83380400001)(8936002)(55016003)(52536014)(966005)(5660300002)(76116006)(66946007)(66446008)(64756008)(4326008)(478600001)(8676002)(66556008)(66476007)(71200400001)(186003)(41300700001)(38070700005)(9686003)(26005)(54906003)(110136005)(7696005)(86362001)(6506007)(316002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0x2rDslLfZHyLR4nB0XkTH455Z9tA+0MPl3kK3aGOTZgcH3p+ts3906j7Bqc?=
 =?us-ascii?Q?IykYYM8HuBGRjc7mi61rpphWkLwEvhsmA1bPPoFsE0rjiVc9daKAmH5ZoN5r?=
 =?us-ascii?Q?ozXiKMYSlMTxYC7jQXCLD0r87auiP+v9AP2la+waSZ4IJ5rPqNMH0SwjMVqM?=
 =?us-ascii?Q?kaGsp5IDloJEfbej08LkKDzR4A+QkheMVhU8CjCLCXqzfvhJb+txkiolPWQV?=
 =?us-ascii?Q?7BLmLMMJTNJcD0jbG9+hyRnTptjcU80FyPJd7V3eXkLI1U7XgudRozfN4rAl?=
 =?us-ascii?Q?E4UfMMfbMwwbe7yxTQfb6DE3zabdm53eWkMbUT9uafa2JvSTSgjjRmjksrUQ?=
 =?us-ascii?Q?3t38pteNwDPZtZMhIVkEpLMTGyjaSBsS1XOUMcOZB4L5qbXCx+WcOEWVsdgi?=
 =?us-ascii?Q?MHQrldzzq9Qw1Cb+6kKvVR7OX5gzg0+0bE3I4yTgpgyINdnm4jgE3OqExYtM?=
 =?us-ascii?Q?jLLuwxrmvijAHt6kMOKy7xbZXqJETLSwvIFy6xFuhA6T35USOOkxM8xQ0HCa?=
 =?us-ascii?Q?tE7aONQ9b8SgWqI0OaoIa4+M6HlKpEjteRv0mrvW0GVSKLQa8L5cfmM9hafL?=
 =?us-ascii?Q?CBR0pcAIO7el6IKAhRtwYau2CudSN3qvAuZskXcRU1iKrnM7PHlCT/0Tbo7q?=
 =?us-ascii?Q?lAKqg+dkdZlSQspRAr43ce/nhZZrl5OtSktKTN+LixEyGXW9j1DjrRYTcnrX?=
 =?us-ascii?Q?nPAdvG3YMv16mYBQnCebcZeiAiKb8gEa0Mh/02rneNh5NGZt2VC0ujWvLm6h?=
 =?us-ascii?Q?/65F+C32fsHQWC4FjsPQ1IOgK4PmS9Ci1+CtHJXGZXqqcpqLzg/8y55YeC8G?=
 =?us-ascii?Q?GKSNN3wNldf26KADmrl0nRPhkA5Q57FFgo95fHmK8/ZHlXozSfB0Rczkt85F?=
 =?us-ascii?Q?DDat5Q91cKMWm3n0fa05Y9OLPQFQVQwmbL0aDfU+tJHwh/3XYz8KouheMSK9?=
 =?us-ascii?Q?ZBSAzm2enCxQj9rd5N3Czbjxy9FLg2y8Bq7uDyY/GZOzU+cvakfsOpWvIHQs?=
 =?us-ascii?Q?K4DGVjMRyuuF5Ogk5yEY4D6cu8DF509oRCLA9eLl33QiTtygpPpqqxjgwRO9?=
 =?us-ascii?Q?iBOrNEm1aCP9wby5nFiRpaW9Ch0jWR+KUy11H/rAXRRzizPYLaL9YaYYeHIA?=
 =?us-ascii?Q?+3ZRIxMXOOfIMpSSypxs/pr94UGWfWXQJvK65FlX8brRXdaLlCoFmkQ1BZl3?=
 =?us-ascii?Q?eilPdzwogXbc+xadQRnEzNLSuNEY15wje8+9GrMAriVoWHVVkbMDDobUyTsH?=
 =?us-ascii?Q?R5Z2+pH67pzXa2mwEPnYZ8Te+ePzL/QwMQ2Iy3Zb5Zj3zmOjMzPkfqFgo97/?=
 =?us-ascii?Q?xuaqVZLM8N9YVCySFkcIiUkhtTKEX6PNDt9cKPECiEMpXrDH15sfkUmc/ETF?=
 =?us-ascii?Q?dZpz53x48GE5o9MqNPstAq1pgXjDmZmw1JY6j7uVpy2YotjeSpe/sUnlAAQU?=
 =?us-ascii?Q?L4Gdil3YTIfU3zVUDPoQxpLgLgMkmhN/iYb241FagL4VdFzMNNsUn/mDYzYs?=
 =?us-ascii?Q?V89wlCHDEWBLWusaKBn5RqMVa03RpooURMeEgTocrhgo5fF1sA0zIP6LGU3U?=
 =?us-ascii?Q?+IMpgeH7rp5Hw3uZO/oEbkJiRoMUja+Tb8xedvme?=
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR06MB4495.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de6ffad-cf77-44d4-29b2-08da85e9fc9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 16:02:03.8222 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5kxYTtXrG6knJy8Nbg7edVORcve2ij0QbsLoH+QKOgKd/EJgSvOkHDXITAhVycfFFkww2yyMBBidHn/YibtbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB6665
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Wed, 24 Aug 2022 21:04:25 +0000
Subject: Re: [dm-devel] [PATCH] multipath-tools: add more info for NetApp
 RDAC arrays
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ng-eseries-upstream-maintainers
 <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Martin Wilck <mwilck@suse.com>
> Sent: Wednesday, August 24, 2022 3:24 AM
> On Wed, 2022-08-24 at 01:33 +0200, Xose Vazquez Perez wrote:
> > From:
> > https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-
> 49E94674-947F-4921-A1D1-CE9B42DCBA39.html
> > https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-
> CA17AE34-F5B2-4FF4-8FD4-4A7AA4238976.html
> > https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-
> 3DA657A9-FF4A-4237-90EC-BA8863B7431E.html
> >
> > To use ALUA mode, "Automatic Load Balancing" should be enabled and
> > "Select operating system:" should be changed to "Linux DM-MP (Kernel
> > 3.10 or later)".
> >
> > To use RDAC mode, "Automatic Load Balancing" should be disabled and
> > "Select operating system:" should be changed to "Linux DM-MP (Kernel
> > 3.9 or earlier)".
> >
> >
> > Add it to prio and hardware_handler, and to alua info.
> >
> >
> > Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: DM-DEVEL ML <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  README.md                  | 5 +++--
> >  multipath/multipath.conf.5 | 8 +++++---
> >  2 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/README.md b/README.md
> > index b05b1332..4e34c591 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -165,8 +165,9 @@ To enable ALUA, the following options should be
> > changed:
> >     "LUN Affinity" and "ALUA" should be changed to "Enable",
> > "Redundancy Type"
> >     must be "Active-Active".
> >
> > -- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series
> > and OEM arrays:
> > -   "Select operating system:" should be changed to "Linux DM-MP
> > (Kernel 3.10 or later)".
> > +- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series
> > and rebranded arrays:
> > +  "Automatic Load Balancing" should be enabled and "Select operating
> > system:"
> > +  should be changed to "Linux DM-MP (Kernel 3.10 or later)".
> >
> >  - NetApp ONTAP:
> >     To check ALUA state: "igroup show -v <igroup_name>", and to
> > enable ALUA:
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index acdd1ae6..58080990 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -6,7 +6,7 @@
> >  .\" Update the date below if you make any significant change.
> >  .\" ----------------------------------------------------------------
> > ------------
> >  .
> > -.TH MULTIPATH.CONF 5 2021-09-08 Linux
> > +.TH MULTIPATH.CONF 5 2022-08-14 Linux
> >  .
> >  .
> >  .\" ----------------------------------------------------------------
> > ------------
> > @@ -320,7 +320,8 @@ Generate the path priority for NetApp ONTAP
> > class, and rebranded arrays.
> >  .I rdac
> >  (Hardware-dependent)
> >  Generate the path priority for LSI/Engenio/NetApp RDAC class as
> > NetApp SANtricity
> > -E/EF Series, and rebranded arrays.
> > +E/EF Series and rebranded arrays, with Automatic Load Balancing
> > disabled and
> > +Select operating system: Linux DM-MP (Kernel 3.9 or earlier).
> >  .TP
> >  .I hp_sw
> >  (Hardware-dependent)
> > @@ -1568,7 +1569,8 @@ with Failover Mode 1 (Passive Not Ready(PNR)).
> >  .I 1 rdac
> >  (Hardware-dependent)
> >  Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp
> > SANtricity E/EF
> > -Series, and rebranded arrays.
> > +Series and rebranded arrays, with Automatic Load Balancing disabled
> > and
> > +Select operating system: Linux DM-MP (Kernel 3.9 or earlier).
> 
> Don't we handle RDAC just right with detect_prio and detect_checker set
> to 1? I'd like to avoid adding wording here that suggest to the user
> that she needs to tune settings, where it's actually not necessary.
> 
> Thanks,
> Martin

Yes, with the multipath defaults that have been in place for years now the
proper prio and checker get used.

The linked NetApp documentation is misleading, and I'll work to get that fixed
in the newer versions. Manual enable/disable of Automatic LUN Balancing is
NOT required as it follows the operating system type selected in the array
configuration.

Thanks,
Steve

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

