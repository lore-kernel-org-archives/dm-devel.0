Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1AF9C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 14:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666277934;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GAlHXjOpo/zxZE9vbNeftQyEO7OkyaSJ72KgwWKPT6E=;
	b=JP7l1dvlRZr+Jb+DJfBgoWfqGpYUihHhxgjdFIz27Sr10XBS0yRY4SKibx8z0ZZ6lbPP4Y
	mWy8tUBxm+g6cOd6OuDEHZUSThx0kmITr2umtZyfnAvSyL/D2ihVbKZc+xuz7st52VmWSN
	UBlQokHnPclrAx3ze2Px21Ic27y+9OY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-R8Rmx1KpMtK9JnMQV3lYwg-1; Thu, 20 Oct 2022 10:58:51 -0400
X-MC-Unique: R8Rmx1KpMtK9JnMQV3lYwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE621382F1A8;
	Thu, 20 Oct 2022 14:58:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C92F239D7C;
	Thu, 20 Oct 2022 14:58:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 977041946595;
	Thu, 20 Oct 2022 14:58:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 10D071946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 14:58:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F17C22024CBB; Thu, 20 Oct 2022 14:58:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E83D72024CB7
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2B363C025B5
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:47 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2081.outbound.protection.outlook.com [40.107.21.81]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-FnaWXzKkOfCOjD-vNP2GdQ-1; Thu, 20 Oct 2022 10:58:46 -0400
X-MC-Unique: FnaWXzKkOfCOjD-vNP2GdQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM7PR04MB6981.eurprd04.prod.outlook.com (2603:10a6:20b:103::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 20 Oct
 2022 14:58:43 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 14:58:43 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/8] libmultipath: fix queue_mode feature handling
Thread-Index: AQHY2nNFPB4Ke3zSoUWI/5T0xIfo864Xc/uA
Date: Thu, 20 Oct 2022 14:58:42 +0000
Message-ID: <72e32000e148f9abc792b24afd15aebb5262ad7d.camel@suse.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
 <1665164144-6716-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM7PR04MB6981:EE_
x-ms-office365-filtering-correlation-id: 8789521f-86ab-4a35-9c5e-08dab2ab94b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: b+B/cJvEd0Gdf+KDQsr0yo+7qvEpJX+xPPc1m/bDjeeWLh4L+vj7Sx8vkwgU9ItZbZIJhfrKouMPgdfKfXd+T/Xm3hPn7hAG3m9ZQIT6cco9sSIJoQTgiCcSHWrrCtOBwKMovKesB4+8i3dGjofEKo9ZmpK3ah7SARKB2Nend414ohfoVQdh9sp8EzbEJlche8IVYMpb2VR6USyaYUJYm0gdnLkMrx6RN2TKLGAFkTT6wGwYrlNm1oPhGbakcIZFq0oHFBOwhvQiNBtS9SMTxUN8BWB9EGgYrNUOXNN2a4q8jABjjde/Eqcv/bhD2zIO5nScMIBkDY8lrwI5fKkjU42VORle/DQnvSyg8/rRjZLk206j+EJD2Y1jgSGZVgvpbu8rakAznHwckxNBv4sQeshgIVZ0sLN5lNwZSjs22IPGYQnFusN+7kScU0rlluX3B9U/Q9NzPgw3RWrI8OTxFTUjO+g5uI4f7qkDRhPHv4s//01iRa0hn4xbYDE2az1LHYKBo+JtQsMRMzFccnF5Qv/aKUKvRU47Vdp0KHrtssNaFla0+Ol38hsUU9BdFsWfbCR1qA/Blc235lM6b5/To10ge9wssYib1DbqUBJKp7Th0V2UFWNyy/VVNXYb+tK4Aq8MxkNGveVsESXsQ/onl6skbXrqucDCfkIJDO/DMt09HlK9bRVurXV/ji5u8iT4aU+JTTjWuh9KbgNwsCnqocYdZXlRtm1F5aj8Mfzhfi7Q5GqeuI7P7ntbOGVkYvZJhZo0+jHEep4TH/B20FZzPA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(6512007)(71200400001)(478600001)(83380400001)(86362001)(6486002)(66946007)(66476007)(66556008)(36756003)(66446008)(316002)(110136005)(41300700001)(26005)(76116006)(44832011)(8936002)(4326008)(5660300002)(8676002)(6506007)(2616005)(2906002)(186003)(64756008)(38070700005)(122000001)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?MWgn3fzuf3d7TDW01eQljpYOfDr2xVXp3QSctQl5w5ongnj4H08HrWI1N?=
 =?iso-8859-15?Q?XoxLTjf7nQFx52C/ntp0QbyC+HXAuvKBotreY+sdRejIzojX222y6Vv4k?=
 =?iso-8859-15?Q?25oqhrexpVQ5VVHgyhC2MWnl8sCVu8O0jwLiA/dAAgbVTHdICzUxHdMeH?=
 =?iso-8859-15?Q?+KGWgy9Ii3A6Acum6WIoR8I9kYCjQOYGJcQXTRKP2OAwKgVuQhS58+gWt?=
 =?iso-8859-15?Q?951BjUCCenHYTU452OaJGhN4fwz/tHtLLj16ct2a+Nbxm+C2iM7m1Q4nk?=
 =?iso-8859-15?Q?t5siDs7ICQKH/5DM0HVxS4EseDjTf8JzbiS4B2NeSduQp1v5+8VgM77ck?=
 =?iso-8859-15?Q?jr10Z/15G0f7aYe7hNbtbifAfsvdzXpxWBEZ7hD8OPbZyNtqqQI9mUSCR?=
 =?iso-8859-15?Q?syEO3zRghqDpIPFHH+paE9no1+sIr+sjwtxw+gPe8ZqUC/iCKneViyk6Z?=
 =?iso-8859-15?Q?v2HwD1o+ZEKA9J65elsN3H8Ulji6eYdxuN45vhRkpPImpFX8ZGmn6vmnc?=
 =?iso-8859-15?Q?rBhpkDTebuz50CjmMey7F+yIU386RezBDNf2dejuDX/5NZXWeztkvNFdf?=
 =?iso-8859-15?Q?TPwmuAhJzRgtMgyXr92ki4OTC3QBkOuBqA4PLLp7vMp/Pc1KPdwIz0G8s?=
 =?iso-8859-15?Q?snf9+ThPI/Kf9bTmOqk0Z0jYOWqUOU6+1j/rxXNeCh3TD8lefIjJh8nBb?=
 =?iso-8859-15?Q?N83v/WLNnxLuaLNMyxoSKSREFSrbXDHrGJUnyqInaXDNMBtmuRpPQmmhI?=
 =?iso-8859-15?Q?TsnW3GglKuo1WlJx/mg5iziNMt2k9QOAbiJuP4wpkE59RXqvHTWLqaSNk?=
 =?iso-8859-15?Q?tR5ZBceixRTHMwH/eRw10/eOuKGeXsc7UVsf8qgSmXGYRsOevwKlopsys?=
 =?iso-8859-15?Q?RuD5m4up73ra5JoZOLYVOaFuFuugbkW50aD1jDLAieIZIN6xk+BzyhPfk?=
 =?iso-8859-15?Q?8hgU4AwmmEkhntRyco6PFY2/6ifA/Izehk/f1tyV4NIkoPdoGAxddtBVg?=
 =?iso-8859-15?Q?2jsATsDRMNQNftTYwwocKlBPuyKGRgUwdTFO3AwQEhBTwAVmD8O2i/SrG?=
 =?iso-8859-15?Q?UQSSZUzR/7KUNPdjcOXds6kc/q1z6wESDBUnn8UkMB/jAqgq+YGDIpDfr?=
 =?iso-8859-15?Q?W7T4l8oSnH5/lrp54zbdjKTe4bgMTAgM2HbEhXQFcdFM6rSrTrsAlT1YB?=
 =?iso-8859-15?Q?Jj5SCpcTcPsDRWb6afs3CHqFkb9RsCA16LKmaruZ+cAMAtjrE9p+RAlE6?=
 =?iso-8859-15?Q?PLSzZIfzy0WeuJJS2eNOORNHO9d4JPGf4LFOwJ4X6d8wNR0XxP5pJ61q2?=
 =?iso-8859-15?Q?zRhk7Y2bdCoeYX5AnOrmP99odz4uwJpmOlho9Rg1lKfrfYTExGpvaZSM0?=
 =?iso-8859-15?Q?j8tb674vmhpY0AKBuSq/jJ9E0fntU0IJSEnasGdnlyfqdVQma15qHRBmn?=
 =?iso-8859-15?Q?DXxmVaUjJqfccoQEHI1geiz3aibnIq49aFRT9HN4CKn9YRP+Pl4kuxzj7?=
 =?iso-8859-15?Q?iQJYiIW2eV8/2ANvkBJAL1lphnC00bSyTMM+T9FM8lQBLf33HHSEUG3Mp?=
 =?iso-8859-15?Q?HillPL4cP/IMeeQLp0XbgrWh7EzvZiI7i7ZlYu6oBoks/ClVjT/Cldfsb?=
 =?iso-8859-15?Q?50nO2eEolHD4ZcBELIuAJ3NXtvlE7x+BHjPmxmvB/uzAWrt5to+uxeXtW?=
 =?iso-8859-15?Q?mpWKLdXyohNXidO+2crFNnqMPQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8789521f-86ab-4a35-9c5e-08dab2ab94b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 14:58:43.0009 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8K9P5DC1TwLO+VDX5rpPgW9TY9uDKHb+iO1zIFJfiF/tGkOsGGw7LCQcp+T2sC01UhhJeeGC2ircc++sQr7nwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6981
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9095673A1A082F47993F86E5644A0342@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> device-mapper is not able to change the queue_mode on a table reload.
> Make sure that when multipath sets up the map, both on regular
> reloads
> and reconfigures, it keeps the queue_mode the same.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Some remarks below.

> ---
> =A0libmultipath/configure.c=A0=A0 |=A0 4 +++
> =A0libmultipath/dmparser.c=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/propsel.c=A0=A0=A0=A0 | 55
> ++++++++++++++++++++++++++++++++++++++
> =A0libmultipath/structs.h=A0=A0=A0=A0 |=A0 7 +++++
> =A0multipath/multipath.conf.5 |=A0 7 +++--
> =A05 files changed, 73 insertions(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 8af7cd79..41641e30 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -1075,6 +1075,7 @@ int coalesce_paths (struct vectors *vecs,
> vector mpvec, char *refwwid,
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf =3D NULL;
> =A0=A0=A0=A0=A0=A0=A0=A0int allow_queueing;
> =A0=A0=A0=A0=A0=A0=A0=A0struct bitfield *size_mismatch_seen;
> +=A0=A0=A0=A0=A0=A0=A0struct multipath * cmpp;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/* ignore refwwid if it's empty */
> =A0=A0=A0=A0=A0=A0=A0=A0if (refwwid && !strlen(refwwid))
> @@ -1184,6 +1185,9 @@ int coalesce_paths (struct vectors *vecs,
> vector mpvec, char *refwwid,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0verify_paths(mpp);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmpp =3D find_mp_by_wwid(cu=
rmp, mpp->wwid);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (cmpp)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->queue_mode =3D cmpp->queue_mode;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (setup_map(mpp, &param=
s, vecs)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
emove_map(mpp, vecs->pathvec, NULL);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 50d13c08..3b37a926 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -151,6 +151,8 @@ int disassemble_map(const struct _vector
> *pathvec,
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(word);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0mpp->queue_mode =3D strstr(mpp->features, "queue_mo=
de bio") ?
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 QUEUE_MODE_BIO : QUEUE_MODE_RQ;

Nitpick: You have spent effort to make multipath-tools support any
whitepace characters in the previous patches, but here you don't. I can
see that disassemble_map() generally assumes space characters as word
delimiters, but at least I see some inconsistency here.

Do you intend to generalize the whitespace handling in
disassemble_map(), too? Or am I overlooking something?

> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * hwhandler
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 98e3aad1..d4f19897 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -26,6 +26,7 @@
> =A0#include "strbuf.h"
> =A0#include <inttypes.h>
> =A0#include <libudev.h>
> +#include <ctype.h>
> =A0
> =A0pgpolicyfn *pgpolicies[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0NULL,
> @@ -413,6 +414,59 @@ void reconcile_features_with_options(const char
> *id, char **features, int* no_pa
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0}
> =A0
> +static void reconcile_features_with_queue_mode(struct multipath *mp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char *space =3D NULL, *val =3D NULL, *mode_str =3D =
NULL, *feat;
> +=A0=A0=A0=A0=A0=A0=A0int features_mode =3D QUEUE_MODE_UNDEF;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!mp->features)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &space);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &val);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &mode_str);

I was wondering why we need pthread_cleanup() complexity here, seeing
no cancellation points in this function. I eventually realized that
condlog()->dlog()->log_safe()->pthread_mutex_lock() is a cancellation
point. I suppose we need to clean that up some time.


> +
> +=A0=A0=A0=A0=A0=A0=A0if (!(feat =3D strstr(mp->features, "queue_mode")) =
||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 feat =3D=3D mp->features || !isspace(*(fe=
at - 1)) ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sscanf(feat, "queue_mode%m[ \f\n\r\t\v]%m=
s", &space,
> &val) !=3D 2)

Nit: Given that mp->features comes from the multipath.conf, I'm pretty
sure that it can't contain \n or \r as whitespace characters
(read_line() would remove them()). Not sure about \f and \v; guess they
are allowed but I wouldn't swear that they can be used in
multipath.conf without causing trouble elsewhere.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto sync_mode;
> +=A0=A0=A0=A0=A0=A0=A0if (asprintf(&mode_str, "queue_mode%s%s", space, va=
l) < 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "failed to alloc=
ate space for queue_mode
> feature string");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mode_str =3D NULL; /* value=
 undefined on failure */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto exit;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!strcmp(val, "rq") || !strcmp(val, "mq"))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0features_mode =3D QUEUE_MOD=
E_RQ;
> +=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(val, "bio"))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0features_mode =3D QUEUE_MOD=
E_BIO;
> +=A0=A0=A0=A0=A0=A0=A0if (features_mode =3D=3D QUEUE_MODE_UNDEF) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: ignoring in=
valid feature '%s'",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp-=
>alias, mode_str);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto sync_mode;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0if (mp->queue_mode =3D=3D QUEUE_MODE_UNDEF)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->queue_mode =3D features=
_mode;
> +=A0=A0=A0=A0=A0=A0=A0if (mp->queue_mode =3D=3D features_mode)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto exit;
> +
> +=A0=A0=A0=A0=A0=A0=A0condlog(2,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"%s: ignoring feature '%s' =
because queue_mode is set
> to '%s'",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->alias, mode_str,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(mp->queue_mode =3D=3D QUEU=
E_MODE_RQ)? "rq" : "bio");
> +
> +sync_mode:
> +=A0=A0=A0=A0=A0=A0=A0if (mode_str)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0remove_feature(&mp->feature=
s, mode_str);
> +=A0=A0=A0=A0=A0=A0=A0if (mp->queue_mode =3D=3D QUEUE_MODE_BIO)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0add_feature(&mp->features, =
"queue_mode bio");
> +exit:
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +}
> +
> =A0int select_features(struct config *conf, struct multipath *mp)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> @@ -428,6 +482,7 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0reconcile_features_with_options(mp->alias, &mp->f=
eatures,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&mp->no_path_retry,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&mp->retain_hwhandler);
> +=A0=A0=A0=A0=A0=A0=A0reconcile_features_with_queue_mode(mp);
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: features =3D \"%s\" %s", mp->alia=
s, mp-
> >features, origin);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 5a713d46..129bdf0e 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -170,6 +170,12 @@ enum max_sectors_kb_states {
> =A0=A0=A0=A0=A0=A0=A0=A0MAX_SECTORS_KB_MIN =3D 4,=A0 /* can't be smaller =
than page size
> */
> =A0};
> =A0
> +enum queue_mode_states {
> +=A0=A0=A0=A0=A0=A0=A0QUEUE_MODE_UNDEF =3D 0,
> +=A0=A0=A0=A0=A0=A0=A0QUEUE_MODE_BIO,
> +=A0=A0=A0=A0=A0=A0=A0QUEUE_MODE_RQ,
> +};
> +
> =A0enum scsi_protocol {
> =A0=A0=A0=A0=A0=A0=A0=A0SCSI_PROTOCOL_FCP =3D 0,=A0=A0/* Fibre Channel */
> =A0=A0=A0=A0=A0=A0=A0=A0SCSI_PROTOCOL_SPI =3D 1,=A0=A0/* parallel SCSI */
> @@ -396,6 +402,7 @@ struct multipath {
> =A0=A0=A0=A0=A0=A0=A0=A0int needs_paths_uevent;
> =A0=A0=A0=A0=A0=A0=A0=A0int ghost_delay;
> =A0=A0=A0=A0=A0=A0=A0=A0int ghost_delay_tick;
> +=A0=A0=A0=A0=A0=A0=A0int queue_mode;
> =A0=A0=A0=A0=A0=A0=A0=A0uid_t uid;
> =A0=A0=A0=A0=A0=A0=A0=A0gid_t gid;
> =A0=A0=A0=A0=A0=A0=A0=A0mode_t mode;
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index e098d555..46a4126c 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -459,8 +459,11 @@ precedence. See KNOWN ISSUES.
> =A0<mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR, which corresponds to
> =A0bio-based, request-based, and block-multiqueue (blk-mq) request-
> based,
> =A0respectively.
> -The default depends on the kernel parameter \fBdm_mod.use_blk_mq\fR.
> It is
> -\fImq\fR if the latter is set, and \fIrq\fR otherwise.
> +Before kernel 4.20 The default depends on the kernel parameter
> +\fBdm_mod.use_blk_mq\fR. It is \fImq\fR if the latter is set, and
> \fIrq\fR
> +otherwise. Since kernel 4.20, \fIrq\fR and \fImq\fR both correspond
> to
> +block-multiqueue. Once a multipath device has been created, its
> queue_mode
> +cannot be changed.
> =A0.TP
> =A0The default is: \fB<unset>\fR
> =A0.RE

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

