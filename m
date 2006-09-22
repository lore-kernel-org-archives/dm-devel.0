From: Edward Goggin <egoggin@emc.com>
Subject: RE: Why is device mapper unable to remove a mapped
	devicewhich is open?
Date: Fri, 22 Sep 2006 16:47:24 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D13DA@CORPUSMX40A.corp.emc.com>
References: <20060922204312.GY17654@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20060922204312.GY17654@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Yes, I remember this coming up in discussions quite some time
ago.

Thanks!=20

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Alasdair G Kergon
> Sent: Friday, September 22, 2006 4:43 PM
> To: device-mapper development
> Subject: Re: [dm-devel] Why is device mapper unable to remove=20
> a mapped devicewhich is open?
>=20
> On Fri, Sep 22, 2006 at 04:26:16PM -0400, goggin, edward wrote:
> > Why shouldn't the kernel's reference counting for the
> > mapped device's md structure account for properly=20
> > handling the de-allocation of the md structure upon
> > the last close in this case?
>=20
> This behaviour has flipped a couple of times during the
> development.
>=20
> It would be fine if devices could never be suspended.
> You can't close a suspended device you've written to
> until it gets resumed.  If you've removed it you can't
> resume it because it has gone.
>=20
> It's similar in a way to how the kernel used to (at least I=20
> assume someone
> fixed it?) let you unlink a swap file and then it was impossible to
> 'swapoff' because you couldn't reference the device any more.
> =20
> Alasdair
> --=20
> agk@redhat.com
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
