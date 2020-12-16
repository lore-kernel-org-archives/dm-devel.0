Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7315C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:52:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E9A8233EB
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:52:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E9A8233EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-eDYO5uheNk-LJG8R50p1Nw-1; Wed, 16 Dec 2020 15:52:23 -0500
X-MC-Unique: eDYO5uheNk-LJG8R50p1Nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D0499CC09;
	Wed, 16 Dec 2020 20:52:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B90AC60CC4;
	Wed, 16 Dec 2020 20:52:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C01024BB7B;
	Wed, 16 Dec 2020 20:52:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGKqEOU003226 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 15:52:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 833B1D1D12; Wed, 16 Dec 2020 20:52:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7ACB6D1E97
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 20:52:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12AE680088F
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 20:52:12 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-580-qr9txoUEPnmYtToSTUWGrg-1;
	Wed, 16 Dec 2020 15:52:09 -0500
X-MC-Unique: qr9txoUEPnmYtToSTUWGrg-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2111.outbound.protection.outlook.com [104.47.18.111])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-3-oFCUjhaWMzWLlWrzo-eAeQ-1; Wed, 16 Dec 2020 21:52:06 +0100
X-MC-Unique: oFCUjhaWMzWLlWrzo-eAeQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5068.eurprd04.prod.outlook.com (2603:10a6:10:14::30) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14;
	Wed, 16 Dec 2020 20:52:05 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Wed, 16 Dec 2020 20:52:05 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v3 0/4] add library to check if device is a valid path
Thread-Index: AQHWp/Ku9LkAs41VFU2tawoAA7qy2qn6ireA
Date: Wed, 16 Dec 2020 20:52:04 +0000
Message-ID: <c62a2a29c7e958ae2671bca67f0c689885a7164b.camel@suse.com>
References: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8f69908-3e70-4828-ba17-08d8a2047225
x-ms-traffictypediagnostic: DB7PR04MB5068:
x-microsoft-antispam-prvs: <DB7PR04MB506803418A08DF70FD7C3F8CFCC50@DB7PR04MB5068.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: OVbaj00mNifYag7SwjFUSnMn6PbiblRp0HdO8Rt5333L/uWtC4lxNEI8rXtNzMBFgGuDTKLnaUgpIueGfNhxhQ6+B9hlp0Z0QQjqqFCWPYI6wtZ96J70Dnh5Dc+Wd1dwUdyzBh/dn/IAiEf/DddwVZGViCDSNN3r9yxFqKRrou2Sy1DAA6r6w+yZt6Wum3QwK36OnOi8lfN5u4gP5Q6NLmmd38x2BDnLVyPgG6qEJHcQE/m6YBPiMUg4Gq4GsSe50LFLify9A4NGfGI0w3NNendmWINK75f/L1B5WRLNYdtvOPWm/ai6nGXhz4ED1HnX8efY6nCpATLZ2lU6xdzqQ+KV7cnNqNPN81T1v0eb451BHrtm0PY7N043SLwYapgcRJJh5eJ0ygdIsj2H0+tnbw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(5660300002)(44832011)(966005)(64756008)(6486002)(6506007)(26005)(4001150100001)(66946007)(2616005)(71200400001)(8676002)(36756003)(76116006)(110136005)(2906002)(86362001)(91956017)(66556008)(478600001)(6512007)(4326008)(66574015)(66476007)(186003)(316002)(83380400001)(66446008)(8936002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?0Xty4pE1890VivN5Fk0jrodNNSqbd1ZfTWKMn8Xn62QJSuvyzP65RnXUJ?=
	=?iso-8859-15?Q?0l/l5FUNiIQHamX5aURuRwAWQNAyZJqVlGbkzJb6yKVneczFicJogWAzb?=
	=?iso-8859-15?Q?mihJVYCqBundqWhw+rxDN44OFyZk4UCP0PdKCxudqESc1OQSd6tVmihIj?=
	=?iso-8859-15?Q?RJkEVU+YwyzZnVYmsbHIav44m620SEkGsx0y5KABJ4XMIEV+UzMfHaLTf?=
	=?iso-8859-15?Q?apZIk1aJQgg7CHnDrWrmNY//fXDMZ5dq5TDIdBQ+JrCSNnYSmeBwSFBM1?=
	=?iso-8859-15?Q?W5j8iAFiOmRr+hlekSSZ+8myN4jTK+KDnIxS/4HbHWQ6n2//FhZccxTO2?=
	=?iso-8859-15?Q?gq1tRQIukBKXyxaYF5d6i+11tiGHfy20qz70VkkNkp8leWXdZMWa9719V?=
	=?iso-8859-15?Q?nq+YBVbOv4SSL+hM3OtFFFpHTU8G7rb7TH9ep08kD88aDhgY/OdtweStF?=
	=?iso-8859-15?Q?ZhmnF5VMkG/hJDCm3rlb4XFQBMIJmTQzCdHFYTJu+kzy096fNx+YqaVRq?=
	=?iso-8859-15?Q?yUuSFNItfSjHaEa2lFt5tBpfkGQUDsS1LbLRxl3Q+zJ4snf6S8LniwAL0?=
	=?iso-8859-15?Q?uJyZ8cWfeGdD/YCsvvtiH8sLB/7CJcVwgDRDBCL4rlSniS0hSGB+gXaiZ?=
	=?iso-8859-15?Q?pEs+klRxamwnr+AQC2uu9VDx1hkGfMS9jT1yXIPa5PrWmXeoe2Mt8Q5I/?=
	=?iso-8859-15?Q?3xUQ12m6j1ez6KWpm7H2r6lYBMqucqKrOEnJdA4HvxI+Vr4rVZrONwzBv?=
	=?iso-8859-15?Q?NOgESaNegHTeTP1iCal6bzbS4SCVnzSHFDa8yDNz6HZwye0NKpt2y2uJR?=
	=?iso-8859-15?Q?05ILPsgfL6IjnHeiPTbjFCXB6F7DLNj/Y//xzUIcw3kKGqnjWGNW9eZqv?=
	=?iso-8859-15?Q?18B7yJRkhQcjZU+8F1E9kQOWgOJx4UV+zEJKjDK+I1cJGlZY9rDBVpCeZ?=
	=?iso-8859-15?Q?O4Q8W9dVdKWyjE3eifOwe3GcsXHMCP/TjDj4ClR51DqhUu5qCTOm7Ojsg?=
	=?iso-8859-15?Q?XH7OP1tCWv5W4iwAIaznvk2Ds8Alweu/MuJx4cz50i0r9OAhvVkGn+W?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f69908-3e70-4828-ba17-08d8a2047225
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 20:52:05.0050 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: twrtocUiUHfYCzC3spTYUusmdRAj11bC6iIzg3AoWX1mF9Q4RmI3I+j9IHK20MGq3fv70JDAVoqmODhQwOBZBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5068
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGKqEOU003226
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3293644E494B6E4D8C398F63B9C199AB@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Ben:

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
>=20

For the set:
Reviewed-by: Martin Wilck <mwilck@suse.com>

I have created a new branch=20
https://github.com/openSUSE/multipath-tools/tree/upstream-tip

where this is series applied on my recently posted series
"libmultipath: improve cleanup on exit" (v3), in the hope that it will
pass review, too. It has to be this way around because your set
requires libmp_verbosity.

As soon as my series is finalized, this will be pushed to upstream-
queue.

Regards,
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

