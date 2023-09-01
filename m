Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3789CA0FE5
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693585030;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Fzvu6wNsmhLRvaTtoBtbne/LSqHDOJH40Zs0FpNPUbw=;
	b=Ov0ky+YNT56iAcQ2u+1h5CwT4imlC0Bi3oYdxFCIkxFWKUEJLrWfU8xOs7T3qdKNRyMU5x
	ogpKFkV9JpX3RCjnzBArQnkRdD8WevYlotA0jnWsRNMmB2IW7T9jGBVYpHRzFLgvbRR4t7
	G5Eh5vX38JEfodYaEwPt2DraxvXsBgA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-wcPT6V8EPUine98gRjrcvw-1; Fri, 01 Sep 2023 12:17:07 -0400
X-MC-Unique: wcPT6V8EPUine98gRjrcvw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E438182ACA4;
	Fri,  1 Sep 2023 16:17:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 895BCD47819;
	Fri,  1 Sep 2023 16:17:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 445331946A46;
	Fri,  1 Sep 2023 16:17:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE67519465B7
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 16:17:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AB111404754A; Fri,  1 Sep 2023 16:17:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2D7E40C84A6
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 16:17:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87A04939184
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 16:17:00 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-LwUdHDwyPk-qarWUd5d-0w-1; Fri, 01 Sep 2023 12:16:58 -0400
X-MC-Unique: LwUdHDwyPk-qarWUd5d-0w-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PA4PR04MB9565.eurprd04.prod.outlook.com (2603:10a6:102:26b::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.38; Fri, 1 Sep
 2023 16:16:56 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::68cd:f684:ea5f:394e]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::68cd:f684:ea5f:394e%5]) with mapi id 15.20.6745.021; Fri, 1 Sep 2023
 16:16:56 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 0/4] Make prio timeouts work like checkers
Thread-Index: AQHZ3FYhX+2Lh6g1B0KrHPFyswCIMbAGJsaA
Date: Fri, 1 Sep 2023 16:16:56 +0000
Message-ID: <e0408fddb74d92e18bceb2e54af2335862365829.camel@suse.com>
References: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PA4PR04MB9565:EE_
x-ms-office365-filtering-correlation-id: 0ccfe94c-911d-4dbd-807c-08dbab06dcc8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: fZAzVuHSnofaLe9Yc0P7pXoPOK6sj7HljtTsp6167xKSrGCsDuj5s87W+XbPxuztivjtppQvo+vOmZ/RMIGZdIhRaJqR69t26tDSJKwEIV80oquzNWeJwU6HRgbpf585hUpixhb7HMZs71bi3m5z+elYLTpbascsxkh6QUsLvQLyFYhL/HSjiEBzvDnyfK7QMlmt9KeuVdVLPLrYbu9k5m6SyosvfgBULTH52OkbMGSTh8uapgrg9dvsG7QBafUzfM1ifxi5I+FfvRc14JDc8hqYgud/Tciik2PxLGqLaIQH7Tb445VLM9eFfLA5hFQc3Zn403+nILqBJt8gxihfhXpqm3GXIMb37CBd1vVUkqTGmofUeGBAcEz22/F/hGznpPqEGd6PWdV30Qsl5M6g1gzScQmVCASn6Q0JCfJZUko/szyobmARXNgLlm837iQtiXv/8BGqtLULodgruFvhUEyJUhFAnmLPz3NgEdGBq7fF25CgxR2mHVPFXnsh2dM6ZL7aN9sx2IBYnGWt/hRCUDBDcviWEOzuaeR5mxaleAtspLA570m83K2LDYupGYl1mBB7EhpB7SV7QNfWh0UA74hUnHSNAVB5eiedJYIf+4Nm4Y1Z9igM7JuFMUuwDKKC
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199024)(186009)(1800799009)(2906002)(8936002)(8676002)(478600001)(71200400001)(6512007)(38100700002)(66556008)(38070700005)(316002)(44832011)(66446008)(66476007)(66946007)(91956017)(110136005)(83380400001)(6506007)(6486002)(64756008)(36756003)(76116006)(5660300002)(41300700001)(2616005)(4326008)(122000001)(26005)(86362001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?0UwUOK4QORdWKi5qHLn5F4rgYFkgKjeGH7quZXmTDkGmcEALsny85gtvh?=
 =?iso-8859-15?Q?XIkR+sJtN/E0o8FVSwvro+1GOgET+av15IeUFapbBTgyoSBrIGw1zoNLK?=
 =?iso-8859-15?Q?tfdcEVn71LxfUvn84N+yc28pvBFeh4jnMkVHW0eFHStbfKy+vsNl8ZOxh?=
 =?iso-8859-15?Q?bxYkpsquaf99HPrv8G++YvGhD9iZ5szpBEdZIriLEnEfE7vf2z5Uma0mZ?=
 =?iso-8859-15?Q?MuvJZ06I3LIWxwUj2EACSJqDg+Jylcd6y8nCBaypluypMavy7sSglfe6b?=
 =?iso-8859-15?Q?Nz489xKsHysWoRcybZhb66ANfyooqiI+a3cplbW0WnDC6QGvk7JtpG7wj?=
 =?iso-8859-15?Q?6cAxh8khNfro98M6zBrHBZRv11W0/7HYSPbhUdqDjQPzQWjyLAHMRJMem?=
 =?iso-8859-15?Q?Oe58CphaoyqVz1qFuiHguz7CywaFvmvWomAjOnw/sdyaiGP52a9sY63zD?=
 =?iso-8859-15?Q?IGbYUwebnBd7dqbbFDcbAVpJaJVLimJSY6QgMIrF7zSdXz5cZ4szVteJn?=
 =?iso-8859-15?Q?VeW838Oy6Lmr4R6d6U9zq3u+8YiXKqQRgRDmFgmJHPyf5mw9452eBM5uU?=
 =?iso-8859-15?Q?tap1o5w9OpP2T0ecp8loKXAWv+M1iZFLizgYq6q883hbPNIxA3hBg4Miy?=
 =?iso-8859-15?Q?qy6nDadCXACIs9gAeoGWQmSpGKFTwbNcyg178Ar/r1HMrB7ra+HvWkpUD?=
 =?iso-8859-15?Q?Yk4nzChZpvDvAKp7p/kRFHQ9vCkAFSip7XNOMnHJJOTJUjEYILslYeyeM?=
 =?iso-8859-15?Q?QVeh9ZyAzKgodE9buH4tvfcpd9qx+R5FKcBg2dsZpXc5BuSBCjZoWQ+6x?=
 =?iso-8859-15?Q?mcWMc7tmdxntdo0NNoJ35b1qcWsj4UtxiBBf6zNr8alGemzfax8VLKWiF?=
 =?iso-8859-15?Q?2/adnGVYcSgzf4kqfCM9EqXOKVK7SXcbosQmyqpRb9UeFo7huE/ktf+hu?=
 =?iso-8859-15?Q?MCaS5xkeE8C+cJ3Jz/oOwB5uFMm16o7ALY/kyA8qmZnVaqx39p1HGMFpd?=
 =?iso-8859-15?Q?kHe2YAF39NbXLC19ikJDWUXxEhGBcwb46vpcSgYy3wOxbgKzb0C/0LJWE?=
 =?iso-8859-15?Q?FRJWMzpJVFrkOhaWP0f02dOQ9/nBlcDCIolLapfAUhjSUD9wvN2z+Ab46?=
 =?iso-8859-15?Q?Hs8sLySJxVv25BTUgRllPD/t5y9nrkZO/3bXosEfv6YWezDCcMTWqoFLI?=
 =?iso-8859-15?Q?E4rLAWS1MQiKfVFYam4oZdLZPXAI2YXS4AFRzB20GRwt8jKfBtuQuMHg8?=
 =?iso-8859-15?Q?oybAD+/2F0m6U8rNpvfPJjOXwgUKfXPBZP9XDdPHMiJP4SJ0NE9XyH2uJ?=
 =?iso-8859-15?Q?+b6hDvQmrGathKT7Dweg4UoFLR30amIpkww8pGKreG6e9aSQBDAWHFjro?=
 =?iso-8859-15?Q?D6JhI6BY7/HH+3VH3cMvaubNah4HOCDRQIHoyWD4JHX/ggNE3ahhf7oA4?=
 =?iso-8859-15?Q?dOnWDpvfUSYpmfaGdj4q99jD9uynFoKAX+q+uSL2aZdVp1Z/NylGWzjPI?=
 =?iso-8859-15?Q?SPpZIXPq+aPv9YHmzhxggwXbMCRpF2mEU71BIh0vVO044H//p0wffccID?=
 =?iso-8859-15?Q?XRf1xmOo4sWryeZhQzxRRzGwdj17j8JQcf0IB450LagVKinRs98EOg2lE?=
 =?iso-8859-15?Q?N8auiF6jSQka135N/NUqeeNRfqgphcOl3VWCmr4St/HGwqZfTRp4Xzitj?=
 =?iso-8859-15?Q?4H5OUqPX+QhG84410sthElI97w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ccfe94c-911d-4dbd-807c-08dbab06dcc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2023 16:16:56.4949 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lNPigXBjqOIVvW8ZjpfnxhsFqnXeaxMZc2xOY0IK2QcGbMtA62cGfKRlnX+xq+MO8tklevRqS/2omdghFA8jNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9565
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 0/4] Make prio timeouts work like checkers
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <CF1A8DF6956D0B43833719A4D7345D7E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-08-31 at 16:57 -0500, Benjamin Marzinski wrote:
> This patchset changes how prioritizers set their timeouts, to make
> them
> match how the checker functions work, and also cleans up some minor
> timeout issues.
>=20
> This patchset has been entirely reworked based on suggestions from
> Martin Wilck: Patch [1/4] no longer rechecks the timeout values at
> all
> in the checker loop. Patch [2/4] makes the checker_timeout a path
> variable, following Martin's suggestion. Patch [3/4] roughly
> corresponds
> to patches 2, 3 & 4 of the previous patchset, except that it uses the
> path's checker_timeout variable to cleanup a number of function
> calls,
> and incidentally fixes the issues in detect_prio() and the
> path_latency
> prioritizer. Patch [4/4] is new. It makes the datacore checker
> respect
> the checker timeout as well, if no timeout is specified in the prio
> args.
>=20
> Benjamin Marzinski (4):
> =A0 libmultipath: don't bother to recheck timeout
> =A0 libmultipath: make checker_timeout a path variable
> =A0 libmultipath: make prioritizer timeouts work like checker timeouts
> =A0 libmultipath: standardize datacore prioritizer timeouts
>=20

For the series: Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

