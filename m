Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208D013D8B3
	for <dm-devel@lists.linux.dev>; Mon, 24 Jun 2024 13:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719236631; cv=fail; b=W2yx6TY/t2r+0w/G/RMQKH3QgTPdQVOhVwl91fg1YuTvVHXRzz+Iy3LGsb8hZalQYla1zayyCNxxZpheDi51CmmCq5oI5+r7CcKsB69Vq7YtjslJxZOt7yxEY4p8M3l2FCMdmqv8VwqNSpj1RjVheM1PDoydoL/ceek5w5bbSWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719236631; c=relaxed/simple;
	bh=8bs8awmXwnaAxmh5sb5jwki0JcDs9fzMzcTCDRdrM7s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XI7XWNlEY9blqEyINoNlHTrFndN+JOxAUadV5BT5MrnVKwDhfaEGfv78z805WRRzG233bfKoEGxWsVSMeNLLi/2RxYBqXuuNlYOBdKU2xVYbYitrk4kmwiddazhy+xvVgL1qCYS9fbjttDGoBwJw+9ky/wepZGl9253Rzrm3UVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AHbTEJD5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=I+Gi5BK/; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AHbTEJD5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="I+Gi5BK/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1719236630; x=1750772630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8bs8awmXwnaAxmh5sb5jwki0JcDs9fzMzcTCDRdrM7s=;
  b=AHbTEJD53brkZEMj1wvwd3a0qcIl9H89a1dlikpCXmspOhyO30dMU4nk
   Py1d7twuJHpCOzj6Tk26iogGm19b8+chTAJpcXx81RKU5Og444vjTl4ua
   dSqy3mqHh7f/6vUnDkbtrWAHj+f+EalJKYe3ZOi6qilWutHWGM2fIKtjy
   KVQsHIJAWWBer+u/hoyzJszcvYvNy51J9ZDShx8RUuuMGVtrf3p39APU4
   QaKSGcJOkZHqeofs4g8LQwNa02y8vPaFKLjhrq9fk1YzhLiiEmB08Nsyd
   AkV6bRUm1r2fUvwnGf23k9O+/pRmSVH5ASAbEtGryeGwN9pCwm3LPPFKP
   g==;
X-CSE-ConnectionGUID: Cj+XiBeHTb2Lifkj+652Sg==
X-CSE-MsgGUID: JqK5vCnQT6+VOxSxxELpVA==
X-IronPort-AV: E=Sophos;i="6.08,262,1712592000"; 
   d="scan'208";a="20658735"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jun 2024 21:43:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoOecen1JiMzMueB7fQzYvaKi7WPK/rb+2wwkOtBhFGSneAo0NT7Fr/OEqidS3REDQB2I+zpat8JQCp3lcSuIvDxxOynUyu4fxyv2TtRM6uJxm+tw5xzxhw+YxNYkCrEw2lgAXtJfLO+RB1iNu49s/Z9SeD+xVrgrsACIVAEoTgI17I/vbQWn+8UNxFEeY34vBGUSYSViE/H2/vPgQIhAm5/Gi/0okRH7I1Mw+Qxz9EjibOp5Qj1UdwD1AIUaEXZNUtwP8p2/OkbBNBOWj2DR2KfGWP7v6EBD0p9WXjmhoEhPiMWYmuR4J8tGs4+SSSTPCJulgPFLSFecegQvk8x3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbEpLl+HJYZ+TvlsFhrDpDn46IHKPdXKWL3llKyvuxQ=;
 b=bnmfSMC9ztUIsaN22iEshLbkemIu9jRvGIJg+NKnHDj4miwa/GNM4kqpYZx8q6G0IR5002sScCsn8bpghVtx85LKF/NtJBDjaeo4q8I9c4kvS9O+DuiMnbas1Jxxv5BKDHPT6I0zQvOiWBJ40tr1bSIFWzkgLxIcioZdXLiSzyEt0fpNf067wax68m62TtTkg0A0yqqCfau7qwVRJFoDiCZ53IJC2gzS4wYlADy5s0+2ojpldujycNDETQuYIvRjK3kG4Smu0f3oziyx3C2cKZGFmBQISYT1eAIq/pvilH0QPes8JQfjOX2CSwFxKSC6MDem5T4z/Cw2VA0Ia/lc1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbEpLl+HJYZ+TvlsFhrDpDn46IHKPdXKWL3llKyvuxQ=;
 b=I+Gi5BK/i2stm2MBtIsyDpnp+zNIkB2VSGElt5KZy4q1qZ43o7/1I0FfIjgJHTidJtfKgRM4wEE0SZt9gYyiDI67G2+Cu9ur23o08xt/GZ3xwE79enb3I1bF5xQpYCv7YyROxA6bbdVK0WbTc6fn1YDgN/M70AVJ5/m4cuBB3r0=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY1PR04MB9635.namprd04.prod.outlook.com (2603:10b6:a03:5b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Mon, 24 Jun
 2024 13:43:47 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%3]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 13:43:47 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: Bryan Gurney <bgurney@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>
Subject: Re: blktests dm/002 always fails for me
Thread-Topic: blktests dm/002 always fails for me
Thread-Index:
 AQHavWqPXCpPMpKn4ECcCs6HQBvzjLHGxlmAgAAB4wCAD6M9gIAAPsiAgAAsPgCAAAcWAIAAFNQAgAACDACAAAnHAA==
Date: Mon, 24 Jun 2024 13:43:47 +0000
Message-ID: <d7gabzh3ra4qrabgqco2chztktudzzayes644sgdlo2ta4dvak@ihsedf2mrqzb>
References: <ZmqrzUyLcUORPdOe@infradead.org>
 <pysa5z7udtu2rotezahzhkxjif7kc4nutl3b2f74n3qi2sp7wr@nt5morq6exph>
 <ZmvezI1KcsyE3Unl@infradead.org>
 <42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr>
 <Znkxn7LymUjD3Wac@infradead.org>
 <i4skne2yegneuyuw7nqt2mziuywjwo2p54emgba3fjcg5rflhe@dvqy65je7boc>
 <ZnlcrgxYvqqy5uoK@infradead.org>
 <lkgvrxzyxf5gpxzdb5yq5epbhhxdz72rfqnjbzg4qyi6npndsw@g6wkv5jh37wj>
 <Znlv3iR74jbi8Rc9@infradead.org>
In-Reply-To: <Znlv3iR74jbi8Rc9@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY1PR04MB9635:EE_
x-ms-office365-filtering-correlation-id: 395b3006-7401-48a0-e0d7-08dc9453ac45
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ue6ALl19njL7Pd3pPR7PuHBNsu8VmgVPEjnoOQcyaw+JMPxlfA8JCtEtnW/E?=
 =?us-ascii?Q?cKiZ10XAwqYAgI+UJdtf+sVSttdJ6pLz2ztDclxq88NYP/bfJ80mckI26bPl?=
 =?us-ascii?Q?QjaHlE6rhjvs4//Dve7NqjcxTRx87aFQdMHDfH3RDlzRW1qLTlKN+HrU706a?=
 =?us-ascii?Q?BC3gpEaGkG+Je34YDunWdFwGcJ5p1811cCWVACv2CzwFa/KsFwGAfRuobkMs?=
 =?us-ascii?Q?THV/3b2dCRv3obyQFMjnT2jGmmQRZHQci72o87Uvm4toSX7GgYKvyUZnJyLA?=
 =?us-ascii?Q?HdUKoGPgxTtU4zyVpVMuBFm29RWVDhuPIXOi8b0SzJt2/Bi6OXH86/rMSPuI?=
 =?us-ascii?Q?27Z3DJJG9ZcZV4/hDba4Bqzslexua90X293fSLWzlpfS9sRKf0qg80ekdvM6?=
 =?us-ascii?Q?SZ7P88A1KuAI6NPfSuax3td4E7dK4WDhN8A6QuMmho41z7f5ZtqRViv4H/gC?=
 =?us-ascii?Q?M75cvaKjhjUi45aqGa3QHxMzSaM5L3sn3Upm8btuXg8QtC393Qdk3FqtpSIo?=
 =?us-ascii?Q?iudhA7CAJmJ+qyzPlKtQsaMkHf0kOlAUWK7jCNbtL/qcZmkivXxGO9hkiWAD?=
 =?us-ascii?Q?A0rKjTR/QNFONjQZZc0vLkg44QMOeEQGqLH+rqKEnm14THgPP+XfG8eYSxbr?=
 =?us-ascii?Q?F+4rDiIx73bEHya1WyQ4mWYsm9dAvyEWgg15QJF2IhozPl8OQBAvr9gRMU+C?=
 =?us-ascii?Q?MIKExSH8M74d0s6Df8B2E1MWURhh9pwUDdndXfWonxZ6GyGuookaAMyB4Z+q?=
 =?us-ascii?Q?kkqEc6PU2Q2P1q1JcJ9uN72mvMZ3V240QndIcsPgRb6LT39USJpPZrzjw7vK?=
 =?us-ascii?Q?Mdd7VK2aW1dxOa/86IfXiAQGwTwnLVAbqQ5PRgDV7Z7qLcSMozVn2zJVJbz3?=
 =?us-ascii?Q?RWWECL1SUJxgvuj6C+QJ3Esxr61DBLfcE9QiAUQWR+xoam1ekafULrx/jkpt?=
 =?us-ascii?Q?upxZlK2dcDDQVDbVKkuKTkjgFwdirxz2/PgHsXRaEd3ICrMjT8N/TJ9bFc3N?=
 =?us-ascii?Q?8bhNznoaamhW77LhfsQbZV0MNu8FUvkye2l2hdUQPfKYdN/NdJ8UMHyrIkuQ?=
 =?us-ascii?Q?kHgVdGpk8h2C1ZwJ13b/smk2yraJI+bRsd8EAW3tCQiNkh8YxlYvAOGzGfH2?=
 =?us-ascii?Q?9D/28J6SEENw95AsUo5WAgFttuWRmJ+FvlhgaiG7CTm90De7uQm8vexZ0wQy?=
 =?us-ascii?Q?17qJkeBiq6oF/AV0o/+azK/Mxo5uThTbu10zPExtcq6oWW0UHiKQg1shcDH1?=
 =?us-ascii?Q?tDeXh/YV1srBBa4TJEACNwdSyTgSK+dzKhDCKiW/lPzQeLWm5vYDFFeF/XmN?=
 =?us-ascii?Q?ARZzppCkVKUM3MsNwE767UeBSa3vVa4xi/+/9WiGvIcUfyJ4mDmlzTr7G0IV?=
 =?us-ascii?Q?xk9yfrU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XPGmWEHAOy1KyLwTNUAggzIyftblQUMXwjmaI2rRDm91L/W5Dc0SGvaIR1KA?=
 =?us-ascii?Q?XonqosL2YanStmAoKTA/cWgEuwYnnj74zo9wr4JdTfbtLPTHrXRgnUo/xWao?=
 =?us-ascii?Q?cr4y9X9RLavvyiGpUTinBHky1Ybz5oGj7veKReeFSc7K4rEtuLpoe1OcuoOv?=
 =?us-ascii?Q?2/fRVAyntH4SmY1HLnL5jHTKx+j8CcUo+0ZY1uDL+XFpyRR15q5JkcYnjtFo?=
 =?us-ascii?Q?D596WhfOlr9wNHhjhaJ6WwpY46lgvHYwDTRYNeBa2VriXdczInrSxU1GNCE+?=
 =?us-ascii?Q?rwxxTKltvNJpGgIXcJkThwr6uXHu3OresFzuqvuMqRURhA1g753a/NvNgJJh?=
 =?us-ascii?Q?5hKksf2HIsxRE8czVxATR4n7jKiHUi/SO2jeTozi7l5h8ab9XkH4scLI5hd5?=
 =?us-ascii?Q?pufBg8hEfsPxpXM1WATu3g4J4DynKSzKQFBgOJZGzDU1u63gAyD7ELyTBMhg?=
 =?us-ascii?Q?SpbsYdwgws+PZ5WNxj3S8+zMQsKyI0STVWR+QKY3cvfgSOrlQF8StjfuPYhW?=
 =?us-ascii?Q?Dymp+9DX5TtQa2iKLDOyLwVdCYe8qPALigG/t1eWD8DxJ2hVKl40fXpTKkny?=
 =?us-ascii?Q?tX/Pgcc3lVxpI4dl8r3wVnViR8SOnBiHTmBRqv8mlPUcM1Zf/4G/iREBsX/A?=
 =?us-ascii?Q?+czai4asUqn6IR2WztCFTt7yK0b2ZB1UGWFIoKzQaM8RdmwZ9wUMyHJkkxnX?=
 =?us-ascii?Q?XbxxxywnS7cZd/DkBZ+lF16zF3BBgjd6lVh1ViT0uLPyjlIzsvoPCWya0NkV?=
 =?us-ascii?Q?VBXzXHmZll4B7DIFxlV7SNGe+FTaoFNWjyHkoq2Z5i7cpos6+tZOxCNKyhHq?=
 =?us-ascii?Q?vXihK3MLru6jV3CV7ob1zOXl9uRgdsexFHgE5rSSYQp4cOWFqUd/d6IxCC0z?=
 =?us-ascii?Q?VEt4xoMvJ88ASxUugNghLzSwhIcYjezZDgm9THIVveas+tCx32fSRluj3whf?=
 =?us-ascii?Q?D4EukaRV0mygg32j0aC1ev2GQeBzVSTWrRSoVZXovLc6EakNzmqYIqtbwQXr?=
 =?us-ascii?Q?IV+u9ulav57SqRxvSyWaCAbu7Fh95SYObQwcn628UZWKd0ghEn/q8g2OnDRw?=
 =?us-ascii?Q?OnfWFXBSMIV9mSUzBsEI2vpsYmIdERMjjH8NKePMIPIA9KDASAtr8tU9u3B2?=
 =?us-ascii?Q?GM8egmQmBqFYGW/GLq9nvCuntZ//0mB9H3onlT3/CtI93y5fsRGNWf2FDiXg?=
 =?us-ascii?Q?w4zAuDucnUJ9DISYV2auQoSAVc/p9Fe73jxqzsgonbC72nbnpFXxEKdJn1OS?=
 =?us-ascii?Q?4oxpHiylFjaDVD5/YasPzl7ENx7iaUfNKTcSmenW4okYquDbS0p5ZAqIEzKj?=
 =?us-ascii?Q?Yq8JWSQXtGy6sel/iSTakhIewMC74MGggiFGqS8iYxfSOZJPNYenpS96Jux0?=
 =?us-ascii?Q?zpqqsZpIvj/dOojMy3M7Tge3Qe8U3ZCCSZENM9J1gzXzyekjkYSyAto5aQMQ?=
 =?us-ascii?Q?Oe3bYmWp/Z2sF+gpQXROHZVOBWyCJFzY8N9JttmZ6JIRl2Ql7XepF4ZHSIQy?=
 =?us-ascii?Q?C16ogC+I3Z6t7dd6OxKNqsBDIqCSjd9iKDi+F6AWb2oLlFuQh2Z7oKubHSRI?=
 =?us-ascii?Q?CmbFVK1MlEJfWr061cYNFH1gvCjmEx3y9rDYv6uKky23PGI+navN++F5+Yxb?=
 =?us-ascii?Q?sRDd92hYm8l+YQ3mzd+whGk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B2023851058E5A44A32B76602CF286EE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QCAljIBblCPZIPZq7/sHFXz+ij61Z0LyCcuk7PuPbADdTT9qLAeE4oR+tV6jKm0c3aZ222qW7IUIhOsxfBVmNHLjwgOc9Kl0eIUriLaxMJuzc8ZS7Y9Pmxg2LfvE1Rqu/TXb+ZaGaINVDUmCeqeyw/PEp6aEZgZoHYxq8Ny0/nVDujunSca6r+k/Pf3hGFj0iC1+nrcsK8sq+Yyc6EVNF4D12+juDHj+wJWrgNLdSC3M0iEt177HGIAcI5wT9eWkZxGU5Qj6kKeSV45MEb9uTrAqiKpyNv3NbXtcavu5Kh34XialAIHEpLYcF+Rxbocd9WIy+W6pG5Mej1tlSG2VOMlOcWkk4j81Vp9kjEvsoKSIuFGRPYshKkdcZL/Li295eCYqPSBBdKC/qWHcTNK6ow38v6XnE0/8jOhrMOHFg85K6fuoxoSefDqmFTiX12uOsbhVc0rWgcwwcnwvzAkcDaeE4Yb+HOLlSfY4pmaRUi54L+93c/Yeod70cF1jWs2AyDUthg2myy3ULZzLa0tmW4KCKJyrXdl3qe33uguk8FlI0nQYjaG3C4iqttj9Nw5uvwQ7pN2JqrzJhiz90ryGiCRmLayitjSlCBoLRKSNA4JlVQVl7D2UvUavjL9O2UKw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395b3006-7401-48a0-e0d7-08dc9453ac45
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 13:43:47.2822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IQ/y17ZJKP8ODoC6zF/7px0HUzUivWNo6vX92wLiPXeTBnJz9KKchOsVPu2W8sqyl/E+sd1pn6NmekrNfd5J6CoPXw3JMVrZb1iacMdickQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9635

On Jun 24, 2024 / 06:08, hch@infradead.org wrote:
> Yes, it is a 4k block size device.  With your patch the test passes
> fine.

Thank you very much! Will post the formal fix patch tomorrow.
