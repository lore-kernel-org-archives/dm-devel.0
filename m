Return-Path: <SRS0=fTgt=EH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB47C2D0A3
	for <dm-devel@archiver.kernel.org>; Sun,  1 Nov 2020 21:33:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AD54A21556
	for <dm-devel@archiver.kernel.org>; Sun,  1 Nov 2020 21:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD54A21556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-GIZlQSKDMa2TFPOfk5r5IQ-1; Sun, 01 Nov 2020 16:33:27 -0500
X-MC-Unique: GIZlQSKDMa2TFPOfk5r5IQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAF7C185A0CE;
	Sun,  1 Nov 2020 21:33:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58B4921E87;
	Sun,  1 Nov 2020 21:33:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EC3F886C0B;
	Sun,  1 Nov 2020 21:33:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1LXJbb024861 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 16:33:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7D70542ACA; Sun,  1 Nov 2020 21:33:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 767F142AB8
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 21:33:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EEF2101AA5B
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 21:33:16 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [51.163.158.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-52-lKl0N1gJMp2evzrsD1vKCQ-1;
	Sun, 01 Nov 2020 16:33:13 -0500
X-MC-Unique: lKl0N1gJMp2evzrsD1vKCQ-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2051.outbound.protection.outlook.com [104.47.2.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-39-VWVwFSprOWaWWU4omCysvA-1; Sun, 01 Nov 2020 22:33:11 +0100
X-MC-Unique: VWVwFSprOWaWWU4omCysvA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB5866.eurprd04.prod.outlook.com (2603:10a6:10:b2::14) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29;
	Sun, 1 Nov 2020 21:33:09 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.029;
	Sun, 1 Nov 2020 21:33:09 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v3 0/4] add library to check if device is a valid path
Thread-Index: AQHWp/Ku9LkAs41VFU2tawoAA7qy2qmz3UeA
Date: Sun, 1 Nov 2020 21:33:09 +0000
Message-ID: <62b3ff51b69044b7d25460370210f59cd4ec492c.camel@suse.com>
References: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [90.186.0.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b83cff4-5548-45e2-a67c-08d87eadba85
x-ms-traffictypediagnostic: DB8PR04MB5866:
x-microsoft-antispam-prvs: <DB8PR04MB5866A3B62F93B738E7719EBDFC130@DB8PR04MB5866.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5Ov1wl6A/4miqF4C5WGBHFM2P0xEaYwv6t6+jJzmRBsepR1f1o4JpYd3JHrLqwvqF8c5vJjQS7wJFE6k8D40VRti3RVYQdD3oEssUCTp/5A3RlGrYDyFg+A9bGTLPR2Nnso7pfw0I5f1+E/1g9crmmnR8OVTwhvnoxEZ07ha+x/iWtOfRyYIuOITTgaWo4YMZ5tVa9LBRdn7MIdyizhEzbIfKChlg3+bGSJT23snBH5Qvq71o1+30S36lZQChBxHjJqClvcqzJpoQy/waZgA7udUB7mJWAKBIeuHjEWDSvY7s2LvZhdRs1enXHiAA/cWaA07j14QkG6BIp8do/nr78+vyWF9mxbsBFOrTUbvh5IW7UoDCOLEtks8XcSiZgN6ljZ3z3j9Rb9Pt0lfba8wqA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(6512007)(83380400001)(86362001)(966005)(64756008)(8936002)(66446008)(4001150100001)(66574015)(66556008)(44832011)(6486002)(2906002)(478600001)(8676002)(316002)(91956017)(186003)(36756003)(6506007)(66476007)(110136005)(5660300002)(26005)(66946007)(2616005)(4326008)(76116006)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: IPb8zzEc4SGBevuB3t2nnuTQJ5G2pGByifMBvhIJB89uT55d3ROEkAAW6XO1Vy7ONdUYzMFGToUHIPMf56rSgYopLV0cM0zMZtr7UDQ+xSKP/ofMed8G6G4fRryFSNbxOiPV0zv75EnJOwEmcEB38E6lGPSazlHxvDhz02zILCwQ2z1JRyUg3daX0wKJShxmA8k5N9TB/Q36gOmhWSn/uhouzeTUQm5SVmr8hz9n0J79xf1IzsGx0ji2dfW5VgU85iP1B3pofJ6EDm61iwpwNY38gJaslDC/bWmc8ux1+efhq+CFbKX+UjuJx8INlLB0YRRLewWk+3uQORblmV8yjs+hdo+853RvzknNPaA2clkeq7+gzQO5uJhpZvU6iCL8PasPphoKiLFDQoHYYP1GGWdGtZP/MeSBWSuuBKVmr00mC4c/o7ASR3QFt64AYdkGTVRztocnFP1c3Ck/QCaFdDqpCNBNC/46VpsmW/B6M4UHj5xHHzcfkO1eYdbgmy64kVzc5gB7kmst0BKtQvzKeWw4QQH5MZmpUGkjImdBUoZLTrCVolSO3HRIuwPFRWjLFseNBsvq5Gmi8709XCkStaT9wtenmg7whMcIX9DAONczkpAGY7hL50UomYuctA2eM3JUiy/So7UHB8ZzCVVnag==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b83cff4-5548-45e2-a67c-08d87eadba85
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2020 21:33:09.6108 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 55neZZyS/9j1s++eL3pVZEyI7OsC5TfuVqVWnnSumvF3nwraOTsFBs1g+/xKnxU0lpDSqC0c/decrnZgE9oVeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5866
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A1LXJbb024861
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 0/4] add library to check if device is a
	valid path
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F7BABF11A1433945A6FBEFAEB3AFCE8F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-10-21 at 16:39 -0500, Benjamin Marzinski wrote:
> The main part of the this patchset is the first patch, which adds a
> new library interface to check whether devices are valid paths. This
> was designed for use in the Storage Instantiation Daemon (SID).
>=20
> https://github.com/sid-project
>=20
> The seconds patch adds unit tests for this library. The third patch
> adds
> get_uid fallback code for dasd devices. The fourth patch just changes
> the get_uid log level for devices configured with uid_attribute "".
> This
> is because it is currently necessary to configure multipath with
>=20
> overrides {
>         uid_attribute ""
> }
>=20
> to claim multipath devices with SID (instead of using
> multipath.rules),
> since SID doesn't currently get the UID information itself, and it is
> called by udev before this information is added to the udev database.
>=20
> changes from v1 to v2
> ---------------------
> 0001: This patch is now rebased on top of, and makes use of Martin's
> patches that provide a default *_multipath_config, udev, and logsink.
> Because of this, mpathvalid_init() now has a parameter used to set
> logsink. There is also a new API function,
> mpathvalid_reload_config().
>=20
> 0003: This is completely new, since Martin pointed out that adding a
> new
> config option to always use the fallback getuid code was unnecessary.
> It
> just makes a uid_attribute of "" log at normal levels.
>=20
> changes from v2 to v3
> ---------------------
> 0001:   rebased on top of Martin's latest patches, fixed some small
> bugs
>         and added documentation to mpath_valid.h
> 0002:   New
> 0004:   was 0003. Untangled the logic, at Martin's suggestion.
>=20
> Benjamin Marzinski (4):
>   multipath: add libmpathvalid library
>   multipath-tools tests: and unit tests for libmpathvalid
>   libmultipath: add uid failback for dasd devices
>   libmultipath: change log level for null uid_attribute
>=20
>  Makefile                            |   3 +-
>  Makefile.inc                        |   1 +
>  libmpathvalid/Makefile              |  39 +++
>  libmpathvalid/libmpathvalid.version |  10 +
>  libmpathvalid/mpath_valid.c         | 202 ++++++++++++
>  libmpathvalid/mpath_valid.h         | 155 +++++++++
>  libmultipath/defaults.h             |   1 +
>  libmultipath/discovery.c            |  45 ++-
>  libmultipath/libmultipath.version   |   6 +
>  tests/Makefile                      |   5 +-
>  tests/mpathvalid.c                  | 467
> ++++++++++++++++++++++++++++
>  11 files changed, 929 insertions(+), 5 deletions(-)
>  create mode 100644 libmpathvalid/Makefile
>  create mode 100644 libmpathvalid/libmpathvalid.version
>  create mode 100644 libmpathvalid/mpath_valid.c
>  create mode 100644 libmpathvalid/mpath_valid.h
>  create mode 100644 tests/mpathvalid.c

As you probably saw, all acked. However there's a small problem with
the rebase on my recent patches. They aren't all acked yet, and Xose's
report about uclibc made me realize that there are more issues with
uclibc in my series. I don't think this will require major changes,
but e.g. on_exit() is unavailable in uclibc. I'd like to rework those.

Also, I'd wish that Christophe tags a new libmultipath version before
applying the "library version" series and everything thereafter.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

