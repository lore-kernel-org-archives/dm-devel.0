Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9421BC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 17:02:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-IBRzvoXdMmeVLewlaU0KSg-1; Fri, 03 Dec 2021 12:02:46 -0500
X-MC-Unique: IBRzvoXdMmeVLewlaU0KSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE493100C661;
	Fri,  3 Dec 2021 17:02:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 976CA60843;
	Fri,  3 Dec 2021 17:02:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09A341809CB8;
	Fri,  3 Dec 2021 17:02:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B3H2Zok010175 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 12:02:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 643A1492CA5; Fri,  3 Dec 2021 17:02:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D4D5492CA3
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 17:02:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2346A80A0B4
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 17:02:35 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-221-FRqO2zUJN_GMV0tsQ-mNVA-1; Fri, 03 Dec 2021 12:02:33 -0500
X-MC-Unique: FRqO2zUJN_GMV0tsQ-mNVA-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2110.outbound.protection.outlook.com [104.47.17.110])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-39-5TdowxJpPD6BI2xtbo6eog-1; Fri, 03 Dec 2021 18:02:30 +0100
X-MC-Unique: 5TdowxJpPD6BI2xtbo6eog-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB6156.eurprd04.prod.outlook.com (2603:10a6:10:cd::13) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23;
	Fri, 3 Dec 2021 17:02:26 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%5]) with mapi id 15.20.4734.028;
	Fri, 3 Dec 2021 17:02:25 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>
Thread-Topic: [PATCH] multipathd: handle fpin events
Thread-Index: AQHX4cN3WHkLuxT/XU2rhrfCJFDyL6whC44A
Date: Fri, 3 Dec 2021 17:02:25 +0000
Message-ID: <465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
In-Reply-To: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1386e4b-e916-4e1c-d38f-08d9b67eae3e
x-ms-traffictypediagnostic: DBBPR04MB6156:
x-microsoft-antispam-prvs: <DBBPR04MB61564E9B135C4861D689BE4CFC6A9@DBBPR04MB6156.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: n5ml1hradQZKqOupdfazDa2HaZVxWM0ne9YwxGCsBtKExQtPLeE4qdtW66aZ5ytnAAUCVwa2Fp46ATR2Rv7k59jIpAgKnMtboyyWfLQWiu1QMdF/MjL/Rm96LShu4LvOztsV4Dzg4GhbjhTfF9Uh9lAJ96nSz+f+VarMBOWpIVXkc14fmixM4gDoeVzqNjDKv0k0UEDqOCttOol1htBYKtgOt2GEvs+nrqNk8vWna6i4rqelEQgcdFh6GeYjzRLDe/+j5GzRpw0S3c582ZennqR3z3d6+5G4w72gkZuodZyt9HJn5bxOv6d1EfsGi7oodOjR/GKBbdba4Yq+VF0A0DVE2x0J/l7Zg66egpSZ4zONydfdsa9YeGAVWC2hw4F3WwLluvG3snSwaHAWY1tGr8RgSC2Ag/yJmhdyLiW/1qsibZG5QwxS283UJ4KbDMaJJb4OH8zsc6A9cauaeyPRcduIojYqA9W8/VZ6wJb7/iMKuSfjFRFaw7dfF4Ndj9Ce+LKZQTStymuR1b1pyQlIO3igt4DPp1vGJlAnCbvoR1/oNo1VKKlGWWgcpruQvipY6c+j0vKvJ8l0iJGPd1XvgSoOvorYHXlOiW3LOn8Dpf/885PvAi14zRRsvS2G6h1NndE+epTGHZWH5GvAqMG6p/KfWoB3yJTvZSmSbXAd2QFxwANxYqYgbIcib+Zrq6bWruiMMcuFOu9qZJJPBT5Wig==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(44832011)(91956017)(36756003)(2906002)(5660300002)(4326008)(71200400001)(186003)(38070700005)(86362001)(76116006)(316002)(6486002)(64756008)(4001150100001)(66446008)(66476007)(54906003)(8936002)(8676002)(30864003)(110136005)(66946007)(66556008)(2616005)(38100700002)(6512007)(508600001)(26005)(122000001)(6506007)(83380400001)(559001)(579004);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?7TmXC+E7rZCp6JIpe5jdzmozTdR2KEPqQ0YVZLhWODntZMJcI4S4Vf9w7?=
	=?iso-8859-15?Q?i8gLRsFg1lN+Hk0iM7rrLhHppYP+ET7J2MkvuE+qVZ8bx8NYnBQU1dNc1?=
	=?iso-8859-15?Q?1pEigDKorMxvxZcv2oaoWN8T/jCU57TzYpsLUGm19aJMw3gfYSPece98o?=
	=?iso-8859-15?Q?Xumo4xRhMWWgYrUzi7NTh0pXuRh6nucyEJM81G0/X0UNndgA/GCssnvC3?=
	=?iso-8859-15?Q?aWvfocgOjT0MJnmLH8z87/IH/sOa/uAw2Rm5WiOmP6a6c028gQ/J3rKMs?=
	=?iso-8859-15?Q?Le2lwmaq38OdfTyJd8w9LnMyR83WY/gI66YE3DreMNNT0D4bT92rjNCyE?=
	=?iso-8859-15?Q?Y6cxgV66/iellkkEYI3NkcTB7lcwo8owV9nq5HtTfLTvABagdeylwufoh?=
	=?iso-8859-15?Q?+8y42YjgMnhX/B4SES4wA/wp80lgMHxprqKsHDVL+YETIJXdKOQjjO6XA?=
	=?iso-8859-15?Q?fiB1mWMKEn4qv7AvcpxHdfAcEbTmPf2QzMBh3YsY92TQ+FaXm/3mcIb5H?=
	=?iso-8859-15?Q?pxFmh12bYw38Ee7sKuXKFSohtucuNWj3rL51pXmZQrG3iLpP4ORkXF/3R?=
	=?iso-8859-15?Q?980R8Cz4fTndJwnubwEo03y+yaarXuTECrzIOavMI7MjXsou3AlRSNgL5?=
	=?iso-8859-15?Q?D1LY8D7GP8cTkcwLJMFky8BEfslnqkiGvPW2+p7ed/jk2bi0/CUTGftVT?=
	=?iso-8859-15?Q?GpbNitnves7CKQIXXJ7QRzsFn7dHVdZdWZNKQuzfiaDESz7p4vY+HoFad?=
	=?iso-8859-15?Q?E2urd1ELqZUWZ0c2wgwvn9hFEkQUqv2Jaqa9lAwDre4k8Gm/gA3/TspLP?=
	=?iso-8859-15?Q?bMFmv0JznSIv1uHSdcDzE0gn+qAggVLSZijPVF4qF0Zgqr+csiY2gnkZB?=
	=?iso-8859-15?Q?FFx3CeUXkbfs70zizNZlmuu4VEx43HResIvsXDo/ZfluKp1MnJ6shTaOH?=
	=?iso-8859-15?Q?vDaXpyOeDAKVtu7V7jZOkdHC1NEu76pkFgkhP4MwLw+jmaEV94Pr6hKcx?=
	=?iso-8859-15?Q?Q6T+LTd/s9kkNvYEDfYTa2lxt7cBBKS3Kb9wgIx83c1o5tuBZOpPfMITK?=
	=?iso-8859-15?Q?3yw0v/Ixb99P2+bJ60XfPHSrfGOpcYErl5fTPMPPThNHwp/W3Y3QwdKmb?=
	=?iso-8859-15?Q?+h8EIPfvaxFgYMNp+c4XQirIBdGXrYyHHHqDPCMtQGoAXH17qKblU15AR?=
	=?iso-8859-15?Q?TOCrcNvNcr4/UbBQlH+0/qadAIGYX1pP2qn4MGrAIFVlpSvYL4EqbUIdA?=
	=?iso-8859-15?Q?/JU+piX43mpapNgesQAF50WSqvB8HQF6ZuSsqj19ycWF9P8fYfephe1mz?=
	=?iso-8859-15?Q?zdi1Eq+sJqKC2j5ArqukT6TrDnWMHQdETjFqB0LJTHg8gwx9homN4ZZ82?=
	=?iso-8859-15?Q?ifd6YMMvj8frfrlu+yEzXklhJQgO4rwEK55iGpakfX8DWRJY/BI0SEt7i?=
	=?iso-8859-15?Q?jl/vCO02RjFfBa9zZBDgEDvVGgAx0ObP3VYYfbSCv2KvQcRKTO6ygA3Pb?=
	=?iso-8859-15?Q?PctmGu9uYs8pezwY94t22WiAj4a3R84EEY2xUmsCnu7eC6Uqi8w64G0YB?=
	=?iso-8859-15?Q?lOZdeH5R08DXTuPwhtNtLp1hfsQFWo+t6GdcfscWFQYIJ6LL57L/TvPsw?=
	=?iso-8859-15?Q?h0WADCN3MytnjEJ1mTzV77m2McqwuAmIWXzeLgzP5Asa0UIZ5gX9yjylR?=
	=?iso-8859-15?Q?6YOiSi2oySDaOEQW+IcFpXnspBMREJ1sLKjEbT8jqZ47LmQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1386e4b-e916-4e1c-d38f-08d9b67eae3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 17:02:25.3504 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oniqbihGTxejug9RFEyTsCpMWsHCWLIA5Wkgn88FrsdsHHxDf9t8gmSjnlBuzYoOx75q5bQ+fIKArl7aMwrwtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6156
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B3H2Zok010175
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: handle fpin events
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
Content-ID: <F982FDBD3106A246839A51188858B71F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello Muneendra,

On Wed, 2021-11-24 at 15:21 -0800, Muneendra Kumar wrote:
> This patch incorporates the functionality to handle
> FPIN ELS events present as part of FCTransport daemon
> (available in EPEL8) into the multipathd. This helps us to
> reduce the response time to react and take the necessary actions
> on receiving the FPIN events.
>=20
> This patch currently support FPIN-Li Events.
>=20
> It adds a new thread to listen for ELS frames from driver and on
> receiving the frame payload, push the payload to a list and notify the
> fpin_els_li_consumer thread to process it.Once consumer thread is
> notified, it returns to listen for more ELS frames from driver.
>=20
> The consumer thread process the ELS frames and moves the devices paths
> which are affected due to link integrity to marginal path groups.
> This also sets the associated portstate to marginal.
> The paths which are set to marginal path group will be unset
> on receiving the RSCN events
>=20
> Signed-off-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks! Please find my notes below.
First of all, you'll have to rebase to the current master branch.=A0
Sorry about that.

> ---
> =A0Makefile.inc=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 13 +
> =A0libmpathpersist/libmpathpersist.version |=A0 12 +-
> =A0libmultipath/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 4 +
> =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 3 +
> =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 1 +
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 31 ++
> =A0libmultipath/libmultipath.version=A0=A0=A0=A0=A0=A0 |=A0=A0 5 +-
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 47 +-
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
 20 +
> =A0multipathd/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 10 +
> =A0multipathd/fpin.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 23 +
> =A0multipathd/fpin_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 56=
6 ++++++++++++++++++++++++
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 38 +-
> =A013 files changed, 756 insertions(+), 17 deletions(-)
> =A0create mode 100644 multipathd/fpin.h
> =A0create mode 100644 multipathd/fpin_handlers.c
>=20
> diff --git a/Makefile.inc b/Makefile.inc
> index d0ec9b44..1241c39b 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -137,6 +137,19 @@ check_file =3D $(shell \
> =A0=A0=A0=A0=A0=A0=A0=A0echo "$$found" \
> =A0=A0=A0=A0=A0=A0=A0=A0)
> =A0
> +# Check whether a file contains a variable with name $1 in header file
> $2
> +check_var =3D $(shell \
> +=A0=A0=A0=A0=A0=A0=A0if grep -Eq "(^|[[:blank:]])$1([[:blank:]]|=3D|$$)"=
 "$2"; then \
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 found=3D1; \
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 status=3D"yes"; \
> +=A0=A0=A0=A0=A0=A0=A0 else \
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 found=3D0; \
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 status=3D"no"; \
> +=A0=A0=A0=A0=A0=A0=A0 fi; \
> +=A0=A0=A0=A0=A0=A0=A0 echo 1>&2 "Checking for ..=A0 $1 in $2 ... $$statu=
s"; \
> +=A0=A0=A0=A0=A0=A0=A0 echo "$$found" \
> +=A0=A0=A0=A0=A0=A0=A0 )
> +
> =A0%.o:=A0=A0=A0%.c
> =A0=A0=A0=A0=A0=A0=A0=A0@echo building $@ because of $?
> =A0=A0=A0=A0=A0=A0=A0=A0$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
> diff --git a/libmpathpersist/libmpathpersist.version
> b/libmpathpersist/libmpathpersist.version
> index e0748138..fa312f6b 100644
> --- a/libmpathpersist/libmpathpersist.version
> +++ b/libmpathpersist/libmpathpersist.version
> @@ -10,7 +10,7 @@
> =A0 *
> =A0 * See libmultipath.version for general policy about version numbers.
> =A0 */
> -LIBMPATHPERSIST_1.0.0 {
> +LIBMPATHPERSIST_2.0.0 {
> =A0global:
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0__mpath_persistent_reserve_in;
> @@ -28,11 +28,9 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0prout_do_scsi_ioctl;
> =A0=A0=A0=A0=A0=A0=A0=A0update_map_pr;
> =A0
> -local: *;
> -};
> -
> -LIBMPATHPERSIST_1.1.0 {
> -global:
> +=A0=A0=A0=A0=A0=A0=A0/* added in 1.1.0 */
> =A0=A0=A0=A0=A0=A0=A0=A0libmpathpersist_init;
> =A0=A0=A0=A0=A0=A0=A0=A0libmpathpersist_exit;
> -} LIBMPATHPERSIST_1.0.0;
> +
> +local: *;
> +};

You don't need to worry about this. I'll fix it up when I add your
patches to the queue branch.

> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 7f3921c5..3a00d7bd 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -45,6 +45,10 @@ ifneq ($(call
> check_func,dm_hold_control_dev,/usr/include/libdevmapper.h),0)
> =A0=A0=A0=A0=A0=A0=A0=A0CFLAGS +=3D -DLIBDM_API_HOLD_CONTROL
> =A0endif
> =A0
> +ifneq ($(call
> check_var,ELS_DTAG_LNK_INTEGRITY,/usr/include/scsi/fc/fc_els.h),0)
> +=A0=A0=A0=A0=A0=A0=A0CFLAGS +=3D -DFPIN_EVENT_HANDLER
> +endif
> +
> =A0OBJS =3D memory.o parser.o vector.o devmapper.o callout.o \
> =A0=A0=A0=A0=A0=A0=A0=A0hwtable.o blacklist.o util.o dmparser.o config.o =
\
> =A0=A0=A0=A0=A0=A0=A0=A0structs.o discovery.o propsel.o dict.o \
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 30046a17..b8a5520a 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -906,6 +906,9 @@ int _init_config (const char *file, struct config
> *conf)
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * fill the voids left in the config file
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0if (conf->fpin_marginal_paths)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->marginal_pathgroups =
=3D YN_YES;
> +

Rather than adding a new config option, I'd prefer to add a new value
"fpin" to the marginal_pathgroups option. That would make it more clear
that the two are actually related / exclusive.


> =A0#ifdef USE_SYSTEMD
> =A0=A0=A0=A0=A0=A0=A0=A0set_max_checkint_from_watchdog(conf);
> =A0#endif
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 933fe0d1..7746aae7 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -186,6 +186,7 @@ struct config {
> =A0=A0=A0=A0=A0=A0=A0=A0int ghost_delay;
> =A0=A0=A0=A0=A0=A0=A0=A0int find_multipaths_timeout;
> =A0=A0=A0=A0=A0=A0=A0=A0int marginal_pathgroups;
> +=A0=A0=A0=A0=A0=A0=A0int fpin_marginal_paths;
> =A0=A0=A0=A0=A0=A0=A0=A0int skip_delegate;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int sequence_nr;
> =A0=A0=A0=A0=A0=A0=A0=A0int recheck_wwid;
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 1b75be47..0f10495d 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -204,6 +204,33 @@ set_yes_no(vector strvec, void *ptr, const char
> *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> +static int
> +set_fpin_marginal_path_yes_no(vector strvec, void *ptr, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 int line_nr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0char *buff;
> +=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> +
> +=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> +=A0=A0=A0=A0=A0=A0=A0if (!buff)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +#ifdef FPIN_EVENT_HANDLER
> +=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, "yes") =3D=3D 0 || strcmp(buff, "1=
") =3D=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YN_YES;
> +=A0=A0=A0=A0=A0=A0=A0else if (strcmp(buff, "no") =3D=3D 0 || strcmp(buff=
, "0") =3D=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YN_NO;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for %s: \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> buff);
> +#else
> +=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YN_NO;
> +=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, FPIN support is not there i=
n the
> kernel",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0file, line_nr);
> +#endif
> +=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}

I'd suggest something like below instead (untested):

#define declare_def_unsupp_handler(option, msg)=09=09=09\
static int=09=09=09=09=09=09=09=09\
def_ ## option ## _handler (struct config *conf, vector strvec,=09=09\
=09=09=09    const char *file, int line_nr)=09=09\
{=09=09=09=09=09=09=09=09=09\
=09condlog(2, "%s line %d, \"" #option "\" is unsupported: %s", file, line_=
nr, msg);=09=09=09=09\
=09return 0;=09=09\
}

#ifdef FPIN_EVENT_HANDLER
declare_def_handler(fpin_marginal_paths, set_yes_no)
#else
declare_unsupp_handler(fpin_marginal_paths, "compiled without FPIN support"=
)
#endif

But see above for my actual preference wrt configuration.

> +
> =A0static int
> =A0set_yes_no_undef(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> @@ -1530,6 +1557,9 @@ declare_hw_snprint(all_tg_pt, print_yes_no_undef)
> =A0declare_def_handler(marginal_pathgroups, set_yes_no)
> =A0declare_def_snprint(marginal_pathgroups, print_yes_no)
> =A0
> +declare_def_handler(fpin_marginal_paths,
> set_fpin_marginal_path_yes_no)
> +declare_def_snprint(fpin_marginal_paths, print_yes_no)
> +
> =A0declare_def_handler(recheck_wwid, set_yes_no_undef)
> =A0declare_def_snprint_defint(recheck_wwid, print_yes_no_undef,
> DEFAULT_RECHECK_WWID)
> =A0declare_ovr_handler(recheck_wwid, set_yes_no_undef)
> @@ -1947,6 +1977,7 @@ init_keywords(vector keywords)
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("enable_foreign", &def_enable_for=
eign_handler,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&=
snprint_def_enable_foreign);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("marginal_pathgroups",
> &def_marginal_pathgroups_handler, &snprint_def_marginal_pathgroups);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("fpin_marginal_paths",
> &def_fpin_marginal_paths_handler, &snprint_def_fpin_marginal_paths);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("recheck_wwid", &def_recheck_wwid=
_handler,
> &snprint_def_recheck_wwid);
> =A0=A0=A0=A0=A0=A0=A0=A0__deprecated install_keyword("default_selector",
> &def_selector_handler, NULL);
> =A0=A0=A0=A0=A0=A0=A0=A0__deprecated install_keyword("default_path_groupi=
ng_policy",
> &def_pgpolicy_handler, NULL);
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index eb5b5b55..65d29fb0 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -31,7 +31,7 @@
> =A0 *=A0=A0 The new version inherits the previous ones.
> =A0 */
> =A0
> -LIBMULTIPATH_9.0.0 {
> +LIBMULTIPATH_10.0.0 {
> =A0global:
> =A0=A0=A0=A0=A0=A0=A0=A0/* symbols referenced by multipath and multipathd=
 */
> =A0=A0=A0=A0=A0=A0=A0=A0add_foreign;
> @@ -284,6 +284,9 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0/* added in 8.2.0 */
> =A0=A0=A0=A0=A0=A0=A0=A0check_daemon;
> =A0
> +=A0=A0=A0=A0=A0=A0=A0/* added in 10.0.0 */
> +=A0=A0=A0=A0=A0=A0=A0vector_find_or_add_slot;
> +
> =A0local:
> =A0=A0=A0=A0=A0=A0=A0=A0*;
> =A0};
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index b2876670..8807db6a 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -84,6 +84,8 @@ static const char cmdline_origin[] =3D
> =A0=A0=A0=A0=A0=A0=A0=A0"(setting: multipath command line [-p] flag)";
> =A0static const char autodetect_origin[] =3D
> =A0=A0=A0=A0=A0=A0=A0=A0"(setting: storage device autodetected)";
> +static const char fpin_marginal_path_origin[] =3D
> +=A0=A0=A0=A0=A0=A0=A0"(setting: overridden by fpin_marginal_paths)";
> =A0static const char marginal_path_origin[] =3D
> =A0=A0=A0=A0=A0=A0=A0=A0"(setting: implied by marginal_path check)";
> =A0static const char delay_watch_origin[] =3D
> @@ -1036,9 +1038,12 @@ int select_san_path_err_threshold(struct config
> *conf, struct multipath *mp)
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(buff);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (marginal_path_check_enabled(mp)) {
> +=A0=A0=A0=A0=A0=A0=A0if (marginal_path_check_enabled(mp) || conf-
> >fpin_marginal_paths) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->san_path_err_threshol=
d =3D NU_NO;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D marginal_path_or=
igin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (conf->fpin_marginal_pat=
hs)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ori=
gin =3D fpin_marginal_path_origin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ori=
gin =3D marginal_path_origin;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(san_path_err_threshold);
> @@ -1059,9 +1064,12 @@ int select_san_path_err_forget_rate(struct
> config *conf, struct multipath *mp)
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(buff);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (marginal_path_check_enabled(mp)) {
> +=A0=A0=A0=A0=A0=A0=A0if (marginal_path_check_enabled(mp) || conf-
> >fpin_marginal_paths) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->san_path_err_forget_r=
ate =3D NU_NO;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D marginal_path_or=
igin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (conf->fpin_marginal_pat=
hs)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ori=
gin =3D fpin_marginal_path_origin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ori=
gin =3D marginal_path_origin;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(san_path_err_forget_rate);
> @@ -1083,9 +1091,12 @@ int select_san_path_err_recovery_time(struct
> config *conf, struct multipath *mp)
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(buff);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (marginal_path_check_enabled(mp)) {
> +=A0=A0=A0=A0=A0=A0=A0if (marginal_path_check_enabled(mp) || conf-
> >fpin_marginal_paths) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->san_path_err_recovery=
_time =3D NU_NO;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D marginal_path_or=
igin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (conf->fpin_marginal_pat=
hs)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ori=
gin =3D fpin_marginal_path_origin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ori=
gin =3D marginal_path_origin;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(san_path_err_recovery_time);
> @@ -1107,6 +1118,12 @@ int select_marginal_path_err_sample_time(struct
> config *conf, struct multipath *
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(buff);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (conf->fpin_marginal_paths) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->marginal_path_err_sampl=
e_time =3D NU_NO;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D fpin_marginal_pa=
th_origin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(marginal_path_err_sample_time);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(marginal_path_err_sample_time);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(marginal_path_err_sample_time);
> @@ -1130,6 +1147,12 @@ int
> select_marginal_path_err_rate_threshold(struct config *conf, struct
> multipat
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(buff);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (conf->fpin_marginal_paths) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->marginal_path_err_rate_=
threshold =3D NU_NO;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D fpin_marginal_pa=
th_origin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(marginal_path_err_rate_threshold);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(marginal_path_err_rate_threshold);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(marginal_path_err_rate_threshold);
> @@ -1147,6 +1170,12 @@ int
> select_marginal_path_err_recheck_gap_time(struct config *conf, struct
> multip
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(buff);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (conf->fpin_marginal_paths) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->marginal_path_err_reche=
ck_gap_time =3D NU_NO;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D fpin_marginal_pa=
th_origin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(marginal_path_err_recheck_gap_time);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(marginal_path_err_recheck_gap_time);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(marginal_path_err_recheck_gap_time);
> @@ -1165,6 +1194,12 @@ int
> select_marginal_path_double_failed_time(struct config *conf, struct
> multipat
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(buff);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (conf->fpin_marginal_paths) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->marginal_path_double_fa=
iled_time =3D NU_NO;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D fpin_marginal_pa=
th_origin;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(marginal_path_double_failed_time);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(marginal_path_double_failed_time);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(marginal_path_double_failed_time);
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 88d2a1df..a2db9c9f 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -1109,6 +1109,26 @@ The default is: \fBno\fR
> =A0.
> =A0.
> =A0.TP
> +.B fpin_marginal_paths
> +If set to \fIyes\fR,it helps in detecting marginal paths through FC
> fabric.
> +FC fabric sends the impacted ports information through ELS frames.
> +This feature parses the ELS frame and moves the devices which are
> +affected due to link integrity to marginal path groups.
> +This also sets the associated portstate to marginal.
> +The paths which are set to marginal path group will be unset
> +on receiving the RSCN events.
> +It is \fBstrongly discouraged\fR to use more than one of these methods
> for any
> +given multipath map, because the more concurrent methods may interact
> in
> +unpredictable ways. If the fpin_marginal_paths methods is active
> +marginal_path and san_path_err parameters are implicitly set to 0.
> +Enabling this will also enables the marginal_pathgroups feature by
> default.

No offense, but this is difficult to understand. Here's a draft for
this paragraph:

"Fibre channel fabrics can notify hosts about fabric-level issues such
as integrity failures or congestion with so-called Fabric Performance
Impact Notifications (FPINs) [perhaps add a link to some document on
the web here]. If this option is set to ..., multipathd will receive
these notifications, set path states to "marginal" accordingly, and
regroup paths as described for "marginal_pathgroups yes". This option
can't be used in combination with other options for "Shaky path
detection" (see below). If it is set, marginal_path_xyz and
san_path_err_xyz parameters are implicitly set to 0."

You'll also need to add some text to the "shaky path detection "
section.


> +.RS
> +.TP
> +The default is: \fBno\fR
> +.RE
> +.
> +.
> +.TP
> =A0.B find_multipaths
> =A0This option controls whether multipath and multipathd try to create
> multipath
> =A0maps over non-blacklisted devices they encounter. This matters a) when
> a device is
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 393b6cbb..cd6f7e6d 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -4,6 +4,10 @@ ifneq ($(call
> check_func,dm_task_get_errno,/usr/include/libdevmapper.h),0)
> =A0=A0=A0=A0=A0=A0=A0=A0CFLAGS +=3D -DLIBDM_API_GET_ERRNO
> =A0endif
> =A0
> +ifneq ($(call
> check_var,ELS_DTAG_LNK_INTEGRITY,/usr/include/scsi/fc/fc_els.h),0)
> +=A0=A0=A0=A0=A0=A0=A0CFLAGS +=3D -DFPIN_EVENT_HANDLER
> +=A0=A0=A0=A0=A0=A0=A0FPIN_SUPPORT =3D 1
> +endif
> =A0#
> =A0# debugging stuff
> =A0#
> @@ -34,6 +38,12 @@ endif
> =A0OBJS =3D main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
> waiter.o \
> =A0=A0=A0=A0=A0=A0=A0 dmevents.o init_unwinder.o
> =A0
> +ifeq ($(FPIN_SUPPORT),1)
> +OBJS +=3D fpin_handlers.o
> +endif
> +
> +
> +
> =A0EXEC =3D multipathd
> =A0
> =A0all : $(EXEC)
> diff --git a/multipathd/fpin.h b/multipathd/fpin.h
> new file mode 100644
> index 00000000..88b879a5
> --- /dev/null
> +++ b/multipathd/fpin.h
> @@ -0,0 +1,23 @@
> +#ifndef __FPIN_H__
> +#define __FPIN_H__
> +
> +#ifdef FPIN_EVENT_HANDLER
> +void *fpin_fabric_notification_receiver(void *unused);
> +void *fpin_els_li_consumer(void *data);
> +void cleanup_fpin_list(void);

The cleanup function doesn't need to be exported, see below.

> +#else
> +static void
> *fpin_fabric_notification_receiver(__attribute__((unused))void *unused)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return NULL;
> +}
> +static void *fpin_els_li_consumer(__attribute__((unused))void *data)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return NULL;
> +}
> +static void cleanup_fpin_list(void)
> +{
> +
> +}
> +#endif
> +
> +#endif
> diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
> new file mode 100644
> index 00000000..a2a6f671
> --- /dev/null
> +++ b/multipathd/fpin_handlers.c
> @@ -0,0 +1,566 @@
> +#include <errno.h>
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <libudev.h>
> +#include <scsi/scsi_netlink_fc.h>
> +#include <scsi/fc/fc_els.h>
> +
> +#include "parser.h"
> +#include "vector.h"
> +#include "structs.h"
> +#include "structs_vec.h"
> +#include "main.h"
> +#include "debug.h"
> +#include "util.h"
> +
> +#include "fpin.h"
> +#include "devmapper.h"
> +
> +static pthread_cond_t fpin_li_cond =3D PTHREAD_COND_INITIALIZER;
> +static pthread_mutex_t fpin_li_mutex =3D PTHREAD_MUTEX_INITIALIZER;
> +
> +static LIST_HEAD(els_marginal_list_head);
> +static LIST_HEAD(fpin_li_marginal_dev_list_head);
> +
> +
> +#define DEF_RX_BUF_SIZE=A0=A0=A0=A0=A0=A0=A0=A04096
> +#define DEV_NAME_LEN=A0=A0=A0128
> +#define FCH_EVT_LINKUP 0x2
> +#define FCH_EVT_LINK_FPIN 0x501
> +#define FCH_EVT_RSCN 0x5
> +
> +#define list_first_entry(ptr, type, member) \
> +=A0=A0=A0=A0=A0=A0=A0list_entry((ptr)->next, type, member)
> +
> +/* max ELS frame Size */
> +#define FC_PAYLOAD_MAXLEN=A0=A0 2048
> +
> +struct els_marginal_list {
> +=A0=A0=A0=A0=A0=A0=A0uint32_t event_code;
> +=A0=A0=A0=A0=A0=A0=A0uint16_t host_num;
> +=A0=A0=A0=A0=A0=A0=A0uint16_t length;
> +=A0=A0=A0=A0=A0=A0=A0char payload[FC_PAYLOAD_MAXLEN];
> +=A0=A0=A0=A0=A0=A0=A0struct list_head node;
> +};
> +/* Structure to store the marginal devices info */
> +struct marginal_dev_list {
> +=A0=A0=A0=A0=A0=A0=A0char dev_name[DEV_NAME_LEN];
> +=A0=A0=A0=A0=A0=A0=A0uint32_t host_num;
> +=A0=A0=A0=A0=A0=A0=A0struct list_head node;
> +};
> +
> +static void _vector_reset(void *v)
> +{
> +=A0=A0=A0=A0=A0=A0=A0vector_reset(v);
> +}
> +
> +static void _udev_device_unref(void *p)
> +{
> +=A0=A0=A0=A0=A0=A0=A0udev_device_unref(p);
> +}

You don't need these, use pthread_cleanup_push_cast(vector_reset, v).

> +
> +/*set/unset the path state to marginal*/
> +static int fpin_set_pathstate(struct path *pp, vector reload_mps, bool
> set)
> +{
> +=A0=A0=A0=A0=A0=A0=A0const char *action =3D set ? "set" : "unset";
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->mpp || !pp->mpp->alias)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> +
> +=A0=A0=A0=A0=A0=A0=A0condlog(2, "\n%s: %s=A0 marginal path %s (fpin) dev=
:%s",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0action, pp->mpp->alias, pp-=
>dev_t, pp->dev);

No need to log both pp->dev and pp->dev_t. If you want to provide more
insight for users, rather log the SCSI HBTL or remote port ID.
log level 3 should be sufficient.

> +=A0=A0=A0=A0=A0=A0=A0if (pp->mpp->wait_for_udev) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "\n%s: device no=
t fully created, failing to
> %s marginal",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>mpp->alias, action);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> +=A0=A0=A0=A0=A0=A0=A0}

Why this? The mpp may not be fully initialized, but we could still set
the path property.

> +=A0=A0=A0=A0=A0=A0=A0if (set)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->marginal =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->marginal =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0vector_find_or_add_slot(reload_mps, pp->mpp);
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +
> +}
> +
> +/* This will unset marginal state of a device*/
> +static void fpin_path_unsetmarginal(char *devname, struct vectors
> *vecs, vector reload_mps)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +
> +=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_dev(vecs->pathvec, devname);
> +=A0=A0=A0=A0=A0=A0=A0if (!pp)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_devt(ve=
cs->pathvec, devname);
> +
> +=A0=A0=A0=A0=A0=A0=A0fpin_set_pathstate(pp, reload_mps, 0);
> +}
> +
> +/*This will set the marginal state of a device*/
> +static int fpin_path_setmarginal(struct path *pp, vector reload_mps)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return fpin_set_pathstate(pp, reload_mps, 1);
> +}

It's confusing that fpin_path_unsetmarginal takes a name and
fpin_path_setmarginal takes a pointer. The latter is so trivial that
you might leave it out, actually. For ther former, I suppose you're
concerned that the pp pointer may get freed. That's reasonable, but I
suggest to use dev_t instead for identifying paths.

> +
> +/* Unsets all the devices in the list from marginal state */
> +static void
> +fpin_unset_marginal_dev(uint32_t host_num, struct vectors *vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *tmp_marg =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct list_head *current_node =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct list_head *temp =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct multipath *mpp;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +=A0=A0=A0=A0=A0=A0=A0struct _vector _reload_mps =3D { .allocated =3D 0, =
};
> +=A0=A0=A0=A0=A0=A0=A0struct _vector * const reload_mps =3D &_reload_mps;

This works, but you might as well use a bitmap or an additional
field in struct multipath to track which maps must be reloaded.

> +
> +=A0=A0=A0=A0=A0=A0=A0if (list_empty(&fpin_li_marginal_dev_list_head)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "Marginal List i=
s empty\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(_vector_reset, reload_mps);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> +=A0=A0=A0=A0=A0=A0=A0list_for_each_safe(current_node, temp,
> &fpin_li_marginal_dev_list_head) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tmp_marg =3D list_entry(cur=
rent_node,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0node);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (tmp_marg->host_num !=3D=
 host_num)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, " unsetting marg=
inal dev: is %s %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0tmp_marg->dev_name, tmp_marg-
> >host_num);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpin_path_unsetmarginal(tmp=
_marg->dev_name, vecs,
> reload_mps);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(current_node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(tmp_marg);
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(reload_mps, mpp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D reload_and_sync_map=
(mpp, vecs, 0);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D 2)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "map removed during reload");
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +}
> +
> +/*
> + * On Receiving the frame from HBA driver, insert the frame into link
> + * integrity frame list which will be picked up later by consumer
> thread for
> + * processing.
> + */
> +static int
> +fpin_els_add_li_frame(struct fc_nl_event *fc_event)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_mrg =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (fc_event->event_datalen > FC_PAYLOAD_MAXLEN)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_mutex);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_mutex, &fpin_li_mutex)=
;
> +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> +=A0=A0=A0=A0=A0=A0=A0els_mrg =3D calloc(sizeof(struct els_marginal_list)=
, 1);
> +=A0=A0=A0=A0=A0=A0=A0if (els_mrg !=3D NULL) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->host_num =3D fc_ev=
ent->host_no;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->event_code =3D fc_=
event->event_code;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->length =3D fc_even=
t->event_datalen;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memcpy(els_mrg->payload, &(=
fc_event->event_data),
> fc_event->event_datalen);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_add_tail(&els_mrg->nod=
e, &els_marginal_list_head);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cond_signal(&fpin_l=
i_cond);
> +=A0=A0=A0=A0=A0=A0=A0} else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "NO Memory to ad=
d frame payload\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D -ENOMEM;
> +=A0=A0=A0=A0=A0=A0=A0}

Logging ENOMEM in this way is often not helpful.

> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0return ret;
> +
> +}
> +
> +/*Sets the rport port_state to marginal*/
> +static void fpin_set_rport_marginal(struct udev_device *rport_dev)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0ret =3D udev_device_set_sysattr_value(rport_dev, "p=
ort_state",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Marginal");
> +=A0=A0=A0=A0=A0=A0=A0if (ret >=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "set rport port =
state to marginal
> succeeded\n");
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "set rport port =
state to marginal failed:
> %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
);
> +}

I wonder why you have this, but no function to unset marginal status.
You might as well use our utility function sysfs_attr_set_value() and
skip your custom logging.

> +
> +/*Add the marginal devices info into the list*/
> +static void
> +fpin_add_marginal_dev_info(uint32_t host_num, char *devname)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *newdev =3D NULL;
> +
> +=A0=A0=A0=A0=A0=A0=A0newdev =3D (struct marginal_dev_list *) calloc(1,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0siz=
eof(struct marginal_dev_list));
> +=A0=A0=A0=A0=A0=A0=A0if (newdev !=3D NULL) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0newdev->host_num =3D host_n=
um;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strlcpy(newdev->dev_name, d=
evname, DEV_NAME_LEN);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "\n%s hostno %d =
devname %s\n", __func__,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0host_num, newdev->dev_name);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_add_tail(&(newdev->nod=
e),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0&fpin_li_marginal_dev_list_head);
> +=A0=A0=A0=A0=A0=A0=A0} else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "\n Mem alloc fa=
iled to add marginal dev
> info"
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 " Unset the marginal state manually after
> recovery"
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 " for hostno %d devname %s\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0hos=
t_num, devname);

No extensive logging of ENOMEM, please. If you are out of  memory, your
condlog will likely not work either. If you really need, print a
constant string and add a section to the man page explaining how to=20
recover (I suppose restarting multipathd would suffice).

Btw, how does your code handle "multipathd reconfigure"? I'd think that
reconfigure (or at least, the recently added "reconfigure all") should
reset all marginal states. But that doesn't seem to be the case.

> +=A0=A0=A0=A0=A0=A0=A0}
> +}
> +
> +/*
> + * This function goes through the vecs->pathvec, and for
> + * each path, check that the host=A0 number,
> + * the target WWPN associated with the path matches
> + * with the els wwpn and sets the path and port state to
> + * Marginal
> + */
> +static int=A0 fpin_chk_wwn_setpath_marginal(uint16_t host_num,=A0 struct
> vectors *vecs,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uint64_t els_wwpn)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +=A0=A0=A0=A0=A0=A0=A0struct multipath *mpp;
> +=A0=A0=A0=A0=A0=A0=A0int i, k;
> +=A0=A0=A0=A0=A0=A0=A0char rport_id[42];
> +=A0=A0=A0=A0=A0=A0=A0const char *value =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct udev_device *rport_dev =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0uint64_t wwpn;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0struct _vector _reload_mps =3D { .allocated =3D 0, =
};
> +=A0=A0=A0=A0=A0=A0=A0struct _vector * const reload_mps =3D &_reload_mps;

See remark about reload_mps above.

> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(_vector_reset, reload_mps);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(vecs->pathvec, pp, k) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Checks the host number a=
nd also for the SCSI FCP */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->sg_id.proto_id !=3D=
 SCSI_PROTOCOL_FCP || host_num
> !=3D=A0 pp->sg_id.host_no)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sprintf(rport_id, "rport-%d=
:%d-%d",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->sg_id.host_no, pp->sg_id.channel,
> pp->sg_id.transport_id);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rport_dev =3D
> udev_device_new_from_subsystem_sysname(udev,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0"fc_remote_ports", rport_id);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!rport_dev) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "%s: No fc_remote_port device for
> '%s'", pp->dev,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rport_id);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;

This is not a fatal error. Use loglevel 2.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(_udev_=
device_unref, rport_dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0value =3D udev_device_get_s=
ysattr_value(rport_dev,
> "port_name");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!value)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o unref;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (value)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0wwp=
n =3D=A0 strtol(value, NULL, 16);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * If the port wwpn matches=
 sets the path and port
> state
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * to marginal
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (wwpn =3D=3D els_wwpn) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
 =3D fpin_path_setmarginal(pp, reload_mps);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ret < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0goto unref;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_set_rport_marginal(rport_dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_add_marginal_dev_info(host_num, pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +unref:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(reload_mps, mpp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D reload_and_sync_map=
(mpp, vecs, 0);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D 2)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "map removed during reload");
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0return ret;
> +}
> +
> +/*
> + * This function loops around all the impacted wwns received as part
> of els
> + * frame and sets the associated path and port states to marginal.
> + */
> +static int
> +fpin_parse_li_els_setpath_marginal(uint16_t host_num, struct
> fc_tlv_desc *tlv,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct vectors *vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0uint32_t wwn_count =3D 0, iter =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0uint64_t wwpn;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_fn_li_desc *li_desc =3D (struct fc_fn_li_=
desc *)tlv;
> +=A0=A0=A0=A0=A0=A0=A0int count =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0/* Update the wwn to list */
> +=A0=A0=A0=A0=A0=A0=A0wwn_count =3D be32_to_cpu(li_desc->pname_count);
> +=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got wwn count as %d\n", wwn_count);
> +
> +=A0=A0=A0=A0=A0=A0=A0for (iter =3D 0; iter < wwn_count; iter++) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0wwpn =3D be64_to_cpu(li_des=
c->pname_list[iter]);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D fpin_chk_wwn_setpat=
h_marginal(host_num, vecs,
> wwpn);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "failed to set the path marginal
> associated with wwpn: 0x%lx\n", wwpn);

Again, no fatal error; use loglevel 2

> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0count++;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return count;
> +}
> +
> +/*
> + * This function process the ELS frame received from HBA driver,
> + * and sets the path associated with the port wwn to marginal
> + * and also set the port state to marginal.
> + */
> +static int
> +fpin_process_els_frame(uint16_t host_num, char *fc_payload, struct
> vectors *vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0uint32_t els_cmd =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0int count =3D -1;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_els_fpin *fpin =3D (struct fc_els_fpin *)=
fc_payload;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_tlv_desc *tlv;
> +=A0=A0=A0=A0=A0=A0=A0uint32_t dtag;
> +
> +=A0=A0=A0=A0=A0=A0=A0els_cmd =3D *(uint32_t *)fc_payload;
> +=A0=A0=A0=A0=A0=A0=A0tlv =3D (struct fc_tlv_desc *)&fpin->fpin_desc[0];
> +=A0=A0=A0=A0=A0=A0=A0dtag =3D be32_to_cpu(tlv->desc_tag);
> +=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got CMD in add as 0x%x fpin_cmd 0x%x dt=
ag 0x%x\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
_cmd, fpin->fpin_cmd, dtag);
> +
> +=A0=A0=A0=A0=A0=A0=A0switch (fpin->fpin_cmd) {
> +=A0=A0=A0=A0=A0=A0=A0case ELS_FPIN:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*Check the type of fpin by=
 checking the tag info*/
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch (dtag) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case ELS_DTAG_LNK_INTEGRITY=
:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
Parse the els frame and set the affected
> paths and port
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
state to marginal
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cou=
nt =3D
> fpin_parse_li_els_setpath_marginal(host_num, tlv, vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(count <=3D 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(4, "Could not find any WWNs,
> ret =3D %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0count);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return count;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case ELS_DTAG_PEER_CONGEST:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "Rcvd FPIN: Congestion not
> supported:\n");

Please don't log this on every invocation, just once. But actually,
I don't understand why you don't filter out everything which you don't
support in the receiver already. If you do that, you wouldn't need this
code at all. You could just use an assert(), as no unsupported events
could ever be encountered here.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case ELS_DTAG_DELIVERY:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "Rcvd FPIN: Delivery notification
> not supported\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case ELS_DTAG_CONGESTION:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "Rcvd FPIN:Transmission delay not
> supported:\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0default:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +
> +=A0=A0=A0=A0=A0=A0=A0default:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "Invalid command=
 received: 0x%x\n",
> els_cmd);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0return (count);
> +}
> +
> +/*
> + * This function process the FPIN ELS frame received from HBA
> driver,
> + * and push the frame to appropriate frame list. Currently we have
> only FPIN
> + * LI frame list.
> + */
> +static int
> +fpin_handle_els_frame(struct fc_nl_event *fc_event)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D -1;
> +=A0=A0=A0=A0=A0=A0=A0uint32_t els_cmd;
> +
> +=A0=A0=A0=A0=A0=A0=A0els_cmd =3D (uint32_t)fc_event->event_data;
> +
> +=A0=A0=A0=A0=A0=A0=A0switch (els_cmd) {
> +=A0=A0=A0=A0=A0=A0=A0case ELS_FPIN:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*Push the Payload to FPIN =
frame queue. */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D fpin_els_add_li_fra=
me(fc_event);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret !=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "Failed to process LI frame with
> error %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0default:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((fc_event->event_code =
=3D=3D FCH_EVT_LINKUP) ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (fc_event->event_=
code =3D=3D FCH_EVT_RSCN)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*P=
ush the Payload to FPIN frame queue. */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
 =3D fpin_els_add_li_frame(fc_event);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ret !=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(0, "Failed to process
> Linkup/RSCN event with error %d evnt %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret, fc_event->event_code);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "Invalid command=
 received: 0x%x\n",
> els_cmd);

Not sure if this should be logged at level 2, always. Depending on the
fabric, it might generate quite some log spam.

> +=A0=A0=A0=A0=A0=A0=A0}

Please use if() ... else rather than a switch with just one case
clause. I think you should check event_code before els_cmd. See also my
comment for the main receiver code below.

> +=A0=A0=A0=A0=A0=A0=A0return (ret);
> +
> +}
> +
> +/*cleans the global marginal dev list*/
> +static void fpin_clean_marginal_dev_list(void)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *tmp_marg =3D NULL;
> +

No locking needed here?

> +=A0=A0=A0=A0=A0=A0=A0while (!list_empty(&fpin_li_marginal_dev_list_head)=
) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tmp_marg=A0 =3D
> list_first_entry(&fpin_li_marginal_dev_list_head,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list, node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(&tmp_marg->node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(tmp_marg);
> +=A0=A0=A0=A0=A0=A0=A0}
> +}
> +
> +/* Cleans the global els=A0 marginal list */
> +static void fpin_clean_els_marginal_list(void *arg)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct list_head *head =3D (struct list_head *)arg;
> +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_marg;
> +
> +=A0=A0=A0=A0=A0=A0=A0while (!list_empty(head)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_marg=A0 =3D list_first_=
entry(head, struct
> els_marginal_list,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(&els_marg->node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(els_marg);
> +=A0=A0=A0=A0=A0=A0=A0}
> +}
> +
> +/* Cleans the global lists */
> +void cleanup_fpin_list(void)
> +{
> +=A0=A0=A0=A0=A0=A0=A0fpin_clean_marginal_dev_list();
> +=A0=A0=A0=A0=A0=A0=A0fpin_clean_els_marginal_list(&els_marginal_list_hea=
d);
> +}

Please add these cleanup functions to the exit handlers of the=20
two threads using pthread_cleanup_push(), like we did it with the
uevent dispatcher and listener in uevent.c. This way you don't need to
export cleanup_fpin_list().

> +
> +/*
> + * This is the FPIN ELS consumer thread. The thread sleeps on
> pthread cond
> + * variable unless notified by fpin_fabric_notification_receiver
> thread.
> + * This thread is only to process FPIN-LI ELS frames. A new thread
> and frame
> + * list will be added if any more ELS frames types are to be
> supported.
> + */
> +void *fpin_els_li_consumer(void *data)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct list_head marginal_list_head;
> +=A0=A0=A0=A0=A0=A0=A0char payload[FC_PAYLOAD_MAXLEN]
> __attribute__((aligned(sizeof(uint64_t))));
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0uint16_t host_num;
> +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_marg;
> +=A0=A0=A0=A0=A0=A0=A0uint32_t event_code;
> +=A0=A0=A0=A0=A0=A0=A0struct vectors *vecs =3D (struct vectors *)data;

You must register your threads (both) with RCU:

=09pthread_cleanup_push(rcu_unregister, NULL);
=09rcu_register_thread();


> +
> +=A0=A0=A0=A0=A0=A0=A0INIT_LIST_HEAD(&marginal_list_head);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(fpin_clean_els_marginal_list,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 (void *)&marginal_list_head);
> +=A0=A0=A0=A0=A0=A0=A0for ( ; ; ) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li=
_mutex);


You should use pthread_cleanup_push() here for unlocking,
as you're calling pthread_cond_wait().

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (list_empty(&els_margina=
l_list_head))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pth=
read_cond_wait(&fpin_li_cond,
> &fpin_li_mutex);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!list_empty(&els_margin=
al_list_head)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(4, "Invoke List splice tail\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lis=
t_splice_tail_init(&els_marginal_list_head
> , &marginal_list_head);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pth=
read_mutex_unlock(&fpin_li_mutex);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pth=
read_mutex_unlock(&fpin_li_mutex);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (!list_empty(&margina=
l_list_head)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
_marg=A0 =3D
> list_first_entry(&marginal_list_head,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0struct
> els_marginal_list, node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0hos=
t_num =3D els_marg->host_num;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0eve=
nt_code =3D els_marg->event_code;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mem=
cpy(payload, els_marg->payload, els_marg-
> >length);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lis=
t_del(&els_marg->node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fre=
e(els_marg);

why memcpy here rather then pass &els_marg->payload down directly,
and free els_marg a few lines further down?

> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
Now finally process FPIN LI ELS Frame */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(4, "Got a new Payload buffer,
> processing it\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
((event_code =3D=3D=A0 FCH_EVT_LINKUP) ||
> (event_code =3D=3D FCH_EVT_RSCN))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 fpin_unset_marginal_dev(host_num,
> vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0ret =3D
> fpin_process_els_frame(host_num, payload, vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (ret <=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "ELS frame
> processing failed with ret %d\n", ret);

Again, no condlog(0) please unless it's *really* fatal (basically,
multipathd can't continue running).

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0return NULL;
> +}
> +
> +/*
> + * Listen for ELS frames from driver. on receiving the frame
> payload,
> + * push the payload to a list, and notify the fpin_els_li_consumer
> thread to
> + * process it. Once consumer thread is notified, return to listen
> for more ELS
> + * frames from driver.
> + */
> +void *fpin_fabric_notification_receiver(__attribute__((unused))void
> *unused)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int ret;
> +=A0=A0=A0=A0=A0=A0=A0long fd;
> +=A0=A0=A0=A0=A0=A0=A0uint32_t els_cmd;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_nl_event *fc_event =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct sockaddr_nl fc_local;
> +=A0=A0=A0=A0=A0=A0=A0unsigned char buf[DEF_RX_BUF_SIZE]
> __attribute__((aligned(sizeof(uint64_t))));
> +=A0=A0=A0=A0=A0=A0=A0size_t plen =3D 0;
> +

please register with RCU, see above.

> +=A0=A0=A0=A0=A0=A0=A0fd =3D socket(PF_NETLINK, SOCK_DGRAM, NETLINK_SCSIT=
RANSPORT);
> +=A0=A0=A0=A0=A0=A0=A0if (fd < 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "fc socket error=
 %ld", fd);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(close_fd, (void *)fd);
> +=A0=A0=A0=A0=A0=A0=A0memset(&fc_local, 0, sizeof(fc_local));
> +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_family =3D AF_NETLINK;
> +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_groups =3D ~0;
> +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_pid =3D getpid();
> +=A0=A0=A0=A0=A0=A0=A0ret =3D bind(fd, (struct sockaddr *)&fc_local,
> sizeof(fc_local));
> +=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D -1) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "fc socket bind =
error %d\n", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0for ( ; ; ) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Waiting for ELS=
...\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D read(fd, buf, DEF_R=
X_BUF_SIZE);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got a new reque=
st %d\n", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!NLMSG_OK((struct nlmsg=
hdr *)buf, ret)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "bad els frame read (%d)", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Push the frame to approp=
riate frame list */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0plen =3D NLMSG_PAYLOAD((str=
uct nlmsghdr *)buf, 0);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fc_event =3D (struct fc_nl_=
event *)NLMSG_DATA(buf);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (plen < sizeof(*fc_event=
)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "too short (%d) to be an FC
> event", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_cmd =3D (uint32_t)fc_ev=
ent->event_data;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got host no as =
%d, event 0x%x, len %d
> evntnum %d evntcode %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0fc_event->host_no, els_cmd, fc_event-
> >event_datalen,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0fc_event->event_num, fc_event-
> >event_code);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((fc_event->event_code =
=3D=3D FCH_EVT_LINK_FPIN) ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(fc=
_event->event_code =3D=3D FCH_EVT_LINKUP) ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(fc=
_event->event_code =3D=3D FCH_EVT_RSCN))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0fpin_handle_els_frame(fc_event);

No need to check the event code both here and in fpin_handle_els_frame.
I'd suggest to handle it just in the latter.

> +=A0=A0=A0=A0=A0=A0=A0}
> +out:
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0return NULL;
> +}
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1defeaf1..d81ebd92 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -16,6 +16,7 @@
> =A0#include <linux/oom.h>
> =A0#include <libudev.h>
> =A0#include <urcu.h>
> +#include "fpin.h"
> =A0#ifdef USE_SYSTEMD
> =A0#include <systemd/sd-daemon.h>
> =A0#endif
> @@ -130,9 +131,11 @@ static volatile enum daemon_status running_state
> =3D DAEMON_INIT;
> =A0pid_t daemon_pid;
> =A0static pthread_mutex_t config_lock =3D PTHREAD_MUTEX_INITIALIZER;
> =A0static pthread_cond_t config_cond;
> -static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr,
> dmevent_thr;
> +static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr,
> dmevent_thr,
> +=A0=A0=A0=A0=A0=A0=A0fpin_thr, fpin_consumer_thr;
> =A0static bool check_thr_started, uevent_thr_started,
> uxlsnr_thr_started,
> -=A0=A0=A0=A0=A0=A0=A0uevq_thr_started, dmevent_thr_started;
> +=A0=A0=A0=A0=A0=A0=A0uevq_thr_started, dmevent_thr_started, fpin_thr_sta=
rted,
> +=A0=A0=A0=A0=A0=A0=A0fpin_consumer_thr_started;
> =A0static int pid_fd =3D -1;
> =A0
> =A0static inline enum daemon_status get_running_state(void)
> @@ -3029,6 +3032,11 @@ static void cleanup_threads(void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(uevq_thr);
> =A0=A0=A0=A0=A0=A0=A0=A0if (dmevent_thr_started)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(dmevent_th=
r);
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_thr_started)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(fpin_thr);
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_consumer_thr_started)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(fpin_consume=
r_thr);
> +
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (check_thr_started)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(check_thr, N=
ULL);
> @@ -3040,6 +3048,11 @@ static void cleanup_threads(void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(uevq_thr, NU=
LL);
> =A0=A0=A0=A0=A0=A0=A0=A0if (dmevent_thr_started)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(dmevent_thr,=
 NULL);
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_thr_started)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(fpin_thr, NULL=
);
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_consumer_thr_started)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(fpin_consumer_=
thr, NULL);
> +
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * As all threads are joined now, and we're in
> DAEMON_SHUTDOWN
> @@ -3101,6 +3114,7 @@ static void cleanup_rcu(void)
> =A0static void cleanup_child(void)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0cleanup_threads();
> +=A0=A0=A0=A0=A0=A0=A0cleanup_fpin_list();
> =A0=A0=A0=A0=A0=A0=A0=A0cleanup_vecs();
> =A0=A0=A0=A0=A0=A0=A0=A0if (poll_dmevents)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cleanup_dmevent_waiter();
> @@ -3137,6 +3151,7 @@ child (__attribute__((unused)) void *param)
> =A0=A0=A0=A0=A0=A0=A0=A0char *envp;
> =A0=A0=A0=A0=A0=A0=A0=A0enum daemon_status state;
> =A0=A0=A0=A0=A0=A0=A0=A0int exit_code =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0int fpin_marginal_paths =3D 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0init_unwinder();
> =A0=A0=A0=A0=A0=A0=A0=A0mlockall(MCL_CURRENT | MCL_FUTURE);
> @@ -3215,7 +3230,9 @@ child (__attribute__((unused)) void *param)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0setscheduler();
> =A0=A0=A0=A0=A0=A0=A0=A0set_oom_adj();
> -
> +#ifdef FPIN_EVENT_HANDLER
> +=A0=A0=A0=A0=A0=A0=A0fpin_marginal_paths =3D conf->fpin_marginal_paths;
> +#endif
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Startup done, invalidate configuration
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> @@ -3283,6 +3300,21 @@ child (__attribute__((unused)) void *param)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto failed;
> =A0=A0=A0=A0=A0=A0=A0=A0} else
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uevq_thr_started =3D true=
;
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_marginal_paths) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D pthread_create(=
&fpin_thr, &misc_attr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_fabric_notification_receiver, NULL))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "failed to create the fpin
> receiver thread: %d", rc);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o failed;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_thr_started =3D true;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D pthread_create(=
&fpin_consumer_thr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&mi=
sc_attr, fpin_els_li_consumer, vecs))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "failed to create the fpin
> consumer thread thread: %d", rc);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o failed;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_consumer_thr_started =3D true;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_attr_destroy(&misc_attr);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0while (1) {


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

