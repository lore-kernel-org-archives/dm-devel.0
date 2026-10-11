Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5DC7E792;
	Sun, 11 Oct 2026 09:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711351; cv=fail; b=AP3DhTX8erVcBQ38K2S/C6jsNlhRlEoXnirmehO8I9ASCkgHg6833tCRpw4BvCoOutqrUZedNLJbK2oFPtHebtp+BAdRNoXVI+gw+gTroziFniJ76hjtFA6/hlYjMH8otdvmfCaKTiLEqfPCdh9wACZycpWJQt7rmcihN/YDg0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711351; c=relaxed/simple;
	bh=iK7ZtVlZ5/+eKgYG+KLP/Ya1S8Q8idG7lGzAFm1oFPs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hROdAUek/3WVboTeRPLJ0RGOTvkDUpJyW1BYPelGvsVCbU1Hy1eEZciltPhzSio7e9xFh/M0fy+X4OuHaEQY2RnJz3VlUBoEu6WSQPViHt54Ick/4R+iLU1VGF3OoLSuvvVkNnklHykaOTU8Ip4oK89MiWwwvAe9K/yS0CWb/wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uT3pobpC; arc=fail smtp.client-ip=40.93.198.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uT3pobpC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jAJNI7zGxtekGkUYFcul46YQXKmOabUp8tlm+43IsWnHD8xafSp4WfPCA3/uhFqMdWB7qeUmDYv6exnLcwJC9ZC4EnSuDIbp7ZxdABNe60K7FrPGjfsJiamEQ6EfKy0WSt+5TOV/P3jHJV2efDCgfeNplxxfwnJvri+f8uvdwbfeoap9/0J3iIfnti+E/SwTySv9IPw4SXsCzPQruhlmI4KRYUmB/DZjtX1ekbNPYjmsprAZnapq9TUKY0lmUO0ReAyMM+lQW2nZQ8wLhf9d0TwCN7ZgL7TdUcAXnw3gQzPTVpD4KT/lsEyz/z1PoVECGFdqk4mefWYiSW+tgg7e0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iK7ZtVlZ5/+eKgYG+KLP/Ya1S8Q8idG7lGzAFm1oFPs=;
 b=uOAkKZkpX8Ae89EaBWfOf1sbjm9GheozAyHUnr9ykWnQIIdl3sNMlwTfIhGAVXV+obbDWaqjG3+iAHdI/Xa+aAji9G80B2Xtdg7k2djMtwTn6uS0PIs/3D8a2HtVcV/81CtDfVsdFapa0b2O/GBhi1V3+9G9uzFfV92PTz7lG8BntneKmrZFAfZf58T/R6CNCU+gGoSgwgMwsuEywRFdcE9Tvgsh7EuSlTj8xPO9VIOJbbqFmRwnXTLt1pgESxl2PedQq71Vk0hWNTVIy5n2r1BHAjHdFx1KInTHuWzIdRlOeuQphSV8C5V0z4/k+s0+zUcJg/Ff2BPA15LwsOaniw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iK7ZtVlZ5/+eKgYG+KLP/Ya1S8Q8idG7lGzAFm1oFPs=;
 b=uT3pobpCMVyISM2FYJbxMYARRpbIw1D16VoERWgTIfB9DK9vJM/fG60F7HCjeYfgxhX5UBykMerbKGNKnK/ZB9jXIx/eqvetCSZZmxV+Hm2z4gDPyB2HTaI26IRWWf1J0MsYGjAEvTIeGuLa2JvdL4CYAQ6OS4fmEGrF23IsNDcPIV8KeOHwOFtGu0bLpmh9CW6PG1YhlJJ72iXpjAo4ZQ3tpXinsjmniSAmcUnY+8dQsKblyRDotSPAaWQt4fT8Tv7QXn5CL9uy908hhekOxZmSL2DdamX5zws8TEP4WDaFgpxJsbSV7iqrN6XnqEfyWh2vUC3mdC9k3qk/O4+szg==
Received: from DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) by
 BL1PR12MB5899.namprd12.prod.outlook.com (2603:10b6:208:397::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Sun, 11 Oct
 2026 09:35:44 +0000
Received: from DM4PR12MB6136.namprd12.prod.outlook.com
 ([fe80::75c4:de57:e254:243a]) by DM4PR12MB6136.namprd12.prod.outlook.com
 ([fe80::75c4:de57:e254:243a%6]) with mapi id 15.21.0496.018; Sun, 11 Oct 2026
 09:35:43 +0000
From: Manuel Huber <manuelh@nvidia.com>
To: Andrew Halaney <andrew@amutable.com>, "bot+bpf-ci@kernel.org"
	<bot+bpf-ci@kernel.org>
CC: "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>,
	"agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org" <snitzer@kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>, "bmarzins@redhat.com"
	<bmarzins@redhat.com>, "dhowells@redhat.com" <dhowells@redhat.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "paul@paul-moore.com"
	<paul@paul-moore.com>, "jmorris@namei.org" <jmorris@namei.org>,
	"serge@hallyn.com" <serge@hallyn.com>, "ebiggers@kernel.org"
	<ebiggers@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "corbet@lwn.net"
	<corbet@lwn.net>, "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "keyrings@vger.kernel.org"
	<keyrings@vger.kernel.org>, "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "fsverity@lists.linux.dev" <fsverity@lists.linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "brauner@kernel.org"
	<brauner@kernel.org>, "martin.lau@kernel.org" <martin.lau@kernel.org>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "mason@kernel.org" <mason@kernel.org>,
	"ihor.solodrai@linux.dev" <ihor.solodrai@linux.dev>, Fan Wu
	<wufan@kernel.org>
Subject: Re: [PATCH bpf-next v2 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Thread-Topic: [PATCH bpf-next v2 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Thread-Index: AQFA8w+2C5zyX59jlDtLuO4vqcUrcQHtTXNaAg0PIQi4EQlHsA==
Date: Sun, 11 Oct 2026 09:35:43 +0000
Message-ID:
 <DM4PR12MB61364B4F81AE7A8D1FB71E1BDE902@DM4PR12MB6136.namprd12.prod.outlook.com>
References:
 <20261008-ajhalaney-dmverity-key-identifier-v2-1-008456d189cb@amutable.com>
 <910460850fd4163dadb804fbdf6c17f6a9dfec060f4d865a17df87336ea3e165@mail.kernel.org>
 <asgQxTE-6YtEgvYZ@toolbx>
In-Reply-To: <asgQxTE-6YtEgvYZ@toolbx>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB6136:EE_|BL1PR12MB5899:EE_
x-ms-office365-filtering-correlation-id: c99ab713-d20e-4997-fbd4-08df277b0573
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003|38070700021;
x-microsoft-antispam-message-info:
 PRs500bxM3NxZCkCdDr6SkNC0YnwV28TQrsqeh3oDBKFcMdhsOg6Ui6CwWBlCYiwpPvXc3M79/MKI5+VAmzCKCohyNDR2JklmKYLYqVvBXcZjDkGUVdmsAREw34lfL/vx33pKK+pEcP2AGFOsfKpIDWY+MNoGRy7Ikd3FLQ2SSfhq0TY+HXzjQJnLEYQhnLl+VOjfElfpBubWRKyt/s/6AGHrq2XHuOW6CUVXoMFJWNbb53rTE2HRiZSWhau8ra0wG1twgkLLFHUMzR2hRwQgNnLwKz7yhGz8BX5vFP639qFu7ezmWPiB2N5k+xp8qOxAc2Don6Z2ia0kh5uVBspVQlAHgKD88zVEdz16avVe7CLLykTG4OwPZKg5lDK3UVmARhoFfPw7JBOEaaxrjn9Mw2o7kqlsCxYoodXNDEhVnxGYQcUwgJ20TTrGKngR1zKTYDyw3EPdpFhcVdKPDyjZPweZrAKub5Ft/284jWQfZdIjRdxVU7yzfBIj/V7qKdlFPXJKDA0XzlGotZPLMq6e7JlT5GhBbEUrdXqr7rvueaXmyoSDH2gCRj+OPX47fovkSrEyYXj0QqCzNivvoKpFwmFt1ADglhmKvTlxdrbTPmwqR6w+3aZ7xehztvOeaBL0Pl7wUM/Kliwr2i2Bb5w2WiiLgN5fcb25hu0B0SGMq8S8i5809vVvrhPSjWpPLboes9Vi+CNBwsdjJ9s2SsGLMTu8VuncSuHxKfC4TiaH5c=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6136.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?jiS1KVes5yntX9+lEatHLw0Mv5/PrqzyYtSU6u4lDXziYGN0cIBFSEel9sj7?=
 =?us-ascii?Q?7yN6RuqpvGe4e+8NMFCQJWgzsQjrELkRCqMqjzLuqln8MesvVc31nRNjXtC/?=
 =?us-ascii?Q?N/T8yfQ7TnIHW0i7jYD9nGuSc0Mzxx7KbdvXnIikf8cKfu88aaToiWEfJrPO?=
 =?us-ascii?Q?LQ7eEoXHefRoshu0G03+wSCehK0I8Ll7Y50hZ6ZNsgPjEvZdMMxjJJ65cRU0?=
 =?us-ascii?Q?5i14WaGqDsacaTJe6NlPT9N+M0NzWpl2mH0rLu4MSHyUmtpyT1QtFHC4w5nd?=
 =?us-ascii?Q?a40pqecAWqxJPnwPjWcKyTM/1vOl67g+kg9gkbgFlknNELg5I6qP6/W225Hf?=
 =?us-ascii?Q?cV0AMnmB/Gg0TsUsBap+br5STYYK8STxwOJTkMSOtuD93R9cou0oEJwoL4wH?=
 =?us-ascii?Q?sPEzAbKWCCEXOUKOtwHmWYR31mzb7onxiYn4hJCj4cXtF2Ac+YN5SrpVRSGw?=
 =?us-ascii?Q?gNi7G5KofyN1umjw9mNY8767YbM4hvBJJCiuDY/Q4OPQKS6L7U+Z0L1hSxpJ?=
 =?us-ascii?Q?jzh3eDVkXTCGi8CU5USNOVOP9J/AmdxbdXvyiJ6bWlgqSN5tcbP0TgZlDohn?=
 =?us-ascii?Q?fhkMq+F8scjRZbxQlaCyqXmD2L/VBVRFbzilwkVmj8AFQPaIBf/AODzFpFFn?=
 =?us-ascii?Q?C+EYJWnmMu8COiR51gqXGs0jOvplsoxpMHBRMU7o7ywwgWEcFg2akwpukveQ?=
 =?us-ascii?Q?xAF0WOwdRTGgCcT73/FRrxJY7Za0dtYj+EZDIC7kzESf2A86PkGJf9kJDcOE?=
 =?us-ascii?Q?Q8P4x0ItE9nnEp0iKVlfm+VB+DOv3GAwc1db38GeIH2vQ+gxjSG7J9PWzS5J?=
 =?us-ascii?Q?MqVsUkJlbNAIrNDIQwF8yYsa4wy5u9sdX26LHV+yRlGiM+vvpQXR9a7FzMvA?=
 =?us-ascii?Q?MX7PkEdVnph2dx5Qj/iVnaMdBFQzLCIXQfRpAEH0+Zu9zhHrhtM+nPpX8dMI?=
 =?us-ascii?Q?Nv6GE/YIZtFy3rPdqgvl2W8q77sPZRFD5TbODw8jWHGRhoSofULM7GyVtCSE?=
 =?us-ascii?Q?nEZ0CEHBEQi8ltDcdErMttBz7db6CzQvKJLkIvmBEVlPwRLel3GZrPxMpM3V?=
 =?us-ascii?Q?0ZyBlWRGVJHn8K3M+abLVx/c9XV8IAh2MV9HQbQpa6vtd3J0E2L/SqNilTzw?=
 =?us-ascii?Q?hcV3AHZE8FbSYIBUJwvFCdT61Ng2H/+OSB3qzENSyih6jkxy48apmVZMe7ZL?=
 =?us-ascii?Q?anfWTARibbNdkRpT+2EHG0tEHYUh3glI/IOpRinkrNuqKRpfi69TNyl5+c0d?=
 =?us-ascii?Q?WRpLz3cFowVyoUW5F1To9bslb7SUdwmFexwnAnAHzjxhn3dcdEqwoCxMk9R+?=
 =?us-ascii?Q?KJERWoiSXkdI40FRKfwhtNg56F3Xw7CQm8IKoivaIkRFf0wBFGo9skucEDEX?=
 =?us-ascii?Q?Fw2iaW9YbNw0umjJ5MGvEFA8NHG3QkoJ6xZr22vZQoxoKLhPb/aivC1zW+n+?=
 =?us-ascii?Q?mrZVJ6hrBcipWO70Xwtn6krax/IMkkEUumYO3hK0RB9U8DmnO+8/464cQ5jw?=
 =?us-ascii?Q?Nz7DfNAx29/TwFJlFXtd2X1KBemhW9jbA33j1aG368nlqFrdE4WGTM5guprh?=
 =?us-ascii?Q?Ln5WPTtPkEYpni9zZwZ6G9Gjo/Imlz4nWNQ17MfFy9bLYM43xylIQzZCG3pi?=
 =?us-ascii?Q?bZnmyrqbAyRGI8IvklaH9HvbqLFHbTo/PkDvzLHN0u0PLxV4GUeWPbwt6TdR?=
 =?us-ascii?Q?xehdLDvwkWAmZCXq5G3Apu/6pt1rio+azc3D/O+uiJrZAkdH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6136.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99ab713-d20e-4997-fbd4-08df277b0573
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2026 09:35:43.5474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1xq2aH5Cit0Q4+wXuGQYfdbAbfOiuDDem7WcQ2OPeVWzHyXb1mweCpPweRPPvWHcIJZ8+YgCQSbabY+yQV5MrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5899

On Thu, Oct 08, 2026 at 02:57:00PM -0700, Andrew Halaney wrote:
> With the BPF keyring ID already being merged here in bpf-next, plus
> Jarkko's feedback/RB, I continued following the current pattern instead
> of walking back the BPF keyring ID, and dealing with the
> builtin/module/rodata differences I alluded to that would make that
> approach a little more annoying (at least with how I thought it thru).

Another data point for this design choice: after initial discussions
with Fan Wu, I am about to propose a dedicated .ipe keyring for IPE
policy-signature verification. The keyring would be exposed to
userspace so that a trusted entity can provision keys, modeled after
the .dm-verity keyring.

I do not want to introduce churn to this discussion. I am happy to
establish the reserved ID range and generic registration interface
upon proposing my changeset, to establish this separately, or to
follow any other suggestions. Getting guidance for this subject ahead
of time for the case where 'yet another keyring' is introduced would be
highly appreciated.
