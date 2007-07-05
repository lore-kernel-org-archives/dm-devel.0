From: "Roland Mieslinger" <roland.mieslinger@interoute.com>
Subject: RE: online disk resizing
Date: Thu, 5 Jul 2007 15:15:40 +0200
Message-ID: <7531FC6D348A2F4A9670BBC9BCB3250802B3E2E8@cm050024.europede.psinet.dc>
References: <E43E8EC1853DF64D8DF70C7FDC14E92A027093C5@dewdfe26.wdf.sap.corp>
	<468CE787.6040500@sigmatrans.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <468CE787.6040500@sigmatrans.ru>
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

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Alexander Benaguev
> Sent: Donnerstag, 5. Juli 2007 14:44
> To: device-mapper development
> Subject: Re: [dm-devel] online disk resizing
>=20
> Raayman, Sebastian wrote:
> > this is also dependant on the HBA you are using. With a=20
> Qlogic adapter=20
> > you can simply send an:
> >=20
> > echo scsi-qlascan
> >=20
> > to your Qlogic adapter (for example under /proc/scsqi/qla2xxx)
>=20
> thanks for attention, guys
>=20
> Sebastian, yes, I use qlogic, but, you will laught, I have=20
> not /proc/scsqi/qla2xxx. googling around shows that:
> "as of RHEL4 U3 (and I'd imagine upstream kernel.org kernels)=20
> the 'scsi-qlascan' no longer works with the qla2xxx driver.=20
> The new method is:
>=20
> echo 1 > /sys/class/fc_host/host<ID>/issue_lip
> echo "- - -" > /sys/class/scsi_host/host<ID>/scan" but it=20
> does not work for me.
> I tried "echo 1 >
> /sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/0000:06:01.0
> /host1/rport-1:0-1/target1:0:1/1:0:1:2/rescan"=20
> too. so, it was much better: dmesg showed me disks with new=20
> capacity, but "fdisk -l" still showing old capacity;( any thoughts?

try:=20
blockdevice --rereadpt <blockdevice>

Roland
