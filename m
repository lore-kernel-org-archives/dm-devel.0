Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36EDC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:34:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 72D0D6124A
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 72D0D6124A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-3IULKyUWNBiOD2FbRgu19w-1; Thu, 04 Nov 2021 16:34:51 -0400
X-MC-Unique: 3IULKyUWNBiOD2FbRgu19w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFB4791270;
	Thu,  4 Nov 2021 20:34:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A82A7101E589;
	Thu,  4 Nov 2021 20:34:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5868E1806D04;
	Thu,  4 Nov 2021 20:34:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4KYjK5022164 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 16:34:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4A8AC2166B25; Thu,  4 Nov 2021 20:34:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43CE02166B26
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:34:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 817D6800B26
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:34:38 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-74-qKXFIaFqON6n_KFNPlIJ3A-1;
	Thu, 04 Nov 2021 16:34:36 -0400
X-MC-Unique: qKXFIaFqON6n_KFNPlIJ3A-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2054.outbound.protection.outlook.com [104.47.1.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-7-vlFBJpfgP5mHX9Ob4aHE4Q-1; Thu, 04 Nov 2021 21:34:34 +0100
X-MC-Unique: vlFBJpfgP5mHX9Ob4aHE4Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5228.eurprd04.prod.outlook.com (2603:10a6:10:1b::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10;
	Thu, 4 Nov 2021 20:34:33 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 20:34:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/8] libmultipath: make set_int take a range for valid
	values
Thread-Index: AQHXuu1qiBbr6TjMp0yEmQooqYZ1J6v0AOWA
Date: Thu, 4 Nov 2021 20:34:33 +0000
Message-ID: <5a3077f3cf5fd24e25fffd1690ca7afceec7ec46.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a7b14ca-8a69-4b4b-6e6a-08d99fd282f8
x-ms-traffictypediagnostic: DB7PR04MB5228:
x-microsoft-antispam-prvs: <DB7PR04MB52289FEF32EE7190BC0E2200FC8D9@DB7PR04MB5228.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zc7rpRdvK/Voug5o6Ep8Wc/r7mNLD+iHE2txtsrfjT6WId5cN/1nFABTwAYgjHBS2k9zEbY1bSiCqhMfDJ+3lr+PZ2xgAPHeuGjnsc7jo6pnKdTkgnzJT9+eLQEpydGlOi7GfpODxnuWB/aWMCfA3lu3gAMF7RRvm+eS0uOfHpAIWlnuS1FReeqFQkTDFklvxy21QXDGzHLP2pa3jwmNoZRU3fLoGA3MbV4g1Fz/Ul2SHRKjyvOMxWMM+78k9dMNcbX6VBlOfbmSFS76Y+SOjf/TQiWXXwgg2ZA62CKur4OzQsK6dW7CYvnbTv4hTtVacqlMGhDzT7zMpZj3sydL1iBKUDU5lJA8ODJiWQ3IaSj4VJNNZFxHgJHb0psGZDbxfuDngB6OI793PHhOcvr5Szjr+3oWdNlkejcYRTMstuV6TkTokU4osBydP62BWuSX4B7X0NXusSg6yiQgEQ1WZklM/WWEk7Lyfqni4q2PTVJWxpeALsY7YWqTOg/JeBsZ0SIdvAyQiY1mD8yyFE9CsS8RLsjshf6iJJ/KGpKwTxJGD9aAnJ9WfAd26azmypCA+81f4KdKa0vy5YV+3rmCD7B2/kBPUjsUKDcmEfHYzNkab3cwgDu3akLN+V31eGqm6N8ScK2Uv5+q/wned2+ANOwDgga3QxqXGdLLtAX0OTY956S7uiS3SeaV3PBm3ccQMYp6+mwN8x5BLvu1KWh6Ag==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(5660300002)(6506007)(6486002)(316002)(4326008)(83380400001)(508600001)(66556008)(66476007)(64756008)(66946007)(91956017)(76116006)(6512007)(66446008)(86362001)(8676002)(38100700002)(36756003)(8936002)(122000001)(26005)(2616005)(38070700005)(71200400001)(2906002)(186003)(44832011)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?BSEUbQBOIUzsgSt0qhjTLilvtVwODB6GY1oyhtCMB9Tc2724pA2Am++58?=
	=?iso-8859-15?Q?rsqOWhLv1peeEpjG5PcfkR6JLP7+Zn+3Ae7gfbXob7T+hu5qR1KBm+tIa?=
	=?iso-8859-15?Q?xltKUYLtgdz2ifCd6HYbhQi4Q3wEQvBbuNpoNWrt/v95nZQHaPpuVqWiH?=
	=?iso-8859-15?Q?kGgpB9r9lAt29/Gazg4ENPnLiTvVb8tm4uFObTSfBZh4lChzhFQ9QWBEP?=
	=?iso-8859-15?Q?zbYNG1hY6yBBhHM2ImtwAxjVGgvywVpoR19Su4x7o/qEBp6L6mPRtMZP3?=
	=?iso-8859-15?Q?sDZpZkacYNXFsUGh/QYDl5ZIPKuuOVqRYD0SKqYrm8VV6s2q/1taL3tz2?=
	=?iso-8859-15?Q?dMcjs96YRwHoirZT4YWXsUhOCzCDKLQtfNkmN4K16ThMC6KBuIkgecO+d?=
	=?iso-8859-15?Q?xKfW+ekCgxzWnRNYGuvU3az3N8b7zd4lghgoBhGILjSjpJntWeJouNLZz?=
	=?iso-8859-15?Q?+EGdAh1Qnf3YYHV6ejZNUooVnAsH7I/V2G1HFyQw58/Wd/ldJtbehtPAW?=
	=?iso-8859-15?Q?mkPa9Fa/PcxI2Xr4za+7p3uI4m3Did86jZm5DHgZEM8c0RcxRocbtQLGD?=
	=?iso-8859-15?Q?qTV4Y7EBeFiV8LNZUGjUSd6vKfKZh8nD+48E/uoPj1KCkEMbNpK5hKNeN?=
	=?iso-8859-15?Q?IloxAC5C9XdDpttmdyYCPhrtN5lc8+SB9Y9ozuBLM7dXMTq0/q1U5YnPk?=
	=?iso-8859-15?Q?+ma9FwpjZFibmef77c7Iej4629R5VGuN9QrLyFOPX77YlTtZPoXzT5/mw?=
	=?iso-8859-15?Q?UPV3b4M8bTaC82kGo9TBXcLQjVLnUYBKzgqJ1a+czLZCacPJAB42AweEj?=
	=?iso-8859-15?Q?U0Lh9eC9atPTtWfydJ2761/mcKI9dAJgm+dkcX0nFd+MDE1dXOFxDq8wA?=
	=?iso-8859-15?Q?cu26oxHeebcRqyvoF2dcoH5eH8YXs4LPrKM4hDsi98GLLvhiA2369kmlb?=
	=?iso-8859-15?Q?AcJ8K1ZhoVMYq48HufpLRoFMFxGW1CrKOcEGmqaSmFncXe9b2gTB1dYu/?=
	=?iso-8859-15?Q?x4XJj8qaGU894CK5V9SPK5WuYmf0vEy3DZebznPBFDXglus+QjmS9oRST?=
	=?iso-8859-15?Q?4iSPySvLJls7SnNavSbVjuiLBUIFz+pqQkPuWZDkgjGS2mnOVPNv93O9r?=
	=?iso-8859-15?Q?RqEbw7TPmPPLnShe0Z72MJGxHI5Q921tOZ4PFzufIEG87sZru6HWuEevD?=
	=?iso-8859-15?Q?h8xrUhJwsyFCWB5dNYI70ZtDBJ/soOz09CVawrp1P3WuVJ6b18YE4IFGp?=
	=?iso-8859-15?Q?M63lhqcFODPu2wnvuC7mljRRwhp4OP/DnIJ1ltKhfjHsCDv0xULoN/V1t?=
	=?iso-8859-15?Q?hgdYFSidHWBAYAObTNWbf+BQmsxxyxi+jNs0/xPqRcQhRxQy1AMuMEBiA?=
	=?iso-8859-15?Q?GD2Q6Sp+diGEpcVLmlXoeW0T0w5GjpLHiOP944b2496GXW60Nvy1M9gtT?=
	=?iso-8859-15?Q?vBs+Tj07QLJMGauhi/S3KSoBh3IbSEzQ3eJ5QZblzNwWxybj/gTTkPAp0?=
	=?iso-8859-15?Q?b8gId29+khtJT5SOTWpGZKcu4A9GOImqkGG6rzyznhepnmkpOcCzfvnLA?=
	=?iso-8859-15?Q?RCShEJ1W7XudD0tzj8so5nWBYR48iw/SGwBf3OqklDsQ1pUch0PvMTcjY?=
	=?iso-8859-15?Q?kBtYzb95wDWbHJB9eJzGq9QxuT1RP3XctZ0hdfRyUrqOQqvEuokhUXsmj?=
	=?iso-8859-15?Q?AfoKCjRm6bCXKinG6OPbcPE4GqpTxB14dWvCNzjgFdpiZfQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7b14ca-8a69-4b4b-6e6a-08d99fd282f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 20:34:33.8114 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +X+vjPu8WUo0ZTHEncS8JJFOjg+MMK5VvNWO8o+6hvScAilaorh+7+JTEFSBeKeZJl6oCLcwR3CDAzGG8gso9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5228
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4KYjK5022164
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/8] libmultipath: make set_int take a range
 for valid values
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
Content-ID: <615F82FF4C8C5C499C2BEFC551027493@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> If a value outside of the valid range is passed to set_int, it caps
> the
> value at appropriate limit, and issues a warning.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

One nitpick below.

It's a lot of code changes for just two cases where we have nontrivial
values for min and max. I guess for uint the count of nontrivial cases
was zero?

Yet it's an improvement, so I'm going to ack when the nit is fixed.

Martin



> ---
> =A0libmultipath/dict.c | 121 +++++++++++++++++++++++++++---------------
> --
> =A01 file changed, 75 insertions(+), 46 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index eb2c44c0..1758bd26 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> ...
> @@ -298,7 +347,7 @@ declare_def_snprint(checkint, print_int)
> =A0declare_def_handler(max_checkint, set_uint)
> =A0declare_def_snprint(max_checkint, print_int)
> =A0
> -declare_def_handler(verbosity, set_int)
> +declare_def_range_handler(verbosity, 0, 4)

You should use MAX_VERBOSITY here.


> =A0declare_def_snprint(verbosity, print_int)
> =A0
> =A0declare_def_handler(reassign_maps, set_yes_no)
> @@ -473,22 +522,22 @@ declare_ovr_snprint(checker_name, print_str)
> =A0declare_hw_handler(checker_name, set_str)
> =A0declare_hw_snprint(checker_name, print_str)
> =A0
> -declare_def_handler(minio, set_int)
> +declare_def_range_handler(minio, 0, INT_MAX)
> =A0declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
> -declare_ovr_handler(minio, set_int)
> +declare_ovr_range_handler(minio, 0, INT_MAX)
> =A0declare_ovr_snprint(minio, print_nonzero)
> -declare_hw_handler(minio, set_int)
> +declare_hw_range_handler(minio, 0, INT_MAX)
> =A0declare_hw_snprint(minio, print_nonzero)
> -declare_mp_handler(minio, set_int)
> +declare_mp_range_handler(minio, 0, INT_MAX)
> =A0declare_mp_snprint(minio, print_nonzero)
> =A0
> -declare_def_handler(minio_rq, set_int)
> +declare_def_range_handler(minio_rq, 0, INT_MAX)
> =A0declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
> -declare_ovr_handler(minio_rq, set_int)
> +declare_ovr_range_handler(minio_rq, 0, INT_MAX)
> =A0declare_ovr_snprint(minio_rq, print_nonzero)
> -declare_hw_handler(minio_rq, set_int)
> +declare_hw_range_handler(minio_rq, 0, INT_MAX)
> =A0declare_hw_snprint(minio_rq, print_nonzero)
> -declare_mp_handler(minio_rq, set_int)
> +declare_mp_range_handler(minio_rq, 0, INT_MAX)
> =A0declare_mp_snprint(minio_rq, print_nonzero)
> =A0
> =A0declare_def_handler(queue_without_daemon, set_yes_no)
> @@ -512,7 +561,7 @@ snprint_def_queue_without_daemon(struct config
> *conf, struct strbuf *buff,
> =A0=A0=A0=A0=A0=A0=A0=A0return append_strbuf_quoted(buff, qwd);
> =A0}
> =A0
> -declare_def_handler(checker_timeout, set_int)
> +declare_def_range_handler(checker_timeout, 0, INT_MAX)
> =A0declare_def_snprint(checker_timeout, print_nonzero)
> =A0
> =A0declare_def_handler(allow_usb_devices, set_yes_no)
> @@ -583,13 +632,13 @@ declare_hw_snprint(deferred_remove,
> print_yes_no_undef)
> =A0declare_mp_handler(deferred_remove, set_yes_no_undef)
> =A0declare_mp_snprint(deferred_remove, print_yes_no_undef)
> =A0
> -declare_def_handler(retrigger_tries, set_int)
> +declare_def_range_handler(retrigger_tries, 0, INT_MAX)
> =A0declare_def_snprint(retrigger_tries, print_int)
> =A0
> -declare_def_handler(retrigger_delay, set_int)
> +declare_def_range_handler(retrigger_delay, 0, INT_MAX)
> =A0declare_def_snprint(retrigger_delay, print_int)
> =A0
> -declare_def_handler(uev_wait_timeout, set_int)
> +declare_def_range_handler(uev_wait_timeout, 0, INT_MAX)
> =A0declare_def_snprint(uev_wait_timeout, print_int)
> =A0
> =A0declare_def_handler(strict_timing, set_yes_no)
> @@ -616,19 +665,19 @@ static int
> snprint_def_disable_changed_wwids(struct config *conf,
> =A0=A0=A0=A0=A0=A0=A0=A0return print_ignored(buff);
> =A0}
> =A0
> -declare_def_handler(remove_retries, set_int)
> +declare_def_range_handler(remove_retries, 0, INT_MAX)
> =A0declare_def_snprint(remove_retries, print_int)
> =A0
> -declare_def_handler(max_sectors_kb, set_int)
> +declare_def_range_handler(max_sectors_kb, 0, INT_MAX)
> =A0declare_def_snprint(max_sectors_kb, print_nonzero)
> -declare_ovr_handler(max_sectors_kb, set_int)
> +declare_ovr_range_handler(max_sectors_kb, 0, INT_MAX)
> =A0declare_ovr_snprint(max_sectors_kb, print_nonzero)
> -declare_hw_handler(max_sectors_kb, set_int)
> +declare_hw_range_handler(max_sectors_kb, 0, INT_MAX)
> =A0declare_hw_snprint(max_sectors_kb, print_nonzero)
> -declare_mp_handler(max_sectors_kb, set_int)
> +declare_mp_range_handler(max_sectors_kb, 0, INT_MAX)
> =A0declare_mp_snprint(max_sectors_kb, print_nonzero)
> =A0
> -declare_def_handler(find_multipaths_timeout, set_int)
> +declare_def_range_handler(find_multipaths_timeout, INT_MIN, INT_MAX)
> =A0declare_def_snprint_defint(find_multipaths_timeout, print_int,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 DEFAULT_FIND_MULTIPATHS_TIMEOUT)
> =A0
> @@ -1385,27 +1434,7 @@ declare_ovr_snprint(recheck_wwid,
> print_yes_no_undef)
> =A0declare_hw_handler(recheck_wwid, set_yes_no_undef)
> =A0declare_hw_snprint(recheck_wwid, print_yes_no_undef)
> =A0
> -
> -static int
> -def_uxsock_timeout_handler(struct config *conf, vector strvec, const
> char *file,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 int line_nr)
> -{
> -=A0=A0=A0=A0=A0=A0=A0unsigned int uxsock_timeout;
> -=A0=A0=A0=A0=A0=A0=A0char *buff;
> -
> -=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> -=A0=A0=A0=A0=A0=A0=A0if (!buff)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> -
> -=A0=A0=A0=A0=A0=A0=A0if (sscanf(buff, "%u", &uxsock_timeout) =3D=3D 1 &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uxsock_timeout > DEFAULT_REPLY_TIMEOUT)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->uxsock_timeout =3D ux=
sock_timeout;
> -=A0=A0=A0=A0=A0=A0=A0else
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->uxsock_timeout =3D DE=
FAULT_REPLY_TIMEOUT;
> -
> -=A0=A0=A0=A0=A0=A0=A0free(buff);
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> -}
> +declare_def_range_handler(uxsock_timeout, DEFAULT_REPLY_TIMEOUT,
> INT_MAX)
> =A0
> =A0static int
> =A0hw_vpd_vendor_handler(struct config *conf, vector strvec, const char
> *file,


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

