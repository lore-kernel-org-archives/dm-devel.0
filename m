Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A73C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 11:38:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EA74D613DF
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 11:38:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA74D613DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-59qHFfwxNPCvN9syUiBEbQ-1; Wed, 12 May 2021 07:38:35 -0400
X-MC-Unique: 59qHFfwxNPCvN9syUiBEbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3F3E801107;
	Wed, 12 May 2021 11:38:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EBDB6267D;
	Wed, 12 May 2021 11:38:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8B43A1800BB0;
	Wed, 12 May 2021 11:38:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CBcHeH013502 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 07:38:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 381B9106255; Wed, 12 May 2021 11:38:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3210910483F
	for <dm-devel@redhat.com>; Wed, 12 May 2021 11:38:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88B5280D0E0
	for <dm-devel@redhat.com>; Wed, 12 May 2021 11:38:14 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-539-2rg2I28NMTW9WhcKHPTi0Q-1;
	Wed, 12 May 2021 07:38:12 -0400
X-MC-Unique: 2rg2I28NMTW9WhcKHPTi0Q-1
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur03lp2054.outbound.protection.outlook.com [104.47.8.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-22-bxckxaXAN5iHz9I7Xxgv9w-1; Wed, 12 May 2021 13:38:10 +0200
X-MC-Unique: bxckxaXAN5iHz9I7Xxgv9w-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7114.eurprd04.prod.outlook.com (2603:10a6:10:fe::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 12 May 2021 11:38:09 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Wed, 12 May 2021 11:38:08 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/5] multipathd: make ev_remove_path return success on
	path removal
Thread-Index: AQHXRrx9QRn2HTqim0uQGVS/yH6it6rfuRYA
Date: Wed, 12 May 2021 11:38:08 +0000
Message-ID: <66c4ca02bb90a7a4c18819082d2ec554ddc56205.camel@suse.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620775324-23984-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94b131a7-a1f1-4f60-c0d0-08d9153a6a89
x-ms-traffictypediagnostic: DB8PR04MB7114:
x-microsoft-antispam-prvs: <DB8PR04MB71142B5DBE69BFE7E332A039FC529@DB8PR04MB7114.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zd7sH9NdXU8UgxV2dU6sxPgctQ5vqSAZ2HNsCTCBiI3awhkRWq2gIur6IXKMqwRTmQsta6rKX4lZ4d+GZ01wEXP3mnudl1ZCRY5NZ07Q60kt51RI+3k/RG/Fxbc96XZgwFuTl92TUdAm+c0sUTiclUvqQTtHKUrwJaR6akYVXRi5Tw8tOQsbqiyA9Mxu0lBkCAN+l7CooOCxEfSc03ixMU0xGyCTSpnC2O1iaRc3HHhSeN293EkqmvPBEOQ2XtHu1/jHZQialofCUTD7I/WrLSskFRtGCzs+VoUQFdKedqZEpU38lnCtYSCPIMrKut6TdHRebFRdPAmD54gOrzaW2YybpqqVk55kEvvijxFsy7/XlbWBI4C2LTjn9c3NMn396i8xvutOUAXWgRp94AJ2wXe/k6ibB5QbpOpiLai9bxqk8drTDQqeHZErHCIFtO9cTrqSkDceb2zn8vVK61J78CBa29XaDKK4YR/4njPJ35DaAw+sPOe0e3atAQsoxPGn95QzuJAklUY9V3ybv69h/AqRNSBzHE1PWuwuVfbE7+JrhwC0qEceVPfl+oojousC4rsUo2OxUx7Ob34efTplUz74VH1GmLAQHM8bT8kl21zutRfH2kjnijT6E4z9ilVRvUkKefB8BoIjYRBTs9EIYA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(366004)(39860400002)(376002)(136003)(396003)(8936002)(8676002)(6506007)(83380400001)(86362001)(2906002)(71200400001)(26005)(122000001)(186003)(66946007)(66446008)(44832011)(2616005)(478600001)(38100700002)(91956017)(66476007)(36756003)(5660300002)(6512007)(66556008)(76116006)(110136005)(6486002)(316002)(64756008)(4326008)(60764002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?i4N59gy5m1wHFxTqlfi/av5PeenOG3nADZjZtDMcWrK/1Xx8ghmn7ooTT?=
	=?iso-8859-15?Q?qB8H2qp9412sVaiOEdzW2Pr5DaHXQVP1xOlNNPJ4tuuZag1XRYXz7zwdY?=
	=?iso-8859-15?Q?cACZzH9cYp3O/cZ4VJa0Ln0pSTq1yvdl0gQnmyzFNWOiVXNZ/0yXuqAPF?=
	=?iso-8859-15?Q?NXRrJJ5usBs7DotocZFIosUVJCSNl+FpOtyv9ReL4joiW0f1hEdBbPm86?=
	=?iso-8859-15?Q?Be9jR6uwT3ZIM6bU6z3rbJitGQxbDpI7Gjyv09wOGBa19NF53SvXAkXM/?=
	=?iso-8859-15?Q?UtWP1t1O6Xa/uIGzRxkXvK6DsDFa140fdOcEQ0/VYdHIqlbqMM/rT81N/?=
	=?iso-8859-15?Q?oFT2dYHVLeFMrObvyWGHHkNYuSev0yc9u5zxTkwIQPatjdpAw22/V1a55?=
	=?iso-8859-15?Q?cFW+5RGCVfsBUEOyRN9PNzw8nn1l+k1m7EhoZ8p0eTqly3lTIRlxCGREu?=
	=?iso-8859-15?Q?PVfhJ0NHWt5qGdK6qSyHR6JUxCYDe7MwW7r5jieyb4Ju3i3qMVMHzO6Mx?=
	=?iso-8859-15?Q?yIZIsdRn/MYIt02eagjonObpcT/zbnn0BMxkaIhZcpXWO4/YnioPEfiSt?=
	=?iso-8859-15?Q?H+Ydw4Ue4T30C/FBOTWNSYggFslzvRNrvBlaN1f8unSYpzSFP3/AcvvQZ?=
	=?iso-8859-15?Q?jqWW03abrBrYtgIkK3XuZq77KsHuyAISbJwyANSavuBgVeJYo1KG/a9wZ?=
	=?iso-8859-15?Q?78RbPgzAxsly9/mmWbrpsYRdl4wCfEIHQUoTlXY7A/OeuY5S4vkW+t+22?=
	=?iso-8859-15?Q?DBGqgaVmnO1GM3cJsI8aaPx4vPcZke2by6JTz7+ZOSGSbp7C5fgSc3iWl?=
	=?iso-8859-15?Q?wD+X5b/U+CiydxPPmCaW1dcBTrC0we6g29HOOkVaLFVAcriEa/MpxjeIc?=
	=?iso-8859-15?Q?JVWNyev/OJNuzhaAKhkn1M7lnuHTqAr1Q/yOk0h3xCOt4hLsJHmb42Sk6?=
	=?iso-8859-15?Q?5G/iY1vSfyIstcVPwPYjfK6vrMWp67TIuXEiUov3Rs3yZ+I6/PavWQtag?=
	=?iso-8859-15?Q?uWu+hfZk4LQB/ha3JyqSnICS9vT71S68Tx/voCPwVuCUZEg/TeNaeoLIK?=
	=?iso-8859-15?Q?auEcll6SILl/Co34OtnEu0II9vgJ9d9BBn6L38rCH5FYmgQ87iyTziV5D?=
	=?iso-8859-15?Q?VtpGctc9obK8ihhZI/4q5cll0L/88JJHQEIBrACD8JA6/r3XEbNXwxhOn?=
	=?iso-8859-15?Q?1K/DJUPtB8RqKOqZPCc8JXYhONafjWWcHpSD88uYHzkkAYkkY7QGf1iXa?=
	=?iso-8859-15?Q?5oKq8PSvMr8x9XWvRr3HhCjXIme9XYvh2ZxBp834RdxFy+yJ60APAZckm?=
	=?iso-8859-15?Q?VPCzt6XHkLpfAp0fEBgPMifl0t1vFR8dU82QpXj0vfYfJyXbEdmDI+vPV?=
	=?iso-8859-15?Q?qyGM+kaCAfSpun4xB3h270nte0b1hfMRn?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b131a7-a1f1-4f60-c0d0-08d9153a6a89
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 11:38:08.8455 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CQpuNfyy20/Y9Cuxtlw72/xfmxSOzvo4wursy5B4OMXg7Y5UXxjwo/54cXUKMG+IHUyq6pKgd8BdGwS6ousMHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7114
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14CBcHeH013502
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/5] multipathd: make ev_remove_path return
 success on path removal
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
Content-ID: <361CA2F3ADEBCE45AE6D9F85A580D15C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> When ev_remove_path() returns success, callers assume that the path
> (and
> possibly the map) has been removed.=A0 When ev_remove_path() returns
> failure, callers assume that the path has not been removed. However,
> the
> path could be removed on both success or failure. This could cause
> callers to dereference the path after it was removed. Change
> ev_remove_path() to return success whenever the path is removed, even
> if
> the map was removed due to a failure when trying to reload it. Found by
> coverity.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This looks ok, but I'd like to discuss it in some more depth.

We need to clarify the meaning of the return code of ev_remove_path().
We guarantee that, when ev_remove_path() returns, either the path is
removed from internal data structures and kernel maps, or INIT_REMOVED
is set. We can't guarantee whether the path

 a) is not referenced any more by any kernel map,
 b) was actually removed from pathvec and other data structures in
multipathd.

We have to agree on whether it means a) or b) if we can't make these
two cases equivalent. Assuming multipathd has correct information about
the kernel mappings, the only difference between a) and b) is the
unlikely failure in setup_multipath(), where a) is true and b) is not
(because sync_map_state() won't be called).=A0Your patch assumes the
semantics of a), which is correct AFAICS, but should be more clearly
documented.

Actually, I think we can fix the discrepancy between a) and b) - if
domap() was successful, we should be able to orphan the path, even if
update_multipath_strings() failed for some reason.
=20
IMO we should consequently change the retval for the cases where
ev_remove_path() returns without deleting the path for a non-"failure"
case (wait_for_udev and !need_do_map).

Thoughts? Whatever we decide wrt the semantics of the return code, we
should document it clearly in comments at the function header.

Here's a quick review of callers:

 - cli_add_path(): AFAICS this needs b) semantics. We shouldn't set up
a new path unless it had been successfully removed internally.
 - cli_del_path(): needs a) semantics.
 - handle_path_wwid_change(): needs a).
 - uev_add_path(): needs a).
 - uev_remove_path(): the return code of ev_remove_path doesn't matter
much here. This is the only caller that sets need_do_map =3D false.
 - uev_update_path(): we currently don't look at the return code.
uev_add_path() will make another attempt at removing the path if
necessary.

Regards
Martin

P.S.: The remaining failure cases in ev_remove_path() are the failures
in update_mpp_paths() and setup_map(). The former can only fail with
ENOMEM, afaics. The latter, likewise, or if the map is fundamentally
misconfigured (which to me means that a previous call to setup_map()
would have failed as well). I'm wondering why we remove the entire map
in these failure cases. This goes back all the way to 45eb316=A0
("[multipathd] DM configuration final cut") from 2005. It's true that
both failures are pretty much fatal, but why is removing the map the
answer here?

However, this goes beyond the purpose of your patch. *If* we remove the
map, returning 0 is correct for either a) or b).

P.S. 2: I wonder if the logic in uev_update_path() is correct. Rather
than calling uev_add_path() after rescan_path() directly, I think we
should rather wait for another uevent (and possibly trigger another
"add" event, I don't think "rescan" automatically generates one).



> ---
> =A0multipathd/main.c | 6 ++++--
> =A01 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6090434c..4bdf14bd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1284,7 +1284,7 @@ ev_remove_path (struct path *pp, struct vectors *
> vecs, int need_do_map)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trlcpy(devt, pp->dev_t, sizeof(devt));
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (setup_multipath(vecs, mpp))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* Successful map reload without this path:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* sync_map_state() will free it.
> @@ -1304,8 +1304,10 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0return retval;
> =A0
> =A0fail:
> +=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: error removing path. removing map %=
s", pp->dev,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0remove_map_and_stop_waiter(mpp, vecs);
> -=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> =A0static int


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

