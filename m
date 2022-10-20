Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 425BEC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666277912;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iqAFRZY5ayV2QexIt7gjYblUJirQByXSDMufpdDWBxw=;
	b=cSPchPzxjdyis4ISi5yo2YQX8vCTchAZxZ7fBEgYXKXLdZowmGziyd3+AxHenKRq0pWnYX
	bt8Ak3VvH0g2KerubKuBJy7XxpqPGrNgVvEtxLiENBudfu2uS+7Gcnz6LMuD5TaKeYndJ7
	2pSLWlM77d5mD1ViUr+lPBxLuKA0pCk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-6MLcsQQrPTWQT5ptevg6aw-1; Thu, 20 Oct 2022 10:58:30 -0400
X-MC-Unique: 6MLcsQQrPTWQT5ptevg6aw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EBB01C08970;
	Thu, 20 Oct 2022 14:58:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 683BB40C6EC2;
	Thu, 20 Oct 2022 14:58:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 45A4D1946595;
	Thu, 20 Oct 2022 14:58:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D91751946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 14:58:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE38A200A384; Thu, 20 Oct 2022 14:58:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B55082024CBE
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92B718339CB
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:28 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2055.outbound.protection.outlook.com [40.107.22.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-x9xGOz06NBW_PoRiLtKY1Q-1; Thu, 20 Oct 2022 10:58:25 -0400
X-MC-Unique: x9xGOz06NBW_PoRiLtKY1Q-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB8753.eurprd04.prod.outlook.com (2603:10a6:20b:42c::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 20 Oct
 2022 14:58:23 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 14:58:23 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/8] libmultipath: cleanup remove_feature
Thread-Index: AQHY2nM/ijFCkHbA9U6y9Cr4jKjzOq4Xc+QA
Date: Thu, 20 Oct 2022 14:58:23 +0000
Message-ID: <9435d8ddc23ddc74bc5e39072ad80b9263963c53.camel@suse.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
 <1665164144-6716-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB8753:EE_
x-ms-office365-filtering-correlation-id: dd61c9f5-0b1c-4c30-085c-08dab2ab88ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uBVuep5+VkS/QmcJgPJITqbqJ2wQM3PtyKoKceT+OYLtiYvAEGYL8BtKVDoJtRX5C441LrAG0qV7ToL99jbTMkEKsqbpbrjlzl6WsK6JL7DvSdZtLxLDhgKNhEOKJp2DmAiAL3F5B+57yTUhdKTSogiFV8bsoXQxZH0dq3QSMff4NHnaWp+FOTdiLiBm5l2SU8/6AKQCkCu5Kr4LREonVKESS+Qj2lKcuyu1JePy5HzOeHA7/oBmaa+gVuctNbVMvEVIirEI8mXQIv52A5L+twy8DacpS78Wl+nsbhjtbKwFoiHwXQaMJrjvcVKScQEApjwQ+AfeXfj6HHvKe7hBq+hWeLorKpCFpOwsunWn7mSiRKmIYGpAXiky8vvUY2WZ7jCHfbS7iXvcii1L/SdwHMBv4HVAOs++Bo5AyzEpEDBTeT0PrZhfZxNpxDAYLb4iNt00wLHIAGFKuu82JOHAKVEqhl0ANQL8kjjMao1IXvEo7JJxc4JcR2ww1ys8XJ6CAU17pOVAnRMtrES5Zo1xK3u9Gs+IIhgsav5QJrR7HT029A8XLk4v2seZO6s2gSQSWLqIOwqfdZ0vPa7eSPFd521+hEcv5FRmdRxhH4sFlOnteE0VclGHMpjlC/hke/ol5KMvl1jIqpLSQ7BBr6JKMzE8KBWI032qW1xRu4TN4BsDLpT/6ORZc7jgYYJ1Wvj4/QgRwXdpPG9OjnMRd5p9zYvzIM7105HqzK3oOUcuysKNPWGFXx7P0NHhmYwFp511t7O9a9gweeMXYic0MgJIMw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199015)(186003)(2616005)(44832011)(2906002)(71200400001)(122000001)(38100700002)(36756003)(86362001)(38070700005)(83380400001)(66556008)(6506007)(26005)(6512007)(316002)(110136005)(64756008)(8676002)(4326008)(66446008)(6486002)(41300700001)(478600001)(5660300002)(8936002)(66476007)(76116006)(66946007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?RRU9o+UZMPyPRkdgDlSsY4jIxbCWFVzK2DKVX+1PZacdPUc+cl1QJYV/j?=
 =?iso-8859-15?Q?RQsKTjeAA2dwGYblruQND10VI/RnQk2rs67O7LcFgOOBkILIK1Zp2/fJo?=
 =?iso-8859-15?Q?DDX+YaDwdgw7x4UpQ/mCdtwOHREH0q4VelOwzuUorYnRNL47xiM3Qt0tW?=
 =?iso-8859-15?Q?nZtGzoIAptOFlYOmQNs0SB9wJ+WTydA5cw1XB3ga2VWD+IZbHbR+oyveB?=
 =?iso-8859-15?Q?5U1lKe8Wo+5ISPPf42n2QIXOVNy5rwBTaN2LIAPFNz7BPS7edjUpyNoTK?=
 =?iso-8859-15?Q?5xSTu2+TD+58upt+7CZngybsoAolETSXtrfSv8i/C1nMvmAB78F+DRqrj?=
 =?iso-8859-15?Q?pCT559vmR92UIdwQyTtUGdf6srABPBxnm0nJ6wpyK3vkBE1WIRrL2Pind?=
 =?iso-8859-15?Q?v7hLNDB0byik6S7FE9WubsaVW3b6ZX6nJf1wwo9MXCQq5coy3pomsF9GZ?=
 =?iso-8859-15?Q?8LAAwNOJd++JDUyjbitQhCSeYBU51U0Z3qSYNHBtCmumWYlSB7+wKFBQ8?=
 =?iso-8859-15?Q?mlKbb60UXiQSDd7YxjVFHfyrE5NVShR6yCrU2GmxY9jazfJazvt2MQUrc?=
 =?iso-8859-15?Q?pBq4p4aI6IUYQYyUDJa9QxkEDyKUtS355i5tF5+296NnmXG+cOnov8zZi?=
 =?iso-8859-15?Q?xfx88EDgBP0mRLiZqNzW2YgsPOnCSyqdI+rfAsMdtEEFqWha2A2oJxbNs?=
 =?iso-8859-15?Q?+TAVCqKk/ypFXp4M0Jsqc9rFB/cQFk75q5VFWKA1mioKkBedKuPec+oYI?=
 =?iso-8859-15?Q?jiipnqf21lJbb3N0PbkL7nJd1B6Qa384OowmRFRlI5K5u7vnmFbmUDZcj?=
 =?iso-8859-15?Q?XL1wLsHeY7BhxQiAbUar2YaF57LYCs8i0P2JtEi7V2v+ib4osAw8MQ55p?=
 =?iso-8859-15?Q?icdR4004yW7xcwJkC4tb5HW5HOpwO2hze6TFyZnBbLfjOcuHR9lG7MvJF?=
 =?iso-8859-15?Q?+fPNjci+j4XAHJX5zb2tCI6ZXHYGC5iI14JbIVYDFH2kive6dJyNf+pBC?=
 =?iso-8859-15?Q?6EZrOMKR3DiDY1GHsK1qbJX7G6msZWCIVXFeDBVH/4l08qxn8goNPRCRP?=
 =?iso-8859-15?Q?Hy/8FjvrsmNnDWuopK2Pwy4QnMaq4c/K8WlE37muUOV1O4QE+vgLv2x0q?=
 =?iso-8859-15?Q?n/q7Deoyt04x5E5z9vHHQYohquh9A2v+jAIWrK9X1Lhr8wLtKI1k9B3SI?=
 =?iso-8859-15?Q?Qzv6iiagWj8P9gP4J2l6B1BdyzIlBbMC3SRckgsXtriE+yKJhkotXhs8Q?=
 =?iso-8859-15?Q?Ceb5H55MEVQcGsYlQ55ykGd2BmUzPs/LMagz58C9mWTNb5xITEg9BSEh6?=
 =?iso-8859-15?Q?X+YD8vlxraACyJtX6yRzvCILy1q6skOrMqpjabcqvocVF8Itq5RaDADJ5?=
 =?iso-8859-15?Q?bVDPhSpJTWWhXRSkJEREtYWLl2qw/aOgJj5OlRj5PhApV4VXarp4/SWC+?=
 =?iso-8859-15?Q?whdHyWWrCHf3o2EEThu+lrglMv6izR+ShSoNtENjsX6cmrr3RKPfB9j+2?=
 =?iso-8859-15?Q?kdbDukslaCIBc8AumtEffRKnoo22pnwq388JUn+hI4TP/amdsKV44wN3W?=
 =?iso-8859-15?Q?zPxGq2iGRxW17kmO2oZEfVqbnfHzowPaeuS7M5TbSSYmD/QCKgpSh9YUe?=
 =?iso-8859-15?Q?7y+m0qzaA/M5cL8TPQcS9popt33z4zGQquKET2zNqQpkxceEtrjrnh8eS?=
 =?iso-8859-15?Q?eLcDxBWPNNrpCBUhdQ8gJaRCrw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd61c9f5-0b1c-4c30-085c-08dab2ab88ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 14:58:23.2224 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DTMMzJyTHwzEnWzxWlIDfwEe3eEepS8xP0WIdUyKXhF7miuw79XLuVSg0LOXwVP+oQqG63L2FftBNpQjZtlgyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8753
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 1/8] libmultipath: cleanup remove_feature
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <150782D7AC27A448842560D0734B26CD@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> remove_feature() didn't correctly handle feature strings that used
> whitespace other than spaces, which the kernel allows. It also didn't
> check if the feature string to be removed was part of a larger
> feature
> token. Finally, it did a lot of unnecessary work. By failing if the
> feature string to be removed contains leading or trailing whitespace,
> the function can be significanly simplified.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

This is part of the code that always makes me think  we should clean it
up more thoroughly. Therefore I've added some remarks below.

As you've started working on this, perhaps you want to follow up?
If not, fine with me for now.

Martin

> ---
> =A0libmultipath/structs.c | 82 +++++++++++++++-------------------------
> --
> =A01 file changed, 29 insertions(+), 53 deletions(-)
>=20
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 49621cb3..1f9945e0 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -6,6 +6,7 @@
> =A0#include <unistd.h>
> =A0#include <libdevmapper.h>
> =A0#include <libudev.h>
> +#include <ctype.h>
> =A0
> =A0#include "checkers.h"
> =A0#include "vector.h"
> @@ -663,7 +664,7 @@ int add_feature(char **f, const char *n)
> =A0
> =A0int remove_feature(char **f, const char *o)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0int c =3D 0, d, l;
> +=A0=A0=A0=A0=A0=A0=A0int c =3D 0, d;
> =A0=A0=A0=A0=A0=A0=A0=A0char *e, *p, *n;
> =A0=A0=A0=A0=A0=A0=A0=A0const char *q;

I see you sticked to the conventions ;-) but the variable naming
in this function could be improved.

> =A0
> @@ -674,33 +675,35 @@ int remove_feature(char **f, const char *o)
> =A0=A0=A0=A0=A0=A0=A0=A0if (!o || *o =3D=3D '\0')
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0/* Check if not present */
> -=A0=A0=A0=A0=A0=A0=A0if (!strstr(*f, o))
> +=A0=A0=A0=A0=A0=A0=A0d =3D strlen(o);
> +=A0=A0=A0=A0=A0=A0=A0if (isspace(*o) || isspace(*(o + d - 1))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "internal error:=
 feature \"%s\" has
> leading or trailing spaces", o);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0/* Check if present and not part of a larger featur=
e token*/
> +=A0=A0=A0=A0=A0=A0=A0p =3D *f + 1; /* the size must be at the start of t=
he features
> string */
> +=A0=A0=A0=A0=A0=A0=A0while ((p =3D strstr(p, o)) !=3D NULL) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (isspace(*(p - 1)) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (isspace(*(p + d)=
) || *(p + d) =3D=3D '\0'))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D d;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (!p)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/* Get feature count */
> =A0=A0=A0=A0=A0=A0=A0=A0c =3D strtoul(*f, &e, 10);
> -=A0=A0=A0=A0=A0=A0=A0if (*f =3D=3D e)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* parse error */
> +=A0=A0=A0=A0=A0=A0=A0if (*f =3D=3D e || !isspace(*e)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "parse error in =
feature string \"%s\"",
> *f);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> -
> -=A0=A0=A0=A0=A0=A0=A0/* Normalize features */
> -=A0=A0=A0=A0=A0=A0=A0while (*o =3D=3D ' ') {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0o++;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0/* Just spaces, return */
> -=A0=A0=A0=A0=A0=A0=A0if (*o =3D=3D '\0')
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> -=A0=A0=A0=A0=A0=A0=A0q =3D o + strlen(o);
> -=A0=A0=A0=A0=A0=A0=A0while (*q =3D=3D ' ')
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0q--;
> -=A0=A0=A0=A0=A0=A0=A0d =3D (int)(q - o);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/* Update feature count */
> =A0=A0=A0=A0=A0=A0=A0=A0c--;
> =A0=A0=A0=A0=A0=A0=A0=A0q =3D o;
> -=A0=A0=A0=A0=A0=A0=A0while (q[0] !=3D '\0') {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (q[0] =3D=3D ' ' && q[1]=
 !=3D ' ' && q[1] !=3D '\0')
> +=A0=A0=A0=A0=A0=A0=A0while (*q !=3D '\0') {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (isspace(*q) && !isspace=
(*(q + 1)) && *(q + 1) !=3D
> '\0')
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
--;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0q++;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> @@ -714,15 +717,8 @@ int remove_feature(char **f, const char *o)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0/* Search feature to be removed */
> -=A0=A0=A0=A0=A0=A0=A0e =3D strstr(*f, o);
> -=A0=A0=A0=A0=A0=A0=A0if (!e)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Not found, return */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> -
> =A0=A0=A0=A0=A0=A0=A0=A0/* Update feature count space */
> -=A0=A0=A0=A0=A0=A0=A0l =3D strlen(*f) - d;
> -=A0=A0=A0=A0=A0=A0=A0n =3D=A0 malloc(l + 1);
> +=A0=A0=A0=A0=A0=A0=A0n =3D=A0 malloc(strlen(*f) - d + 1);

Given that this function never increases the length of the feature
string, we might as well implement it without the allocating a new
string.=20

> =A0=A0=A0=A0=A0=A0=A0=A0if (!n)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> @@ -732,36 +728,16 @@ int remove_feature(char **f, const char *o)
> =A0=A0=A0=A0=A0=A0=A0=A0 * Copy existing features up to the feature
> =A0=A0=A0=A0=A0=A0=A0=A0 * about to be removed
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0p =3D strchr(*f, ' ');
> -=A0=A0=A0=A0=A0=A0=A0if (!p) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Internal error, feature =
string inconsistent */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(n);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> -=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0while (*p =3D=3D ' ')
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p++;
> -=A0=A0=A0=A0=A0=A0=A0p--;
> -=A0=A0=A0=A0=A0=A0=A0if (e !=3D p) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0do {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e--=
;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0d++=
;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} while (*e =3D=3D ' ');
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e++; d--;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strncat(n, p, (size_t)(e - =
p));
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D (size_t)(e - p);
> -=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0strncat(n, e, (size_t)(p - e));
> =A0=A0=A0=A0=A0=A0=A0=A0/* Skip feature to be removed */
> =A0=A0=A0=A0=A0=A0=A0=A0p +=3D d;
> -
> =A0=A0=A0=A0=A0=A0=A0=A0/* Copy remaining features */
> -=A0=A0=A0=A0=A0=A0=A0if (strlen(p)) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (*p =3D=3D ' ')
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p++=
;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strlen(p)) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p--=
;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0str=
cat(n, p);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0while (isspace(*p))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p++;
> +=A0=A0=A0=A0=A0=A0=A0if (*p !=3D '\0')
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strcat(n, p);
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strchop(n);
> =A0
> =A0out:
> =A0=A0=A0=A0=A0=A0=A0=A0free(*f);



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

