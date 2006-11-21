From: Edward Goggin <egoggin@emc.com>
Subject: RE: Re: update for shared path checker context
Date: Tue, 21 Nov 2006 09:14:28 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1570@CORPUSMX40A.corp.emc.com>
References: <1164067375.25061.7.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1164067375.25061.7.camel@localhost.localdomain>
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

On Monday, November 20, 2006 7:03 PM, Christophe Varoqui wrote:
> To: goggin, edward
> Cc: dm-devel@redhat.com
> Subject: [dm-devel] Re: update for shared path checker context
>=20
> Le vendredi 17 novembre 2006 =E0 11:21 -0500, Edward Goggin a =E9crit :
> > Christophe,
> >=20
> > I made the following changes.
> >=20
> > modified the path checker interface so that each path checker
> > type could specify the size of their shared path context area
> >=20
> > discovery.c:get_state() now returns without setting path state
> > if the path's mpp pointer is not set (IFF PP_DAEMON) else it
> > becomes tricky to update the path checker's ptr to the shared
> > context area after the path checker has been already initialized.
> >=20
> > structs.c:free_multipath() now frees shared context area if it was
> > allocated.
> >=20
> Wouldn't a void** mpcontext in struct multipath instead of a=20
> void* keep
> us from resorting to those ->size_scxt fonctions ?

Yes, much better idea!

>=20
> - mpcontext allocation is deported insode the checker, so only the
> checker needing the facility have to care.

OK.

> - mpcontext freeing in free_multipath is ok, I guess

Given your approach, should free mpcontext in the path checker
free functions ...

>=20
> Something like the attached patch, for example.
> (extreme hack to readsector0 to showcase the facility)

I'll try this out with the clariion inactive snapshot stuff
and let you know.

>=20
> Regards,
> cvaroqui
>=20
>=20
