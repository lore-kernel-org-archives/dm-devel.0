Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E7AEC43334
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 07:56:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-bTsSydNiPjaniAaWPHbgrw-1; Wed, 08 Jun 2022 03:56:40 -0400
X-MC-Unique: bTsSydNiPjaniAaWPHbgrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2766803B22;
	Wed,  8 Jun 2022 07:56:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6251140466A3;
	Wed,  8 Jun 2022 07:56:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DBF2194704C;
	Wed,  8 Jun 2022 07:56:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC5F31947042
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 07:56:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C6BC401E5C; Wed,  8 Jun 2022 07:56:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 974EB456CD9
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 07:56:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B37B80B712
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 07:56:35 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-UpKNGCZmP56WgJzg2Z9dSg-1; Wed, 08 Jun 2022 03:56:33 -0400
X-MC-Unique: UpKNGCZmP56WgJzg2Z9dSg-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2057.outbound.protection.outlook.com [104.47.13.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-45-Empx1c_0NUeuLWJM4z4Mrw-1; Wed, 08 Jun 2022 09:56:30 +0200
X-MC-Unique: Empx1c_0NUeuLWJM4z4Mrw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by HE1PR04MB3065.eurprd04.prod.outlook.com (2603:10a6:7:1d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Wed, 8 Jun
 2022 07:56:28 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::80f9:38c4:1d69:7886]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::80f9:38c4:1d69:7886%6]) with mapi id 15.20.5332.012; Wed, 8 Jun 2022
 07:56:27 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: unset detect_checker for clariion / Unity
 arrays
Thread-Index: AQHYesBA6PR50V8MFEqY2TtKCigfDK1FJQEA
Date: Wed, 8 Jun 2022 07:56:27 +0000
Message-ID: <1675cd007bfee3f944c986e7e8a9eec8969487cd.camel@suse.com>
References: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16a617a1-1ce6-4d77-d635-08da4924645d
x-ms-traffictypediagnostic: HE1PR04MB3065:EE_
x-microsoft-antispam-prvs: <HE1PR04MB30650F326750FE4577505FFDFCA49@HE1PR04MB3065.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FDTld8rWBZtipfhjKL/KQ8HHLkTyktohusjEG8GJg00gsY7osinJXY/LmV9ThGzHTmpaEOflmd4qanFPZNzcyqmEubRfghsRdTVajLzy6VuUGIw+73VGNAyUMRER//q4mMoDIcIY/hf+wp41+CARcj0OTLzDLZ/72Cw9PtfgCZImNB8hFKTXzRB5wErDwQoNvIv4TVw0EG1OAgGsw0JgmhXD823irUANR1m2louC3rEt/nhmh2DfGkHF3BWWzFMaRie8/0E41xTHlaNek+pHmc8K5tHKZQuoE9d7PItGXTQv939L2EJ0Cs4InYCs0YQMnpmz7sB1UsXcXzxEx0jS0nFL6hmmbcCnduRpD/fWUpZBlve/ZCAUMUsDVwoGx3leueQazw4DSzcUlTgV0gmcEQekevKuHr6qc6jHI1TCFi8lmRMjw0uxULrZmz2MurNOd/Ue00x2W0pCLOQJRi4uzYxdPw9y85yjQ5u9OOnft1u2HfgqffMZ/8CBR/Dsx3Jg2GO1H0mLiWy38Tv+ZajzRn+TcrxQbvh4QcfnMsQosNeJtC91bUn/Cp+MU3xdNPsMxZddWS8jtNhVVROf3tCAIj0lklDmhV56qqZkn7iL7+nRwARLOq4iDPUzdyw/oSsFkt+TegdUHkR96tcxGPM4Uj0rWEY44TqFVuad+SINGPCTH06K2co08P2a4UFNejBqVyHiciZJbKi8Ou1y0MRI9A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(26005)(54906003)(66946007)(316002)(6486002)(508600001)(71200400001)(5660300002)(8936002)(110136005)(36756003)(86362001)(2616005)(66556008)(66446008)(66476007)(64756008)(8676002)(4326008)(44832011)(6512007)(83380400001)(186003)(91956017)(76116006)(38100700002)(6506007)(38070700005)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Vsnd4gNXmtyXw64SaQdw36VScQa6zlSYnDJTxyo3Dag5Qp1VGuTm+lnsj?=
 =?iso-8859-15?Q?+/mPdb4Sh+mOT7ZkoeGBHh5ZmIbcKV78M3A5FdKeUU953ocp+Af9VkICt?=
 =?iso-8859-15?Q?UpHLFQSoxmV2ZKNIoC2t2WasMtZl6Ylw5zl+QHkSXC0RYKbxml40pCARk?=
 =?iso-8859-15?Q?RJVXn5d4f7FJHyrFO6C1RL4nYfgdmV6oUcOcmfjDAkBcoHZuDQ2s6YqCo?=
 =?iso-8859-15?Q?t8Pd5IMh4Jr2nYA/MSqtC3Eva/DTxbrh5JYa0tGY7hRQnxajUqEaZf2JW?=
 =?iso-8859-15?Q?OFOssIH2594CawtvYNLUSA8RDdf5YEBKkdZ4K8S0rFjWKldBgtrE8erpR?=
 =?iso-8859-15?Q?vOq4tPs5zNDoK6lkHtghaNl4xr2U3zReyvjANIaDiYc/SinZLH8EPhN4y?=
 =?iso-8859-15?Q?A+TNpeuh39hdFZmnszvW0bNVubSxTdjwfiQZ82JNf6h0IXXN48t3RewVA?=
 =?iso-8859-15?Q?dxfRvOVIWFMfvxBVp42kM8wIxiJUIoqV0X1PlEXGBK4HWs2RDN0TB1RZB?=
 =?iso-8859-15?Q?OD1z4/AHhYZAx5+3qIZcm6jFign/iO95JZTkP4xhneK1l6BHkV9kUxHgP?=
 =?iso-8859-15?Q?GKAMcOLJ2k2OrA1y5NnXoZXgCf+GTH9UoWjcmvuE/3mVNngmQjUFXD5J7?=
 =?iso-8859-15?Q?Dw2F8VDkCLWBv5wfA7WaMD0go+X2FQ5nXgUqRn149pvr8PmWSKauwIn/t?=
 =?iso-8859-15?Q?kc2nC139FVgfwVs3CDsWSsPFAel7V3h/OsW9lyyLIH3OyUB/x/lkrP73N?=
 =?iso-8859-15?Q?MAZx+xhsE4NCUIHXVXU6ljsfA5t4/nTY6SeX3T1NxEe3FcTJPIUwvOy3J?=
 =?iso-8859-15?Q?bZPY+3HrN49MD/nCgwH5CaAvY9qfjN0TIFFHBtYIkOrZnwqSGHg++BzTi?=
 =?iso-8859-15?Q?Rc9nmVJZzz+079pjQJXBbgMeTCNu3C7cZq2DGRMaHEJ5EQ9J+nky1+X/v?=
 =?iso-8859-15?Q?2YJR40MmYM+Jis43FC4yVbsIonO9SOfqc+oVyYKxngJjDzVcgxkKcuFVb?=
 =?iso-8859-15?Q?P1rnW5j2A3oAEQfl0R/MVlaXAVjY9UDgWU9MSZnqND3VO6TDLS52fwuzK?=
 =?iso-8859-15?Q?fSBcJv9cWpsqBQAQJhEEqO9sS6hFXnzplF5bHsZ8AqS9K2ELqYygzzkvg?=
 =?iso-8859-15?Q?xuh0za4NyFe7Kji1rMwwyiHcn7DeUcpMsphs9zN7jk1dh24SoE/Td+o4p?=
 =?iso-8859-15?Q?FJRDAkdtQJBy3RQNuxgTa40GkkjQQs8QQ+hLW8NThjYMraUAA6JUlRXIi?=
 =?iso-8859-15?Q?FBvi+G0f5SN5zFImkdIFPf6rxg+EdOoWFSVLuV2CZHs6hHUwSDmLpRxKE?=
 =?iso-8859-15?Q?ZyrSCVXTyyGJ0A0SbwKnHlTLR9ZMoGR8tUb4O0LlLvuJp/qu5sIdv6+J+?=
 =?iso-8859-15?Q?RkKribcA4HaLmmF0Spcp6RXg87N5aqZboLkEgNprefgp9oAl/Jy0w6MtR?=
 =?iso-8859-15?Q?AA7rUK4JZTk9m+Zk7LPlDGVRMPsz2trEupHe/y1DxH56vRQzQO+eVgs7x?=
 =?iso-8859-15?Q?JPOUhYGFutTwvvkzZ1OLnNPPsyc2CFs9PRwi1OVKnkWAHvQUF79oM8IW6?=
 =?iso-8859-15?Q?5rK/C+bvzQC0OiHuJB400/K4hTlSMRS4frzbewEnRz5GpLZvUqs0iGz5L?=
 =?iso-8859-15?Q?XgmiOYPzeqQcQyrDNfWAijkG3vRHXHqWIYwn4GtZQCVTLAKNMr1lyq17r?=
 =?iso-8859-15?Q?CiQS+HXFCiM0fTGyhibvA7QQeqYPyQo6+sbpFUbCtymWUyRCkeFcUtLvx?=
 =?iso-8859-15?Q?lHK+K7HRILB8F0dYgTCbLHFMyQxKa56nJBSs29jJWYNThZMWU9ZA4QDVy?=
 =?iso-8859-15?Q?d63BvqFrlcQRyfxG5r7+WcF5uYTnhWs7tjozxu8bG0ffFhGNIPkSB2fwq?=
 =?iso-8859-15?Q?zWqk=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a617a1-1ce6-4d77-d635-08da4924645d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 07:56:27.7711 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: keqKgTMHTche3oNelFXsrf7cVCh/01ZWdPH8DxQOl4AHsPFzqzPmuqsXKX/zqLv88gZZS+DW5C129Dx28UMwjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3065
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] libmultipath: unset detect_checker for
 clariion / Unity arrays
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
Cc: "vincent.chen1@dell.com" <vincent.chen1@dell.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <01C072430814054EB14749583BFED047@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-06-07 at 17:45 -0500, Benjamin Marzinski wrote:
> Dell EMC would like to always use the emc_clariion checker. Currently
> detect_checker will switch the checker to TUR for Unity arrays.
> This can cause problems on some setups with replicated Unity LUNs,
> which are handled correctly the the emc_checker, but not the TUR
> checker.
>=20
> Cc: vincent.chen1@dell.com
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This points us to a flaw in our logic.

It was wrong in the first place to have autodetection take precedence,
even over "overrides". The effect for users is that whenever
"path_checker" is set, "detect_checker no" must also be set, which
is highly surprising and adds no benefit.

We should assume that if a device has an explicit checker configured
either in the device configuration, overrides, or the hwtable, this
checker must be used, and fall back to autodetection only if this is
not the case.

So while this patch is alright, I'd prefer a patch that fixes the
logic.

(The same could be said for detect_prio, but I don't want to make
outrageous demands).

Martin





> ---
> =A0libmultipath/hwtable.c | 1 +
> =A01 file changed, 1 insertion(+)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 39daadc2..415bf683 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -350,6 +350,7 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D (300 /=
 DEFAULT_CHECKINT),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.checker_name=A0 =3D EMC_=
CLARIION,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_name=A0=A0=A0=A0 =
=3D PRIO_EMC,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_checker =3D DETECT_=
CHECKER_OFF,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Invista / VPLEX */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

