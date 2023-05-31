Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A78C7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 16:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685549705;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jWC57RXkbcwO/FVFSVDQUeb9NtzA6rTdDF9Lp2oU8r8=;
	b=GvTttPp+Ms1vTAGGPztifGZm3odO+QD2H20+MA4uwyDrnJwZsOM8kfE9jzD3x0r71CYETp
	FhgJ6eDgAaYGCuxB4Pqr4ZxCwetwub9/baGitF7NZ9Invk3I/2uv0LPwuo/LUIAU96TOOi
	MJe2HE6MMBQebY+3UwoOesBTmdNhmOg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-v_ODcgEqOxuBEJkW8d37Og-1; Wed, 31 May 2023 12:15:01 -0400
X-MC-Unique: v_ODcgEqOxuBEJkW8d37Og-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D04B293248A;
	Wed, 31 May 2023 16:14:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A883E2029F6D;
	Wed, 31 May 2023 16:14:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84A0919465B7;
	Wed, 31 May 2023 16:14:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A16B41946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 16:01:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 819F6492B0B; Wed, 31 May 2023 16:01:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7954F492B0A
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:01:57 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E5C8802A55
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:01:57 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2087.outbound.protection.outlook.com [40.107.22.87]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-y2w02clGM9umMB4oWqiQAQ-1; Wed, 31 May 2023 12:01:54 -0400
X-MC-Unique: y2w02clGM9umMB4oWqiQAQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PR3PR04MB7482.eurprd04.prod.outlook.com (2603:10a6:102:8f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 16:01:51 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:01:51 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/5] libmultipath: don't count PRIO_UNDEF paths for
 pathgroup priority
Thread-Index: AQHZjpZ1NSdGt3J2WEOmsWplZn20v690lT4A
Date: Wed, 31 May 2023 16:01:51 +0000
Message-ID: <48129524e844776a33419b6d7a9391819f3c6ca3.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PR3PR04MB7482:EE_
x-ms-office365-filtering-correlation-id: eeefd792-9b86-417e-8266-08db61f058c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Kmb/BN+OQq+Og0xIqTHGSkL8Nl2L7KQqwpBYUq7Qt3zuU5FfPK/N/qLVwVJnHRrtmFOGzglGnH7+fxV1GW2htFX+zP7SopCCK1fpnaDFwRGjciXuwL/SK6dPS8hDwJsME57N3q3e62zqpjQHborEB061q3IGUfnnGo0K05oKTWavWbVMiKmLqVD6DpsZyFgyv62tFkcB9xsNqtdu7LxRsMLkfixRpN8zioD+8pYPuUVdiQMxBgjF44oiDD9ihxhUrwJ2jaPeZExx4EOmHB/gD9Cy0V/2VUGPtJCavRM8VZ92PkDZa5y/EsQT0S+oHCJM/0L2Q/aJvBeerDvv9Qs2HO2dsnmF7FiEvDaiav9jtnipZsxzXisUE/F5xrpaUcJIhsKq4HrWR0qSx6rIrryS5bEESj6ZYMN55tT24qwqBG/Ix4KaGYzIvZM6fS5COqnzGRR+eIBH6KAhWhhN3wFARPHV6OdrPvDuWh0v0OPLnRKl4banV2U/yQ6XCckzbXFWjpEl8t2mHO19wPEwV93sHCQT8KrKe3NRZeMqk+BW8ylnQifS2A5Tooe7tGDq4m0is1qvwxgQqUuEn4JGj3FDEX0B6HtnpDHTOOqSApZ0K6UdMCnpsnRfK57sq+mPVOK4
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(91956017)(44832011)(76116006)(64756008)(66556008)(66446008)(66476007)(66946007)(8936002)(316002)(4326008)(41300700001)(110136005)(8676002)(5660300002)(4744005)(2906002)(6486002)(71200400001)(478600001)(6512007)(6506007)(26005)(36756003)(186003)(83380400001)(2616005)(86362001)(122000001)(38070700005)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?zL6olrgzwkwBhdkUbcGiu2jvgf++HsM4sU3DHZdrKccmXJfQJVJRm4wSg?=
 =?iso-8859-15?Q?db18IIPdxE/TEj2S4OMoN5bXo/1CHOc5n3JKg/8/YtnDHWTBK+DLPWZbx?=
 =?iso-8859-15?Q?UIYDiM9p+lAqSyDsVoQMnW0/q17wYzw2sQ2fkwWVEwhLqTlr9S82HLhPy?=
 =?iso-8859-15?Q?QfSz8r1aGuG7B7pf858KVdoWr0n1i9FrdY2TAzEZn5/JoMBUshGe/4G1W?=
 =?iso-8859-15?Q?v867kAheSLq8Pl3KmDYcP92zBc3IRzIJDrnAb0Yl3w73sja1IzecRY0Qz?=
 =?iso-8859-15?Q?r4oZMeFXI3IGO/Skp7kbbzYEwNLIB8pihQPs/4ANnHF/oDMqKRNtd1FSi?=
 =?iso-8859-15?Q?Mn74WEa1fJf33ZE/1R2Bjs/8EtDG0aPUUDY+uv1DSexDO/3DitWH65+k/?=
 =?iso-8859-15?Q?JRkqEGDC3fxwd+8CUYnxm6brXLVMagkXpM/XSxHoWyEBiUkkUZ5x1vQus?=
 =?iso-8859-15?Q?akTrRUtY4telOHkhLAkIXj/03GBcjow9ku0euUhm0QzC6M9ZpesmGpWBa?=
 =?iso-8859-15?Q?qe9WipKJFxmaSXxBiO91RWrwEMFQIfjurvf2KPGQ7rv9NEG7/+gtQv5vn?=
 =?iso-8859-15?Q?9YOBzL4DONdDBnpcNi4VUBwCHm5Ti7iBvqgxEfjUfaDSSVZfyE04HKjJg?=
 =?iso-8859-15?Q?F2AaoaVyTH0lHxKttMVB1eOAi7J0UxpyVL0Yk8DSeXLNq04VgSgoHcFHG?=
 =?iso-8859-15?Q?xH4IKXveEz38/9K8kAlNvjVGDxV5iFu15krtuLq4lHXJDW/DhuXO+ZW4y?=
 =?iso-8859-15?Q?mhbwsGJHDMjgXmztfhq8LZpuBVNDgIEzcj88GbTzH7rDksecFuU6ldAim?=
 =?iso-8859-15?Q?5FEmuYoN2s33SGplRPGkrScr0MgubqV9oOmnnyhe+9sMWBU5zI9omiVJ2?=
 =?iso-8859-15?Q?lN0c34Qa1oNusn08kMHNlnuuqFDAGpB2PnIbnsA5MtKQIYqrUPkzTHyfk?=
 =?iso-8859-15?Q?4pgvVI8RIhl0qa4XM7ypP3r/cz7XtngrdRmkZkJmYwfB0Gyd+B3scPpP6?=
 =?iso-8859-15?Q?W9Au5AugOnz8t1cBj4suEySAWkIuNPXjkcPF/iVCnddstJJ9ngIH6BDhj?=
 =?iso-8859-15?Q?B6/dpWUj76tw3wVV3qN11VgtkJ95YtEH4n0nM9FEuc4L+8njzu+toET4Q?=
 =?iso-8859-15?Q?ZE7hkgS6i+eZEbVfWEAa1qfEQ3AoNX9uPUKUAIUUDjHPed7bgmpAKqaj/?=
 =?iso-8859-15?Q?rGC3/AiayC2YOxBfj6B9B+GbKAVjzFfCrnD1pyKJ9tGYpvw3Ww77nfevx?=
 =?iso-8859-15?Q?aypCULNiZbyHZVd5zSqAcp1M7cJSYi77aNn3sQpsggIKjeXBl2lYRzcN3?=
 =?iso-8859-15?Q?SGSo93ftrAusSpwb8UWO19/leRzTXofXeWC02pkFFwp4Gtzm00N4grlHs?=
 =?iso-8859-15?Q?zZ3SF26rwka6UVf+2k0brdc/+53T5wYg4VgbIs0XwcxKxDx+3XOGS0XOU?=
 =?iso-8859-15?Q?FcFz02qIgWqGZ1lPSH4OgEN9g71W4ZjM+j4ruXetH9w9Ew+ihcAdZcpEL?=
 =?iso-8859-15?Q?mRbXTXzITcvncnJjFKgL1EvucTTTC24rP4315wjQjH18m4gchqn+/Sdq1?=
 =?iso-8859-15?Q?jjEanXFmpyYPL/1lloS1JqA/etzNvkc8yoQ1m6NngDPZETjM3BajYASZE?=
 =?iso-8859-15?Q?givb4Ha+YigoESVUtuy5S7UHTKo9r7cnZMqShX+WvMTq8lIP/+F3um/AG?=
 =?iso-8859-15?Q?Fexz?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeefd792-9b86-417e-8266-08db61f058c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 16:01:51.2357 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w1dh7oaVZ4TYDKTdHlXNvCIMntdKrGPXmViYWgYe2BPj/tuhcZaWzBimk0JsPixRf59GHYfwYfQcyfd4NRoAdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7482
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 1/5] libmultipath: don't count PRIO_UNDEF
 paths for pathgroup priority
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
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <DA00F0091C66BD418028B5D40458CDD8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> When multipath is not set to group_by_prio, different paths in a
> pathgroup can have different priorities. If there is a problem
> getting
> the priority of an active path, its priority will be set to
> PRIO_UNDEF.
> This will change the priority of the whole pathgroup, even though
> it's
> likely that this is simply a temporary error. Instead, do not count
> PRIO_UNDEF paths towards to priority of the path group, unless there
> are
> no paths that have an actual priority. This will not effect the
> priority
> of multipath devices with group_by_prio, since all paths in a
> pathgroup
> will have the same priority.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

