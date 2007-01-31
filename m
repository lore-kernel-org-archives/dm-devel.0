From: =?iso-8859-1?Q?Lo=EFc?= Minier <lool+redhat@via.ecp.fr>
Subject: Re: Weird discrepancy between /dev/mapper/* and /dev/dm-*
	devices breaks lilo
Date: Wed, 31 Jan 2007 12:00:10 +0100
Message-ID: <20070131110010.GA29662@bee.dooz.org>
References: <20070131104737.GA29370@bee.dooz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070131104737.GA29370@bee.dooz.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 31, 2007, Lo=EFc Minier wrote:
>  bee:~# dmsetup table dm-1
>  device-mapper: table ioctl failed: No such device or address
>  Command failed

 (responding to self)

 Is lilo supposed to call something like "dmsetup info" on the
 major/minor of dm-1 to translate this into a device mapper
 "device_name"?  E.g.:
 bee:~# file /dev/dm-1
 /dev/dm-1: block special (253/1)
 bee:~# dmsetup info -c --noheadings -j 253 -m 1
bee--sata-refuge:253:1:L--w:1:1:0:LVM-beM0G1UiiCSaWGi1RkcyX3EhGET9D7GbyLP=
U0wXiCs
OswbyC2LoECortBYa3prWw
 bee:~# dmsetup table bee--sata-refuge
 0 131072 linear 8:2 117440896

 Or is the device-mapper code supposed to accept device names from /dev
 as parameters?

--=20
Lo=EFc Minier <lool@dooz.org>
