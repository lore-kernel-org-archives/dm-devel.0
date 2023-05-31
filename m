Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0697C7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685547444;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f5Mg+WUTShN7W1ua35S9xAFt7FEA+YUPqFvGRpIiCT8=;
	b=UrqXTHlVP4TQWqRzYWwKmy/B5em0iS0TJu7eLP9ytLIwV6kZ93afes6kdy5aUttHnHTHqR
	gi2yxECfRmIXie7td5U2CG78ji8HnRl3RFJJTjRALaTfs7jqgJvuaq+lJW0cTicXwLbh4v
	BWzBXH3kgCZEEyPdCBOhH4ggXNzzucU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-Bt6j0AAdPZGY7HsNfQ1NkA-1; Wed, 31 May 2023 11:37:21 -0400
X-MC-Unique: Bt6j0AAdPZGY7HsNfQ1NkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62CAF800141;
	Wed, 31 May 2023 15:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4ED3A421D3;
	Wed, 31 May 2023 15:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 02F3B19465A0;
	Wed, 31 May 2023 15:37:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E708E1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 15:19:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BB8BC154D9; Wed, 31 May 2023 15:19:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 92ED0C154D7
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:19:06 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6877A858F18
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:19:06 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2082.outbound.protection.outlook.com [40.107.20.82]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-fxh9j1ZTMJ2qQwEPgPJz_w-1; Wed, 31 May 2023 11:19:03 -0400
X-MC-Unique: fxh9j1ZTMJ2qQwEPgPJz_w-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DBAPR04MB7351.eurprd04.prod.outlook.com (2603:10a6:10:1b2::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:19:00 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:19:00 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/5] libmultipath: don't copy pgpolicy string in
 get_pgpolicy_name
Thread-Index: AQHZiqX3H7i+IzVZEEaXgyaEWcdPuK90kSUA
Date: Wed, 31 May 2023 15:19:00 +0000
Message-ID: <b7138306a28e44a0fd68991cda5e7ef6220c2fd5.camel@suse.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684537332-23033-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DBAPR04MB7351:EE_
x-ms-office365-filtering-correlation-id: 40f50455-0d40-487f-c1d4-08db61ea5c4c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 06CtOBv9vsBSI3lgoy6WnHh8pjLbauILpalmchgXzSdPes3drEai2mqdRSUQqhh2TOaPOeg2eLRYkGhukWZ4W3GW83ZEjmtCUBsS/WUZzwsSL+I+QIT46sMMN/ayJ2hSHMGWjKQrITsMRVbElwl/J5qsdetlaNnzrzdnNidvCwfHns6Y7z12MJ/Xt67dm989b1pyJZ673IB26FmGTF2sN0yRqgUYvb+gVfhK978cf8vRpQBQxGgK9xy3M/uGZWDttwOLhrgJVpum+YtcJl6hpXbIno+aXahZhpaXeacBZ8GRvnjsghfucB8IZ8bl+tZc/EobFOTqK8eDAeBgqgWZ00Jzfo3/D0zRR0laHLdG0TxBT6kDjtXksLV1LF+4jO/deGTK2LlYgnvD1LMXsup+v9dwYjd33lO7d3TRFEwitua+NMbgVVTOoXopw8TcRE7mLKxMQuhc2E1wS29Ie4tJRHK/bbKppsYyAVNRgyBrM5SUvEYGigOTmhyIjtstD43zuXscCsKKBPjgQ77gq9yLVbfFxvKAroasPWXVC1s5/aTBVvuSvIdHWUq6xr+nEDxeKcRNjJd7wvN051r5z6wUVZLR16lLTefT1opzq4Rq4flAVM1bAnnJA0EEhb6ZRW3G
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199021)(26005)(110136005)(478600001)(8936002)(8676002)(122000001)(38100700002)(44832011)(64756008)(66476007)(76116006)(66556008)(91956017)(66446008)(66946007)(6512007)(4326008)(6506007)(86362001)(71200400001)(2616005)(316002)(38070700005)(5660300002)(186003)(36756003)(6486002)(41300700001)(83380400001)(2906002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?UsiDithAMcxDzrkUAthMAt8k9bPErTW3vdgoAo84YNmxm0AWB6C78HOAy?=
 =?iso-8859-15?Q?JkhQEVs2txAlQ0UpCqnzJspuYXUVRkLmRZvFihLBuhfOLvK3nsgqCvnOu?=
 =?iso-8859-15?Q?8e+C8cLpjmbpMuNwc2KOapbsoCjbBItALfPOWUXYfItMNGLC8MtpNug2M?=
 =?iso-8859-15?Q?t9mUrrWInUBUI13cNEcgV9QTKGxDb+IS44iEbcWnRjutNKs5EP05zYvIu?=
 =?iso-8859-15?Q?n+yO00kX14t4oR/ulu4tOL621C0tGYUDYndgE23u11KmcYgtvBM7cjMih?=
 =?iso-8859-15?Q?D/MRLMevS1DvqXF8bn2e1ImW1tMr3wISwwL7gIyEhBzNmc9ng+EQ5yBVi?=
 =?iso-8859-15?Q?nusJkeED7oB6R/RVvN0SDiqs3w1ucQlUkBOVrveyL5EbgGcPJM1rchHWa?=
 =?iso-8859-15?Q?L7a/7IlqayzelSUBVJursToxdFy83SDE+jAhbvZnx/Spvi+XlsZBVnpGZ?=
 =?iso-8859-15?Q?Ki8iZeX4Df/ekGJYM3m7uyTOCivPoo4ZQAR23Ck8r9ZO46zcb1esI0j2N?=
 =?iso-8859-15?Q?M8iiVJ0/3qrD151PLpMxqctJmVOwItsO9tWUBeJtt9JF9x3MxV8jkuaxz?=
 =?iso-8859-15?Q?y/OmeNs0bD0EShi2Y2Kaw2rlGqi82Aj5F7SfAn6bGNJLVdHIbRPTdEnYt?=
 =?iso-8859-15?Q?r2LneLMmazccyNObdEkehxzys7iBTal+wZhfCsg2PeeesBwM8y3pZeF20?=
 =?iso-8859-15?Q?WPRT+XmZRn82U2L8mHEqXTOp78jmREAdcCDfczptrspnq1J4yrzdY4jKD?=
 =?iso-8859-15?Q?6G4gO2nmaOV5rLoKeJPk0jF1OHTF8uQEmHvEUZwB/mMEeubB3QrPl9qv6?=
 =?iso-8859-15?Q?KIc9n6FdlhUOEmuKU3mhA8xsNe7M5GVsMRHKqL6wtS/Gr+qGumtr5ke3H?=
 =?iso-8859-15?Q?sobU+l/DXYHyjeSNr98B6wxrpUCzQfrrmQyNvAOGknJ/c89aJD2gd9rn+?=
 =?iso-8859-15?Q?0I4Qo+BmIGa3gW4R0PcrFDwPfgYzyyBHyIfZ3Ryq0XbPtYCaqujAJAd6u?=
 =?iso-8859-15?Q?8rHe0y+jm3xS+mUKHxf/hK8kya+bu1iUPxrgXNQShuKsisX2mj24i/Mff?=
 =?iso-8859-15?Q?GnBHoSh0DYh472/GkXRZK8/TOjfqEGX3ReKZNxcHpc0LpCGzeT9yGq0vu?=
 =?iso-8859-15?Q?j0K8LcOv5w/8Ny6NQYS9b5C+h5OuzAD6JHtxwkGXly0Avf9VhAWMdc7p/?=
 =?iso-8859-15?Q?9g0k0ISTtnitS/HV51+l6+H9nCdlDw7aWcMO74cpB1STy280dMmEQB7cU?=
 =?iso-8859-15?Q?+EL+dG5jEKutKP5hW5P/lrj1FttO4CZ13YVz3BAJ2BOwYPXj45cHMw3gN?=
 =?iso-8859-15?Q?WHxiNHCKASY/3xWeDMZqYHnXIVWWIbjnN+CaXZJXTdVzlqE2BRUbBqvku?=
 =?iso-8859-15?Q?9XG5w88iRjZDUXyc77nHWAzBde4Fg2a2D/wzgt7L4PoN/cS0R4DG58+IY?=
 =?iso-8859-15?Q?k4FdhnCVZ175FiMSkMLCNZHW3VtrAMXnr+WcKG/akO8ekf22GC0bWZQXS?=
 =?iso-8859-15?Q?EFfSLWEHWc4/AeTl+zSKPJSK2IlT8eJxdFYQAcxe5M2cbuqjCmlLQqX8O?=
 =?iso-8859-15?Q?wSY9g5sstkuV8Q0G1yK4Bj/gHa4c5BDZApinM+f28EyucDcJ4RDwWklmk?=
 =?iso-8859-15?Q?PaOFo/au9w/EMVThUdLLbQj6s239EgE6nRqggMBgtmuk3j0l6E32QiFHk?=
 =?iso-8859-15?Q?SMAW?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f50455-0d40-487f-c1d4-08db61ea5c4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 15:19:00.1501 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TIyc1JwaIABHalw0l3MjDMIibWEbhVTeStchQ5ub6oTpm89vaoGTdPvQhsj2S3fkNDbczRAmfRQMhfDDgwnWgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7351
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 2/5] libmultipath: don't copy pgpolicy string
 in get_pgpolicy_name
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <D8709CEBA65CC448BB3875001DD8DE0F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> copying the value into a passed in buffer doesn't help any of the
> callers of this function. It's just wasted work.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0 |=A0 6 +-----
> =A0libmultipath/pgpolicies.c | 27 ++++++++-------------------
> =A0libmultipath/pgpolicies.h |=A0 2 +-
> =A0libmultipath/propsel.c=A0=A0=A0 |=A0 6 ++----
> =A04 files changed, 12 insertions(+), 29 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 2e9b45f9..dddd3cd6 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -1209,14 +1209,10 @@ set_pgpolicy(vector strvec, void *ptr, const
> char *file, int line_nr)
> =A0int
> =A0print_pgpolicy(struct strbuf *buff, long pgpolicy)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0char str[POLICY_NAME_SIZE];
> -
> =A0=A0=A0=A0=A0=A0=A0=A0if (!pgpolicy)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0get_pgpolicy_name(str, POLICY_NAME_SIZE, pgpolicy);
> -
> -=A0=A0=A0=A0=A0=A0=A0return append_strbuf_quoted(buff, str);
> +=A0=A0=A0=A0=A0=A0=A0return append_strbuf_quoted(buff,
> get_pgpolicy_name(pgpolicy));
> =A0}
> =A0
> =A0declare_def_handler(pgpolicy, set_pgpolicy)
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index e14da8cc..edc3c611 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -31,34 +31,23 @@ int get_pgpolicy_id(char * str)
> =A0=A0=A0=A0=A0=A0=A0=A0return IOPOLICY_UNDEF;
> =A0}
> =A0
> -int get_pgpolicy_name(char * buff, int len, int id)
> +const char *get_pgpolicy_name(int id)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0char * s;
> -
> =A0=A0=A0=A0=A0=A0=A0=A0switch (id) {
> =A0=A0=A0=A0=A0=A0=A0=A0case FAILOVER:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "failover";
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return "failover";
> =A0=A0=A0=A0=A0=A0=A0=A0case MULTIBUS:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "multibus";
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return "multibus";
> =A0=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_SERIAL:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_serial";
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return "group_by_serial";
> =A0=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_PRIO:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_prio";
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return "group_by_prio";
> =A0=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_NODE_NAME:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_node_name";
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return "group_by_node_name"=
;
> =A0=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_TPG:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_tpg";
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> -=A0=A0=A0=A0=A0=A0=A0default:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "undefined";
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return "group_by_tpg";
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0return snprintf(buff, len, "%s", s);
> +=A0=A0=A0=A0=A0=A0=A0return "undefined"; /* IOPOLICY_UNDEF */
> =A0}
> =A0
> =A0
> diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
> index d3ab2f35..9e4ddda2 100644
> --- a/libmultipath/pgpolicies.h
> +++ b/libmultipath/pgpolicies.h
> @@ -21,7 +21,7 @@ enum iopolicies {
> =A0};
> =A0
> =A0int get_pgpolicy_id(char *);
> -int get_pgpolicy_name (char *, int, int);
> +const char *get_pgpolicy_name (int);
> =A0int group_paths(struct multipath *, int);
> =A0/*
> =A0 * policies
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 841fa247..d214281b 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -268,7 +268,6 @@ verify_alua_prio(struct multipath *mp)
> =A0int select_pgpolicy(struct config *conf, struct multipath * mp)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> -=A0=A0=A0=A0=A0=A0=A0char buff[POLICY_NAME_SIZE];
> =A0=A0=A0=A0=A0=A0=A0=A0int log_prio =3D 3;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (conf->pgpolicy_flag > 0) {
> @@ -288,9 +287,8 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_prio =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicyfn =3D pgpolicies[mp->pgpolicy];
> -=A0=A0=A0=A0=A0=A0=A0get_pgpolicy_name(buff, POLICY_NAME_SIZE, mp->pgpol=
icy);
> -=A0=A0=A0=A0=A0=A0=A0condlog(log_prio, "%s: path_grouping_policy =3D %s =
%s", mp-
> >alias, buff,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin);
> +=A0=A0=A0=A0=A0=A0=A0condlog(log_prio, "%s: path_grouping_policy =3D %s =
%s", mp-
> >alias,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0get_pgpolicy_name(mp->pgpol=
icy), origin);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

