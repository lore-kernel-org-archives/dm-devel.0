From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use 'mpatha' for user_friendly_names option
Date: Wed, 07 May 2008 09:17:08 +0200
Message-ID: <48215774.9030602@suse.de>
References: <20080430090329.CAC0718C6FF@pentland.suse.de>	<20080506193539.GA7332@bogon.ms20.nix>	<482149EC.4080808@suse.de>
	<000001c8b00c$e26539c0$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000001c8b00c$e26539c0$cf42e3c1@pitagora.it>
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

Hi Domenico,

Domenico Viggiani wrote:
> Hannes Reinecke wrote:
>> Normally I don't use this option much; in fact, I discourage=20
>> everyone on using it :-) I really loath to have external=20
>> configuration files to get your filesystem up.
>=20
> In fact, I remember the nasty problem at boot time with bindings file
> residing under /var/lib/multipath when this is a filesystem different f=
rom
> /:
>  http://kbase.redhat.com/faq/FAQ_96_12017.shtm
>=20
Which is exactly why I don't like it.
And most users normally won't touch the device names anyway,
so I don't have a problem with /dev/disk/by-id/scsi-XXXXX-partY.
Plus it breaks my brilliant seamless-switch-to-multipath scheme :-)

Hmm. Maybe I should write an NAA/IEEE naming decoder to translate
the hex number into something readable :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
