From: "Paul Cote" <paul.cote@incipient.com>
Subject: Upgrade issues with v4.8
Date: Tue, 6 Nov 2007 18:51:16 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8B8B@exch-2003.incipient.waltham>
References: <20071106225413.GB5668@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20071106225413.GB5668@us.ibm.com>
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


I just recently upgraded to RHEL V4.5 and to Multipath tools V4.8 but
the paths are not being generated. I thought it may be a new
restrictions that would be managed via the multipath.conf file; but all
tweaks that I've made thus far have not made a difference. Falling back
to V4.7 works just fine but I would prefer to stay current with V4.8.

Any thoughts?

Dmesg does show some errors:

SELinux: initialized (dev 0:10, type nfs), uses genfs_contexts
device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table
device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table
device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table
device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table


With v4.7 ... The path list USE TO look like this;

multipathd> show paths
hcil     dev  dev_t  pri dm_st   chk_st  next_check       =20
3:0:0:3  sdaa 65:160 0   [active][ready] XXXXXX.... 75/120=20
3:0:0:4  sdab 65:176 0   [active][ready] XXXXXX.... 74/120=20
3:0:0:5  sdac 65:192 0   [active][ready] XXXXXX.... 72/120=20
3:0:0:6  sdad 65:208 0   [active][ready] XXXXXX.... 74/120=20
3:0:0:7  sdae 65:224 0   [active][ready] XXXXXX.... 74/120=20
3:0:0:8  sdaf 65:240 0   [active][ready] XXXXXX.... 73/120=20
3:0:0:9  sdag 66:0   0   [active][ready] XXXXXX.... 73/120=20
3:0:0:10 sdah 66:16  0   [active][ready] XXXXXX.... 73/120=20
4:0:0:0  sdai 66:32  0   [active][ready] XXXXXXXX.. 101/120
4:0:0:1  sdaj 66:48  0   [active][ready] XXXXXXXX.. 102/120
4:0:0:2  sdak 66:64  0   [active][ready] XXXXXXXX.. 101/120
4:0:0:3  sdal 66:80  0   [active][ready] XXXXXXXX.. 101/120
4:0:0:4  sdam 66:96  0   [active][ready] XXXXXXXX.. 101/120
4:0:0:5  sdan 66:112 0   [active][ready] XXXXXXXX.. 102/120
4:0:0:6  sdao 66:128 0   [active][ready] XXXXXX.... 75/120=20
4:0:0:7  sdap 66:144 0   [active][ready] XXXXXX.... 74/120=20
4:0:0:8  sdaq 66:160 0   [active][ready] XXXXXX.... 76/120=20
4:0:0:9  sdar 66:176 0   [active][ready] XXXXXX.... 76/120=20
4:0:0:10 sdas 66:192 0   [active][ready] XXXXXX.... 77/120=20
0:0:0:0  sda  8:0    0   [undef] [ready] [orphan]         =20
1:0:0:0  sdb  8:16   0   [active][ready] XXXXXX.... 75/120=20
1:0:0:1  sdc  8:32   0   [active][ready] XXXXXX.... 75/120=20
1:0:0:2  sdd  8:48   0   [active][ready] XXXXXX.... 75/120=20
1:0:0:3  sde  8:64   0   [active][ready] XXXXXX.... 75/120=20
1:0:0:4  sdf  8:80   0   [active][ready] XXXXXX.... 74/120=20
1:0:0:5  sdg  8:96   0   [active][ready] XXXXXX.... 72/120=20
1:0:0:6  sdh  8:112  0   [active][ready] XXXXXX.... 74/120=20
1:0:0:7  sdi  8:128  0   [active][ready] XXXXXX.... 74/120=20
1:0:0:8  sdj  8:144  0   [active][ready] XXXXXX.... 73/120=20
1:0:0:9  sdk  8:160  0   [active][ready] XXXXXX.... 73/120=20
1:0:0:10 sdl  8:176  0   [active][ready] XXXXXX.... 73/120=20
2:0:0:0  sdm  8:192  0   [active][ready] XXXXXXXX.. 100/120
2:0:0:1  sdn  8:208  0   [active][ready] XXXXXXXX.. 101/120
2:0:0:2  sdo  8:224  0   [active][ready] XXXXXXXX.. 100/120
2:0:0:3  sdp  8:240  0   [active][ready] XXXXXXXX.. 100/120
2:0:0:4  sdq  65:0   0   [active][ready] XXXXXXXX.. 100/120
2:0:0:5  sdr  65:16  0   [active][ready] XXXXXXXX.. 101/120
2:0:0:6  sds  65:32  0   [active][ready] XXXXXX.... 75/120=20
2:0:0:7  sdt  65:48  0   [active][ready] XXXXXX.... 74/120=20
2:0:0:8  sdu  65:64  0   [active][ready] XXXXXX.... 76/120=20
2:0:0:9  sdv  65:80  0   [active][ready] XXXXXX.... 76/120=20
2:0:0:10 sdw  65:96  0   [active][ready] XXXXXX.... 77/120=20
3:0:0:0  sdx  65:112 0   [active][ready] XXXXXX.... 75/120=20
3:0:0:1  sdy  65:128 0   [active][ready] XXXXXX.... 75/120=20
3:0:0:2  sdz  65:144 0   [active][ready] XXXXXX.... 75/120=20

But with v4.8; the path list is

multipathd> show paths
hcil    dev dev_t  pri dm_st  chk_st  next_check
#:#:#:# sdz 65:144 1   [undef][undef] [orphan] =20
#:#:#:# sdy 65:128 1   [undef][undef] [orphan] =20
#:#:#:# sdx 65:112 1   [undef][undef] [orphan] =20
#:#:#:# sdw 65:96  1   [undef][undef] [orphan] =20
#:#:#:# sdv 65:80  1   [undef][undef] [orphan] =20
#:#:#:# sdu 65:64  1   [undef][undef] [orphan] =20
#:#:#:# sdt 65:48  1   [undef][undef] [orphan] =20
#:#:#:# sds 65:32  1   [undef][undef] [orphan] =20
#:#:#:# sdr 65:16  1   [undef][undef] [orphan] =20
#:#:#:# sdq 65:0   1   [undef][undef] [orphan] =20
#:#:#:# sdp 8:240  1   [undef][undef] [orphan] =20
#:#:#:# sdo 8:224  1   [undef][undef] [orphan] =20
#:#:#:# sdn 8:208  1   [undef][undef] [orphan] =20
#:#:#:# sdm 8:192  1   [undef][undef] [orphan] =20
#:#:#:# sdl 8:176  1   [undef][undef] [orphan] =20
#:#:#:# sdk 8:160  1   [undef][undef] [orphan] =20
#:#:#:# sdj 8:144  1   [undef][undef] [orphan] =20
#:#:#:# sdi 8:128  1   [undef][undef] [orphan] =20
#:#:#:# sdh 8:112  1   [undef][undef] [orphan] =20
#:#:#:# sdg 8:96   1   [undef][undef] [orphan] =20
#:#:#:# sdf 8:80   1   [undef][undef] [orphan] =20
#:#:#:# sde 8:64   1   [undef][undef] [orphan] =20
#:#:#:# sdd 8:48   1   [undef][undef] [orphan] =20
#:#:#:# sdc 8:32   1   [undef][undef] [orphan] =20
#:#:#:# sdb 8:16   1   [undef][undef] [orphan] =20
multipathd>=20
