Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62038C352A1
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 20:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669839072;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+3dzuRBVufIsChbtGpGVzbYUmYFiscn1ArZH8SEgcdA=;
	b=H0Rbox6xdzVnUc1dmGXGxvJ4xfdc2KNftAhEy7Zg+tepfRYT7BVLGPbdFBl/b+VjmcXI5b
	pUVsgQd0R5NVfRNU5XMYnCbSqZTk4ljZFj9hjhwXhfm1S5NtEyyGYmXonanCjqis8Ks+zh
	RaHmEsO9ai/TYLDcd/2Ul2V8ARx0bIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-04r93ASZOnq-cyBuZsuLmA-1; Wed, 30 Nov 2022 15:11:10 -0500
X-MC-Unique: 04r93ASZOnq-cyBuZsuLmA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0AF0186E242;
	Wed, 30 Nov 2022 20:11:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 880A6492B15;
	Wed, 30 Nov 2022 20:11:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 598CF19465A2;
	Wed, 30 Nov 2022 20:11:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 51BB21946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 19:52:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE67A2166B40; Wed, 30 Nov 2022 19:52:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C62BD2166B26
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 19:52:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3CCB800186
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 19:52:42 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04on2077.outbound.protection.outlook.com [40.107.6.77]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-s687TijDOw-j1Nf07zQdvg-1; Wed, 30 Nov 2022 14:52:39 -0500
X-MC-Unique: s687TijDOw-j1Nf07zQdvg-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM9PR04MB8097.eurprd04.prod.outlook.com (2603:10a6:20b:3e9::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Wed, 30 Nov
 2022 19:52:36 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%6]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 19:52:36 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/2] libmpathpersist: fix command keyword ordering
Thread-Index: AQHZBHguZVB6y1CbzkK6KGJQ5+qysa5X4aSA
Date: Wed, 30 Nov 2022 19:52:36 +0000
Message-ID: <d00cb36a9f16ff4ccd5cee38328cf27b45fa0ea0.camel@suse.com>
References: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
 <1669784208-9754-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1669784208-9754-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM9PR04MB8097:EE_
x-ms-office365-filtering-correlation-id: 34f7ef79-fece-40e4-7f39-08dad30c6df3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Pk1n8YBX2WE8Qyn4Ua+nFGfREU088Y0MKfZYXfpMargy5fgwnbAi0c9EeajXhdUgeoy3uBvOKQQpfKi0TnLW8CijWWLEY74vyMFEsMUhJE2bP4/+N0RCr+mWOGtgj1NWlVra2FaOAotpNegQFRwT70isFSe+5KvqN1e9RFKFxH79meNHBEgXlOjrDSlV2+SvDC3lwpcYREzLQVkPDAUrMgq5WX9n3SkABeFKD7ZGM4Vz+nO3bViu6dqtCq6AAe1rFaOIM9GM4EMxcEu0xrylSkS7vrNrVrFnJKwFX46NLwBySrF26UHoSc80pLzWu3FZvzKvTVCjBic8hcZrlFNK6KisyfvmjRraitfrxc9WehMC8HXGSxmPiJsria+j2VBbaent87/Zx2vm66cYG4Sllp4pBe40FfdhfX5iw4fogRwcM450xcrEGnZq2/AJVi38hp8vxhvZC2RdNJZRwQhBkTbCRPHfymmnG2FCaMWkd4lYH3r94h36unznN+SDXaZMFD7ovqbRTzM7oRtEs5iJ+hhgM8ArGortYGdmlSlFnenxS66TqDyqzmhOO+MDugHvUXnO/JpfhjKUq87zJ30/jxsYHlqj8Nhxx6TufNBkP5TBbXbdfs/tk4dqiu38vkAFf0SpKnKaG/W8gb3NPUGl96V4H1ghysKtfy1GZbjdjlsnb9O/LB/D5z+uE86CgRY+F7iAeNWdCBIsySXAI2koxA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(2906002)(122000001)(36756003)(44832011)(41300700001)(86362001)(66446008)(91956017)(8936002)(66556008)(66476007)(76116006)(64756008)(66946007)(5660300002)(4001150100001)(8676002)(6486002)(38070700005)(316002)(38100700002)(478600001)(4326008)(110136005)(71200400001)(6512007)(83380400001)(6506007)(26005)(2616005)(54906003)(186003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?5c+5bjO8Y3EXXglVR/9Xpy0ZIgCAmtIV4PoQUenrRhnfTIjIaPM+yN89G?=
 =?iso-8859-15?Q?HIwuKj4NKUP7BPhi4e1ebU+b/ZoCGeEF6LXnLIixKqJG6LLI/I0pMrD7F?=
 =?iso-8859-15?Q?9cTT8kGEYUQcKEx2JiUSqyaONMaCHH2Xp99NyAi0FwzRJyX/9kYuHkKMQ?=
 =?iso-8859-15?Q?vKWu6eoXPJrb2UHUZIAedk09A3xYn7PWHidPZfNES8+CnX0s7O5aziHZS?=
 =?iso-8859-15?Q?OxsSbNabRMY8+ymSPVEoDT7gT1nh/8wyfLMy5hNo+wQPen2CvrzLIQeg6?=
 =?iso-8859-15?Q?p0s3B0XbiyQBjUWl05uRey0D3Ddo+6dLsC6ofSy+QRKgI/OxkRPWeYfnX?=
 =?iso-8859-15?Q?HaobNTWybvEZznRzVdABv63PoKkpJB+YsmFymUkjHL9gaUJ13UHI86TTD?=
 =?iso-8859-15?Q?u3L0VHlpwrDkE9qdWZxNO7/CQzMhBG3y0nUUNJniEZhpABo250d92A8+e?=
 =?iso-8859-15?Q?GTjwyw9G60yncLiwtda/4wQ3Jjn90dJ+j+np3buuX67Zip+rFadbD02Is?=
 =?iso-8859-15?Q?YKYscYCOXz8Qc/43l/bCez4su+tCRPSt4AEnsAR/kxOy0OHm47qg2A6Ea?=
 =?iso-8859-15?Q?egBGWwpA5KraoS2LWKFU0KN9msiJherDVxdGF6N4dKoZobq2VXBITL0j2?=
 =?iso-8859-15?Q?+YEdKSpCL2R64gLlEG93l1EGuZZ4roT+fNNcYJjTBraY7/aS5BLAOyN45?=
 =?iso-8859-15?Q?Y38bPF8Mk8eeYj31nF8PrGVj4SQe+UkVFbGOh9CIaQ3m7WPzIT7TaFV/Q?=
 =?iso-8859-15?Q?k+Devq5aHFivamrVyACgRSkhwG5Aqx0DCIb2LsWoOt9Mc7VKQHH6p3tlL?=
 =?iso-8859-15?Q?+Akbair4LVHXvpL2IIA+ZZM7QbFQUxWRSZcMKYUuKkNK6sXlbTLw+3Z0z?=
 =?iso-8859-15?Q?Jia811YFVyGmV6URX4BR7pgpEgCm4mN+3FcjA/rPUEJ2+jMIKDWo3tR8j?=
 =?iso-8859-15?Q?bkKZsJtRgUvPZ/XLfdmeIBXhyGMw5VJKg+iZoOGyP2JYtG9oLABuPSWCJ?=
 =?iso-8859-15?Q?860uBh4Pxffpsan2ZMAGbkWdG/ojvl86MgRQi3XIqj8hi1YCeZ19cKxdt?=
 =?iso-8859-15?Q?NJfx4et6JIdU08HQqFjyYCrmdsi8FN+XVbcvFORVLJL+GdfsbisNp3kJU?=
 =?iso-8859-15?Q?xwGGLBIWouJjgpq2TS1i5tgUFM8JdKO24X7N7cX/qH+5rhF75rYHKnouf?=
 =?iso-8859-15?Q?pDYGt0aDQMXHJ9WbevdaCcm4fmXalUGv4bX1hZinbTrRg14Um/dTSRIqd?=
 =?iso-8859-15?Q?N+L6JS4ckHxI4AIE7fZL3mLJO9a/Q0FawtCJ/130cCIkT5Jn1cTn8Y4Kt?=
 =?iso-8859-15?Q?mHX57wq1dM0LHLQRVDQFkd17iuh2PA7kI/gRRJRIAWEHc4oxEm3vM8WCD?=
 =?iso-8859-15?Q?EvqsuZXvdiY71w/XnhYMvpWQyhRXMLtB3on8NqnYBm8POGwNVSgYuI8nS?=
 =?iso-8859-15?Q?O58xAzB0RRBxTQni8RuB8Oocxu9oOKM6Ij84lZMv1aKSByRp6xvYKyTrc?=
 =?iso-8859-15?Q?O3h0LEGz7JgDRcEj/mC7PkYCSOlpETnK9V5AHgr624a+2K99V1TB3cW+W?=
 =?iso-8859-15?Q?i/jok5e5lQuU9BAqHOaBY8j6xvts673tWUAGv3IekM5tL7nidOsgStIsJ?=
 =?iso-8859-15?Q?IuBbw34r/xnPOkTtKwYhWGjHDRn11gjmzGNu+qOqoXR6ohXdmcQxVXmpH?=
 =?iso-8859-15?Q?7JMgYjEMGJveCe9Z9aXBbA66GA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f7ef79-fece-40e4-7f39-08dad30c6df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 19:52:36.3777 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hlJx3nglW8AkV1Tw23lnbialFlT6cG+yTyCXDz8By8kdCOqNyUpPA83JRTVHKQqxEPBSLQ/mE81uzVM2EIvF3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8097
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 2/2] libmpathpersist: fix command keyword
 ordering
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
Cc: "lixiaokeng@huawei.com" <lixiaokeng@huawei.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "miaoguanqin@huawei.com" <miaoguanqin@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3CC0ADA1967A0A4E8D499CEDC4A88987@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-11-29 at 22:56 -0600, Benjamin Marzinski wrote:
> When libmpathpersist was communicating with multipathd, it wasn't
> using
> the correct keyword order for the commands, as specified in the CLI
> commands reference. Since commit f812466f, multipathd requires
> commands
> to be ordered correctly. Fix the ordering.
>=20
> Fixes: f812466f ("multipathd: more robust command parsing")
> Reported-by: miaoguanqin <miaoguanqin@huawei.com>
> Cc: lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmpathpersist/mpath_updatepr.c | 23 ++++++++++++-----------
> =A01 file changed, 12 insertions(+), 11 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_updatepr.c
> b/libmpathpersist/mpath_updatepr.c
> index 5824c169..4529a82b 100644
> --- a/libmpathpersist/mpath_updatepr.c
> +++ b/libmpathpersist/mpath_updatepr.c
> @@ -18,7 +18,7 @@
> =A0#include "mpathpr.h"
> =A0
> =A0
> -static int do_update_pr(char *alias, char *arg)
> +static int do_update_pr(char *alias, char *cmd, char *key)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int fd;
> =A0=A0=A0=A0=A0=A0=A0=A0char str[256];
> @@ -31,7 +31,10 @@ static int do_update_pr(char *alias, char *arg)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0snprintf(str,sizeof(str),"map %s %s", alias, arg);
> +=A0=A0=A0=A0=A0=A0=A0if (key)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0snprintf(str,sizeof(str),"%=
s map %s key %s", cmd,
> alias, key);
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0snprintf(str,sizeof(str),"%=
s map %s", cmd, alias);
> =A0=A0=A0=A0=A0=A0=A0=A0condlog (2, "%s: pr message=3D%s", alias, str);
> =A0=A0=A0=A0=A0=A0=A0=A0if (send_packet(fd, str) !=3D 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: message=
=3D%s send error=3D%d", alias,
> str, errno);
> @@ -56,18 +59,16 @@ static int do_update_pr(char *alias, char *arg)
> =A0}
> =A0
> =A0int update_prflag(char *mapname, int set) {
> -=A0=A0=A0=A0=A0=A0=A0return do_update_pr(mapname, (set)? "setprstatus" :
> "unsetprstatus");
> +=A0=A0=A0=A0=A0=A0=A0return do_update_pr(mapname, (set)? "setprstatus" :
> "unsetprstatus",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 NULL);
> =A0}
> =A0
> =A0int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t
> sa_flags) {
> =A0=A0=A0=A0=A0=A0=A0=A0char str[256];
> -=A0=A0=A0=A0=A0=A0=A0char *flagstr =3D "";
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (sa_flags & MPATH_F_APTPL_MASK)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0flagstr =3D ":aptpl";
> -=A0=A0=A0=A0=A0=A0=A0if (prkey)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sprintf(str, "setprkey key =
%" PRIx64 "%s", prkey,
> flagstr);
> -=A0=A0=A0=A0=A0=A0=A0else
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sprintf(str, "unsetprkey");
> -=A0=A0=A0=A0=A0=A0=A0return do_update_pr(mapname, str);
> +=A0=A0=A0=A0=A0=A0=A0if (!prkey)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return do_update_pr(mapname=
, "unsetprkey", NULL);
> +=A0=A0=A0=A0=A0=A0=A0sprintf(str, "%" PRIx64 "%s", prkey,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(sa_flags & MPATH_F_APTPL_M=
ASK) ? ":aptpl" : "");
> +=A0=A0=A0=A0=A0=A0=A0return do_update_pr(mapname, "setprkey", str);
> =A0}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

