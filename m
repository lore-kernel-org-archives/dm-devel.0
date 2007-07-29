From: "Ethan John" <ethan.john@gmail.com>
Subject: Re: Designing a new prio_callout
Date: Sun, 29 Jul 2007 09:03:05 -0700
Message-ID: <d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
	<46A735E1.4070206@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46A735E1.4070206@suse.de>
Content-Disposition: inline
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

Thanks for the heads-up about ALUA. We're looking into it.

What is the purpose of the custom mpio_prio_* applications that ship
with open-iscsi if not to handle multipathing?

On 7/25/07, Hannes Reinecke <hare@suse.de> wrote:
> Ethan John wrote:
> > I hope I found the right list for this.
> >
> > My company is developing an iSCSI solution, and in looking into Linux
> > compatability and performance, we're concerned that our architecture
> > doesn't
> > play well with the existing multipath configurations that are availab=
le.
> >
> > We cannot support what Linux calls multibus, or what the fiber world =
seems
> > to call active/active. We will need folks to configure failover
> > exclusively.
> >
> > It appears that the current multipathing failover configuration assig=
ns a
> > priority to each path (by default, just assigns the same priority to =
all
> > paths). This is bad for us, as we're presenting iSCSI targets across
> > multiple machines in a cluster; ideally, a user will have multiple de=
vices,
> > each with a separate path to a separate machine, with failover to the=
 other
> > machines in the cluster. The default setup of multipath will map all
> > connections to a single machine, which is no load balancing at all.
> >
> > I've fooled around with various other values for default_prio_callot
> > (besides the /bin/true), and the one that seems to work best is actua=
lly
> > mpath_prio_random.
> >
> Argl.
>
> > In fact, mpath_prio_random would actually work perfectly, except that=
 it
> > seems to swap path priorities extremely often -- several times a minu=
te. So
> > my company needs to develop a new script, probably much like the
> > mpath_prio_emc or mpath_prio_netapp ones, so that we can hint at load
> > balancing across devices with failover as the multipathing policy.
> >
> > I've been completely unable to find documentation on this. Where migh=
t I
> > look? Is this even the right direction in which to be looking for a
> > solution to this problem?
> >
> Have you looked a ALUA ?
> It's in SPC-3 section 5.8: 'Target port group access states'.
>
> This is the preferred way of handling these things.
> And is supported by multipath-tools.
>
> Mind you, only implicit ALUA is supported. Explicit ALUA
> support will be implemented, too, once someone actually
> uses it :-)
>
> Please do not design your own way of handling failover. This
> has shown too many difficulties in the past.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


--=20
Ethan John
http://www.flickr.com/photos/thaen/
(206) 841.4157
