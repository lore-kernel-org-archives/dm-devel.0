Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2077C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 21 Oct 2022 20:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666383130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gMhn01YydnIovrYr+Tn42LUnmtDbfGVTrUigCTmYgdU=;
	b=Bp4LLwXuF+Ri2Q8w14fCAPJYHrsOaDndHIRvYTyOzuIDnMfjdP98LRYMqA0csuYJzKLLvg
	k7STQFPD8lk7I1xN/Z+9HnuQBqMBFyaDqxysi8bzU6+t/Kj716hXIymYGCgkB7f71jTWrS
	ZaPJLtb+uBh4jnE4CiUOz8NN1eCY4Sw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-BH8AsdyIPmSRp7AquDKYNA-1; Fri, 21 Oct 2022 16:12:09 -0400
X-MC-Unique: BH8AsdyIPmSRp7AquDKYNA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC454101E98A;
	Fri, 21 Oct 2022 20:12:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2301E492B04;
	Fri, 21 Oct 2022 20:12:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF60A1946587;
	Fri, 21 Oct 2022 20:12:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D96A1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 20:12:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C2E3112131B; Fri, 21 Oct 2022 20:12:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4344C112131E
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 20:12:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DFF0186E28C
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 20:12:03 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-eopbgr80041.outbound.protection.outlook.com [40.107.8.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-VR9aAoOaMCGMPGNAM1QO9g-1; Fri, 21 Oct 2022 16:12:01 -0400
X-MC-Unique: VR9aAoOaMCGMPGNAM1QO9g-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAXPR04MB8688.eurprd04.prod.outlook.com (2603:10a6:102:21f::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 21 Oct
 2022 20:11:58 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 20:11:58 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 4/8] libmultipath: fix queue_mode feature handling
Thread-Index: AQHY5Ylf2Qzi10ejsk2l9uknXUhC2g==
Date: Fri, 21 Oct 2022 20:11:58 +0000
Message-ID: <3451b6aab58d7dbf767b034ff4cc54a071f5a882.camel@suse.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
 <1665164144-6716-5-git-send-email-bmarzins@redhat.com>
 <72e32000e148f9abc792b24afd15aebb5262ad7d.camel@suse.com>
 <20221021174837.GC19568@octiron.msp.redhat.com>
In-Reply-To: <20221021174837.GC19568@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAXPR04MB8688:EE_
x-ms-office365-filtering-correlation-id: 28193d79-eb6a-4f48-0682-08dab3a0821d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: tSk3B08IznbMOsWXSHqzlYXTDCqBEXy+4xPVV7zzLMQTLc+Bw0/aWGjQV8aN2lPaV//4E/HL9RgC4qEL9qxvDpyn2LH+A6A0I/MXPb0HUJvNlIvlIk091Lotx3hKLF7brqOmM+gOIKJ9IpHzcgUNOlBPqhyiMOrhYiycQsGjaviCthFABariy/hcUayhUfyUSG8d7S3XCQjOpOWmww6E29a9GHGeBNI56cmqemyXRS2xcxIHMJ8aYsNl2b6ddBVZfnRvGNI4PFcZrvFfOTJ1Rl1Cj946W443QsV+pIQ7v1SgYaWyBs6U+M5d07kxQgRCt7EinBtgOXOyoCry1zsDr/efsa7oJxg1W/2/GB1QyzKyEsbmuf7yt9EDcLkZ525+UbQzEohm7HCFWMnRWW10YPj4gZItzS2qKEeO9jr69OOhmTCyvc76cMdEOb7bu/g2jRdSCLHMYqW/GE4dMvGTu4/UecELUrqgs7erhAUW8P+4fl/kZGXhU7cyBF3AvVeCIDHR6E7YiGi+ouNYarSkqkH3L0REnkmXE2ix5qqoWty1JbeIvhVLU6n+aqFwmB19/4uNVw8pckjtz2JkZfYGdwr6p45ymdX6nYDdLvc1Vvqn8aqJNwZHI2pUHXcjY9Qazy0jjMRi7oPIURVcarFDZgRzfCdy7A/owzPJs4+UyPcS8GMPEtbAQXjzCQyGoN+B9OZ1NjibiKytXawXNp+8gQFGmKCC39Iaa8bFAMJCOsGbG8O6ecdpyNEPjBUsDJFMhHVglMfeqjY8AJNJ73Kgag==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(36756003)(71200400001)(83380400001)(6486002)(122000001)(66899015)(478600001)(2906002)(38100700002)(44832011)(6916009)(86362001)(54906003)(4001150100001)(2616005)(186003)(316002)(38070700005)(8936002)(66476007)(41300700001)(26005)(5660300002)(4326008)(64756008)(6512007)(6506007)(66446008)(8676002)(91956017)(66556008)(66946007)(76116006);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?NgqurP31ebUvUBchpvS8wd7tDhJyK2cyQQ7WFm1qtfr1sMqs72qe54/u1?=
 =?iso-8859-15?Q?oHknWwo9i3RKY0GEx5D2WsGV/QtuWm1Os344u7xh0vge2i0BR+Yt8AUxu?=
 =?iso-8859-15?Q?S2sm3BE8P3kUUxX+n3gMfOExenIlxadkZblTBO2ioIg5nzOwSScW9LVis?=
 =?iso-8859-15?Q?yeKIgf3+Y0lcgYHie1pcx00bqvrvBUH8I0GmDvQx+OvJNaITqI4EPY9g6?=
 =?iso-8859-15?Q?W+bJ/jYNd+tqnVB5frvfDJjX3i8sjvq5ysIgzeeoBnjuAO3spg4SF1L1M?=
 =?iso-8859-15?Q?2qrZyFX7keJq7KYyWAl7FMecmfi4prGXmRQWR18d3PAqPsw/YznDWHM+d?=
 =?iso-8859-15?Q?/jjp86X+kkzrFTeDHRCdxDHVsdJbrjlQXXDT6VwKzbVliailqUWTtG2hn?=
 =?iso-8859-15?Q?Ac1fkJoqrQMb39Wmq1jfhqBGijaR5xonzZ/LDkcnLkG9ZP/sSH4AlV5GH?=
 =?iso-8859-15?Q?19MPDhek7toI4lYPmYS7QjH1fRQmjD28bqfLCmhmaJuOc6UQAAM86y7Te?=
 =?iso-8859-15?Q?OMLwlTHTCv0a+O3sUl0pCuc8o7a7oZtF9uEFF1UFtrLjdUpQZuxzA3f90?=
 =?iso-8859-15?Q?36Zmv3+Gc8rLC+TyI23rGTLoxwssRu+d6NhXYewoiOi8KXY9lDVRBCgWS?=
 =?iso-8859-15?Q?O43BmHkqJwnuoTycHVC4S/172o0ATVNqd00V8r3B95DwMQnJW49imRt+u?=
 =?iso-8859-15?Q?KN0VtcRw2ySlxQAbVZO7vieSnkYTgaPfZ1TGMGw1FGIHgqHan2l7V5ue0?=
 =?iso-8859-15?Q?ClyJbjzSO1zP6XLsPod0cbpviIZ4fHxrHgEb7Y56cJgoZZax9q7TARYR7?=
 =?iso-8859-15?Q?w5oDZDSi+H12GkReW9ybjzwS6ikJJxQGoBsAHZ1uJx+hTjiNkxGteUaEk?=
 =?iso-8859-15?Q?ybnf3DtebLvl0+PL6tVvELv21aBC3GXaUTkLzP/hLG/pVUxzNWDXH+qGm?=
 =?iso-8859-15?Q?hUQ73PYk4qjt4vA2wc/UMouB+p8mYhvrhm5mpgBe4U0sj5ryYJ7Jw3R3U?=
 =?iso-8859-15?Q?lFB6AMGCko5UQu4f65fLNykP28Z198+cV8kMuN1YMW3leWIg/hFKLACDN?=
 =?iso-8859-15?Q?6TqUvCkUQYlWGucfVgThhtAo/32YJyzBIROeHLIEGHpHcAayA2Vm0N2E4?=
 =?iso-8859-15?Q?e9VdBST6F+ynVtDtWLqVcX2Pz1BIBViIMBal8RY+kb4Y5Wl6CZJwEXdyM?=
 =?iso-8859-15?Q?5Zttw3udQuE5mgDk1wvG5olSUJTxAxRjoA4oC6z4W8pSiAFqPYXmh02Ae?=
 =?iso-8859-15?Q?Ev8nWtxRK1c9andoW+LQEByvReGAgLxp25udwIX8M0n+u0AMVeB9j+2pN?=
 =?iso-8859-15?Q?aHYa/yAk2qq/lsY3YOHBfp9dL3/Na7V00O2W3Du0dtOKQhy8QzsEUSlCn?=
 =?iso-8859-15?Q?aJNmglscrKvizfZjUjiDmTCUMOeBBR80dvQyiEVl0AfDWkY5WvuhpKmSE?=
 =?iso-8859-15?Q?0nP3Qswp0M2qzsyQJ4al7uvX8jjZ6/QgZN/5p4Hk/eAWE7Q03pDaX5ttq?=
 =?iso-8859-15?Q?2GRIfuLuLgb1ImE7XKjfA1QMHOFnrX/abQhdOrm8LwcBuYGQUO2UgjN7T?=
 =?iso-8859-15?Q?JX9i1V0iYjN/SKKuc3ynUTyfcC89s3lm2d9rSDArDl6qIYgO+tJ4Fy76c?=
 =?iso-8859-15?Q?JJZKdspKAlYozIxVeUk7mjeOvmYEkP2puZesRrGz+1GUXYP8rHLr2RWUX?=
 =?iso-8859-15?Q?R7ANuexj17MovMWqQlZxMNh5zA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28193d79-eb6a-4f48-0682-08dab3a0821d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 20:11:58.4956 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: janNm2HnZURk1JQ+OxRPUMfdywciR+hBFqugD6OHcqIe+iCUMA+9+87PT67qnUhl5V/0/EFEX1G2X0ziUnlgvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8688
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 4/8] libmultipath: fix queue_mode feature
 handling
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8BB435C951F9344285F53DD146B94C29@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-21 at 12:48 -0500, Benjamin Marzinski wrote:
> On Thu, Oct 20, 2022 at 02:58:42PM +0000, Martin Wilck wrote:
> > On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> > > device-mapper is not able to change the queue_mode on a table
> > > reload.
> > > Make sure that when multipath sets up the map, both on regular
> > > reloads
> > > and reconfigures, it keeps the queue_mode the same.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> >=20
> > Some remarks below.
> >=20
> > > ---
> > > =A0libmultipath/configure.c=A0=A0 |=A0 4 +++
> > > =A0libmultipath/dmparser.c=A0=A0=A0 |=A0 2 ++
> > > =A0libmultipath/propsel.c=A0=A0=A0=A0 | 55
> > > ++++++++++++++++++++++++++++++++++++++
> > > =A0libmultipath/structs.h=A0=A0=A0=A0 |=A0 7 +++++
> > > =A0multipath/multipath.conf.5 |=A0 7 +++--
> > > =A05 files changed, 73 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > > index 8af7cd79..41641e30 100644
> > > --- a/libmultipath/configure.c
> > > +++ b/libmultipath/configure.c
> > > @@ -1075,6 +1075,7 @@ int coalesce_paths (struct vectors *vecs,
> > > vector mpvec, char *refwwid,
> > > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf =3D NULL;
> > > =A0=A0=A0=A0=A0=A0=A0=A0int allow_queueing;
> > > =A0=A0=A0=A0=A0=A0=A0=A0struct bitfield *size_mismatch_seen;
> > > +=A0=A0=A0=A0=A0=A0=A0struct multipath * cmpp;
> > > =A0
> > > =A0=A0=A0=A0=A0=A0=A0=A0/* ignore refwwid if it's empty */
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (refwwid && !strlen(refwwid))
> > > @@ -1184,6 +1185,9 @@ int coalesce_paths (struct vectors *vecs,
> > > vector mpvec, char *refwwid,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0verify_paths(mpp);
> > > =A0
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmpp =3D find_mp_by_wwi=
d(curmp, mpp->wwid);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (cmpp)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->queue_mode =3D cmpp->queue_mode;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (setup_map(mpp, &p=
arams, vecs)) {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0remove_map(mpp, vecs->pathvec, NULL);
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0continue;
> > > diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> > > index 50d13c08..3b37a926 100644
> > > --- a/libmultipath/dmparser.c
> > > +++ b/libmultipath/dmparser.c
> > > @@ -151,6 +151,8 @@ int disassemble_map(const struct _vector
> > > *pathvec,
> > > =A0
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(word);
> > > =A0=A0=A0=A0=A0=A0=A0=A0}
> > > +=A0=A0=A0=A0=A0=A0=A0mpp->queue_mode =3D strstr(mpp->features, "queu=
e_mode bio")
> > > ?
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 QUEUE_MODE_BIO : QUEUE_MODE_RQ;
> >=20
> > Nitpick: You have spent effort to make multipath-tools support any
> > whitepace characters in the previous patches, but here you don't. I
> > can
> > see that disassemble_map() generally assumes space characters as
> > word
> > delimiters, but at least I see some inconsistency here.
> >=20
> > Do you intend to generalize the whitespace handling in
> > disassemble_map(), too? Or am I overlooking something?
>=20
> The kernel will never output any whitespace characters other than
> space,

This was the part I was missing. The kernel separates args using
isspace(), but of course it won't insert any weird characters
when it returns the status line.

Fine, then.

> so that seems like unnecessary complexity.=A0 We also know that the
> kernel
> will never output a feature named something like "enqueue_mode" so we
> don't need to check for the space before "queue_mode". But I suppose
> the
> the kernel could add feature named "<something>queue_mode" in the
> future. If you think it's important, I send a patch to add a space
> before "queue_mode", in the check to deal with that possibility, but
> I'm
> not particularly worried about this.



> =A0
> > > =A0
> > > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > > =A0=A0=A0=A0=A0=A0=A0=A0 * hwhandler
> > > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > > index 98e3aad1..d4f19897 100644
> > > --- a/libmultipath/propsel.c
> > > +++ b/libmultipath/propsel.c
> > > @@ -26,6 +26,7 @@
> > > =A0#include "strbuf.h"
> > > =A0#include <inttypes.h>
> > > =A0#include <libudev.h>
> > > +#include <ctype.h>
> > > =A0
> > > =A0pgpolicyfn *pgpolicies[] =3D {
> > > =A0=A0=A0=A0=A0=A0=A0=A0NULL,
> > > @@ -413,6 +414,59 @@ void reconcile_features_with_options(const
> > > char
> > > *id, char **features, int* no_pa
> > > =A0=A0=A0=A0=A0=A0=A0=A0}
> > > =A0}
> > > =A0
> > > +static void reconcile_features_with_queue_mode(struct multipath
> > > *mp)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0char *space =3D NULL, *val =3D NULL, *mode_str =
=3D NULL, *feat;
> > > +=A0=A0=A0=A0=A0=A0=A0int features_mode =3D QUEUE_MODE_UNDEF;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (!mp->features)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &space);
> > > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &val);
> > > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &mode_st=
r);
> >=20
> > I was wondering why we need pthread_cleanup() complexity here,
> > seeing
> > no cancellation points in this function. I eventually realized that
> > condlog()->dlog()->log_safe()->pthread_mutex_lock() is a
> > cancellation
> > point. I suppose we need to clean that up some time.
> >=20
>=20
> So is fprintf(), so even as a systemd style daemon, condlog() is a
> cancellation point.

Right, figured that in the meantime.

> =A0
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (!(feat =3D strstr(mp->features, "queue_mode=
")) ||
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 feat =3D=3D mp->features || !isspace(=
*(feat - 1)) ||
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sscanf(feat, "queue_mode%m[ \f\n\r\t\=
v]%ms", &space,
> > > &val) !=3D 2)
> >=20
> > Nit: Given that mp->features comes from the multipath.conf, I'm
> > pretty
> > sure that it can't contain \n or \r as whitespace characters
> > (read_line() would remove them()). Not sure about \f and \v; guess
> > they
> > are allowed but I wouldn't swear that they can be used in
> > multipath.conf without causing trouble elsewhere.
>=20
> I was matching the characters that isspace() checks for, for
> consistency, since we used isspace() to check that there was a space
> before "queue_mode".

Ok.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

