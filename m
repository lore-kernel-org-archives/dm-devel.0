From: Hannes Reinecke <hare@suse.de>
Subject: Re: Round Robin vs Active/Passive
Date: Fri, 23 May 2008 09:16:54 +0200
Message-ID: <20080523071654.GB380@pentland.suse.de>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>
	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>
	<483468AD.7@linpro.no> <000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>
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

On Thu, May 22, 2008 at 10:24:52AM +0200, Domenico Viggiani wrote:
> * Tore Anderson
> >
> > path_grouping_policy group_by_prio
> > prio_callout "/sbin/mpath_prio_emc_silent /dev/%n"
> >=20
> > (This is an EMC array.)
> >=20
[ .. ]
>=20
> Sorry for question: is this how new ALUA mode works for EMC Clariion CX
> arrays?
> Are default settings suitable for this new failover mode?
>=20
> I just upgraded my CX700 to FLARE26 with ALUA mode...
>=20
No. Alua is completely different. You have to use

prio_callout "/sbin/mpath_prio_alua /dev/%n"

for this.
Although the normal EMC configuration continues to work, too.
And also note that you have to change the failover mode
to '4' to enable ALUA on the Clariion.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
