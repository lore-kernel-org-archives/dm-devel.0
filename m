Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE77C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 09:45:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-EuViCphrML2tEUCY6M7Ujg-1; Wed, 30 Mar 2022 05:44:57 -0400
X-MC-Unique: EuViCphrML2tEUCY6M7Ujg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5498828078D3;
	Wed, 30 Mar 2022 09:44:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 305EB40D2822;
	Wed, 30 Mar 2022 09:44:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7C7A19451F3;
	Wed, 30 Mar 2022 09:44:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F8D419466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 09:44:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D5411121314; Wed, 30 Mar 2022 09:44:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3738E1121331
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 09:44:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B2A828078D8
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 09:44:45 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-_2ZPGFIRPsCW-OtsufuKjA-1; Wed, 30 Mar 2022 05:44:43 -0400
X-MC-Unique: _2ZPGFIRPsCW-OtsufuKjA-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2052.outbound.protection.outlook.com [104.47.1.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-12-iiop_mMhOu68Qv4pyOAh7g-1; Wed, 30 Mar 2022 11:44:40 +0200
X-MC-Unique: iiop_mMhOu68Qv4pyOAh7g-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM9PR04MB8212.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23; Wed, 30 Mar
 2022 09:44:39 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::7891:cf1e:2bf:a180]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::7891:cf1e:2bf:a180%3]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 09:44:39 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [RFC PATCH] multipathd: Don't keep starting TUR threads, if they
 always hang.
Thread-Index: AQHYQ+Vdq04RXybMoUS5JBNbIEsFDqzXrcAA
Date: Wed, 30 Mar 2022 09:44:39 +0000
Message-ID: <f17860010d25b1fa5abee0e6e3b98df2f8319647.camel@suse.com>
References: <1648610530-28526-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1648610530-28526-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5050c5f8-db3f-4c3c-08de-08da1231e8a2
x-ms-traffictypediagnostic: AM9PR04MB8212:EE_
x-microsoft-antispam-prvs: <AM9PR04MB82122A767DB61B8AEE0375D4FC1F9@AM9PR04MB8212.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: fsZ83YoZQEFHgmNUYXilZOK8Lz0Rm30JlVYaDomp1MNxoOpEdBLYluhbvn5ACAs86nP9VcSVc1xnc+kc8ufxbrBtNelFtbbCVWdxRLFraTlHHIsGLur/g/xK9jpdZMUuQ0UtPcAm6PqQkVcYcyqX1QJYdqkHGMdg1OfFkcjNE5euQk0yAXtd2vvzt2/Jpr6AXmcMiJtElU3ggu+KewRgJjjAEIOAdGKlztdbL0hw9e6oyjTHKljVcuf7XfduJcGTwPVUI2HtZ0d6uZLuE++/4BuchpOEXP2oRq5GbR9liObtRuiUG+arhhXC0qTTjaZvNJASzez8MljukHJ5P0V2mhew8tFcjXAVoJDvXHvlBhySmd2gwYB3k1dbLV0TvNGHEOKLgt3Dj19uVZbzhCmmBCkRoyC18nmUiRi8KmxWYuAFwm9DIY2V3z4NvEr5yWEJ6k8J8lI/y/fn3O66Z88ALAuutfE00O7/bHFCJAGyEiQ3B5ah+HRhhPwAsik2VdAyyb+jyxWmOYjbXOiod67u9Bbq/uAhoVKZqBtF0gU1e9A9naQab0wUaxX5ESlL3LCLybz/GCHqUreL0c/8/0YsQXocN9S/rND2zQfT+QqPg0Cm/ECaIPnXwgOkMu7XTeOjPoTqsCFGIsNCLne2kgjk+m7V9zCrzwe/2p9eOJoC2xGbuLaCfAt/udBL27tBEbF58EIifVuz+EophOce/Wdks+PH8lslCXm0THrFbWv2p7jToDZFrXKShpk1K4jJh9CYcZumH2zqia2vwhaLMsQ4A+/bHqRIcKPXiCrnAYqtGxB7+ipuudDapnRLFgbUmy9CFpIal2llVXwLsCr7nxEfgA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(38100700002)(64756008)(66946007)(66556008)(66446008)(122000001)(91956017)(66476007)(966005)(6512007)(26005)(4326008)(38070700005)(76116006)(8676002)(110136005)(86362001)(508600001)(186003)(44832011)(83380400001)(2616005)(5660300002)(6486002)(71200400001)(36756003)(8936002)(316002)(6506007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?UGIRx/jQ6057DjXS/mS5koNhdrd6z8yRmRvAcYMXxyLtDRV0t8vXci8NE?=
 =?iso-8859-15?Q?68+LlB/ixxMEETu6ZQPklRgZxPVRxDwYBWNKoAE6QHhZIo8ixh4P7K0Ue?=
 =?iso-8859-15?Q?gdENzZMUOAB05eBh4lbRWIEfFvY2mc3dQXGVuhvv1qZV2V+sZYdq/6qjP?=
 =?iso-8859-15?Q?7Iqzh01SA76sWngnjj12+3OPSN4u/h10hwNNZnIFI61B7xwGasSxSzXmQ?=
 =?iso-8859-15?Q?2dyoUfXIdm0RJCrISCZHYv0fNop7MDFcZHPMrRUkce8+xZXKcOBLfB/gB?=
 =?iso-8859-15?Q?7/3lkWN+3u0UZ7MMOJtvBhGRAe2o5AxU40lVOZvw1KIUonVTBSIhyATra?=
 =?iso-8859-15?Q?AuMc/JI3FR6skl/BOqnamBkDlXvPeVakg1pEvC0yyx2zIpuGsc51hn+Yd?=
 =?iso-8859-15?Q?6XwP35c7GlQ/5/Xm/nr1AGs22j64ogI/OQEnUxBufRxMGn2C11e8gFaF3?=
 =?iso-8859-15?Q?PMpTLJeMa9kR29wCVa/X+wvb11jcx2ACv5TjNN7BKldJrgYJwBgh3WK7p?=
 =?iso-8859-15?Q?hG5MuRVm7tW0ytbpHlXSR1lY13Xcbcj6bSyjyghGrsDMHu9ESnsqyLE5S?=
 =?iso-8859-15?Q?8ACOv4oAKAUHSAuwzwmi5v98pbw2C8zeU0ggiHgo1sa2d2BGPaCVgqqO9?=
 =?iso-8859-15?Q?4QdJ4yS/+fp9e1OPSfWIkSq+kOIm4ZhgvVPmxGWhB4ZKEmLq7lKhYbMl/?=
 =?iso-8859-15?Q?1tkSxTfVITnzoXgDKRs36BoTLatEMBYb8FOSMGsCGhdw9WinsmrmiRsC7?=
 =?iso-8859-15?Q?VwuL8meux27SOWLCAhqQa/RFh3zbgUitnW61PFUAbHSw8jKE+1bnDVefL?=
 =?iso-8859-15?Q?txy22frDNpEdTfMl+OEqms496QAjvEjQRE4LnBYuH6QyFVSYmEs3yOQxc?=
 =?iso-8859-15?Q?OOfnoZJptN8iASttQ7EPnPfF4hj7ezfWl6ZcKAqStGFylOGRQMn8OAqWC?=
 =?iso-8859-15?Q?cn/KosxxoVyf7hPTJ4aomyK2hhCIBTld/xV8KGxWHy9TlPvSppuhBtNNM?=
 =?iso-8859-15?Q?Gahsomd6l2cb1tYlDbN7mtAnBoULt34Dp8oh6q+ZoH4Mctv7rlQO5Qq3B?=
 =?iso-8859-15?Q?B8xsGYG2gKSTV7LAy7HzyrCOeqYDqNw0bUr79sHayUqPb+Fx0Wq4VkJ/g?=
 =?iso-8859-15?Q?XH4LnEMlJEKyP+adFNOmjmRIoWpm4ENoHhPK+nA9OsFV906/Ve5SzQxI0?=
 =?iso-8859-15?Q?9WZCXL09COkk+sOULnk1NzB7lphjsPcD/y8DS3JTr4pDrG0S049wsmDIT?=
 =?iso-8859-15?Q?R8dWqetKgC4t9QdUs7ZSiPB5fJ4myXRn1cofUWi5mCSPshoASmTzLQQXD?=
 =?iso-8859-15?Q?3GbQ2QgC3Et0q71BbzD+wHxmcXY3yFEINrVUBzQr0bl9H5m4nPAxs7ocj?=
 =?iso-8859-15?Q?E5LzMuFW6ZWZLWEAHA9AwAt01jjuYbeaPzCuhipZgMRUM7KfukNhkDWoh?=
 =?iso-8859-15?Q?tyKC8hUuocCUdcRuZYhCxOG1tFxZUDjPw1mhwDZp/lD+cgVcLVWkFnxIT?=
 =?iso-8859-15?Q?EhT8fSNXhpgxIY5wwXVOtyoaPdhi/HiC0hYDtE4IkXTNTNlfzLmMYudQH?=
 =?iso-8859-15?Q?23lEB36vUxPBRcwsu1XH1UOTUQUpKcxbGjQy1iSOlQMKw8/CN3JO8GjXE?=
 =?iso-8859-15?Q?L4O2G5ImjLs8d2PtkUAtqlOXOzWDBxITbwWwiPFeGkocGPjUKZfjusBEw?=
 =?iso-8859-15?Q?ERI9CMb7lAWvIMgK9dqmK49f8mWhdGURb1HryPmfznxib1Ki+eQAjT4Ff?=
 =?iso-8859-15?Q?e9JaFmzWYxf/9UUVvhmPAR0a962AveHtpscJc5OoGMqSO/Bh2p+OcXa9O?=
 =?iso-8859-15?Q?M3xsu7purTkEJfCvh+UgIBMHP9SO5+QUNivev0XxWzKqMk1xuXvZYM4o+?=
 =?iso-8859-15?Q?5RDA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5050c5f8-db3f-4c3c-08de-08da1231e8a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 09:44:39.1039 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yjsv2spWveL6OZKdLEUsjt9IJ1Hw64GdC4KYHm5aaGN4ClHoI2rd+LhObrpbmIAYbarUD/U5phCFa+0i/VRWKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8212
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [RFC PATCH] multipathd: Don't keep starting TUR
 threads, if they always hang.
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E1A03059648E434A9A4443F7479BB164@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-03-29 at 22:22 -0500, Benjamin Marzinski wrote:
> If tur thead hangs, multipathd was simply creating a new thread, and
> assuming that the old thread would get cleaned up eventually. I have
> seen a case recently where there were 26000 multipathd threads on a
> system, all stuck trying to send TUR commands to path devices. The
> root
> cause of the issue was a scsi kernel issue, but it shows that the way
> multipathd currently deals with stuck threads could use some
> refinement.

Alright, let's start the discussion about dead TUR threads again ;-)
For my own records, here are links to some previous ML threads:

https://listman.redhat.com/archives/dm-devel/2018-September/036102.html
https://listman.redhat.com/archives/dm-devel/2018-October/036156.html
https://listman.redhat.com/archives/dm-devel/2018-October/036159.html
https://listman.redhat.com/archives/dm-devel/2018-October/036240.html
https://listman.redhat.com/archives/dm-devel/2018-October/036362.html

Have you assessed why the SCSI issues were causing indefinite hangs?
Was it just the TUR command hanging forever in the kernel, or some
other issue?

I have seen similar issues in the past; they were also related to SCSI
problems, IIRC. I used to think that this is just a symptom: The "dead"
threads are detached and consume a minimal amount of non-shared memory
(they are a pain when analyzing a crash dump, though).

But I agree, just continuing to start new threads forever isn't
optimal.

>=20
> Now, when one tur thread hangs, multipathd will act as it did before.
> If a second one in a row hangs, multipathd will instead wait for it
> to
> complete before starting another thread. Once the thread completes,
> the
> count is reset.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/checkers/tur.c | 23 +++++++++++++++++++++--
> =A01 file changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/checkers/tur.c
> b/libmultipath/checkers/tur.c
> index c93e4625..1bcb7576 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -26,6 +26,7 @@
> =A0
> =A0#define TUR_CMD_LEN 6
> =A0#define HEAVY_CHECK_COUNT=A0=A0=A0=A0=A0=A0 10
> +#define MAX_NR_TIMEOUTS 1

Why did you choose 1? Perhaps we should make a few more attempts?

Other than that, this looks ok to me (assuming you've tested with the
code from bdf55d6, or something similar).

Martin


> =A0
> =A0enum {
> =A0=A0=A0=A0=A0=A0=A0=A0MSG_TUR_RUNNING =3D CHECKER_FIRST_MSGID,
> @@ -54,6 +55,7 @@ struct tur_checker_context {
> =A0=A0=A0=A0=A0=A0=A0=A0int holders; /* uatomic access only */
> =A0=A0=A0=A0=A0=A0=A0=A0int msgid;
> =A0=A0=A0=A0=A0=A0=A0=A0struct checker_context ctx;
> +=A0=A0=A0=A0=A0=A0=A0unsigned int nr_timeouts;
> =A0};
> =A0
> =A0int libcheck_init (struct checker * c)
> @@ -358,8 +360,23 @@ int libcheck_check(struct checker * c)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0} else {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (uatomic_read(&ct->hol=
ders) > 1) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
The thread has been cancelled but hasn't
> quit. */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ct->nr_timeouts =3D=3D MAX_NR_TIMEOUTS) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(2, "%d:%d : waiting for
> stalled tur thread to finish",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0major(ct->devt), minor(ct-
> >devt));
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0ct->nr_timeouts++;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
The thread has been cancelled but hasn't
> quit.
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
Don't start new threads until the last
> once has
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
finished.
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ct->nr_timeouts > MAX_NR_TIMEOUTS) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0c->msgid =3D MSG_TUR_TIMEOUT;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return PATH_TIMEOUT;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ct-=
>nr_timeouts++;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
Start a new thread while the old one is
> stalled.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* We have to prevent it from interfering
> with the new
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* thread. We create a new context and leave
> the old
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* one with the stale thread, hoping it will
> clean up
> @@ -375,13 +392,15 @@ int libcheck_check(struct checker * c)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
*/
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (libcheck_init(c) !=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return PATH_UNCHECKED;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0((s=
truct tur_checker_context *)c->context)-
> >nr_timeouts =3D ct->nr_timeouts;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!uatomic_sub_return(&ct->holders, 1))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* It did terminate, eventually */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0cleanup_context(ct);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
t =3D c->context;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ct-=
>nr_timeouts =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Start new TUR checker =
*/
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&ct->l=
ock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tur_status =3D ct->state =
=3D PATH_PENDING;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

