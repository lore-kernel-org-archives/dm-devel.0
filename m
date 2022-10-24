Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A85C38A2D
	for <dm-devel@archiver.kernel.org>; Mon, 24 Oct 2022 08:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666598408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Qpvn+0YV5zJMdAwmEngY5F/YvNr+B2+VvclLLVI/yTk=;
	b=Es1bjhC/3mV+jYs7hj0Ps88CsoE8VVs6FprQ4IH8Utmk3zKA1B9ZtZvzOLEqopsq1ykyjl
	KQp0Z8OMwNGPSPLeShkP/tNN9X7EOIlidFiMB3+r3v94f8pAnXB3NR+7cJbgFkdHMPtR3x
	ndGfGxO+u1+Nml3HkM/QAV9koGC8yIU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-FzOjvLGyNDCNtYFZ-oe--g-1; Mon, 24 Oct 2022 04:00:04 -0400
X-MC-Unique: FzOjvLGyNDCNtYFZ-oe--g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FA5A29AA3B8;
	Mon, 24 Oct 2022 08:00:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E18792028E94;
	Mon, 24 Oct 2022 07:59:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A0C5D1946589;
	Mon, 24 Oct 2022 07:59:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 163731946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Oct 2022 07:59:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E804E20290A5; Mon, 24 Oct 2022 07:59:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFF9520290A2
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 07:59:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAEEE3817962
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 07:59:54 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur02on2053.outbound.protection.outlook.com [40.107.249.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-2RdMrEfdNtGZjIfistIV-Q-1; Mon, 24 Oct 2022 03:59:52 -0400
X-MC-Unique: 2RdMrEfdNtGZjIfistIV-Q-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAXPR04MB8704.eurprd04.prod.outlook.com (2603:10a6:102:21f::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Mon, 24 Oct
 2022 07:59:49 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Mon, 24 Oct 2022
 07:59:49 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "wuguanghao3@huawei.com"
 <wuguanghao3@huawei.com>
Thread-Topic: [PATCH V2 0/6] allowing path checking to be interrupted.
Thread-Index: AQHYzNJNK6zObVBqrUGch1+NtQF+fq4SnkCAgApnBQCAAF5CAA==
Date: Mon, 24 Oct 2022 07:59:49 +0000
Message-ID: <1aa29975832df778754367c8099fa2f3ddccc812.camel@suse.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <44f7c759-943d-23c9-bcd0-b20b0457e329@huawei.com>
 <20220915181754.GA23693@octiron.msp.redhat.com>
 <2686cb11-3955-e3f0-5f42-647dc9cfed36@huawei.com>
 <1be59335-9ba8-607e-efc2-90feb66901fe@huawei.com>
 <363ff8ee-21f1-92fb-27b9-6c8bfa937543@huawei.com>
In-Reply-To: <363ff8ee-21f1-92fb-27b9-6c8bfa937543@huawei.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAXPR04MB8704:EE_
x-ms-office365-filtering-correlation-id: 8a914764-49d7-4cb7-b65f-08dab595b9b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2DOD3ku/aHxnHwuQGqoO4IP9jAuTkhXgvCHjem87Kk56kIzjMzlO4HDZpDlY/FSzIZ/7bimPAuTR/vwE7a9aIK+FZ7merh4Kt6MKgO4hIajX1AyEPSFLPgwreqY7mL3TB0sHXjRZT6DvcJo2WhT60GPlQQUrQT53o0qf8PtTr9XXsGbNU1vdpaitkerjLVlJzqiYPdagA1dn9PaH+W/ppw8pjR5uVGP4qzYlxdglV2mAI8py46sgN7qpIZ/SUsNs9CL9b/LQ2SQhTEJRcKOViMv+DN7uSUeeR9L371dxNZt6nh5znNtjbzrcANarpjKC5/FipX66g3ggxMeC64V97+x0oPqFKU1DQnAEYHRZEWu2Qq/5bdZZYIG1Gr9WXwH+h4B9F/NCUF/VYAvyXjhnAINaD7yF3le6u4ha24ODn8+NtlPRxa3V66a/8VKCEU8UKe2+CvifF00IMyfU4rmHvwbQqzMRALltizNec1jxsDQcS91DHUrOUvBlqywNR61O4yJ88zP0ugsXhpjhUCT/Sk9LRzkC3ZnZdYzntAy7dJdNUzqvYSGuSvVfs/hcyhcDp4gM7i1bNKLDTV/LCwv9qYUZmhzJ0UeO+mTiNfMlTazqcvaPme2LcClFLl+6sPXBIxXsrdnQw5YfwSQae1GgPpjRSVgX29ocXnajC1mtST0SUt+fmgdnYjvPUlUVX38n2USWdpcMSpA7bVsC2IavJJJ1umzo04ZL06CFA5PD8DqDsydVUOsj7LWOY8cphGxzEvlLbxDPyZt/r+peUUsfew==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(4001150100001)(2906002)(2616005)(41300700001)(8936002)(83380400001)(36756003)(71200400001)(38070700005)(4326008)(6506007)(44832011)(86362001)(186003)(5660300002)(26005)(6512007)(8676002)(76116006)(66556008)(64756008)(66946007)(66476007)(66446008)(54906003)(110136005)(478600001)(38100700002)(122000001)(316002)(6486002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?LkejBs0RycOuofJO0dL1PgyPGMecPLjGoXJTBdN1qxuIqU3ZiRRo6TYk/?=
 =?iso-8859-15?Q?9Ygd9k0g1nFSiA6T3ytWooDukQ5isTOXGQlqdYrtw/2WZkRE6Z9NEcfsq?=
 =?iso-8859-15?Q?76pZheVjIxiy68EabR7LwbxNMMiyer/pDeDWr6fWjl3qnJ27e88nKAk6E?=
 =?iso-8859-15?Q?reNXxOIhIPAuIH7i0/Gep/alhlCTJMG+WqwNk4EHD5fwpe1kkdRSIFx1m?=
 =?iso-8859-15?Q?5mtcPcsXYuns7D4DQLsO6OtV0HNojpluErr6F9sYjg5vXKmIzuson1K/Y?=
 =?iso-8859-15?Q?U7anDw5NdGp27gJS17in0159johgwLChc0JwB2lmz+NzN7dmZFlWhLXoO?=
 =?iso-8859-15?Q?D5Y0G0APZ1kxhRG18aIJc08xD6YQ2ovX2v8WYyNq3zvKcoVZVUzKBtM3S?=
 =?iso-8859-15?Q?PBRd4uS/BnApNj5GwX085UDMHtkeFcSKDfRvaBZcCjAT/eD4O7mcmx7Vx?=
 =?iso-8859-15?Q?H/fPvRXWGEZE8BMNheFKX+1H/8OfWI5l7IK/z1YV2vmSX7JFqitlBBq09?=
 =?iso-8859-15?Q?QE0PRYmSeWqWNIK2/yRQdgKxBhXXsAKTlP+8NVPyqGscM5T1nqajpVgA5?=
 =?iso-8859-15?Q?cuzCOuoQoiKNUSqhCwES/HDvK0ntB5xHJKMIZ0WhrNyBVOZZdAW6rT4Cr?=
 =?iso-8859-15?Q?DP/yuburAUsijnfjbBkou86ELMRkGzSTWt4NIlTItg7yedEP1Ngb/YQsA?=
 =?iso-8859-15?Q?x0r9OFc3QRsM1nv2keVlufHkQBaUBxmq3FQCLRXvXyhoZrvlWcfR99Sgp?=
 =?iso-8859-15?Q?MpG9ehU1pE1099JTmy7l+83/xKV8vp2N4IV/k+7rvBS5Us9OfMW1hHvTt?=
 =?iso-8859-15?Q?UXXa32ig2dQ7mVoXBMuvm/5skjQ3+OqnR8cNs3FLoh1o3/cZRmEJ/Pby7?=
 =?iso-8859-15?Q?2WWl4jRspT5fHWhYcp68qPqTiFIO79ScCBtxHn8iMuD/89FcLaY2ucnoP?=
 =?iso-8859-15?Q?/Ky+MAqTpAb8aRUtnX9tBuawL6Ng986B/FV9nqJLTXlsjYBLi/Ajdjru1?=
 =?iso-8859-15?Q?1goDCuFN5InCj4xGmhQ6SwROu8NQl6k3A//IDKwad8fiiWxpyv3PN5pU9?=
 =?iso-8859-15?Q?5Vqry7SUKAIS8kp16UZx8AHtvFt5a/8zX+MlJ2N+zBcRIiDlthwTrJF5Z?=
 =?iso-8859-15?Q?ljXQ0z++7ZYDHbUQwRFkS7LbiLOAyszLsivQF8PClGr0EvrcbqKEBRTl1?=
 =?iso-8859-15?Q?DSVWReYWgJoHMaixsYQ5GATJeFjZW2Wq1V6T+qL0RPd/gCI4pcW9Nv/kM?=
 =?iso-8859-15?Q?YdEq3EpbkmyqqH6py3L3RC13hZL2xXqg0nJUGRwRswpjAKSA3hALHNelX?=
 =?iso-8859-15?Q?yaV9xigse9c7xNhNvHtttXvQ1rZORbezix+RMdA3yuL404HUCCw3mzh4E?=
 =?iso-8859-15?Q?QEwDuOxc3nRGrxMzFliH1tnOe7hmJeb8VYO6NZl8cHUpyoDWr0CJGP7Ps?=
 =?iso-8859-15?Q?3za8tZxrdT3wuLDT79On0xPoO3FeMhGk+HvR6nTIbHZHsfsx535vXBz53?=
 =?iso-8859-15?Q?NLgEi63VBfvIY96eKRiNfHzc+bh0Hb3C2TwpspSbGVyTElgSGcbfe62dQ?=
 =?iso-8859-15?Q?E3amHeLQ9/IP5f+X4FaB6diFzckySQjyrIDH4IAfCRtAHzXqyMM81vH7a?=
 =?iso-8859-15?Q?789jbFzBFNuMsZAVq4r5tHNIHNzlNnLcwNMyt2/Lyt39fiwCfmm1tO1z8?=
 =?iso-8859-15?Q?6VFwnme8nV4WQaQo/tWKbrJEgg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a914764-49d7-4cb7-b65f-08dab595b9b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 07:59:49.6391 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tB8X3bxqQ15geEcl+3tI0WtK5yLTser3lL9OamOZiX6vne84XVeXBY+RKfxa36XnPr9Zh3cxukHBu6ILJtkcWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8704
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH V2 0/6] allowing path checking to be
 interrupted.
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
Cc: "linfeilong@huawei.com" <linfeilong@huawei.com>,
 "lixiaokeng@huawei.com" <lixiaokeng@huawei.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6C2E0863EA2AE64DBFEC6BBC990CCCF1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello Wu Guanghao,

On Mon, 2022-10-24 at 10:22 +0800, Wu Guanghao wrote:
> Friendly ping ...
> Is the series of patches for vecs->lock ready to be merged into
> mainline?
> Thanks

Ben's series has been merged in 0.9.1 already. There have been no
reviewed patches on top of it, unless I am mistaken.

Btw, I never received an answer from you about my suggestion from=A0
Sep. 20:

> > The version we are currently testing is 0.8.4, so we only merge the
> > first 3 patches in this series of patches. Then after the actual
> > test,
> > it was found that the effect improvement is not very obvious.
> >=20
>=20
> Which path checker are you using?=20
> If it's TUR, could you try to simply change the sync wait time?
>=20
> static void tur_timeout(struct timespec *tsp)
> {
> =09get_monotonic_time(tsp);
> =09tsp->tv_nsec +=3D 1000 * 1000; /* 1 millisecond */
> =09normalize_timespec(tsp);
> }
>=20
> Change the 1 millisecond above to e.g. one microsecond. That should
> speed up the checker significantly. You will get a higher rate of
> "pending" path states, but that shouldn't matter much.
>=20

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

