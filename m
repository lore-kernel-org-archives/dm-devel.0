Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.102
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794575020;
	b=4wawudanIzjLpQwdHYlF/wx41C3vXJcLxQeefixBd6V/fh6VWdYyQxzp1rrJpd6YPc+g
	 JgQRehBv8gsyYTtmVmUWlzCe2/ayDJQAs+qzGCZfff2ECf4pFTABot4eNVZn++VYMTO0S
	 0mgypus2xRLo9g29XCZzgHR9MhguaJd07mqq137cRHv/MTZZPeW/DJcvxhVR2EpgsaeNE
	 Gs5/poukSgiwGOsB1Cfuix5rJLHiJ6ltqWfl/IUTMSBGdBOGDxrFOoSmXQGeg8NScDto9
	 yh4Erpbsq23HKKcFik3AQZ1CSAL8KGZ7BZRMAdeRxVq3k+evZerKxa1k80DcthIbGEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575020;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-atpmessageproperties:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=48GZs7YzT4skm5SopQPGdf+8fk7qFiA4NEeOmj/XnCg=;
	b=f8VgLBKRm5axIyu/gc0aNsDr9AKb1D+HnE53KkwAQSiq9YSiG5iQvzseLder/bfYOgxl
	 uD/ZyjSMR5K1Jjd2Zwv6jko44XB6oyPv/z9UlU+H5rs9c8Mm+ItH00sczn0bbf9whlOeH
	 cJKivU7XhwK8VYNAmI4PxDBI2MFFaG9nspGCBL5jgzLHlDQQ7ppxJqpGgl/lsMIYrG869
	 NfDz5R1ZRrQAiktVQuPD2uoKUqU3lFyZ/6iH4YrwVDsSqTK2XDlCaW2LaRrGrXqccrclg
	 I1oaO6xZzLdonadeLtYlm73bS/cUvvwbpZrqzQraA80pVh1a669w3vfXwzKOAdtg6kg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=Quantum.Com;
	spf=pass smtp.mailfrom=Quantum.Com;
	dkim=pass header.d=quantum.com header.i=@quantum.com header.a=rsa-sha256 header.s=selector2 header.b=DBJz7ZYD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.102
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023102.outbound.protection.outlook.com [40.93.196.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B806606A323
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 13:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B806606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Quantum.Com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Quantum.Com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=quantum.com header.i=@quantum.com header.a=rsa-sha256 header.s=selector2 header.b=DBJz7ZYD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hwatn6FfPiR8l17JRFzocWF6194sv03raOtHVKB7nDNVxPyiZMp1oWi3qtY3+1q3WrAHhVv0PQ0vWUq9eWjV1lD5APGgYY4k1MSrzePGIu8iMVE1PUG12uJ0HWAUFD6IbgwUun+lYrV4hZEU5/AztegLF9/6pB2awYFP5QcssEnra4NWEGsFbkvIgWuguX/McW+De675OmuAqLX/TvYdWZexxhbN6fGsVMchX43iaw3kR6Bj+pQhGfFx4QN1dKlmY/LRcxFFPB2itsPY1t+6WAYeKyjcVuiNS/2qijTLDRcmrYbcJO3omDjkf0UOMUmIu36lUXcIuXiic/ekpu9eJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48GZs7YzT4skm5SopQPGdf+8fk7qFiA4NEeOmj/XnCg=;
 b=faqz3hw3mVjB7ttSWlQFheDOYMpJJO/ZabFwACh712rDkTZ/j38tDhFrL8lGi2CkEWwRrNPcWh9gEvktiQ088bnsfHNyOBniJS0aLUPbqcNGW6rfqlZIwXUVCUMs1iD+AUcO41UGx8n35GQUBU8ONWhzeqHrX+p81HpOaEYao+ASysZo1O9K2pIgAHNvPs+hTf9xm2/f2bRFbvPXEGxx7zX4DQbTvGVmbRIYEUxBuDCSyybwXwiO5kjhC1Dy3gmm5xa3BOzBYzbGzOPjTQR9dFqI5phKBniTdsIB1H59lr8Fs379ZkWpzIH6oB3rQDV8uiUviL4ys+7/Ekaa/QwnMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantum.com; dmarc=pass action=none header.from=quantum.com;
 dkim=pass header.d=quantum.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantum.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48GZs7YzT4skm5SopQPGdf+8fk7qFiA4NEeOmj/XnCg=;
 b=DBJz7ZYDv8anECSk3azq2tdGSQelway/Tvegxjp0v2La3c8KIk0sbe+M2mkcjYn8+SKxwmndotFiRs0X72xI74Z9R8hmMj4s5R6uJgnYKfPfoSCCQvOZJpYoJjARZdTnbqKen8ZX1o6HvyJEs00X3W1VzAb78qJhqButv1OH9L0/vpWm66T2nk5BKSH1s1A7Xh7rU7hahg2D1ISKHtQYLyTRdwzNaU27ITphSuqJDqmpQ33U5D7UV6qi9Sx33ZI/FSkenvV5NdTNQuPBfJsbbV1lCDNxCrfyMs7VvNxbT6DBpRGAn6MA9h2p9qx3yRJeSlhM1JKAP3WZq0UbgLpplg==
Received: from BL3PR14MB5577.namprd14.prod.outlook.com (2603:10b6:208:3b8::16)
 by CH3PR14MB6915.namprd14.prod.outlook.com (2603:10b6:610:131::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 13:03:33 +0000
Received: from BL3PR14MB5577.namprd14.prod.outlook.com
 ([fe80::8ad4:cb4d:6241:79ff]) by BL3PR14MB5577.namprd14.prod.outlook.com
 ([fe80::8ad4:cb4d:6241:79ff%5]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 13:03:33 +0000
From: Bart Brooks <Bart.Brooks@Quantum.Com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>, DM-DEVEL ML
	<dm-devel@lists.linux.dev>
Subject: RE: [PATCH 06/13] multipath-tools: hwtable: update Pivot3 maintainer
 email address
Thread-Topic: [PATCH 06/13] multipath-tools: hwtable: update Pivot3 maintainer
 email address
Thread-Index: AQHdc25huEqbWkqiBE6H48ZyUGDyVrcr97ZA
Date: Fri, 13 Nov 2026 13:03:32 +0000
Message-ID:
 <BL3PR14MB5577651E43F52AA4ABE95A98F17F2@BL3PR14MB5577.namprd14.prod.outlook.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
 <20261113125549.504780-7-xose.vazquez@gmail.com>
In-Reply-To: <20261113125549.504780-7-xose.vazquez@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=Quantum.Com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL3PR14MB5577:EE_|CH3PR14MB6915:EE_
x-ms-office365-filtering-correlation-id: 166db8d0-5d62-42c5-d618-08df41868578
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|10067099003|4143699003|11063799006|56012099006|261026140227099003|261026121527099003|261022105027099003|261028144727099003|261021123027099003|261021121427099003|261021135927099003|261102123227099003|261009223027099003|55112099003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 YwIbneQz+0PnMmDto6SwpdCF99AsJEyWTasWxOsCJ0Ny0vhs9+EwXBCwjH+GgO+9UZfj8KA++7bS8nPS6IArFJovdzin5AuhGu/zet+vY5p2eRzL7lqQQ6+tUUlMPGGK+ITFAC6eMk+WrQSRIwk12T4nU7SvipicPYAbJLhg7b/lrdHN5DizxrDkBAfZflA5iZhpi/dZ7/bnNLJYNxNZrTTudsVmKxxZ523MjESD6SILce3k6Xys+I0HrrizflHh7YSkJ/9dHgrukQikdGkzojsXyJ8Gl4qh+0ujFCMae1sUnPkilqRWuFaJw37Q8iTKnFs7CApGUKkzBsWtaJziU1oQUuyQbe5fe7gpQpJbP+v/cDHC3k9YrAhnCI3ydcBE5+MlOm61n7z7qYY8UvQhtt/CZzf5lDBGvGQiDg7vW3bZcLffg+VXpWFXp1894VUXgbfi47DsM5SQtse0N8MR9FEPG5kAm8StFZknJHg4VNrXJyrS4XvUNCH7/6hvks1saLt1iaKKo7efTNk3Oj+uoo1pqS23gC4FvMty8SBJzuK2dy4OzTrmol78S2A/DnxE7SBuc9tL8eVF96wHN2j4Wrl7U3u4NjblSM/1rER/kMOK30W/NT8QsbItcAkQPQp+OKy7yVDLW9HnrVyrQ1sdOkRyWb6CiKsvl6cFBloG30PT4DG30i5u1jAqHArfKUPTW2R9cQp33UwYUOriaUau3ote5KiYBq+BJ3DI/uXEH+8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR14MB5577.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(261021123027099003)(261021121427099003)(261021135927099003)(261102123227099003)(261009223027099003)(55112099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?5b0gmq3xTA2wpJG3TBc4V1XTphe3ncAKcfrdByZFEuT1TbYlcymGkaoygrgD?=
 =?us-ascii?Q?GIk04k23iIfF0ZcC3lDQNRm34hKNF2B2wpcCbP26i+TIGnrVUh5m7IhY0r88?=
 =?us-ascii?Q?2I6mOwVoue5zQhtTutyC+Bwm46IC+Pqy/+xkMRABKmZoFKMYIHnjGWupBL/q?=
 =?us-ascii?Q?iLR85pDNoJUQCRHb5c4ceakDYqqdaN6HUJyM9j/0x0wgZvPduPIx8ex2bAaP?=
 =?us-ascii?Q?ltOMGzesUYZQnSHe3Dl5UG0dSg+Fs7G5eC/CoDqWbvJeCyRngQDfWFlFyLRT?=
 =?us-ascii?Q?ugRJhZK6wiVg+sphXK9MG0Ff1Cy7qSo15Ucj3WC54jO/sYmXToYqX9W/gEgU?=
 =?us-ascii?Q?eeaB8l65k73804XOTg3DTm/TtGCipbENXafEVX9y64x/gxEcPDjRizlWRyeN?=
 =?us-ascii?Q?JYcU7Yi1H7B/myregJNY+pNqtMVMUSiSSQLJzMOkashS77ARMYAoUJ471+vB?=
 =?us-ascii?Q?FJW4dDhOCWrs6xvJh7fXjj3l5VB4B/c3PaOgf3AHlOdamJXQSMkMB3YfXZqD?=
 =?us-ascii?Q?yo+ceO9cQCR7DXyd21XfrvWYO+5hZ9KRwqk21U+eHGR1HBPssm/1HPeeF7i7?=
 =?us-ascii?Q?Yb5SpXgWVAbzkQPbPVvt2y1oDX93wmg8YGYgaBnBE6EWornchzvsErEb1/dB?=
 =?us-ascii?Q?ETWYFstgQI/RKWWLxvAHiTsZ0pdF6Pi4MoYnCXMPO2eARW9GIyBlSGKDTvgc?=
 =?us-ascii?Q?jTXBU7vU/jLzQgaqdBZEsJAxrXH66UBLS/L7spUmJU0v+Lxx7xK6vqtrCllz?=
 =?us-ascii?Q?2smVR3HWd6T/y7bLptHH0d1PcqjPeLGjrk/Oak6pe0FRH0JpBpfRHweTCqON?=
 =?us-ascii?Q?xR0pMJV0nUGronGuKt2qA5oD8Tcy/jRayqzGaDgBz+ESqx1hBzILUIwdGRzi?=
 =?us-ascii?Q?13FlWEnHzWAjX5XutiZBMfNztc3cNR1BqxUHWQs6Cgwy6IZLfDWN04AsV+Mu?=
 =?us-ascii?Q?0bI4/6rIL+xdT0W7wTsWRCK1scHmGS29e0Q+I/lsfnqcM/w+wj3HK+HwU3lF?=
 =?us-ascii?Q?6hXpcN1E29746PeOkY+9MMIDZOjgLo6ucRBV1xekktYR1cc5c3HfWkMZQVNT?=
 =?us-ascii?Q?NEf5eAKa1OLHobW8l1WYbQPFsYPP4GOg9rLVqFf8LNkkszsTpp4DZ6bGKb80?=
 =?us-ascii?Q?oZrggsky0vgCqxCAOgYmDKMzRqF4z5UtEkY3jbdKvH1s1EOjrZerb/GFCruE?=
 =?us-ascii?Q?Ek9zQcFgH5Lu+jDKpPFhK2pdlCOeYxolBrYkW9NSwNI4nfQD+KEnYBzII4Tk?=
 =?us-ascii?Q?Fys3hQBiLTdHU42YImZAvC5P7e+hNsUE1TJn6GK17zRTNqQ+tJSHevw9PRFp?=
 =?us-ascii?Q?2PoZrWng6JxJLdQVcUMJzi6SNprj+2qHIXeHm2V3ayezmUzrcyS7i+jHoilZ?=
 =?us-ascii?Q?lGtGAEL7gCOi/SR2BE0PQRGwfq6mLjq8X3oj/KTmlVlIEZ4fkNeu5XcodGjc?=
 =?us-ascii?Q?/a8jARvBsrO3glBdmmwWVjqMLqcQ+Xi8liV8GzR+4zjBCreukbrnypeiLHUl?=
 =?us-ascii?Q?Uul2K2rUisdWjwnOAphD9ulebE2vRzQp7zMMIYRicycw076Ah0cxDKuRm3U2?=
 =?us-ascii?Q?SeqW9RXiSYiByIahbLZfL9Y1XJF6eeJzGAT28nS6ZkHVhX1wDP6wCwCwnMAr?=
 =?us-ascii?Q?F/udQMjfPETY0AYbLsS0XbOE2MuGUdkLaFDoYn0iP7UPziXjlFWUs343935R?=
 =?us-ascii?Q?gVLlZJPN9fE/hKSqZDpZs4F9kxSuaq+kjoY941kcgJrca5WY1J+zEnYvEnIE?=
 =?us-ascii?Q?HQm3OLcxNg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: quantum.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR14MB5577.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 166db8d0-5d62-42c5-d618-08df41868578
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2026 13:03:33.0117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 322a135f-14fb-4d72-aede-122272134ae0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eJfTezZobSfe0lYTlgeFWY2FMCVEEWs1Sb878mXibEvVgW9xtamh5oZy16pPTYXoAOpXZpiH9pYKNKrTvVmpTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR14MB6915

Hi Xose,

Thank you,
Bart

-----Original Message-----
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Sent: Friday, November 13, 2026 7:56 AM
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>; Bart Brooks <Bart.Brooks@Q=
uantum.Com>; Martin Wilck <mwilck@suse.com>; Benjamin Marzinski <bmarzins@r=
edhat.com>; Christophe Varoqui <christophe.varoqui@opensvc.com>; DM-DEVEL M=
L <dm-devel@lists.linux.dev>
Subject: [PATCH 06/13] multipath-tools: hwtable: update Pivot3 maintainer e=
mail address

[You don't often get email from xose.vazquez@gmail.com. Learn why this is i=
mportant at https://aka.ms/LearnAboutSenderIdentification ]

Cc: Bart Brooks <Bart.Brooks@Quantum.Com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c index c9f12b26=
..a0befb0a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1013,7 +1013,7 @@ static struct hwentry default_hw[] =3D {
        /*
         * Pivot3
         *
-        * Maintainer: Bart Brooks <bartb@pivot3.com>
+        * Maintainer: Bart Brooks <Bart.Brooks@Quantum.Com>
         */
        {
                /* Raige */
--
2.56.1

The information contained in this transmission may be confidential. Any dis=
closure, copying, or further distribution of confidential information is no=
t permitted unless such privilege is explicitly granted in writing by Quant=
um. Quantum reserves the right to have electronic communications, including=
 email and attachments, sent across its networks filtered through security =
software programs and retain such messages in order to comply with applicab=
le data security and retention requirements. Quantum is not responsible for=
 the proper and complete transmission of the substance of this communicatio=
n or for any delay in its receipt.
