From: Hannes Reinecke <hare@suse.de>
Subject: Re: online disk resizing
Date: Thu, 05 Jul 2007 09:33:44 +0200
Message-ID: <468C9ED8.8040201@suse.de>
References: <468BD5F2.8040001@sigmatrans.ru>
	<7531FC6D348A2F4A9670BBC9BCB3250802B3E2D6@cm050024.europede.psinet.dc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7531FC6D348A2F4A9670BBC9BCB3250802B3E2D6@cm050024.europede.psinet.dc>
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

Roland Mieslinger wrote:
> I did the same with HP MSA in the past, but without dm involved.
>=20
> You can use "blockdev --rereadpt <blockdevice>" to make the the kernel
> recognise the new disk size (geometery). The nasty thing is that you
> have to stop all I/O to the blocdevice.=20
>=20
You've not only to stop all I/O, but also have to make sure that on-one
claims the device (ie no open files, not mounted, no device-mapper tables
etc.). Otherwise will the kernel reject any size updates.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
