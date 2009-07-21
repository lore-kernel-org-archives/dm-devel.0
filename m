From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Allow multipath devices to be created for
	readonly	devices
Date: Tue, 21 Jul 2009 16:37:34 +0200
Message-ID: <4A65D2AE.9060102@suse.de>
References: <200907081417.59976.knikanth@suse.de>
	<20090720200835.GE32330@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090720200835.GE32330@agk-dp.fab.redhat.com>
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
Cc: Nikanth Karthikesan <knikanth@suse.de>
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Wed, Jul 08, 2009 at 02:17:59PM +0530, Nikanth Karthikesan wrote:
>> Currently we cannot create device-mapper tables for multipath devices
>> whenever they are read-only.This patch modifies the device-mapper to
>> set the 'READ-ONLY' flag automatically whenever a read-only is added
>> to the table.
> =20
> I recall discussing this before:
>=20
> 1) Contrary to the assertion above, you can already create such dm
> tables, by marking them explicitly as read-only.
>=20
Yes, I know. The whole point of this patch is to make the interface
more userfriendly.
Or, push the implementation details down one layer into device-mapper.

Sure, it is possible to create read-only dm tables, but this requires
some prior knowledge as you have to set additional flags.

This patch actually got kicked off by a difference in behaviour
when try to mount read-only devices as read-write.

With 'normal' block devices you'll get an -EROFS, whereas on device-mappe=
r
you get -ENXIO. The userland tools are normally equipped to handle the
former, not the latter.

The other part of the patch set links the read-only state of the device-m=
apper
device to the underlying devices, so when one is changed the others will
get updated, too.

> 2) The distinction between read-only and read-write device-mapper
> devices is currently clear and simple.  This proposal replaces the
> definitions with far-less-intuitive ones and that is why I ignored it
> first time around.
>=20
> If you believe the existing interface and behaviour is inadequate,
> think about some alternatives:
>   - What is the heart of the problem here?  Give a specific example
> to show why we need improvements: Is the patch really about
> optimisation, arguing that to achieve the desired result through the
> current interface involves avoidable effort?
>   - Consider whether adding another clearly-defined state to the system=
=20
> or extending the userspace interface would be a better approach.
>=20
The main point here is that by changing the device-mapper code we don't
have to modify any of the userland tools. Basically what this patches
do is moving the 'special device-mapper read-only handling code' from
userland into the device-mapper core.

Yes, this is debatable. But I don't know how many userspace tools there
are, and changing all of them to handle this case correctly is a daunting
task.
Plus that it'll be 'device-mapper only' code, which I don't think is a
good idea.

To summarise: I don't object to keeping the device-mapper interface fixed=
,
so that any program using libdevmapper or device-mapper directly has to b=
e
aware of this.
What I do object to is that programs using generic means (ie syscalls)
should be changed to accomodate special device-mapper handling.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
