From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: RE: Question about dmevents
Date: Mon, 23 Jul 2007 09:43:26 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC012598AB@orsmsx418.amr.corp.intel.com>
References: <20070722111553.GL459@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20070722111553.GL459@agk.fab.redhat.com>
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

>-----Original Message-----
>From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On
>Behalf Of Alasdair G Kergon
>Sent: Sunday, July 22, 2007 4:16 AM
>To: device-mapper development
>Subject: Re: [dm-devel] Question about dmevents
>
>On Sun, Jul 22, 2007 at 10:43:17AM +0200, Peter Rockai wrote:
>> In fact, when using theh libdevmapper-event library, the client-side
>> code should already fail, if a device has no uuid. In practice, this
>> means that uuid-less devices cannot be monitored, but that is
probably
>> a case that is not really important (or is it?).
>> I would probably prefer to just document this as requirement and keep
>> things as they are. Comments?
>
>That all makes sense to me.

Agreed :)


>
>  name =3D user-friendly reference; can be changed at will
>  uuid =3D software-friendly reference, a constant for the life of the
device
>
>If we have existing software not setting up uuids then those programs
need
>investigating.
>

I have a question though, not being too familiar with the device-mapper
core code. When I load a fresh system using FC7 on a raid1 volume (for
example) I never see a prompt during the installation asking if I would
like to have a UUID assigned. After the install I check and there isn't
one assigned by default. If I then add some disks to the system and
decide to install an LVM2 mirror I do this using the command line and
there is a UUID assigned by default. Is this also a bug in the
installer? Or is there a way I can assign a UUID to an already existing
system? In the documentation it says I would have to delete my volume
group and rebuild it to assign a UUID is this correct? If so how can a
fresh system get a UUID?

Thank you for all the help :)=20

Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com

>Alasdair
>--
>agk@redhat.com
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
