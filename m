Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0201C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 12:14:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 261C364E79
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 12:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 261C364E79
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-C-NSxfgWPDCujHz1pa-23Q-1; Thu, 11 Feb 2021 07:14:45 -0500
X-MC-Unique: C-NSxfgWPDCujHz1pa-23Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A5ED107ACE3;
	Thu, 11 Feb 2021 12:14:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 091F460CCC;
	Thu, 11 Feb 2021 12:14:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 239E618095CB;
	Thu, 11 Feb 2021 12:14:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BCEbUB020130 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 07:14:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0857E2026D46; Thu, 11 Feb 2021 12:14:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 010CF2026D13
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 12:14:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71FE2811E87
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 12:14:34 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-229-tudHrhvHNvSQ-unnfMIlhA-1;
	Thu, 11 Feb 2021 07:14:30 -0500
X-MC-Unique: tudHrhvHNvSQ-unnfMIlhA-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2057.outbound.protection.outlook.com [104.47.6.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-24-tXp3Nm_zML-ry8o65BLIjw-1; Thu, 11 Feb 2021 13:14:27 +0100
X-MC-Unique: tXp3Nm_zML-ry8o65BLIjw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.29;
	Thu, 11 Feb 2021 12:14:25 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3825.030;
	Thu, 11 Feb 2021 12:14:25 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 2/2] multipathd: add recheck_wwid_time option to verify
	the path wwid
Thread-Index: AQHW/qMuQs93dFGIW0CwQCKCag2SdapQZg8AgAH+94CAAHySAA==
Date: Thu, 11 Feb 2021 12:14:25 +0000
Message-ID: <293ad1261123efb63dcfff4d02440e1728b3c013.camel@suse.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-3-git-send-email-bmarzins@redhat.com>
	<e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
	<20210211044833.GJ15006@octiron.msp.redhat.com>
In-Reply-To: <20210211044833.GJ15006@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.223.142]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4acd9c74-b068-479a-e5a3-08d8ce8692d2
x-ms-traffictypediagnostic: DB8PR04MB6555:
x-microsoft-antispam-prvs: <DB8PR04MB655513F8BB19EEC48A48AAA3FC8C9@DB8PR04MB6555.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:178
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: I9vz0KCz+qkUB32P23EwCJuc+II6L9WfFmXvS8VSo5ZgJt2eR+71GBO1oTfQtaWjHgkGjOaQKAIwqzN9OKju5N8JFb3vd8HL3QIC/qI7rWk+kH0Aq7brpC46cmXuszvWZfcTxf0WZmM/kPW5CrOO+kXhRsJXnWhGL8z5WcxDmak5NFtocGueNkC1kQhNmWM6Yj5T8UWstofo0SY08H1LJa8YXqn/jzf5aRjHIPys9nt7FQFdqRTI4F9qSztWExo6kzIvL6HI3AkCYFaj2RLfYw7p+Y88DKlAVtlGl2VAk4aTpDhif887Zw1Cd0tBhqsvqD0nKB40CNkKXC7TbJY3gUMn73fT6Yxjn3i3llvCMSuSrT5PrDiFSBFYzztw+l5cQPwSZOkDioM+b3z0sWIxyW0GZzq4zE3CkR/8anX6UsWkKtNlcYbQAjPgEeRE1aKbDzGrpuBqsdndfDxkMEOiZtlfK3aKZ/gZBNGKN4qmnVU+3fMl6VzF2kOjg9H/lMPqZOw1rH4A/FVGlzVozOTHRw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(366004)(346002)(39860400002)(376002)(26005)(478600001)(83380400001)(6506007)(66574015)(66556008)(316002)(2616005)(54906003)(44832011)(5660300002)(71200400001)(186003)(36756003)(30864003)(6486002)(8676002)(86362001)(2906002)(15650500001)(6512007)(8936002)(6916009)(66446008)(66946007)(64756008)(76116006)(66476007)(4326008)(91956017);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?BFGy7IdO4m6ZUmQU3Yd30+4TIkLrCFSzwXO18PMFG85bsoPQVmo8sVveU?=
	=?iso-8859-15?Q?xvN+sGPbS1FyVkkVDOL4Ct5A1K1OgQMqgYxZ6UWrFaCQidFfySemRku+N?=
	=?iso-8859-15?Q?Xbhjj0AnVwjewsZgX4ThzDwa+tiQewBt+Ub6bDWBHGS/wVMzB77hYutLT?=
	=?iso-8859-15?Q?wMImoTeUdNYjvScnyyDzsm5Vwwp1r6IDZfacZyOpP7+psSlDh9fULuHOO?=
	=?iso-8859-15?Q?xz0JYhRvVeO1aR+z2WNEInOjpwwHzcLCH29gdkHRE7Nrdg0MtYsKAFTcu?=
	=?iso-8859-15?Q?NX03O6fXG2hLcQ4lIEGwg3PAx+bdoHa3AwKj4AGTuOh3QWc/eWZrJDM3p?=
	=?iso-8859-15?Q?kJxu7Q8dJNnTSdPTzrZN4H11dafLB3OuhFreZZ8QCdtfNyAQwOqpDKP34?=
	=?iso-8859-15?Q?cRLT5U6OplgJtgfsWEeTNMXbrC76pxxXuiuN1g7MA3ykvD1LuvX2jiuJR?=
	=?iso-8859-15?Q?bLjzw7oIbApK+SJpr7tFbQ8wbT13wbRRjQ2yp93273jS74uTomTp/uIzC?=
	=?iso-8859-15?Q?BjMF1N8Dp4BXCwxr4gap58zxyT0iaNOGFmzMco0V/mj5DthmK2zQR7aQb?=
	=?iso-8859-15?Q?XLOeY8WyVa2oaMdxV2bjymHEfTms6IJjX+ll/Obz3Pidx2HdMsOZlS83C?=
	=?iso-8859-15?Q?+E77z7B46ytBdmuckm+lADcyDOWUuhI5mcviagicOIG6GsWSvSNi20QqA?=
	=?iso-8859-15?Q?tFH7ETCjLSU0XugSWdyZxD6XfaHeB3CKN6F2VOhq46oQKyKDJary6KPFR?=
	=?iso-8859-15?Q?BYUxIfoer0n94pObPq4AGJbgYi/Do6OptgtSTih2PaXq87KGaeWhMpItl?=
	=?iso-8859-15?Q?+kZ98FfWT+9x1lOP3G9p0TSm6AZJz8ji7JrqaiiiXapIWQKsjanFqmJlr?=
	=?iso-8859-15?Q?KjpS5v4Odh+9EHI7sOlrie81EvMDboSf6NFZr89ur5Ty1NAZXBqvUy+jx?=
	=?iso-8859-15?Q?7oRIpTqlsAt/vwRTVymYoQmBY8SpVYmu/4EgpDRIEvVGI+l10lrvDpSUp?=
	=?iso-8859-15?Q?+rRRicyajsMObI7F/K2//tJ3/zk1tljYKxA+eUySxYDFdgkIA2A+R1U2E?=
	=?iso-8859-15?Q?sdHL0F5F3fGIAHqDdOUwZBzWeTZgLZEgA7AaZLTvHbQSmi/6VzGLfk0pR?=
	=?iso-8859-15?Q?f/UebCsrFHpkhnIDSAG8A43LCbewq1hVErN5XOcD1in7pJFNdbKTLDPSu?=
	=?iso-8859-15?Q?4zBhPfQlDcWNJ8UP/5g4J4/AZ7jA/iyquRrgw+jIV6XW8tXWmqC8N8oFQ?=
	=?iso-8859-15?Q?lUk2TRu45rzAyagPDFp6j2o/TElygoTK7ckOmduDarrRqSahJuRHp2RH+?=
	=?iso-8859-15?Q?FH90hLOex+vS413eVheTbKYaaNBk1NAzl8EPoXjsxNU2wDjNs6qlRKGnF?=
	=?iso-8859-15?Q?R34fSPYeE/KlP1zhZJI+Sfz8pcXT5add9?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4acd9c74-b068-479a-e5a3-08d8ce8692d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 12:14:25.6739 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r807EzJiJ0L5Rb8Is9hejAR2Qwah5CEkyrL5Ab7Nos64iBWVuMuDc4iqTDw5kFRFLTBgv8Vxoyq1pTrYCexJvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6555
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11BCEbUB020130
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
 to verify the path wwid
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
Content-ID: <125763713BD26E48BC2B38733D661659@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-10 at 22:48 -0600, Benjamin Marzinski wrote:
> On Tue, Feb 09, 2021 at 10:19:45PM +0000, Martin Wilck wrote:
> > On Mon, 2021-02-08 at 23:19 -0600, Benjamin Marzinski wrote:
> > > There are cases where the wwid of a path changes due to LUN
> > > remapping
> > > without triggering uevent for the changed path. Multipathd has no
> > > method
> > > for trying to catch these cases, and corruption has resulted
> > > because
> > > of
> > > it.
> > >=20
> > > In order to have a better chance at catching these cases,
> > > multipath
> > > now
> > > has a recheck_wwid_time option, which can either be set to "off"
> > > or a
> > > number of seconds. If a path is failed for equal to or greater
> > > than
> > > the
> > > configured number of seconds, multipathd will recheck its wwid
> > > before
> > > restoring it, when the path checker sees that it has come back
> > > up.
> >=20
> > Can't the WWID change also happen without the path going offline,
> > or
> > at least without being offline long enough that multipathd would
> > notice?
>=20
> Yes. There is no way to guarantee that you won't hit this issue.
> That's
> why this is configurable and disableable. People get to choose how
> likely they are to shoot themselves in the foot.

We have seen quite a few cases lately where TUR checker was "wrong"
about path state. TUR would succeed, but the regular IO on the path
would either fail or, worse, hang. So by adding an SG_IO right in the
middle of check_path(), with vecs lock held, we increase the risk of
making multipathd hang (it can happen elsewhere, too, like in
get_prio(); I'm still pondering how to avoid it in general).

Thus, it's definitely reasonable to let users switch this on and off.
(it should perhaps be a hwtable option. Are these WWID configuration
mistakes more likely to happen on specific storage arrays than on
others?).

But I fail to see the reason of making the likelihood configurable.

Every sane user would strive for a minimum likelihood for this kind of
failure. As you pointed out, we can't guarantee a zero likelihood, but
*if* we do this, and *if* we do it when paths come back alive as you
implemented it, then it makes sense to do it always as quickly as
possible.

IOW: I think it should be a boolean option, and if "on", it should test
after every down time.

>=20
> >=20
> > > =A0If
> > > multipathd notices that a path's wwid has changed it will remove
> > > and
> > > re-add the path, just like the existing wwid checking code for
> > > change
> > > events does.=A0 In cases where the no uevent occurs, both the udev
> > > database entry and sysfs will have the old wwid, so the only way
> > > to
> > > get
> > > a current wwid is to ask the device directly.=A0
> >=20
> > sysfs is wrong too, really? In that case I fear triggering an
> > uevent
> > won't fix the situation. You need to force the kernel to rescan the
> > device, otherwise udev will fetch the WWID from sysfs again, which
> > still has the wrong ID... or what am I missing here?
>=20
> In the reproducer I posted using targetcli and FC devices, sysfs is
> wrong.=A0 That does make me a little leary about simply re-adding these
> devices as new.=A0 udev will run scsi_id to grab the new WWID and store
> that in the udev database, but if we ever fail back to looking at
> sysfs,
> we will still see the old data.=A0 In general, having devices on the
> system with bad sysfs data seems dangerous.

That's right, we shouldn't do this. Either we force a SCSI-level rescan
and verify the WWID is correct in sysfs therafter, or we mark this path
as unusable/bad and spit out BIG FAT ERROR MESSAGES.

>=20
> > > > Currently multipath only
> > > has code to directly get the wwid for scsi devices, so this
> > > option
> > > only
> > > effects scsi devices. Also, since it's possible the the udev wwid
> > > won't
> > > match the wwid from get_vpd_sgio(), if multipathd doesn't
> > > initially
> > > see
> > > the two values matching for a device, it will disable this option
> > > for
> > > that device.
> > >=20
> > > If recheck_wwid_time is not turned off, multipathd will also
> > > automatically recheck the wwid whenever an existing path gets a
> > > add
> > > event, or is manually re-added with cli_add_path().
> > >=20
> > > Co-developed-by: Chongyun Wu <wucy11@chinatelecom.cn>
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > I am uncertain about this.
> >=20
> > We get one more configuration option that defaults to off and that
> > only
> > the truly inaugurated will understand and use. And even those will
> > not
> > know how to set the recheck time. Should it be 1s, 10, or 100? We
> > already have too many of these options in multipath-tools. We shy
> > away
> > from giving users reasonable defaults, with the result that most
> > people
> > won't bother.
> >=20
> > I generally don't understand what the UP/DOWN state has to do with
> > this. If the WWID can change without any events seen by either the
> > kernel or user space, why would the path go down and up again? And
> > even
> > if so, why would it matter how long the device remained down?
>=20
> A new LUN can't get remapped to a still-being-used LUN id. The LUN
> that
> was previously mapped to that id must get unmapped first.=A0 That will
> cause IO and and checker commands to fail. So unless a LUN gets
> unmapped
> from a LUN id, and a new one remapped to that id quick enough for no
> IO
> and or checker commands to go to it, the path should go down. In the
> case that spurred this development, the path was down for hours
> before a
> new LUN was remapped to that ID.

OK. My thinking was that storage configuration changes are made by
scripts or software more often than not, and in this case down times
may be quite short. But if they say they need it - fair enough.

>=20
> > But foremost, do we really have to try to deal with configuration
> > mistakes as blatant as this? What if a user sets the same WWID for
> > different devices, or re-uses the same WWID on different storage
> > servers? I already hesitated about the code I added myself for
> > catching
> > user errors in the WWIDs file, but this seems even more far-
> > fetched.
> >=20
> > Please convince me.
>=20
> Err.. An important customer corrupted their data and while they admit
> that they were at fault, it's hard for them to guarantee that
> something
> like this won't happen in the future, and they asked if multipath
> could
> do a better job of catching these sorts of mistakes. Obviously this
> is
> more convincing when it's coming from your customer. But the fact
> still
> stands that this has happened to multiple users even with our
> existing
> code to catch this.

I wasn't aware of multiple affected users. I saw Chongyun's post and it
looked to me as if this had happend once, likely in his organization.
It wasn't even clear to me whether production data were affected.

I still believe that this is primarily a problem on the storage vendor
side. They should make it harder for users to shoot themselves in the
foot (low-level LIO doesn't count - of course you can do all kinds of
ugly stuff with it).

> Since this isn't a problem that can always be fixed, the best we can
> do
> is try to catch it before something bad happens.=A0 If the path is
> remapped before it goes down, then corruption can happen before there
> is any possiblity of doing anything. That case is unsolvable. But if
> the path does go down when the LUN is unmapped, then there is a
> chance
> to catch this before damage is done.
>=20
> Now, obviously if you don't set this to 0, then it's possible that
> the
> path gets unmapped and goes down, but comes up before your timeout,
> and
> you don't catch it in time.=A0 Really, this is a dial that nobody that
> hasn't got bitten by this issue cares about, but everyone who has had
> this happen really wants to be there.

OK, then. Please consider making it boolean though, as argued above.
If the time must _really_ be configurable, maybe those affected parties
can come up with reasonable suggestions for a default?

>=20
> > This said, I'd like to understand why there are no events in these
> > cases. I'd have thought we'd at least get a UNIT ATTENTION
> > (REPORTED
> > LUNS DATA HAS CHANGED), which would have caused a uevent.=A0If there
> > was
> > no UNIT ATTENTION, I'd blame the storage side.=A0
>=20
> Are you able to try the reproducer I targetcli FC reproducer I
> posted?

I wanted to, but I had no time to set this up yet.


>=20
> > Maybe we need to monitor scsi_device uevents.
> >=20
> > Technical remarks below.
> >=20
> >=20
> > > ---
> > > =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > > =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > > =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +-
> > > =A0libmultipath/configure.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +
> > > =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > > =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 36=
 ++++++++++++
> > > =A0libmultipath/libmultipath.version |=A0 6 ++
> > > =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 10 ++++
> > > =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 | 18 ++++++
> > > =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 +++
> > > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
| 92
> > > +++++++++++++++++++++++++++++++
> > > =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
|=A0 2 +
> > > =A012 files changed, 180 insertions(+), 2 deletions(-)
> > > =A0.
> > > =A0.\" ------------------------------------------------------------
> > > ----
> > > ------------
> > > diff --git a/multipathd/cli_handlers.c
> > > b/multipathd/cli_handlers.c
> > > index 54635738..970d5e21 100644
> > > --- a/multipathd/cli_handlers.c
> > > +++ b/multipathd/cli_handlers.c
> > > @@ -715,6 +715,15 @@ cli_add_path (void * v, char ** reply, int *
> > > len, void * data)
> > > =A0=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_dev(vecs->pathvec, param)=
;
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (pp && pp->initialized !=3D INIT_REMOVED) =
{
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path =
already in pathvec", param);
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->allow_wwid_rech=
eck =3D=3D
> > > ALLOW_WWID_RECHECK_ON
> > > &&
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 check_path_ww=
id_change(pp)) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(0, "%s: wwid changed. Removing
> > > device",
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dev);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0handle_path_wwid_change(pp, vecs);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return 1;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > +
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return 0;
> > > =A0=A0=A0=A0=A0=A0=A0=A0} else if (pp) {
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index 19679848..17eef3a4 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -823,6 +823,59 @@ ev_remove_map (char * devname, char * alias,
> > > int
> > > minor, struct vectors * vecs)
> > > =A0=A0=A0=A0=A0=A0=A0=A0return flush_map(mpp, vecs, 0);
> > > =A0}
> > > =A0
> > > +void
> > > +handle_path_wwid_change(struct path *pp, struct vectors *vecs)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0const char *action =3D "add";
> > > +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->udev)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(pp->udev, "uevent", action=
,
> > > strlen(action));
> > > +=A0=A0=A0=A0=A0=A0=A0trigger_partitions_udev_change(pp->udev, action=
,
> > > strlen(action));
> >=20
> > Nit: it looks a bit weird to use a const char * variable for
> > "action"
> > and a constant for "uevent".
>=20
> It does mean that there's no chance of typo'ing it one of the four
> times
> it's used and not having it be caught, but I'm fine with changing it.
>=20
> > > +=A0=A0=A0=A0=A0=A0=A0if (ev_remove_path(pp, vecs, 1) !=3D 0 && pp->m=
pp) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_=
FAILED;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->a=
lias, pp->dev_t);
> > > +=A0=A0=A0=A0=A0=A0=A0}
> >=20
> > I suggest taking a ref on pp->udev, calling ev_remove_path(), and
> > triggering the uevent after that.
> >=20
>=20
> vecs locking will save us from handling the uevent before we remove
> the
> path, but your ordering does make things look more obviously correct.
> I'm fine with changing it.
>=20
> > > +}
> > > +
> > > +bool
> > > +check_path_wwid_change(struct path *pp)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0char wwid[WWID_SIZE];
> > > +=A0=A0=A0=A0=A0=A0=A0int len =3D 0;
> > > +=A0=A0=A0=A0=A0=A0=A0char *c;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (!strlen(pp->wwid) || pp->bus !=3D SYSFS_BUS=
_SCSI)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> >=20
> > Maybe you should look at uid_attribute here, to be consistent with
> > has_uid_fallback()?
>=20
> Possibly, be this code will never be run to see if wwid has changed
> without first having been run and verifying that the wwids match. If
> the wwids don't match the first time, then it's disabled.
> =A0
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0/* Get the real fresh device wwid by sgio. sysf=
s still
> > > has
> > > old
> > > +=A0=A0=A0=A0=A0=A0=A0 * data, so only get_vpd_sgio will work to get =
the new
> > > wwid
> > > */
> > > +=A0=A0=A0=A0=A0=A0=A0len =3D get_vpd_sgio(pp->fd, 0x83, 0, wwid, WWI=
D_SIZE);
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (len <=3D 0) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: failed =
to check wwid by sgio: len
> > > =3D
> > > %d",
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pp->dev, len);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > > +=A0=A0=A0=A0=A0=A0=A0}
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0/*Strip any trailing blanks */
> > > +=A0=A0=A0=A0=A0=A0=A0c =3D strchr(wwid, '\0');
> >=20
> > Quite unusual, why not use strlen() or strnlen()?
>=20
> This was pulled directly from get_uid(). But I agree it could be
> cleaned
> up in both places

Strange, it never caught my eye. Maybe we should do a start-from-zero
review of our code :-/

>=20
> >=20
> > > +=A0=A0=A0=A0=A0=A0=A0c--;
> > > +=A0=A0=A0=A0=A0=A0=A0while (c && c >=3D wwid && *c =3D=3D ' ') {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*c =3D '\0';
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c--;
> > > +=A0=A0=A0=A0=A0=A0=A0}
> >=20
> > Nit: You don't have to nullify every space. Just the first one.
> Again, this is just a copy of get_uid().
>=20
> >=20
> > > +=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: Got wwid %s by sgio", pp->dev, =
wwid);
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (strncmp(wwid, pp->wwid, WWID_SIZE)) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: wwid '%=
s' doesn't match wwid '%s'
> > > from device",
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pp->dev, pp->wwid, wwid);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > > +=A0=A0=A0=A0=A0=A0=A0}
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0return false;
> > > +}
> > > +
> > > =A0static int
> > > =A0uev_add_path (struct uevent *uev, struct vectors * vecs, int
> > > need_do_map)
> > > =A0{
> > > @@ -919,6 +972,21 @@ uev_add_path (struct uevent *uev, struct
> > > vectors
> > > * vecs, int need_do_map)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uev->kernel);
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D 1;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (pp->allow_ww=
id_recheck =3D=3D
> > > ALLOW_WWID_RECHECK_ON &&
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 check_path_wwid_change(pp)) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(2, "%s wwid change detected when
> > > processing add uevent. removing path", pp->dev);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/*
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * don't use handle_path_wwid_change
> > > here,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * since that would just trigger another
> > > add
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * uevent
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 */
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0ret =3D ev_remove_path(pp, vecs, true);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (ret =3D=3D 0)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp =3D NULL;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0else if (pp->mpp) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_FAILED;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->alias, pp-
> > > > dev_t);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> >=20
> > What's the purpose of this code? Are you handling your own
> > artificial
> > "add" event here, which you triggered before in
> > handle_path_wwid_change()? Or are there real cases where the kernel
> > would send an "add" event without sending a "remove" event first?
> >=20
>=20
> This shouldn't be for handling our own add event. Either the
> ev_remove_path() in handle_path_wwid_changed() succeeded, and there
> is
> no path in pathvec, or it failed, and pp->initialized should be set
> to
> INIT_REMOVED. Either way, we miss this code path. This is simply if
> we
> get an "add" event without the "remove" event, which is a real thing
> that has happened when LUNs get remapped.

That sounds like a kernel bug, or something else really awkward and bad
which we should try to understand and fix.

Thanks,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

