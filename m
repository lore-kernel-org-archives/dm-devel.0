Return-Path: <SRS0=d4ru=NZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8BAC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  3 Sep 2021 15:23:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E29C261106
	for <dm-devel@archiver.kernel.org>; Fri,  3 Sep 2021 15:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E29C261106
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-qWz7AdNxOA22Pi-Mpvv4Jw-1; Fri, 03 Sep 2021 11:23:12 -0400
X-MC-Unique: qWz7AdNxOA22Pi-Mpvv4Jw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B44BE1006C85;
	Fri,  3 Sep 2021 15:23:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28A2A77BE7;
	Fri,  3 Sep 2021 15:23:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE82E1809C98;
	Fri,  3 Sep 2021 15:22:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 183FMv3k001607 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Sep 2021 11:22:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2F6E12051CFC; Fri,  3 Sep 2021 15:22:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22F9F2051B82
	for <dm-devel@redhat.com>; Fri,  3 Sep 2021 15:22:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C936884362
	for <dm-devel@redhat.com>; Fri,  3 Sep 2021 15:22:50 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-100-HzeaE2BnN5KDLqr-A9KG7g-1;
	Fri, 03 Sep 2021 11:22:49 -0400
X-MC-Unique: HzeaE2BnN5KDLqr-A9KG7g-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-22-DSObpW9zOrmdVJQGQcQngQ-1; Fri, 03 Sep 2021 17:22:46 +0200
X-MC-Unique: DSObpW9zOrmdVJQGQcQngQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7097.eurprd04.prod.outlook.com (2603:10a6:10:12a::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21;
	Fri, 3 Sep 2021 15:22:45 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4478.020;
	Fri, 3 Sep 2021 15:22:45 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 6/6] libmultipath: drop unnecessary parameter from
	remove_map()
Thread-Index: AQHXoEWfj707kmXBdUqpXVEY8gUhB6uSC24AgABjHYA=
Date: Fri, 3 Sep 2021 15:22:45 +0000
Message-ID: <05c0b2e043dfb7e8e024f5ebefcec55bdb7b3762.camel@suse.com>
References: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
	<1630619869-12251-7-git-send-email-bmarzins@redhat.com>
	<933d61399192f5e5064054d29488680de0dc7970.camel@suse.com>
In-Reply-To: <933d61399192f5e5064054d29488680de0dc7970.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e13e9e6-1713-450d-1bfc-08d96eeeae6c
x-ms-traffictypediagnostic: DB8PR04MB7097:
x-microsoft-antispam-prvs: <DB8PR04MB7097CB0FC357D6E4E1C254D5FCCF9@DB8PR04MB7097.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EoCMDRe0e6sGPgEiWt8Cf546UiHq88uk/xxRB61xegRLtoENd3m0oqq7Yczyy1pjSmHIXvsPVFW/bajYkAPxIKOkpM1y5K8V/yvUu6V7Z5MY3rj5viDh3GOy250KaJzhwIk2x8rAro6htBO8Gm4fo3wXpCysd+8jAOxF8LZA9MNapeI5xULJKDyEMMpMevBCASAjT3C53yhtxjRBTajgcUiGamoHmP4mCjtZOTM08QBriOL6CaN9C0l2UXCg1iJ8tEpWUfNLZ7YhLgmj9Nu4NHPruq0wIPRV+YN64ihCn/GjInQ8iME8BJ75jsmSxVKC8Oo3LAIrEQvNzYOY/w/aYxT1gwU4aNbHrT+x5M3Os1GTFkDz4lYWaCQj0taIOf4LAyDyX56pxdJDUQ99XradN0LyVJmQ8RzrbeZKOzeCSd9l9nGJ5dQuVcyc3sEJAV9D3CaNYc0ZJBVkS1AHYr9s133JQ/bOg52P2r3HSpvDM7nJTIlc6olCf4xoPAfRaMhR0unUCsOaQERRz1J9ucNeN+W5/YEtsFmtS37kZy/xLS5MSjVEma/TaPBPnLWP2GBK5ru9kKdCfbPPbTdMlVHMR/rqkbUy6Olvo7GDbOv2/ti2cleZLJ5O0Zzsfk8ZGtCsf3WlmS8cBFWUNrBjhsgx2aDkD4VpTohi2sCXmLla7YgE9XHO7ZWoHaO5jZ7XHKXHgNWvSFA2iA/qmNW3hBv2ZA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(91956017)(86362001)(8936002)(66946007)(38070700005)(66556008)(66476007)(66446008)(64756008)(2906002)(6512007)(6486002)(76116006)(316002)(44832011)(2616005)(71200400001)(36756003)(5660300002)(8676002)(478600001)(38100700002)(6506007)(26005)(110136005)(186003)(4326008)(122000001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?SVgh4srSsopP+nHKeFTOaDPMOiLYxE/3HCpnpDMTWL+g9PWrjfZY3ZsJD?=
	=?iso-8859-15?Q?hGYHJePuJFoZkWXYuiBsNd3YBTuLnAq/j5AbntlIR+8fhtDxEsVZr0nvA?=
	=?iso-8859-15?Q?wsx7UmeoVG4MMjQmPPN8QiQ1KvQ7mX7n0cRrWfSNxnTJcrHYqrSaXF4OM?=
	=?iso-8859-15?Q?/VboNeHvjgWz1Kpq9UvqcA1VTOYzbrN7WKbmfBTMNkd8+WeOJK/4ShZa7?=
	=?iso-8859-15?Q?UuP2Zkqen/PyeVGWNXPx6Cbf9M2MwEV+Qdd3+NppVTds+LpAYox8QKB1j?=
	=?iso-8859-15?Q?gEI/flEoGOxolBUWUq+vVGPN9f3tnVJoubAc59h8Q850wo+LXmFh5TE43?=
	=?iso-8859-15?Q?f4Ui8upGd5xFRpE8rBdkirTWLrXuAZRk7S265x3O5Q2Klgj/WbewOtKDY?=
	=?iso-8859-15?Q?HUv2xxhfni4pUkZlLSR+MHFTyb/CfKfl95RqHL9W5LFFN7ZAvTZC1mVSg?=
	=?iso-8859-15?Q?uswmVVzuewDMHQxbgNsCxOYI5G20sOBqtXO0Q3tfPssUa48PD+MIMRjkP?=
	=?iso-8859-15?Q?ygivDPHUlfC2Bw3GjEhOYulYj5JzIWrEmqukukujICVEKVupWvQVUiYHf?=
	=?iso-8859-15?Q?vMUS+hGADboP4frjZ3NAXIZQ1s+OnavWF4v1NFjSWDePvh4Ad8OGBb5gb?=
	=?iso-8859-15?Q?8BsrFCBBG76fMTNJGrYBXAjZfmsUX7w8rox2NqLuM0CoQhEEfCi1cxDED?=
	=?iso-8859-15?Q?ouJ0wLkCqNB61vs/tAyiVDKLAMKzQFTpuYPMusLDQGLLI2Hx4ppFhVXhU?=
	=?iso-8859-15?Q?0Tz1BstKSsKn9dVAwrKOFFoqo2O+E1gec+hV8WoezzfKjBmBbsaY3QGAK?=
	=?iso-8859-15?Q?Y4Q0ZV7/+6I8oZllKiaZTy2MA0FSGQmQX/TIodBIrsq/NS9HjKhAI3Llp?=
	=?iso-8859-15?Q?U3UaUFHED6GY8+26d8WsRNgHlQiYFHc+QgSXTJPWfRhGLLpoZHq2eIxaQ?=
	=?iso-8859-15?Q?A+dYxhqlSz6TY0kJnHFDl56uXcGUAcGvv6E+XxTm4+QdaJcuGdVfux7Us?=
	=?iso-8859-15?Q?TPLVQy9cO8f9nCIQTNlThxSoBFNROKTeVyFxz/pPNaV+t3hKBJezaqMqj?=
	=?iso-8859-15?Q?Ug+c+HLwH/YUrRKc3Y7Lr2Dt55WzbitZ+hSe5io5IkJj7Ttssusfxf8EN?=
	=?iso-8859-15?Q?rapyX/u4PA0BFxjMIim3rRzQj69KeIri18o+s69AQwN+r6jcf1tBXf7P2?=
	=?iso-8859-15?Q?3c9kiheZ3U4ERHq6jZzHGseV/fZAVQx2ZW/ev3Bi573luVp0DKOTLq6oH?=
	=?iso-8859-15?Q?tz0xta4WELpQHvCJRGIEXz15FtYxaGM71I6YogiyCy4mf/1H5cwA4hssE?=
	=?iso-8859-15?Q?vBU/yuMtgXXWW4sZazlYeU6P+oRLsSdU2FCm3cTLgNjFiUaDLjk3KKgzs?=
	=?iso-8859-15?Q?WVB4lAX9Hd+EPbC+62yxMsCDMRUcBpFgt?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e13e9e6-1713-450d-1bfc-08d96eeeae6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 15:22:45.5719 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWhpQT5Ub4rqqlNBeZjDcExS8PDMkdR8vWq1obT1sIh0Q91i1yADm/iK0P99ERtsN0gFOUNU1NkyLymX4Sg5Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7097
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 183FMv3k001607
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 6/6] libmultipath: drop unnecessary
 parameter from remove_map()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C3F62C62E2BCBB45BE65681E38AB693F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-09-03 at 11:28 +0200, Martin Wilck wrote:
> On Thu, 2021-09-02 at 16:57 -0500, Benjamin Marzinski wrote:
> > When remove_map() is called, if the multipath device is in a mpvec,
> > it
> > must be removed from it, because the device will be freed. Now that
> > the
> > mpvec is passed as a separate parameter to remove_map(), the
> > purge_vec
> > parameter is redundant.=A0 It was only used by coalesce_paths(),
> > since
> > the
> > multipath device isn't on any vector when remove_map() is called
> > there.
> > Instead, remove_map() can just be called with a NULL mpvec, when
> > there
> > is no mpvec to remove the device from.
> >=20
> > remove_map_by_alias() also has a redundant purge_vec parameter.=A0
> > Since
> > it only removes a map if it finds in on vec->mpvec, calling it with
> > KEEP_VEC would be a bug, since it would leave a pointer to the
> > freed
> > device in the vector.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Good catch. But we need to adapt libmultipath.version. I'll send a
> fix
> to be added on top.
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>

This breaks the directio test, too. We need a test patch on top.
I'm going to post it.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

