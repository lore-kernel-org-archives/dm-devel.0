Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7415CC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 09:11:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF847611CA
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 09:11:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF847611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-XpTP9E51MhepzSjrmGWigQ-1; Wed, 12 May 2021 05:11:22 -0400
X-MC-Unique: XpTP9E51MhepzSjrmGWigQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7A67101371D;
	Wed, 12 May 2021 09:11:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 118C761094;
	Wed, 12 May 2021 09:11:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86519998E;
	Wed, 12 May 2021 09:11:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14C9BCuG001203 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 05:11:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 47FF920B665C; Wed, 12 May 2021 09:11:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42AD220B6655
	for <dm-devel@redhat.com>; Wed, 12 May 2021 09:11:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 046AB858F0D
	for <dm-devel@redhat.com>; Wed, 12 May 2021 09:11:09 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-525-P-o0BbbLPNq2GbLNnl9dCQ-1;
	Wed, 12 May 2021 05:11:06 -0400
X-MC-Unique: P-o0BbbLPNq2GbLNnl9dCQ-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2055.outbound.protection.outlook.com [104.47.1.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-27-dQ7JdlS3NeaKMRSuSJ4tzg-1; Wed, 12 May 2021 11:11:04 +0200
X-MC-Unique: dQ7JdlS3NeaKMRSuSJ4tzg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7097.eurprd04.prod.outlook.com (2603:10a6:10:12a::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 12 May 2021 09:11:01 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Wed, 12 May 2021 09:11:01 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/5] multipathd: don't fail to remove path once the map
	is removed
Thread-Index: AQHXRrx8yIFdDiNhekK09KxwHtsUaarfj/uA
Date: Wed, 12 May 2021 09:11:01 +0000
Message-ID: <27a2802df2338186af82df84a027bc35f756ad00.camel@suse.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620775324-23984-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: caa68378-e8b5-4dfa-87ee-08d91525dd31
x-ms-traffictypediagnostic: DB8PR04MB7097:
x-microsoft-antispam-prvs: <DB8PR04MB70975B85FBABDCA31D2F27ABFC529@DB8PR04MB7097.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /0iMjliCIoEla1vDD5P+4UbnRGaMma7siCgqcMIdbHWzMxrN7dr8+WcI2nHPSyIybHwF51abevCOujQgPkKGbZ3kPlpBjm3xQRg0kidf5nFQHMCUYdl/XaHRs4+aokMvSG/aLB3b5RGsFWXjvAQkjd1newoSNLfBg7+89QOIk3c+sQn624vmlC56eP2XfWKT2xRlP+f/xPtl4VqBO3nC2icCll+/wfBHvr8gQrSkqjKZPwMHdr3WgRUcuhAXFKpeQ4kiN3z7nd4+4GCFuAWQPqoBKZZit3+qKXSaic60GElbNlIw97dru97HqmhylitfgDlDtbqXxkpRYGGk5v64HLpGsLrlZOPfRpFpKa7poVxtRu5qSG0/Z/oLVGYPmoNajhieq+ZRCYkxzK4tqNgHk3O081sX2EN6j3ww5X+4UiPSTdwfsObhPfbo/MwRYr4cBpNquMdq2lSzs4Xjsi0ZdVo8rTho16Ah1cH+X5cQ1Exa2BkXaQklPIJ5yNf7dBKDeHJZDeXeAaOm0nx1RcLFj+PoqGUIoQ9UxVAVsiKj75IBidtLJi++EeLrCRsb3UKAfNXRgKQFxrSVK/5ZMXLZ+I/IfENTyAHlL/dsLbVBls8=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(8936002)(6506007)(26005)(36756003)(38100700002)(122000001)(83380400001)(8676002)(71200400001)(6512007)(5660300002)(478600001)(110136005)(316002)(2906002)(66476007)(66946007)(66446008)(91956017)(64756008)(66556008)(76116006)(4326008)(44832011)(2616005)(186003)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?XDfgeMDxjbRFVMzvuhFhhdZv/znaJrNBuA5/xI4K3GjNerosmGTzmecVr?=
	=?iso-8859-15?Q?yneEvePBF+Me5yneML189kmV23AtipxuclxLV68qRhhGJg4Dpb+KtsUMY?=
	=?iso-8859-15?Q?uimjG94/wcx4CuAstqaAoaKQYr+sC+70QnbKbvDoPGjBSjYtKhHocH5Se?=
	=?iso-8859-15?Q?Kh7vosSSzcu9pVh2VvUiN0Nx84sWyDlHzPkaw16X2DjdGipfC6MbL3fg5?=
	=?iso-8859-15?Q?AO7zHit4KraGId9femko/tgtOWMtT9Nj3lIeD1FJH5DbSNYTmUM0yYp+h?=
	=?iso-8859-15?Q?IV76SVDjWhbia6xZzlLLd1rVvNxKHfZQXXfd3a484DB6r3uMOl0prh75s?=
	=?iso-8859-15?Q?BXNj5L42lZFY7Zcy1NG9pBlhq495dun+k6TCorV8fZ7H73wvg8tjqdrM1?=
	=?iso-8859-15?Q?yj0D48aRCQMpBXiVLziMhxWdG1ZJ5AQnyMk8TAap50RCfWf3Kog5L4mg4?=
	=?iso-8859-15?Q?0HbM6P4+QlJTytPyrkyNmTNKYjyCmod2RCUBpcK2Sv2+Mh/eJuZdXz7bC?=
	=?iso-8859-15?Q?oR6ztyikiiUV4pxPykDzFqhCH7Sg9VGyu1sbJ8aGEI4mjHwpGmLuMx/Ys?=
	=?iso-8859-15?Q?IK24Jpr4Y+CN6E8I6msIOc8QpQyDjdxt7Gb9Ade4FZVGJpuImlvJ/ospc?=
	=?iso-8859-15?Q?mtO/Fd13hQKiVGY0YYj1rzjghiBbaw/vSQ/kH3saq2yIbMFr0GPVyOlzm?=
	=?iso-8859-15?Q?8YHFjCIt8IbfHwXJGKGqivR2IMuU/XBBzblexrJWUIAMszkuQiMkSs0QT?=
	=?iso-8859-15?Q?5oIAdKulGqfKp8jm1nVDjOb07w/imeyymzBhPpW6Bufl8DfgNd0Vt22SK?=
	=?iso-8859-15?Q?DH1Ahz2e66raJ3mXx51yEIILAzjRVVeSlXaqxkCABchioLkjXWIFw49J3?=
	=?iso-8859-15?Q?4650wsvNStKM9Iajs+pr3BE4IZ2Gjn2dDqIkA1/q/3uIaoM2k+VG91ZDu?=
	=?iso-8859-15?Q?2YVY7R3+RLQ709/ZvIuECU2a+NDD03kqVpCBxhVcxhfAg0axteeVothoq?=
	=?iso-8859-15?Q?WI4qEhWvqNvmV4D0QT1LeQjn60r4qwefQMZ0k9ag6CJnv49FEPAY3IwdA?=
	=?iso-8859-15?Q?w2UV9ty60SeS6ldPmkvD0JnpZQ2yU1UPk1rFGr/IONbP9jIOOkfQyuEfk?=
	=?iso-8859-15?Q?XpYiCH1NMzeNBTRIMiM028c0hy1ROCk/Lw244CeT8wK+b2Cmo0+OisNyT?=
	=?iso-8859-15?Q?+hZ0v45Zt6pAsvOFcVznhm8UqfPypdKkI7KaNyQp8aXc9pY8rqVLGSa7y?=
	=?iso-8859-15?Q?elIIh2LqJf5pS9EfsBD7eoY6pk3ZGt9YeBOuvDbNbXFKMpBrugzFj5tuE?=
	=?iso-8859-15?Q?8gj5ypz1zNqYrBpneBK965XDiS7Hke1EHpSO3WO8no4qjEPNgGGHy/Ei6?=
	=?iso-8859-15?Q?yFYEMWGAxSE/btIoWCcHSpKDqX1T9+pXj?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa68378-e8b5-4dfa-87ee-08d91525dd31
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 09:11:01.7830 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: STTxDqVvFN/y51kL7m3Z+iguEK2mPiD2wXcVGvZ6iE1Eq8VG27/VhWVfIUVmssuethuiNdpAg1Jzm0+FfQIqwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7097
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14C9BCuG001203
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/5] multipathd: don't fail to remove path
 once the map is removed
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
Content-ID: <902C570FB17BAD4780F897BEBF5585E7@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> In ev_remove_path(), if update_mpp_paths() fails, we delete the
> entire
> map. However, since update_mpp_paths() happens before we call
> set_path_removed(), pp->initialized isn't set to INIT_REMOVED, so
> remove_map_and_stop_waiter() doesn't remove the path when in removes
> the
> map.=A0 But with the map removed, there's nothing to keep us from
> removing
> the path.
>=20
> Call set_path_removed() before update_mpp_paths() to avoid the odd
> case
> of ev_remove_path() removing the map but not the path.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/structs_vec.c |=A0 3 +--
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 13 ++++++++-----
> =A02 files changed, 9 insertions(+), 7 deletions(-)
>=20
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index d242c06b..432c0c63 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -45,8 +45,7 @@ int update_mpp_paths(struct multipath *mpp, vector
> pathvec)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * Avoid adding removed paths to the
> map again
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * when we reload it. Such paths may
> exist if
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * domap fails in ev_remove_path().
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * when we reload it.

I'd like to keep the remark about domap(). It's meant as a reminder for
us and future developers how this situation is most likely to come to
pass.

Other than that, ACK.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

