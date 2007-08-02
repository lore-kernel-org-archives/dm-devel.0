From: Hannes Reinecke <hare@suse.de>
Subject: Re: RH 4 and HSG80
Date: Thu, 02 Aug 2007 08:27:23 +0200
Message-ID: <46B1794B.4040806@suse.de>
References: <OFD9DA3C9D.6E99EABB-ONC125732A.005472D4-C125732A.0055D34C@de.ibm.com>	<46B0BEB9.4060303@interactivebrokers.com>
	<1185994366.17399.105.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1185994366.17399.105.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> On Wed, 2007-08-01 at 13:11 -0400, Eric Ritchie wrote:
>> Thanks for the help. Unfortunately, I don't have /sbin/mpath_prio_hp_s=
w.=20
>> I have other mpath_prio files but not the hp one. I guess that means I=
=20
>> need a newer version of multipath-tools. How can I upgrade to the late=
st=20
>> version?
>=20
> Try out different mpath_prio's (especially the _tpc one). One of them
> _might_ work.
>=20

mpath_prio_tpc doesn't work. The HSG80 is basically the same firmware tha=
n
the older HP MSA boxes have (active/passive), so you'd need the hp_sw rel=
ated
things.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
