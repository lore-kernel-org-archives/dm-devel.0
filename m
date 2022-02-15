Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D85C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 20:44:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-7wWlRu1KM3SBeYZi-PxzCw-1; Tue, 15 Feb 2022 15:44:14 -0500
X-MC-Unique: 7wWlRu1KM3SBeYZi-PxzCw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A26ED1124C41;
	Tue, 15 Feb 2022 20:44:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84C12102AE41;
	Tue, 15 Feb 2022 20:44:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 260844A7C9;
	Tue, 15 Feb 2022 20:44:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FKi7Ao007314 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 15:44:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 78F25112132D; Tue, 15 Feb 2022 20:44:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72EEB112132C
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 20:44:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F9243C01D98
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 20:44:01 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-199-XT-kFvV_NIGK9RXVty6zeQ-1; Tue, 15 Feb 2022 15:43:59 -0500
X-MC-Unique: XT-kFvV_NIGK9RXVty6zeQ-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-7-Qh4CjYJ6Oq2IV6PtYOVbzw-1; Tue, 15 Feb 2022 21:43:57 +0100
X-MC-Unique: Qh4CjYJ6Oq2IV6PtYOVbzw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM0PR04MB7122.eurprd04.prod.outlook.com (2603:10a6:208:19c::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19;
	Tue, 15 Feb 2022 20:43:56 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Tue, 15 Feb 2022 20:43:55 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "maier@linux.ibm.com"
	<maier@linux.ibm.com>, "christophe.varoqui@opensvc.com"
	<christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v3 1/2] libmultipath: support host adapter name lookup
	for s390x ccw bus
Thread-Index: AQHYIqSunpijNAbmMEe2Ph2xsUnkiKyVFDWA
Date: Tue, 15 Feb 2022 20:43:55 +0000
Message-ID: <a501002dd1d5cc84ec4cf4f438cf8ec4c14be257.camel@suse.com>
References: <20220215194547.51156-1-maier@linux.ibm.com>
	<20220215194547.51156-2-maier@linux.ibm.com>
In-Reply-To: <20220215194547.51156-2-maier@linux.ibm.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7f584d5-82b1-44ba-0b46-08d9f0c3e269
x-ms-traffictypediagnostic: AM0PR04MB7122:EE_
x-microsoft-antispam-prvs: <AM0PR04MB71220C3FAE216AD8BE48A540FC349@AM0PR04MB7122.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: xWi1oqkXtMq7hlEL0w8VH2uIYBHMyjRk3mSXkwIWsgi2HeHzMxtLQVtv/wmws0KWiJKKxqm2JYBxtE8XUE8q2QchC8PYtbHIU7obvX6o/7b3g8loI0Snqn1lBosbCFy7bKpWovVx8HWR6Ckpmcu0uVAPZtJLL0xQvVLdUgGQRJ4lxFSFTXBporygeoZa5p3FG3Cfj1cd2qNz0gty9b+HuPr0bGK/JjHtEAoKt1dMbFdZvdOovaeNPfl8s4se3LtV6XYCLBSgudKf5wp4n7aaJbp28JFq7pR1BhbxmZHKsEK3tF0zE29EexM5yDiBe/zQj5y5LY6zxEkvTbL4EGWLb6EuZD953y6tirPBLdhxQv3DKhNU3jAfIk8fB0hcWTbBEl2fzKqq8UaEeHJkQFn3EEVTHWrOoax3l5YmVKEHUnDRXiyPXqqgpXkOSMjSammspf46BLN/nuiUqBtu1n47Cjp3DZCntCh0E0BO2PVZGmix8q70TSl2SEtUIEIREvn+knk3VGaIMY3rPj3s2hcrc02b29JIRMCtP05hIdUX9uUOSfgITDnqY79Z/QklvX4MxPCFyZYtTbTuN6HApD4ZyN4Jjd15zkZQpXsdRD8BTpKpjKRIu7Qhze2jDzL0PQ+trbd2GI5fwTA1pmIKvG5cinWgkuE4UCwlp4nrXpsPPTjRHgczeTaE/QpPiY0IcF8Q6DZSOlCVXsaclt9YWk38zA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(122000001)(38100700002)(38070700005)(186003)(83380400001)(8936002)(316002)(5660300002)(66946007)(91956017)(8676002)(66556008)(76116006)(64756008)(66446008)(4326008)(66476007)(2906002)(71200400001)(86362001)(110136005)(36756003)(44832011)(6506007)(2616005)(508600001)(6512007)(26005)(6486002)(54906003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?yM+h5bOAnG1aviHP8LYMYeg7cfsMY5hBwZv1kyBZ4j+oFlibSLhhpCGPn?=
	=?iso-8859-15?Q?k25xomsUhg6X8P7WeD+b2lZ3aTM/tKVEIo+pys29Z+ExQENf1PhlqkcxE?=
	=?iso-8859-15?Q?hScgH/JagUM+u5QHGBJGlfCJCznmdK9OIOi/vhpRWZTlIt6YEknjvoMyU?=
	=?iso-8859-15?Q?hUn7V40puzUSPX0ReXrZdQoL3hiI2L2y13ohKKvn+1v4LewiovfrB12rC?=
	=?iso-8859-15?Q?C+lOienMfvIk6qlJtBlyCEoUL2SjxkHP30BLYslE7ZYZVcmlCy/bue/5h?=
	=?iso-8859-15?Q?CnR/bcuLAgBEJgbuFLxNiBNUHwIpwmeD8B6r0RP1hnKU783sdDjeYVRSG?=
	=?iso-8859-15?Q?QZMjpOiCiZ5vxIpM22mTPfX1XfYdaKp6GUAEHR0gxDW5PgxI6+tM6GwU2?=
	=?iso-8859-15?Q?b/JCpdBDJG+lBh3JJGrea483IvPPTprppz72xczhSHCCvcECxXaMkpdSQ?=
	=?iso-8859-15?Q?1FU6wYwleStOHDCIJdBD6654DLJ1vaiPk7Ei79DPO3CKL01MzdWuJjj2P?=
	=?iso-8859-15?Q?SuOy/HE6qy1HOCZ3mGDRjmPsz4Dbyyj+Tn6habMPCNk5OJl9Ro+hUolzU?=
	=?iso-8859-15?Q?eiOHbgM3fI3oRinI/UmMQ6xx9P0L0pbmvLb6mtmZGTOoDTOk1/lFJ36Wq?=
	=?iso-8859-15?Q?nnv7PSndpkUHw+eruiIyn4UWYFrAiVoBgLDZ9cXMz4BoTwwjI9MU8A7W5?=
	=?iso-8859-15?Q?UbrvkfcKSDZwt7YeR2+iF1KpEn2IjbKxR8gdY0WbiurZuuMPKutTWuTCr?=
	=?iso-8859-15?Q?Er9mslh8vN3qPIvyATOwQvDbA3P9MxNFyIQw3EfiZmPyRrrUbu/1G5LNP?=
	=?iso-8859-15?Q?VQi99hWRthI0THjuxgJNiQqoI7o6nJBh1MYQaweYsrqndIKJJvVSBbOqD?=
	=?iso-8859-15?Q?46J95xg122MTB9E8IXEoWVNTMO99VhK8zWnczKPh43mn17gg0x+0GksM4?=
	=?iso-8859-15?Q?mIpJ/OYt3oQMLRNfLLKSbsVU9e6WYMKQFTFNdmEjVEfbVjMThRVUBnlJH?=
	=?iso-8859-15?Q?XgHmSeqxUNRLSW87SN7PdoiRy1qkp4/y7YMKQ2hmmH6Rb1ppDKLArClzH?=
	=?iso-8859-15?Q?IRMkhRLecfwQo6/BFv+yUG+lKgHaLSpUtLQuWoSjOknMNR/b88J05wWYq?=
	=?iso-8859-15?Q?UuoWmCZ9vt2f9KndB30WbKRfPoATCGJY6fO++zG4NYy4GIU5Am6Iv9Gqo?=
	=?iso-8859-15?Q?MOYWJQJ/1SJaioV9LwznC3Wof3D4l/NPIm3v66PGbh+aGYqX7YPNPfrnr?=
	=?iso-8859-15?Q?mE6W42hreqcmC0Kj4VaEq79UbM2pVuW4jp5rI0122tG5/rWGDdJnh1+rh?=
	=?iso-8859-15?Q?GrOak30FR3k5oeqlddMhsBE4itquZYOrIXqs48Cb1t56fM5dN0BeLdW/Q?=
	=?iso-8859-15?Q?en/06TaLmA5FCG44NSpVWZun0GMxPCMKgFo/PAPDj+/3OcATNhOoZ1iRU?=
	=?iso-8859-15?Q?Vwb89wMss9+FykIuGp26/u8STzGohcETpFbZ/o4BE5X8p0lDCtjujzzhS?=
	=?iso-8859-15?Q?QNF90H5eyLBHKDlt1Taqp+LF00tG13iYOPg794D5b8sM4+NDwMXXvPjuY?=
	=?iso-8859-15?Q?HAYo6r8qYaMcXjbHHWVB1Qdvr/OelwT2juI6IKU/lE7hAIwZN2pRELT5J?=
	=?iso-8859-15?Q?2h4yrCs00UGUPik/H9bXwBwtiPLmRv4JYjGLT5LeFwZM7AlwZ15ROpL43?=
	=?iso-8859-15?Q?AY1y8j4g/GMoPE40YiUj/TTp24qlTYykmhbV6pPqcqSrmHM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f584d5-82b1-44ba-0b46-08d9f0c3e269
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 20:43:55.6522 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gNBXSsIrAFcXxivP7k0f3Mjo2hsgB1LBGzevQ3fpD8sCjNAObpIb9os43Mu/RzCfOGyjL1hovB10lHlSDHD8tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7122
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21FKi7Ao007314
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 1/2] libmultipath: support host adapter
 name lookup for s390x ccw bus
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <354BA2F7B025744F9A6AD6442A352AAE@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-02-15 at 20:45 +0100, Steffen Maier wrote:
> There are also (FCP) HBAs that appear on a bus different from PCI.
>=20
> Complements v0.6.0 commit
> 01ab2a468ea2 ("libmultipath: Add additional path wildcards").
>=20
> With that we can easily get the full FCP addressing triplet
> (HBA, WWPN, LUN) from multipath tools without additional tools
> and correlation:
>=20
> $ multipathd -k'show paths format "%w|%i|%a|%r"'
> uuid=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |hcil=A0=A0=A0=A0=A0=A0 |host adapter|target
> WWPN
> 36005076400820293e8000000000000a0|1:0:3:160=A0 |0.0.5080=A0=A0=A0
> |0x500507680b25c449
> 36005076400820293e8000000000000a0|1:0:4:160=A0 |0.0.5080=A0=A0=A0
> |0x500507680b25c448
> 36005076400820293e8000000000000a0|58:0:3:160 |0.0.50c0=A0=A0=A0
> |0x500507680b26c449
> 36005076400820293e8000000000000a0|58:0:4:160 |0.0.50c0=A0=A0=A0
> |0x500507680b26c448
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^^^^^^^^
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 instead of [undef]
>=20
> Make helper function static and generalize it to also cover CCW bus
> in addition to the already supported PCI bus. Had to move now static
> helper in front of its only user.
> While at it, use string functions that are safe against buffer
> overflows.
>=20
> As a side effect this patch theoretically also enables group by
> host adapter for s390x based on v0.6.0 commit a28e61e5cc9a
> ("Crafted ordering of child paths for round robin path selector").
>=20
> Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
> Signed-off-by: Steffen Maier <maier@linux.ibm.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

