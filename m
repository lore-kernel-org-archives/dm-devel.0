From: "Alexandre Berge" <Alexandre.Berge@etsi.org>
Subject: [SATA Raid] Volume is broken (Intel ICH7-R)
Date: Tue, 26 Jul 2005 18:26:30 +0200
Message-ID: <4091553999CBE4409CC2B562152B5A330857F680@email10.etsihq.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C591FE.C78CAF3B"
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
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

This is a multi-part message in MIME format.

------_=_NextPart_001_01C591FE.C78CAF3B
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

I've got the same kind of problem, except that I'm trying to use RAID 1
(on Fedora Core 4)

dmraid 1.0.0.rc8
device-mapper 1.01.02
grub 0.95

# dmraid --debug --verbose -ay
DEBUG: _find_set: searching isw_ciehjjjfgd
DEBUG: _find_set: not found isw_ciehjjjfgd
ERROR: isw: volume Raid-HD0_2 is broken
DEBUG: _find_set: searching isw_ciehjjjfgd
DEBUG: _find_set: found isw_ciehjjjfgd
ERROR: isw: volume Raid-HD0_2 is broken
DEBUG: set status of set "isw_ciehjjjfgd" to 16
INFO: Activating GROUP RAID set "isw_ciehjjjfgd"
DEBUG: freeing devices of RAID set "isw_ciehjjjfgd"
DEBUG: freeing device "isw_ciehjjjfgd", path "/dev/sda"
DEBUG: freeing device "isw_ciehjjjfgd", path "/dev/sdc"

Please find attached my "dmraid -rD" ...

The second disk of the array (sdc) has been unplungged and then
re-plugged before the problem happened... Raid array status is displayed
as "REBUILD" during boot process.

Thanks in advance for your help,

Alex

> Chandler,
>
> please send me the files "dmraid -rD" writes (*.dat, *.size, *.offset)
> in a bzip2'ed tarball named isw-Chandler_Garruth.tar.bz2 for
> investigation.
>
> Regards,
> Heinz
>
> On Wed, Jul 06, 2005 at 04:59:48PM -0400, Chandler Carruth wrote:
> > Hello,
> >=20
> > I am attempting to install Gentoo Linux on a box with a RAID0 Array.
> > This is a brand new box, with Intel's ICH7 chipset, and accompanying
> > fake-RAID chip. The RAID array works in Windows, but despite all my
> > attempts, I cannot get it working in Linux. I am now using a LiveCD
> > designed specifically to run on boxes with fake-RAID arrays. The
various
> > software versions are:
> >=20
> > * Grub 0.96
> > * device-mapper version 1.00.19
> > * dmraid version 1.0.0.rc6
> >=20
> > This is the most recent version I have been able to find. I am
> > attempting to compile a binary of dmraid version 1.0.0.rc8, but I am
> > doubtful about this solving the problem. Any ideas would be welcome.
=3D]
> >=20
> > # dmraid --debug --verbose -ay
> > DEBUG: _find_set: searching isw_bhibhdiifc
> > DEBUG: _find_set: not found isw_bhibhdiifc
> > ERROR: isw: volume ARRAY is broken
> > DEBUG: _find_set: searching isw_bhibhdiifc
> > DEBUG: _find_set: found isw_bhibhdiifc
> > ERROR: isw: volume ARRAY is broken
> > DEBUG : set status of set "isw_bhibhdiifc" to 16
> > INFO: Activating GROUP RAID set "isw_bhibhdiifc"
> > DEBUG: freeing devices of RAID set "isw_bhibhdiifc"
> > DEBUG: freeing device "isw_bhibhdiifc", path "/dev/sda"
> > DEBUG: freeing device "isw_bhibhdiifc", path "/dev/sda"
> >=20
> > Please, any idea as to how to setup this RAID array?



------_=_NextPart_001_01C591FE.C78CAF3B
Content-Type: application/octet-stream;
	name="isw-Alexandre_Berge.tar.bz2"
Content-Transfer-Encoding: base64
Content-Description: isw-Alexandre_Berge.tar.bz2
Content-Disposition: attachment;
	filename="isw-Alexandre_Berge.tar.bz2"

QlpoOTFBWSZTWex2/8gAAj//t//0EMVEE//5fG5YgO+lntAAEEAgYACACAoASBxAAfzoBEcAwjCa
YhgEAyAGEaZMmEYCGhwDCMJpiGAQDIAYRpkyYRgIaCKqZGKeppoaZGhtR6gAAAAABptEbUBUkiaE
npppMgDRoyNAGgaZAaDQD1DRmOkua6l6k45KWay5wqdLpnWpjXycqWbMsisqIXNktCYLlkZ1QjOo
uVCaUs889WHUISIlGO0LGtyqWysQLEKTLUVZjIbpRoXtKiztqWUpkbb8LzGm8xBgUU31rPMc7BVz
7opNKoflrycklyeBXpe98nxXm2U+0mJwmJtl6dyTMmwIzNdLA6ykk4HA4Hr7LQSbrPJvGu3szO1m
STfZWLWxyWvZZLzSpxszvLmwuWk7K2pokuZF+bFeY5L5MGe1qaqoYUwUthTOlzVky5C2SSseFZG4
pmOaY3EvMrITaOKTmyaHGe1e2XE9LB+2pNo+DUPYYN1xrNK5qnPbknz5KqqxmrJ3J8z9L4LCl4KH
bKjfXCcS8iyF5YjlXAXzAFckWgtBMU04eeCmHcHJLprrKuqXCwLZFqrnrGt1fVaBtmMYlzUZVkJS
BbCzGJYEayxFc4CyUcrlL4/yhOw/4u5IpwoSHY7f+QA=

------_=_NextPart_001_01C591FE.C78CAF3B
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C591FE.C78CAF3B--
