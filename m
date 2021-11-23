Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2D2C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 11:05:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-itGxIcBnOpCJGOwzgqgRTw-1; Tue, 23 Nov 2021 06:05:38 -0500
X-MC-Unique: itGxIcBnOpCJGOwzgqgRTw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2782980EFAA;
	Tue, 23 Nov 2021 11:05:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E7C9100EA05;
	Tue, 23 Nov 2021 11:05:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF14E4A703;
	Tue, 23 Nov 2021 11:05:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANB5RSa014045 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 06:05:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1056C4047279; Tue, 23 Nov 2021 11:05:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AF084047272
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:05:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E03F7106668B
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:05:26 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-53-MdwWgAbzP1yPPdp8KjXfLA-1; Tue, 23 Nov 2021 06:05:24 -0500
X-MC-Unique: MdwWgAbzP1yPPdp8KjXfLA-1
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur01lp2059.outbound.protection.outlook.com [104.47.0.59]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-4-HgxmQHW3MaO2X8Q9rBMKYQ-1; Tue, 23 Nov 2021 12:05:22 +0100
X-MC-Unique: HgxmQHW3MaO2X8Q9rBMKYQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4473.eurprd04.prod.outlook.com (2603:10a6:5:34::26) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24;
	Tue, 23 Nov 2021 11:05:20 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4713.026;
	Tue, 23 Nov 2021 11:05:20 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH] multipathd: avoid unnecessary path read-only reloads
Thread-Index: AQHX3M5WUEb/bxOK1E+H6voh4CAkfQ==
Date: Tue, 23 Nov 2021 11:05:20 +0000
Message-ID: <d4620e9a741d0c5d8565f71c4a20eebb1ca6ebee.camel@suse.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
	<6444fd097cf43bdfe6b1947f42f270e958310fff.camel@suse.com>
	<20211122153554.GJ19591@octiron.msp.redhat.com>
	<7ae474b1273b27a188593b716e5f0dfc1d09cad1.camel@suse.com>
	<20211122174303.GL19591@octiron.msp.redhat.com>
	<148fdecf9a05bcd82fa7da26910a82dc94d579df.camel@suse.com>
In-Reply-To: <148fdecf9a05bcd82fa7da26910a82dc94d579df.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 170c8bff-4567-47da-bb4b-08d9ae7123ce
x-ms-traffictypediagnostic: DB7PR04MB4473:
x-microsoft-antispam-prvs: <DB7PR04MB44735A84D8CB629533411B26FC609@DB7PR04MB4473.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ycdS6CXCAxXFS+RrLWBkFFMqeYmnTFILGbrHu4VFJllZgl5MlEgmLLfSn3cmHMiw7KvwEl4R+b14JNkAYOjLl04Mrt18gIPrZq0BLF8v/Ykxpe1HR7jrOxSShTqdrvYFVLYLg73uqaMJNGL+st6fj1A3Gu+l8O46tdeBhkjrpWgsnRamE1SXu0qd7WhO/GL3CGmWmyIggK597M4wuwHs6ci5CcnzPLNm+DiY+EVOAoamHisbdYBMOGg6DIg1HO7WkGHBtXe6c8mXzYkBhCt8tuVRwSN6njqOsCkkQDdVKMb/uoLfm7ljdR8c1Sbg5osqaO6IGavzjeU24VaZOPmVhs6VPHaReAw+NK5yhQe85lQunjT/4NoUK1Ev+/yYXX00kg6dLnJXxjnbA1xC2thxETZ5b/ibgM4RxUyXyVqF/7+XIgulrW+Bi34Xeh1JPoI1nbJUFj88fJ8QxVIVUWA/kZPHcSdDBbWf0zXU4hVgl1jLuUbJUhgv0OWcC479TlH3vm2UhDtIkPKzcNB8Qsl1J5wF9HyZYP73/5qP5RCFmC3sCn6x5W4i1uVp5yd5g0WdQY2QOebpnBvmaTOox+HD+njeaVvrgtiOQ2KJf+IPl/wJBUd06D0ZP0FzNiNfLOg/x4TpNC97XUAE82SAfjfVlVl8a+Bdn33bPbZ/l2TS7N9KQ1aBmoGameNPheDqVCQAhwnjO9WVCXDpKDK3Sdqxzw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66946007)(66556008)(66476007)(64756008)(66446008)(316002)(86362001)(54906003)(122000001)(5660300002)(91956017)(76116006)(38100700002)(6486002)(8676002)(4001150100001)(8936002)(71200400001)(83380400001)(186003)(26005)(44832011)(6512007)(6506007)(6916009)(38070700005)(36756003)(508600001)(4326008)(2616005)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?SrBMByx+/gLeFgiwANnP463BShLfu1d5WwhSUvOjXUtrOdooGqVVsxyVT?=
	=?iso-8859-15?Q?8X5j02ZgkF86/jDAWUt2f4fHc8bEAaAXq1k/G6yciW8eVmgIQ7oBKyLSu?=
	=?iso-8859-15?Q?1HMzy2nvPF3gqVrOxJo5E+bKPkXHuUMlXSsGqr7qT0ZpT719F88au67UR?=
	=?iso-8859-15?Q?RkwBJnyEfAV5dN9qdtPbIXoVMVCNx/TvHWqcLhTXeO8BmPmINBRLkZYga?=
	=?iso-8859-15?Q?tGZP6R/FRgd7wqraEuQy8YjtQxsfhh0QEorlnQQrSw92E/zJnGPeq0DZZ?=
	=?iso-8859-15?Q?BMxJgSlrwHzRNaNdoVnfdgKcybID+gK27JWf6SRvx83tPlc6mydPyBQoo?=
	=?iso-8859-15?Q?RkpGLYwNGqE8hmBcEkHCTcaYMo+/t43oVfeMyQ2FJmUcoAppO8FJBiXU7?=
	=?iso-8859-15?Q?DAwp6M7otFVY/AMHyxexr6n0FkjRSUkOgqCPVqAldxF4qWzvuIgiU+RZN?=
	=?iso-8859-15?Q?7oARnHpUXt4TxBBW/666rcPhOlHzfvAsKKSZvNAv3VImTKyzxoNC5F2OY?=
	=?iso-8859-15?Q?ky0Mi3oYmv/M2gE9tu7wMMmSOf/x9wQuu4OHUOsMOauTJeerqLyUpqOYP?=
	=?iso-8859-15?Q?vK574EDiXy8rbQA0YuBYH4VTyOCN7gUGmEUmKlgY7UmpDjLX0HYMbkgJb?=
	=?iso-8859-15?Q?IGkCw/l1HviLtx5Bobjh3xVkQlDPIEaTiBvhHy1M3CZx9tn9xKbam83wU?=
	=?iso-8859-15?Q?Br4W5L2yAKGbaUa13X1NioT0HBM0BWfgsptQzY7EjMHXtSGzcXrcomnyu?=
	=?iso-8859-15?Q?llWSBjTnXMFyLZ3H2rpdEilO8fl8D/ceVVrM3pCOdGzyHdEAyZKyIv9Ek?=
	=?iso-8859-15?Q?81mVTCKASPBwPoRBFIaGiB+AZI5JlfzuWskQo/vBlPPkUVzms17dRij+J?=
	=?iso-8859-15?Q?m5eKYh0dfbmoRvhtyYxpy28cqgBeClhSsfQXzZ2+xzWi01gEvEqNfGGfj?=
	=?iso-8859-15?Q?/cDYA9KylHOp6ok//ZdSo2BW+NkDW/VFq7w87TgxUyvn8YCnFaHvZ3nGP?=
	=?iso-8859-15?Q?34KC2fqtKp3Ju3HkKoeW8sdtQJz+ZN2IqWKzDVTWQIwD3jqG+LxXvxUu5?=
	=?iso-8859-15?Q?MSrHWO0ow0egO2jiUfqZ/yoOL2mNwu6FcBZ4ccjhRo/UQfsNP5OixFsk6?=
	=?iso-8859-15?Q?2NZlcGUCPK0fx+hA8YoKXgYdjwwb5mA3kc27AeYRx0EL/ywt0N2UqrYNj?=
	=?iso-8859-15?Q?5ruSaw+If/V62D+XVJxqhjfEVbTFbpdAno+OmvxpEBeC/0hK1PD8EI4wz?=
	=?iso-8859-15?Q?+sh864rvSmgfrfHbbo9KpLQem7yngS5pSvCfCj+tfDqWfTdxVsjxyXu4r?=
	=?iso-8859-15?Q?89zKEsLHgjMDhsfsQbpz8NXA1eArqijK26ad1ldmhiakO6ooAi93ZnYRX?=
	=?iso-8859-15?Q?dt1cwVcRfCpk/8gwLHzwKtAsSFgeTN5Uv2qPZQcCl3XsAy3g3vtY/bjpl?=
	=?iso-8859-15?Q?K8Xk10ZLVeJCrMqYMebPWpZbLnx4ALRnAY4TIr0LANLnWrSAKUhvYXopW?=
	=?iso-8859-15?Q?nIX3MnsqrmIVXL/uwQzROsu4Z9r/EJIwPrL6Ei1/VjbWpkn7yCqjyYU6b?=
	=?iso-8859-15?Q?hrKkUndgcMXtj78AOLkjGrAMHyxEZ3X+fts0xamIWMheML7qzEJxiiGAP?=
	=?iso-8859-15?Q?h3WfXrmil4+iEwBP9KeuolaPvlL9ggaXAs5IMeRxIvVjvJBK3F73Sad3D?=
	=?iso-8859-15?Q?SP7RspTCxU5hLF3/ZPJcwtTWGlnm93sbjqbOtAdht18mNSU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 170c8bff-4567-47da-bb4b-08d9ae7123ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 11:05:20.2465 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BpaAB6+YyMYTVgmJRI9Ssf3AMHXCWwHjjvRtsEI7qeBwg5ZlPVZzg85cjFllP2Mh9g9rQyyVk7gCXDOhS63u9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4473
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ANB5RSa014045
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DFF670FDA5487949923F9A2797B7015C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

some more thoughts about the ro handling.

On Mon, 2021-11-22 at 20:39 +0100, Martin Wilck wrote:
> On Mon, 2021-11-22 at 11:43 -0600, Benjamin Marzinski wrote:
> > On Mon, Nov 22, 2021 at 04:48:06PM +0000, Martin Wilck wrote:
> > > On Mon, 2021-11-22 at 09:35 -0600, Benjamin Marzinski wrote:
> > > > On Fri, Nov 19, 2021 at 09:33:39PM +0000, Martin Wilck wrote:
> > > > > On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> > > > > >=20
> > > > > > +static bool
> > > > > > +needs_ro_update(struct multipath *mpp, int ro)
> > > > > > +{
> > > > > > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > > > > > +=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > > > > > +=A0=A0=A0=A0=A0=A0=A0unsigned int i, j;
> > > > > > +=A0=A0=A0=A0=A0=A0=A0struct dm_info *dmi =3D NULL;
> > > > > > +
> > > > > > +=A0=A0=A0=A0=A0=A0=A0if (!mpp || ro < 0)
> > > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > > > > > +=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &dmi);
> > > > >=20
> > > > > Why can't you just use mpp->dmi here?
> > > >=20
> > > > Since that value is set when the dmi is originally created, I
> > > > didn't
> > > > want to not reload a map, if we simply haven't updated it yet
> > > > to
> > > > reflect
> > > > a change in the read-only value, like with do with
> > > > dm_is_suspended()
> > > > or dm_get_deferred_remove(), etc. I could make a
> > > > dm_get_read_only()
> > > > function and put it libmultipath/devmapper.c like the others,
> > > > if
> > > > you'd
> > > > rather.
> > >=20
> > > I had expected that this property wouldn't silently change under
> > > us.
> > > Actually, I do think that we should get an uevent if this
> > > happens.
> > > Not sure if we process it properly, though.
> >=20
> > I think we will update the dmi,=A0

This would need to be done on a change uevent for the dm device in
ev_add_map(), but AFAICS we don't. ev_add_map() is basically a noop if
the map is already known, unless wait_for_udev is 2.

> > but I'm not sure that these uevents
> > won't race. The worry was that the device would switch to read-only
> > and
> > then back too quickly, and we would get this event and still see
> > the
> > device in read/write because we haven't processed the event which
> > would
> > update the multipath dmi.
>=20
> OK. I'm fine with the patch, perhaps explain these subtleties some
> more
> in the commit message for future reference.

I've never looked into the ro attribute processing closely. I just did.
I'm unsure how a race would come to pass, in particular with your patch
applied:

 1. path change uevent arrives
 2. ro attribute of path device has changed
 3. map reload occurs if=20
    a) map was rw before (thus all paths, too) and the path changed to
ro
    b) map was ro before and all paths have changed to rw
 4. kernel will call set_disk_ro() depending on the DM_READONLY_FLAG;
    set_disk_ro() triggers an uevent for the block device if and only
    if the ro flag changed
 5. we set mpp->dmi in __setup_multipath().

We hold the vecs lock between 3 and 5, so even if the uevent arrived
before setup_multipath() was called, I don't see how it could race.
mpp->dmi as derived in 5 should reflect the state correctly.

What we could do is remember the ro-state of the map in dm_addmap(),
e.g. in a mpp->ro field. If map creation with ro=3D0 succeeded, we can be
pretty certain that the map is in read-write state. Otherwise we'd
fallback to ro=3D1, and remember that state, too. We could verify that
state once more against the dmi info in setup_multipath(). By doing
that we'd cover the time span between the dm ioctl and retrieving the
dmi in setup_multipath(). That would IMHO be more consistent than the
current use of the temporary force_readonly flag.

I've been wondering whether we should use your logic during map
creation, too, and not even try to setup the map with ro=3D0 if we have
paths in read-only state.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

