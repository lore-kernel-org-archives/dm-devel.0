From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 0/7] Fix muitpath/multipathd flush issue
Date: Fri, 3 Jul 2020 18:50:26 +0000
Message-ID: <11f2c30ae0c94ce76e1bf110e8bc599cc7ddd832.camel@suse.com>
References: <20200618180458.GI5894@octiron.msp.redhat.com>
	<c5e95e7bc75b11e811854ff0b0988ff19ef45e13.camel@suse.com>
	<20200618230625.GJ5894@octiron.msp.redhat.com>
	<5357998bd17e1147fd3a6615e03251d1aa4900d8.camel@suse.com>
	<20200702031449.GB29962@octiron.msp.redhat.com>
	<8158d509bca2cae483d553defdd1eb378c16d813.camel@suse.com>
	<20200702151829.GA11089@octiron.msp.redhat.com>
	<cd568c7aabaa102db8ef6ba8ceb87b96d62f632c.camel@suse.com>
	<20200702194128.GG11089@octiron.msp.redhat.com>
	<be1e8d96543bc86a6a194bb9c708fba91878d9c9.camel@suse.com>
	<20200703163909.GA7187@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200703163909.GA7187@redhat.com>
Content-Language: en-US
Content-ID: <EE61EAF43CE96F48899739D2EF44C8E4@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "zkabelac@redhat.com" <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, 2020-07-03 at 12:39 -0400, Mike Snitzer wrote:
>=20
> Docker couldn't have later opens fail due to a pending removal --
> it'd
> break their app.  So if you want it to do what you'd have imagined it
> to
> be; we'll need to introduce a new flag that alters the behavior
> (maybe
> as a module param off of DM core's dm-mod.ko).  Patches welcome --
> but
> you'll need a pretty good reason (not read back far enough but maybe
> you have one?).

Thanks a lot for the explanation. I don't think I'm going write patches
and reason about it. We were just looking for the best way to safely
flush maps in multipath-tools, and I'd considered deferred remove as
one option, which it most likely is not. Anyway, I like to understand
why thinks are the way they are, so thanks again.

Cheers,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
