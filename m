Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12372C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 20:03:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-vkZnnKwHO5CxEoTNtbOj8w-1; Tue, 23 Nov 2021 15:03:50 -0500
X-MC-Unique: vkZnnKwHO5CxEoTNtbOj8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11FCE1023F4D;
	Tue, 23 Nov 2021 20:03:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6D0760C7F;
	Tue, 23 Nov 2021 20:03:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 606B04E9F5;
	Tue, 23 Nov 2021 20:03:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANK3hpt005917 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 15:03:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F20282180122; Tue, 23 Nov 2021 20:03:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA4832166B25
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 20:03:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03585106655A
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 20:03:40 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-60-hdX80jZHNPW2dR-wN-dJJw-1; Tue, 23 Nov 2021 15:03:38 -0500
X-MC-Unique: hdX80jZHNPW2dR-wN-dJJw-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2051.outbound.protection.outlook.com [104.47.10.51]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-4-rc10ceagPTeiJQElcFy7yg-1; Tue, 23 Nov 2021 21:03:35 +0100
X-MC-Unique: rc10ceagPTeiJQElcFy7yg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0401MB2359.eurprd04.prod.outlook.com (2603:10a6:4:4c::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22;
	Tue, 23 Nov 2021 20:03:33 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4713.026;
	Tue, 23 Nov 2021 20:03:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH] multipathd: avoid unnecessary path read-only reloads
Thread-Index: AQHX3M5WUEb/bxOK1E+H6voh4CAkfawPs7yLgAAjhyqAAXS4YoAARMkA
Date: Tue, 23 Nov 2021 20:03:33 +0000
Message-ID: <e9831789e34f4667f2e9584b72dbea87c1197be6.camel@suse.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
	<6444fd097cf43bdfe6b1947f42f270e958310fff.camel@suse.com>
	<20211122153554.GJ19591@octiron.msp.redhat.com>
	<7ae474b1273b27a188593b716e5f0dfc1d09cad1.camel@suse.com>
	<20211122174303.GL19591@octiron.msp.redhat.com>
	<148fdecf9a05bcd82fa7da26910a82dc94d579df.camel@suse.com>
	<d4620e9a741d0c5d8565f71c4a20eebb1ca6ebee.camel@suse.com>
	<20211123155701.GM19591@octiron.msp.redhat.com>
In-Reply-To: <20211123155701.GM19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fab22e6-72b1-4295-2487-08d9aebc53e7
x-ms-traffictypediagnostic: DB6PR0401MB2359:
x-microsoft-antispam-prvs: <DB6PR0401MB2359A08591985365BBEC0D11FC609@DB6PR0401MB2359.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 8AphQkn4AloxeWO7vKguIjMN/3VQ1L2SdJ1cq08TOZf/qs/nbLxdeu+EV/vH8RPR2+aUrjrZqASw6D12JAPLgu837nHfzPcOwkN/b+YBnvP1T5L9wprhxurENZ8lzL4OpOJbiPH7LcySuwGCvICJte3YIQD2snAPFS+t8+BhbZ+BuAz+Ou3Hvsm9aRfXgfTGplottMeXO7SywLtDQtchf/pRYaXtEg+u+qtBW+eI+ukRUJSv538RUSD+6vwSr6dmUn7QCc/ft6rQz+fwQzYNOZa40LJX61+a7lGxx12xjIoyYB0ev0xg3XxJ1Coj8MpH6+JGZfoZHSdKfj6cRVYDvsfRzP33FnAacGMaYhhq+Keo+4fxeYvFefqbLXt5L4R5ci94Aut2dM44g5dNjrCKXJ5PN5GHM7qmUC1R3PWtifLf/8wj/zS6JtouP44FIayfhi9spaTk/52Qg8UC8qNICrWdGkzCc7E5o23PZbbLSZmZWYzy2E5arzoajyEMSrTFp7dEG2qGu43WqRXg1GoYFo5MrZiqIV5PHou+93DPIuf5XAtM7dkBE9qtDiDW2a1i6gTmBzvvHz1u38HeY8Ob20QNfCoqkr9PYmN1h60X/BPPCqk0ay8Lf1HixI3Qa4Qhwf/yB8LA5/T/XJU+rD0q5vaGJ0CAchHEQtoFuCrU2JcQfl0geaiuTEy3l7LrNplo08CirfMMmyskCBAsTSLWUg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(2906002)(64756008)(66556008)(66476007)(66946007)(66446008)(5660300002)(76116006)(316002)(4001150100001)(26005)(38100700002)(122000001)(91956017)(6486002)(36756003)(508600001)(186003)(44832011)(6512007)(54906003)(2616005)(83380400001)(8676002)(4326008)(71200400001)(38070700005)(6916009)(6506007)(86362001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?kPvHkNzuyd/ZXI1j0xb6MmLft2NGR7J1jA4MTICJBNZA7gzjG6r5q6FIc?=
	=?iso-8859-15?Q?hMQjA/38gft3xu6f9pxiXn3qAPdTMSeMal5JrDTlkKEn72pNEy6w/HKbi?=
	=?iso-8859-15?Q?IcBtFpXLBA9sy3JCWqLzW0LII5nz+77xapEwjdlL6NcNpcXQfOmIeO3Y8?=
	=?iso-8859-15?Q?g27vd9IHruXbc7C5Y5R2OaVqlnksjw7XS/mF+EA11IwEP3BwUeXulKsAg?=
	=?iso-8859-15?Q?8uGncJ+j1xtcgPlmWP96sXEPiFGMMukH97tDWuUgmLzJSpeiefpvUqVwR?=
	=?iso-8859-15?Q?h/I7KWClEHojf33//YZ9o4amfC8TjwG1gifNp2EbYWtwa6+UjG0TnEXyr?=
	=?iso-8859-15?Q?cOwh0PkyoXba/CykoVnk5jmL6Q2mv13fg5DIFCs6Lg8/Juc0raO+Hmnnl?=
	=?iso-8859-15?Q?gPqZyLKIKnIVNS1TvO3djq3gaFmgQ3Y7ziMwFaSOYKtSzQou6Q43fpcRA?=
	=?iso-8859-15?Q?iROXim1/PgTUR/K1xH4XgFK3Ka9uZP9E5z7Gur8HHV3JwbtHUCPYPvjBx?=
	=?iso-8859-15?Q?JKWMNmWKjwfU6gtYIW9mMutD3nGFOVfFuCiwY0H+0CJPVL+rmJrmaDZRu?=
	=?iso-8859-15?Q?VGxYWrjuM00R1rrZufs7roKxaq799o9Rgfv/pYDCw3m2Wq6bB7fv9tsNN?=
	=?iso-8859-15?Q?Z3sblUpP9MXakRtmAsJpYWN88u5iuCpqsiunwv+K8InP2QCOSuENhczeP?=
	=?iso-8859-15?Q?c/xg1RF93Yvwcj3iB9zhyGPKTp+G0sj8hz+JHd/tbxPUDW+jcecezKtUx?=
	=?iso-8859-15?Q?Zl5sw3HuxwDiJdDRgYt4/VYW1J/Qrjubr3/M5NF3S7pn/tJsuyprgnCGb?=
	=?iso-8859-15?Q?AiLzSvCEd/j483G9vSqs0LCCzRcu1doRy9UQr/aTGEDzPEV9xlQL+NbV9?=
	=?iso-8859-15?Q?Y/05gT2SEnEq3l+O3LeYo9rk8wYh8L5jaXeVSG2g1E6jCpfiMjTdQA1ZS?=
	=?iso-8859-15?Q?AOnQtwluQV5yNhJib8n5yuNTDw20oQ8Z3f7y1fa4jVVdNNdLtBgrKFII8?=
	=?iso-8859-15?Q?6MGWKbbmpAEzslgn9SZxOM3Kf3JelxgtsAojurHKLt5m5cJUgnaAKFMKV?=
	=?iso-8859-15?Q?MHQ8EvKfA8RbSWGPRNj3POOcUA4kprcURVQTYrQO4uoHLm2dLYy43lFL+?=
	=?iso-8859-15?Q?HSOpm6+pDcwvVO7ovc7FGpTPYJRMU5WStj7b5tmiCAVPL92VJrs3vWb9O?=
	=?iso-8859-15?Q?Wt62aAD1i5Foav6TqmDJMFK8pXFvsLsJwvSrlaVfI3ES3FGWZVKK7Ccvj?=
	=?iso-8859-15?Q?2Mt0jxtsXYmaX1WOLPV6fMZIpAPJIzm767Uc1F9NXBSjDCyQentDE+E+v?=
	=?iso-8859-15?Q?uGdGT4CtouBxFRD1fzx4MxqqH6N6pjp65Ap/9hkE+T96BO2lO3psEdV70?=
	=?iso-8859-15?Q?kDXcZL8Sr6Rc+t1w9bbNC8ORkT21ImX/uFIGf5FvL1gceg4xIdnK8Gmoq?=
	=?iso-8859-15?Q?lH/EToXtmT2qyK+Oxc4TlvY94b4PghAWgLmD8W8AsQVP+hs1I5jHiK1w5?=
	=?iso-8859-15?Q?gBJMGmMsCsR/orqFAj84f4QMJgcefhAA5AgCCXUjnUtovCxtYRjmpbjVG?=
	=?iso-8859-15?Q?+Z2tyzuoMiU2WUfveZMew7mFe11B9BnSheFC9iKnefZxGUbyvh6SrPtJB?=
	=?iso-8859-15?Q?LuS6ohjUbut4+RtCxHXrS368L5eaMHaX3axZCf+KG7gbJauXkIPKrFesx?=
	=?iso-8859-15?Q?b9Qeh5Q8wl/hHGZJKBk8cvR5A/IzasKGnE2bEpc2N2kKm6c=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fab22e6-72b1-4295-2487-08d9aebc53e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 20:03:33.3248 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rQg8YLirLTurTSQPgB3fn+IwQUsKKMEvVTl4uvvmySfxiaOje3RyZasPvvw2m9uWzYaJ14XlTlnvkWEh9b35jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2359
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ANK3hpt005917
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: avoid unnecessary path read-only
	reloads
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8523DAEEBE057747BF41366E39D2BB0B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-11-23 at 09:57 -0600, Benjamin Marzinski wrote:
> On Tue, Nov 23, 2021 at 11:05:20AM +0000, Martin Wilck wrote:
> >=20
> > I've never looked into the ro attribute processing closely. I just
> > did.
> > I'm unsure how a race would come to pass, in particular with your
> > patch
> > applied:
> >=20
> > =A01. path change uevent arrives
> > =A02. ro attribute of path device has changed
> > =A03. map reload occurs if=20
> > =A0=A0=A0 a) map was rw before (thus all paths, too) and the path chang=
ed
> > to
> > ro
> > =A0=A0=A0 b) map was ro before and all paths have changed to rw
> > =A04. kernel will call set_disk_ro() depending on the
> > DM_READONLY_FLAG;
> > =A0=A0=A0 set_disk_ro() triggers an uevent for the block device if and
> > only
> > =A0=A0=A0 if the ro flag changed
> > =A05. we set mpp->dmi in __setup_multipath().
> >=20
> > We hold the vecs lock between 3 and 5, so even if the uevent
> > arrived
> > before setup_multipath() was called, I don't see how it could race.
> > mpp->dmi as derived in 5 should reflect the state correctly.
>=20
> I admit, I didn't find a definitive race. I was just worried about
> the
> possibility of the dmi being outdated. While there's always the
> possibility of the multipath device's RO state getting changed
> outside
> of multipathd (by a multipath call for example), this is not the
> place
> to deal with that. ev_add_map() would be. After looking at this, I'm
> o.k. with trusting the existing dmi, especially if we are updating it
> in
> ev_add_map().
> =A0
> > What we could do is remember the ro-state of the map in
> > dm_addmap(),
> > e.g. in a mpp->ro field. If map creation with ro=3D0 succeeded, we
> > can be
> > pretty certain that the map is in read-write state. Otherwise we'd
> > fallback to ro=3D1, and remember that state, too. We could verify
> > that
> > state once more against the dmi info in setup_multipath(). By doing
> > that we'd cover the time span between the dm ioctl and retrieving
> > the
> > dmi in setup_multipath(). That would IMHO be more consistent than
> > the
> > current use of the temporary force_readonly flag.
>=20
> So the idea would be to never try reloading read-write when the map
> is
> marked as RO, until we get a path event updating the RO state? I do
> worry about cases where well fail to reload the map correctly then.
> Imagine that we have a map with mpp->ro=3D1 with one read-only path.
> The
> read-only path gets removed. If we just assume that the mpp->ro state
> is
> correct until with get a path_event changing the read-only state, we
> will won't reload read/write here.

I didn't think about this possibility. TBH, it sounds pretty
pathological to me.

> =A0 The other option would be to check
> the path's RO state every time we reload, or at least whenever we're
> reloading to remove a path. That has the advantage that it doesn't
> produce a dm error message like a failed reload does, but I'm not
> sure
> if it's any less work. Or am I misunderstanding what you are
> suggesting
> here?

Hm, I guess not. I'm worried that that may slow down reload operations
quite a bit. Under normal circumstances, all paths will be r/w most of
the time (in my experience, read-only multipath storage is pretty
rare). The idea to re-check this only on path removal sounds ok-ish. We
could also track the ro attribute of paths, so that we don't have to
check sysfs every time....

But before things get overly complicated, trying to load r/w first and
checking -EROFS like we do now, and doing the sysfs check when we
receive uevents, is just as good, if not better.

> > I've been wondering whether we should use your logic during map
> > creation, too, and not even try to setup the map with ro=3D0 if we
> > have
> > paths in read-only state.
>=20
> If sysfs says one of the paths is read-only, it seems reasonable to
> skip
> the read/write reload.

The only problem being that we'll have to check all paths in almost
every case.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

