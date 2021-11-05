Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F97C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 10:55:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE0F56120D
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 10:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AE0F56120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-vZmnqGNyOJ6BDwCuNwht0Q-1; Fri, 05 Nov 2021 06:55:35 -0400
X-MC-Unique: vZmnqGNyOJ6BDwCuNwht0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B78CB36307;
	Fri,  5 Nov 2021 10:55:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 364E95D6B1;
	Fri,  5 Nov 2021 10:55:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AA3CA1806D04;
	Fri,  5 Nov 2021 10:55:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5AtOww002496 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 06:55:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 394F251E3; Fri,  5 Nov 2021 10:55:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 320C051DC
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 10:55:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DF741064E69
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 10:55:19 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-172-16pQIqxMP2Gd3C4zyfPFog-1;
	Fri, 05 Nov 2021 06:55:16 -0400
X-MC-Unique: 16pQIqxMP2Gd3C4zyfPFog-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-9-5r1CGMRlMgecPoEIS3hFCw-1; Fri, 05 Nov 2021 11:55:14 +0100
X-MC-Unique: 5r1CGMRlMgecPoEIS3hFCw-1
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
	by VI1PR04MB5711.eurprd04.prod.outlook.com (2603:10a6:803:e7::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Fri, 5 Nov 2021 10:55:12 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
	([fe80::94cc:cd3e:e473:4e45]) by
	VE1PR04MB6560.eurprd04.prod.outlook.com
	([fe80::94cc:cd3e:e473:4e45%4]) with mapi id 15.20.4669.011;
	Fri, 5 Nov 2021 10:55:11 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/7] multipathd: fully initialize paths added by
	update_pathvec_from_dm
Thread-Index: AQHXxebeV4GFGv0wyUqQuLf4uivcTKv0BbIAgADVtYA=
Date: Fri, 5 Nov 2021 10:55:11 +0000
Message-ID: <33b4e4f8942ab340b4fba39e91c3d10e9c6aa402.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-6-git-send-email-bmarzins@redhat.com>
	<2a319ae1e5eba66db17ab6372c95ac81f75a92e2.camel@suse.com>
In-Reply-To: <2a319ae1e5eba66db17ab6372c95ac81f75a92e2.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7607f953-f9a9-45bd-994f-08d9a04abd97
x-ms-traffictypediagnostic: VI1PR04MB5711:
x-microsoft-antispam-prvs: <VI1PR04MB5711BE5867DB8F42E83017ADFC8E9@VI1PR04MB5711.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zR9TaQQVBLgBYsEqDwb+44gqHma1ne1bjStEAjkjyKUvbdRasG4WgtyDriCawx1SooRapLDUubQAF+N52GCpEKQYy+VR+fiqgFHW0TIJwk9GHqE55HvTWL/MNVje0b8PDu2OLMBUxlJ1PxCBZHGAKF9A2LesqgYyFNoMI3EPiCj2kVtllVi/ojc55uBfaeItREHco48FFoF1IrpfuEu9aHo7zb5RtreVskqrdjxFUH+GyO/+ZcNhW2r0ha6yJUZ2R+AtVt50FGb3Qa5LkzZ4TGiBiIUOy2CRJDn5D4ExjhLf6fdhSFcxmZ2ngD4e0gHau2ikF8+shSkwAvmxMUXE1pXUGdHSq9CBHN/aNMLgH3Vo3J7jJthmRXdkApsTm/Ilblw3qVdGVSy9BeFcFU1UeheMB7S66DqCDzK5v9+trdAaSwqrBk2CYIzbTv1BUaIhXeHFNLh/XNTGA/oD4gmd51huKMBqY8QjXu5CfqNXM/xGx2Zl5ozgewzQtBqgAaAFXovkmF7cpSY+A/d+YF8s2iQ/CLE+gmrkku3VirMVVWcMW6auQ7vpliRjh56rUMFeYh11ju2ER28EarU73lsLu49lZNIhwXkXRs/75uZq922AVNP9FBQlwrCcDJPPUtgNjHMkO2Z3je0IOyQFGv64K1IWlPL2+XyQYLp78OOMcR6gXiBv4CG7TqOZsaXdGTihrmN3g+aJ/9zart1od34KGw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:VE1PR04MB6560.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(83380400001)(508600001)(38070700005)(122000001)(66476007)(86362001)(38100700002)(6512007)(76116006)(2906002)(4001150100001)(91956017)(66946007)(2616005)(36756003)(5660300002)(71200400001)(26005)(186003)(316002)(66556008)(4326008)(66446008)(64756008)(6486002)(6506007)(44832011)(8936002)(110136005)(8676002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?VT/dNYeQ0ROjaOCsLcdNpEFrsUTGxNSNkGcNUOm6T4c73gDSO1p/5zzzi?=
	=?iso-8859-15?Q?WbXfl3DZWnMbgMb/61pqkR26s+GO0CqI0MFgglXYoWc99JG1CfUnDNrPf?=
	=?iso-8859-15?Q?GHG3fH9VLxLG+1JNJ8opaLM8yVL6jB29w5aSd1u8sIOBKPbmPhxAz+UfS?=
	=?iso-8859-15?Q?IO5oKDYTuTBqEPRRsMx3A0UTtKpDmigu4LiBfJTXMM0BFcfUsku5UtWBi?=
	=?iso-8859-15?Q?H38zilEXPSlOtFYuJQabS+ok0T+4FiTmEeCzfzrE37y7Nmw0/ecq7RifU?=
	=?iso-8859-15?Q?bJG/9Naopbn0i6RlGvWz+NkLs/AJcYRN9qNC7lqlR5Yr66Bj5Jdh1+iXF?=
	=?iso-8859-15?Q?IcZJzEooahvVwUFmAuJAiWmYCjro+AKFNOpe5CwdQ3jukf+CXR10f+Ovm?=
	=?iso-8859-15?Q?uabnmSpmmJptU0Nqz/vUmGt91d9edXp0PVydOPXXMz7p85AqngG++rh/w?=
	=?iso-8859-15?Q?d1Z/sPNw1eOFYeWMJ1IsmAWR/+4/x1pXhahelzJ9RcPbLCIAHWGPtSCNt?=
	=?iso-8859-15?Q?wcg2hpJjYSDAhC9Ft3RxnrEPjoy3OnksYnVXU5z7QZFR+bbvn21MLsgI5?=
	=?iso-8859-15?Q?OihEI8e9AqoFol0UEphp31ki7OdhyLcedYZaWrNHuOMWwJ0mFAtZDUp75?=
	=?iso-8859-15?Q?JQ2wTtL65/sj08N3+qGdcV+Ww52E07/sZjrwnqQsTi8geWyGX6GbSBZdw?=
	=?iso-8859-15?Q?WDdVbOSywugMtL6rcllgZeiDWsAEsYbs2VdaQr77oO+mwSTGaLO/sEzIe?=
	=?iso-8859-15?Q?ELyWzc72eCRxcchUWRLSrVgy3O98kRkqcu+zNlK1feP9tnkEnzq5ubCHp?=
	=?iso-8859-15?Q?dqQdC4EAo4mKBQwu8zfHKz4tl9fMVGfQ+ThUnOhUj7FwZF/ZEXxVO+jlW?=
	=?iso-8859-15?Q?+CRxrvsnR27IfmroCyqEQFFARZXzNVPuzVMyJrabAMWxDrgwcZRbMMzqz?=
	=?iso-8859-15?Q?5mPiz/fD1aZ/MorJlu7Bn+EWJ3myHrTJHSIt8p9yOY1POGzMLvv4X1mxZ?=
	=?iso-8859-15?Q?KOuEt7sqCmjsU7HRxPePqzDgcWkNOtJZ2CvzXcnFPlqdkfUxSPLaEEKp6?=
	=?iso-8859-15?Q?6saKvf0DylQpyK2/oW+bn8kt8DrzMmB69dFUco0DmOaGPPbbH/XiPUYFX?=
	=?iso-8859-15?Q?rSOWkTgGFUw08bjCZwK9DFHa4/+qS+160qU6B64fUd1VYzGU5FMk/9g0v?=
	=?iso-8859-15?Q?tw91gKiLQstuaG2fAb9H3XTVoAzmSKWxSoYCIKAdM6iU8L68696KUE9xB?=
	=?iso-8859-15?Q?OMZd9n5MxIeSyTGeldqAjO+2oK0l+mugenb9p+UGG64HqXivqk8Jc3QNw?=
	=?iso-8859-15?Q?oU5DunDyOBBEzZgZy5+wiW5HhO0dsUgIt5YKwwIM59Uqm5CFodabbb32M?=
	=?iso-8859-15?Q?vRj5PuGTuKYGY4o22Ru/47S9GZT8oDYg7NAIJSe5BQmBGwIj5e3KX8cTx?=
	=?iso-8859-15?Q?SG3u4Gr/nRCRiEF9PcDMAiWfYfiNvNAaAMBhstvjXSdFxFiCVHL1kM9AU?=
	=?iso-8859-15?Q?CJCmkUDHMG2/wbOapBLst0wki5x5yapAr5dOmjo3hJuqqq9qewGmAivRR?=
	=?iso-8859-15?Q?3JRl6pdD0XjlkSfv4QOeAJ0XvjIElFrtvE3sjDibpj5pR1MvTcgefZDky?=
	=?iso-8859-15?Q?ao1nsQP3ehLfaZnmlpcLTyIaUfvFWQ6AzAV59T+9NywXSoaGJ2YYzzGCQ?=
	=?iso-8859-15?Q?BWqNjVRT5vcCsTkln1DMu/6bVtDGKuamnaN/xAKaH4ijK0E=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7607f953-f9a9-45bd-994f-08d9a04abd97
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 10:55:11.7739 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IhbCbFtq+8WzxQpINPccZ5I6cOyHFSrXRJ7T9WizKdG51JnpshSkVnvkXQTxXfl0nV28ryjTMMpgLRTWrvdlFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5711
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A5AtOww002496
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/7] multipathd: fully initialize paths added
 by update_pathvec_from_dm
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
Content-Language: en-US
Content-ID: <D46A026AC1521740A1F1AFFB90F97970@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Thu, 2021-11-04 at 23:10 +0100, Martin Wilck wrote:
> On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> > ...
>=20
> >=20
> > Multipath now has a new state to deal with these devices,
> > INIT_PARTIAL.
> > Devices in this state are treated mostly like INIT_OK devices, but
> > when "multipathd add path" is called or an add/change uevent
> > happens
> > on these devices, multipathd will finish initializing them, and
> > remove
> > them if necessary.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Nice. Somehow in my mind the issue always look much more complex.
> I like this, but I want to give it some testing before I finally ack
> it.

I noted that running "multipathd add path $path" for a path in
INIT_PARTIAL state changes this paths's init state to INIT_OK, even if
the udev still has no information about it (*).

The reason is that pp->wwid is set, and thus pathinfo() won't even try
to retrieve the WWID, although for INIT_PARTIAL paths the origin of the
WWID is not 100% trustworthy (being just copied from pp->mpp-
>wwid).=A0pathinfo() will return PATHINFO_OK without having retrieved the
WWID.=A0

I suppose we could apply a similar logic as in uev_update_path() here,
clearing pp->wwid before calling pathinfo().=A0If udev was still unaware
of the path, this would mean a transition from INIT_PARTIAL to
INIT_MISSING_UDEV. OTOH, we'd now need to be prepared to have to remove
the path from the map if the WWID doesn't match after the call to
pathinfo(). This means we'd basically need to reimplement the "changed
WWID" logic from uev_update_path(), and thus we'd need to unify both
code paths.

In general, the difference between INIT_MISSING_UDEV and INIT_PARTIAL
is subtle.=A0Correct me if I'm wrong, but INIT_PARTIAL means "udev has no
information about this device" and INIT_MISSING_UDEV currently means
"we weren't able to figure out a WWID for the path" (meaning that
INIT_MISSING_UDEV is a misnomer - when fallback are allowed,
INIT_MISSING_UDEV is actually independent of the device's state in the
udev db. We should rename this to INIT_MISSING_WWID, perhaps). The
semantics of the two states are very different though:
INIT_MISSING_UDEV will trigger an attempt to regenerate an uevent,
whereas INIT_PARTIAL will just stick passively. IMO it'd make sense to
trigger an uevent in the INIT_PARTIAL case, too, albeit perhaps not
immediately (after the default uevent timeout - 180s?).=20

Also, we currently don't track the udev state of=A0devices cleanly. We
set INIT_MISSING_UDEV if we can't obtain uid_attribute, which doesn't
necessarily mean that udev is unaware of the device. I believe we
should e.g. check the USEC_INITIALIZED property - it is non-NULL if and
only if the device is present in the udev db. If uid_attribute isn't
set regardless, we could conclude that the udev rules just don't set
it. It might make sense to retrigger *one* uevent in that case, but no
more.

IMO=A0we need a clear definition of the INIT_xyz states and their
transitions. We won't get along with intuitive logic any more.

Cheers,
Martin

(*) my test procedure is simply to delete the paths' files from
/run/udev/data and to restart multipathd.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

