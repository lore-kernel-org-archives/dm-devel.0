Return-Path: <SRS0=GC9A=EF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F17C00A89
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 21:16:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D1A5D20A8B
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 21:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1A5D20A8B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-PKYQXXBGMhu4Lh23sEG_9Q-1; Fri, 30 Oct 2020 17:15:58 -0400
X-MC-Unique: PKYQXXBGMhu4Lh23sEG_9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AB478018AB;
	Fri, 30 Oct 2020 21:15:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3058A19D61;
	Fri, 30 Oct 2020 21:15:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AAAD0181A86E;
	Fri, 30 Oct 2020 21:15:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09ULFn5W020147 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Oct 2020 17:15:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CBBFA1111C7C; Fri, 30 Oct 2020 21:15:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6C5C100619D
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 21:15:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50666101AA42
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 21:15:47 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-256-ck0PHjABObOLdUKB13hq2Q-1;
	Fri, 30 Oct 2020 17:15:42 -0400
X-MC-Unique: ck0PHjABObOLdUKB13hq2Q-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2106.outbound.protection.outlook.com [104.47.18.106])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-20-wXd23LfnMh2Gqa8eyPq7ug-1; Fri, 30 Oct 2020 22:15:40 +0100
X-MC-Unique: wXd23LfnMh2Gqa8eyPq7ug-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4074.eurprd04.prod.outlook.com (2603:10a6:5:25::27) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20;
	Fri, 30 Oct 2020 21:15:39 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.029;
	Fri, 30 Oct 2020 21:15:39 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/5] libmultipath: don't dlclose tur checker DSO
Thread-Index: AQHWqYGhMjFC8lt10kOGjZ1zvJEYX6mwsJ0A
Date: Fri, 30 Oct 2020 21:15:39 +0000
Message-ID: <095833a0bcbc5f1bb792555b43ebf526553d0c99.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603487708-12547-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [90.186.0.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb1dd72b-f582-48a8-f60e-08d87d18f3eb
x-ms-traffictypediagnostic: DB7PR04MB4074:
x-microsoft-antispam-prvs: <DB7PR04MB4074D1B6C5A663CDB0922651FC150@DB7PR04MB4074.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 7HmXPkmoplcB9X4Q4wEFRTkXI+AH/aloAdk6o4zYUe+gKOuz3H70u024YQeKZoDrQ2+Fxv1VEKcWsXIOYntcfAxNzWlhFngyGx8MqywYZZs5w4L+YIyQmXTCzD2SP/7tnVJ0ni0Y7PfrsnKpr4kZ9EUCsXAtE12J5uJQNDYPjEn9uWCMkIi2ch/brTxfFOqsYe2Q4r3BxLx8kzgHpTy78SQbrbiCqbppLAbacaNIlcufccpc9tdG/Wl+emKaH/0PXikIa02Ny+RO7z89C4v629DbjV0TC1ZHNj6meAcdIg0EzjFeQjylZQZTJoseJTrbz+IjsWQFJ5zaUi4C5+XSow==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(66556008)(91956017)(76116006)(66476007)(86362001)(186003)(478600001)(83380400001)(8936002)(64756008)(4326008)(66446008)(5660300002)(44832011)(6506007)(2906002)(6512007)(26005)(316002)(8676002)(2616005)(36756003)(110136005)(4001150100001)(66946007)(71200400001)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: MSxzKmK7EtyIFB3lI1h0nmyBhid2Vvf8sWo0l+lq2jO5xUfKft1PylbAQ44y4cvkgDjSP0UFw1NvQHv7p6ujJW/lzBK8OEUbqHv1pjOcOjbAiaBqnPlcQ7p/Garlh1XNYYgZNKA/Y54FEvuxYTbR5cYnds5Kmp9AJ/ot3e13Yuv0Z8iRYHF5lPA/bNEeE86hpMB+ggSap/4I86+wK4tLFGOQyrNQQlTMw8b4+KrtAAcBIuInB/FpGSNx5QYp1Jyoxs3ToC8tkFi0QsHvmcMdzYqwwoQgITTNxUHC72jTomhNzfjpgJ2Op0DU9u/hL9bK4my5s3zN67GgDvtrXliS+yRbd/prBTXgN+iPg5MS2xl5J3yQDf/OuKY9qbvD7Z3GYY9xpC2WxXjPsR/i0ZbqjxIjVlUomShZvxsBKzb/oLvKcZDeLsXwbtjcCP+vKFdPDt+fPvpbysoUDmpG3XkHBoa37RUkZWbM2FSlJGkk8zBlV+YsWgezKerCSIFTiaEZ2O1ZfwzleOB1EeczaOeytxclbMnOvJvxBzXbnThl2H0ymPmhJAJw5/OXqoAwMquFaI7ZuN5gA7vhrJNn6loMw6taWRS8/zmgf3SVGxNJ2TpokgF6KVcbcSH+mnWgvH4f0aUyhG6o7aFMaF9s9fKGjg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1dd72b-f582-48a8-f60e-08d87d18f3eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 21:15:39.7340 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQGoP4JATmUQtKSekEQn1rRkiQCEWilDxa/qY6g/km8u4yw/VTL/XDZpaFKXejZrCORAG3L6FrlzH73ZgnG+3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4074
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09ULFn5W020147
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker
	DSO
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <47845E502256404987826CCC1A8524F1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> The multipathd tur checker thread is designed to be able to finish at
> any time, even after the tur checker itself has been freed. The
> multipathd shutdown code makes sure all the checkers have been freed
> before freeing the checker_class and calling dlclose() to unload the
> DSO, but this doesn't guarantee that the checker threads have
> finished.
> If one hasn't, the DSO will get unloaded while the thread still
> running
> code from it, causing a segfault. Unfortunately, it's not possible to
> be
> sure that all tur checker threads have ended during shutdown, without
> making them joinable.
> 
> However, since libmultipath will never be reinitialized after it has
> been uninitialzed, not dlclosing the tur checker DSO once a thread is
> started has minimal cost (keeping the DSO code around until the
> program
> exits, which usually happens right after freeing the checkers).

I'm not against this, but have you considered using an atomic  refcount
for the DSO? With every tur thread starting, we could increase it, and
decrease it in the cleanup function of the thread when it exits. That
should be safe. If the refcount was positive when we exit, we could
refrain from unloading the DSO.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

