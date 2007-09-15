From: Eckebrecht von Pappenheim <evp@heise.de>
Subject: Re: path priorities on Sun's 6140
Date: Sat, 15 Sep 2007 08:26:03 +0200
Message-ID: <29A5BF0F72CEC4FE750AD8C7@[192.168.12.2]>
References: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com>
Content-Disposition: inline
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
Cc: James Fillman <JFillman@cucbc.com>
List-Id: dm-devel.ids

Hi,

> Can anyone briefly explain what the mpath_prio_tpc utility does and
> where these priority values come from?
>=20
> The output of multipath -v2 -ll is:
>=20
> [root@vlxq02md cluster]# multipath -v2 -ll
> mdi_logging (3600a0b800029f8e80000064d46e565e7) dm-9 SUN,CSM200_R
> [size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 1:0:0:2 sdd 8:48  [active][ready]
>  \_ 1:0:1:2 sdg 8:96  [active][ready]

you are sure your two pathes are using different controllers? A SAN setup
problem which makes the HBA use only 1 of the two controllers seems to be=
 a
very good reason for this multipath output.

Do you use a single-port HBA?=20

With my dual-port HBA I get:

Raid5_for_IMAP-Volume (3600a0b80002906e20000089345bf1a2b) dm-1 SUN,CSM200=
_R
[size=3D1.4T][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D12][active]
 \_ 7:0:1:1  sdac 65:192 [active][ready]=20
 \_ 6:0:3:1  sds  65:32  [active][ready]=20
\_ round-robin 0 [prio=3D2][enabled]
 \_ 7:0:3:1  sdam 66:96  [active][ready]=20
 \_ 6:0:1:1  sdi  8:128  [active][ready]


with multipath.conf:

devices {
        device {
                vendor SUN
                product CSM200_R
                path_grouping_policy group_by_prio
                path_checker tur
                prio_callout "mpath_prio_tpc /dev/%n"
                features "1 queue_if_no_path"
        }
}


BTW: A polling interval of 10 seconds is too slow for 6140 firmware
updates,=20
I had to use 5 seconds because the controllers are rebooting quite fast..=
.

regards,
Eckebrecht

--=20
Eckebrecht von Pappenheim
Netzwerkadministration
Heise Zeitschriften Verlag GmbH & Co KG
Helstorferstr. 7, D-30625 Hannover, FRG
E-Mail: evp@heise.de  - Tel: +49 511 5352 242  -  Fax: +49 511 5352 479
http://www.heise.de/

Registergericht: Amtsgericht Hannover HRA 26709
=20
Pers=F6nlich haftende Gesellschafterin: =20
Heise Zeitschriften Verlag Gesch=E4ftsf=FChrung GmbH
Registergericht: Amtsgericht Hannover, HRB 60405
Gesch=E4ftsf=FChrer: Ansgar Heise, Steven P. Steinkraus, Dr. Alfons Schr=E4=
der
