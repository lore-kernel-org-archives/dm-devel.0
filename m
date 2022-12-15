Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F57C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 15 Dec 2022 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671119602;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zyg/ZnPZWxqQVkS56YKMe9rgzQ5GIYeDQpvJ3UCuSns=;
	b=YBfWOGKPBJ6slc9gNMSj2/ncqM2SiQH2s69TUvatD/8UAZm1Ed858mNlkIGFymevpBA2jv
	yg/qnOvoOMFbl/X8ijHGmLBYj70heZcrkUnJweca8BB+k9ev7bnOCSGG4RCsm+EAoBRyCH
	S3v7i/NKv25ow3679RrRsY/PW928b5U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-kW5zDx3gNEysdvW653mODQ-1; Thu, 15 Dec 2022 10:53:21 -0500
X-MC-Unique: kW5zDx3gNEysdvW653mODQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94A6C8030CC;
	Thu, 15 Dec 2022 15:53:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3224BC15BAD;
	Thu, 15 Dec 2022 15:53:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF61219466DF;
	Thu, 15 Dec 2022 15:53:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E34CE19465B2
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Dec 2022 15:53:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8EEE049BB6A; Thu, 15 Dec 2022 15:53:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 85750400F5A
 for <dm-devel@redhat.com>; Thu, 15 Dec 2022 15:53:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A58A185A78B
 for <dm-devel@redhat.com>; Thu, 15 Dec 2022 15:53:12 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04on2076.outbound.protection.outlook.com [40.107.6.76]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-CCSLa_F9PtWhc5XJ12QjEQ-1; Thu, 15 Dec 2022 10:53:09 -0500
X-MC-Unique: CCSLa_F9PtWhc5XJ12QjEQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DBAPR04MB7413.eurprd04.prod.outlook.com (2603:10a6:10:1a6::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Thu, 15 Dec
 2022 15:53:06 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%7]) with mapi id 15.20.5924.011; Thu, 15 Dec 2022
 15:53:06 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH V2 0/3] multipath config fixes
Thread-Index: AQHZEARoZ53ijs8w4U+snxXBOUCswq5vEYghgAAJEoA=
Date: Thu, 15 Dec 2022 15:53:06 +0000
Message-ID: <8237f562fa13e40fa33467693fff3a40627b46dc.camel@suse.com>
References: <1671053900-14923-1-git-send-email-bmarzins@redhat.com>
 <204a11c0a4cabffea117638b597ba0f99b0dacad.camel@suse.com>
 <20221215152029.GE6245@octiron.msp.redhat.com>
In-Reply-To: <20221215152029.GE6245@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DBAPR04MB7413:EE_
x-ms-office365-filtering-correlation-id: 115d12f8-73b2-4d52-d746-08dadeb474f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: svAkSdNAW9usdNd9+hS46afMimfetJV6C1UMxAI8vKM6sJWjB7dxFBNO9I9UcjYhiL4/JbMSn+5MGemc/4E4exT6HafvEUTuS4dUZW9A28rjColoZYCSCY1ZzdlG9LSebJfSdo5bTPpXMG8qodi137fEeF1ImOD5xkBd1RCkx3u8scP5vhu9SKIrbRqja7RqYsBRBF93gQVUzCil5fIT72CGcuaYoJXyDOoeypJHzxfrrNO+e9A/Fz5PYEcdukt8/EZLMuhKpRQaBbk4qnUWSkQ8mYvcrIUpZ/NkVXCqeOdSskSaxFS/f+QnnskiffGR8ef5oXPoQPvLI2ChXcQI1Qbfv8nf+vx0ZGW2lx6BStT9Bl6Otkec/kvo3KyS3LUBvEhEhG5zh87h55ME4UlIYvjweR2MvJD6l4MpjYsLWzhdE675G5Bv4BrYeqJ5SDrBLfyeWen278TEoN1EYjPUghzi9uXmRu7U5zmEtXL0+Uam9bxkwiW2YyVGf9jZfHBmG+FYHlf0eleWFhG8e6NOVt20rqFVEk/ThOWlWV/kG7fK3vbcEVSvKZ8FT5y8x+Bo5pdpFMcaJOgeeXf3sEpVSt/bDEM5fuexPHDyOWKuqpi4UTsxE1n7bUMyXRa6votykhpel2BdtuaV34qRr2fN8W12xHAvBYUziQ8GTbrDCQ8/fzVASF7sIEV3X+PSJJb/SqPMOtNP5dNwpwVmQG/dbw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(26005)(38070700005)(478600001)(5660300002)(6486002)(6506007)(71200400001)(38100700002)(122000001)(6512007)(66946007)(6916009)(54906003)(316002)(4326008)(66476007)(66446008)(8676002)(186003)(76116006)(64756008)(91956017)(44832011)(36756003)(2616005)(2906002)(8936002)(4001150100001)(66556008)(86362001)(41300700001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?eZ1kR7Adc2Hk3+lM+xo+9mb6aPjBoDXAkdm0yQFdsPRszLjtYwZk0xAmK?=
 =?iso-8859-15?Q?s+KYme4CSU2pkNGKnqJ/vcNWRS1L5UBSb0pkaSmvDeoBdGUhnchCZHj2J?=
 =?iso-8859-15?Q?1yp0luacxRpfaalxZO7NLFNu1qbRHtscoAsYHbKWIMFY+XzzqK71zzxzU?=
 =?iso-8859-15?Q?bjM1wReK1xl14L+t61yYldqjOTIhSodEZsZBW0T4BPvpwrfztC7LHCXN9?=
 =?iso-8859-15?Q?ZHw70X0N92XjAkMcaWeB12My4coZoZLpln4HTjWJNhY8d46PLkEEnuAZh?=
 =?iso-8859-15?Q?2QZKRX8r0sEOc2Jrvus7xKiCIfejn5/iD2xXuTbD2gdmvG3H6jHHJ52Ug?=
 =?iso-8859-15?Q?UiuaKrm0oB10z+sLxN0RktdZdxD4HK2+9Xd1j0ifKXx6u9Q5vL4fGGmH7?=
 =?iso-8859-15?Q?UUOj4ds6gLwTY4iaVTfa4xmRXHOqv+ELH2SHgcIQnc8wIQvlKt1YtCzN7?=
 =?iso-8859-15?Q?+qhB987aq6Qod/RKrsXPEKaS+BX3bbUgxHZdT9z84nhIl1o+xNbC/fdgW?=
 =?iso-8859-15?Q?uszbjntMKYAeVK/2qRmNRRplSGw58RYALhmEA4O7k5o4OihUTmH9wXz8v?=
 =?iso-8859-15?Q?K0Tf4s4iIt8as6NzDK7N/Zp6nqaxn3CxiQKb/+g5/Wehep7Wwro8kRtVr?=
 =?iso-8859-15?Q?JTIzwgfT1vvQVtL6tmtLBBPdfVBDihmjZ77zccVzz5uUfNI/d3BmURoQu?=
 =?iso-8859-15?Q?B7M1iUU/ANrgazVvZs2LBzamUIp6rRy0ZAA3CQ4lm3Ap45cIMs2zjdes5?=
 =?iso-8859-15?Q?uOUr3f/YG2lnAhLiDjMZuKqxKu1IQWsDAmOddJCJOf8qyCnqBuWtDguai?=
 =?iso-8859-15?Q?JNK6InDPCLGgNX8dArSjTvnBD6L3iC7OskM/MltplbbvWdO85vxb8BZuE?=
 =?iso-8859-15?Q?YxLm9VFGJemFWqminufLaA4DXWnEs+e+2Hjo+s0bqL09F1no5H/OOSyCp?=
 =?iso-8859-15?Q?zLfdvI1g/7fxsHL86Og2nx+TE8CwAZ/5DyEFvrq4UDwZXjXXMiST8qRj6?=
 =?iso-8859-15?Q?ak1TJhPsuRHVJV2SFSSjxIeZORKBtiLI8PwzLVEND3HIMNLJHocknUeL5?=
 =?iso-8859-15?Q?YTiBjfE12CBXHtprYqyoHi2uK65sq2cLecPe4LqD43DpCSr2U0PS4AT5D?=
 =?iso-8859-15?Q?1AE+6STpX8Z88VOoLgZUtcDJvueW+zB6bzL11q8OvevL0PQ5uSQwCXsbm?=
 =?iso-8859-15?Q?Blyb0k//bA1smJ+S9Kn678i6JW5GCqPHRKHBuwSWh0oNAXnyeardKaODv?=
 =?iso-8859-15?Q?czbh7BIFTr6YehZMMke3SrEF2FVTznWEmB3zWIuJBNcsj3YJkWXDfyU2X?=
 =?iso-8859-15?Q?YDc12eKwWrSkQE9pQM5fEi/rvT2HCwQUS40tjOX170a7PjhM58lAtP7mb?=
 =?iso-8859-15?Q?ESVt+cK72EV69TPlQPjgqamC7I6/djRgnfIskZgstZ15IsugZ3eHCvQxX?=
 =?iso-8859-15?Q?PR7pJ8UotZTPd/86MnL/57yi5lzuQ6O87J0fZgLGiqGU6JlkOHC+PVqI3?=
 =?iso-8859-15?Q?zt8AeRC8G/lacb7R4YbARtgKlxDS+rSollyGX6morHQCaYzKmXDd0sx/6?=
 =?iso-8859-15?Q?EL2PTac2pNIJt57P+99R6qnuHvFWXQaktFLXBDxIgC3Eq59la6SAYpRUN?=
 =?iso-8859-15?Q?SVOHGImyy0W2sWK9H6e4NF1CI5dBtD0d/U3qH4DpJ0bDiRe+1uxYeD6gn?=
 =?iso-8859-15?Q?PCE4BZw/i3E1Ls0lqOdKMaqJ1A=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 115d12f8-73b2-4d52-d746-08dadeb474f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 15:53:06.4194 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A/tfGinBi1HCcHPYj4LhBIZz5q2SEPsg4ZhxC+PCA8Oi7TTaPdZ2Mnu6dwDFxARohvu6WZIZya6c89OzN2a07g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7413
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH V2 0/3] multipath config fixes
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
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A543E9487D6BC64EAA8BCF7915E6866A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-12-15 at 09:20 -0600, Benjamin Marzinski wrote:
> On Thu, Dec 15, 2022 at 11:34:20AM +0000, Martin Wilck wrote:
> >=20
> > Hm, my suggestion was wrong. It shouldn't be a pointer at all but
> > an
> > array:
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0static const char spaces[] =3D " \f\r\t\v";
> >=20
> > "static" makes sure it's only initialized once, and ends
> > up in the .rodata section.=20
>=20
> Dumb question. If you explicitly make it an array, does that mean the
> compiler will always allocate separate memory for it, even if there
> is
> another identical const array? With multiple pointers to the same
> const
> string, the compiler will often just have one string in memory, which
> all
> the pointers refer to. Not sure if the same thing happens when
> they're
> defined as arrays.

I am unsure about it, either. A quick experiment shows that the
compiler does not merge multiple const char arrays with the same value
into one memory location, while it does for string constants. (I
suppose this works only for constants defined in the same source
file?).

Also, if you use a pointer (rather than an array), the compiler is
smart enough not to allocate memory for the pointer variable. At least
in simple situations, it's probably the best idea to just use the
string constant without declaring a variable. So you could have written

#define SPACES " \f\r\t\v"
...
=09=09p +=3D strspn(p, SPACES);

This would benefit from gcc's constant merging.=A0In the case at hand,
the compiler output would be nearly the same between all 3 approaches.
But this would change if you started using SPACES in some other
function.

What definitely should not be used is=20

        const char spaces[] =3D " \f\r\t\v";

(without "static") because it causes the array to be allocated on the
stack and re-initialized at every function call.

The moral: we shouldn't try to be smarter than the compiler
(this refers to my review :-/)

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

