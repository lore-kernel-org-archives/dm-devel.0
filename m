Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616DDC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 14:56:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC4D861547
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 14:56:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EC4D861547
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-Whqz6hMaNUGcVwVgsb-Xmw-1; Thu, 18 Nov 2021 09:56:33 -0500
X-MC-Unique: Whqz6hMaNUGcVwVgsb-Xmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 460681927800;
	Thu, 18 Nov 2021 14:56:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 500795D9D5;
	Thu, 18 Nov 2021 14:56:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5472F180BAD1;
	Thu, 18 Nov 2021 14:56:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIEuLjj018964 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 09:56:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7F8B04047279; Thu, 18 Nov 2021 14:56:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A0F1404727D
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 14:56:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C06085A5B5
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 14:56:21 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-33-fKwLQeWjPvSS7sd-ZpqG8w-1; Thu, 18 Nov 2021 09:56:19 -0500
X-MC-Unique: fKwLQeWjPvSS7sd-ZpqG8w-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2110.outbound.protection.outlook.com [104.47.17.110])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-22-t9VgpwF0PMW-A_2Mm_PTfA-1; Thu, 18 Nov 2021 15:56:17 +0100
X-MC-Unique: t9VgpwF0PMW-A_2Mm_PTfA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4922.eurprd04.prod.outlook.com (2603:10a6:10:18::29) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22;
	Thu, 18 Nov 2021 14:56:15 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Thu, 18 Nov 2021 14:56:15 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v3 0/4] Add "reconfigure all" multipath command
Thread-Index: AQHX3BBQXpNzFs4GkkysNti6pxTu56wJYL2A
Date: Thu, 18 Nov 2021 14:56:15 +0000
Message-ID: <84a3edae8bc303e37d01c7def1f091c208117100.camel@suse.com>
References: <1637194052-5985-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637194052-5985-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8295671c-7243-4c55-f0e3-08d9aaa391fa
x-ms-traffictypediagnostic: DB7PR04MB4922:
x-microsoft-antispam-prvs: <DB7PR04MB492250484CBAE33D1EB47BDAFC9B9@DB7PR04MB4922.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2pnuDSDkrvc+rIoMDoWnYEU8KF74UmJHcZ+CHmOemN0ezeQqOsmIUywldoiKMK0nCC7ZDA6PA9abjlmdOIdm9qMquN7o7SU5Qmd1L7LsW6CizvdQ/gi+WnZq5XRbkXdea0NnpBT/91J7gj2qdXMH3gjz2PEwd3Ns1A9oJvYZH35ToRB8fz636mIvay6NAKYJWuZa9Zlomw9RdtwTtcDhFRfMq/zlj4sl6X7+zuRG0uGgpt/yBwaGCFsjsIkhilVKnUl514ExF0Hrb8Xzyxk3kxZ4q5pFWPCLZFhLkVHxqcsPiof7cjPXNNlpToLv4tmJX/78dwW0fStgWhubGPo3o0q3LMG7BAPuxURFlbKgzFT9immrW3FA4IfdcnOicN8IzMTlh0RQ8OrixTrwYijuOocZrJM/6FWNgdz9aC4W/Zy2wAET+MfUDkZP2ZAugQpP+j2vyw+xYVW43z3g36SMWLexyfmKFKQJTNRXv/76fcp3gevcV4qkGPHwdXxyLXWPBWW3XjCee7PHek5S4zjSHeFk7i1UfK2GQGKP4TX4bhP1azGKJaiv5wk5Zw7J9u93+BR5LIhQOLMnHudDwqtiyBab4mNyxrn4w5rK70KAirq/ddeA37B7pCTfhMgTnclyt3eym2ljYupH+/3B5oGUrk8XOZ601jcq7yY6NNWzz0tyJKxQTZ/G/cloxEW1K3rU264R4jXfLBjIaRefR87Pcg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(2906002)(6506007)(2616005)(5660300002)(186003)(36756003)(4326008)(38100700002)(71200400001)(4001150100001)(122000001)(38070700005)(91956017)(6486002)(86362001)(8676002)(6512007)(316002)(64756008)(66446008)(66556008)(508600001)(66946007)(66476007)(110136005)(8936002)(26005)(44832011)(83380400001)(76116006);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?+iH8VoHwMetN5IpjRXIsyMdxnOgj2gfgGT+vRIW52xNdIdSgnaepCj0PM?=
	=?iso-8859-15?Q?NMoH6txeon6UD85Zj7DHwzp/qZNmvwssT3FNZHkpWCijSE4yGDVa/8v6l?=
	=?iso-8859-15?Q?2LK/WfvVkpKOdYZgrMc+Hr8lwXr0BVm+pfA18YQ36IDPI7NF+ZpREfWzF?=
	=?iso-8859-15?Q?1WzQ+t8Bpq7YIP2ljESKILq0LX0l+QsEPpVZyE/xriNVIt64M20Yk+9+s?=
	=?iso-8859-15?Q?Mmf+zdd06/1Wn3sQ5ZINBYTqBeXdAmpwKHX5LAjh+KBGzmFyS69HHcMhm?=
	=?iso-8859-15?Q?j0fhMN8gLJ1P3swalEYx/FUA9lxoIQjwrXrt683Zhb0flXr0owBIsPPvH?=
	=?iso-8859-15?Q?QG01ZFGaUIwZ9gffgH56yt33YbYcgyrjs41mpH2DQjwT1VYnB+rSAQlsh?=
	=?iso-8859-15?Q?36Fw0ash3h0Sfq8GLGVTSGTv/7IdSBvk4uZOp5YN9DMLRXnzJu4bp/q0Q?=
	=?iso-8859-15?Q?izeZUo/US1eoSzS+n/KrWLCJioog58EvWSn1DqwJPtWIeqijjwecp05se?=
	=?iso-8859-15?Q?WsGuSzmnjzy9yrRY9HWaH9ftikmdLlomUa3kM42oOXEgGupN78Z2muTed?=
	=?iso-8859-15?Q?sFbD06kcntpXkWvTRvlU1fhAMCvk1juE5hGxulTO5KYidA9bPFU28b6Il?=
	=?iso-8859-15?Q?YmthFIipJk2YSqnv4YfZPlyUg5s7QeUdLoRqIheDevEWSkoXM0tCUgD0C?=
	=?iso-8859-15?Q?rOPzY1jDIrMFMvA1G/ZpZ7UgrtiSbXWDQfZP5gOclkffvm/HkMaCNmTMo?=
	=?iso-8859-15?Q?dtsAp7UW17ehFu+4MuO06mSpLQNY15XNCqKQkuCCCTFc6OicCcvLuFUGI?=
	=?iso-8859-15?Q?AbkGUM81T7Roa+xpvq2zIxfmn1agiyJMoKVqGlcqoYMzxqva339T5QCf8?=
	=?iso-8859-15?Q?iJrA1iCr5JRzlQ1mCuhlpdnmp+m2gwHaYgc8LwU4EnjVTJapyVNeMLdA2?=
	=?iso-8859-15?Q?15Q3TqZHOyO/m9BECtgX/Ft2jmZz5AgFE3zrXmzfMZxsFaLaA6G084fCv?=
	=?iso-8859-15?Q?ZWXxmf9Szz/Yuj+w8b8RCYu3Ch5qZMSmwtA8Dmi+bMCj6mEH9vKaaPTPj?=
	=?iso-8859-15?Q?eiGFiX9Ro9JNmkV5xJ5TLOS+B9PaHtpUE+Mnqz5ywDcxcyR7EGVyQKcFn?=
	=?iso-8859-15?Q?wV1XPX1LR5zTqhjbIezVC1W+wDrGLexWQYyBv7rLs5jPTNR5cUkK+sr/m?=
	=?iso-8859-15?Q?BtGWL7SB+8++w5eF90cETqXEr4zDGBwZOBjWx0RMCmfbaO9uDGue/+Z0e?=
	=?iso-8859-15?Q?FZe55rbXPNLkOFAshCVtLgTfrHfwBHOL09tIyA8L9PAxaiYwZNO418fIR?=
	=?iso-8859-15?Q?JCL1HX7dTN1lbCY/CHMHjxo88JrXkqeHqq49NdQfrf8G+xWwJz42yuZ+n?=
	=?iso-8859-15?Q?csSezYapnx0lep8lln+BE886w2meD9yKHdJm0idw6lnan8RAi4tWHO3R5?=
	=?iso-8859-15?Q?e2YrfbW7FEedqsPcvJgghy1qQHSlekEEPROqXKuaArJ1MIkKzIovtSd6z?=
	=?iso-8859-15?Q?9gPyf6GPOt01l4JbMtRsuKYZ2CoTPeMimNA+Zi038ES0590+JYzawAUo7?=
	=?iso-8859-15?Q?QI12o0Ja1wqGMpYY91ZbVAMEGAqllDFQsqqIGDF2/yWV+nIBIJxqI54JB?=
	=?iso-8859-15?Q?O3ouUuGsRErsfG36MV3AcvyLMJXhPNBJJrIfq1AnMnh7+OpYxydZ8xS8Y?=
	=?iso-8859-15?Q?4F6Mvzy/H0Sw5BJ9Eb94RaVfHhNvb/3gp2JmWhvTt70S7eY=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8295671c-7243-4c55-f0e3-08d9aaa391fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 14:56:15.4269 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ORc37X37O1AibTAa2As+qdsrIYHvnU7laYIGQTajAn9/9toa96kJIiiDjmASwCRBikq/8/RrqsTerWuuvYhRZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4922
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIEuLjj018964
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 0/4] Add "reconfigure all" multipath
	command
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5F72FC6724D3974EBF470A558C9F082C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-11-17 at 18:07 -0600, Benjamin Marzinski wrote:
> This patchset is supposed to replace Martin's
>=20
> multipathd: add "force_reconfigure" option
>=20
> patch from his uxlsnr overhaul patchset. It also makes the default
> reconfigure be a weak reconfigure, but instead of adding a
> configuration
> option to control this, it adds a new multipathd command,
> "reconfigure all", to do a full reconfigure. The HUP signal is left
> doing only weak reconfigures.
>=20
> In order to keep from having two states that are handled nearly
> identically, the code adds an extra variable to track the type of
> configuration that was selected, but this could easily be switch to
> use a new DAEMON_CONFIGURE_ALL state instead.
>=20
> The final patch, that added the new command, is meant to apply on top
> of
> Martin's changed client handler code. I can send one that works with
> the
> current client handler code, if people would rather review that.
>=20
> Changes from v2 as suggested by Martin Wilck:
> 0003: configure() and enable_delayed_reconfig() directly access
> reload_type, instead of having the value passed in.
> schedule_reconfigure() takes an enum force_reload_types instead of a
> bool
> 0004: Modified to deal with schedule_reconfigure() changes.
>=20
> Changes from v1 as suggested by Martin Wilck:
>=20
> 0001: update libmultipath.version to handle ABI change in struct config
> 0003: Clarify commit message
>=20
> Benjamin Marzinski (4):
> =A0 multipathd: move delayed_reconfig out of struct config
> =A0 multipathd: remove reconfigure from header file.
> =A0 multipathd: pass in the type of reconfigure
> =A0 multipathd: add "reconfigure all" command.
>=20
> =A0libmpathpersist/libmpathpersist.version | 12 ++--
> =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 1 -
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
|=A0 2 +-
> =A0libmultipath/libmultipath.version=A0=A0=A0=A0=A0=A0 | 22 +++----
> =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 2 +-
> =A0multipathd/cli.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 1 +
> =A0multipathd/cli.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 2 +
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | =
12 +++-
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 | 84 +++++++++++++++----------
> =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 3 +-
> =A0multipathd/multipathd.8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 10 ++-
> =A011 files changed, 88 insertions(+), 63 deletions(-)
>=20

For the series:

Reviewed-by: Martin Wilck <mwilck@suse.com>

The fact that this is based on my uxlsnr series and that I'm still
working on the latter has required minor rebasing on my part.

Also, my late ABI check has turned out that my patch "add optional
wakeup functionality to lock.c" was actually a major, not minor, ABI
change (offsets in "struct vectors" changed).

Unless you object, I'll resubmit these, rebased and with the library
versions ultimately fixed, when I submit the uxlsnr series.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

