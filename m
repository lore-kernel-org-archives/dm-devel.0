From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: What license is multipath-tools under
Date: Thu, 28 Jul 2016 00:41:12 +0200
Message-ID: <1a392247-70b6-6fea-5a71-ffacf229fbac@gmail.com>
References: <1469616127.6204.9.camel@debian.org>
	<26bf809d-9e9e-b4ae-9110-a67819246907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <26bf809d-9e9e-b4ae-9110-a67819246907@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rrs@debian.org, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/28/2016 12:19 AM, Xose Vazquez Perez wrote:

> GPL code can not be mixed with LGPL code. So I guess libmultipath/ files are "GPL v2" ???
> 
> 
> multipath/main.c
> Under "GPL v2 or later". It's linked with libmultipath.so and libmpathcmd.so.

For reference, the ldd output(in Fedora-24-x86_64):

libmpathcmd.so.0:
        linux-vdso.so.1 (0x00007ffef04c6000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f104e834000)
        /lib64/ld-linux-x86-64.so.2 (0x00005585327c4000)
libmpathpersist.so.0:
        linux-vdso.so.1 (0x00007ffddd16e000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fa639e39000)
        libdevmapper.so.1.02 => /lib64/libdevmapper.so.1.02 (0x00007fa639bdc000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007fa6399d8000)
        libmultipath.so.0 (0x00007fa63978f000)
        libmpathcmd.so.0 (0x00007fa63958b000)
        libc.so.6 => /lib64/libc.so.6 (0x00007fa6391c9000)
        /lib64/ld-linux-x86-64.so.2 (0x000056519d76e000)
        librt.so.1 => /lib64/librt.so.1 (0x00007fa638fc1000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007fa638d99000)
        libsepol.so.1 => /lib64/libsepol.so.1 (0x00007fa638b01000)
        libudev.so.1 => /lib64/libudev.so.1 (0x00007fa638ae0000)
        libm.so.6 => /lib64/libm.so.6 (0x00007fa6387d5000)
        libsystemd.so.0 => /lib64/libsystemd.so.0 (0x00007fa63874b000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007fa638534000)
        libpcre.so.1 => /lib64/libpcre.so.1 (0x00007fa6382c0000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007fa6380bb000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007fa637ea1000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007fa637c7a000)
        liblz4.so.1 => /lib64/liblz4.so.1 (0x00007fa637a68000)
        libgcrypt.so.20 => /lib64/libgcrypt.so.20 (0x00007fa637782000)
        libgpg-error.so.0 => /lib64/libgpg-error.so.0 (0x00007fa63756d000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007fa637368000)
libmultipath.so.0:
        linux-vdso.so.1 (0x00007ffdd9ea2000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f088a932000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f088a72d000)
        libdevmapper.so.1.02 => /lib64/libdevmapper.so.1.02 (0x00007f088a4d1000)
        libudev.so.1 => /lib64/libudev.so.1 (0x00007f088a4b0000)
        libmpathcmd.so.0 (0x00007f088a2ac000)
        libsystemd.so.0 => /lib64/libsystemd.so.0 (0x00007f088a222000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007f088a00b000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f0889c48000)
        /lib64/ld-linux-x86-64.so.2 (0x0000562501e17000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f0889a40000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f0889819000)
        libsepol.so.1 => /lib64/libsepol.so.1 (0x00007f0889580000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f0889276000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007f0889071000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f0888e56000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007f0888c30000)
        liblz4.so.1 => /lib64/liblz4.so.1 (0x00007f0888a1e000)
        libgcrypt.so.20 => /lib64/libgcrypt.so.20 (0x00007f0888737000)
        libgpg-error.so.0 => /lib64/libgpg-error.so.0 (0x00007f0888523000)
        libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f08882b0000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007f08880aa000)

kpartx:
        linux-vdso.so.1 (0x00007fffc2cd6000)
        libdevmapper.so.1.02 => /lib64/libdevmapper.so.1.02 (0x00007f3cdbfec000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f3cdbc29000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f3cdba21000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f3cdb7fa000)
        libsepol.so.1 => /lib64/libsepol.so.1 (0x00007f3cdb561000)
        libudev.so.1 => /lib64/libudev.so.1 (0x00007f3cdb540000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f3cdb324000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f3cdb019000)
        /lib64/ld-linux-x86-64.so.2 (0x000055e9e4b82000)
        libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f3cdada6000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f3cdaba2000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007f3cda99c000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f3cda782000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007f3cda56b000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007f3cda365000)
mpathpersist:
        linux-vdso.so.1 (0x00007fff6e9b6000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f49c5d65000)
        libdevmapper.so.1.02 => /lib64/libdevmapper.so.1.02 (0x00007f49c5b08000)
        libmpathpersist.so.0 => /home/xose/tmp/mpt/lib64/libmpathpersist.so.0 (0x00007f49c58ff000)
        libmpathcmd.so.0 => /home/xose/tmp/mpt/lib64/libmpathcmd.so.0 (0x00007f49c56fc000)
        libmultipath.so.0 => /home/xose/tmp/mpt/lib64/libmultipath.so.0 (0x00007f49c54b2000)
        libudev.so.1 => /lib64/libudev.so.1 (0x00007f49c5491000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f49c50cf000)
        /lib64/ld-linux-x86-64.so.2 (0x000055c2f7c26000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f49c4ec6000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f49c4c9f000)
        libsepol.so.1 => /lib64/libsepol.so.1 (0x00007f49c4a07000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f49c46fc000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f49c44f8000)
        libsystemd.so.0 => /lib64/libsystemd.so.0 (0x00007f49c446e000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007f49c4256000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007f49c4051000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f49c3e37000)
        libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f49c3bc3000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007f49c399d000)
        liblz4.so.1 => /lib64/liblz4.so.1 (0x00007f49c378b000)
        libgcrypt.so.20 => /lib64/libgcrypt.so.20 (0x00007f49c34a4000)
        libgpg-error.so.0 => /lib64/libgpg-error.so.0 (0x00007f49c3290000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007f49c308b000)
multipath:
        linux-vdso.so.1 (0x00007fff6bebe000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fdc24635000)
        libdevmapper.so.1.02 => /lib64/libdevmapper.so.1.02 (0x00007fdc243d8000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007fdc241d4000)
        libmultipath.so.0 => /home/xose/tmp/mpt/lib64/libmultipath.so.0 (0x00007fdc23f8b000)
        libudev.so.1 => /lib64/libudev.so.1 (0x00007fdc23f69000)
        libmpathcmd.so.0 => /home/xose/tmp/mpt/lib64/libmpathcmd.so.0 (0x00007fdc23d66000)
        libc.so.6 => /lib64/libc.so.6 (0x00007fdc239a4000)
        /lib64/ld-linux-x86-64.so.2 (0x00005650a01da000)
        librt.so.1 => /lib64/librt.so.1 (0x00007fdc2379b000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007fdc23574000)
        libsepol.so.1 => /lib64/libsepol.so.1 (0x00007fdc232dc000)
        libm.so.6 => /lib64/libm.so.6 (0x00007fdc22fd1000)
        libsystemd.so.0 => /lib64/libsystemd.so.0 (0x00007fdc22f47000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007fdc22d30000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007fdc22b2a000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007fdc22910000)
        libpcre.so.1 => /lib64/libpcre.so.1 (0x00007fdc2269d000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007fdc22476000)
        liblz4.so.1 => /lib64/liblz4.so.1 (0x00007fdc22264000)
        libgcrypt.so.20 => /lib64/libgcrypt.so.20 (0x00007fdc21f7e000)
        libgpg-error.so.0 => /lib64/libgpg-error.so.0 (0x00007fdc21d69000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007fdc21b64000)
multipathd:
        linux-vdso.so.1 (0x00007fffca7c3000)
        liburcu.so.2 => /lib64/liburcu.so.2 (0x00007f7031bf0000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f70319d3000)
        libdevmapper.so.1.02 => /lib64/libdevmapper.so.1.02 (0x00007f7031777000)
        libreadline.so.6 => /lib64/libreadline.so.6 (0x00007f703152e000)
        libsystemd.so.0 => /lib64/libsystemd.so.0 (0x00007f70314a3000)
        libudev.so.1 => /lib64/libudev.so.1 (0x00007f7031482000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f703127e000)
        libmultipath.so.0 => /home/xose/tmp/mpt/lib64/libmultipath.so.0 (0x00007f7031034000)
        libmpathpersist.so.0 => /home/xose/tmp/mpt/lib64/libmpathpersist.so.0 (0x00007f7030e2b000)
        libmpathcmd.so.0 => /home/xose/tmp/mpt/lib64/libmpathcmd.so.0 (0x00007f7030c28000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007f7030a10000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f703064e000)
        liburcu-common.so.2 => /lib64/liburcu-common.so.2 (0x00007f703044a000)
        /lib64/ld-linux-x86-64.so.2 (0x000055fed25fa000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f7030241000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f703001a000)
        libsepol.so.1 => /lib64/libsepol.so.1 (0x00007f702fd82000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f702fa77000)
        libtinfo.so.6 => /lib64/libtinfo.so.6 (0x00007f702f84b000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007f702f646000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f702f42b000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007f702f205000)
        liblz4.so.1 => /lib64/liblz4.so.1 (0x00007f702eff3000)
        libgcrypt.so.20 => /lib64/libgcrypt.so.20 (0x00007f702ed0c000)
        libgpg-error.so.0 => /lib64/libgpg-error.so.0 (0x00007f702eaf8000)
        libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f702e884000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007f702e67f000)
