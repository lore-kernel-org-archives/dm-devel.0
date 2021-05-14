Return-Path: <SRS0=HAWy=KJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A9CC43461
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 21:01:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACB5061401
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 21:01:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACB5061401
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-GoEF6RIHOP6h8Afz2ivv7w-1; Fri, 14 May 2021 17:01:55 -0400
X-MC-Unique: GoEF6RIHOP6h8Afz2ivv7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DD52107ACC7;
	Fri, 14 May 2021 21:01:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 020AF10016F2;
	Fri, 14 May 2021 21:01:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D4FA180B463;
	Fri, 14 May 2021 21:01:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14EL1mlV015993 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 May 2021 17:01:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 150E5210EA26; Fri, 14 May 2021 21:01:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F696210EA25
	for <dm-devel@redhat.com>; Fri, 14 May 2021 21:01:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AA49833942
	for <dm-devel@redhat.com>; Fri, 14 May 2021 21:01:45 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-148-7mGdQzLtPrObi2o9mHA6zw-1;
	Fri, 14 May 2021 17:01:43 -0400
X-MC-Unique: 7mGdQzLtPrObi2o9mHA6zw-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-40-obMn6fF4ORC-eZ9AWj6yHg-1; Fri, 14 May 2021 23:01:40 +0200
X-MC-Unique: obMn6fF4ORC-eZ9AWj6yHg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7580.eurprd04.prod.outlook.com (2603:10a6:10:1f7::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25;
	Fri, 14 May 2021 21:01:38 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4129.028;
	Fri, 14 May 2021 21:01:38 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [dm-devel] [PATCH v3 3/6] multipathd: fix ev_remove_path return
	code handling
Thread-Index: AQHXSP1MZLJh752IHEGgXHglsdoWYqrjdqwA
Date: Fri, 14 May 2021 21:01:38 +0000
Message-ID: <5513097ae80b7ea8eaf84a0ef8fe1eaaa17f5816.camel@suse.com>
References: <1621023060-20011-1-git-send-email-bmarzins@redhat.com>
	<1621023060-20011-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1621023060-20011-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 496a8861-f4af-47a5-c55d-08d9171b778f
x-ms-traffictypediagnostic: DBBPR04MB7580:
x-microsoft-antispam-prvs: <DBBPR04MB75800AC7C3B512C09ABD3F8EFC509@DBBPR04MB7580.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: R5OtUrREGQFy8zFPiexlQ52Lag/jOdepJH0TdFl4fDoc0nLMcyG7hF7xb/UB/UkCGimZfkF+nt4jVKOQIp5CCeXrN6IIgB+7zZqSze4QzryuCdjoBIUqPVr3x+GQKVpVAbqtjYJRZ4RdTTaED5moMSvihcbR+HufT5s9LwwDx0vzYgEaU0uAwppxDpkbs57anCfsw6MMu4fOnmiQ75VRyjdc9QtKhQ0Hmw9WUqc6uIfzVrJsMDY2DyhAPV3xgZ2RGtxbi/PWPSNeAEv7ulzHf0hoASB5knOQaK6jKnpDJt1YTlSYzo0+B8Ugbfe+XHIxSGIsdm5w91Jey8aMdru4koUNB+tXpzpPa2QCQUizcGVItjw7V7CTV4OiYgJ/7t6XP0RdZCtH5pFXflIwdDc67DP6Rp16zrqW0QElRU1vl2BQoyXEtzlSpv7ORsqQgfugacx3l265shDdfPBARw8JfvFiIzjlGXjvuc4dffX8q5HoVYJu0JunOfAwExf6LaaBszNogWh4kmqwPYs4HK0HUWS5LjZuYIgulKa/IfJR1GbXKT44mzHikyBlnHL8HXZV9q18pyoN3VBTGTLoNycA3VjKSBMc8DwoG3rHY4+aZ0g=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(396003)(346002)(366004)(39850400004)(136003)(86362001)(36756003)(8676002)(6512007)(8936002)(44832011)(83380400001)(122000001)(5660300002)(71200400001)(186003)(4326008)(38100700002)(110136005)(6486002)(2906002)(91956017)(2616005)(6506007)(66946007)(66476007)(76116006)(66556008)(64756008)(478600001)(66446008)(316002)(26005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?kwtDnl8deRKho0cW4cxFWJBonIvV7TGrWa1WMER7TUt12UGr/Lmx2v7m7?=
	=?iso-8859-15?Q?9jd3JNLev42pOXxZNw937fRklbz4nXisSpG9UqWoduNF0gLpexuCyk3zk?=
	=?iso-8859-15?Q?xuFpmPthR0I5Zfl6PmyVH5odg7UKp0E3dBG4r3xSkZXTA6BxTa7ZifBCL?=
	=?iso-8859-15?Q?Xq1jpQgzz/RBClKz45h9pmNkzSUbmVmEA+yBM9840LslG0MyiYsYlgKgf?=
	=?iso-8859-15?Q?jL0x7TtS3a1XbhsQFx64TLtXCJjKV/Wd0pNuckg+DwJMTH2x/eo0rSzlz?=
	=?iso-8859-15?Q?ZMtlhtCv1TVDXxfN5BdmKAtoywq4Os/1mP5cVw1lH1bx1EGVewI9GWBaX?=
	=?iso-8859-15?Q?LD3x3GhDH5BpFTqT5SiwZpKSMQ2sVNImSALBP25hrA7o9GO0ITqHYgwHY?=
	=?iso-8859-15?Q?NemfV2gdBVB7gi5uGIFxHPQa5XuIT5TKEDQP68q37eJLKQDSa2weRj11z?=
	=?iso-8859-15?Q?BWY2z+psQ/CHn8CizvoKtYscU1eLxq7NqeQlVJFpMCA0DyQT8gESRwuWv?=
	=?iso-8859-15?Q?2TYYsOO8ilVZcjTq2ElY9fwrcwlLRWmM4SA7dJHZd9U09JJs8XxyZiS8G?=
	=?iso-8859-15?Q?fsseNfmCQGP12VQPyFvvmXB4LTQNdRH6Q75dbIE3GSnalya2iIuyYrlXe?=
	=?iso-8859-15?Q?sxfDBnq2o7KAgmbBzlKi2Zp7N3IxaRNzM6aDL6gbViDir2p+Vu7QSmfxN?=
	=?iso-8859-15?Q?x5jLuiIzwtzHF/ovPVY+fMiBDpK8HdViULdw5jpNy5ljrWlxOWiVGExYJ?=
	=?iso-8859-15?Q?kXbHEwtG2onAf0oMVt3fSITas6KasACpwsj211hga+cnyuj2nB/+dMNrN?=
	=?iso-8859-15?Q?cybJCDhpqqKVycserRAOvwW+kHcjisuCSrBTUVAXnXj5N+p8GrqnE0eVG?=
	=?iso-8859-15?Q?J3rPFKVFCvqGREwORxzNtSrYsPges/nCU/AHdzk+69TCxcI64bnqZ7O4N?=
	=?iso-8859-15?Q?oO68PrxLEocvbPOn32BiN6S2HpsZ3p+Bbpy0bHY83CN3CNWOjh3HSlDM6?=
	=?iso-8859-15?Q?PT9/bD1ofMJp04WqzLyG+k0f+0/uaQl5uXPfh8dIEYxL6agZOFEK/6iIC?=
	=?iso-8859-15?Q?+Lavk9II2h0n6UHkHrYAWQDtC1yGViEQKtP7ARl3ORngJq6MwmGPsgM3t?=
	=?iso-8859-15?Q?tftrTSwAnquQhuTZwqhj44rF5a2OiS3iVQVMft5GiQz8D7G0ERczVWzW6?=
	=?iso-8859-15?Q?QqZ0q625Ln2nMqfnR1ymEsYNxCSV1zi5Wf5QQBVTFSGKiaUXndzQpnZRg?=
	=?iso-8859-15?Q?11ieFgYmQoypvP6VdxRFK/NohDQkHPHJOQNMWcY1bZ4vDc2VXczbmZiyG?=
	=?iso-8859-15?Q?B29wLt42DIPRLcV92Zgov2DfoJIDVISJUjqHsvjGR5YmB+MxpoF7t5Xwr?=
	=?iso-8859-15?Q?/JO06mPTlGtdCFl0wrL+U5WnMjy/y1enV?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496a8861-f4af-47a5-c55d-08d9171b778f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 21:01:38.6263 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K7M+5/Qb0iPy52189utgTwzlc2CKpvS9/PrMDqjd8TIT7lkmKi+NKW+iA/6duXi2WPi7vGG/qeFXLI0Z2uLcmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7580
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14EL1mlV015993
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 3/6] multipathd: fix ev_remove_path return
 code handling
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
Content-ID: <04CFEC78166E50488B4E7C081BA9BB46@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-05-14 at 15:10 -0500, Benjamin Marzinski wrote:
> When ev_remove_path() returned success, callers assumed that the path
> (and possibly the map) had been removed.=A0 When ev_remove_path()
> returned
> failure, callers assumed that the path had not been removed. However,
> the path could be removed on both success or failure. This could
> cause
> callers to dereference the path after it was removed.
>=20
> To deal with this, make ev_remove_path() return a different symbolic
> value for each outcome, and make the callers react appropriately for
> the different values. Found by coverity.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Almost perfect - I still have one nit below.

> ---
> =A0multipathd/cli_handlers.c | 14 +++++++++++--
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0 | 41 ++++++++++++++++++++---=
--------------
> --
> =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0 | 14 +++++++++++++
> =A03 files changed, 47 insertions(+), 22 deletions(-)
>=20
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 1de6ad8e..1462ea84 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -752,7 +752,8 @@ cli_add_path (void * v, char ** reply, int * len,
> void * data)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* Have the checker reinstate this
> path asap */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->tick =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} e=
lse if (!ev_remove_path(pp, vecs, true))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} e=
lse if (ev_remove_path(pp, vecs, true) &
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 REMOVE_PATH_SUCCESS)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* Path removed in ev_remove_path()
> */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp =3D NULL;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse {
> @@ -813,6 +814,7 @@ cli_del_path (void * v, char ** reply, int * len,
> void * data)
> =A0=A0=A0=A0=A0=A0=A0=A0struct vectors * vecs =3D (struct vectors *)data;
> =A0=A0=A0=A0=A0=A0=A0=A0char * param =3D get_keyparam(v, PATH);
> =A0=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +=A0=A0=A0=A0=A0=A0=A0int ret;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0param =3D convert_dev(param, 1);
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: remove path (operator)", param);
> @@ -821,7 +823,15 @@ cli_del_path (void * v, char ** reply, int *
> len, void * data)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: path alre=
ady removed", param);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0return ev_remove_path(pp, vecs, 1);
> +=A0=A0=A0=A0=A0=A0=A0ret =3D ev_remove_path(pp, vecs, 1);
> +=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D REMOVE_PATH_DELAY) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*reply =3D strdup("delayed\=
n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*len =3D strlen(*reply) + 1=
;
> +=A0=A0=A0=A0=A0=A0=A0} else if (ret =3D=3D REMOVE_PATH_MAP_ERROR) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*reply =3D strdup("map relo=
ad error. removed\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*len =3D strlen(*reply) + 1=
;
> +=A0=A0=A0=A0=A0=A0=A0}

So you went for the new replies. Fine with me, let's see if anyone
complains. But you should check the result of strdup() before calling
strlen():

                 *reply =3D strdup("delayed\n");
                 if (*reply)
                        *len =3D strlen(*reply) + 1;                   =20
=A0                else=A0{
                        *len =3D 0;
                        ret =3D REMOVE_PATH_FAILURE;
                 }

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

