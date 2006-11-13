From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch to CLARiiON path checker to handle inactive
	snapshhots
Date: Mon, 13 Nov 2006 17:41:09 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1543@CORPUSMX40A.corp.emc.com>
References: <1163457484.10466.114.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1163457484.10466.114.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

OK, I'll work on it tomorrow and send it to you before
updating the CLARiiON specific checker to use this new
path checker context.

> -----Original Message-----
> From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
> Sent: Monday, November 13, 2006 5:38 PM
> To: goggin, edward
> Cc: dm-devel@redhat.com
> Subject: RE: patch to CLARiiON path checker to handle=20
> inactive snapshhots
>=20
> Le lundi 13 novembre 2006 =E0 14:15 -0500, Edward Goggin a =E9crit :
> > =20
> > > -----Original Message-----
> > > From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
> > > Sent: Sunday, November 12, 2006 6:38 PM
> > > To: goggin, edward
> > > Cc: dm-devel@redhat.com
> > > Subject: Re: patch to CLARiiON path checker to handle=20
> > > inactive snapshhots
> > >=20
> > > Le vendredi 10 novembre 2006 =E0 18:02 -0500, Edward Goggin=20
> a =E9crit :
> > > ...
> > >=20
> > > Ok, I aknowledge this approach is far more complex than your 1st
> > > attempt.
> > >=20
> > > If I read correctly the two candidate patches, the clariion=20
> > > checker need
> > > to share information with the other path chechers=20
> attached to the same
> > > multipath to decide for a state to return.
> >=20
> > Yes.  This is only because for the passive paths, the clariion
> > is not returning a specific sensecode/asc/ascq combination to
> > indicate an illegal attempt to read/write from/to an inactive
> > snapshot LU.  If it did so, the clariion path checker code
> > could continue to rely simply on testing each path independently.
> >=20
> > By the way, since none of these solutions deal correctly with
> > the use case where /sbin/multipath is checking the path status
> > of a passive path to an inactive snapshot before any active
> > paths to that LU have been checked, /sbin/multipath will show
> > the passive path (or those passive paths) as ready when it
> > (they) are really faulty.  I think the best solution for this
> > is to have the /sbin/multipath (or its equivalent like
> > "multipathd -k") get the path state(s) from /sbin/multipathd
> > instead of re-calculating its own states.  What do you think?
> >=20
> It sounds right, and it should be a safe change as long as the "daemon
> startup" and "multipath-without-multipathd" logics are unaffected.
>=20
> > Also, what about the idea of the distributions no longer starting
> > /sbin/multipath before /sbin/multipathd in order to avoid cases
> > where multipathing is started without having the full feature
> > set of multipathd (e.g., queue_if_no_path timeout feature).  This
> > is after initrd so there shouldn't be restricted user environment
> > issues involved with providing multipathing for the root device
> > from the ram disk.
> >=20
> Yes, /sbin/multipath mostly useful for root-on-san, embeded in
> initramfs. Even there, a single-shot run of multipathd might work.
>=20
> > >=20
> > > If so, let's pretend another checker might one day stress the same
> > > need :)
> > >=20
> > > What do you think of a facility like the following=20
> > > (completely untested
> > > and surely semi-bogus) patch sketches ? Would it make=20
> your patch as
> > > straight as your first attempt ?
> >=20
> > Yes.
> >=20
> > >=20
> > > It seems to take care of our griefs with "container_of" and the
> > > clariion-centric additions to "struct multipath".
> >=20
> > Yes.  I like your idea, it adds generic value whereas my=20
> 1st solution
> > did not.  Will you be checking in this code soon?
> >=20
> You should build upon it as-is.
>=20
> As the first user of the framework, you may want to change it a bit to
> make theory meet reality. Then I'll happily merge it as a preparatory
> patch for the clariion checker bits.
>=20
>=20
> >=20
> > > Regards,
> > > cvaroqui
> > >=20
> > >=20
> > >=20
> > >=20
> > >=20
>=20
>=20
>=20
