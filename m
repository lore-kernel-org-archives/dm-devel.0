From: Lan <transter@gmail.com>
Subject: Re: what is the current utility in testing active paths
	from multipat hd?
Date: Wed, 27 Apr 2005 11:36:27 -0700
Message-ID: <ac71172a05042711367e80e21d@mail.gmail.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A94B@SRMANNING.eng.emc.com>
	<20050427170710.GU4431@marowsky-bree.de>
Reply-To: tranlan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050427170710.GU4431@marowsky-bree.de>
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

On 4/27/05, Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2005-04-27T12:27:32, "goggin, edward" <egoggin@emc.com> wrote:
>=20
> > Although I know it sounds a bit radical and counter intuitive,
> > but I'm not sure of the utility gained in the current multipathing
> > implementation by multipathd periodically testing paths which
> > are known to be in an active state in the multipath target driver.
> > Possibly someone can convince me otherwise.
>=20
> Because user-space doesn't know whether any IO has actually gone down a
> given path, and that would be the only time the kernel would detect the
> error.
>=20
> > If not, it may be possible to significantly reduce the cpu&io
> > resource utilization consumed by multipathd path testing on
> > enterprise scale configurations by only testing those paths
> > which the kernel thinks are in a failed state -- obviously a
> > much smaller set of paths.
>=20
> I could see not testing paths if we knew IO was hitting them; as an
> approximization, the active paths from the active PG might be omitted.
> However, the paths in the inactive PG all need to be tested, or else yo=
u
> are never going to find out that the paths have gone bad on you until
> you try to failover.
>=20
> The best way to minimize path (re-)testing needed is to figure in the
> hierarchy of components involved; as long as the FC switch is still bad=
,
> there's no point testing any target which we could reach through it,
> etc; testing whether the switch itself is healthy would round-robin
> through our various connections to the switch, to make sure we don't
> declare the switch down because we got hung up on one failed path.
>=20
> Another option would be to not mechanically test every N seconds, but t=
o
> retest a failed path after 1s - 2s - 4s - ... 32s max as a cascading
> back-off, and maybe start at 2 - 64s for paths in inactive PGs.
>=20
> Not testing paths however isn't a real option.
>=20

I think it's a good idea to make a distinction between testing paths
for probing (i.e. making sure they have not gone dead) and for
reclamation. Possibly this would mean having two separate testing
threads. This way users could decide which policies they would want to
use for each type of testing. Some users may not care so much for
probing. For example, if they have large configurations and and are
willing to trade off immediate knowledge of system degradation for
saved cycles, then they may decide to not have probing at all, and can
live with having paths fail due to failed I/O. Or use a probing policy
that doesn't consume so many resources, e.g. use a lower probing
frequency than reclamation testing. Reclamation is more crucial I
think and would be of more concern for users.  Enabling users to
determine the policy for reclamation, e.g. the testing frequency or
enable cascade-backoff, etc., would be good since factors for this
decision would be based on knowledge users have of their own
configuration and data load.


> > multipathd, this will no longer be true.  This seems unlikely
> > apparently due to the difficulty in implementing consistently
> > accurate path testing in user space.
>=20
> Uh? How is path testing in user-space difficult?
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>
>=20
> --
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
