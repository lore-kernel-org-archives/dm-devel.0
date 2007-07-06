From: Hannes Reinecke <hare@suse.de>
Subject: Re: online disk resizing
Date: Fri, 06 Jul 2007 08:19:24 +0200
Message-ID: <468DDEEC.1030701@suse.de>
References: <E43E8EC1853DF64D8DF70C7FDC14E92A027093C5@dewdfe26.wdf.sap.corp>	<468CE787.6040500@sigmatrans.ru><7531FC6D348A2F4A9670BBC9BCB3250802B3E2E8@cm050024.europede.psinet.dc>	<468CFB57.4050508@sigmatrans.ru><7531FC6D348A2F4A9670BBC9BCB3250802B3E2EC@cm050024.europede.psinet.dc>	<468CFDFC.7000807@sigmatrans.ru>
	<7531FC6D348A2F4A9670BBC9BCB3250802B3E2ED@cm050024.europede.psinet.dc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7531FC6D348A2F4A9670BBC9BCB3250802B3E2ED@cm050024.europede.psinet.dc>
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
>> -----Original Message-----
>> From: dm-devel-bounces@redhat.com=20
>> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Alexander Benaguev
>> Sent: Donnerstag, 5. Juli 2007 16:20
>> To: device-mapper development
>> Subject: Re: [dm-devel] online disk resizing
>>
>> Roland Mieslinger wrote:
>>> Did you get a error from blockdev command?
>> none
>>> Did you stop all I/O to the device?=20
>> I can't!=3D) it's not online resizing, if I should stoping io;(
>=20
> That's were i stuck too.=20
> You can do it without reboot, but I've found no way to do it online.
>=20
As already said: online resizing only works if there are _no_ references
to that device. Ie no device-mapper tables referencing it etc.
Otherwise any block device updates will be rejected by the kernel.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
