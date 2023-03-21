Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1CDC74A5B
	for <dm-devel@archiver.kernel.org>; Tue, 21 Mar 2023 09:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679389867;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tjZeSW31fK4R8zt45n/NVU7L1WF34rPeMx1SGv77n/g=;
	b=XzqKfbCg3gOl9cMn2cEsiJ0OJmCCCezSCmHZdCeQqgRj9XiZFomlR7/FPNgFluGbqGR3l2
	02N8pkmZ1o1f5clb5Ncf8mV8h4dCH1h7Ze59i7pZoffRQlt7+SM8F9Ne9ECgHeaCvz9Iqe
	AbaguCD19zC28HoXL596XsYmoK2ysrA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-_xaGlEgXNbmeKB7JE5wD3g-1; Tue, 21 Mar 2023 05:11:04 -0400
X-MC-Unique: _xaGlEgXNbmeKB7JE5wD3g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1AB21C05B0C;
	Tue, 21 Mar 2023 09:11:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93B8C492C13;
	Tue, 21 Mar 2023 09:11:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F232B19465B2;
	Tue, 21 Mar 2023 09:11:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05F8B19465A2
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Mar 2023 09:11:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DA35CC15BAD; Tue, 21 Mar 2023 09:10:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1A79C15BA0
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 09:10:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A71DF3814949
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 09:10:59 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on2080.outbound.protection.outlook.com [40.107.13.80]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-ghXCH46rMc6G-CJniKQi-w-1; Tue, 21 Mar 2023 05:10:57 -0400
X-MC-Unique: ghXCH46rMc6G-CJniKQi-w-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DBBPR04MB7531.eurprd04.prod.outlook.com (2603:10a6:10:20c::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 09:10:54 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 09:10:54 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH] libmultipath: limit paths that can get wwid from
 environment
Thread-Index: AQHZPKvyANbsh8kW3UyR3Hllsj4wYq8EXl96gADSXIA=
Date: Tue, 21 Mar 2023 09:10:54 +0000
Message-ID: <0ac7494151ffb02af7576b40bda4580b3461238c.camel@suse.com>
References: <1675963711-22722-1-git-send-email-bmarzins@redhat.com>
 <5be1cfaef0f67e4992169b92a9c44cdcb623affc.camel@suse.com>
 <20230320203752.GI19878@octiron.msp.redhat.com>
In-Reply-To: <20230320203752.GI19878@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DBBPR04MB7531:EE_
x-ms-office365-filtering-correlation-id: 593b609b-8407-4cde-2a1d-08db29ec2cf5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1TubnH7a6x5/0ygjO8YL1apsImuG/zAn8hauVkRDB+w1LrwuSFjxMPb467vWSa+A4yjb5RgprENhsR4pCbPfUb2m+/Bohnb1X+Dq/Ghj+7L5G3ByKc90Idpa/fcAeFHwnP4Jk2kupeWtbCqe1OgufbopzwoR3YjapASCTeRfA49KjaP/y4//Abzr262Ze3l8Sc/QWQI5iMOmvZXzEbTrumc/qagLLhfslMMOy4TOKLOaeqewDwnPeB1B7eTQpq1EocdwIwTK6q3mN52bYzuA+zYwkPpFTs3wSQZeRiWMyleqnBzFEd2nec/xoZQqB7Easq9ijA152hJF4Et3TNVcZYvNGo9hE+K+K09IHw/HUnP8LN9Juzufl5Df+p9HJBfJz3VDgU9QBjfK8dxZWTtOUbh7G2SpGMyQTb0FBA0fgG0zWuQNAyMNtQLPHZNi9tJ4jaycyDtBQUU44oAIEiWYrzcwhkJrfX40FQfLcmJsL34J9z5/nvDRLLxQpe3JT8j8BQ39SgrIlZxoW1y0DubZgjT36BYIxRRmvfZMaIgTeTO3Xiqbdnlrl6duYJwXCXEmaDlPyVOMihuhllXMdaF3gFNGmZxKaNqcTptnCi3Iq5LqXzKYgp+SXAJTcNc60NeA0iiDJ0NTA1yF9gryqiJsaL4BnMtiCKnfJAjUUMu9+XLrqQJzwaUCN6rxl9bxsA/56cAEl4sqwkl2XXoNAvIvwQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(54906003)(2616005)(6512007)(71200400001)(6506007)(478600001)(6486002)(26005)(5660300002)(316002)(186003)(44832011)(76116006)(38100700002)(38070700005)(86362001)(2906002)(8936002)(66946007)(6916009)(91956017)(122000001)(4326008)(66446008)(36756003)(66476007)(66556008)(64756008)(41300700001)(8676002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?rx4XDTcWtRJGe9bb9r8GXfAp1TmQTWZHYnPdJdeRYeteMzRB8X3hao2cC?=
 =?iso-8859-15?Q?NGp+aJ8AqU2vspwAzkX1OWsvNtWwHEvt23K4XC6dQshQYPbD6ux+mM4pB?=
 =?iso-8859-15?Q?Ly6H11c848nut8ExjQJuhoqel+5aWaWkZaekEjhVfmeJpquMArzDEP+v4?=
 =?iso-8859-15?Q?G79X2nMYkmOB08vR5o6h3ZCSUmF9BO3nIEzB85qPnhaE+mVTTJvZpjv6Q?=
 =?iso-8859-15?Q?d1sZLepp7cz6RhZpTDNfGf3536fA+nrSBd8/0Lr2DzQt4WqqCynyN9inl?=
 =?iso-8859-15?Q?AH3UbQ72doElD9dS0+cKSdjarxVzkyvnMxwoMmcd9HUW8R5aKEtg3cFII?=
 =?iso-8859-15?Q?0YT0dhszOdROetyKZccuWF3DTltCBnUTe5oD7gi6BVt66Wyq9/kxlYcfA?=
 =?iso-8859-15?Q?fkS+a8OnurzFCT5q78Pl1o0uMu3hKfNwj9n7P+MJrHPBaSwmYl7EUcnl7?=
 =?iso-8859-15?Q?7je4tchEOUy2+YxqUIFGCTA/T1nbvElmWQSXh5G1wYdrJfRwzmOBcK5xq?=
 =?iso-8859-15?Q?pDj2CS3NFf5tJeeMukQuw+ypQKJel0lbSOMwNqCh/RvHnIYYQx65GyQjP?=
 =?iso-8859-15?Q?+JgOqnOIUgTiweu4lQGrVqIb4We3TSXe/vOatTA8hj9WWZD333LdbUaJB?=
 =?iso-8859-15?Q?2XFCJNI9khTRB8YGUj7bd475mpyzKoWL8RDtSkP+JhWrbUiL1Ijii2CDY?=
 =?iso-8859-15?Q?eW74/jL+nhv/bDQm09AMJ4+4xXE8U21QoYBPRHytli52H5xBn3fJJrOrJ?=
 =?iso-8859-15?Q?3jMyrS6FaL4kO66sPd3kPZ9MTfA8lylqEOt2dekXHXAXCrMCiO4qEJcXo?=
 =?iso-8859-15?Q?kyjSsX9NwLNnB40pe6Sk7bsAOBn1RfSMVygdYULjjVXZb5jnkrReWSpUD?=
 =?iso-8859-15?Q?e/+ZBucVRm0OXqDyetCYHAcbb5AhMuNUr2OjRsdRjs/O8IF9DOQKHXEPV?=
 =?iso-8859-15?Q?N81S3qkO5ezSBlq5jpR5MtarvoBi+tAS7kHdh4vMDWvUc8DWd6yoz/vHH?=
 =?iso-8859-15?Q?qc4q1uDO1VlpetXx9hqvSgI4JTg2U5McKqHE5eu0x2msEPKCcDewreLIf?=
 =?iso-8859-15?Q?U6uJM9mmZu3hOg3oIXHgkKj10HNoSfohGlyWjtWMft+JKk1/MaPJbdsXC?=
 =?iso-8859-15?Q?GCS2OVcyIzSqaEdePlXHjeuRXIzRbyoQAWLL7zouCJDH6WvmT0z2KAYMx?=
 =?iso-8859-15?Q?S29rznMOFDDMGgsw+TMXSN85ogMzwI1z2+R/mwQzd/ndqVKV2pDI5kHrg?=
 =?iso-8859-15?Q?elbtLXYRJoWEwyAW71x8w1q1ARUX9V8Eguzr00xLpsgGeQDd0HPp2aCAo?=
 =?iso-8859-15?Q?7/Xe/SBzALPoWoohlYTwimPmXiqGBan3W398ZFeL0gRQF3MAUPNzFJ2x+?=
 =?iso-8859-15?Q?vqRd2eLBeEp7N1rdhgLixMQ8A3zWse8aN3G03XQtUrOxayujEYTBtzB9S?=
 =?iso-8859-15?Q?yG0NWizqwsTiidwK0jJgYdkyIPXvsxhN4fx3E69eYETFcZ6RTHFQvU4SG?=
 =?iso-8859-15?Q?r8vG5G1a3WS0m9GfF1w3doPXkV+PlV0fOV8S2W6z0ErG3a0OlTiittdN8?=
 =?iso-8859-15?Q?CvkVEMZwG9SVGz11jju26xNoe7pjdPXnsTiaeXLljqM7ON04OGa5aWGiz?=
 =?iso-8859-15?Q?uU/qJpFj3ZhzRY95FrWzMQzupCJaLkZOpf9mgrenWyTQBgAwqxbWNz/DU?=
 =?iso-8859-15?Q?y5ICtnWAFdSISbvZ0lcKtFNSBw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 593b609b-8407-4cde-2a1d-08db29ec2cf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 09:10:54.5717 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8XFO3/ZVzzUn3W6xypO/UNGtlqESgs/AbqUNJYU1ZOq4+DUf7GX5HvvLa+0aF/P49jjjPEKHil36FzGOY+n+7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7531
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] libmultipath: limit paths that can get wwid
 from environment
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <401CA86BFC90ED4E80E6A17CB97BF797@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-03-20 at 15:37 -0500, Benjamin Marzinski wrote:
> >=20
> > I have to say I don't quite understand why we read from the
> > environment
> > at all if the libudev call fails. This was coded before I joined
> > the
> > project, so perhaps you can clarify it. Why do we expect the
> > environment to provide the correct value if libudev cannot?
>=20
> I'm pretty sure that the udev database for a device isn't set up yet
> when we are in the middle of processing the ADD event for it.

You are right, of course. I had a brain fart.

>  When udev
> calls "multipath -u" on the add event, we can't look up the value in
> the
> database because the database entry for the device doesn't exist yet.
> We
> have to use the value it passed in via the enviroment.
> =A0
> > If we need to keep this fallback, I wonder if we need another field
> > in
> > "struct path" for it. For example, we could read MAJOR and MINOR
> > from
> > the environment and use uid_attribute only if the result matches
> > the
> > path's devt.
>=20
> This is basically what my patch does.=A0 It sets the can_use_env_uid
> flag
> only on the device that the uevent is for, so the only device that
> can
> get its WWID from the environment is the device whose uevent we are
> processing. The other paths we find in path_discovery() must be
> intialized, which means that they will have a udev database entry,
> and
> we can find their WWID there.

I wasn't saying your patch was not correct. I was just not so excited
about adding this field, which only multipath uses, to "struct path".
But I just checked this doesn't change the struct size, and given that
the environment is more important than I realized yesterday, your
approach is more efficient than what I suggested.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

