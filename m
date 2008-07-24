From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Fix whitespace issues in multipath-tools
Date: Thu, 24 Jul 2008 08:48:20 +0200
Message-ID: <488825B4.8080807@suse.de>
References: <4886E57C.2000106@suse.de> <1216846612.9122.6.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1216846612.9122.6.camel@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

Christophe Varoqui wrote:
> Le mercredi 23 juillet 2008 =C3=A0 10:02 +0200, Hannes Reinecke a =C3=A9=
crit :
>> Hi Christophe,
>>
>> one day I got fed up with all of those whitespace issues.
>> Here's a patch to fix up (most) of them.
>> So no guarantee for completeness, but a good step in
>> that direction.
>>
> Sure, committed with 2 left-overs :
>=20
> 1/ in uxsock.c, the patch unduly removed addr declaration
>=20
Ah, that's where it went. I was merging / re-diffing my SLES
patch queue and suddenly I got this missing 'addr' declaration.
But then I got too lazy to chase it down :-)

> 2/ in config.c, there was traces of something I smelling like a good
> fix, but not fully fonctionnal (use of alloc_keyword where not
> available). As this fix should not be merged in a format patch anyway,
> I'll let you juge if you want to submit the complete fix separetely.
>=20
Yes, another bugger-up on my side.
This is actually part of my 'multipath -t' patch,
which allows you to dump the internal hwtable to stdout.
I still prefer that approach over the 'multipathd -k xxx' option,
as this does _not_ require to have multipathing running, hence
you can even modify / create a multipath.conf in dry-run mode
and you wouldn't risk any service disruption.
Which you inevitably would have if you have to fire up multipathd
and have him claim all unused devices.

I'll see to prepare the patch.

Thanks for merging.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
