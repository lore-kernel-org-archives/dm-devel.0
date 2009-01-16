From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: How does multipath tool handle Lun remapping?
Date: Fri, 16 Jan 2009 13:13:28 -0500
Message-ID: <20090116181327.GD1493@mars.virtualiron.com>
References: <d364733c0901160042n65184828pcac1e7a6435b6c9c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d364733c0901160042n65184828pcac1e7a6435b6c9c@mail.gmail.com>
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

On Fri, Jan 16, 2009 at 04:42:25PM +0800, =E8=B0=A2=E7=BA=B2 wrote:
> Hi,
>=20
> multipath path tool use the external program, such as scsi_id in udev,
> to get the id of the lun. But how does it handle the lun remapping?
> For example, at first, thiere is a lun in array:lun1, it is mapped to
> host with lun id 11. On the host, I use the multipath program to
> generate a multipath device for this lun. Then I unmap lun1 and
> another lun: lun2 which is mapped to the host with the same lun id 11.

Do you reboot the system after those unmaps/maps?

> In this situation, it seems that the multipath tool could not notice
> that there is a change of lun even after recreate the multipath
> device, is that true?

It would - as long as hte block devices get re-created/deleted
for the new/old LUNs.

>=20
> Thanks,
>=20
> --=20
> Xie Gang
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
