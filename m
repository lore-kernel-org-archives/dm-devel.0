From: Hannes Reinecke <hare@suse.de>
Subject: Re: multibus / failover and EMC CX600
Date: Thu, 18 Oct 2007 08:19:07 +0200
Message-ID: <20071018061907.GA22562@pentland.suse.de>
References: <066001c810cc$cd9f6f90$0a00a8c0@ALDI2> <471631E5.9050603@linpro.no>
	<068301c810e8$1f4e6e70$0a00a8c0@ALDI2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <068301c810e8$1f4e6e70$0a00a8c0@ALDI2>
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

On Wed, Oct 17, 2007 at 08:04:12PM +0200, Gerald Nowitzky wrote:
> I'm afraid the patch did not work for me. I'ts still the same.
>=20
> I am using kernel 2.6.22.2 at the moment. Should I upgrade to 2.6.23 ?
>=20
> Anybody any Ideas?
> The system is not in production at the moment. We could do some testing=
.
>=20
Well, yes. By the looks of if the problem is with multipathing still hold=
ing
references to the stale devices.
IE after dev_loss_tmo kicks in, the devices are removed from sysfs.
But multipathing does _not_ update it's device-mapper tables (that's why
you see all the '#' in the output), so there's still a refence on the
removed device and the in-kernel resources can't be freed.

So when the device is re-registered, you're getting this Oops.

Try to update the multipath information by running 'multipath' after the
devices have been removed. Once the '#' in the output are gone, you can
savely re-add the devices.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
