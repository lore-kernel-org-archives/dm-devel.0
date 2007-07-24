From: Hannes Reinecke <hare@suse.de>
Subject: Re: Re: [multipath 1/1] cache sysfs_devices
Date: Tue, 24 Jul 2007 08:35:16 +0200
Message-ID: <46A59DA4.1010703@suse.de>
References: <20070720172919.GA2497@bogon.ms20.nix>	<11849647793576-git-send-email--s>
	<20070720210343.GA11879@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070720210343.GA11879@bogon.ms20.nix>
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
Cc: Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Guido Guenther wrote:
> I give up on git-send-email - it always fools me. Nevertheless this one
> fixes the described bug of paths coming back as different block
> devices:
>=20
> Keep a list of sysfs devices for sysfs_device_get() so uev_trigger() ca=
n look
> up the necessary information for proper path removal in case of a 'remo=
ve'
> uevent - the sysfs files in the filesystem might be long gone at this p=
oint.
>=20
> This also plugs a memory leak where we'd malloc space for the same sysf=
s device
> over and over again for every processed uevent.
>=20
Hmm. But now we're running into the opposite trap: memory for a block dev=
ice once
existing will never be freed. So over time we're likely to become a memor=
y hog.

Better it would be to remove the sysfs device from the cache once we're d=
one
with it.

I'll cook up a patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
