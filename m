From: Hannes Reinecke <hare@suse.de>
Subject: Re: Round Robin vs Active/Passive
Date: Fri, 23 May 2008 10:55:21 +0200
Message-ID: <20080523085521.GC380@pentland.suse.de>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>
	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>
	<483468AD.7@linpro.no> <000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>
	<20080523071654.GB380@pentland.suse.de>
	<4836798F.4060100@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4836798F.4060100@linpro.no>
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

Hi Tore,

On Fri, May 23, 2008 at 10:00:15AM +0200, Tore Anderson wrote:
> * Hannes Reinecke
>=20
> > No. Alua is completely different. You have to use
> >=20
> > prio_callout "/sbin/mpath_prio_alua /dev/%n"
> >=20
> > for this.
> > Although the normal EMC configuration continues to work, too.
> > And also note that you have to change the failover mode
> > to '4' to enable ALUA on the Clariion.
>=20
> Hmm, interesting.  Apologies if I've been spreading misinformation!
>=20
> Now you made me curious.  How does using an array (in ALUA failover mod=
e
> 4) with my configuration:
>=20
>         device {
>                 vendor                  DGC
>                 product                 *
>                 product_blacklist       LUNZ
>                 path_grouping_policy    group_by_prio
>                 path_checker            tur
>                 no_path_retry           queue
>                 prio_callout            "/sbin/mpath_prio_emc /dev/%n"
>                 failback                immediate
>         }
>=20
> differ from using the ALUA specific code in multipath-tools?  I believe
> it would look something like this?
>=20
>         device {
>                 vendor                  DGC
>                 product                 *
>                 product_blacklist       LUNZ
>                 path_grouping_policy    group_by_prio
>                 path_checker            tur
>                 no_path_retry           queue
>                 prio_callout            "/sbin/mpath_prio_alua /dev/%n"
>                 failback                immediate
>                 hardware_handler        "1 alua"
>         }
>=20
Yes, this looks about okay.

> I assume the ALUA bits are able to explicitly tell the CLARiiON to
> transfer volume ownership from one controller to another (something I
> don't think is desired in clustered environments anyway - the array
> should have a better understanding of the optimal location of the volum=
e
> than the hosts, who could be in disagreement and end up moving the
> volume back and forth), but what other differences are there?
>
In moving the assignment to another controller you will have a more
efficient I/O throughput, as in general the internal link between those
two controller isn't the fastest. So you really want to move the
LUN to that controller which should handle the I/O.
(Remember, the original EMC failover couldn't even handle I/O on
the non-active controller ...)

And for ALUA support in general this is just a standardized method of
signalling the required failover/multipath support mode to the initiator.
You can map just about any existing failover method on ALUA modes,
so in principle every IHV can update their firmware to support ALUA.

And most vendors already did so. Funnily enough, none of those chose
to implement the _exact_ modes the original firmware supported.
With EMC we suddenly can do I/O on the secondary path, the active/active
HP boxes suddenly have optimal and non/optimal paths, the old HP
MSA firmware starts do do I/O on their standby path, too, etc.
Bit of a shame, really. I was really curious how ALUA paths in 'standby'
mode would be reacting ...

> I'm speaking strictly from a user's point of view here - the difference=
s
> "under the hood" isn't that interesting to me as long as it ends up
> working the same way and in an equally reliable manner.
>=20
Well, the big advantage of the ALUA support in the EMC is that even the
secondary path will function, albeit slower. Hence you wouldn't get
the I/O errors during boot anymore.

HTH,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
