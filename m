Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D4A0C38142
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238420;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=woTydaxVmtdV+jLI4m7fzUFbeE2N5ShLvTpQIoBgWBQ=;
	b=AKucJM5kHY5ddKGXGInGHTB+yi54C2/ZCV3z56hxKvn8HBEGLGC+7WTPq0v2ZQ6EVRdCIM
	hHb2KQXmBSzEAE+YSDwOdTNQXbI4wVC6ZpvVqP5Po+3UPxiK5hu0LdSUOOqkIFHdKtijYb
	d+LwzOhnJplogwyngk06wZABIlBYims=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-O_9WgyvNOxKnqUb41T3UNg-1; Wed, 01 Feb 2023 03:00:17 -0500
X-MC-Unique: O_9WgyvNOxKnqUb41T3UNg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB6461C05AF5;
	Wed,  1 Feb 2023 08:00:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B694A2026D4B;
	Wed,  1 Feb 2023 08:00:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 902981946A67;
	Wed,  1 Feb 2023 08:00:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 74C9019465BB
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 08:00:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5882E112132D; Wed,  1 Feb 2023 08:00:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5019E112132C
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 08:00:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BB21811E6E
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 08:00:12 +0000 (UTC)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01on2059.outbound.protection.outlook.com [40.107.14.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-JseJEdEfP2qG5Hhjq4af6w-1; Wed, 01 Feb 2023 03:00:04 -0500
X-MC-Unique: JseJEdEfP2qG5Hhjq4af6w-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAXPR04MB8475.eurprd04.prod.outlook.com (2603:10a6:102:1de::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 08:00:01 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%9]) with mapi id 15.20.6043.028; Wed, 1 Feb 2023
 08:00:00 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/4] libmultipath: cleanup ACT_CREATE code in
 select_action
Thread-Index: AQHZNasRS4NOt/keg0KBAX4erCoE7665uwaA
Date: Wed, 1 Feb 2023 08:00:00 +0000
Message-ID: <73f8cf0b188f42c7b52ebc22dd203274fa20a0c1.camel@suse.com>
References: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
 <1675193661-1147-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675193661-1147-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAXPR04MB8475:EE_
x-ms-office365-filtering-correlation-id: 7535b791-1e47-4096-6dbb-08db042a51b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: OuYJTQXdeKvN7idmuOLDtbLafrIl6yNdOBYsLMszgFHHm88WamUvnKAC2AmSMRLQp53y7BpMdGUR/MvnOrpcxQnTyHTBBCd0v2G/lgRbQnDq9oC9of6QjHbSyYsJWOzhoCxSFsEUUcsDoZH+TbOOVzzMaakOteBzo/cpwALY5FUSohS/QMO/TN8hCxgTlyj0BfovnMK9XpB5A0bNqes+YWtdzQpH9MaJH1To/Yt2WSnACEpa5sWBXK4OPQtCBW+gNEhOltipk2SkQBxY1I9k31cucng3LhyAlNjIKG8w7Dw2ivuGeR6MyanF89maB2ZTuMwxbITKhUxt71yyBJQ7PtmEkXlZUsrO///tmC417UQFI3d/HXwNQMLYtuHuCLgvYQxsP6VBOY5s069z2j+6FoAJRnFhEjAFhuC4k0w6A2MZ5wd+rGQTr+8j/XIiilW3W/jgTaDn/HIRFMviQLIdXceFz5uG3J0NShDTryn1FANPIltm2NPETraUQcRMcze7ScIxnQW/PjCfFBVrJQZVC0qZuzzW0+cO1uLi7ze0BoogyMcXIwK7I3iK2l+IKCQaRvJRirwEgzw+CLaDzSFR7DaiFAuRYQzPgHcsV1eni3lTg3SY/gcINje3LZ1ZR+SJNCyA6WNRJgbz1lCTZU3ek/ZMHxlK1AY5Teciet4T1bw7czuzeZgendfhoGV5wPpTa84/OKWI2IXX6qPwz6Z4qA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199018)(86362001)(36756003)(38070700005)(38100700002)(122000001)(110136005)(66946007)(64756008)(66556008)(66476007)(66446008)(76116006)(8936002)(4326008)(91956017)(316002)(8676002)(41300700001)(44832011)(2906002)(83380400001)(2616005)(478600001)(6486002)(186003)(26005)(6512007)(6506007)(71200400001)(5660300002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?XpNH4R5wV1TTWcmdxVF/7Ch8AlSu9hnk7Q78f9UkYINf2bpvYIQ4fMeBR?=
 =?iso-8859-15?Q?Bl+uOBdMJ+cxqFxgugYdvMwaI4+TVvLJBi39RxGk60zpnOM640Q2DdtIe?=
 =?iso-8859-15?Q?F8qWbhcQI9uGJpw+DawcwXOElpCaXkv0Lhay6o2blGwpE9n7R8VK8LtgR?=
 =?iso-8859-15?Q?+zOy3I/JOsn6dhQKssAIydTZjpHQg0adGSkJUVeCpCTOXEzUiB9J6IBLR?=
 =?iso-8859-15?Q?Nyd9g4nR3sc5KiWIQtaISlYj1DBMMKuXWhyq59w5PahfeNw5gNKRnL+/N?=
 =?iso-8859-15?Q?uE3V66gbKVTDvN2LKVK+mLewJWX/BYp+s78vnkvqlueq4+iMOZyGulN8P?=
 =?iso-8859-15?Q?vWpSE54UjnUwf3og/zJIXbYPlEPG8AgbBjmpNzgJGglUnCIJw8Qtda+ac?=
 =?iso-8859-15?Q?ZOK2XQ0+I3ceBU9RzY/k9NmTIcRhxdS1rrczdCwh7tks3Ki3EPulnlr41?=
 =?iso-8859-15?Q?FtQr7I74mXVzcqziKxMSTLW6LdAtWJGCednWftu8qlbh7t/lbbehDpGCO?=
 =?iso-8859-15?Q?wCRTObup/MYVNMKntw5qQuExd7yuOi8vANp2p0r37lYYVNkz9hJ/Me445?=
 =?iso-8859-15?Q?awAjhuRcdMnQ6UDB9iKSE0fCoj5XhPBLjcBnIk2mgZIN8veQMfdVUf8CS?=
 =?iso-8859-15?Q?YzelB+T6N30lL45lz2xK6xgxN2K3vv0vnQeY9HQNHDB/faFHtjnCglnNs?=
 =?iso-8859-15?Q?jWCkwvb1/L3vYnORLvW6kZ87GwUCfnSTAid688imBJUy/gTEvaVAOeBt0?=
 =?iso-8859-15?Q?FSFyOf7MluW1PN/KSPj0BSpWAAlz9E3pRJYXkf3JrJ1v5N+BWjQvDZQSc?=
 =?iso-8859-15?Q?CmRkDX4J6xhhB94t6ZNoRLg7gv/HfFA0VYRngdH0qxLo7tRTh3k/7X1Ru?=
 =?iso-8859-15?Q?OvqmuthundPgjMLud9UuiY2GArm0VpguID77+FFcgEFWZMT2/yM0iyYCj?=
 =?iso-8859-15?Q?HNOZpaP4b83NkLdad+t6TA8eNYJQR6q/dCqpeHlX6zA0YQUpa09/c9lOZ?=
 =?iso-8859-15?Q?FfkJlsgN7OdD+vfmhLYlBNKlbM/A8FQpPD8zoaMv+M4Cx5cQjiL/lYF+Z?=
 =?iso-8859-15?Q?Ru3GWuPkh2AHz8XckiCZPpLDdlf06zF20OsIHPyxbs7f7yJQpOzzMxZ9n?=
 =?iso-8859-15?Q?e1U6L1wygiU6vyBEcFQ+u3urQFBRuvw+lfuZiZtI9SCgmR1ydqTzHgKOY?=
 =?iso-8859-15?Q?5wc6IejFznZr0dQODylKtZznEmEDGooJL/4oCXuYmhGafSXOW300wjAzk?=
 =?iso-8859-15?Q?S9bJVm3CnRR+68OhmYdjWNOESqhZ1WlhpdzBD4K2xg4MKB04Xm+cFZMXE?=
 =?iso-8859-15?Q?B/5YsRzJnpXJIpIRcrt7NMC3ucHK0f5drHzs8LmY8KSc5UoewWQhP5soN?=
 =?iso-8859-15?Q?2Aff3/3Ai8RNoxtBKz3kVqbfWnLl0aLU0WVfDvD9v7PeE7XHpoVakr832?=
 =?iso-8859-15?Q?iJit4bO0WxmhQBgcHRT1C1CF2JUKH3IwTdDhp7p+R2labvR7UTWUsft+X?=
 =?iso-8859-15?Q?KiPdGyqdz0+0VTH3mTgn3djFnmsc5XJvow0p039317WiD3C7v/GzN0ruH?=
 =?iso-8859-15?Q?BNgaPvyRG5gw3wMwDAaorQqAkqcsIyACQoqmmkAZ9AeRA80YYzwLbEDCR?=
 =?iso-8859-15?Q?HPPnDqikpIEaSin02jQcWicBVu1T1Sanj9PxtxDUuAWFeDe5LDiPHsqmJ?=
 =?iso-8859-15?Q?hFf5etWm8MU82792x6agUsAuYA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7535b791-1e47-4096-6dbb-08db042a51b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 08:00:00.8948 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P8eZmG87kD66jyXpFvFKzI0BzmCb9wtqny17A3z1ct3UC3SyP/X2Pdxx7hzxvDxFE3qQ1SEpXOmU1aV1+4Z/Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8475
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 3/4] libmultipath: cleanup ACT_CREATE code in
 select_action
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4D8E1BC2D599974E805FA3B4A68D972B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-01-31 at 13:34 -0600, Benjamin Marzinski wrote:
> Combine the two separate blocks that set ACT_CREATE into one.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/configure.c | 38 +++++++++++++++++---------------------
> =A01 file changed, 17 insertions(+), 21 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 6811e661..e870e0f6 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -686,33 +686,29 @@ void select_action (struct multipath *mpp,
> const struct _vector *curmp,
> =A0=A0=A0=A0=A0=A0=A0=A0if (mpp->need_reload || (cmpp && cmpp->need_reloa=
d))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0force_reload =3D 1;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (!cmpp_by_name) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (cmpp) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "%s: rename %s to %s", mpp->wwid,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0cmpp->alias, mpp->alias);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0str=
lcpy(mpp->alias_old, cmpp->alias,
> WWID_SIZE);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->action =3D ACT_RENAME;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(force_reload) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =3D 1;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_FORCERENAME;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn;
> +=A0=A0=A0=A0=A0=A0=A0if (!cmpp) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (cmpp_by_name) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(1, "%s: can't use alias \"%s\" used
> by %s, falling back to WWID",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0mpp->wwid, mpp->alias, cmpp_by_name-
> >wwid);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
We can do this because wwid wasn't found
> */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fre=
e(mpp->alias);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->alias =3D strdup(mpp->wwid);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_CREAT=
E;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_CRE=
ATE (map does not exist)",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->alias);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_CRE=
ATE (map does not
> exist%s)",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->alias, cmpp_by_name ? ", name changed" :
> "");
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (!cmpp) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: can't use a=
lias \"%s\" used by %s,
> falling back to WWID",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->wwid, mpp->alias, cmpp_by_name->wwid);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* We can do this because w=
wid wasn't found */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(mpp->alias);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias =3D strdup(mpp->=
wwid);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_CREATE;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_CRE=
ATE (map does not exist,
> name changed)",
> +=A0=A0=A0=A0=A0=A0=A0if (!cmpp_by_name) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: rename %s t=
o %s", mpp->wwid, cmpp-
> >alias,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->alias);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strlcpy(mpp->alias_old, cmp=
p->alias, WWID_SIZE);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RENAME;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (force_reload) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->force_udev_reload =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->action =3D ACT_FORCERENAME;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

