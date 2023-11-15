Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8D93D6C
	for <dm-devel@lists.linux.dev>; Wed, 15 Nov 2023 07:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=qti.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qti.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q4turgPV"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AF6PBtC029142;
	Wed, 15 Nov 2023 07:01:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=2Jg+QTxOmCXQR0dI//ICIZEvpdUkFOv9ORJmdG0yNPo=;
 b=Q4turgPVl1hsRP3xIJQdfpnH+c2LIfvqrPnSUMKjO3BukI1jLdU7nMAicWc7Q4CSKiXu
 VG7LgQhQYONc3xQdY1wwCX/XunlANQ4TKudKoK9vJjrJoxTkLNPy7xNJCgkIVboCb4nM
 Wwl8Pu/hAqsSO3U93X5R2Qg9y6lLRVL9vv2bjvEv07wGvz1I0S9qgt7w9GVagpzJkkcC
 Xo3nEf2gDQf1y3MALlPfOwXgOzm2rskiHr/yX8JrALU9ymuqpgKAmmUn9sGepdELGwOr
 YOQgwnNuf9NZw/KI2wF58Jo83+sOOIv76u9o4JWFwLild+WIsTjmoMXbruu/Ei/gryz6 yw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ucba6syq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 07:01:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Evjn1YF8RGI+WlHXSg93s7Ca+0YOckt+AU8+umKJ+jw5ZxgsM8U9sQllD0b01m+tMYUEn2Zaw51og8sVr1ijD4FTpGCSIQQs27hFN4dvcVjFn7nkx/hJfgVKL7/O9zK3Dp6rc3X761N28I5NqFuvZ+Kdag6+6venx1JHhm6G9dlA37EJmEtEJ+kq2D9I0oY8olqU3qwjsbhutRS+KDYdR2x0ph08LVNY5KQjVXkO8qEGGQ/ltmE0/OcfEZB8u5d2WtqwmaH/JM+limuRfPXjUU9HDZYPoN4ujGm8zd9OzwP0Rqrt2flyHqCJngaAEU71l4rXixEC6Ug2ZryDvDPsvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Jg+QTxOmCXQR0dI//ICIZEvpdUkFOv9ORJmdG0yNPo=;
 b=OslW4N0hS5mbjOPzZ7Ed5GRskCe6MWoqz44jDS8NowvopsKW8xD/jTg2U3nH4hGliWJXmdQe8YB7fezJ0lLCaRfBBWU7N3j1fvDHHwp2F8mNVOWX8F94XQFcVzgZLAaAPYcsz/Yvy9wWEIl7LQ9U+ZgoJApQ/RMyU+JNLBwiI5dT9+SgWNxxpGL4aZk808Tn1IDcwOCxjmrtUXabCBzKwkbVMkG47f08DkvObWkUCsUP0MaxBm3Bh97Ho8rpS8c0R5bYl7ZGFlTRr1WjseOmQHOuUHxcJHPUiyVWWlwt7mKfh4k+AFL2Dig0fZvB/PUh2Om3L7H0FBJbnmP1+J6U9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from SJ0PR02MB8593.namprd02.prod.outlook.com (2603:10b6:a03:3f4::6)
 by CH3PR02MB9423.namprd02.prod.outlook.com (2603:10b6:610:122::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 07:01:22 +0000
Received: from SJ0PR02MB8593.namprd02.prod.outlook.com
 ([fe80::d835:49f5:7ad2:25ab]) by SJ0PR02MB8593.namprd02.prod.outlook.com
 ([fe80::d835:49f5:7ad2:25ab%4]) with mapi id 15.20.7002.015; Wed, 15 Nov 2023
 07:01:22 +0000
From: Aaditya Raj Barnwal <abarnwal@qti.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
        "Aaditya Raj Barnwal (QUIC)"
	<quic_abarnwal@quicinc.com>
CC: "agk@redhat.com" <agk@redhat.com>,
        "snitzer@kernel.org"
	<snitzer@kernel.org>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
        "Ravi Kumar Siddojigari (QUIC)" <quic_rsiddoji@quicinc.com>
Subject: RE: Patch : drivers/md/dm-verity-target.c
Thread-Topic: Patch : drivers/md/dm-verity-target.c
Thread-Index: 
 AQHaEJI42aRUErHkGkOK2jZ/71QvfrBtEBMAgAAM9JaAABH/AIAFzcGAgAbyNwCAAARTgIABDjwg
Date: Wed, 15 Nov 2023 07:01:22 +0000
Message-ID: 
 <SJ0PR02MB8593C7351FBA28D4B213E105F6B1A@SJ0PR02MB8593.namprd02.prod.outlook.com>
References: 
 <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
 <e371659-f86f-e711-ceb6-db9f0fd2e70@redhat.com>
 <PH0PR02MB859987618E8647439950A053F6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
 <559787b2-9b87-4ce-d5d9-6e16f22bc44@redhat.com>
 <1e9615ee3bf84ab7a3023152e3b94284@quicinc.com>
 <f66b2e7c-294b-60f8-7bd0-a4dff496fb4@redhat.com>
 <b5956421-f371-3535-6538-b189b16ec73e@redhat.com>
In-Reply-To: <b5956421-f371-3535-6538-b189b16ec73e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR02MB8593:EE_|CH3PR02MB9423:EE_
x-ms-office365-filtering-correlation-id: bb260e0a-ec85-4927-7d4e-08dbe5a8ad0c
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Il6F/69slo0XMFIH4aqk+nDtjhEd9waCWZ9wtqds/ayJAQgZKjG/twxMX9iB+CRgJwdF17+LUKWBv6SDNxYMz3eoZYJ+wbfUTFTGR637d0uKmSOyJomuBR3VNh60rxKhyTDSdu0PT4HAgiNgtjCGXXV9BJF7uumhW3SbOq9ugmbCA8Vvo/uQfyXh7oa0ZQIrNWT6clPzDAFZZ12hZxO9H6HtrNsEf5luEmTBrh44L7wgb+hR+mccTkdoiLbAPw8N2xdwffYp3LdI5FttMKrlvcwQllREYmMwPsY3rvuzQiudIzPTbzxF01DYaoT491dcg/RAvkkZ4oxBcOUd0klfDBUnnzdiJl1ivArKXULcO96cqFMVvfZDIJCmbaCyYiWHmvuJ2hAslZz/jIHaJGpWyHfwhl2RLpDVHAiIpT24cnWQ9GYCgTVNebOvyVwT/xhtw1KGRkj4KbUox0lMfc+jtq09FrCRksrEq2vrH9hnNamSq/cY1yd+Td209Zfuq9Y52QIsNJCYzQUL+upnkzZCL6D44TVdPeqqUbQBFRATTNeLjkGa7c0ASrAdLvZkbLU9FUoZ2lrPIKI0MDSP5/9I7CrlilNgIpATIhvgHxkprWCmzm2B69zew/7mNTynE3GQHBbIBn23RGTkfeKOQqe1LgPGPc0JyOMESYXtYPmy2Ow=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR02MB8593.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(39860400002)(136003)(396003)(230273577357003)(230922051799003)(230173577357003)(64100799003)(451199024)(186009)(1800799009)(107886003)(9686003)(122000001)(26005)(38070700009)(478600001)(66446008)(52536014)(41300700001)(8936002)(86362001)(33656002)(2906002)(8676002)(5660300002)(4326008)(66476007)(64756008)(316002)(54906003)(66556008)(66946007)(76116006)(110136005)(53546011)(7696005)(6506007)(71200400001)(38100700002)(55016003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?/oXHfqq2E92FuPtrArc2K7+u0m5mbv2OSaApzgxoyaggwV5r+wvSKrv8S2PG?=
 =?us-ascii?Q?tui1Toa780MSio25ztZ4/8ElxYj+jRtnjkhEIyPqSS/OY2W5CAod6NHyzgp1?=
 =?us-ascii?Q?6e2nCBRMz4TsjA7R0+ccmix2xsmSi0ro1+ne8FGsPAkeZojL0KPZ7u52s9gd?=
 =?us-ascii?Q?ou2WWX5zJsAJWi2ZWeQuNFVWPcaviI6alRKbXVNVFQCYYkWZWrCrjpLz7nIe?=
 =?us-ascii?Q?jNXhiMQegM/Eeb7M7hLWLWdtbIvkG2ZFHq00N1TJyN2hOiCYml7o9NQbFoT3?=
 =?us-ascii?Q?umSOfw4hkydT9vKBxzHLIEBdyWr0V40TiuvDA6jjJuzxsPCQQHpBZuMjeXKR?=
 =?us-ascii?Q?J5kVEz7gtIWuJoUjANvxl7KIivOlnh5DXbWReEpBVqwBAngw58QHyxoN2Ts8?=
 =?us-ascii?Q?K7eBq/pNV6+zoWXXuCXG3m+GRuMHuwAQyIDoO6FX/moJbPPZrr6SqiU2gz2Y?=
 =?us-ascii?Q?BukpYX2uw8dXGFA15wz1ptnV+LhLOxijBU8elwITjIIZxXEUUSizkZTUMXOP?=
 =?us-ascii?Q?g2MjtYGpzAQiCRHIiaF2GYukrJlU1W97jXpDnZegJERqdQ4/j31tdJdysY5+?=
 =?us-ascii?Q?GPET40PxngKFNFmBu+c6U0rVZbLr9kLYCV5ENkN85m4LkBVcr+txIHXcxD+/?=
 =?us-ascii?Q?D8jGfonNk9QvDek9LhW//qPVNQM1taIKCZATo1V72QE1fcFTnk6x9gn5Jvby?=
 =?us-ascii?Q?cQNaJIrluQI92wHTic3lpe9EU6xq15Fx7hmA4PJSwdQ79o3sbxKkVlZq/oGT?=
 =?us-ascii?Q?NHZqaTR1QtowQZJiZyxH4cjJj/7994ootGrd69mgmF+wMKJJFY/jWVNo+dR3?=
 =?us-ascii?Q?Xcls+Q1+JaqNVSgKhZiTJsreIRPQMSEhRNs20ran6jAdXl0HvuLo14iq+qel?=
 =?us-ascii?Q?1rO8ZX3XdX7m/rkuS7n58kTMhzFGR/JauvDaD0egLLW8z0pbtYUEhiwiL2mG?=
 =?us-ascii?Q?yfVSS5v/tGm4d177PigwJ7la2XlFksSG58KMoxOimgK8bjBT4cuhLsnjcXiO?=
 =?us-ascii?Q?kjbZHNxYxFCdxhlM+KxHHEOuJHJ7MrNSRM9EqVKgUhWCzPC9xRu/XGqTuF7g?=
 =?us-ascii?Q?TH08cY6ekIrMf2z+dabBv+pmb9Mo5ZAi0f4v/jtClkZH3ILPtvgmdqhdzZW8?=
 =?us-ascii?Q?bhyyvF3epLs0ANmlsqg4DmqEfl9q1JVgpBpYqP/5pQxC3zux07w0xYtXMA21?=
 =?us-ascii?Q?eUhNK//7D6F++JZlDVahRBbqqilqKD/oyIOm35l7rbU/l0usCB6mJz+fiOyy?=
 =?us-ascii?Q?4OSdkXEji3rpjBm0UQfXTXf2hn+KQWvq0qhWA5H/DwAysQ17MzSp8YO9Q3kd?=
 =?us-ascii?Q?RpBR0KijHL+i+a1it6qWdRb4j0WLxA3l4/7ZJoAiexmu5J1qhhpK4jLfZY/0?=
 =?us-ascii?Q?2mtRFNemOIA050bAk1c5UeZMnBfpw9UK6Dy1HUXwEUsg4WKAOydWs/Tz4FZd?=
 =?us-ascii?Q?wiuHkEHjba6ZziA0G+tKUdsl6qV3qUhb1WXQnvCHeRECqULRZbfEdPjmGfub?=
 =?us-ascii?Q?WCXnf+Xsvvvz3hiLXXrNltNlH6M6ekiLsNz+szumkqmJx0Va395jmWQpXOos?=
 =?us-ascii?Q?ARvTlwPjPrRLrH+hYVQW4eX2eG2kX4kEmGM+aJ0l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	YBwfiC1cvIvEYaRp5LAvkfRcF5iP4970dcGzOhZEDLggx/P+zi/TF4y0449x3fwg+zc2DhxdKp3oZMiIoiMeFAJojXweUbcsIWKJw2YPSTbT5lGpmV24Fd8r6HlXFl/1BqJoOiaj4xVJfZoRz7zeB83SwxNk2vjA8r1ZNsFD8g1SiBsmKd3XMCda7gf8VOe5OIMmD64yhffjpRfUDVuEV6ecTG23Ogg4IM8rH1tYVudOBJXrrhPsSfU5urPepcLVc7GiScuEv58XtwLuf2okU8osXWyOfvKsRIYNyvWU0uiD3VQqE8Oyi1hJ15FmGC4AldIwh6e52stBz39z8vOI/bzRg3lT/LIcohsLPRbRQfQn1TdzRhl7gNzrgeUWik/Y1x1CHITwYRoNY/T1oAi3p7odUgddywpyWmA63Bj/rnePLhTxuGWl9S8tceT6uWmoT5jLpX52qfh+Of+FHr63+UoI/t7Yi/vWYnrhQAdKukJxkUfYSuil+RGMrgrDIp5OPufS9cuTO0dwpYXWfIjdMcSB7weF1Raz+cyU5ynFpFF0SmoOzwSYnlzX5JFK+BIaO9Jh3euJTLFF//NVb0GVTRdZ/6Jj6u6GWpwUVVIn1GxphbRDwyBQmN5Fogr+JC3OGAcaEebbIBzamtZwDfrFr4v7+lyGNYYtoRwjS2W0zNPZ3qIMEt+bmNsVEF9OAqjQ6u179GhgIj9kKqhiCXAPWNJpf3xFC+a52GBS4R0tAjTeGXTREPO/cA8zuwmbpBdyp+6d1Gzj3d1z/90k59H9MWEubQLS/xB1Pa8kMay2+Gr3S3BcjTfmshjMZL7wTUNYO+cpdwCXFRXVr2gMNI9nKw==
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR02MB8593.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb260e0a-ec85-4927-7d4e-08dbe5a8ad0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2023 07:01:22.2997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZMhpjteVC0XoQ1ZsZzUzf5nVT0HyV0heIZiCyRcp5RgC+YjQKG89wslWf7TvTTMrDD/sEsqGPqsm7QFMArTZA4x7uENrxD9IEpOjzXAy71k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9423
X-Proofpoint-GUID: G0K1GbPJYv7DSUj8YaEWQPLnBcvsqaSc
X-Proofpoint-ORIG-GUID: G0K1GbPJYv7DSUj8YaEWQPLnBcvsqaSc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_05,2023-11-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311150052

Sorry if that statement confused you ,  It was debugging print=20
that was added to check if the  tight while loop has ended or not
=20
Code : dm-init.c=20
dm_init_init()
=20
	wait_for_device_probe();
	for (i =3D 0; i < ARRAY_SIZE(waitfor); i++) {
		if (waitfor[i]) {
			dev_t dev;
=20
			DMERR("waiting for device %s ...", waitfor[i]);
			while ((dev=3D  name_to_dev_t(waitfor[i]) !=3D0))
				fsleep(5000);
		}
=20
	DMERR("exiting after %s ",waitfor[i]);  <<<<<<<<<<<here it was added=20
	}
=20
	if (waitfor[0])
		DMINFO("all devices available");
=20
	list_for_each_entry(dev, &devices, list) {
		if (dm_early_create(&dev->dmi, dev->table,
				    dev->target_args_array))
			break;
	}


-----Original Message-----
From: Mikulas Patocka <mpatocka@redhat.com>=20
Sent: Tuesday, November 14, 2023 8:23 PM
To: Aaditya Raj Barnwal (QUIC) <quic_abarnwal@quicinc.com>
Cc: agk@redhat.com; snitzer@kernel.org; dm-devel@lists.linux.dev;=20
Subject: RE: Patch : drivers/md/dm-verity-target.c

WARNING: This email originated from outside of Qualcomm. Please be wary of =
any links or attachments, and do not enable macros.

On Tue, 14 Nov 2023, Mikulas Patocka wrote:

>
>
> On Fri, 10 Nov 2023, Aaditya Raj Barnwal (QUIC) wrote:
>
> > Hi @Mikulas
> > Sorry for my late reply
> > I was not clear on the ask assuming it to be device configuration , ple=
ase see below points for your query.
> >
> >  *  Only eMMC chip  Micron product name (S0J35A)  PNM 48(width) CID =20
> > value 8GB: 53304A333541h
> >  *  Linux version 5.15.104 compiled for  Arm64 (armv8+ )
>
> I did these commands:
>
> $ git checkout v5.15.104
> $ grep -r 'exiting after' *
>
> and grep didn't find anything. But your log shows an 'exiting after'
> message. So, where does this message 'device-mapper: init:  exiting after=
'
> come from? Are you using clean v5.15.104 or did you patch the kernel=20
> with some external patch?
>
> Mikulas

BTW. I see that the "dm-mod.waitfor" mechanism was introduced in 6.2, and i=
t is not available in 5.15.104.

So I suggest that you upgrade the kernel to at least 6.2, or backport the u=
pstream patch 035641b01e72af4f6c6cf22a4bdb5d7dfc4e8e8e to your kernel 5.15.=
104.

Mikulas
