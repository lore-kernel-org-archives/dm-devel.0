Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6173DC7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686069153;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zO5wOT/HwMAG1o2dCvhBiXEdJJOB1P58LAVo6PEqo/k=;
	b=YPVjSGIN7eo0gDZ6mQ+YFRikwhja4+ZWH7b3EG3d/nzjIgrgxFF7cMTfBNiJqN8Nfb+hu0
	u/bhXvmCbclQR/Jy/glfiv7A5uwQvBkEldX0rEkbTaATG74hPKhNMvpLASluCwgTZkrAYX
	fqgF1DR/EpMuPbLycmPQPGgyxNNVZdA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-Wnt9Vp0OMfqziwggkzrUug-1; Tue, 06 Jun 2023 12:32:29 -0400
X-MC-Unique: Wnt9Vp0OMfqziwggkzrUug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58E8B185A792;
	Tue,  6 Jun 2023 16:32:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 695CC9E8D;
	Tue,  6 Jun 2023 16:32:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A78519465BC;
	Tue,  6 Jun 2023 16:32:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 262A219465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 16:32:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05F449E94; Tue,  6 Jun 2023 16:32:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1AC79E8D
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:32:19 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC14529AA39D
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:32:19 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on2050.outbound.protection.outlook.com [40.107.13.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-aS1mWE54PEKstvym9VzjQw-1; Tue, 06 Jun 2023 12:32:18 -0400
X-MC-Unique: aS1mWE54PEKstvym9VzjQw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAWPR04MB9864.eurprd04.prod.outlook.com (2603:10a6:102:390::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 16:32:14 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 16:32:14 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 4/5] multipathd: reload map if the path groups
 are out of order
Thread-Index: AQHZjpZ2q6vNqLfPoUixhg0FPwfDKa98pQ7/gACgTYCAALvDiYAACpkA
Date: Tue, 6 Jun 2023 16:32:13 +0000
Message-ID: <ee1290d1c2b5adf734a6df243707b3546d261f0e.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
 <76217148d8069829795fb1d8608d5c5da60402e2.camel@suse.com>
 <20230605190807.GT24096@octiron.msp.redhat.com>
 <20230606044215.GV24096@octiron.msp.redhat.com>
 <a9070100acf9c2a6ba479dd3ca840e3d61e522f7.camel@suse.com>
 <20230606155402.GY24096@octiron.msp.redhat.com>
In-Reply-To: <20230606155402.GY24096@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAWPR04MB9864:EE_
x-ms-office365-filtering-correlation-id: bf64fe18-4766-402f-88ad-08db66ab95b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Ey5XLVdRkHwmO1yei6mhoaP4kstuBrBuOYd+W7ecr6D5HEOfKzQ7EBjigtsuiM5ngj7OTFXfZoK23XYTGNTFw3fbWEap5WTMxC7L0YjIBaJVe1m8oawLa6hraOVXgj7cDyAkh7KXgMxq+KqeQHcgpOpNbwNsHy8VIUdrdOuqPyR20GF/0PgP9UD8tRo1H5ZW1VKrxlRV8KAA3k8oifey8PCAlwiabfu+fVdG9fMfNrzEPHDXSI8mODZOkEdUXDM4xiIafJVMH3PCCX2S4eHIsKuvdfvBekUihacLwYWBTi0Or236MKJ5OSgA/dIRImPCdeGa98Z8+1WJfrXWOOagICjEyKsJM3GX8XFyKxOsdexO1/nxdZLaRki8yZS1Z2KvnOHDra+KCzZKbXAOdYHhjoWRZ+Xraisy3D841WwWrOm3LMxis27m3ehMKhc9h1aQ+/8v9RgzikHMILl26KR4PtsEbNM8Wj6UMUcmJvp8ToWIrvM0ARrDrzWXX5T0ToqRZJyn74XC3Iw0FD3Xv0puIbVc+HHTeq971jI5yZKKFsyFPdib86BhrA1Ku8IYMwPi521d7fwcSAP69i2HCwuBX2Dat+wFdiy/b449Hk3vbjdmjcCy9ofjPfPxEAKCTMH6
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199021)(83380400001)(44832011)(478600001)(8936002)(8676002)(316002)(450100002)(41300700001)(4326008)(66476007)(66946007)(64756008)(66556008)(76116006)(91956017)(122000001)(5660300002)(6916009)(66446008)(38100700002)(38070700005)(86362001)(6486002)(36756003)(2906002)(71200400001)(26005)(6512007)(186003)(6506007)(2616005);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?9qKxjeJgyo3sPDTgXml+GCOl8l6X+N59UiGZuM/GDqNKyEm48KXD5Iid4?=
 =?iso-8859-15?Q?B8GqG9nLMnm3Zp+nFKjtQm0RHt9QCu9a9QIUF4xgFP6/bzRvvLd4iUQBD?=
 =?iso-8859-15?Q?27vfWr1RFA2FETFQ6VLa9O01BLFcB4or/Div26O88cLeos/RBSG4ue94I?=
 =?iso-8859-15?Q?6lF6Le94ScrRNQB1GqZ+xCqar/nYJ8Ltgdbos9A4K8AkxxqystbeZl0iR?=
 =?iso-8859-15?Q?ELcU/1CSkdMlN/HpgfBH8JYjKCH/2/BASml6TYO5N1D2Bnh9jpcn5tgSU?=
 =?iso-8859-15?Q?z/jAEGQ8iXZTl00QDv9gIzRvw2U35I4frTAOK03hszlpPBSMWDJp8zF8F?=
 =?iso-8859-15?Q?JU6ABs987/UAxhwRTP7OrpIjFHD/sAkdz4ezV1e//9BQ59ErAk57dxmnx?=
 =?iso-8859-15?Q?umdN5a25fYRxTaFV65CDB8wgONKbo3yn/vv/b8dgmdJpCft7JTiDp+6U+?=
 =?iso-8859-15?Q?C5YNHdeckYL7+7cf6PWrX7TniZoK97mc7PHmBDj/k74VuqCr5Lf+pmFAS?=
 =?iso-8859-15?Q?cNWMLbnJuISbDfGXTL7oc+Ni13wj2OYdOQWt3FIQW+5VlRl2kL21gXWiI?=
 =?iso-8859-15?Q?mZhVf+gpJ5jdiqWdtdBY9IiWkF/WtNtb2X9zwQq70uhLi2In5mxxeLawp?=
 =?iso-8859-15?Q?57w9TaMbIu2Rv+2MWIinbLOVFGj+YbDKIY5VwMwCcvp4JJelVYusKX/N9?=
 =?iso-8859-15?Q?deCQtGsGSpkVPBvzQk6/nDBpYZhZOYauywpnsN7jGYFOSqapN2HsNLJoC?=
 =?iso-8859-15?Q?Ud0+D9PluEbCJbwMlNVvHVY+ajhYOAIPTdF9ZHznoP9y8a+sWgIfihGNQ?=
 =?iso-8859-15?Q?ZbXI5v3moDRO76pSt+NRjxFCI2sTc0SvJdPmwl3uu7kjS9W6MhzHxA6nX?=
 =?iso-8859-15?Q?hqyKN4T1nfFMef2yoX2Bi92lpXov5edQESB0gGNzjbHesHtQEyJQ02LnI?=
 =?iso-8859-15?Q?JqMawpmnTjivDG8cbJqjMY60iS8vO6kMsVg5U6Ag3kmOTT9KbAOhM6+Oc?=
 =?iso-8859-15?Q?NCAmPMNmJlKHYf8FawHWaTMohN8dMskyrmAlCaz0uMpmI+Puc2BptV8ww?=
 =?iso-8859-15?Q?AFWXB32W27UGDqZuB83Au6ioi6U1At7+qLJLmEJT5Gx3abc5J1pvJSurz?=
 =?iso-8859-15?Q?+TplMoqM5JPrnnrWBNjLTy+NMMggv2gaAacJym7Vt0sAs7TegmYfGb6g6?=
 =?iso-8859-15?Q?Z3jsFVdUZO+dnmqTL7Nj9kcAqtFPBFPRsEfANqZFRoXcUe4lMQRthztL5?=
 =?iso-8859-15?Q?5Uge++q7u1vbd7y5P99uFyhp5U4y1kD6dQFVwJ0TVx3VXUBDG4NZJJkqL?=
 =?iso-8859-15?Q?nozbOEX95PmXHOlTFLlsoK/4LNounDCprTQ1+bxdOfzj9fSFGy1xJ4Acs?=
 =?iso-8859-15?Q?F5lr1WR+SRd7/3DYamiSrE8al8kZV7TEYeDKrH7+XMmedX3/RpyBJ+UMl?=
 =?iso-8859-15?Q?xFRFrxAZUeuSnwsa4ta005XFR4aURj7Kfc8iHzgvWKLUheSHcANLSamYs?=
 =?iso-8859-15?Q?7vdLAiPnqaoktG8ixgv+jMoWcwqdW4mvDgx1Q5oheijMWG5HzXuS74c8h?=
 =?iso-8859-15?Q?i28PKmKR3nXxrkyY9fFPFVaALaleyWXUL7qLdNku+n2yo4x6vKsMVlt1y?=
 =?iso-8859-15?Q?ElENk3zG9NDfbt5m6/t693eZDZ3M5IANds5n2JdrkWIuIgOYGXEPl37Zl?=
 =?iso-8859-15?Q?hfeu?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf64fe18-4766-402f-88ad-08db66ab95b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 16:32:13.9704 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8HT6XoaaghzKqtsuLX4l8hOr0Z7T3mxwO2udWyrZCbukYTijIslksejg9HdR+yo6Xsx/F1YXHCSZsmqkaGRDPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9864
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 4/5] multipathd: reload map if the path
 groups are out of order
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <3D7113360A205B47B8755106CD814B44@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-06-06 at 10:54 -0500, Benjamin Marzinski wrote:
> On Tue, Jun 06, 2023 at 02:55:27PM +0000, Martin Wilck wrote:
> > On Mon, 2023-06-05 at 23:42 -0500, Benjamin Marzinski wrote:
> > > On Mon, Jun 05, 2023 at 02:08:07PM -0500, Benjamin Marzinski

> > > =20
> > > Actually, after looking into this more, pushing those two
> > > functions
> > > together makes the logic more confusing. Plus select_path_group()
> > > is
> > > used by multiple other functions that don't need to check if the
> > > path
> > > groups are out of order.
> >=20
> > Hm. Can it happen at all that select_path_group() returns something
> > other than=A01 but path_groups_in_order() returns true?=A0
>=20
> Yes. It might even be the common case. Say a switch goes down and all
> the paths in the high priority pathgroup fail. The kernel will switch
> over to a lower priority pathgroup. As long as those paths work, it
> won't automatically switch back to the high priority pathgroup when
> we
> tell it that those failed paths have recovered. It's multipath's job
> to
> tell it when to proactively switch pathgroups. Since multipath
> doesn't
> update the priority of failed paths, the pathgroups should still look
> the same (unless you use group_by_prio and the path fails between
> checking the state and running the prioritizer, in which case you
> will
> likely get a PRIO_UNDEF and reconfigure the pathgroups, but that's
> the
> thing group_by_tpg is trying to resolve).=20

Ok, this is subtle; it's caused by the fact that path_groups_in_order()
ignores the ordering of PGs with pgp->prio =3D PRIO_UNDEF (which will be
the prio of a PG with only failed paths), whereas select_path_group()
will ignore such PGs it in a different way - by never selecting them.
I hope I understand correctly now.

I have to say this is confusing. We have different concepts of how path
priority and path state together affect the PG priority, and we apply
these different concepts in different parts of the code. I'm not saying
it's wrong, but at the moment I'm too confused to tell if it's right.

> =A0
> > If we follow the mindset you layed out in your patch ("the kernel
> > treats the pathgroups as if they were ordered by priority")
> > consequently, just determining bestpg is not enough; we'd need to
> > sort
> > the PGs every time (except for a user-triggered switchgroup
> > command).
> > IMO whenever we reload the map anyway (e.g. in setup_map()) we
> > should
> > make sure that the PGs are properly sorted. Using "switch_group"
> > instead of a full reload is just an optimization because the kernel
> > operation is more light-weight than a full reload. But as soon as
> > we
> > have e.g. a marginal path group, reordering is probably a better
> > idea
> > most of the time.
>=20
> We already do correctly order the paths in setup_map().
> setup_map() -> group_paths() -> sort_pathgroup().=A0 Actually, looking
> at
> this, I don't see why we even bother to call select_path_group() in
> setup_map(). The answer will always be 1, since we just sorted them.
>=20

Right. I suppose the call to select_path_groups() predates the one to
sort_pathgroups().

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

