From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath-tools: Add preferred TPG prioritizer
Date: Mon, 14 Sep 2009 08:24:39 +0200
Message-ID: <4AADE1A7.1080008@suse.de>
References: <20090911182308.GN15326@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090911182308.GN15326@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Benjamin Marzinski wrote:
> Instead of using the Target port's Asymmetric Access State to determine
> priority, some users what to use the preferred port bit.  This patch ma=
kes
> a new prioritizer, based off the ALUA prioritizer, but using the prefer=
red
> port bit instead.
>=20
Please, no.

This would mean that 'tpg_pref' would evaluate the PREF bit _only_,
with total disregard to the other settings.

We should be updating the existing 'alua' prioritizer to evaluate
the PREF bit together with the existing AAS status; then we could
be using it for all scenarios.

I think I got a patch somewhere ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
