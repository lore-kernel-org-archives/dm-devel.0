Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501EBC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 10:11:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9A42523110
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 10:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A42523110
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-K_82H06LNoKkpTTYNW1Atw-1; Tue, 19 Jan 2021 05:11:17 -0500
X-MC-Unique: K_82H06LNoKkpTTYNW1Atw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16B77180F169;
	Tue, 19 Jan 2021 10:11:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D6891002D43;
	Tue, 19 Jan 2021 10:11:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EC8DD180954D;
	Tue, 19 Jan 2021 10:11:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10JAB84l019128 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 05:11:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 76BE31004059; Tue, 19 Jan 2021 10:11:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71E151004149
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 10:11:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD7AB187504B
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 10:11:05 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-507-NRPPhLmIOtSWwTXjERnTLg-1;
	Tue, 19 Jan 2021 05:11:03 -0500
X-MC-Unique: NRPPhLmIOtSWwTXjERnTLg-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-6-eWI-xXcFMFC_id-7egsdWg-1; Tue, 19 Jan 2021 11:11:00 +0100
X-MC-Unique: eWI-xXcFMFC_id-7egsdWg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2741.eurprd04.prod.outlook.com (2603:10a6:4:98::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10;
	Tue, 19 Jan 2021 10:10:57 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3763.014;
	Tue, 19 Jan 2021 10:10:57 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [dm-devel] [PATCH v3 0/1] Multipath io_err_stat fixes
Thread-Index: AQHW7h4GWk7pxs14PEu7fp/G0ab6A6ouuoQA
Date: Tue, 19 Jan 2021 10:10:56 +0000
Message-ID: <8c5b7af1ea04fad0919cf0c1ca5d01cd561f990b.camel@suse.com>
References: <1611031564-18663-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1611031564-18663-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b5baa50-69cc-49e2-b532-08d8bc6283ae
x-ms-traffictypediagnostic: DB6PR0402MB2741:
x-microsoft-antispam-prvs: <DB6PR0402MB2741C72CF1379DF945D89320FCA30@DB6PR0402MB2741.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /s/GRt53FtYR+sOXm4O/VSX8+HQVu5jHTtkxtTfRz1U0HAm8N3UAjslp5+9jcPLlkWqO23f8tardphAUsT2eNDCqsn0CiOgxj6535DNezB5zZAqQFLyrKHVPZHxOOU6qr2NFNIeCS++cduAteDnhAwBSFwRURdLDKH4NRnNZzzKxPodKaIO5SF0FDxieh85YM5YdmN0TKlKsXsD7YwASSz7yy0uOEUGkUPEHmC5jiM/aQ7HFLhRbx4HDjKASpJZ+z57nXkwM37WwlQp/rUCr3jb+O+oJGDYR5buXoOvESeAE4JM/eesjxmIib6VxUJGsqjn1bSp2aP+jQZWgTh0LuvulMB0Xu9m4ajQV5GrTMbt+4AzGmeBNdWHYStr9lDgx8Js2p1lQd4XYW5/+CTmWsQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(346002)(39860400002)(376002)(396003)(136003)(6512007)(83380400001)(91956017)(316002)(36756003)(110136005)(76116006)(8676002)(86362001)(71200400001)(2616005)(64756008)(478600001)(66446008)(66556008)(6486002)(66476007)(26005)(66574015)(8936002)(186003)(5660300002)(44832011)(4326008)(6506007)(66946007)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?8AzSNhS53s3nZzasEZ38iDndCxfXS7iASs6dvhaKMTR8KtJLi37hRvdgK?=
	=?iso-8859-15?Q?QMCXnbOhK8RqZ4yKhczrvE9kwGBVxG7XHl4UzyMGZQm72dHwyViJxfvJy?=
	=?iso-8859-15?Q?vpPFjYldjdgWhpH7ki5JtFKcEDacVDZ5lPCFo/htOVuhpYCul48H2MXta?=
	=?iso-8859-15?Q?FtPnmLylBsRncTQtgpDcPDIzBG99ZqtI40r7rUOHzk6G63U6MWt4z3fi5?=
	=?iso-8859-15?Q?l9vYRQ5R5d8edhqCB5bia8/22bNCoKpmcslnxEDBPC5ZdVJzDsM4O2haU?=
	=?iso-8859-15?Q?wq4ctriZleMH4dnOh5y+S7ZZlT9eDSyfhn+jFbV+W1e+iN8SfkoMlU7Wc?=
	=?iso-8859-15?Q?GE6Ynl1nVLTNIY0jEgjVX1/oZQXj7RVilqkH7tEoE8VDdyDNyCGkJVE3p?=
	=?iso-8859-15?Q?ZLYrPA1E0Du3Efm2Lce3SiVyrVLxP2FU4sie/JwoQYhEJibOnMdkb+WaW?=
	=?iso-8859-15?Q?pC7NKx+lxxEOs555zOrcW7V/mIwiocox52QTIYF3G7WCsEuvkkGDw88ec?=
	=?iso-8859-15?Q?dfajDFu5661UxElNwb3GQJ+FgRVS7VHINt+jbInzgd1z8/rnqUnTjKGQj?=
	=?iso-8859-15?Q?H++HXFnnzq5F/Pw1DmUztj//etjZfOa+wSTZ2aIEb70ywZjKL0sc3/TiK?=
	=?iso-8859-15?Q?+L0dvM2bWqMZTY5BKvHrkzIvxSL4UV0dHEjbEADS0B7k1CeY5iEV1JJLu?=
	=?iso-8859-15?Q?3RXjhlfatV1tGxbvCI/Xo3XP1FvLxy9+utgEvmud0lEL8oIuqAXH+KbwX?=
	=?iso-8859-15?Q?dTyqSuhXJnz4tD7hJyFbtQ3hf4MudGvmUGL09nNpER0auZ2kgsJBE8e0I?=
	=?iso-8859-15?Q?hyQ6KNxaq4q3L/q88bbTYSmAIKCXW1/Kp9OcgZrQGst1E6cmVfLigW8/k?=
	=?iso-8859-15?Q?Kud5sy5IIiq8qBTBAiI9UL9RWMU/8qBvKNnJu0Pcek0HWxvwhEBscQDJO?=
	=?iso-8859-15?Q?J0WkodTXMm6bLsybp62LOzSgpkkUz0QcVPnDamJtvcohj7vq6LA16x1RU?=
	=?iso-8859-15?Q?bTJrTN0QaNRP/Til7e3qc8sN5Amuijm1g/GzGVOdUzqhVguceF9k6ABwB?=
	=?iso-8859-15?Q?zVQs4kauyBELu54+vF4tZNUGGeN22rZdoSjbN6AZ/voqhxc8s/3WpUcOc?=
	=?iso-8859-15?Q?JrfbL?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b5baa50-69cc-49e2-b532-08d8bc6283ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 10:10:57.3857 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aDyvRL2T5bC9uBUxfG1iWu578txn9bOxk4nFMKAVp/7tCkuhupkAh2bzWi5SolfzJXI7YezTBVZlzvlWQ4eCng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2741
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10JAB84l019128
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 0/1] Multipath io_err_stat fixes
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <EDC43443C4E78B46BEC1B2035410D4E4@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-01-18 at 22:46 -0600, Benjamin Marzinski wrote:
> I found an ABBA deadlock in the io_err_stat marginal path code, and
> in
> the process of fixing it, noticed a potential crash on shutdown. This
> patchset addresses both of the issues.
>=20
> Changes from v2:
>=20
> 0001: This is patch 0006 from v2. It is exactly the same code. But
> the
> commit message now mentions that check_path() no longer switches
> paths
> from delayed to pending.
>=20
> Changes from v1:
>=20
> 0002: use cleanup_mutex instead of cleanup_unlock as suggested by
> Martin
>=20
> 0003: add pthread_testcancel and use cleanup_mutex instead of
> cleanup_unlock as suggested by Martin. Also, make tmp_pathvec a
> constant
> pointer, since it should always equal _pathvec.
>=20
> 0004-0006 are new patches to deal with io_err_stat issues from
> Martin's
> review
>=20
>=20
> Benjamin Marzinski (1):
> =A0 multipathd: cleanup logging for marginal paths
>=20
> =A0libmultipath/io_err_stat.c |=A0 7 +++----
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 25 ++++++++++++++------=
-----
> =A02 files changed, 17 insertions(+), 15 deletions(-)
>=20

Thanks a lot for adding the explanation.
For the whole 6-part series:

Reviewed-by: Martin Wilck <mwilck@suse.com>

Pushed to "queue" branch.

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

