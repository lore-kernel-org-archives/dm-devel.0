From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: RE: How is the multipath pg policy group-by-nodename
	any	differen t than the failover policy?
Date: Tue, 3 May 2005 14:40:54 +0200
Message-ID: <20050503124054.GR1285@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A95A@SRMANNING.eng.emc.com>
	<a104606cc87e76d5150c588d17db8905@nanisky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a104606cc87e76d5150c588d17db8905@nanisky.com>
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

On 2005-05-03T13:22:32, Arthur Bergman <sky@nanisky.com> wrote:

> >How is the resultant path grouping any different than if you used the
> >failover
> >path grouping policy instead?
> >
> >--
> >dm-devel mailing list
> >dm-devel@redhat.com
> >https://www.redhat.com/mailman/listinfo/dm-devel
> >
>=20
> Huh, as far as I understand it group_by_nodename uses the
>=20
> /sys/class/fc_transport/target0:0:0/node_name information
>=20
> from our setup, there are 8 paths to two controllers, there is no=20
> failover cost but it defeats read caching pretty beadly to use both=20
> controllers..
>=20
> /sys/class/fc_transport/target0:0:0/node_name:0x50050768010003d5
> /sys/class/fc_transport/target0:0:1/node_name:0x5005076801000361
> /sys/class/fc_transport/target0:0:2/node_name:0x50050768010003d5
> /sys/class/fc_transport/target0:0:3/node_name:0x5005076801000361
> /sys/class/fc_transport/target1:0:0/node_name:0x5005076801000361
> /sys/class/fc_transport/target1:0:1/node_name:0x5005076801000361
> /sys/class/fc_transport/target1:0:2/node_name:0x50050768010003d5
> /sys/class/fc_transport/target1:0:3/node_name:0x50050768010003d5
>=20
>=20
> So all path that ends at a matching node_name, even if they are on=20
> different transport targets get one path.

Now figure in that this might need to be stacked with more hw-specific
stuff like dm-emc ;-)

I think that ought to work already if multipath-tools would set up the
right cascaded multipath tables in theory though; however it might not
because depending on how the stacking works some things might not
propagate up or down correctly right now.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
