Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C355C61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675351389;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LMFFPV4MBziXk6fUEvlNGxmwL/E6tKCL6qI4EPQbscU=;
	b=Hs8vGmfkg0hGxgWVCNVL04bE4fl16NFwSqVI64tBu7RunF+g2It5eF/qSHmwW0R/f4S7i2
	Io3TPdqqIaTfXHiz64fdbWCxWwuZFm8eavyhmsyEPTuLi1GXWV2TLqeORgVpLa0RstDBK2
	22qc+UoXPcUAfzPMJ4AOQuyZ3YcN2pg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-jIAc9waNPb-MsfZftLSn0w-1; Thu, 02 Feb 2023 10:23:06 -0500
X-MC-Unique: jIAc9waNPb-MsfZftLSn0w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3987C800050;
	Thu,  2 Feb 2023 15:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1F0C1492C14;
	Thu,  2 Feb 2023 15:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA25A194658C;
	Thu,  2 Feb 2023 15:23:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E4AD41946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 15:23:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E813404CD82; Thu,  2 Feb 2023 15:23:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5571F404CD80
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 15:23:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32E151C051AC
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 15:23:00 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-JMP0DrO3M0Gz2r9NaoZvPQ-1; Thu, 02 Feb 2023 10:22:58 -0500
X-MC-Unique: JMP0DrO3M0Gz2r9NaoZvPQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DB9PR04MB8281.eurprd04.prod.outlook.com (2603:10a6:10:25f::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 15:22:56 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%9]) with mapi id 15.20.6043.028; Thu, 2 Feb 2023
 15:22:56 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH v2 0/4] multipath: fix multipathd renaming issue
Thread-Index: AQHZNlXFtyvZ2dg41EmFgpBob2oV7q67xXRlgAACUoA=
Date: Thu, 2 Feb 2023 15:22:55 +0000
Message-ID: <fca5064aca5f7df92aff4c4c0417cc8ac7efcfda.camel@suse.com>
References: <1675266989-8281-1-git-send-email-bmarzins@redhat.com>
 <5cfc86dfe02c991f1aacb75a6c2ccfce289f298b.camel@suse.com>
 <20230202151429.GB17327@octiron.msp.redhat.com>
In-Reply-To: <20230202151429.GB17327@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DB9PR04MB8281:EE_
x-ms-office365-filtering-correlation-id: 0300d83d-485f-402f-9a1b-08db05315c30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AQ/uosv1o6i0tBUzPaW12Ja6fDZqhoy3RMPwzJ/HJghPiVMA01pKVwuBXc3FwoXgSALlLGlGc/V88nokQrnydxcdGXFR7J96inMIfl4zm/BBH9+olsqmvajiCz6RkgJhvl6NuU/i06/C/8t9nK/mNaZaLUvR3F+HicxQwG1Xr36JgHMBS7jdYxMloMcNHcQyI772gKgblXaEY1N1oZt9jIKCEGTNbBqq3gNOeGN+WijMjyzcoXcvVsaPSEJnKtOAOV0RUZ8qmOlktoM6eAL/prJ6GRGlMazxPTpI59n5/mquvzjZh1CrVHxMj2aKvPD5DkpMtQ1XH9yLS4axVwai7OcJzckJZjKesdHfdAmls9/jES3V+3IP36ut9UiX+/wgU8G+dXJ++tB1znLnUy43+GBYIAoj6KtOXkQPJgeac+Zt+H0QdmuEd2y0DDMAyL2TECnreEFilgq6/QmEyd1UVywrkC7UtrGU1Yn+lZiiTk06IorG/iHMajI5fFRgXPs9yQ5UjL797M3zLb6fkv52vab+8i7uJT0nR09V73yAmfLfyFXfvG2ehqQf6B6GlvNDEUQjPpZYrSvObjJCtwvJHNBgPFkYzcoPZD0WrYU6QaWvK47P8oRnpSLLnantUisSTLMCIKHwkDuw6PhvYLxJfjZqLtsnt5z1ZizeLYqs9gEnl4jBU+s+UuTQS0wSz0VL0pcWNxPSwSfizQwDFtwh3A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(376002)(366004)(346002)(39850400004)(396003)(136003)(451199018)(66446008)(76116006)(4326008)(8936002)(8676002)(41300700001)(316002)(66556008)(91956017)(6916009)(66476007)(64756008)(54906003)(66946007)(38070700005)(36756003)(558084003)(86362001)(38100700002)(122000001)(71200400001)(186003)(6486002)(6506007)(6512007)(5660300002)(44832011)(26005)(2906002)(478600001)(2616005);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?TtmUyXRiFItxgc7aJ5qpdrVE0G76+g0DZJTSYTdsdgE7nXYcmEW3dcYUH?=
 =?iso-8859-15?Q?W498kB/uH0EPacBuP46az2fABctBO/5Wo6D2zHPSvLTtVtUZn2XL5chPC?=
 =?iso-8859-15?Q?pjmx3mOgbP2U6v40ov4XiRxeT+O151FMsenRme6Q4Cmpui0LbsavMo+QI?=
 =?iso-8859-15?Q?H45Z4bWPeu4Y0uxpSUtBBFG9MhH6vBh4Wpv9zSUtcLNsit3oFD+CS8J17?=
 =?iso-8859-15?Q?eNqerRO+MfBb2w2vi14/p4/3znwAlc62uZ+R7Wht7TH+RBHl0UdlFWqvR?=
 =?iso-8859-15?Q?9BedTdALPlMPX5BS+p71MChSY3diLyrcl5f7RVWBw0BVOGe3q8ortqCgt?=
 =?iso-8859-15?Q?z06kg7jnPJTq6cj9oLlque6yVHdm27ymR9xUUarjdO8NlTOysYuJStiY+?=
 =?iso-8859-15?Q?8cWKEJ+6sIIugXPCE30DFUUtObBmzjGHHfXlpu9/Suk229LcnICHRJcEy?=
 =?iso-8859-15?Q?bjclDvTmW0mDoHDGvfroUF3JG6KiBLb1DY2Mzy9sukrq3CHK0+F+oVZr1?=
 =?iso-8859-15?Q?20kl6Z4jtWQz1GL0DVwt+ReE3gb1+GG/KfZyVekZhTbiwd1L8F0mCZ1fo?=
 =?iso-8859-15?Q?EOOqmhFq0FDu1bX4X2sL5nfi/hmN2njuKqg9EnybMJK7BPdrd8VChKxGl?=
 =?iso-8859-15?Q?WflPSeic9Pn9/LOEebVitdwamjyayKvoe6HERAJBJhSgnSEjGZoY6ZvUC?=
 =?iso-8859-15?Q?nXUwXsarwRxwChU0WHrhXlmezE2xYUAf88x2gahdpHWhdlbxTtHWJrZSP?=
 =?iso-8859-15?Q?zF0mvy4fzh3xQu6tFzQi/hrkBsefeAlkEhA4qNO4IXO0XDEvHVCUeBYp6?=
 =?iso-8859-15?Q?66L5rzvqRWRTAJYKJgw7NgAHM2YR8Nk7owTSaqx/eM4bhBFHyQeTT/vYk?=
 =?iso-8859-15?Q?J02coE+vICGrMXe5vg+tFY4ToDUc1bkpQypK6N4f85Aj8GewAMebbxtI3?=
 =?iso-8859-15?Q?VE784TwAsiHc3stM6pQWIBNhbxcrUiatPB1TioMBJmT61uodO9KS/AbvQ?=
 =?iso-8859-15?Q?SIH87a17WhXUj9S+eBPVmS2RyBnbQJ8quu1bsGTjYwPGbV2XwdL94TivW?=
 =?iso-8859-15?Q?5xNTh/BAL+850g5h2NZZIYW0Bm0GaSm4CcBilcZ90XBfaV0svMKI0zh2s?=
 =?iso-8859-15?Q?91L9CTFXNG/rW9j+ynU1fLlQ+2Fo6yggtJuhEhlTiJgt4Z/jDRj3jqw/7?=
 =?iso-8859-15?Q?Eqceojxh2/2VbmfWLjNbPj4QwO7xPx/BzfqM7wdsbujgNa53SsIbj6wCv?=
 =?iso-8859-15?Q?VCrH4V7hDG+w4Lv2poP61jHBP6AurlzPh/wolAeqamf1TxcNnpi3ACPQY?=
 =?iso-8859-15?Q?nkFTxwAFpyMYKVXweNv5EWknwMab4u0gOqIrZvraEyeiFWeir5GtnjmmV?=
 =?iso-8859-15?Q?4a3GUv+ZDcr8igXw9csjE94v5d3okUg/n9gIgYB5kY4YhnX7HqWAGs5IU?=
 =?iso-8859-15?Q?RXlfZAjcEX2TEtNn1oN1unYvNqPqRU723YuEoZpeVNRgXi8eWWuOiB7hA?=
 =?iso-8859-15?Q?lnFsGgH20vNEZJ8gMbsCGaw/wyORbU0RkCIYUJGBk5HTlyXagyO61yfBg?=
 =?iso-8859-15?Q?YlAtZl5xw3PirzNXNa+/ijEJf6WxwMIYnxJbauCTQhsrqlrot70UX4Fxx?=
 =?iso-8859-15?Q?+6/9tNwRlkoCNGbYMEdEmOrgueEajIJDxlCkx37G3JxxX4D6s76h+TdiF?=
 =?iso-8859-15?Q?Bunb+Qt/GjZNjEy63XiomdvGWA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0300d83d-485f-402f-9a1b-08db05315c30
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 15:22:56.0657 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZ/0U26T01992eGqyJ7aNvWbwl6Zo62NUwWmiwIWGFgziX49zo9GIW6BtEo4p7hgOKFHDVyfh3z+kWf2q7LmFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8281
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 0/4] multipath: fix multipathd renaming
 issue
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D5A747E2850AF14A8836E0695D4D893E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2023-02-02 at 09:14 -0600, Benjamin Marzinski wrote:
> 
> It looks like you pulled the first version of my patches, without the
> fix you suggested for impossible renames, into your queue branch. 

Oops, thanks for noticing and notifying me. Fixed.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

