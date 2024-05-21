Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34A5219ED
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 05:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716268651; cv=fail; b=jTM8uQyTXoJKGmG2tpHQjJqstS8nntWqrsxTaWiRHJXYkNPdYQsXNHbjulUmitMOf2HkFRFDXJ/uRcywYFxkOf6/Yc0FrPC0lvdyZmxfuvorCBaUhT09zSl54oxuAUZpkCD5LrSn4QSIURTkHaq+zosMAs3oLS0uMsB7YamPZAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716268651; c=relaxed/simple;
	bh=8Ah/GREQtfdwFzH3LrmQncfSPJ5rwOx3DiTutvT10NQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pyaj0BpLu50aXQZaa1Rq9br0HamYBTFZzfex571K7FSMIUHOOrHPBwd19SvWzMWUyAF8MxSGO1NiAe8/CDu9U0UXwS7sL6QCh7jqCURLxE5ztoZCb1wLPpi8Y+Wc4B52FEQy3ql+IerefrxmTb3ruWX1Ri11aRmwPg73ExSnAEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=amaYr7N3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cMc036O8; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="amaYr7N3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cMc036O8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716268649; x=1747804649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8Ah/GREQtfdwFzH3LrmQncfSPJ5rwOx3DiTutvT10NQ=;
  b=amaYr7N3oy6saDD8MlpApx7Ms8e8byBS2m6QfD4e11RgXlin23F5ympZ
   YRAg+Q5cWt3E7Aew2VmXguXQVFp+pPG85Qeoh0GGaIo+/Ou0qPFyCqzHz
   93VITiVAmIg0pl59I38rcCwSfX/gWCfO2XizSyD3gl98Lgefv2pFGBlQY
   3c8L3vAxC0hoOuSBxmc/fBXMMWpUDcCn56sluNp+TChIG1HJbV1amSAD9
   lCbl9DYhPDHZbHbaKTEcFIaRYDZlOUnQDz1X5C/751RbupP8DSgrYD/C1
   dvuIt2zozaOrgcELJ3UOibpH7Tj4v47qoUYqx57hXKhllzyYBAdcCBAXC
   Q==;
X-CSE-ConnectionGUID: HBnjpPa1Q2Ws73/KdN7IYA==
X-CSE-MsgGUID: O3l0TeEOTaWA7uNG1/rZ3w==
X-IronPort-AV: E=Sophos;i="6.08,176,1712592000"; 
   d="scan'208";a="16877000"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 21 May 2024 13:16:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N//hjzWOXXNUlOwh73jWkx3pydD5cDMQ2touDE2BNPdjyncnsHlMjLRv9HY6z1BdRcf6T2z4VSJbrmo30iVjy2oDwgCrq2akbqP/BOiKg3FYG51CM8vctbJWTgGs9AY8W0w18g81K+aYYTgDEsPyLoGPDM7xyJKzeIv0EEUhOvZtSOMaACsAKLhpJ+EpUdPU1BGvppgYcqk3qHVGw4mznU3b7bYH6VkpseCJLkAS3BekF/nk6wWxAaVkdfO2jwZwuS4d7IQOdixmbra8MIYhLuAHloWo4+TgBMftqJPv3DB8lruzvIJy+eMm8BRXG3vL6LyTS3V+IiPtI09cuM2llw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muYPDn2LhpBU58vPuy78tkP9Szoq/WKTuYkje7U27/8=;
 b=g8nWYHHLYmsH61hcqoZlQe61AnaWQhotfMB5h3qChLKNy6hwUuj+Fs1MEkOWJsqh/cMZutiRcsi7oKxDh8QasHrqq3ldv6tuTwFKE2vTxD9cQigp6eBsmjBo7XKowFFC7tfm0fWhQ5rYkPNTpF1scYcSjuGSj7r18nyRdPA1trMBYIXTrvjmdEquq2QJj5UJG32nsMSIAgJGXEXJX++Ty9W000BlFNq7H86RBNR9IeEnMZ9DF6dq+t4GuuSBvmskWf8jvgdhNWqXQ6HyFD2XCzuGdfmS1SzQMdn9/hLSgTjWagngutHDIzlxKybFNF4ewVDwdd+5z2JKvjjLCGJxgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muYPDn2LhpBU58vPuy78tkP9Szoq/WKTuYkje7U27/8=;
 b=cMc036O8CNHA6yCJLQGxhSHbzlJLVIh9wYBwqfPGHaJXkkvkUiymPOHX+ztJks/Qg7c7JOlyNRcEDGhFiOc7ny7RDS4Vai8J4dVlLvSCPeGUCET3S6GvfeFbnDVI7VdIcyqEHw0GRU+cfoI0M4uer+13XJR2OgDgDHg6QLg2nL0=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH2PR04MB6936.namprd04.prod.outlook.com (2603:10b6:610:a2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.36; Tue, 21 May 2024 05:16:19 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f%3]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 05:16:19 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Bryan Gurney <bgurney@redhat.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "snitzer@kernel.org"
	<snitzer@kernel.org>
Subject: Re: [PATCH] tests/dm: add dm-dust general functionality test
Thread-Topic: [PATCH] tests/dm: add dm-dust general functionality test
Thread-Index: AQHaqs6ZWevFxwsTIUei2Iy08nz1PLGhJmaA
Date: Tue, 21 May 2024 05:16:19 +0000
Message-ID: <2yvdxcpid6rvi2us3z3hxxgeyvp3zfv4cgqxkd2rubp3rohmoj@6gvleke7iae2>
References: <20240520155826.23446-1-bgurney@redhat.com>
In-Reply-To: <20240520155826.23446-1-bgurney@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH2PR04MB6936:EE_
x-ms-office365-filtering-correlation-id: 254e48b2-4aba-4c3c-4484-08dc795525b5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?HoI8AblGPe4xfsm+3VUE4QQaJ8Oqt4oFaYpDHMN0N9TguX4gWyin6BtlRzRo?=
 =?us-ascii?Q?GeDQwcFcqf3Dq5FS7/UxmExd1fDAvrh49KDxaZ9Tp/DzfJjoKVKtXAtR9PLD?=
 =?us-ascii?Q?CVEdRjpZGj8stjiJiZbvpMpqyssBYDQcMlxhRnpUVvXgboTqQwICsK8S7Fr1?=
 =?us-ascii?Q?ajMRoDUC3w+NDYtMcehZqZZbnBorrRJi9fn7RM+sYLgSi8AA/JPT0Gbo1Jsp?=
 =?us-ascii?Q?m40L1Ap7b+ab0FIJPO4UC9xZMEFvsUosqORGmhE8Ryw2kqO3azFv2yVFiIWb?=
 =?us-ascii?Q?XlGpQa4hjomnN5FyEGtnhX75UlZkDHaOr/ESO1W2J7aD49ypavsulbiJl0Py?=
 =?us-ascii?Q?675jTzhmsy9vfvXqyz8IKkVGl3hif8v/Okfq1c6r5lwsa6gX5Y8CQyC6JMRM?=
 =?us-ascii?Q?7mkbge5GF6/2Tv/QEx2qXr6NiojXEh31H5iIigKkQWj919r81ktTrW+/4g/O?=
 =?us-ascii?Q?mVwipsIexz+oBAcSZph85O/wSsPDK8hjkeUARmkm0gwen/K5uNzHqgu/Z04Q?=
 =?us-ascii?Q?9VRF4RkN+lm+SeJgf7tIan44YV3bQqkHhAjraio1ezUyzbMvqxqzK/ja4HBt?=
 =?us-ascii?Q?reQcZ5E3+mfkyoE8Bz2buLUEuQkRcHsMHnqlspmyr5VBa/QjTk7KRFPmAaXP?=
 =?us-ascii?Q?SAZWWgtO9acOuVr911npOw1Q/MGbBXnE4GOqljrr5jmhrYmPy0qJzsFtXmNV?=
 =?us-ascii?Q?X+O5MPyImgaUz89rMvF1iEmGCPmAyBTZK1yOBk3SR+GUWk7VpEVq4W7sXZ+V?=
 =?us-ascii?Q?YFKUnuu8CFrj9/NVJngFDAw7hV7/30vRo/0UBnG+e4kd/HsO/9ZP+pOOYLol?=
 =?us-ascii?Q?iR1Ab0z9T4vE1HRaKELzVgXB4nNeaOaKaK1dmLxC0JP7cr98VVXLJ6XFOhox?=
 =?us-ascii?Q?0RqLBFOWTCByC7peghSs2SjlL7g8aMMhz3AE1NCUR38W8TQK71zUscecvXGt?=
 =?us-ascii?Q?f9KD1voRoMFEvu6BbZLISU35GL2QCroTGiW51JKz5jJnh4yIKakBqgftyKD0?=
 =?us-ascii?Q?gzdtifmZGi5RelSukQkU5UbU62xrZcOuDNavyZxLh0wbG28+3isb6EcumDxf?=
 =?us-ascii?Q?It2HWvf2NSHVYbrHOV0VimC24Hi1MIxjkHD1XG4bge7//ZBdAMxD0NpyOR4Z?=
 =?us-ascii?Q?7K75107Y4F/OC2VGwrmfM1pyJ2EQbRzPxDSmRPaMQ+lnEWUTSzfLVAvSWZt/?=
 =?us-ascii?Q?sUriTUJ9E0QtqqLqh6ZxKlKBoglmzPTPLRZqVOUEHqJ68rytfq8X+lGZEOmx?=
 =?us-ascii?Q?IoRVSVlhf0l4qEzi3ZvScR2YPqP7MSLfmgj53uLeimiOvoXuMgNrX8P7CHJm?=
 =?us-ascii?Q?rw2pfuldLuY42rUvuntYybNH7qDy3vxEEbuiDHYH6GO09A=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?iVAEcAXm3I4kjx5IZebhNHvPaqnIAUFDw6w82MTPcyLP+Ujx6Bs+nWuKUOp2?=
 =?us-ascii?Q?WdPctEjmx+4Ljh4f59FgWvUlgVpKz4irOX3hJ/wgawdIWer/yylc5Mk8mOvs?=
 =?us-ascii?Q?4DRLftMp0VJmMVozPBEHSovvomHI+DmT4SWMpQ1+OnXI9BdaAEo7n6WGJB06?=
 =?us-ascii?Q?VipZHAIHfUQxI7DiT/ztA6jGkkXe8ffkUtWeyyBnNHkdeZKGhes0opzcCgCy?=
 =?us-ascii?Q?lS1gxX7dDbBQ3ZV7SkEB9BDkLWZy0C/5qqKh4UYb/PID5o2kzGLxjWwZxA9Y?=
 =?us-ascii?Q?Nh9hZ7DvF/MqchIivYxhfwySr3JnoqLwzBrrgf3yoL4fI2Buir+crn01h4LO?=
 =?us-ascii?Q?qCZ/0mqsPeT+HQcs9ZjJ0b3fDCyUrZzJsllwxZKfxla6GFFBD/vE9gj+TuXV?=
 =?us-ascii?Q?c6JVPBpMsS5Pf9j22SFR1fTRKTID14JTR9gVH40aMcqSJWxi2SIm+vj1XFNL?=
 =?us-ascii?Q?zZX1yLpY+4ayHYksl+VFtA6EHuoRloSnApJyWjd027Lve6dYxSbl4mWAuq8j?=
 =?us-ascii?Q?5um1BE/coB2keitSL2Tj5A7IsCo5Fl3oEHDePVnjX+wf8elHsd1SL6/Dy4hV?=
 =?us-ascii?Q?mvOvg2X5JILzCgt37hlCpt3Dp0Hf2EK0H1rQIr44GEKXYnggJO7EjfyBdo9L?=
 =?us-ascii?Q?lfJCkYMAkiSVPCsvz1rcx1yU7myy96fNyYkSUj8f7A+E4k6M7igP7sz2okNz?=
 =?us-ascii?Q?WqC/llHQ7f8TDe9tJ6iLE+d0eZZUs0PSz2kahowlvqffDaLDlzxUnV59hLvM?=
 =?us-ascii?Q?5qEMYC6j3XlX1M+ZALgaalHviynuNKI26Qlv+5U5AcACsMKfYTG11dbf2QnK?=
 =?us-ascii?Q?ta3omV3+n6wiKZnkJIk6NtMIMrcmNcXvTdRwU46SfLrKECETbOW3SqG4GCpm?=
 =?us-ascii?Q?itH0xnYUkQiPx9aVxK9XGe1rP0gyQwbRvWpFyIx9w2Jii2VLN/ZmwVXfHQkh?=
 =?us-ascii?Q?Nhr90h7+2DwdSulvz78VLDOj0rNs3JIVi1NBmSMOz18y9wZLn/FPdd6FO0YM?=
 =?us-ascii?Q?Oi+Y4gWtQPZ0pDuEgW/RmRVGFLRgYwIbNfAYP7J0KQojJj6ZISlPg0B4F1Yz?=
 =?us-ascii?Q?2RyVdqv2NkQg1R65/wAWN/b2Ye3suVHuUsx87o9K6QIRM68JhwXwIiyUsKTF?=
 =?us-ascii?Q?YECbuyFIPePkN5dFrap4vQzLy/hDv/c1tmHITdA7XXWmDg6n37faIcZDsrnm?=
 =?us-ascii?Q?H3dsUhn4RO3NqWvqezDR31nYaN5HtuwI8q9deB0RXWMtuXFtW4vcqpDKPR+1?=
 =?us-ascii?Q?372rKqKQoLt1G+lWbz/h6yVnIdWPnJj8a5clmAnlmhM9JloYIz/MDy9xSLMb?=
 =?us-ascii?Q?kvvdosxO4Hug6ZytZVW3IzWdxMb98XWVkfoz1QeL5K9IQpzaFhWP0VYu0SAG?=
 =?us-ascii?Q?HkQ3Ex3sWjGgDF+8llY3FIqLtr3fBldRyTzobQtbs/Rid1NwU27sDwYmHL1K?=
 =?us-ascii?Q?jCMH/vb1XnyqDVdFQm+UdlqK5Bf128Vx9GbHc3TqHWxTjOHQD09Ri1Cw7rNu?=
 =?us-ascii?Q?jzkxIynhHo4/nTWWVA2cDSMGxAnEN36EeKl4MoThxHl52EqvdND07ATi1n69?=
 =?us-ascii?Q?pbTj7idh0v64q6jXrokR66XfXEBJ+rtGaV7nGgwsMMtCVAwJc1U6P+pP7lm6?=
 =?us-ascii?Q?idymjj+7LIAW/qMTdwecNTE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <33AD049D7B756A4AAC03C8721863ACAA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ol4fVBr+2z9nOwwfPSum22r/9UMrKl15eXn6/X7f+K8me7JWZ/kdK+g8NupRFj6vzO+Z0619aVQMiddQvWFPC5ytT/p1Iz4IT3ge1CgE2jq42YK0sdjidMbClEK7kpQvTx04QqmRSl6lwqXn9FXmYAx0ilvCgVm3J6epafjqTt1zVpw+z+F6+uoI+BFXcrFOOLZ2aSPzF6ISOeCrDygZHm9VtQJsh8vKkYBnUXdvoevEWsJDAeRT7zEpDU4vnfdZImTzY66fbxeGdMSvwtp3nc9CjfOTNjjWg4n6ttCYC3g10mvoxHWWC4XCCqVaIKDHhW+XKiKSkEE/pyclmyYr/bfwGYnXNezptyIQISETkmTCx7/cvvN4+1CkMXkToVrWtWrEubUXU1I6+AUFlvy3cmSwxiLDkWigx5SIZ0MJZoI0Y4F4/w3Ew3dFGCEgQpHuqX3/V8Wg9FDvlXDjOmUPrTs9/AZf1v+x1cEitckg18unVP3O4x0X0i+AT6jdSj+/XFifJWxFBz64kfI/KYTgCcZrXanDFU45PDeW31taiNnfv/hPufiLNiKzTC/ZjBIXFPMI7uF4EHr+/J1rwbuSyeK4RE0fjCiQxxEEiVq8Ve75Ln1KZdZjBcg7dI92rmtu
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254e48b2-4aba-4c3c-4484-08dc795525b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2024 05:16:19.1463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hgeKCxpcFhWLK7Y5G5Ilex85HWT8aEJVI/KmuADG4VCV384Qki7uLl1X3y8GF5XmNGl2upDbISadyoDkIVKjjMqwMxv2Dau7h6R9MN5Ats=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6936

On May 20, 2024 / 11:58, Bryan Gurney wrote:
> Add a general functionality test for the dm-dust device-mapper test
> target.  Test the addition of bad blocks, and the clearing of bad
> blocks after a write is performed to the test device.
>=20
> Signed-off-by: Bryan Gurney <bgurney@redhat.com>

Hi Bryan, thank you for this blktests patch. It looks good to me. I ran the
the new test case on my test node and result looks good too :)

Before applying it, I will leave it for several days in case anyone have so=
me
more comments.=
