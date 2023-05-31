Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE127C77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685547265;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iVpqzgTnqiUpiOM1ymGfrOshUiPCuwMizMokQDgSyZU=;
	b=K9bfddcPWbGUws8QbExc2rIH51ny9sFYEN7GQecGwfbMS9GS5g7+J7rLcO11RhWUPLHk1Q
	R4jWf3nkK3muxOZb1mvhxnKG4D1CF6LPKMFM+ANM35vyCXjztRfS8X1hpfV5ru8KhJ2byI
	du1uVAJmM3hnQnxBkxMJW4aP0CE/+rA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-lOSfwPJpPZyrF5oKkTTeeQ-1; Wed, 31 May 2023 11:34:22 -0400
X-MC-Unique: lOSfwPJpPZyrF5oKkTTeeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B74F2101B058;
	Wed, 31 May 2023 15:34:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9C4DA40CFD46;
	Wed, 31 May 2023 15:34:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A9301946A42;
	Wed, 31 May 2023 15:34:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 953651946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 15:20:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7E1E140BB2D; Wed, 31 May 2023 15:20:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 757C740D1A6
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:20:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5668E185A7AA
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:20:02 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2047.outbound.protection.outlook.com [40.107.20.47]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-IrNdZ8k4NC2iKRm6UDf5iw-1; Wed, 31 May 2023 11:19:58 -0400
X-MC-Unique: IrNdZ8k4NC2iKRm6UDf5iw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DBAPR04MB7351.eurprd04.prod.outlook.com (2603:10a6:10:1b2::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:19:55 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:19:55 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/5] libmultipath: add group_by_tpg path_grouping_policy
Thread-Index: AQHZiqX4Au0N/CinukSQR0cojhsoUa90kWcA
Date: Wed, 31 May 2023 15:19:55 +0000
Message-ID: <c4e9f110538008c2e9e70fe06ae15a08fe7c4d97.camel@suse.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684537332-23033-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DBAPR04MB7351:EE_
x-ms-office365-filtering-correlation-id: 3096affa-3eee-4b5a-6e6f-08db61ea7d70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6u3v/0B0ABFWJYUzhX1+2V/hlRMAp3jwS1rkc4kZW6BoQu1o/lmKksAo4gZmT/ttFdi4JkQWRhIX9hBQBwzejsug9l4C5gj0e97IwQ2GL8hXu49YKd6ozziDAF1AbLA7UKpz+LN1K80UMmw2QZ13Xl/6VFYOqh9srN8sUluwOb8Em06tz5fIzzyHXeeaOhV7dWzNIEiRMEdqEqyENq7gn3rwV66Zhr0ujRH3h87f+sTyFJWKn01ORID0s+H/xo1z4s6s6X87xSBJLyeP47W3FxfPYynHNEFutXE6tiothLNUxJIzJ6cl9iLWfkziwm96Zz0k80gmir1nwIfnrMalsVYShAqzzuFAh60lzq4BRzxYtVE7CF+mQc7vFNKNrlZ0GmXKKPrZZcTnuTZ4WZHIv5/sQA2KeTn2cH+R5ESd+6VcyoihN5TqhayAGqSy5KRguNj3R1XIzRFjfMUmK1rZKViiW3zbdYdNPLft+zz3Mh7PxKPlmE2A2M9j8l/Maa5scbKNGPw97iKpiGWD7ZAtzaEYRuCb5JodmIqmsQLFlmx4QeOip30rDKD+t3FbK72+ycaTCc69VdECrP1gvgK8rAt0LdU+mzXdUyssvNfhC2QTarc7StRCo6ApJXZPl/I0
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199021)(26005)(110136005)(478600001)(8936002)(8676002)(122000001)(38100700002)(44832011)(64756008)(66476007)(76116006)(66556008)(91956017)(66446008)(66946007)(6512007)(4326008)(6506007)(86362001)(71200400001)(2616005)(316002)(38070700005)(5660300002)(186003)(36756003)(6486002)(41300700001)(83380400001)(2906002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?yFX4GN+ePYyg827r166HaT+vsZotwAu9BwSRqorCWO/3h7GU2JGIDbkrC?=
 =?iso-8859-15?Q?76eP+gAJ4fN+ImWb0/9URChHZdcKMb22byuPBinyC46wOqfcJW4QvbcTm?=
 =?iso-8859-15?Q?LpJm06IFdSozRVY8I9gIu+IhBt/kkciaCFdUe8vOLd8KhFDFxR+w2d0mp?=
 =?iso-8859-15?Q?Sr8ZncMeq49whjYgSiHhQopBdk85C5kveEIl262RVcSjY0cAz6y0mP+WH?=
 =?iso-8859-15?Q?GnDsB1AmhtyhYi+1tAMDKy+BPkG7OQ3xVKJr2/khGX7peW4yB+efplvqy?=
 =?iso-8859-15?Q?c17XvRUkmsCvUSzAKwhQPsbFT2dXQvfLa3ncBPtHizVgkK0EKcnxl0Uhi?=
 =?iso-8859-15?Q?Vjq6FNIuDZHqlQXTupZ5fmYRyf44wphwmtBLVzEQqWYDj1d0j9h4N0JWe?=
 =?iso-8859-15?Q?hyGzRQXFn2okY7WKGuCsfzSu6qOKjOvFYP0Z+dq6izmo7wopGWjALfsAu?=
 =?iso-8859-15?Q?L+Tn7SpfcAo2+Jwz28QxZ267MO8Hb0zowhyA3qqE4AnrLQ3TRAcQjAbAT?=
 =?iso-8859-15?Q?O9U69NFH/6Isus8PzeFRMnpXNtVme+FD0i/DkoZsb2tviYHu1uWHigAmE?=
 =?iso-8859-15?Q?Fds12LEoJ9Ar1DhYtq7rI1gXwMAZ7ZyB5VQLMxjmn6IxGUz+QttLrirYS?=
 =?iso-8859-15?Q?0TqpHt5hP7xgGuBey4udpO/ho5BQFt//eLViFLT6yJ3zactqUnFl3lZOM?=
 =?iso-8859-15?Q?qy/vLOrk3YQQARihvOnQzd94e9QG4YFd4XH53DZ6e/ISfm5DHDgSXp5oA?=
 =?iso-8859-15?Q?qF28d1cTO7rVFtj4poAt7NrItQn2H2OhgiHY4Y6dZIDWL9KaEGk7epl0O?=
 =?iso-8859-15?Q?jY1ncDSkhZ58U8KoVnCn3ylhahvb1gT8I8WK2e9OETOQMGCodVBkifskl?=
 =?iso-8859-15?Q?E04+w2mycZEOp/SzQlyM1hjrvNwd4FH6kFfiOx09fKkgW0BdNy+4N18dw?=
 =?iso-8859-15?Q?yurEIMcx1FKuAadA8ICTymU66jdfPQ3Au6mk2EiAMrE7hsUdTazEzHFii?=
 =?iso-8859-15?Q?hVXcPEDx2BN4MvGDLi/U/5V53urqBYqgFWho9pSzq9berPotr6V6zgTcI?=
 =?iso-8859-15?Q?ntK0fPHlDKOYby8D2+C3mpJg3dQxvO10b3rKAhRfHYEaExlpQbXjiGp96?=
 =?iso-8859-15?Q?PRgoGBM/RSN9BRfeU7odZ9qwIg7EuxaiFvII3pQMgNa0HikCsjNShto1V?=
 =?iso-8859-15?Q?i2KQ4Hic2J3rL+TBAI92TSmqYww7Ayz9jipUYCrz+w67mpdm0EkfcZcda?=
 =?iso-8859-15?Q?PBH57+av3ETV3kycmqP3ZztwzgjX+zhrCSDtNjQo16wrgQkTbN4OzFHB+?=
 =?iso-8859-15?Q?ugcP0MQaNNmeShwQK01dvIQhBWWjCFzkP/XMhJXPlQyEsM2H3b2Novn/H?=
 =?iso-8859-15?Q?KBpLfiUFUW+ThSYKftWh4nUvFiJVBHGB9t2U3Lm906ArH3kRgTb9seV0E?=
 =?iso-8859-15?Q?zATKxqOKn3ch29PDtscsJAgjYxNbWeI/fT5rpA621rnvTKX5RGg/gJ2oT?=
 =?iso-8859-15?Q?nqieiPOtDvb2Z9ccV2QVxWGruFqefFcShD/I/f4y/8EF+jZFLtScM9YLz?=
 =?iso-8859-15?Q?CiW6QXQ8WfQBBcPYR+CKqAiQketzb8IYe2c743D09qqF6lpqN/da5a2um?=
 =?iso-8859-15?Q?NuTN84m+1qDJ5U0ANUtWNFE1nxfK9FSW1vO30CoD0OcetCZxCazf37O54?=
 =?iso-8859-15?Q?rSxS?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3096affa-3eee-4b5a-6e6f-08db61ea7d70
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 15:19:55.7609 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7L9gCxR3hoZDbnh49d//DQLj4uQIymxmT1UgPQw0qWQ5dnxhR/5d8+5GCoJnKmvIyJs/RMETg8FkZqXL9RkXhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7351
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 1/5] libmultipath: add group_by_tpg
 path_grouping_policy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <E7B37372B8DFF04B874C4629AE98B6B8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> When we group paths by prio and the priority changes, paths can end
> up
> temporarily in the wrong path groups.=A0 This usually happens when some
> paths are down, so their priority can't be updated. To avoid this for
> ALUA paths, group them by their target port group instead. The path
> groups chosen by this policy won't always match with those chosen by
> group_by_prio, since it is possible for multiple ALUA target port
> groups to have the same priority.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/pgpolicies.c=A0=A0=A0=A0=A0=A0=A0 | 19 ++++++++++++++++++=
+
> =A0libmultipath/pgpolicies.h=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +++-
> =A0libmultipath/prioritizers/alua.c |=A0 1 +
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 27 ++++++++++++=
+++++++++++++--
> =A0libmultipath/structs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +++
> =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 =
1 +
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0 |=A0 4 ++++
> =A09 files changed, 58 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 6865cd92..2dcafe5d 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1051,6 +1051,7 @@ detect_alua(struct path * pp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0pp->tpgs =3D tpgs;
> +=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D ret;
> =A0}
> =A0
> =A0int path_get_tpgs(struct path *pp)
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index 10b44d37..e14da8cc 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -25,6 +25,8 @@ int get_pgpolicy_id(char * str)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_PRIO;
> =A0=A0=A0=A0=A0=A0=A0=A0if (0 =3D=3D strncmp(str, "group_by_node_name", 1=
8))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_NODE_NAME=
;
> +=A0=A0=A0=A0=A0=A0=A0if (0 =3D=3D strncmp(str, "group_by_tpg", 12))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_TPG;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0return IOPOLICY_UNDEF;
> =A0}
> @@ -49,6 +51,9 @@ int get_pgpolicy_name(char * buff, int len, int id)
> =A0=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_NODE_NAME:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_node_name=
";
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_TPG:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_tpg";
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0default:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "undefined";
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> @@ -191,6 +196,12 @@ prios_match(struct path *pp1, struct path *pp2)
> =A0=A0=A0=A0=A0=A0=A0=A0return (pp1->priority =3D=3D pp2->priority);
> =A0}
> =A0
> +bool
> +tpg_match(struct path *pp1, struct path *pp2)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return (pp1->tpg_id =3D=3D pp2->tpg_id);
> +}
> +
> =A0int group_by_match(struct multipath * mp, vector paths,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool (*path_match_=
fn)(struct path *, struct path
> *))
> =A0{
> @@ -279,6 +290,14 @@ int group_by_prio(struct multipath *mp, vector
> paths)
> =A0=A0=A0=A0=A0=A0=A0=A0return group_by_match(mp, paths, prios_match);
> =A0}
> =A0
> +/*
> + * One path group per alua target port group present in the path
> vector
> + */
> +int group_by_tpg(struct multipath *mp, vector paths)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return group_by_match(mp, paths, tpg_match);
> +}
> +
> =A0int one_path_per_group(struct multipath *mp, vector paths)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
> index 15927610..d3ab2f35 100644
> --- a/libmultipath/pgpolicies.h
> +++ b/libmultipath/pgpolicies.h
> @@ -16,7 +16,8 @@ enum iopolicies {
> =A0=A0=A0=A0=A0=A0=A0=A0MULTIBUS,
> =A0=A0=A0=A0=A0=A0=A0=A0GROUP_BY_SERIAL,
> =A0=A0=A0=A0=A0=A0=A0=A0GROUP_BY_PRIO,
> -=A0=A0=A0=A0=A0=A0=A0GROUP_BY_NODE_NAME
> +=A0=A0=A0=A0=A0=A0=A0GROUP_BY_NODE_NAME,
> +=A0=A0=A0=A0=A0=A0=A0GROUP_BY_TPG,
> =A0};
> =A0
> =A0int get_pgpolicy_id(char *);
> @@ -30,5 +31,6 @@ int one_group(struct multipath *, vector);
> =A0int group_by_serial(struct multipath *, vector);
> =A0int group_by_prio(struct multipath *, vector);
> =A0int group_by_node_name(struct multipath *, vector);
> +int group_by_tpg(struct multipath *, vector);
> =A0
> =A0#endif
> diff --git a/libmultipath/prioritizers/alua.c
> b/libmultipath/prioritizers/alua.c
> index 0ab06e2b..4888a974 100644
> --- a/libmultipath/prioritizers/alua.c
> +++ b/libmultipath/prioritizers/alua.c
> @@ -65,6 +65,7 @@ get_alua_info(struct path * pp, unsigned int
> timeout)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -ALUA_PRIO_NOT_SUPPORTED;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ALUA_PRIO_RTPG_FA=
ILED;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D tpg;

In view of the discussion from the cover letter:

tpg_id should have already been set by detect_alua(). I'm not sure if
it's good to overwrite it silently here. Shouldn't we rather check
if the value is unchanged, or refrain from setting it more than once?


> =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: reported target port group is %i"=
, pp->dev,
> tpg);
> =A0=A0=A0=A0=A0=A0=A0=A0rc =3D get_asymmetric_access_state(pp, tpg, timeo=
ut);
> =A0=A0=A0=A0=A0=A0=A0=A0if (rc < 0) {
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index a25cc921..841fa247 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -35,7 +35,8 @@ pgpolicyfn *pgpolicies[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0one_group,
> =A0=A0=A0=A0=A0=A0=A0=A0group_by_serial,
> =A0=A0=A0=A0=A0=A0=A0=A0group_by_prio,
> -=A0=A0=A0=A0=A0=A0=A0group_by_node_name
> +=A0=A0=A0=A0=A0=A0=A0group_by_node_name,
> +=A0=A0=A0=A0=A0=A0=A0group_by_tpg,
> =A0};
> =A0
> =A0#define do_set(var, src, dest,
> msg)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> @@ -249,10 +250,26 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> +static bool
> +verify_alua_prio(struct multipath *mp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mp->paths, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *name =3D prio_n=
ame(&pp->prio);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strncmp(name, PRIO_ALUA=
, PRIO_NAME_LEN) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strncmp(name, PRI=
O_SYSFS, PRIO_NAME_LEN))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 re=
turn false;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return true;
> +}
> +
> =A0int select_pgpolicy(struct config *conf, struct multipath * mp)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0char buff[POLICY_NAME_SIZE];
> +=A0=A0=A0=A0=A0=A0=A0int log_prio =3D 3;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (conf->pgpolicy_flag > 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D conf->pg=
policy_flag;
> @@ -265,9 +282,15 @@ int select_pgpolicy(struct config *conf, struct
> multipath * mp)
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_conf(pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> =A0out:
> +=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && !verify_alu=
a_prio(mp)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D DEFAULT_PG=
POLICY;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D "(setting: emerg=
ency fallback - not all
> paths use alua prio)";
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_prio =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0}

I don't understand this logic. Why don't you simply check pp->tpgs?

> =A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicyfn =3D pgpolicies[mp->pgpolicy];
> =A0=A0=A0=A0=A0=A0=A0=A0get_pgpolicy_name(buff, POLICY_NAME_SIZE, mp->pgp=
olicy);
> -=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: path_grouping_policy =3D %s %s", mp=
->alias,
> buff, origin);
> +=A0=A0=A0=A0=A0=A0=A0condlog(log_prio, "%s: path_grouping_policy =3D %s =
%s", mp-
> >alias, buff,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 87e84d5d..39504dca 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -125,6 +125,7 @@ alloc_path (void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->sg_id.proto_id =3D PR=
OTOCOL_UNSET;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->fd =3D -1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tpgs =3D TPGS_UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D GROUP_ID_UND=
EF;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->priority =3D PRIO_UND=
EF;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->checkint =3D CHECKINT=
_UNDEF;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0checker_clear(&pp->checke=
r);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index a1208751..0eea19b4 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -317,6 +317,8 @@ struct hd_geometry {
> =A0};
> =A0#endif
> =A0
> +#define GROUP_ID_UNDEF -1
> +
> =A0struct path {
> =A0=A0=A0=A0=A0=A0=A0=A0char dev[FILE_NAME_SIZE];
> =A0=A0=A0=A0=A0=A0=A0=A0char dev_t[BLK_DEV_SIZE];
> @@ -372,6 +374,7 @@ struct path {
> =A0=A0=A0=A0=A0=A0=A0=A0/* configlet pointers */
> =A0=A0=A0=A0=A0=A0=A0=A0vector hwe;
> =A0=A0=A0=A0=A0=A0=A0=A0struct gen_path generic_path;
> +=A0=A0=A0=A0=A0=A0=A0int tpg_id;
> =A0};
> =A0
> =A0typedef int (pgpolicyfn) (struct multipath *, vector);
> diff --git a/multipath/main.c b/multipath/main.c
> index 90f940f1..b78f3162 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -157,6 +157,7 @@ usage (char * progname)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_serial=A0=A0=A0=A0 one priority group
> per serial\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_prio=A0=A0=A0=A0=A0=A0 one priority group
> per priority lvl\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_node_name=A0 one priority group
> per target node\n"
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_tpg=A0=A0=A0=A0=A0=A0=A0 one priority group
> per ALUA target port group\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0 -v lvl=A0 verbosity =
level:\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . 0 no output\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . 1 print created devmap names only\n"
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index b4dccd1b..b65a543d 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -233,6 +233,10 @@ per-multipath option in the configuration file.
> =A0One priority group per target node name. Target node names are
> fetched
> =A0in \fI/sys/class/fc_transport/target*/node_name\fR.
> =A0.TP
> +.I group_by_tpg
> +One priority group per ALUA target port group. In order to use this
> policy,
> +all paths in the multipath device must have \fIprio\fR set to
> \fBalua\fR.
> +.TP
> =A0The default is: \fBfailover\fR
> =A0.RE
> =A0.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

