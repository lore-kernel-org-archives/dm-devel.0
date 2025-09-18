Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2245F224AE8
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 01:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758160474; cv=fail; b=Y0v0OkvImT7CY2M/oe0Y/NM6tPetCfiZJzFio5Cf8eiMWAuFEE42v8j7lfW9CSj5KZHEcxuimqutPPHmUxBi4fywUcOMVi6who5DnCtpGcMm082dHt4sLLXR0tj1hF3NM43PeZgnTTrEPhGmWUL8pbmGedTd2m3xSF4c88A5J8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758160474; c=relaxed/simple;
	bh=xq8JkxkKzI1T1QSkfH90/QgN2ZaRnu4chStEK9oPgJ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R+wbY1oCVl06zQvS/wV7YS3OgTDUwTn9iH1DnVQmlnyXydTilgh+5MKdh45brL+JZRexBtCnCUqcIj1Fn8kkg8gO1RytEjVoNI2azsVUIECNKhIlbUne9ZqrjbqrrAuqXWXXq1EKG8EIZWFXJw5YsJ+OZyZrjn77zucAgU2gHl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=S60qK6UY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=b+uH7kvs; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S60qK6UY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="b+uH7kvs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1758160472; x=1789696472;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xq8JkxkKzI1T1QSkfH90/QgN2ZaRnu4chStEK9oPgJ0=;
  b=S60qK6UYhx0/dF+J/Kwo4LQX92IrYNPDUJAFM0rlUlxyHK5QAfGV1jiU
   8OzQfZwsMfZnHFpoyrceQL9k18rxWgkTjTBnm4AV4Pg2Vycfn/8mD+sju
   aVyMb/oWj+K+tisFd+Cs9xtDEYlE3NbprnIVeCJUFkKuEkfCRZgaL+a0m
   fPjMm4zQdiYXEZvaa+8c82DyxBAp7oWi5hAFU5LJKlgbsmi6sLoIZrnFa
   dcV7Or1ZsOkcIb9cLiWehTw8mGLEdwaYCMMB3DRJJzm5NEwzRxPPykmpm
   fUguh0csqa5ZdKbz5gBbmXKHEoaNzeiAtyMi08woapARGSU4X19ZYdRzH
   A==;
X-CSE-ConnectionGUID: 0fT2lpEwShiUT3x+IqUXCw==
X-CSE-MsgGUID: uujgmczTRCWgCpeKAop/yw==
X-IronPort-AV: E=Sophos;i="6.18,273,1751212800"; 
   d="scan'208";a="124614459"
Received: from mail-westusazon11010008.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.8])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2025 09:54:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cF1qn0onnOVfo0UI/cxFrtpxsi/Boy8o/uoL/UKzX0vL7gekW1LKKwoVJxU4ArLAOKfj4YJMk5HJGG/9xOjPi5DQzzcJrRGS1d4ZXyjUSfNk8n7zJ4Ac65w4NKgI42ZXKE0T946j9DvpYTWGTcYNlCU+T4J1qYHjPHQpg8f91PJR6ZWE1MigCbYye/UlfkrF4xfX0S1Zdq40ZPN22f2+JEk48QoCp68AW4ULDvW09SUY0tfFqVu7cMa7x1mCqeND8GUAwQcxyTVUlYdmlYkd4lPUs08uq67I+g4vxmVw44TqoxcFc/eyTz9zleOAzgMEsFCRUfxKokduZd2GZ8ftLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FndwGIRp5i1f4n+R4zZF21ZoU+aETfwVNPp8AubB2CU=;
 b=CHxRHtXXR1Og5XussnqcDPvFiQyIDE2G2L1TAqJZ71CewiXZLlS5tIta0Uy8G4Mhow8NhHB8G63HJKBexQKNF3HR96OhrKrNlj/0L/UQaX2fPHrMUMCCg8buMgQUwElQQmhF8RKdaveyEuwTi9eLUAiJ0herTuxy9Cs+CbGnK/t7mIGCmhfQYjfBVTqTlgiMWscKa7ZfLv4TrrnyjTuflCJG4nB3bDdH4G3SHaER6UVPIKp6KiG/ssBTKT+Vi42ryHsg+Lglsi/+ElvBU4ag+d2zLD4ou3HoIGdKT6I0OPuijbWvPlu8GlHdjJFBQOGwol8eFF/pVR2ih0JUTlzPRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FndwGIRp5i1f4n+R4zZF21ZoU+aETfwVNPp8AubB2CU=;
 b=b+uH7kvso7OHC+XC8qQYaN4ys7tOdjV3lbayNCOkp8qe5jtWtPT5RftFTyN0ISAJOfVw4IWyUGyH5YetJOHMG6yTiUx53szVechqwXV0aKR/q/j0LEck71WT00+F28M61I06yk4S/mLmGpD4dBQREEcYymvPqhCs9tRD6cm5T2M=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CO6PR04MB7665.namprd04.prod.outlook.com (2603:10b6:303:a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Thu, 18 Sep
 2025 01:54:29 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9115.022; Thu, 18 Sep 2025
 01:54:29 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Bart Van Assche <bvanassche@acm.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v4] dm: optimize REQ_PREFLUSH with data when using the
 linear target
Thread-Topic: [PATCH v4] dm: optimize REQ_PREFLUSH with data when using the
 linear target
Thread-Index: AQHcKD8r2U1k6WeCp0+vmpTt9bP2ng==
Date: Thu, 18 Sep 2025 01:54:29 +0000
Message-ID: <qxeldko7kx763qu7aj7bei5gikwczyzlihaqpdxq3affkmcbz3@v32xuyu3ls5a>
References: <20250910172742.187645-1-bvanassche@acm.org>
 <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com>
 <bbd7cb48-a13c-0077-af7b-39c849c9f6c0@redhat.com>
 <c29b0abc-2443-4cc4-9c2a-a41e6770bb96@acm.org>
 <274476e9-357b-5346-2316-6a6dc2971dfc@redhat.com>
In-Reply-To: <274476e9-357b-5346-2316-6a6dc2971dfc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CO6PR04MB7665:EE_
x-ms-office365-filtering-correlation-id: 81b5fa4d-0c2b-4c1f-3a9a-08ddf6564df7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?HY8+pHHZVEjnX4diegcaDSaiatCHfKKBwETr+SSFW4SfjqD89uy6o09LgeVy?=
 =?us-ascii?Q?z8TnB24mW6d63lMm17fZ8CPUxZ7JB/UJTVbs3eC6poqkk2WxDRsSNOmO88zz?=
 =?us-ascii?Q?Xxyv2dMZxSA6FqS9lYc50f9rtuc/HyE3D9jzhST4n8/nlUBdm2wnYDjbqKvx?=
 =?us-ascii?Q?MCAxl2bbris0TqG+FEv/6dDbK/9Ys44RI5Py6QS7ALiayk1gKl3KDxenzPJg?=
 =?us-ascii?Q?rKrP7n3aeV8LUiai/xXZ4AlZ46DPiAyoNPZx2axLRm/vWwZ/JK3dP4G/fQA1?=
 =?us-ascii?Q?JzwyTsW1H68p3G8nyD0oFqEuCpKuOHHeuQbj4wwuRP9h3VLz363TtfzmJa/0?=
 =?us-ascii?Q?uz8bon9fTQDsxKIDENFVXSMVBpq3VY1AsJCkyr5jrnKV9aW6T2t7Z/CLtHWr?=
 =?us-ascii?Q?hltySUgqYDL1ozaH3mxA7Rp32CYubJPDtdYkeiImAgVd/QjU89XQOtq+a91K?=
 =?us-ascii?Q?ZGkxhZrITyRZS40DPy1ZYVLk6c8BTvMx2en7/9XRjEDjZzx6a2QOLhzx++EO?=
 =?us-ascii?Q?uipxKJR5oxYWXLRzCKZq26ZMVbHuZi7hTxFJb9yGNNGY/2x39FlKnhXnDV9L?=
 =?us-ascii?Q?22O3VMn7skUJsqcx5zhHP0tGXItirSurm9uGSZMUheik9COyEDRfY7mH5P1a?=
 =?us-ascii?Q?L74jj7oTb6HwloOR6XMTnUUOLhFI+ikHqMwLhFoQSazea5sAtklPfHMeu4YO?=
 =?us-ascii?Q?G2M37rNzVqfTGo7UCBm1QtId2c762m6gb1PM9lnB792+1ScYVh686l/l5Lg2?=
 =?us-ascii?Q?cJnN01io6jHWn21EspDwGSPI7CAqBauMC3SkFaS9oeklLU1smGAGoim0lGLv?=
 =?us-ascii?Q?pRDA15JJ6i/yXH2RGk8Nd0jcek6j3M8M928d3ummTtczm5kUzmfUvbVBCWU5?=
 =?us-ascii?Q?hdo2v4miyZdTOOxPssVSgsFqbfL6Nvv2M5hsBYeB0OFVaxCao2Oq6b3EMpug?=
 =?us-ascii?Q?uvkx5Ex/8kr64sMBCRE58YWhrBWv0nOy6HAAv1eG85H4hQv9UfKHDOi40VDm?=
 =?us-ascii?Q?3GpCZGVTl2GIoMYzzgphqF9HBbmyUmKEJYqzJV/lg7b7yzknu3WGP+vMH/Q3?=
 =?us-ascii?Q?NmyomCphKs8ZoEf6E7huZOPtfinogUkwNGoxdI4f1jvI85jJ+MMBY8SaBZfn?=
 =?us-ascii?Q?Ku4P5HEfe/Znn0yXoCq9Vk8ygp7lG23YD8zkTGEfFcNgN+NDAtYrpDAS6zCf?=
 =?us-ascii?Q?A4J6/FfDL59dKC6y2z9ac/wV+RefKCQCnA4FkBSssiSSj3cxwkpGhLzqLsek?=
 =?us-ascii?Q?PjnWBNH2ciU5J+LN/NBmQghkjlvjRtSc9B+ST8E6vAPfK7InFHAaUO8xHxmf?=
 =?us-ascii?Q?qMHNy4eidDhicRz8T9GuODKtKhNSojxSCztzE9Vjq+TLwIHxjLYHgyhTDdSJ?=
 =?us-ascii?Q?VP+pgCRYSnQd/48uRtoFsNkbtZVVar/ezc9Qc6XbnXkLyi3Hg3ntVObiUa8c?=
 =?us-ascii?Q?7b3q4dxABg4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uhkppKxnsmZ/B4Y9i8HayZ/XWDhnEGAbLZxXMNAJZx+X2B/fmHkrbitXuO/u?=
 =?us-ascii?Q?nDLvaDoZB1ptzUQFwXIOoIrL3Km5l4gDdI5dBw8T5Yen9huTGbWPkEJWiyWy?=
 =?us-ascii?Q?EXE5tNxCre1lq2m083lAHYhd0cNLG5sCWIvrilQcQRPzLYFkuJsEO9FQ8CZW?=
 =?us-ascii?Q?0gCA6qyUy9C94pKjtV/7D+Vu+CXfnR0bp4Ac+h/lQ4ogJIYB9rb+L1AKAheD?=
 =?us-ascii?Q?StINU9Uain8PNMGqt49xMuy5M80KMz8tQ1pdeQh3NY7jNSuYy3WzbXbNsrm3?=
 =?us-ascii?Q?dbaZqgmakayBljprp31seavs7+8AXPGimQQpJppwi1UWlGVXyeMHy+TKmyTX?=
 =?us-ascii?Q?WYsn6yM1PybLLaptJ6LUDdib5dXwIw4IR3fPci5jgm2eNfSwAw1doJG1/vSS?=
 =?us-ascii?Q?s+Zt/UGMLQX6Km9QWDTkysmQ1aGcBYkZ7WTXxW1hHwRc6zy0v+uyKoQYfzpZ?=
 =?us-ascii?Q?ZFDgglPb+yYFb833Eowax6Xd+LoKoZOWL3oP0SGi0wbkDCKX5j4M1wufEWHb?=
 =?us-ascii?Q?iqqNe1zYMs0vuuupIkvLI20TYawl/i1QcXaRu1SWPt14FANWkif7a6Fkj5RJ?=
 =?us-ascii?Q?O8mPTnfRUgsVa5yYkF609fmesR2z0lF86IFS5KxW3gTBknCLQCl11IJdKMGl?=
 =?us-ascii?Q?sYaE4jqWUVv4jAC+WJ5kydM/1QSgtgNOISgi23W5CRLqAJurHzMZOOQ8k5be?=
 =?us-ascii?Q?U3wkodsaUeylNIfih3QPqU1WHHC+Y391ZpDJs568GDxzJ73lvXEqU0Fa1F/P?=
 =?us-ascii?Q?7DcmeZDSFLDhaZ6+R08PDqgg/w7xFNtSTNEdjqV16B1w+6mkewxYpSQ9bnKI?=
 =?us-ascii?Q?tCL8A1iBzJt2qnqrqsqiFu5RtrBbDxxn8rrYnBCUpexPJF4FqfOhXuVq724V?=
 =?us-ascii?Q?4kKVgQM/1uET3Zo0ivUCS3F5MrST55bAN5knbGZuJNJtdBRJIPfPLfk244Yp?=
 =?us-ascii?Q?FEQ/wHY3Ap4a3q50KovIM6jvTQKYVQiqtXpLGY+KCuREdDMmfE8NHDlPFAFS?=
 =?us-ascii?Q?jMapULeYEk5CV3VQE1M4xtiI67ZKox/RIIJ1W7IMdMpblQC6KCXid8oP35xr?=
 =?us-ascii?Q?/mgBSD0ey08E7S8goCRHYfLKViqs+bETgIBSUxqaQ4S/whVGRzl8uImg3tZn?=
 =?us-ascii?Q?AxAAW2svQacP/bd48Y3HVLWiorsbNxShfZff1QbGu9WHm6v8C0zvLreymAml?=
 =?us-ascii?Q?yrGnmBfSikRZpe2RsfjptHoj+w1Bpi+O+DTQov0uDv+Jyup8zW4ghugo2ppO?=
 =?us-ascii?Q?QCTE2AgHiVo9ZrR6JiVrfUxMCwLdVMwCMYsEyJR9ta5SP1aCAQC9+rQWraNm?=
 =?us-ascii?Q?SEQCFMLMwArK+2M/aej+ubojYmcBYk74VkVSK/FwnDXVaQUM1yB3HiGnuGAS?=
 =?us-ascii?Q?gcn8bP3CA+3wzF3SluRL139ITctzUoi3KJffrez1RP3tEvyMTZH1qeiw4hpa?=
 =?us-ascii?Q?FS2esbfNcrIZ0ngr9faZxnB0VoW1QO/3jKsxM5fNboShSSNXDaZjBhP21VNw?=
 =?us-ascii?Q?fA9IjGTCYZyze2PhBFNlWJQ5jLsOakKno4R3esAEX9zxhh7+KI/o3ofkt983?=
 =?us-ascii?Q?3Z9B8Nu83uzJiKa9t41ulnAEaqtrhp1pBjCpbXgJxOM4Ref5XshB2hTxN9Gi?=
 =?us-ascii?Q?bA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F483F0DD5BB7A409BDE0E963B018A2F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	26qYbdYOUSV1IyqOg1hAhUFhCylCAJ4tiY9aDJ6o+XmMUHXK7TSMDmq6Ho7gOZ7s1KWCu8n9yX+wPPh1sgIuHKYLE9WyPmEY/CS+nCr7blOY/9svuqmkzo2zJ6bHJ8rUxsYiWAcY16ljlRsuCMVV+5S3X2EGulfnk4QS05oRNsILm+pbBBwLpqxFJv8348sW3oa60BLjUP1vAd/6kjNuc1cPYPYdABZnfgy8iTdZ81DTLiyDwF/ZZaUIcTlJaO+upHOE1ENxZOQg4rE+/FyuTsYJTngH9MQzd6hbzou4Xz4ltnr0o+1VM467sbdlsYn7Sk76xyhtISFJLfozMCZhEw2/wwdwT7dtM7cvCgVNN+h/n6nlavtmGAQWfz2qrcMLHZw7AgVEuqOt27N7sEm78omwJ4z4MU2BFJ/m29NCqNGYomXm4obBOgI1DHagcO3iUr4vrMvSFXqrje/0BEVlF1HxcSU/FQLDedu62k/S37yxTFF5CjlICL+2aOeZoKSW4dh+xab36VB6idfOqEAJMmFzuKLfRW2LxPplfUBtkYQ7jy1NuSKcIhdprzafKhwUqtatuS8ZXCiePbyYsBj0L4DiMoyRpRsu2ng+W+tJnyzt+oD988NznXx0/F4SurwI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b5fa4d-0c2b-4c1f-3a9a-08ddf6564df7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 01:54:29.1910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JMYIw8TTz6NMZmqy+052x6MFY5pqFkIeUOCaUw5cznJ/7Jc/sSTHLh5o3lr6LBxkukhb1/RgPB/yvGrfIaifAJ5/aiEtPBZAe8lq5bIHehs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7665

On Sep 15, 2025 / 17:42, Mikulas Patocka wrote:
[...]
> If the table has only linear targets and there is just one underlying
> device, we can optimize REQ_PREFLUSH with data - we don't have to split
> it to two bios - a flush and a write. We can pass it to the linear target
> directly.
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Tested-by: Bart Van Assche <bvanassche@acm.org>
>=20
> ---
>  drivers/md/dm-core.h |    1 +
>  drivers/md/dm.c      |   31 +++++++++++++++++++++++--------
>  2 files changed, 24 insertions(+), 8 deletions(-)
>=20
> Index: linux-2.6/drivers/md/dm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm.c	2025-09-15 17:30:25.000000000 +0200
> +++ linux-2.6/drivers/md/dm.c	2025-09-15 17:35:47.000000000 +0200
[...]
> @@ -976,11 +972,12 @@ static void __dm_io_complete(struct dm_i
>  	if (requeued)
>  		return;
> =20
> -	if (bio_is_flush_with_data(bio)) {
> +	if (unlikely(io->requeue_flush_with_data)) {

Hello Mikluas,

Last night, I ran my fio test for zoned block devices using linux-next kern=
el
with the tag "next-20250917" and dm-crypt on QEMU ZNS drive. Then I observe=
d
KASAN slab-use-after-free [1]. It happend at "__dm_io_complete+0x866/0x960"=
,
which points to the line above added by this patch. It looks like 'io' is f=
reed
before the reference to io->requeue_flush_with_data. I checked the function
__dm_io_complete(), and found that free_io(io) is called just before the li=
ne
of KASAN. It looks weird for me to access io->requeue_flush_with_data after
freeing io. Do you think this is the cause of the KASAN?

  961                 dm_end_io_acct(io);
  962         }
  963         free_io(io);    <-------------------------------- free io her=
e?
  964         smp_wmb();
  965         this_cpu_dec(*md->pending_io)
  966
  967         /* nudge anyone waiting on suspend queue */
  968         if (unlikely(wq_has_sleeper(&md->wait)))
  969                 wake_up(&md->wait);
  970
  971         /* Return early if the original bio was requeued */
  972         if (requeued)
  973                 return;
  974
  975         if (unlikely(io->requeue_flush_with_data)) {  <---- KASAN sua=
f
  976                 /*
  977                  * Preflush done for flush with data, reissue
  978                  * without REQ_PREFLUSH.

I ran the fio test under the same condition several times, but I'm failing =
to
recreate the KASAN so far. This KASAN looks very rare.

[1]

[ 7042.301608][T62536] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 7042.303303][T62536] BUG: KASAN: slab-use-after-free in __dm_io_complete+=
0x866/0x960
[ 7042.307002][T62536] Read of size 1 at addr ffff88813370caa1 by task kwor=
ker/u16:161/62536
[ 7042.308283][T62536]=20
[ 7042.308656][T62536] CPU: 0 UID: 0 PID: 62536 Comm: kworker/u16:161 Not t=
ainted 6.17.0-rc6-next-20250917-kts #1 PREEMPT(lazy)=20
[ 7042.308668][T62536] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), =
BIOS 1.16.3-4.fc42 04/01/2014
[ 7042.308679][T62536] Workqueue: kcryptd-252:0-1 kcryptd_crypt [dm_crypt]
[ 7042.308712][T62536] Call Trace:
[ 7042.308732][T62536]  <TASK>
[ 7042.308739][T62536]  ? __dm_io_complete+0x866/0x960
[ 7042.308752][T62536]  dump_stack_lvl+0x6e/0xa0
[ 7042.308767][T62536]  print_address_description.constprop.0+0x88/0x320
[ 7042.308785][T62536]  ? __dm_io_complete+0x866/0x960
[ 7042.308793][T62536]  print_report+0xfc/0x1ff
[ 7042.308801][T62536]  ? __virt_addr_valid+0x25a/0x4e0
[ 7042.308812][T62536]  ? __dm_io_complete+0x866/0x960
[ 7042.308820][T62536]  kasan_report+0xe1/0x1a0
[ 7042.308832][T62536]  ? __dm_io_complete+0x866/0x960
[ 7042.308845][T62536]  __dm_io_complete+0x866/0x960
[ 7042.308857][T62536]  clone_endio+0x36f/0x7f0
[ 7042.308867][T62536]  ? __pfx_clone_endio+0x10/0x10
[ 7042.308879][T62536]  ? crypt_dec_pending+0x1a4/0x4a0 [dm_crypt]
[ 7042.308897][T62536]  process_one_work+0x86b/0x14c0
[ 7042.308914][T62536]  ? __pfx_process_one_work+0x10/0x10
[ 7042.308929][T62536]  ? lock_is_held_type+0x9a/0x110
[ 7042.308939][T62536]  ? assign_work+0x156/0x390
[ 7042.308949][T62536]  worker_thread+0x5f2/0xfd0
[ 7042.308964][T62536]  ? __pfx_worker_thread+0x10/0x10
[ 7042.308972][T62536]  kthread+0x3a4/0x760
[ 7042.308983][T62536]  ? __pfx_kthread+0x10/0x10
[ 7042.308991][T62536]  ? __lock_release.isra.0+0x59/0x170
[ 7042.309002][T62536]  ? __pfx_kthread+0x10/0x10
[ 7042.309011][T62536]  ret_from_fork+0x2d6/0x3e0
[ 7042.309018][T62536]  ? __pfx_kthread+0x10/0x10
[ 7042.309025][T62536]  ? __pfx_kthread+0x10/0x10
[ 7042.309033][T62536]  ret_from_fork_asm+0x1a/0x30
[ 7042.309052][T62536]  </TASK>
[ 7042.309055][T62536]=20
[ 7042.335577][T62536] Allocated by task 70951:
[ 7042.336313][T62536]  kasan_save_stack+0x30/0x50
[ 7042.337085][T62536]  kasan_save_track+0x14/0x30
[ 7042.337859][T62536]  __kasan_slab_alloc+0x7e/0x90
[ 7042.338699][T62536]  kmem_cache_alloc_noprof+0x219/0x7c0
[ 7042.339587][T62536]  mempool_alloc_noprof+0x12b/0x300
[ 7042.340351][T62536]  bio_alloc_bioset+0x1df/0x6e0
[ 7042.341153][T62536]  bio_alloc_clone+0x52/0x100
[ 7042.341828][T62536]  alloc_io+0x51/0x490
[ 7042.342478][T62536]  dm_split_and_process_bio+0x13d/0x1cd0
[ 7042.343387][T62536]  dm_submit_bio+0x131/0x470
[ 7042.343975][T62536]  __submit_bio+0x31f/0x700
[ 7042.344688][T62536]  __submit_bio_noacct+0x15f/0x600
[ 7042.345477][T62536]  submit_bio_noacct_nocheck+0x493/0x5b0
[ 7042.346375][T62536]  __blkdev_direct_IO+0x7e0/0xfc0
[ 7042.347084][T62536]  blkdev_read_iter+0x208/0x420
[ 7042.347742][T62536]  aio_read+0x2a3/0x490
[ 7042.348338][T62536]  io_submit_one+0x26c/0x8a0
[ 7042.349038][T62536]  __x64_sys_io_submit+0x161/0x2b0
[ 7042.350031][T62536]  do_syscall_64+0x94/0x7f0
[ 7042.350677][T62536]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 7042.351519][T62536]=20
[ 7042.351818][T62536] Freed by task 70953:
[ 7042.352394][T62536]  kasan_save_stack+0x30/0x50
[ 7042.352965][T62536]  kasan_save_track+0x14/0x30
[ 7042.353740][T62536]  __kasan_save_free_info+0x3b/0x70
[ 7042.354584][T62536]  __kasan_slab_free+0x6b/0x90
[ 7042.355255][T62536]  slab_free_after_rcu_debug+0xf1/0x230
[ 7042.356062][T62536]  rcu_do_batch+0x34a/0x1900
[ 7042.356911][T62536]  rcu_core+0x62f/0x9f0
[ 7042.357709][T62536]  handle_softirqs+0x1de/0x7e0
[ 7042.358422][T62536]  __irq_exit_rcu+0x181/0x1d0
[ 7042.358994][T62536]  irq_exit_rcu+0xe/0x20
[ 7042.359639][T62536]  sysvec_apic_timer_interrupt+0x71/0x90
[ 7042.360701][T62536]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[ 7042.361423][T62536]=20
[ 7042.361701][T62536] Last potentially related work creation:
[ 7042.362422][T62536]  kasan_save_stack+0x30/0x50
[ 7042.362970][T62536]  kasan_record_aux_stack+0xb0/0xc0
[ 7042.363595][T62536]  kmem_cache_free+0x3fb/0x730
[ 7042.364165][T62536]  __dm_io_complete+0xf1/0x960
[ 7042.364742][T62536]  clone_endio+0x36f/0x7f0
[ 7042.365276][T62536]  process_one_work+0x86b/0x14c0
[ 7042.365832][T62536]  worker_thread+0x5f2/0xfd0
[ 7042.366360][T62536]  kthread+0x3a4/0x760
[ 7042.366824][T62536]  ret_from_fork+0x2d6/0x3e0
[ 7042.367386][T62536]  ret_from_fork_asm+0x1a/0x30
[ 7042.367916][T62536]=20
[ 7042.368171][T62536] Second to last potentially related work creation:
[ 7042.368949][T62536]  kasan_save_stack+0x30/0x50
[ 7042.369498][T62536]  kasan_record_aux_stack+0xb0/0xc0
[ 7042.370089][T62536]  __queue_work+0x315/0x1250
[ 7042.370624][T62536]  queue_work_on+0x6d/0xd0
[ 7042.371121][T62536]  blk_update_request+0x447/0x11c0
[ 7042.371726][T62536]  blk_mq_end_request+0x57/0x380
[ 7042.372308][T62536]  nvme_poll_cq+0x6f6/0x1020 [nvme]
[ 7042.372897][T62536]  nvme_irq+0x90/0xf0 [nvme]
[ 7042.373477][T62536]  __handle_irq_event_percpu+0x1c1/0x5b0
[ 7042.374083][T62536]  handle_irq_event+0xab/0x1c0
[ 7042.374627][T62536]  handle_edge_irq+0x2d8/0x880
[ 7042.375142][T62536]  __common_interrupt+0x82/0x170
[ 7042.375726][T62536]  common_interrupt+0x80/0xa0
[ 7042.376269][T62536]  asm_common_interrupt+0x26/0x40
[ 7042.376826][T62536]=20
[ 7042.377077][T62536] The buggy address belongs to the object at ffff88813=
370c740
[ 7042.377077][T62536]  which belongs to the cache bio-1072 of size 1072
[ 7042.378609][T62536] The buggy address is located 865 bytes inside of
[ 7042.378609][T62536]  freed 1072-byte region [ffff88813370c740, ffff88813=
370cb70)
[ 7042.380253][T62536]=20
[ 7042.380513][T62536] The buggy address belongs to the physical page:
[ 7042.381168][T62536] page: refcount:0 mapcount:0 mapping:0000000000000000=
 index:0xffff88813370b900 pfn:0x133708
[ 7042.382292][T62536] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_=
mapped:0 pincount:0
[ 7042.383174][T62536] flags: 0x17ffffc0000240(workingset|head|node=3D0|zon=
e=3D2|lastcpupid=3D0x1fffff)
[ 7042.384094][T62536] page_type: f5(slab)
[ 7042.384554][T62536] raw: 0017ffffc0000240 ffff888134d8a640 ffffea0004ceb=
e10 ffffea000453ee10
[ 7042.385476][T62536] raw: ffff88813370b900 00000000001a0019 00000000f5000=
000 0000000000000000
[ 7042.386359][T62536] head: 0017ffffc0000240 ffff888134d8a640 ffffea0004ce=
be10 ffffea000453ee10
[ 7042.387275][T62536] head: ffff88813370b900 00000000001a0019 00000000f500=
0000 0000000000000000
[ 7042.388137][T62536] head: 0017ffffc0000003 ffffea0004cdc201 00000000ffff=
ffff 00000000ffffffff
[ 7042.389107][T62536] head: ffffffffffffffff 0000000000000000 00000000ffff=
ffff 0000000000000008
[ 7042.390052][T62536] page dumped because: kasan: bad access detected
[ 7042.390761][T62536]=20
[ 7042.391009][T62536] Memory state around the buggy address:
[ 7042.391635][T62536]  ffff88813370c980: fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb fb
[ 7042.392487][T62536]  ffff88813370ca00: fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb fb
[ 7042.393361][T62536] >ffff88813370ca80: fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb fb
[ 7042.394191][T62536]                                ^
[ 7042.394740][T62536]  ffff88813370cb00: fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb fc fc
[ 7042.395570][T62536]  ffff88813370cb80: fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc
[ 7042.396444][T62536] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 7042.397632][T62536] Disabling lock debugging due to kernel taint=
