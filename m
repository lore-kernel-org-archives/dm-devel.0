Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C74ECAAA1
	for <dm-devel@archiver.kernel.org>; Fri,  9 Sep 2022 21:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662758478;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=klG5kMo41QoBoPEFzqDrPQdnsnbsacnIM7kLcOETFrw=;
	b=aTaSq0gCOEGryKGb2aOQ+rMRsQkRwsQmKXZ5JyvAS7+AZfNB8nOjtRR5iDd3+T9TjSwlsZ
	bTGj9iWPZ1wirdMwUD8F1AwAif1hdpwRisEJJAHARJ8S3z3Reh3QvDcP8TWNojnyvp1Usr
	SFjeXszlryZXB+yLxUug8mTO/3bp+SA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-Pug99veHPq2RPwtiyhzDRw-1; Fri, 09 Sep 2022 17:21:15 -0400
X-MC-Unique: Pug99veHPq2RPwtiyhzDRw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C1C13C025AD;
	Fri,  9 Sep 2022 21:21:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DD6D14152E0;
	Fri,  9 Sep 2022 21:21:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 297F51946A42;
	Fri,  9 Sep 2022 21:21:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E2641946A41
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Sep 2022 21:21:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1DF6140334F; Fri,  9 Sep 2022 21:21:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1956F492C3B
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 21:21:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0106F8032F1
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 21:21:10 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2049.outbound.protection.outlook.com [40.107.22.49]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-uDGtvb2DNdOAMqZpkmq98g-1; Fri, 09 Sep 2022 17:21:08 -0400
X-MC-Unique: uDGtvb2DNdOAMqZpkmq98g-1
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13)
 by DU0PR04MB9636.eurprd04.prod.outlook.com (2603:10a6:10:320::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Fri, 9 Sep
 2022 21:21:04 +0000
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::13a:6954:3cd5:84e1]) by AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::13a:6954:3cd5:84e1%4]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 21:21:04 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] multipathd: fix read past end of of buffer in sending
 reply
Thread-Index: AQHYwxpnENbZv+m5FE6XkpapmaKrV63XnegA
Date: Fri, 9 Sep 2022 21:21:04 +0000
Message-ID: <7cd87394c8bc07649fc8ac88c766438f053c770a.camel@suse.com>
References: <1662597110-22321-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1662597110-22321-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM8PR04MB8036:EE_|DU0PR04MB9636:EE_
x-ms-office365-filtering-correlation-id: ef71d2ce-a6dd-4445-3a2e-08da92a933c0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WpkmFWXBpF991ym6hzXXSl9pdXszVnPEy/cQ8q8sJ82wFwsAhCRBAxXEFbs7NohfOLVTkBno/ImVaHc0vIhpwDOfdUoPHrof/ZocHnZ9yEq9b/bZN//lnPj27TGRdqZp4V7KCCcOa78dJoUnouYBCfxnBs8hJD0mw33/KNro4SdDIZRpVZEkRoxlKUv1pr804qX0mgKNLuSIXCmiOLnWi4UvCTHvnLFzMl82nWCS2PSE0s94T3ArGHZv7XvkCCdak4ttWBEuZc6BU74EUbR4wpXiYHLAo8CnupHE8wXmdTsU52Fqfr/AUfK4q2rp9+ZDilyylOfn1oP+/Ax4jnigxbM8ApAUkyyjE5lEW+ImkZU3ulHG8oFfwvj6bFPEjtXwlVcUfuUoL8Gq/tJM4miTAUrm7Q8sJj+fOO6gZWE2exROvrZQ6UD6ZBji0tliTUptOQvnJTY/X92mECEEp1UEdvUWpEouqObWgeUS8HR7YNQSVH8S9KSbAYvMLAN5hpJ9pOapdRZxwtR0+7wkhcW7YN/9oQFlmRkW3V+TDWfIWfFU5FgLYjtcIHvqorxZ060p4M9URHxUQGx9Wx6+maW8QznTcCKKqoIhcDj2zfrhba6JFe/c5xqCtE2bwZ1EbXWwb4W2JlwPSfx3uAYSf0b532wMs9V3UShNt84we1WVln6aAkZLz/hXQNgW51AS0fFdGmP3ZCBkX1jn8o4l6GB6eIgpc//iz0FEMf1b6E2PTfX9zRgH3LSbqkz4W3khI4fSpNOgfv93tLXa6ywX58rvVg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM8PR04MB8036.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(376002)(396003)(39860400002)(136003)(366004)(186003)(2616005)(76116006)(44832011)(91956017)(478600001)(66446008)(66946007)(4326008)(8676002)(64756008)(66556008)(66476007)(26005)(41300700001)(6506007)(36756003)(71200400001)(6486002)(83380400001)(6512007)(110136005)(122000001)(38070700005)(86362001)(5660300002)(38100700002)(4744005)(2906002)(8936002)(316002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?WWQDIHcCXuR1yf3/MCXlfKbiPrpDBi1ZJeg0+z0LWWZ4mpod+Cydv2+O8?=
 =?iso-8859-15?Q?tmAs8hopdiDDsFJpvEWoHsvwisVv9eG09faFdH8pH06SHiRy4sr3ZV3j5?=
 =?iso-8859-15?Q?9Rs/oGCyjMaf6U19BKenXh3aOpAqtyzmV52AZhS+3Q3HHhrFSgMngnI+d?=
 =?iso-8859-15?Q?RvzLzJRC2UZda9Ebdz18lmTnxrQqU7v3QXzrxwWSQ5NLvc1vtBsnBwZFY?=
 =?iso-8859-15?Q?Qn9j89rOLXfSMH4DegucChjarxnfXRJIKrPIL1OdTgKxpl9X+RnLyWoV9?=
 =?iso-8859-15?Q?NHZBcyTI25AIo9f6Mrs9himzxfAI1U4P5qH5T8Vd/dB933rBUiWi47KZO?=
 =?iso-8859-15?Q?c8Iqr7+V04Wt+ABaAyZlPTodC8iFMEQcrScu8XLWYV8aU5x1yt3m74K/z?=
 =?iso-8859-15?Q?ZEQV3WjhvVodQH/LR3xFf9+dDq1FRH6JI5pde7hJE58I++BqoNv8mIwwZ?=
 =?iso-8859-15?Q?DmFpVCF5A6QFdiLXFSIwssN88AGJYjjgye+5Nt/DsIWfbx76bpXah6eH+?=
 =?iso-8859-15?Q?7P0PHzbslBmgRGpXEdMlwevjk62UMtDTcR8CHU4EV9Ji3BGU7puwrCqaO?=
 =?iso-8859-15?Q?F1Sy+wdPHD5dGtRWt84hCiRfCvVetxluZfpJjegnNUu/LKx7sAJfbX5Io?=
 =?iso-8859-15?Q?IjTOmzfU42wNWjmmuOUSRnlft0/VaEudrmy3kTfGym4k4oYDSh90n1cPt?=
 =?iso-8859-15?Q?k0f4cd7Zo6f7xE/OQ5PnZ4HV8IKhNFVfLcV+LybKkvobPNZ2bbU/GLHdG?=
 =?iso-8859-15?Q?MowGqznWXXqKlV0sUYzejTwV9KEf54l4+xdOcKyDcumHwEb4xdgUrytf8?=
 =?iso-8859-15?Q?Q16WnPAgQRG9FkcA9OpzKbkp+g0vOYiUS7eCH7z6ugYUuFSszZM4pN3Rv?=
 =?iso-8859-15?Q?8eELdav0H1HF83tFY7A89RNgSRNhloqBVngkTFc817aQwg865HjwVUbLh?=
 =?iso-8859-15?Q?uvVN5RT65qv7YPCU+LTdQ8bnH0XmyglXCoERx3bbzhyHuphdMNMFGEWfy?=
 =?iso-8859-15?Q?+AnHn5qjp2WzilWslT/O/3+qO2n6/0pLYpzVU2WiXmvuDTBTD5s2sXahi?=
 =?iso-8859-15?Q?fSNsx2czbukYyGKHGVy9iapO/9KOiWThU73kTeN9cRJBuEXsg9cuELzm8?=
 =?iso-8859-15?Q?1ZXkfkEZUGX6j5NIYdJPJT8P7O2x3LN2iY+IrHKxaqvTFnSB8QpfL3ZR6?=
 =?iso-8859-15?Q?KUk7BGBPobNLYgh8ZsHN4+y+Z3FiMVSoGNSZC5qYzpjgwR8iH9lPeahnR?=
 =?iso-8859-15?Q?Uy9mx2AUsPC+z+Vx/cm5eEK5k9/SKPq/AiCkahFCMuIPAqbOU1lSpLu2z?=
 =?iso-8859-15?Q?DemYZoVzkOTMDI0Q3nIOwspQ49fa4DFjc+qncZMg1mhkSVl53eh8aAdPQ?=
 =?iso-8859-15?Q?EyqLU6lM4oVte9tpGKau3dqrmnp3z0Hw6IBFGCUAPu37+UBlK7NUuyps8?=
 =?iso-8859-15?Q?FXWrGhKyigK4b47QtlzfCqqUl78d8uIbJ9vKTVD57ASYJG6VusXsJns7Q?=
 =?iso-8859-15?Q?hFU3U0lgsn1Hr80zeG7ZpzURELDqx/O4RUsE+4ABz4pQmAzvQpKq62Mf2?=
 =?iso-8859-15?Q?XjnV/Pr3LuLqm8WvJnAH2pHnIn8llu9st+jt1K76+4IBJYeB1cTKePJmG?=
 =?iso-8859-15?Q?Jz99T64e01YkVTa/OqkGyqJCsgMFnhWfwg6YfgcjdacvZt5fjFhNotExf?=
 =?iso-8859-15?Q?2bJ+na2WDLcmJAILO/F2lS7TJA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB8036.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef71d2ce-a6dd-4445-3a2e-08da92a933c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 21:21:04.1398 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OfzfjtYqK86jnaS+iXVn4q308DZKieC+1xyvqDU0zln8N037NpYt7whLMzUZUsdQy8Ybs9cHL3dp4UdItbBLAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9636
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] multipathd: fix read past end of of buffer
 in sending reply
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <68FCCC878B6F5A4988C41D67A5771512@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-09-07 at 19:31 -0500, Benjamin Marzinski wrote:
> Reduce the send() length for the uxlsnr reply, by the number of bytes
> already sent
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0multipathd/uxlsnr.c | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 23cb123d..238744b7 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -541,7 +541,7 @@ static int client_state_machine(struct client *c,
> struct vectors *vecs,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (c->len < c->cmd_len) =
{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
onst char *buf =3D get_strbuf_str(&c->reply);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0n =
=3D send(c->fd, buf + c->len, c->cmd_len,
> MSG_NOSIGNAL);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0n =
=3D send(c->fd, buf + c->len, c->cmd_len - c-
> >len, MSG_NOSIGNAL);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (n =3D=3D -1) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (!(errno =3D=3D EAGAIN || errno =3D=3D
> EINTR))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c->error =3D -ECONNRESET;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

