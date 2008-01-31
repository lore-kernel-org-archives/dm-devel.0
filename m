From: "Greene, Rick" <rick.greene@ncogroup.com>
Subject: RE: Multipath and getuid_callout
	issueswithHPXP1024diskarray
Date: Thu, 31 Jan 2008 14:05:54 -0500
Message-ID: <2F1F44D192D1284BAA298E48C1B2A4F90234F16A@exchmail03.ncogroup.com>
References: <20080131183234.GB27979@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080131183234.GB27979@us.ibm.com>
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

If I do "multipath -ll" then I see [ready][active] as the state...my
prior output was from just "multipath -l"

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of malahal@us.ibm.com
Sent: Thursday, January 31, 2008 1:33 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Multipath and getuid_callout
issueswithHPXP1024diskarray

Greene, Rick [rick.greene@ncogroup.com] wrote:
> Thanks for the answers Malahal, you are a credit to the open source
> community!
>=20
> Not sure I understand your comment here, can you clarify?
>=20
> >Greene, Rick [rick.greene@ncogroup.com] wrote:
> >> create: mpath0 (05:83)
> >> [size=3D13 GB][features=3D"0"][hwhandler=3D"0"]
> >> \_ round-robin 0
> >>  \_ 1:0:0:0 sda 8:0   [ready]
> >> \_ round-robin 0
> >>  \_ 2:0:0:0 sde 8:64  [ready]
> >
> >The above out displays two states for me. Maybe your version only
> >displays one.


Thank you for the kind words!  On my system, the following is the
output.
Notice that the "undef" state is printed as "DM state" of the device.
Maybe,
your version of multipath tool doesn't print if it is "undef"

create: mpath3 (320000004cf311021)  IBM-ESXS,ST318453FC   =20
[size=3D17G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D1][undef]
 \_ 0:0:4:0 sde 8:64  [undef][ready]
\_ round-robin 0 [prio=3D1][undef]
 \_ 0:0:9:0 sdj 8:144 [undef][ready]

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
