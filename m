Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C22C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 21:01:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-9QNiOcxJPCeFZhVuM3UMZg-1; Wed, 15 Dec 2021 16:00:53 -0500
X-MC-Unique: 9QNiOcxJPCeFZhVuM3UMZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4748E1E10;
	Wed, 15 Dec 2021 21:00:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D556C5BD33;
	Wed, 15 Dec 2021 21:00:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB5434BB7C;
	Wed, 15 Dec 2021 21:00:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BFKmrrx000767 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 15:48:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0310540CFD1D; Wed, 15 Dec 2021 20:48:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F10DD40CFD0D
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 20:48:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5E82380406D
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 20:48:52 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-30-aHKmSzSqMLeUoCMKgn5Qww-1; Wed, 15 Dec 2021 15:48:51 -0500
X-MC-Unique: aHKmSzSqMLeUoCMKgn5Qww-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-16-kI5cbMaEMxKsw9cLsjcMyQ-1; Wed, 15 Dec 2021 21:48:48 +0100
X-MC-Unique: kI5cbMaEMxKsw9cLsjcMyQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7114.eurprd04.prod.outlook.com (2603:10a6:10:fe::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14;
	Wed, 15 Dec 2021 20:48:47 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4778.018;
	Wed, 15 Dec 2021 20:48:46 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 1/3] libmultipath: embed dm_info in multipath structure
Thread-Index: AQHX8dtqvOPkUfbluE2e27FAeMrtrqw0BpcA
Date: Wed, 15 Dec 2021 20:48:46 +0000
Message-ID: <2e8f5e72d0a5e40f123ef3184038b67815cc7b71.camel@suse.com>
References: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
	<1639590250-11293-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1639590250-11293-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9856189-906d-4cbb-431c-08d9c00c4a64
x-ms-traffictypediagnostic: DB8PR04MB7114:EE_
x-microsoft-antispam-prvs: <DB8PR04MB7114BE479FD97D1829EF7F03FC769@DB8PR04MB7114.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: HGIER6WP4iUyRtxgduLW+FxJS/NYQ4hKgg3/6L08ghM24t2Q8v7OlnYmln5EK3h3rBP4kZq+fQLpNN6/nO8Kspm2kvPiA2wRn5lmfovJEcqPOmeH5rXXU7fj38//swNorVS+jp1bT2NPAeOxhVaFFxeAKeE1dxybkjiY8e3cvdPVo72oVzvf+j3JoNnz5lADTRxNnuqmPZaUFSzi2mmh16V5NiSUsHf3sRmqyLEUahRlW2gbCQ8MZX5CtZ6rWwtMRKucofmfDFAXCVJ3Oi8mS5/VcHLrQoIytqdUH/h+7AkAzLIiKtqkzDOqmaohEx8xGs/r8OoPfS2NFFBMacrZ9ro4XDpwqco3GteCV2f7jy/sC3H+B7MBytH7p8zI9hA2a/gwOshnT9TSnTf9itr4jy4o2bSKGH2OInOcUgK4cQ43tBf0Nwcef5kBXoc6fAk7O9/hLbjwTYDipuPHof6UXJcHEoW5ie78DeWyP97an5//YI+byrNNml5OQeBVKu1/W5W7gcmPx2hM4G0WuiWmxa4lj5COnK5f15LxSxNQeq/kUTLPOiiWqV5BDyYpBGVDP8xSwyCW1WpIHIR5jkHRuEOjbkEdMNgcdJBgP/NvcQ2Uez+FvpKCuQe9V6lcDHSEXf+q0L4OvxoJQvuLF2Mh1aIX/N0JJ6rfB6ssmlX4zuAR7y4I8+RQ0/A0lL2AvgsJLaGHcML53P1ajk3Nr1V0fA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(6506007)(86362001)(508600001)(122000001)(76116006)(5660300002)(64756008)(66556008)(66476007)(8676002)(71200400001)(66446008)(6512007)(110136005)(2906002)(38070700005)(186003)(36756003)(4744005)(2616005)(44832011)(8936002)(6486002)(91956017)(4001150100001)(66946007)(38100700002)(26005)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?X8EkT7X3vtSW7xKsKdhlRLD6dQFyfKfFjoPJYu5e+qRIcBHp8jacrHfgZ?=
	=?iso-8859-15?Q?e37O3qawQivUMwDKI9iNBf9098p4cCT8ZrT6z1hUPlBCKi3DM1IFLGz5H?=
	=?iso-8859-15?Q?rrcCMDqAfcd/MxaQtdM9A7k3xzeCVEXRcrm2QEhZQun1QWOfFdaGseYME?=
	=?iso-8859-15?Q?lMmqsxcW9L5iaNIX74wWMSjXUrUKabbEH/Vn/j1sX5yie1c4+VRkletah?=
	=?iso-8859-15?Q?ZieyoxRoUgSyyZg73BbwS6oDK/B3u7kiaKljRZpOjoUM+T4ed5jxAgw12?=
	=?iso-8859-15?Q?k7CM/9kOnRK4qFvtXs0D5jWiTQ4YJcbYWLNrcRNzR+WJ/1r6StdVdZxTV?=
	=?iso-8859-15?Q?Hiz8tpc1H8RJa6ASBJckbEVgFbnYXd13lWbGaYKoQnptXiperMOxki5kF?=
	=?iso-8859-15?Q?EiXqTlyGy68STobvoAYB8CcdbjwDFiBHeDH4yUsRYedLqy1cOGBcDYVuo?=
	=?iso-8859-15?Q?APoLiS4tMTiLD8aB+KoQz5ur1eEhTYlzGPZJL/1a/QP5r8oR4qpLT6oyX?=
	=?iso-8859-15?Q?g34sOmeycqd+vF+ARb/OOung6mCgUiY4mhtgJltaoAVjMOUtPebslSky1?=
	=?iso-8859-15?Q?3jx/GXTV7w3KJgr6r7K5Fvu1jsjWZhDnB2DWr5VmXIJTlO3XR88mxFEsW?=
	=?iso-8859-15?Q?of/TUSabJzyoVvpexRe+wK+/BPiMVLSfJqzLiqTlppt+hy7I1I+AFfrTg?=
	=?iso-8859-15?Q?0T33+jGzxTny1+EwyR2Y+I4IWnn8ESCDdNesFY5aerOXQW00R71PQmpfC?=
	=?iso-8859-15?Q?VbPocDo92r2kLHbhbp78pvTGS+mi4hSpLOIxMn/fTKLFPGLgmjWKv8+UN?=
	=?iso-8859-15?Q?ZF+/DFPlylfNKz+Au8I6YpS6GU6teeKUI+k61zIQ2kLwC8hskDi+1YDgh?=
	=?iso-8859-15?Q?dN19DMxu2Men66QozIJvtSqiC8TKUiL/2sCLOEmBJB5vfERVX7zIrnFXh?=
	=?iso-8859-15?Q?XJed9y7o/Ikw31o16A0r2r/m4fNbU2omBroTAXM4muoBqPZWnCJlj0PYS?=
	=?iso-8859-15?Q?3uAx7RZ+YPE5FcsZ96SLgNu1ygyMwyex5pxNMP0Y5GunZO2nS1RMsPV55?=
	=?iso-8859-15?Q?7Rr4U3ipGKPec8REAsOD9K6SaoJM9lKYTgs+wMQNKSE/aGUrr2mqedxjr?=
	=?iso-8859-15?Q?A3pGxP0mD6ngXLwMpbf99ncasRuH+mBWOflvP5Sa0ru6NVTLQh1HgThfR?=
	=?iso-8859-15?Q?rN3hdPKyKj27V08U7V8ec4Rh24fA/GwTb7NJtSyqZJ7zxlxDb04Gt8tth?=
	=?iso-8859-15?Q?Y9qqWG1XuC//bbiGPRsUEifRiWP/uXBzTmscnTJDnnJi4epxX0MSxGSQL?=
	=?iso-8859-15?Q?N02w5gDUyY6P3OoinkM9YHZ9uStDqGg0NmFJ1KetlphK2ySFyrT7mn0az?=
	=?iso-8859-15?Q?hNwMQY8LwYOb3pclJK4H5E2aXoy8sRTO98ZcjdAFHyC7+9ftYXZS8ij2u?=
	=?iso-8859-15?Q?Oa/IH3imBjNKMgE9JVD6TAsC48+9epItyq+gmUfWV/Oty3vajaB2Xr8WP?=
	=?iso-8859-15?Q?5B1hZ3xaiEtF1OH0fabeOY6yHva2O/DOxKioz/eIXHRt+cns1jXUd8ZYJ?=
	=?iso-8859-15?Q?MjiVlzOe8gCKNj9qmsF5Z8L7RbnGr4RH4tUrnt2/Uv3QhzD6Fh7qYy4Bi?=
	=?iso-8859-15?Q?BFifRdpIlLu7ooTT8BeOqUKx3eXmpcFkm5k+TTQQ/M4zZBni4/SF7uIyP?=
	=?iso-8859-15?Q?PLmxIN9Wadx/36BnJMaMaLWOjYJBv5roQYudJepIivFfU0M=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9856189-906d-4cbb-431c-08d9c00c4a64
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 20:48:46.8851 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q3YTS98UTWn2ijIqWVSsKjrVAwjGpXq7m9XjWSiTVpu0GFSSWbQ+/W1yljdSiCGy/9jpN0CLTotzgdA4RjsiQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7114
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BFKmrrx000767
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/3] libmultipath: embed dm_info in
	multipath structure
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8632FEA8AFF0364F9E0117A78389D9AB@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-12-15 at 11:44 -0600, Benjamin Marzinski wrote:
> Instead of having multipath allocate its dm_info structure, it should
> just embed it to save on the extra allocations. This also lets us
> have
> only one function that all callers use to fill a dm_info structure.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

