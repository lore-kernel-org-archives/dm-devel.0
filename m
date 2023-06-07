Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1407AC77B7A
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 19:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686164437;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=85JYq6MSRmk+vtxqOSpJEJ0jr+SSjmXQrA7rnt22O/M=;
	b=C3EePX2alreDOSEUCL8Ag+SXxLof2VBXFYgX++xPrCiCDfyP7/ycKHoYV71R148vDFS8mA
	DFtbYQPx/m1mWBKx9RYkAg5Iig7uJY03QMeKTI1L86phGqvAAoTfuvAfv/R7Ej4C3FWAGB
	/X5IRfe6fn4Z7MI7eY/zbSmWqbFxcOg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-BjdAuxXHOHWXC1lvpVSB1w-1; Wed, 07 Jun 2023 15:00:33 -0400
X-MC-Unique: BjdAuxXHOHWXC1lvpVSB1w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 872EA811E7F;
	Wed,  7 Jun 2023 19:00:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E7E22166B35;
	Wed,  7 Jun 2023 19:00:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4826719452C3;
	Wed,  7 Jun 2023 19:00:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 71E8F19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 19:00:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5DA7C403367; Wed,  7 Jun 2023 19:00:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 54BAF400F4E
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 19:00:27 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 399BF8007D9
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 19:00:27 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on2085.outbound.protection.outlook.com [40.107.13.85]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-aNZz4apONBSTWc4r0uvgaQ-1; Wed, 07 Jun 2023 15:00:25 -0400
X-MC-Unique: aNZz4apONBSTWc4r0uvgaQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DBBPR04MB7996.eurprd04.prod.outlook.com (2603:10a6:10:1e3::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 19:00:22 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6455.034; Wed, 7 Jun 2023
 19:00:22 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 09/11] multipathd: only refresh priorities in
 update_prio()
Thread-Index: AQHZmLN0CtHmKIYmQ0iOLY0U03ON2K9/szaA
Date: Wed, 7 Jun 2023 19:00:22 +0000
Message-ID: <e0efeb2eb15362134fd0183ae873eec8b3c0958e.camel@suse.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-10-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-10-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DBBPR04MB7996:EE_
x-ms-office365-filtering-correlation-id: fb5e8bc5-4e8c-4767-950d-08db67897216
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /BykhLPCYqXOdXwSgq5LGfgBDa3IqSgbOTuT6Lh/hUr1wG3WkGPVrFQHm1RKIgmGXCQQT6PdR+v7BWsMXF+KlhK44DKlgvIAblCkhes49E7hGCoSzZ0mXyzbgRc+2vmP4QRX9Np3Xqfbw5LbQRiOELPl5W0nzf2ieYz5lOKuyHI1tzjOO9Nse7hX3Qj66VaDmEgRWUETWfUndNil1YSIccTuTWe+MXXIa08Bk3fgSWbYrBTVwF0XB16ma03jG+H2U69Bj8IJ/p0/iYlB1rSHvLvDIXD27/sAgnA0og30JA4/0c0Pq7JsrYbrkdRiX83i7nSVr5pYVHuLYpl6YRdl5MPOqmrRJ/hRWBQcFaibW6PxjdWmcOsnjJYeSjP2mMJwg13dPIlb2BwsSgaIZ4BW8EqLpv9/K2uvVjCmObACpPJ8HVcVnazyiwxmOqiO9H5cQ0dujW1iPSfWYQBXTutUu7HbUr722tH8VrkJS9frvvwj++/EpD7gKN7920XvbQtfJM/1/hp6R+krbD3zaakDgGh2DyHG1NKopC2adnKwrd5kSWMqcnxPNHpC6ZsTrmW95vD69H8lVlkHfKYnPdGBZJ00iqcNHWLT3qH+Mf5iX+rseaWgicoCDdxpOuE4zyxb
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199021)(36756003)(2906002)(38070700005)(15650500001)(86362001)(44832011)(5660300002)(76116006)(83380400001)(6486002)(71200400001)(186003)(26005)(6506007)(6512007)(91956017)(478600001)(110136005)(66556008)(122000001)(66476007)(4326008)(38100700002)(316002)(66446008)(66946007)(2616005)(64756008)(8936002)(41300700001)(8676002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?vWFjxz+2IeDxUXGmO3Y5WqEnT+aJy6tGbQpNLRo1IeiT/ZV589pjDBkm+?=
 =?iso-8859-15?Q?4NteUH4oScbVRmsKlzh1qNTm4hbDegiUioROilqKK8FE0LLMkEiPJfNHd?=
 =?iso-8859-15?Q?QUKA834qvjdVMCZZx4OAHSqnsBZzS/LllqvLs7WFnUQYZJ7V9EFxZmt9y?=
 =?iso-8859-15?Q?d51KRTqFUExrPXU+K1Dwbc6nBULbDkjl6DHw2r9n7we6ltiyS8LlwtHnJ?=
 =?iso-8859-15?Q?1TThwiMUs189QlN/lvbHnn+F8F6N3xJw2SGsGm083omYUTmNyfdE4eTJx?=
 =?iso-8859-15?Q?fRIi9V5tMTodbv86ZxrcLpgYzNRGrYD+vP69/dg1hUWf+NmhMdWyUY8E1?=
 =?iso-8859-15?Q?gpACxLafgFHNLJgFjEJ6d/32SEdci+iNfcHz9GPHsk86pz99d20f5Xg9/?=
 =?iso-8859-15?Q?D/U9tk8vq3z7YQHm242xmUcAVyI4yVkNlub+LlgknfsJecxkfPnQ7SQNW?=
 =?iso-8859-15?Q?oAoVhi1s+gyVSX7bwv8QK48Twvw7zpJMgQxy2A8ImLEDQZLgRrCp6HjmJ?=
 =?iso-8859-15?Q?q1LIo+fPakhgSyqrvwbqTvuLf1Argq6ufMluE8nsLisoiGaDgCL7LInvb?=
 =?iso-8859-15?Q?ykZ2rzvT/GiBPDdB/c0oHwCbIdOLEGjq+DGFlgHd3hxsDa2jwcWQSZHWM?=
 =?iso-8859-15?Q?JoczLfgCeY/dwOjbTGi5sSGpkLJcOpU17AAOixwaP/nFkX0EH8FRxsTr6?=
 =?iso-8859-15?Q?J2uurwcqB+VY/ZplN+IhEDHvJV1mxT+Ec2WLEjiJUvExhhfLRJjzkyhOh?=
 =?iso-8859-15?Q?cDPrZADN2LZpknzvjRu1tRr/EcEqIs7cPxgvSxEzSjZIgfl6ToZN6oDTH?=
 =?iso-8859-15?Q?oGYfwNw8TZu0nVlOz5f5pGMjpnHyF6owXQIIwLIQ/OUK6920nuPE4Ob5f?=
 =?iso-8859-15?Q?g6xHqwnLR3+8SAuejtwKOJxjv02NmTciYfMTczUNVRl9PFBXEe3yUry9O?=
 =?iso-8859-15?Q?BZRCSPHLua/3ry4mBF5ytdK0uIRFRbWbGX3/fSw/wqOUvVT8C0ho99pcm?=
 =?iso-8859-15?Q?uTzvEWjuoYwx+/a5jpRjH4+b7qis9oqtK5n8Ur7Y0WoXBQU79z9ZBx/t8?=
 =?iso-8859-15?Q?hYBjOdFLOHRTJvI4vvtPdv+ie6GB8jBuCnQjmJxu72H9z13bZKDBxiaHE?=
 =?iso-8859-15?Q?x0nUALadZQSo2YOysRZrAF9Cl4K7FghawwDCNafwDTwtUXpxO3iGAuy4g?=
 =?iso-8859-15?Q?LZsmCBBcQlyKV/R2Up1QEBCWv5ClmrkPIqqwzS8je86nadU0nk/2EFIuP?=
 =?iso-8859-15?Q?zXaB7KFfrGY5uiPHt+ktw2UKgnZZ0QT3hujUn3lQi2dtzpxMv+9wEIsvZ?=
 =?iso-8859-15?Q?5KjxQGgZtNLnC4kKeidZP5fa0M7mCFBCLu4+GxRNW0KzQUFTglhdB/vNS?=
 =?iso-8859-15?Q?eYhG9jjIFzTiHM2brPpbhyxBP5oFznAxrmndOQkokfmDKLysP8QaEgzZT?=
 =?iso-8859-15?Q?cmMN4MHIbfl6qDtHd7vUBvCs1sx5Sqa6NHoSYH9DGVOGs83GZT9Ev4qHR?=
 =?iso-8859-15?Q?7CdBOAmC5Qoneox/rt+GvwCfFodZIpUKDgXFvogeMTSHgB79kHLm7fLSu?=
 =?iso-8859-15?Q?IKES6tnZDYfasgTsGAJz+GXblUST9b7gfXirhUMHJ+W07xJgyvV46NJ7j?=
 =?iso-8859-15?Q?k+H9E092IAqU73zrxvN5JrVFmzmF7Rb/oieZst605q+2R8GybxOLYWakl?=
 =?iso-8859-15?Q?aX+P?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5e8bc5-4e8c-4767-950d-08db67897216
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 19:00:22.5171 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c7wSQ8ypMqEJFG+TE8xeqI7isX3TmuRUlL+GqL5peVOQPTI+e5hNWx+wfTlyjHHFBS7CiRw1EKuRjpdIEM+z2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7996
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH V2 09/11] multipathd: only refresh priorities
 in update_prio()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <1078937D4A00994BB4380D68D9888343@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> Multipathd previously had various rules to update priorities in
> update_prio(), need_switch_pathgroup(), and reload_map(). Instead,
> only
> update the priority in update_prio().=A0 To cover the cases where the
> priorities were getting updated in other functions, update_prio() now
> always updates all paths' priorities, if the priority on the path
> that
> it was called with changes.
>=20
> Also, do not try to update a path's priority if it is down.
> Previously,
> when refreshing all the paths' priorities, a path could have its
> priority updated when it was in the PATH_DOWN state, as long as its
> priority was PRIO_UNDEF. But if a path is down, and the last time
> multipath tried to get its priority, it failed, it seems likely that
> the
> prioritizer will just fail again.
>=20
> Finally, skip updating all paths' priorities in
> deferred_failback_tick().=A0 Now that all the paths' priorities will
> get
> updated when one changes before starting the deferred failback count,
> it's no longer necessary to update them all again when the failback
> timeout expires.=A0 The checker loop will continue to update them
> correctly while the timeout is going on.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Nice, thanks for doing this.

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

