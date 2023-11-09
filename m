Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2084.outbound.protection.outlook.com [40.107.103.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A9136AFE
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 19:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bJIKrI1e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3EXwMp0oA7HCXhB31PoevBUMlA/OdCrJIf7+xOsynVF0P4GgwfWMN5WtvBifvkLiyiTjRj3DR7cs06l/blsk6DZ3WVGQTVXphINKLG/Rz5zhRcsTPpgxdx71YRvTfTX1xLoA5lQ8PAHatPADi60SNX6kUJpkaJ+pjPjoF/0m5xFiyi0oVdWcL6zOLQKEZncjEViw/ScdbIKlurDeTCnxofqMespXSrzE3EJo+AyurCDOR07tJr7yNyb7Ngc1zqTyy8Hk79+NtexH5RQVTB+4xGk3mEYc7xJAc5eY/dQEAicRFvw+yCdEKuXzVvEbytfoxuD6z3KvjoX7+E0NtPotQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4u003cQbqTkBlFRs5+Ycv6cU9As4Kb+TnbfhJhl2vEc=;
 b=NR4Wy42oaXKkDqmKImHn2yCqaeEJchE1nm3bZT6pGHWfpwAd9xzvEsmcX4WuhkM69XhqoqtSSVS5V5cbxblmgRas6Z3hvHB+29rGIYSFbv9ANQjJBhIVPB2BGvrGwyqqAJZGF28U+wQLztdYFKmXM5yFc7I7Pzrre3AEig4y3MtA35HrjIDqPFp0QSkoFAeBk2DrSCGAw/M47YfeK5b5P1kzkX8XemORHx1G10AXWtQseXLT9HvA/Bp0ezqieqreL2UVdHsSLBDxWJehkegUce76faf1RJqIymjhpCgqtzx8z9wabf+dcmY1aIx2ZJOA1q1P+R5SgWIgnXwjkCkqmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4u003cQbqTkBlFRs5+Ycv6cU9As4Kb+TnbfhJhl2vEc=;
 b=bJIKrI1e/W0oabZftHEAcJwQnvs4HrIa9uL8oyKDdZguVyZjhh4a1qKa1WYYhoknXcDlTev98FkanQ8TVwSBJapTMP0y73ZytlopAeTRUtOcWi+GjppLthwmL9xnhHr9QXYNmxBfoRksL6dnJQbPxZgHiaJqiM/u7iDtac1PpdcwGyYQK2Xk3k1j2965Ub15QAtyrft4gtNH75Z0bxg0luH8KLOurY3L2M+HPzq8T7ObzHMYP/1N4YNj8IhTIrK9V0jaAnpzlw1LTbx6bpXnSA1qBb6b+7ZvYQhJCL0BLlk+Mv/dlySwHhEY7EFuDUp5Ruklo8f8/ldaFwgkTRpGLA==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by DU2PR04MB9521.eurprd04.prod.outlook.com (2603:10a6:10:2f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.7; Thu, 9 Nov
 2023 19:46:49 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Thu, 9 Nov 2023
 19:46:49 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/7] libmultipath: Add max_retries config option
Thread-Topic: [PATCH 1/7] libmultipath: Add max_retries config option
Thread-Index: AQHaDdoOZRSHWsemRkaW+Xn4xoVS/7BwlueAgABtqQCAALgJgIAAi30AgAAnKIA=
Date: Thu, 9 Nov 2023 19:46:49 +0000
Message-ID: <a2cd19b130926f95075faea594a95ec54343f8ba.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-2-bmarzins@redhat.com>
	 <e704003e124116e72771d2b7ef90ca66ef242e1c.camel@suse.com>
	 <ZUwG6iJU1xZ/S8WS@bmarzins-01.fast.rdu2.eng.redhat.com>
	 <4eb3625118838c31b4348c24f0712665b9a05109.camel@suse.com>
	 <ZU0WTmeqxb+vKRaf@bmarzins-01.fast.rdu2.eng.redhat.com>
In-Reply-To: <ZU0WTmeqxb+vKRaf@bmarzins-01.fast.rdu2.eng.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|DU2PR04MB9521:EE_
x-ms-office365-filtering-correlation-id: d42fb487-2e5c-4112-414d-08dbe15c9d22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 h5yRHepNbrxXcPW0w4HrhOauVGOlqpJowUoaCqoma0Fk4ZQYaSP4/EHBQiU61464m252Om3ji951iJunVkE+NqEkmLilYdv+ZafgjepFj1jW7OSVozkkzkqVBYVyxqFZCyq8WzRb1bmTYAEXi50kirH1042N6KrGpVQbml5SRcPAfVbAZmhW2rBky9WyY7pMLyrCxB8yj84FzfnDdTdFFzMSgiY1fMjEyLdL1kITk5v1Stqx+4Xp8wABlBOPfFzPl19cj+KJjIEvk0L+PPZnDiIFb1oas1pvpdHDQ/kHcYlzhd1YKllXG3TpWDvmN/lMX65N7WFlZpj5sBc1fidqXih3JPMHUANMVh5rFDnP/voOUzzDE2QjNf/Ess25oghjt8iowzxRbDuFag3ehwGgtEhLt8WzPr22WTmHVwEldOFz0FysG1IbxC/ze8mdCE8SxpM+FNlwBB0xeh4IBNjwldIFrRSdNlt8wuEyhXJIJKK2CUPtjsmPGB+s3M3M9XHv5xo7zKrHvWOzWwVhWzVV/rNsVpkp9+g7wf8mnE9o8Hvvq520yeFA3XBr0BcqjbqJTrI9LpiJJ61fpvS1IYVapZNsG1072h1qW8mMem9Rrea89e2dl7d+sCFFzBJ5Kii9
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(396003)(376002)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(2616005)(66476007)(6916009)(2906002)(6486002)(316002)(26005)(66446008)(64756008)(66556008)(54906003)(66946007)(76116006)(5660300002)(4326008)(478600001)(44832011)(6512007)(8936002)(83380400001)(8676002)(41300700001)(122000001)(86362001)(38100700002)(6506007)(71200400001)(36756003)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?mY9ANEf/v6xEvLLJaFP5QXQNydeq9NcEoWQym6Wt4L6QpW9gx++teQu9i?=
 =?iso-8859-15?Q?B4VfLv9s+Ftd28stXhj2ObR2MSVfOoDZg4KDZkgYMM4pBAJj5emJDbzBe?=
 =?iso-8859-15?Q?s8yZ2RfLIWbK0ATEjYRQkHNOQgtJ6bOuqzlk6fqLAay6riqMQfqQUl+XR?=
 =?iso-8859-15?Q?5Ov4vfNCjh721zbTr/TqngjfHwor79RXiI1ohr/X3cInnrzF/Zb5M7igz?=
 =?iso-8859-15?Q?dLoAPYbRh3k9zUnY/2icqbQT+u1wYpshytvQAStmupCB7qQbAsPQXEI8u?=
 =?iso-8859-15?Q?CDSA7XXnNeBnNV+PEzxFfeNeECSEcLgRSgB/fj0SmESJafoE6srKpYDiw?=
 =?iso-8859-15?Q?1O+ughVNpihCdfh1cegcRy9jvm2DEIeMvvgwNhDKe9yhzEQzVRG0CpXxz?=
 =?iso-8859-15?Q?gpI8KkFIwCG6p3NXOa54i3ZNiwc6Gtbc0AmUd5K7cgNmNF+xmAM/p+fMF?=
 =?iso-8859-15?Q?9evz9sHCowybPVklCSRatGckr8ESHCNFRHfcFsdPWZMubRAHZpqfj3WuH?=
 =?iso-8859-15?Q?rcQwFFVokTTOG2Xlj7EMSZG1POvEnPmmSgJUfeVzH6zd8T/IbFCumYVFX?=
 =?iso-8859-15?Q?YN3k2sTGyRT4NSx9srl10hoaA6A8hvn5RUxVNtbmHSqhPyKeWKEEMpyom?=
 =?iso-8859-15?Q?Wf2eEQ30tsOl0qELL1sqxL9niGnJCAHDnGHnyYN/ZKc8zgB0fbIsI4NLx?=
 =?iso-8859-15?Q?PzXoO/hJU/u0+z9jz6BADjtwo0vNa9FPfHPIG828Wn86+4fjhxjsdiGPr?=
 =?iso-8859-15?Q?gjwpjzwz4gkwB1ufNINTBKZ8y6fNOnRP3B2NuN3EolSnsdL0lO30WUFSU?=
 =?iso-8859-15?Q?QWXfg7lXYbT8et5txTwdOvamDah7JKhVegRvChgpJuQK9FMs15UDzyCRH?=
 =?iso-8859-15?Q?D2CPNi246+PpCb1a47Zb3cG2bLHmv7xBMhFpyKJDcQfMD/KwhTZYVciZr?=
 =?iso-8859-15?Q?qMQEFb+qAtUm9SC2S8jKccgqP6GHsKZkRjJcUUV8a4dcERNsYmenu2DIV?=
 =?iso-8859-15?Q?SRPGlp1RFAW8JmjLLzkTvOyCmYbyhbo/GcCiabQAFZTiVrCk8Aoye23PK?=
 =?iso-8859-15?Q?uHtmTaEEg8Hkm4hOsXI3sp779t16P5OaePGDCQv3Y4ggcP+oKFm7A6n5r?=
 =?iso-8859-15?Q?irlPpP+wFsLo5H4iWdp3hcM2H7BkVm9+ol2LSvqIYNNNz8u9n/oBQ6tKE?=
 =?iso-8859-15?Q?DbxOFXdbSlYUFkdHYFNFMeixYSzR1n21wTKPWzPcTnPkjdR2FlmWj3ppN?=
 =?iso-8859-15?Q?uVpnv+/O/ovJNfYVxwLxl/Gklnt0p3M6HwPNRLXzTIUOI22Fjuk68BL1V?=
 =?iso-8859-15?Q?0OAknv9VnPWlM9APaab5/cqqUDUZsJZgX7+J9bPUevpjUS+3ZqWcvNdDp?=
 =?iso-8859-15?Q?6J1UXHwWfaROEq/M187450U8DHuQmZ7XAMBzHhd+DwTMfQKYr95MRInPE?=
 =?iso-8859-15?Q?p8xINhaFY1EdZ1+x4XuZLPgtLUYTGk74/dL184b7dd3c+AAdimf1cAIOH?=
 =?iso-8859-15?Q?wSINniPMoRMciiP10p135IByeDKglphYF3IHqUAvfUJHDgBSXEeKwqJVg?=
 =?iso-8859-15?Q?tk1KS6svAilOs97wLV0pNOcGQciukq9U8q18qKzpdpgMClutlnGDL3ps8?=
 =?iso-8859-15?Q?UywdjG7H/8L+tp94RA9TLlNGTQQHNj1OCb6/jY/R/CPid0iVVYcvCicP5?=
 =?iso-8859-15?Q?kD7KuUX6cdlcXPgMPeBf8kZsWQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <138949EAD84DEA478A6D9A8412EECDDC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6324.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d42fb487-2e5c-4112-414d-08dbe15c9d22
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2023 19:46:49.2192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XW8AYiSMi811KEx9UiQkLc4yg88g8aCLkZyc2AD8cSGGW8xUKOOfoU2UcbyYhGQEC12bpwi6KTYNKRoNS6rVKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9521

On Thu, 2023-11-09 at 12:26 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 09, 2023 at 09:07:23AM +0000, Martin Wilck wrote:
>=20
> > > In the case were the path_checker keeps succeeding, but the IOs
> > > keep
> > > hanging, multipathd will just keep restoring this path over and
> > > over
> > > again. That's the sort of path ping-ponging that shaky path
> > > detection
> > > should be able to stop. I guess this is can speed up other cases
> > > for
> > > failover as well, so I can leave that off.=A0 Hopefully people know
> > > that
> > > if they are seeing ping-ponging, shaky path detection can help
> > > with
> > > it.
> >=20
> > This is a general argument for enabling shaky paths detection. But
> > I
> > don't see how it relates to max_retries. Decreasing max_retries
> > should=20
> > make it less likely that regular IOs are hanging while the path
> > checker
> > succeeds, whether or not shaky path detection is enabled. By
> > decreasing
> > max_retries, we force the kernel to treat regular IO more like
> > passthrough IO. AFAIU that should decrease the difference of
> > failure
> > probability between the path checker and regular IO.
>=20
> I wasn't being clear. Changing this won't make ping-ponging more
> likely.
> It's just that if you are in the case where IO is hanging for
> extended
> periods of time and then failing, but the path checker is succeeding,
> and you want to an efficiently running system, changing max_retries
> will
> only get you halfway there, since it won't fix the ping-ponging. I
> agree
> that the ping-ponging is a seperate issue. My brain was sort of stuck
> in
> the specific customer issue that drove all this work, which did
> involve
> ping-ponging.=20
>=20
> > I have another question; as pointed out in my previous post about
> > this
> > patch, max_retries only affects the kernel's "maybe_retry" case,
> > IOW
> > mostly DID_TRANSPORT_DISRUPTED. This is a condition that can happen
> > with shaky paths. But SCSI command timeouts are also likely, and
> > for
> > that case, reducing max_retries isn't going to help, as timed out
> > commands won't be retried but passed to the error handler.
> > DID_TRANSPORT_DISRUPTED errors will happen quickly most of the
> > time.
> > IOW, I don't quite understand how decreasing max_retries
> > substantially
> > decreases the time regular I/O=A0would be hanging [1]. I associate
> > hanging IO mostly with command timeouts. Am I missing something
> > here?
>=20
> This work is all in response to a customer, who found that the only
> way
> to work around what turned out in the end to be an HBA issue, was to
> lower max_retries and turn on shaky path detection, to make multipath
> quickly ignore unusable paths. I admit that I didn't dig into why
> reducing max_retries sped things up. They just asked if it was
> possible
> to make multipath control this scsi config parameter like it does
> others, and it seemed like a reasonable request to me.

Right. I didn't want to say it's not. I was just hoping that we could
achieve a better understanding of the underlying issue.

Martin

