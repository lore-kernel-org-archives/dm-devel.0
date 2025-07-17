Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F0F28A700
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 10:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752748443; cv=fail; b=SawrZlgKAQzO95XWeREInBYIiJ43NG1QcpptMY/lenk/xd47kobbNAHSPa5fDYqTNMdkL4/YbS4p14MCE8RaZLbTclOpPBTO7it5TtV5qWj58qx06IgThdwNePfjQPIJgeJTUTmBWZNQSgZY42/xvWKbhrdcpnVI/xgCQY2QYX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752748443; c=relaxed/simple;
	bh=s/ACLHZ5VP6kn1M3TaqJyID8ISQHxjuc8keOYW6iD4c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h+oB57TJYjb47uXr+5kMbnZ4/IStBUTI3VFWvAdGn/vmzW2hmr44n/mYPsFP+W+qvqJhaSmOd+BmZcdFkQ2KBuAtuLk0kCp5+SgfxuCqlZEzpwedr+rDjImlZZ1UzDu74el3xav1r3WIYecjQEEumICAPHXEWQtj/RF0QVoJwDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HsMviNYj; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ajc1HoVg; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HsMviNYj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ajc1HoVg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1752748440; x=1784284440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s/ACLHZ5VP6kn1M3TaqJyID8ISQHxjuc8keOYW6iD4c=;
  b=HsMviNYjGjsffxBdY4vWd3IYAK8K4rGXKS+K3kZ/7Wo0c3xyTFlmFQdX
   nOyOmO+iddnUDuZDnrqq5hL1nxeOs2bntPEXHxAKNlz6FN0jPYqtDCSJb
   Jze9dSWLC9jdxPsPUwraulgVIwWja7vIgenaLlVpgUloxo38B3vSmV7iT
   4YLD6bWSdj8jlf2Xg6IOs19mfNYWIo9FpBUiiAB0veWt1jq6nUquQaewo
   X882O+P58ZDqMleQ9fX41PemM6Yj2JYGyRlzoOoNxm41m93UHLqho2Th3
   Gc2SiaLhnXZewMRk/b3TEDE8E7bE7uKBgOe5UsPLJQZD84SO3Vz7QSOHO
   g==;
X-CSE-ConnectionGUID: XMw21MvmTWSkwthGiBIneA==
X-CSE-MsgGUID: SNY1rx3cTUeIJNafEt104A==
X-IronPort-AV: E=Sophos;i="6.16,318,1744041600"; 
   d="scan'208";a="95469107"
Received: from mail-mw2nam04on2060.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([40.107.101.60])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jul 2025 18:33:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sz57+HO8EVuSWYotS0QzCyYwA2g3ZCRYBu4D7IT7Qny3SKXBhk3S1lTDqYE4GIuHgz8mYXoQO03gnq6lEmO+E3w+wxVPidUaUpO02+5TDM0qa5+ehg+njmfVfCrBWW//x7s50by0yFa7CXLvcQrwU6gIj9AHAf6jmIpVGGRgednTb7NH2FcLeLlywObIuGOEKgCgYn3IZp2gzpBDt+KjnjJwAuIhO45RquQmYX3MaNnXgjCzq3u9WMFg/JaAntsSq/CJ5LXLr1pIgoFr9XK8aTO+Nors6p1Lt1NBWBO9HKuVZBXuZUAuOPGu2SFDppAcWmdSD8mn/3cbQ+UQ56JZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/ACLHZ5VP6kn1M3TaqJyID8ISQHxjuc8keOYW6iD4c=;
 b=aNkfGUPjjZCnXmr3sRFTR+RKxRmSh/P1+m5W3N0pLytE0374N0JEZvbRfl+q/WlGpVvIdptEyXL2ZTNtpwuxbXXtyHETeU+PKek8Wa/tA2bLRDrgTOmqfW62vYH25bc6OsVfvD6tH619eJkWmgTkWeIE7BKocXK3/IEUrndr630xBfienyxq7SM5kT9TO8G1KkbTD6LGE3/lR7m+2rQeUl3NIVxCrVR7VMo7pxe9PcpgW3p5L2oQ7SqoPSQUYetVx9Gb7sAdO5jwhX2vMByyQvqjtbYV15ZsRkEUC7H9FOzp8pwfMoerMxt3GwC4ovCN1YNaG/f/O2xPE6sZDPQMgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/ACLHZ5VP6kn1M3TaqJyID8ISQHxjuc8keOYW6iD4c=;
 b=ajc1HoVg1zAalyi1SoITL2GslD0xFCrt1hBMWuWkd0u+H21uH6lfewbFEZkrx5O3JvGoPmiPKRf67K9EVUqtt7YYarRyqbcqTvKmExN9VV3KFussJnY4O5qw3C/o58Bf55vxSrsjrPLtirG9PoH+MLs06ENCnMtswC2UKfxrfWA=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SJ0PR04MB7790.namprd04.prod.outlook.com (2603:10b6:a03:303::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 10:33:57 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%6]) with mapi id 15.20.8901.018; Thu, 17 Jul 2025
 10:33:56 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Jens Axboe
	<axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
	<mpatocka@redhat.com>
Subject: Re: [PATCH for-next] dm: split write BIOs on zone boundaries when
 zone append is not emulated
Thread-Topic: [PATCH for-next] dm: split write BIOs on zone boundaries when
 zone append is not emulated
Thread-Index: AQHb9sMgEs115cZju0yfrzvJ7LwC/bQ1+SoAgAAl54A=
Date: Thu, 17 Jul 2025 10:33:56 +0000
Message-ID: <h7u7oxijglhp5nw5eizznlc4o247wkbihxsjmg4czhvsgohlud@kk3ldg6colfr>
References: <20250717023255.15111-1-shinichiro.kawasaki@wdc.com>
 <9ac957aa-682a-4997-8578-068444a4b778@kernel.org>
In-Reply-To: <9ac957aa-682a-4997-8578-068444a4b778@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SJ0PR04MB7790:EE_
x-ms-office365-filtering-correlation-id: f8345c1f-8070-4fe2-c6c1-08ddc51d6f4d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ODjjEPpBiW9A2dUlcvua0Cr1M+Fh0Jw2uPQLNUdysOeF8mKUvCdDQcRJ7j5s?=
 =?us-ascii?Q?DYzf4t5Z0kTKFZDq4SN1bzIkzwOhT7w4ND9wup700R1djzyQLpXu8t6YkYBF?=
 =?us-ascii?Q?T4mRtOyDLJUJd/vH4+WT8I9TBSMxyrBfGFO18hJkvK286FnavrHsTcFm7JWN?=
 =?us-ascii?Q?TO3e9mAmZy6RedHOWBi00sFdPY/vUz9Kb0l7rMYzqR/ATHCiMXknGZpIBRsV?=
 =?us-ascii?Q?VRz21NSm/Ea2Y7XrPlliRSPmXYUcfjNFbNfYIqvPSUwH7GM3H674xBNuA3zB?=
 =?us-ascii?Q?n0Sdwnu3y4NSUWwZ53wxpejs7gPEg++c2Vxm3zhZjekZXb/D59wX820DPQOv?=
 =?us-ascii?Q?V9WjInjNWahOWm9QgKYptq4qzNUvgE3wA74ouKSB/3LKbXz9uPpJvRNIGsIo?=
 =?us-ascii?Q?D1jzkcGLjBlTKw/SAvbgn7P0uEnWhVyBEHcNpRJmeRQSZlneCNyhtQGIXpJp?=
 =?us-ascii?Q?c914ZQL9QCynxAY2oDqF26XxY8UKJsys01PMVA0DJwxYzXlTxoam6lxBYr2M?=
 =?us-ascii?Q?79prxlP6+s6u79SoFcKGXg+G3TKVPxQyAphD+J7sJ4KZ8Ju1+mfGKDL2XpDa?=
 =?us-ascii?Q?I4GfEWU0VYd1oFyuGxSd4+YTDjoUBJYXmElgzYxLrCo37XEdN6pZ7dvZXqqV?=
 =?us-ascii?Q?OLBpk9kEMgjI8y/rm5ZnhFwKi5zPyu/+7x9ACmhBD0w3MRLwYxRxcGL/BTzV?=
 =?us-ascii?Q?w9FFADme/Y09RQQKS1FiJt+/Z0WPtfiD8yse6eSmwXbb7wzFe9qlO8i4oYgo?=
 =?us-ascii?Q?mKZnMocMm86L9MecMB++Gm0SrU4B7vZLR9ticqZMEd6qQZ4P6USA4eLYu+j9?=
 =?us-ascii?Q?aPSB7YtEYjwoHo9ceGwJw/4bPlYtUlprkVydytGHkfK1cnlu1qV7dVXD3bn4?=
 =?us-ascii?Q?vPpb/HezbCQpYLgF6gRTTCd9eu2W4eknzO1SiGghnGJR4pEjtUF4lPTu1bhR?=
 =?us-ascii?Q?+P2nzXSXK30oLDpckFEaym0hJQKRmWxmrtNF+M/mQf1sYFf136cdbQ6J73xA?=
 =?us-ascii?Q?/nI0MyPA2AvU+n0Mri0OHpRen5PY0pp+xFaS5Iqlu/XDAJaqPvA8ammn/htR?=
 =?us-ascii?Q?jy8pHT7KZnhp+fWDS4aLGSRhTDsRAygkyUdWifdUPpqW5BOw0bmNYciFTjRf?=
 =?us-ascii?Q?A5SYp9yWFppvsOHSP+S5Pazv5svubxNFyRoaLwM/SH778ywkhBs9JDnev7pn?=
 =?us-ascii?Q?JekVRKmgNOiF7Yrd4J5MAB/MLE8/wNGX06dJ+psX3vrzsOjKPzp8PPNpFV3D?=
 =?us-ascii?Q?vi5aLBv1Slv8wFvW+5sgwRRlOV/UWKZXpug9hK9f8owD7sAc+Wb+8+zsjlw4?=
 =?us-ascii?Q?2BfLAecJRmU+06ViCEJD1ubOWS8rLhFhyhEV8oN973MiQ0ApVB2KuSRJaa0Q?=
 =?us-ascii?Q?6IfR4JsMte+LKTx/8IOoitd9DgIOLLmJw8irRmaSom0ZDvZlORa9SCyynQRb?=
 =?us-ascii?Q?iEIiOVLVBfamLtxLMqcdmZvS3laVldcBqBwijjE6ROAWireYNcKuQg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qCOwoNBbs30BwByNutihsUbsrweSd1wV4TuLB6ovw9ImA+GvTcn65s9XCOa/?=
 =?us-ascii?Q?TeUcuOymHArpVhkxUVfV8pF8zri4U3LvIsItMFWvuX3esOm0rWIsP8aQKALC?=
 =?us-ascii?Q?Jd47BuzYxTsppOxak437+MNiKLP04w+wRFVrhzWGfDvAwAjUMcLhYyWOJNZq?=
 =?us-ascii?Q?CU2fqRXLgwdG0Y0DkQ+kZiUtI2wPxSOpXOQnJV/lnSOQ/mQlTdCSIiY2OKVW?=
 =?us-ascii?Q?sXti4ES1AOI3kzT4w05VQZ+P9h+F8ww6VNU/ZTZcWuuTB+BeP07ZTc2Ga7D+?=
 =?us-ascii?Q?Q9B6FJQvpVp5ZgmlIbhE6H5BM0jARslAvu/n3H8bI3kNpqPrS8dfuiCriICw?=
 =?us-ascii?Q?W3RL3OOy6Zl7ieJ8nOu+BERf33vlCyBdmiWMcmPbuYSycw8lnrzND7L8BzHw?=
 =?us-ascii?Q?nV5aZ0m7PNanTFn8V6iwZtTdV/t/aQsO/xq+qFVKhr1MXnu7kfmwDu5hiukW?=
 =?us-ascii?Q?CEGv8HlM0F4EvU+sIitJi8kpnOreT4foNbpQz98gaF5qsNSxav4NzRNZbIzG?=
 =?us-ascii?Q?pWzIGr8Gw6HHqK2lzHGuQhEKEwA6HQWRaVoOKnwzaBAhQjlLj0YUkWx/L/JH?=
 =?us-ascii?Q?+k7WimamlyQ65bnzG/CDp3JDsN9m1xYbK/Pa6tbEJPhXmIwOOXhjprgoAxxa?=
 =?us-ascii?Q?M9tuEgOJAS5f0S9mjfi9TECh56lDyHOtutocQdK6tVOZwm1WIxKf/Q/uU/IO?=
 =?us-ascii?Q?+ftxc8frs81G4KRNqVIphJjZ+j3qbays/aACGj9VwpP0P+AKXpRRk4cWbYpS?=
 =?us-ascii?Q?Uf/ShuSv+Zd+0LKbsAh4f2nCSSLu1WHQKRZ24kMneMMs09I/kOjJlLqr/Dx8?=
 =?us-ascii?Q?YHZJ7Z4IbzO7hFOU8XVi4LCjjOQRam+uMQ0IEo/8QbfghNnGWLjq+Rf+54De?=
 =?us-ascii?Q?tueFFGk6Z2JRCe1NahffIOfplRz8N/w3h25N1tZaRSPNQwzAT16qHNse0vb2?=
 =?us-ascii?Q?eUsw7ATzBD5nHKSrp2c0I+imXTiqnPqy27RKkovCWdtADfQzUH3H4QV/DXLW?=
 =?us-ascii?Q?sUzT6BpBH6ji1I2aQ4dKVPxT4ePVINkJNq2Nc6ZqD9sJyaHRciVksGO2yr+T?=
 =?us-ascii?Q?6agr1yNWfemvROn8qeI4RAxxHjT+p5DegvdVCZn62P3L/Of/yC8oBIMYnK9y?=
 =?us-ascii?Q?QHcH2LuCQ77En74hRW222CygzJWakSjBUlM4KeTFULEjH8U6g5NdzczEeSPK?=
 =?us-ascii?Q?NGV5RKtUwoKK8g29GaxVYid2Mjc58410JSvx6PZethnfwIeJ34eRe7lRzSB3?=
 =?us-ascii?Q?+f6FZbLtFrmuYOAd4jrMg5A008a8YNK7RJR3i50Zkp5pQWJ+Rwe8thWI/xfu?=
 =?us-ascii?Q?6yyes2wxHL79NznxnALVwSgT82CmAOWWwDWphbm+HblVsNaitpJeFtUUCQcE?=
 =?us-ascii?Q?WseUZfgW53TMAwSVOM1UooGM9CXDIMfKas8nIulfD4NHML7acFj1K3Dgyvxu?=
 =?us-ascii?Q?iPB2GELFJD0S6k6eIlMiRPsMxYbN35tVlQI6AM6TU5M7JnJ5FtuBb2rLG6B1?=
 =?us-ascii?Q?b8ytiN2MKKdn7G+Cp2gtjRv9mI1mAkaDAI6+pZKP09uQe6CSCB0Kx2HQ7Ha4?=
 =?us-ascii?Q?8aRrSolvQ+DuZrMQ4Vsh9DmI8D5W4GiEX1CaEN8cqqZWucpOvvjLzRYHJmrW?=
 =?us-ascii?Q?xA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AF531616B7DD23448E862926F1961939@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UJnC+vvlOryTn7AHi6t5dBiKnhV2iX/RIWns4cxMAJZvhjumyEcikzGuzq4zSNQeBUG7VUYdlW8mygJc/JrdR3ry3lxcYWRfdt543jTmnQC+e1mXzo+V0TR9n2PDP2GSP/QnLiDiXSxYMLubo49fnz1rbKrX98tlbyzVYEsK/yfmw5nIWaEZsHimjvGCsJI1hm1lw7B4sREdBrKc4JFYTpNu10hKF6z/4N2MLkJvb9ACoTI4IxhNfTSkf+KMxyQXTgLaJ8vKY2kqtK5Mqtj40L92sEmn+ujj415pPVpRiIBUrJrUOwM7X4R7fv/qXLpxu5aBrxlCMzywp3YsRR7xYSCrGZ52Fiv3DfLLo7CEEcXvLawLOA1M1PPXnllv19e4mxC/Xgc05Sgz+VNtrqsaIhKrSmeObJoQoyuoxkzlmaSNuDhq7Dlbe/nKFVwIxhol6rSCrfh0Oj9mH1PEZjiXWZuzeAEdZ85UOQoquCiIs+rbFo/goE5uPR6q0q19HwegjaGZJ0dGKmzWUqWI6LnBovk8hQGiKI6WjsVe4y2EhnYzbYYAXU/ItKECIkPDJyZddVKl4wiwIgNH3XtjUIjjwDffF1L1luoDeZWhteQsqYJoUxW6Fg9EtW2IV6BwZEnP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8345c1f-8070-4fe2-c6c1-08ddc51d6f4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2025 10:33:56.7808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FA4ogshBKlAIVyJFLoEnBFn9yhdirze6vlMfJjQl5m3x2ty+tT6/oZT/KHpgld6hqWsbR+sqnQvmBGTHzjwLUMJ4OoJaSUyYktE8FBcvEG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7790

On Jul 17, 2025 / 17:18, Damien Le Moal wrote:
> On 2025/07/17 11:32, Shin'ichiro Kawasaki wrote:
> > Since commit f70291411ba2 ("block: Introduce
> > bio_needs_zone_write_plugging()"), blk_mq_submit_bio() no longer splits
> > write BIOs to comply with the requirements of zoned block devices. This
> > change applies to write BIOs issued by zoned DM targets. Following this
> > modification, it is expected that DM targets themselves split write BIO=
s
> > for zoned block devices.
>=20
> This description is confusing: if the underlying device of a DM target is=
 a
> blk-mq block device, then blk_mq_submit_bio() will be called and will spl=
it BIOs
> as needed, regardless of what the DM target did. For BIOs that are issued=
 by the
> user/FS to the DM device, then that is when bio_needs_zone_write_plugging=
() is
> used by DM core to determine if a BIO must be split.
>=20
> Anyway, I do not think you need to reference this commit. So I would drop=
 this
> entire paragraph from the commit message, and start the explanation with =
the
> below paragraph. That is very clear I think.
>=20
> > Commit 2df7168717b7 ("dm: Always split write BIOs to zoned device
> > limits") updates the device-mapper driver to perform splits for the
> > write BIOs. However, it did not address the cases where DM targets do
> > not emulate zone append, such as in the cases of dm-linear or dm-flakey=
.
> > For these targets, when the write BIOs span across zone boundaries, the=
y
> > trigger WARN_ON_ONCE(bio_straddles_zones(bio)) in
> > blk_zone_wplug_handle_write(). This results in I/O errors. The errors
> > are reproduced by running blktests test case zbd/004 using zoned
> > dm-linear or dm-flakey devices.
> >=20
> > To avoid the I/O errors, handle the write BIOs regardless whether DM
> > targets emulate zone append or not, so that all write BIOs are split at
> > zone boundaries. For that purpose, drop the check for zone append
> > emulation in dm_zone_bio_needs_split(). Its argument 'md' is no longer
> > used then drop it also.
> >=20
> > Fixes: 2df7168717b7 ("dm: Always split write BIOs to zoned device limit=
s")
> > Cc: stable@vger.kernel.org
>=20
> The above patch is queued in block-next, so there is no need for this CC-=
stable.
> Remove it please.
>=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>=20
> One more nit below.
>=20
> With these fixed, feel free to add:
>=20
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Thanks. I will reflect your comments and send out v2 soon.=
