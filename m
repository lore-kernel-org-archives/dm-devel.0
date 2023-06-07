Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC06C7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686162765;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LVNeAJCvMXr11pKn3Z0UJuy/z7awqUABUZFTnXQU2Yk=;
	b=gYD8pQceQzHmyoOvHpHV2fa7MQHuNXEcczeTAws7G07dOJcqAG/716mBvmWg9+JBSWMn3w
	SUIs8XzUFTo9zfDuY1jzJpvp6ekqGwjMMGA54bmZoz+2hV5nvI7Xz2x8xGAHoi5Px0C4iG
	s+QvaW6tgj2NANyyr7uW5RS316/82t8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-laUue5NUP6ucPB_VDQ-2pg-1; Wed, 07 Jun 2023 14:32:43 -0400
X-MC-Unique: laUue5NUP6ucPB_VDQ-2pg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D870A185A78B;
	Wed,  7 Jun 2023 18:32:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C108740CFD46;
	Wed,  7 Jun 2023 18:32:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5AD6419452C3;
	Wed,  7 Jun 2023 18:32:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7776819465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 18:32:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54BB1C16044; Wed,  7 Jun 2023 18:32:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CD36C1603B
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:32:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 308F2802E58
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:32:39 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-3jxHhwApM7amyvbbPFy7LQ-1; Wed, 07 Jun 2023 14:32:37 -0400
X-MC-Unique: 3jxHhwApM7amyvbbPFy7LQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DB9PR04MB8204.eurprd04.prod.outlook.com (2603:10a6:10:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 18:32:35 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6455.034; Wed, 7 Jun 2023
 18:32:35 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 08/11] multipath-tools tests: add tests to verify
 PRIO_UDEF changes
Thread-Index: AQHZmLNdvatN7cPc0EOTyScAdOKg5a9/q3MA
Date: Wed, 7 Jun 2023 18:32:35 +0000
Message-ID: <c142a90d4383ca2b014735f2f6fee6794d96dbc5.camel@suse.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-9-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-9-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DB9PR04MB8204:EE_
x-ms-office365-filtering-correlation-id: aaf874e0-4a93-4f1d-b19e-08db67859076
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nOzupSRvmVjFIv6U7rvx68+fJ17/xZw2mUwyd8VC8Pvv4BuscKvRcA1rInwwEN/XK+kmU3OlTZrHgPQ4Ae2khgwqeMlNb5E40sj7IlD37GLa1YLcMnyYkvslbRRqnAYK5VgAqUv/vSBmWdtqI0MHJBuNKm9qUOgPp3jcyCTDo9aWD0FtsZZl1apbvkf/FUf3ly1aRCn2gDgV04QIOntHKpWfkZqqQ/UWb4CnTc1Tn3sRg5owR9owOlV/Dj0d686ngfgI/EZlMBUmUGp5Iqco3B7n9OvnQc2fUzumIa2yWPMwbsOr45lBjJUG3EUFwvFxB3Z7arDPeoXsw0Mozysv2xrGElD06ywiIdslIRezEFCfGc8JshEJtJZOqmpxwZfbVjoZV+qenNn0YMvAcW+zeSXtxTnMyK2r3TpTIaBNVE0l+WVpq3SDapVxKOUuSibw2o84ueTWsXQkn0d+VY5kaGCz8DRegwuMxI4GUScydPJLBqAaYrPO52bwy77xcnsyup17/rm9OLMHnS9Y79EI2ehiv3cpdD029cxr61s0czHKML7hlsX8jeVGaGYu4gPtHSk/4DmuLTdFJhnRbewDJtbVtQ9sRBwP73s1OWZ6UwPFGzpEpNi/NRFLT2w0dzGH
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(376002)(39860400002)(346002)(396003)(136003)(451199021)(478600001)(2906002)(4744005)(6486002)(36756003)(71200400001)(38070700005)(2616005)(86362001)(26005)(122000001)(6512007)(38100700002)(186003)(6506007)(316002)(5660300002)(8936002)(8676002)(66946007)(91956017)(66556008)(4326008)(76116006)(66476007)(66446008)(64756008)(44832011)(110136005)(41300700001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?MEtGq8qSR7TJ5TAz/r0fsHSJBinw/dD6yJMRN5ImI2LhTtDFdEhtx40y/?=
 =?iso-8859-15?Q?aCsbSVMWd0/foeVHb/kEniggsDiE6bj0QqvW4Bf8EemaV8ZwDxbiuBQ/a?=
 =?iso-8859-15?Q?Nb/D8k8rdyzbqKnQRMbLXo/YTrhHxSgWI3ij6oCDfdb+ntKR8dfOqlDvS?=
 =?iso-8859-15?Q?BBT0gGCcJRlbjhkMq1IygqsscdQ+mar27WHjAIDnOv8gERzglQHYZaKGc?=
 =?iso-8859-15?Q?GMqI0nMcGfl9ej+xj+oyOZewYlP9Ih/D252nfRLYE5/Q3BQP7gTBIy0OK?=
 =?iso-8859-15?Q?EQFnSQHIlFgUYPCAs91g3EX7r+Gg2w/XAaX0T0gjT8D4mlvSN3rml1Ck9?=
 =?iso-8859-15?Q?PzpHEJp3/UsWHz5YG2nCvtT9Va09ZePVQyHMIC2jZ1fAL8VEe+WQfJbAi?=
 =?iso-8859-15?Q?B97ZchdU2OdwZ6F/n+DJjYkPfqWr5vh2rVD6B0rFpdkv8fozHI58nZoTs?=
 =?iso-8859-15?Q?pZzNi6BY/iA4yVCLRocKV9iatA3l6ZVfgg/vFxqBY+7AEa0eT03IzVRDV?=
 =?iso-8859-15?Q?Wo4t/SOn0JXl5PLP6xasYng0ef/XAd2RoD9HZyDGy/cH5i4U3dpF/YTMo?=
 =?iso-8859-15?Q?tqdVVuBqARIdMNZhifbcEyooFUOI9T8c4uOndVKNqgONICKeE5OVKFrLJ?=
 =?iso-8859-15?Q?h8osGgNLcS2bi3n5NpKHSB8bWbnm46KdCqfnvb9tUKu9iq014m/w5q2dF?=
 =?iso-8859-15?Q?JuKyCFbBAj9F8vGLst62PLA4/GSYPCp0WdIWjyveDHXIhWiOueZ7pqjrw?=
 =?iso-8859-15?Q?0ZPb1WpWLqfuA0ND9MJ9x8/qGZwK1dclH9Wcf5wVeFmXtCtKJyt/CnWdE?=
 =?iso-8859-15?Q?l8/KsLHXbc6Kii6ZMB/D+/EYxU6CF5vhDALIY423RWc8NK9NL0P8eif57?=
 =?iso-8859-15?Q?ayp0udPBlFf5fC9MBlMxTnV+jLIFRQKEdiaA1DtOPfoM5oINKgBiNhyR3?=
 =?iso-8859-15?Q?vlb23or77L5N0eElDYoSt5MYXuKJNT44mYcJxQhDcXEJTrPsUqDYcgK5w?=
 =?iso-8859-15?Q?dmMzsUxbBmzp0mggbxeLfeHd9IvWSNonv/ZkXQztGMUSm4nvfjI4VDMcL?=
 =?iso-8859-15?Q?DGM48qYJZSZfVh0HMtFbTUInlBfxDG2pEeuiUkprWnEBp71A96TR6350g?=
 =?iso-8859-15?Q?GcIWdnrUQYBAoUgdjRZNU30l2AMiM47ltQOZ+sw3+spne9K2lWx9fuDI1?=
 =?iso-8859-15?Q?uVanAU+P9xrinhjo781gYxH2O0EC8lj3my1as6Gi4lV9ynrvn4gBjOYjW?=
 =?iso-8859-15?Q?xd+qWx5jNni5J8n1iNDJNvDnoHxvs+orPsWmwxm5kLDpX8vU5z/ikU4Ep?=
 =?iso-8859-15?Q?H9D5mSpI+IEOa2pvlNiiLrrB37Gy5TJYZbWoXHlnDP6xvwVdVkP6M/hNy?=
 =?iso-8859-15?Q?GfwzZrVyooOfzNNyH/UGRRmLCTw7AH9afAPlzEV6kAz9Wq93I9KXOqREo?=
 =?iso-8859-15?Q?wVNL6uj/g58RT4q62hMrWzRPOlwn/tY1IHXrhJj6CzyACrYQVZX8KroWn?=
 =?iso-8859-15?Q?AtxJdzWKTJp1kTX6hHrvm9Pdd2fM6hNI87d90MVLQtVhPJgr7aC4b1Yos?=
 =?iso-8859-15?Q?4gBpdV8M39H+DxLYlUxJdOOqs9PgsoZGfqKJuqFmvsXEshxSPFfS2ria3?=
 =?iso-8859-15?Q?cPxhmtxjWmOYJgfTNN19jDc6hgHcsEF9+BSraJU7g8lgdJcTqy60b6C05?=
 =?iso-8859-15?Q?C2dG?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf874e0-4a93-4f1d-b19e-08db67859076
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 18:32:35.4884 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KUlifObLzAgrfi/DvZUt94RFfTbPSaFxSxkOSpbnXKU+R7UIdroPNW9l7g0rKObwDFQhfLhPFoOcjFkBTL9N7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8204
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH V2 08/11] multipath-tools tests: add tests to
 verify PRIO_UDEF changes
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
Content-ID: <222727071C8D854DAC9DD4780D657DC7@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> Make sure that pathgroups that include paths with a prio_UNDEF
> priority
> are properly sorted.
>  
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Nit: typo in subject. I'll fix this when the series is applied to the
queue branch.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

