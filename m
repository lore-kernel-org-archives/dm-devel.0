Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C5F2C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685548271;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9DPoH7A4G0SxxF4/WgwpT6qkzkvfJKh8uXAzshEwXB4=;
	b=HMr5Qw5Fx2hT7+/24vlQ7Dix96qpUXNuP7YxMqJGvp3qFXZw0WzZpLLFJ3zSnrlyZhDUAf
	+GjK5P9Xcg5CZZvD8YtPFxJqmKNXkTKfgI+ecVDOD3VJPJm7z6ekTVmE/8tvTbmW+61fvS
	TAIT3RROaLsTcy23PLm9am4/FSJ+dRs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-u0lkvCczMPiMbM-KH4OU9Q-1; Wed, 31 May 2023 11:51:10 -0400
X-MC-Unique: u0lkvCczMPiMbM-KH4OU9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B222A802355;
	Wed, 31 May 2023 15:51:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95C1D40D1B62;
	Wed, 31 May 2023 15:51:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D3AC19465A8;
	Wed, 31 May 2023 15:51:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 802841946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 15:45:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E95AC140E963; Wed, 31 May 2023 15:45:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E09DB140E962
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:45:13 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACF4D101A585
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:45:13 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on2040.outbound.protection.outlook.com [40.107.15.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-X_JGM-wOPDWVID9kX7Z_Tw-1; Wed, 31 May 2023 11:45:12 -0400
X-MC-Unique: X_JGM-wOPDWVID9kX7Z_Tw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS4PR04MB9268.eurprd04.prod.outlook.com (2603:10a6:20b:4e3::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:45:08 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:45:08 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/5] multipath: Add a group_by_tgp path grouping policy
Thread-Index: AQHZiqX3AHwb/SstxUylYlZgFQMxSK90mHOA
Date: Wed, 31 May 2023 15:45:08 +0000
Message-ID: <41034230c46f90eafd26fc8a557790ef9d6d16db.camel@suse.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS4PR04MB9268:EE_
x-ms-office365-filtering-correlation-id: 2e0f738d-d82f-4d32-965c-08db61ee0332
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4lEua8geKGal9Wa/PTEJxTA1t0iaPyhNDUdz9FZ2G4zIHrmFMNaeXBItc76a9rgcQN5FsRWOcKjJQWngq4/hFTYWXf9+KKyuFoLCRJo57yYjtiP6F4OHOQHEQtzyGV11F8k+9PXeicJhugmBhweJXeimXZ45TqR6CfRwzZdWt/3WfqmfdzIJCfTnWwrG7SoRwUB/nmf6GKjKrA96fsJaZmEoQXk4M6JZuQCRHpihI8VZGBmXOlD7UyN3fLrjrAp3bDlJ6pJxsL3mWWXwLVGt0iyLaDRqVXt+N69qE2ZfejbN3T2WlEsn8LfHNcszRMSY9OlohToK4Ed6wKfyRjb1Lxf8xZan55un2CLmaWtRJ4zNonkzVz0K/RhUZSKtatGy1LxA+9YgvRjBqWiG2MZe+uimz5uCbBIOw0i4c6EH7EvpwmXHI/mwRaFAe9ymWsh+FE1qBCtHkp3PSPBLfQaKP75eDti00Jrn0P5BuJLW121vBU4KIaamsw/wFoMF5kpRdy6Jz4iDE01OE5MXYfgAYjXk1QRAlZkahv9ELJ9o6tfFEmKqvg9YFQCw2Vplc56xVwU4wqURkUJiY5b9cdtuoZNGxj0a3jpbhX2QLu7EAhCD48aJ4lK6gsg6aRSy0lKy
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199021)(110136005)(8936002)(5660300002)(316002)(8676002)(2906002)(66446008)(66556008)(4326008)(66476007)(66946007)(76116006)(91956017)(64756008)(66899021)(41300700001)(44832011)(478600001)(71200400001)(6486002)(6506007)(6512007)(122000001)(186003)(26005)(83380400001)(36756003)(38070700005)(86362001)(2616005)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?GyYD3evtgYpSXYLg6wbdX44u3z7AHJt0iYzWxrYJHo0q+E3/TfXkClZAq?=
 =?iso-8859-15?Q?ALm/ydzQ45fI/6/I3Xfbv/kSvZt/IvLgoeoxvgaQt1Bc+rBsObhjBgz8Y?=
 =?iso-8859-15?Q?Jlrr+J4qKYjUbRbnCnTxEEqV5Bt/LfINr/v1T5tv8osQwNnZkYaWaB1qe?=
 =?iso-8859-15?Q?dYScqXDrUWV4+CUoEdZsVb3j9fHUo83JsW78WZpYLmu8Yf5iT7mVtpKl+?=
 =?iso-8859-15?Q?aGvmc1Mi5V+IqU6VPYqXkGOPtXi389vVSfNsmTfXubQYN5sg7MQ5QZQEV?=
 =?iso-8859-15?Q?F/qrau72w41TBSKS8CBxxVP9y2GOGK8O59+gqxLGTw2LhoYgBW/EpAeh8?=
 =?iso-8859-15?Q?JKxnmeNw/dHvFG+J9prYcwL+cX3Bs98zWyzeMlEEMZOTfjbZo7QP3iiLQ?=
 =?iso-8859-15?Q?MY0sdB/MHK8k326WnaxgmPtxaCFZsQ0GPDAEARQbdqbCYVNjLRczMovHQ?=
 =?iso-8859-15?Q?zXiHG9crIsuEZyaUUs5DG8msqL7vYwi1TykMx4og3Aa51zLhZMqzOq0jZ?=
 =?iso-8859-15?Q?ij0XI1dm23AXi+6O8KT00xVb0lJXejXgxbv7q4MVaCW3HJvyrnEZTbhgn?=
 =?iso-8859-15?Q?BPla57u6OrkTlZPQ9vvaivxtMxapMw8/hM0zGrR8plpV7mk3cmmBHPZjz?=
 =?iso-8859-15?Q?L8JGoHzMaU5Z2Tl2CMt/tJ79WlQHtRPERlGdTUvE6LNrudvs6kId3thX7?=
 =?iso-8859-15?Q?CIw7Usy+4HyD+TeDKyG2gXr2Ge7yXcuHHNRoFweneMLzl6qrN6xg651sZ?=
 =?iso-8859-15?Q?XQfWuPQsv2aiftNlhLrcOdQSmEyld9SUltitVRzZAtmQzRhpsMklInfXC?=
 =?iso-8859-15?Q?Fps1gb1zjzXgCq8oDGlkW3h3fh8K2QV2IjXtOLDaP/eM4hyrv3jeOer5f?=
 =?iso-8859-15?Q?5RudpXHfqSOqxVVwodfhGuGhDR1kFPHuW+NBNHF/imEr4ZiZiT4RfJqE+?=
 =?iso-8859-15?Q?O5JLRPCh4VqDTFJzeOwcUxTYOmvp4el1NaQaU2ObGo7xRKJOmVNgSSco6?=
 =?iso-8859-15?Q?Uychjhb0RJZQ5WKYqMJmlZjCvNHEPsy+CbSANPezJNVgcAWW9GxmNgNZU?=
 =?iso-8859-15?Q?ts9W8ahnUPcGvE83IoB16asUC8ykc3dJkVznJBZ9lpIFQHcmDsS5QHsnr?=
 =?iso-8859-15?Q?9D+pgU71Yqx+p13SgjiTrxsNpTWdU/G70qmqpdd0D4fyRApqEorCFI76U?=
 =?iso-8859-15?Q?wA7lqNvBDorAwLqPqQy6zVVHDvqUNG3SwFxLd7hyAFFcy7Qw+Sw6NkGSD?=
 =?iso-8859-15?Q?vJXm0YdM05BzkoK+Eh2q1thw4Ib8rQcOSqbLJCyWLU3RhAavqJ3OUuKM/?=
 =?iso-8859-15?Q?u2RusWheJDJ+ijmC4Bgcu2VzSW3HE0XObP3Fx3EQEYsu3wdGsQ6akTBHA?=
 =?iso-8859-15?Q?9bypoo0v/2SI/CptpOinmC41tFg9eXS/+m73kRWVzgNhTQW14K9Zf6KBR?=
 =?iso-8859-15?Q?nu/58Bz50M427BPjGpykVF7JOVWE+fuUniVFrmg7Suwxwoj5WIXe+vpxQ?=
 =?iso-8859-15?Q?qbb0LjTsopqQEC0vdLD1bOwLR8EGYtCEamG8hH69D3wsMX/oJqt4omTLy?=
 =?iso-8859-15?Q?LVk1RMBy/0UhpKtkQGeAVTL7EcfF8oVX4ptz6gLhCNdJRly7brs9X+KRk?=
 =?iso-8859-15?Q?YqBsnYhccCSIAyubOAJ0RQ4QgqU05E/TbAL8SOxTyKISzegwUffQgi4U1?=
 =?iso-8859-15?Q?zqFT?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0f738d-d82f-4d32-965c-08db61ee0332
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 15:45:08.6429 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XilzTOz45POEeF8KIQkPxKO7WKTDFmnPaCjppTMYRa+pKgyz9YdvSub4ia8HO42vhQ2x1jeo3JBdC3f55SjXkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9268
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 0/5] multipath: Add a group_by_tgp path
 grouping policy
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
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <699856B62923824CA6657B76518E2775@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> This patchset is adds a new path grouping policy that can be used
> with
> ALUA devices. The goal is to avoid the temporary incorrect path
> groupings that can happen when paths change priorities.
>=20

Thanks a lot for doing this. It has been on my todo list for a long
time. And sorry to make you wait so long for the review.

> There is one thing that I'm not sure of.=A0 Is there any possiblity of
> a
> path device changing the target port group it belongs to while it
> use?
> If so, then we would need code to check for this and reload the
> device
> if it occurs.

The kernel ALUA code seems to be written to deal with such changes. The
spec is unclear about it. The spec says that the primary TPG is a set
of target ports that have the same state _at all times_, which we might
boldly interpret such that the TPG can't change (if it did, the target
ports wouldn't have the same state "at all times" any more). But well,
I don't think we should rely upon that.

So yes, I think we should be prepared to handle TPG change, even if
it's very unlikely to happen in practice. But it doesn't need to be in
this patch set. After all, the worst thing that can happen is that the
grouping might be wrong in a very unusual situation. With group-by-
prio, that happens all the time, although only temporarily.

Regards
Martin


>=20
> Benjamin Marzinski (5):
> =A0 libmultipath: add group_by_tpg path_grouping_policy
> =A0 libmultipath: don't copy pgpolicy string in get_pgpolicy_name
> =A0 libmultipath: add ALUA tpg path wildcard
> =A0 multipath-tools tests: add tests for group_by_tpg policy
> =A0 libmultipath: add "detect_pgpolicy" config option
>=20
> =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +
> =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 1 +
> =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 1 +
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 17 =
++-
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 1 +
> =A0libmultipath/hwtable.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 1 +
> =A0libmultipath/libmultipath.version |=A0 10 +-
> =A0libmultipath/pgpolicies.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 42 ++++---
> =A0libmultipath/pgpolicies.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 6 +-
> =A0libmultipath/print.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 9 =
++
> =A0libmultipath/prioritizers/alua.c=A0 |=A0=A0 1 +
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 50 ++++++=
+-
> =A0libmultipath/propsel.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 1 +
> =A0libmultipath/structs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 1 +
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 10 ++
> =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0=A0 1 +
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 |=A0 16 +++
> =A0tests/pgpolicy.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | =
201
> ++++++++++++++++++++++++++++++
> =A019 files changed, 338 insertions(+), 35 deletions(-)
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

