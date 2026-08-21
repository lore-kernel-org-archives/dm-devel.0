Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021080.outbound.protection.outlook.com [40.107.130.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8BB47CA8D
	for <dm-devel@lists.linux.dev>; Fri, 21 Aug 2026 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787318032; cv=fail; b=JHZy4aHlpRCcIERhe+iWcqQ/Oc46R+lfzln190xTxlZxfKW5VbksDtaQSqA/mVNR6p7tx5KDvg675dJfGO06ELlsKOPXEPeaTnvyFxWzjPFHJKTMFDggzF0thIB64o3oY3MrhxvwBEHYbSyL6qIqWPlNdPUc06bxoPDrcAkRqlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787318032; c=relaxed/simple;
	bh=fn5AgWWv9ltNOOJasXlkOGSJ8CrCFZCmxR+S7O3IH8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q2zOQ9p1D3ypDwzSwbgiswxMFy+Yx031JGcYtnf2ciBGWzZzobAjt5FW5cv0n5z6fNDG6bvhdoKBkR92b4LboGEeGDn2zWD7vrMaGFWzTFA1/w7MVsTHC8PVN+1ngfsaIlD71Md7erf+gG5vq6hYMpHLy3XztGh7vKGUQVytFOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=F8Fj6DzK; arc=fail smtp.client-ip=40.107.130.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="F8Fj6DzK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IwSvRSPMFijVasMmz5TaJt0/Q2CVZ51XJIIaVvj+n0NLu8xrh5WRPjRzn98vuMOD2ppcNOBE/plJb0fQLeTRQs6iqtuYxjpKbnPTQQ2LKT4Sq1qALn6qleEkjThs046e37FHB5ZAvgl+D7MOb+VTVUerTeQrgDCqrV9e1A40DOhptSZS4v/foIkYqJ6/TWQUTXK4TzHSAlkWviwVTNq+tn/VLjzqC0r7bziJ0v+NUUrHyDQHiWFbZzV5BPgZMxMYKJAH8jtpmQ9/tCad6WW155hK9iPxws1tKSA+FhrXaa/VfCKbyosVfStx/ppy1ezCbPzbVXK8z03oWHTY1CMONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vs3Twic9cr58r1TyYGp6sergN6EkCOOnHcSu72COnM8=;
 b=MWBlDxMKJf/cwa2Z6wH+qdSjzwyYdrXYacvNiIU9cMhweZujiT6S1aODNqGys8O8Vkg/49NE42zeeLCjrmt40gkVDjoJzBwrdUZjBexskV4edz8+QzgNmcEoLe9hq8iqCxkj5mY9Av4wVLdcCXi2lHkGqsJb8N9TCq7/S5jfODB1OdxLZeK4wpDNfklg8B7Wn86AzdtbdA8S68StrhkrdFrhlbFCgFmNjqjO3JAP84RWn3TPObAlCS526Bbdl4H2cq7glmcLLSelCNYnMf4emZWHaTSrSaCWE2jpZ+D4BjeX7tV7k1sjx1fQHLvMbs7k6h2qeDFf6vqK5FopVXbxvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vs3Twic9cr58r1TyYGp6sergN6EkCOOnHcSu72COnM8=;
 b=F8Fj6DzKnNAiN4/nEKuab61q43fiZLzK+l4rQtmP+DYNLjpuBDh36Yy12KxzPQoYXxd+OKHByNez5hLPjOMvUt9HvnxBGA/dR6yh3k14suR4jZEO8i2DhJ1IcwdAFF5ArqwWrvOmi1Hf0aJFzqrGAtur6T7GwAC2Ba5BcxQ/+/Q=
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com (2603:10a6:20b:5b1::13)
 by PAXSPRMB0019.eurprd08.prod.outlook.com (2603:10a6:102:285::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Fri, 21 Aug
 2026 13:13:21 +0000
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c]) by AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c%6]) with mapi id 15.21.0339.008; Fri, 21 Aug 2026
 13:13:20 +0000
From: Shukai Ni <shukai.ni@kuleuven.be>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "cve@kernel.org" <cve@kernel.org>, Jo Van Bulck <jo.vanbulck@kuleuven.be>,
	Mikulas Patocka <mpatocka@redhat.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>
Subject: Re: CVE assignment request: three dm-integrity fixes (integrity
 bypasses, side channel)
Thread-Topic: CVE assignment request: three dm-integrity fixes (integrity
 bypasses, side channel)
Thread-Index: AQHdMN9UHQNq4sncfUeJOJMEZHMjc7an7zIAgACJSYI=
Date: Fri, 21 Aug 2026 13:13:20 +0000
Message-ID:
 <AS8PR08MB89969F158B3771C36765691CE8A32@AS8PR08MB8996.eurprd08.prod.outlook.com>
References:
 <AS8PR08MB8996E541F93B076637E2C981E8A42@AS8PR08MB8996.eurprd08.prod.outlook.com>
 <2026082149-sherry-thursday-b350@gregkh>
In-Reply-To: <2026082149-sherry-thursday-b350@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR08MB8996:EE_|PAXSPRMB0019:EE_
x-ms-office365-filtering-correlation-id: ac22b638-7187-41e4-4d76-08deff85f920
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|786006|376014|23010399003|10070799003|1800799024|366016|38070700021|11063799006|10067099003|4143699003|56012099006|22082099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 GK7K5WOOBAMF1M754yOll5t/Hz4PTJa6hqGxHWSbU3nVxccaaPPoG/MaOTR93EQcmAP3DTDN6NRrqmUq7dCTZeaF62a/3zyFdkPasiJZGgleg8I5ERqg4KzXe4WNZBJRrg36DGfuoXkFcUJPnsLM+axIHycJXQq8Llgz4Z35mjiPLBIsVdDOvy9z3Wk2PaATjpBxA4Koi4QCBSRbaPnPbPt5KBLEOdTe/nm+uZNsW1Ypt30k9dWbkb72pXwLZ6IPC7XpdW5hEEFM58rCOd+Chd9Zm/GUqVkD/wdh++SwmlwO3nhBkkBIEOYAyzLnL46TaewBsxASvpTEDwlPiinpr3GvqiN4ADfEyAqH3uuzZCblgh3X2cuYwQBW4czs2OjpkjRukaLBvdri0DZjstdU85dOpcqTK2K8SVYoS+JdM3dKsz4r2X07CrspGI4CTFS65WH//2EolcyYCceYEc7GNgPDFs06ilaOlzVIW7v1pMk7lIvKtVh0hTFVym+zjcpuHnaf2F9rKdi+T2u/q5KsusSoSOTxz8MG2c2UaYYEUjA3FEajVjHQRBc76U4nMCBZOXZINBlxUiGFZ3nJ6VyqhESu5/nn01khbX4gInXoTBesndDSVU4Hdf+i76Vjj4uj5rnG8x6IC5hmkm/K8MOqGVk4rD0VtQxoikjicc0DNQ/Amw4cPkrrye6yq2615OQqmmYAq8ycf/04r6gFwAWM9N4mSkvDwg2sNf98rvJAFpE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB8996.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(376014)(23010399003)(10070799003)(1800799024)(366016)(38070700021)(11063799006)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?reaCEVoIuILItotP3a59zko20WZKuUAkuX2HPTb4WDhaQzdrQEfzikKP52?=
 =?iso-8859-1?Q?U7GIDIWrLTGEiXMzfFMoq49/S+Day5kd9L+StveS1b4JyVXtX3MZ+LRND5?=
 =?iso-8859-1?Q?gfuGOY5P0RZPcypjz+gwTSY8yH0etfTg4r40+EzLoaGmvn1S1Exg71U60i?=
 =?iso-8859-1?Q?7D7J1WzvYZGRKOVbEvAd40HAcVRA6RBIiTFRrnVLilqfvtNETLmKi52Z+8?=
 =?iso-8859-1?Q?CLzHRUzMT99MevWoo5vLcsbxXvnl5T8Rh7QwWgzFFrTGSdVMWWN6d/g65U?=
 =?iso-8859-1?Q?8fI5GJWcLV0thYmbgubDfTRX1XcI3Yg0f66hNUD+qvSKa9lO0OkN2zC/Qj?=
 =?iso-8859-1?Q?0Io2R4yYXCH1AQJL3kYqtLRdNngl8ODneh4E7A5tGSALb0/QLMW2k1P7Us?=
 =?iso-8859-1?Q?LvKXlrVH3wnt7A3Mdkv4S1Ry0Q/GfKhEvMtJJvIH79QLmrsoS02xZ3Sreu?=
 =?iso-8859-1?Q?cA487EDYz6n0iu4Zp4kb/cj9M1jT3usyfTUZcU6JONzrNmvO0FxxHFnQrz?=
 =?iso-8859-1?Q?hZBJ/tG5fNCQwaEhZANu7f8YFYcCTfF0A31/50g/oRvq5SefKQp7snQa/M?=
 =?iso-8859-1?Q?w1+bpLdHTOqddpuCJLr3/xqeLkiIPG7Zr+n9jqCYlCrKBpKC0WuTmYBA3p?=
 =?iso-8859-1?Q?s+9Pl16AE+xJ/VgqTljkeinbwgQkNLON9IkHYP65jabKBM7bQnsf9jdLfy?=
 =?iso-8859-1?Q?GtOl3Rh3QdKloJhnchVzmHNvBCanfNWUrZJE0UOcrOkoXT7PIXwaAMuKdu?=
 =?iso-8859-1?Q?7KRfj3ucAs+oi3eUXzCZY6IIBThtEBcefFGn4vFmZVnkQmhKvh2CI2TwJ8?=
 =?iso-8859-1?Q?1UGJOVfdIZnvp1PNLg36x9QP0c538Uz3FgQjwZB8nfDUbJksP9sat8dJKb?=
 =?iso-8859-1?Q?CcEiCRpsymrLkJtVyurdVwgboPKcEPceBl8NIq7N8kOFuizwMJJkzUaI8h?=
 =?iso-8859-1?Q?EQmernzoi6pNn4HW8yrW1al8g/mlp2bTRRJY0ZYs+AQcXMooTcWBnysxpL?=
 =?iso-8859-1?Q?Xw5v3EbMleXX6r8ys0Soty41DMthzk6otP2rULHlzoNxiEPZdBDfHSwxo9?=
 =?iso-8859-1?Q?BrQWpZzAkAsp0ygl9I5K4BFJUtmRP2ey/neT6iptX6YJos7aTtJ4V3x4QT?=
 =?iso-8859-1?Q?zY7BsQFLETJ/DMv9WouzFyLecFKiNH32Ne3i8/QTV2NqCROAeGGzaBqNXu?=
 =?iso-8859-1?Q?G0vSyiHpQg2ABQGX/U80YxgJ2WkEq+BNSEeQl7rcNSjyS3ydHCbP3JmAuE?=
 =?iso-8859-1?Q?L3VvVcdKu5lCP1wIZR7se69YTUelu/R7UPE+x1tIKwy4ptWdZA5tJ7Ym5W?=
 =?iso-8859-1?Q?znw3tB3TKpCeIamaqazg3WjaSL7en9mYI61QoUHaIZExN8HmWhJLIVrzoX?=
 =?iso-8859-1?Q?TNMvxCeC3L0JR+DY7/0b0O/tp5lXGF1AOA5Y5t20dE739sQbYaD9UVqsHK?=
 =?iso-8859-1?Q?8Kl7GqWy6hF83P8PO7nSL+qWSGy/BSqCPsObi3VNNWiPS6+Y8ZG8zCneCN?=
 =?iso-8859-1?Q?21+KrL/F9xIT0TK/5+Ptx8tk4RefD5FKfddpcgB8RSZIzUoRovTRdo7nBC?=
 =?iso-8859-1?Q?V/dDFHvWYFvCx0clGTOMuB+SCxfJkvUKEJOFpYgAfhxYXGVxQYIyAB/yIu?=
 =?iso-8859-1?Q?gX4JnCPMzZqSZ1kjd4y7NeufhRttnGlMp3VYJErzgqzHRA/KQ8gNN+/A7Z?=
 =?iso-8859-1?Q?RdrSYnSsxQCfsdgvYglbErm6imsA9i47VCk7s/6l502gphlqtGbCsRjGRK?=
 =?iso-8859-1?Q?w0tkw/Rd6+RfYtUDKJHuQ03wBCuCJh/c9nABR7l2beVve+REXaRJ27GwlO?=
 =?iso-8859-1?Q?gVxJ2+VW8YHqqwts4wA/zCCFzNPrkCU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB8996.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac22b638-7187-41e4-4d76-08deff85f920
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2026 13:13:20.8538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: foO55jr0/hLS86Yij/7e7yeY/TCQLqy5YQ9eR/1jpgEQk4Zb/bGkVMGVY0W6FYLfbmdWO00xdqDJ9jjP8V6ZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXSPRMB0019

Hi Greg,=0A=
=0A=
Adding Mikulas and dm-devel. We are requesting CVE IDs for the issues fixed=
=0A=
by the two commits already included in released kernels: 24d7e5e39b04 and=
=0A=
8bde1033f9cf.=0A=
=0A=
On (3), we understand the timing concern. It has not appeared in a release=
=0A=
yet, so we will return to it once v7.3 has shipped. The substance below=0A=
applies regardless.=0A=
=0A=
> If this is such a serious issue, why was it not marked for any stable=0A=
> backports at all?=0A=
=0A=
The commit message explains that integritysetup versions before 2.8.7 pass=
=0A=
"fix_hmac" on open even when the user specifies --integrity-legacy-hmac.=0A=
Backporting the fix before 2.8.7 is available would therefore break=0A=
activation with older userspace.=0A=
=0A=
> Also, "raw write access" is not something that dm-integrity is supposed=
=0A=
> to protect against, right?=0A=
=0A=
The documentation states:=0A=
=0A=
> "the section number is mixed to the mac, so that an attacker can't copy=
=0A=
> sectors from one journal section to another journal section ... disallow=
=0A=
> the attacker to move sectors from one disk to another."=0A=
=0A=
These are cryptographic properties that are meaningful when an=0A=
attacker can write to the backing device.=0A=
=0A=
In (1), the superblock protection was not enforced. Clearing the flag=0A=
disables verification entirely, defeating standalone keyed-HMAC mode.=0A=
=0A=
> We can assign this, but why?=0A=
=0A=
We are preparing a write-up of our dm-integrity analysis and would like an=
=0A=
unambiguous CVE identifier for each issue. The fixes are also already in=0A=
stable kernels, and downstreams shipping guest images may need CVE IDs to=
=0A=
determine whether they are covered.=0A=
=0A=
> Again, I didn't think that unrestricted access to a backing block device=
=0A=
> was part of the threat model here. And the whole "confidential vm"=0A=
> threat model is constantly being argued about=0A=
=0A=
Issues (1) and (3) require neither timing observations nor single-stepping=
=0A=
and are not specific to confidential VMs. They enable offline forgeries by=
=0A=
any attacker who can write to the backing device, such as an untrusted=0A=
storage backend, a compromised NBD or iSCSI target, or someone handling a=
=0A=
disk outside the owner's control.=0A=
=0A=
Issue (2) is a standard constant-time cryptography concern. The fix brings=
=0A=
dm-integrity in line with the rest of the kernel, which uses=0A=
crypto_memneq() for exactly this purpose.=0A=
=0A=
Concretely:=0A=
=0A=
- (1) Clearing SB_FLAG_FIXED_HMAC in the on-disk superblock via a direct=0A=
  write is sufficient. The target then activates without verifying the=0A=
  superblock MAC, after which the remaining superblock fields can be=0A=
  modified freely.=0A=
- (3) Overwriting a block's tag with 0xf6 bytes causes the block to be=0A=
  returned without HMAC verification, so attacker-chosen content is=0A=
  accepted as authentic.=0A=
=0A=
In both cases, exploitation requires only a single write to the backing=0A=
device and no key material.=0A=
=0A=
We have working PoCs for all three issues and can send them off-list.=0A=
=0A=
Mikulas, we would welcome your view on 24d7e5e39b04 and 8bde1033f9cf, and=
=0A=
on whether backporting the former makes sense once integritysetup 2.8.7 is=
=0A=
available.=0A=
=0A=
Kind regards,=0A=
Shukai Ni and Jo Van Bulck=0A=
DistriNet, KU Leuven=
