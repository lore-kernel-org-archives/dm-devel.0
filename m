From: Andy <genanr@emsphone.com>
Subject: Re: multipath-tools and queue-length/service-time path
	selectors oops
Date: Mon, 14 Sep 2009 10:12:51 -0500
Message-ID: <20090914151251.GA17421@thumper2>
References: <20090911213435.GA1590@thumper2> <4AADA753.6000205@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AADA753.6000205@ct.jp.nec.com>
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

On Mon, Sep 14, 2009 at 11:15:47AM +0900, Kiyoshi Ueda wrote:
> Hi Andy,
> 
> Thank you for reporting this.
> 
> On 2009/09/12 6:34 +0900, Andy wrote:
> > When I try to change the path selector in multipath.conf to queue-length or
> > service-time I get a kernel oops.
> 
> I'd like to see the information of your environment, so could you
> give me the followings?


This is a test system, so there is no problem try things out on it.

version information:

Distribution : Debian squeeze/sid
kernel: 2.6.31

multipath-tools v0.4.9 (04/04, 2009)

dmsetup --version
Library version:   1.02.36 (2009-08-06)
Driver version:    4.15.0


multipath.conf part:

multipath {
	wwid 			350002ac000020246
	path_grouping_policy	multibus
	# path_selector		"round-robin 0"
	path_selector		"queue-length"
	rr_min_io		8	# u02 io count
	alias 			u02 
}

Round-robin dmsetup table:

u02: 0 209715200 multipath 0 0 1 1 round-robin 0 4 1 8:224 8 8:64 8 8:144 8 65:48 8 
u01: 0 73400304 linear 254:0 0
u01: 73400304 73400304 linear 254:4 0
u01: 146800608 52428784 linear 254:2 0
u01: 199229392 41943024 linear 254:3 0
u01_vm4: 0 41943040 multipath 0 0 1 1 round-robin 0 4 1 8:240 1 8:80 1 8:160 1 65:64 1 
u01_vm3: 0 52428800 multipath 0 0 1 1 round-robin 0 4 1 8:208 1 8:48 1 8:128 1 65:32 1 
u01_vm2: 0 73400320 multipath 0 0 1 1 round-robin 0 4 1 8:192 1 8:32 1 8:112 1 65:16 1 
u01_vm1: 0 73400320 multipath 0 0 1 1 round-robin 0 4 1 8:176 1 8:16 1 8:96 1 65:0 1 

Round-robin multipath -v3 :

Sep 14 09:45:31 | loop0: device node name blacklisted
Sep 14 09:45:31 | loop1: device node name blacklisted
Sep 14 09:45:31 | loop2: device node name blacklisted
Sep 14 09:45:31 | loop3: device node name blacklisted
Sep 14 09:45:31 | loop4: device node name blacklisted
Sep 14 09:45:31 | loop5: device node name blacklisted
Sep 14 09:45:31 | loop6: device node name blacklisted
Sep 14 09:45:31 | loop7: device node name blacklisted
Sep 14 09:45:31 | hda: device node name blacklisted
Sep 14 09:45:31 | sda: not found in pathvec
Sep 14 09:45:31 | sda: mask = 0x1f
Sep 14 09:45:31 | sda: dev_t = 8:0
Sep 14 09:45:31 | sda: size = 142082048
Sep 14 09:45:31 | sda: subsystem = scsi
Sep 14 09:45:31 | sda: vendor = DELL
Sep 14 09:45:31 | sda: product = PERC 5/i
Sep 14 09:45:31 | sda: rev = 1.03
Sep 14 09:45:31 | sda: h:b:t:l = 0:2:0:0
Sep 14 09:45:31 | sda: serial = 009534df7894e2720f00fe5320f0e401
Sep 14 09:45:31 | sda: get_state
Sep 14 09:45:31 | loading /lib64/multipath/libcheckreadsector0.so checker
Sep 14 09:45:31 | sda: path checker = readsector0 (config file default)
Sep 14 09:45:31 | sda: state = running
Sep 14 09:45:31 | sda: state = 3
Sep 14 09:45:31 | sda: prio = const (config file default)
Sep 14 09:45:31 | sda: const prio = 1
Sep 14 09:45:31 | sda: getuid = /sbin/scsi_id -g -u -s /block/%n (config file default)
Sep 14 09:45:31 | sda: uid = 36001e4f02053fe000f72e29478df3495 (callout)
Sep 14 09:45:31 | sdb: not found in pathvec
Sep 14 09:45:31 | sdb: mask = 0x1f
Sep 14 09:45:31 | sdb: dev_t = 8:16
Sep 14 09:45:31 | sdb: size = 73400320
Sep 14 09:45:31 | sdb: subsystem = scsi
Sep 14 09:45:31 | sdb: vendor = 3PARdata
Sep 14 09:45:31 | sdb: product = VV
Sep 14 09:45:31 | sdb: rev = 0000
Sep 14 09:45:31 | sdb: h:b:t:l = 1:0:0:0
Sep 14 09:45:31 | sdb: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdb: serial = 00ED0246
Sep 14 09:45:31 | sdb: get_state
Sep 14 09:45:31 | sdb: path checker = directio (controller setting)
Sep 14 09:45:31 | sdb: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdb: state = 3
Sep 14 09:45:31 | sdb: prio = const (controller setting)
Sep 14 09:45:31 | sdb: const prio = 1
Sep 14 09:45:31 | sdb: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdb: uid = 350002ac000ed0246 (callout)
Sep 14 09:45:31 | sdc: not found in pathvec
Sep 14 09:45:31 | sdc: mask = 0x1f
Sep 14 09:45:31 | sdc: dev_t = 8:32
Sep 14 09:45:31 | sdc: size = 73400320
Sep 14 09:45:31 | sdc: subsystem = scsi
Sep 14 09:45:31 | sdc: vendor = 3PARdata
Sep 14 09:45:31 | sdc: product = VV
Sep 14 09:45:31 | sdc: rev = 0000
Sep 14 09:45:31 | sdc: h:b:t:l = 1:0:0:1
Sep 14 09:45:31 | sdc: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdc: serial = 00EE0246
Sep 14 09:45:31 | sdc: get_state
Sep 14 09:45:31 | sdc: path checker = directio (controller setting)
Sep 14 09:45:31 | sdc: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdc: state = 3
Sep 14 09:45:31 | sdc: prio = const (controller setting)
Sep 14 09:45:31 | sdc: const prio = 1
Sep 14 09:45:31 | sdc: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdc: uid = 350002ac000ee0246 (callout)
Sep 14 09:45:31 | sdd: not found in pathvec
Sep 14 09:45:31 | sdd: mask = 0x1f
Sep 14 09:45:31 | sdd: dev_t = 8:48
Sep 14 09:45:31 | sdd: size = 52428800
Sep 14 09:45:31 | sdd: subsystem = scsi
Sep 14 09:45:31 | sdd: vendor = 3PARdata
Sep 14 09:45:31 | sdd: product = VV
Sep 14 09:45:31 | sdd: rev = 0000
Sep 14 09:45:31 | sdd: h:b:t:l = 1:0:0:2
Sep 14 09:45:31 | sdd: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdd: serial = 01260246
Sep 14 09:45:31 | sdd: get_state
Sep 14 09:45:31 | sdd: path checker = directio (controller setting)
Sep 14 09:45:31 | sdd: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdd: state = 3
Sep 14 09:45:31 | sdd: prio = const (controller setting)
Sep 14 09:45:31 | sdd: const prio = 1
Sep 14 09:45:31 | sdd: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdd: uid = 350002ac001260246 (callout)
Sep 14 09:45:31 | sde: not found in pathvec
Sep 14 09:45:31 | sde: mask = 0x1f
Sep 14 09:45:31 | sde: dev_t = 8:64
Sep 14 09:45:31 | sde: size = 209715200
Sep 14 09:45:31 | sde: subsystem = scsi
Sep 14 09:45:31 | sde: vendor = 3PARdata
Sep 14 09:45:31 | sde: product = VV
Sep 14 09:45:31 | sde: rev = 0000
Sep 14 09:45:31 | sde: h:b:t:l = 1:0:0:3
Sep 14 09:45:31 | sde: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sde: serial = 00020246
Sep 14 09:45:31 | sde: get_state
Sep 14 09:45:31 | sde: path checker = directio (controller setting)
Sep 14 09:45:31 | sde: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sde: state = 3
Sep 14 09:45:31 | sde: prio = const (controller setting)
Sep 14 09:45:31 | sde: const prio = 1
Sep 14 09:45:31 | sde: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sde: uid = 350002ac000020246 (callout)
Sep 14 09:45:31 | sdf: not found in pathvec
Sep 14 09:45:31 | sdf: mask = 0x1f
Sep 14 09:45:31 | sdf: dev_t = 8:80
Sep 14 09:45:31 | sdf: size = 41943040
Sep 14 09:45:31 | sdf: subsystem = scsi
Sep 14 09:45:31 | sdf: vendor = 3PARdata
Sep 14 09:45:31 | sdf: product = VV
Sep 14 09:45:31 | sdf: rev = 0000
Sep 14 09:45:31 | sdf: h:b:t:l = 1:0:0:4
Sep 14 09:45:31 | sdf: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdf: serial = 01670246
Sep 14 09:45:31 | sdf: get_state
Sep 14 09:45:31 | sdf: path checker = directio (controller setting)
Sep 14 09:45:31 | sdf: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdf: state = 3
Sep 14 09:45:31 | sdf: prio = const (controller setting)
Sep 14 09:45:31 | sdf: const prio = 1
Sep 14 09:45:31 | sdf: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdf: uid = 350002ac001670246 (callout)
Sep 14 09:45:31 | sdg: not found in pathvec
Sep 14 09:45:31 | sdg: mask = 0x1f
Sep 14 09:45:31 | sdg: dev_t = 8:96
Sep 14 09:45:31 | sdg: size = 73400320
Sep 14 09:45:31 | sdg: subsystem = scsi
Sep 14 09:45:31 | sdg: vendor = 3PARdata
Sep 14 09:45:31 | sdg: product = VV
Sep 14 09:45:31 | sdg: rev = 0000
Sep 14 09:45:31 | sdg: h:b:t:l = 1:0:1:0
Sep 14 09:45:31 | sdg: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdg: serial = 00ED0246
Sep 14 09:45:31 | sdg: get_state
Sep 14 09:45:31 | sdg: path checker = directio (controller setting)
Sep 14 09:45:31 | sdg: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdg: state = 3
Sep 14 09:45:31 | sdg: prio = const (controller setting)
Sep 14 09:45:31 | sdg: const prio = 1
Sep 14 09:45:31 | sdg: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdg: uid = 350002ac000ed0246 (callout)
Sep 14 09:45:31 | sdh: not found in pathvec
Sep 14 09:45:31 | sdh: mask = 0x1f
Sep 14 09:45:31 | sdh: dev_t = 8:112
Sep 14 09:45:31 | sdh: size = 73400320
Sep 14 09:45:31 | sdh: subsystem = scsi
Sep 14 09:45:31 | sdh: vendor = 3PARdata
Sep 14 09:45:31 | sdh: product = VV
Sep 14 09:45:31 | sdh: rev = 0000
Sep 14 09:45:31 | sdh: h:b:t:l = 1:0:1:1
Sep 14 09:45:31 | sdh: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdh: serial = 00EE0246
Sep 14 09:45:31 | sdh: get_state
Sep 14 09:45:31 | sdh: path checker = directio (controller setting)
Sep 14 09:45:31 | sdh: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdh: state = 3
Sep 14 09:45:31 | sdh: prio = const (controller setting)
Sep 14 09:45:31 | sdh: const prio = 1
Sep 14 09:45:31 | sdh: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdh: uid = 350002ac000ee0246 (callout)
Sep 14 09:45:31 | sdi: not found in pathvec
Sep 14 09:45:31 | sdi: mask = 0x1f
Sep 14 09:45:31 | sdi: dev_t = 8:128
Sep 14 09:45:31 | sdi: size = 52428800
Sep 14 09:45:31 | sdi: subsystem = scsi
Sep 14 09:45:31 | sdi: vendor = 3PARdata
Sep 14 09:45:31 | sdi: product = VV
Sep 14 09:45:31 | sdi: rev = 0000
Sep 14 09:45:31 | sdi: h:b:t:l = 1:0:1:2
Sep 14 09:45:31 | sdi: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdi: serial = 01260246
Sep 14 09:45:31 | sdi: get_state
Sep 14 09:45:31 | sdi: path checker = directio (controller setting)
Sep 14 09:45:31 | sdi: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdi: state = 3
Sep 14 09:45:31 | sdi: prio = const (controller setting)
Sep 14 09:45:31 | sdi: const prio = 1
Sep 14 09:45:31 | sdi: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdi: uid = 350002ac001260246 (callout)
Sep 14 09:45:31 | sdj: not found in pathvec
Sep 14 09:45:31 | sdj: mask = 0x1f
Sep 14 09:45:31 | sdj: dev_t = 8:144
Sep 14 09:45:31 | sdj: size = 209715200
Sep 14 09:45:31 | sdj: subsystem = scsi
Sep 14 09:45:31 | sdj: vendor = 3PARdata
Sep 14 09:45:31 | sdj: product = VV
Sep 14 09:45:31 | sdj: rev = 0000
Sep 14 09:45:31 | sdj: h:b:t:l = 1:0:1:3
Sep 14 09:45:31 | sdj: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdj: serial = 00020246
Sep 14 09:45:31 | sdj: get_state
Sep 14 09:45:31 | sdj: path checker = directio (controller setting)
Sep 14 09:45:31 | sdj: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdj: state = 3
Sep 14 09:45:31 | sdj: prio = const (controller setting)
Sep 14 09:45:31 | sdj: const prio = 1
Sep 14 09:45:31 | sdj: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdj: uid = 350002ac000020246 (callout)
Sep 14 09:45:31 | sdk: not found in pathvec
Sep 14 09:45:31 | sdk: mask = 0x1f
Sep 14 09:45:31 | sdk: dev_t = 8:160
Sep 14 09:45:31 | sdk: size = 41943040
Sep 14 09:45:31 | sdk: subsystem = scsi
Sep 14 09:45:31 | sdk: vendor = 3PARdata
Sep 14 09:45:31 | sdk: product = VV
Sep 14 09:45:31 | sdk: rev = 0000
Sep 14 09:45:31 | sdk: h:b:t:l = 1:0:1:4
Sep 14 09:45:31 | sdk: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdk: serial = 01670246
Sep 14 09:45:31 | sdk: get_state
Sep 14 09:45:31 | sdk: path checker = directio (controller setting)
Sep 14 09:45:31 | sdk: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdk: state = 3
Sep 14 09:45:31 | sdk: prio = const (controller setting)
Sep 14 09:45:31 | sdk: const prio = 1
Sep 14 09:45:31 | sdk: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdk: uid = 350002ac001670246 (callout)
Sep 14 09:45:31 | dm-0: device node name blacklisted
Sep 14 09:45:31 | dm-1: device node name blacklisted
Sep 14 09:45:31 | dm-2: device node name blacklisted
Sep 14 09:45:31 | dm-3: device node name blacklisted
Sep 14 09:45:31 | dm-4: device node name blacklisted
Sep 14 09:45:31 | sdl: not found in pathvec
Sep 14 09:45:31 | sdl: mask = 0x1f
Sep 14 09:45:31 | sdl: dev_t = 8:176
Sep 14 09:45:31 | sdl: size = 73400320
Sep 14 09:45:31 | sdl: subsystem = scsi
Sep 14 09:45:31 | sdl: vendor = 3PARdata
Sep 14 09:45:31 | sdl: product = VV
Sep 14 09:45:31 | sdl: rev = 0000
Sep 14 09:45:31 | sdl: h:b:t:l = 2:0:0:0
Sep 14 09:45:31 | sdl: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdl: serial = 00ED0246
Sep 14 09:45:31 | sdl: get_state
Sep 14 09:45:31 | sdl: path checker = directio (controller setting)
Sep 14 09:45:31 | sdl: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdl: state = 3
Sep 14 09:45:31 | sdl: prio = const (controller setting)
Sep 14 09:45:31 | sdl: const prio = 1
Sep 14 09:45:31 | sdl: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdl: uid = 350002ac000ed0246 (callout)
Sep 14 09:45:31 | sdm: not found in pathvec
Sep 14 09:45:31 | sdm: mask = 0x1f
Sep 14 09:45:31 | sdm: dev_t = 8:192
Sep 14 09:45:31 | sdm: size = 73400320
Sep 14 09:45:31 | sdm: subsystem = scsi
Sep 14 09:45:31 | sdm: vendor = 3PARdata
Sep 14 09:45:31 | sdm: product = VV
Sep 14 09:45:31 | sdm: rev = 0000
Sep 14 09:45:31 | sdm: h:b:t:l = 2:0:0:1
Sep 14 09:45:31 | sdm: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdm: serial = 00EE0246
Sep 14 09:45:31 | sdm: get_state
Sep 14 09:45:31 | sdm: path checker = directio (controller setting)
Sep 14 09:45:31 | sdm: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdm: state = 3
Sep 14 09:45:31 | sdm: prio = const (controller setting)
Sep 14 09:45:31 | sdm: const prio = 1
Sep 14 09:45:31 | sdm: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdm: uid = 350002ac000ee0246 (callout)
Sep 14 09:45:31 | sdn: not found in pathvec
Sep 14 09:45:31 | sdn: mask = 0x1f
Sep 14 09:45:31 | sdn: dev_t = 8:208
Sep 14 09:45:31 | sdn: size = 52428800
Sep 14 09:45:31 | sdn: subsystem = scsi
Sep 14 09:45:31 | sdn: vendor = 3PARdata
Sep 14 09:45:31 | sdn: product = VV
Sep 14 09:45:31 | sdn: rev = 0000
Sep 14 09:45:31 | sdn: h:b:t:l = 2:0:0:2
Sep 14 09:45:31 | sdn: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdn: serial = 01260246
Sep 14 09:45:31 | sdn: get_state
Sep 14 09:45:31 | sdn: path checker = directio (controller setting)
Sep 14 09:45:31 | sdn: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdn: state = 3
Sep 14 09:45:31 | sdn: prio = const (controller setting)
Sep 14 09:45:31 | sdn: const prio = 1
Sep 14 09:45:31 | sdn: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdn: uid = 350002ac001260246 (callout)
Sep 14 09:45:31 | sdo: not found in pathvec
Sep 14 09:45:31 | sdo: mask = 0x1f
Sep 14 09:45:31 | sdo: dev_t = 8:224
Sep 14 09:45:31 | sdo: size = 209715200
Sep 14 09:45:31 | sdo: subsystem = scsi
Sep 14 09:45:31 | sdo: vendor = 3PARdata
Sep 14 09:45:31 | sdo: product = VV
Sep 14 09:45:31 | sdo: rev = 0000
Sep 14 09:45:31 | sdo: h:b:t:l = 2:0:0:3
Sep 14 09:45:31 | sdo: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdo: serial = 00020246
Sep 14 09:45:31 | sdo: get_state
Sep 14 09:45:31 | sdo: path checker = directio (controller setting)
Sep 14 09:45:31 | sdo: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdo: state = 3
Sep 14 09:45:31 | sdo: prio = const (controller setting)
Sep 14 09:45:31 | sdo: const prio = 1
Sep 14 09:45:31 | sdo: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdo: uid = 350002ac000020246 (callout)
Sep 14 09:45:31 | sdq: not found in pathvec
Sep 14 09:45:31 | sdq: mask = 0x1f
Sep 14 09:45:31 | sdq: dev_t = 65:0
Sep 14 09:45:31 | sdq: size = 73400320
Sep 14 09:45:31 | sdq: subsystem = scsi
Sep 14 09:45:31 | sdq: vendor = 3PARdata
Sep 14 09:45:31 | sdq: product = VV
Sep 14 09:45:31 | sdq: rev = 0000
Sep 14 09:45:31 | sdq: h:b:t:l = 2:0:1:0
Sep 14 09:45:31 | sdq: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdq: serial = 00ED0246
Sep 14 09:45:31 | sdq: get_state
Sep 14 09:45:31 | sdq: path checker = directio (controller setting)
Sep 14 09:45:31 | sdq: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdq: state = 3
Sep 14 09:45:31 | sdq: prio = const (controller setting)
Sep 14 09:45:31 | sdq: const prio = 1
Sep 14 09:45:31 | sdq: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdq: uid = 350002ac000ed0246 (callout)
Sep 14 09:45:31 | sdp: not found in pathvec
Sep 14 09:45:31 | sdp: mask = 0x1f
Sep 14 09:45:31 | sdp: dev_t = 8:240
Sep 14 09:45:31 | sdp: size = 41943040
Sep 14 09:45:31 | sdp: subsystem = scsi
Sep 14 09:45:31 | sdp: vendor = 3PARdata
Sep 14 09:45:31 | sdp: product = VV
Sep 14 09:45:31 | sdp: rev = 0000
Sep 14 09:45:31 | sdp: h:b:t:l = 2:0:0:4
Sep 14 09:45:31 | sdp: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdp: serial = 01670246
Sep 14 09:45:31 | sdp: get_state
Sep 14 09:45:31 | sdp: path checker = directio (controller setting)
Sep 14 09:45:31 | sdp: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdp: state = 3
Sep 14 09:45:31 | sdp: prio = const (controller setting)
Sep 14 09:45:31 | sdp: const prio = 1
Sep 14 09:45:31 | sdp: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdp: uid = 350002ac001670246 (callout)
Sep 14 09:45:31 | sdr: not found in pathvec
Sep 14 09:45:31 | sdr: mask = 0x1f
Sep 14 09:45:31 | sdr: dev_t = 65:16
Sep 14 09:45:31 | sdr: size = 73400320
Sep 14 09:45:31 | sdr: subsystem = scsi
Sep 14 09:45:31 | sdr: vendor = 3PARdata
Sep 14 09:45:31 | sdr: product = VV
Sep 14 09:45:31 | sdr: rev = 0000
Sep 14 09:45:31 | sdr: h:b:t:l = 2:0:1:1
Sep 14 09:45:31 | sdr: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdr: serial = 00EE0246
Sep 14 09:45:31 | sdr: get_state
Sep 14 09:45:31 | sdr: path checker = directio (controller setting)
Sep 14 09:45:31 | sdr: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdr: state = 3
Sep 14 09:45:31 | sdr: prio = const (controller setting)
Sep 14 09:45:31 | sdr: const prio = 1
Sep 14 09:45:31 | sdr: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdr: uid = 350002ac000ee0246 (callout)
Sep 14 09:45:31 | sds: not found in pathvec
Sep 14 09:45:31 | sds: mask = 0x1f
Sep 14 09:45:31 | sds: dev_t = 65:32
Sep 14 09:45:31 | sds: size = 52428800
Sep 14 09:45:31 | sds: subsystem = scsi
Sep 14 09:45:31 | sds: vendor = 3PARdata
Sep 14 09:45:31 | sds: product = VV
Sep 14 09:45:31 | sds: rev = 0000
Sep 14 09:45:31 | sds: h:b:t:l = 2:0:1:2
Sep 14 09:45:31 | sds: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sds: serial = 01260246
Sep 14 09:45:31 | sds: get_state
Sep 14 09:45:31 | sds: path checker = directio (controller setting)
Sep 14 09:45:31 | sds: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sds: state = 3
Sep 14 09:45:31 | sds: prio = const (controller setting)
Sep 14 09:45:31 | sds: const prio = 1
Sep 14 09:45:31 | sds: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sds: uid = 350002ac001260246 (callout)
Sep 14 09:45:31 | sdt: not found in pathvec
Sep 14 09:45:31 | sdt: mask = 0x1f
Sep 14 09:45:31 | sdt: dev_t = 65:48
Sep 14 09:45:31 | sdt: size = 209715200
Sep 14 09:45:31 | sdt: subsystem = scsi
Sep 14 09:45:31 | sdt: vendor = 3PARdata
Sep 14 09:45:31 | sdt: product = VV
Sep 14 09:45:31 | sdt: rev = 0000
Sep 14 09:45:31 | sdt: h:b:t:l = 2:0:1:3
Sep 14 09:45:31 | sdt: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdt: serial = 00020246
Sep 14 09:45:31 | sdt: get_state
Sep 14 09:45:31 | sdt: path checker = directio (controller setting)
Sep 14 09:45:31 | sdt: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdt: state = 3
Sep 14 09:45:31 | sdt: prio = const (controller setting)
Sep 14 09:45:31 | sdt: const prio = 1
Sep 14 09:45:31 | sdt: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdt: uid = 350002ac000020246 (callout)
Sep 14 09:45:31 | sdu: not found in pathvec
Sep 14 09:45:31 | sdu: mask = 0x1f
Sep 14 09:45:31 | sdu: dev_t = 65:64
Sep 14 09:45:31 | sdu: size = 41943040
Sep 14 09:45:31 | sdu: subsystem = scsi
Sep 14 09:45:31 | sdu: vendor = 3PARdata
Sep 14 09:45:31 | sdu: product = VV
Sep 14 09:45:31 | sdu: rev = 0000
Sep 14 09:45:31 | sdu: h:b:t:l = 2:0:1:4
Sep 14 09:45:31 | sdu: tgt_node_name = 0x2ff70002ac00024
Sep 14 09:45:31 | sdu: serial = 01670246
Sep 14 09:45:31 | sdu: get_state
Sep 14 09:45:31 | sdu: path checker = directio (controller setting)
Sep 14 09:45:31 | sdu: state = running
Sep 14 09:45:31 | directio: starting new request
Sep 14 09:45:31 | directio: io finished 4096/0
Sep 14 09:45:31 | sdu: state = 3
Sep 14 09:45:31 | sdu: prio = const (controller setting)
Sep 14 09:45:31 | sdu: const prio = 1
Sep 14 09:45:31 | sdu: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 09:45:31 | sdu: uid = 350002ac001670246 (callout)
Sep 14 09:45:31 | dm-5: device node name blacklisted
===== paths list =====
uuid                              hcil    dev dev_t pri dm_st chk_st vend/prod
36001e4f02053fe000f72e29478df3495 0:2:0:0 sda 8:0   1   undef ready  DELL,PERC
350002ac000ed0246                 1:0:0:0 sdb 8:16  1   undef ready  3PARdata,
350002ac000ee0246                 1:0:0:1 sdc 8:32  1   undef ready  3PARdata,
350002ac001260246                 1:0:0:2 sdd 8:48  1   undef ready  3PARdata,
350002ac000020246                 1:0:0:3 sde 8:64  1   undef ready  3PARdata,
350002ac001670246                 1:0:0:4 sdf 8:80  1   undef ready  3PARdata,
350002ac000ed0246                 1:0:1:0 sdg 8:96  1   undef ready  3PARdata,
350002ac000ee0246                 1:0:1:1 sdh 8:112 1   undef ready  3PARdata,
350002ac001260246                 1:0:1:2 sdi 8:128 1   undef ready  3PARdata,
350002ac000020246                 1:0:1:3 sdj 8:144 1   undef ready  3PARdata,
350002ac001670246                 1:0:1:4 sdk 8:160 1   undef ready  3PARdata,
350002ac000ed0246                 2:0:0:0 sdl 8:176 1   undef ready  3PARdata,
350002ac000ee0246                 2:0:0:1 sdm 8:192 1   undef ready  3PARdata,
350002ac001260246                 2:0:0:2 sdn 8:208 1   undef ready  3PARdata,
350002ac000020246                 2:0:0:3 sdo 8:224 1   undef ready  3PARdata,
350002ac000ed0246                 2:0:1:0 sdq 65:0  1   undef ready  3PARdata,
350002ac001670246                 2:0:0:4 sdp 8:240 1   undef ready  3PARdata,
350002ac000ee0246                 2:0:1:1 sdr 65:16 1   undef ready  3PARdata,
350002ac001260246                 2:0:1:2 sds 65:32 1   undef ready  3PARdata,
350002ac000020246                 2:0:1:3 sdt 65:48 1   undef ready  3PARdata,
350002ac001670246                 2:0:1:4 sdu 65:64 1   undef ready  3PARdata,
Sep 14 09:45:31 | params = 0 0 1 1 round-robin 0 4 1 8:224 8 8:64 8 8:144 8 65:48 8 
Sep 14 09:45:31 | status = 2 0 0 0 1 1 A 0 4 0 8:224 A 0 8:64 A 0 8:144 A 0 65:48 A 0 
Sep 14 09:45:31 | params = 0 0 1 1 round-robin 0 4 1 8:240 1 8:80 1 8:160 1 65:64 1 
Sep 14 09:45:31 | status = 2 0 0 0 1 1 A 0 4 0 8:240 A 0 8:80 A 0 8:160 A 0 65:64 A 0 
Sep 14 09:45:31 | params = 0 0 1 1 round-robin 0 4 1 8:208 1 8:48 1 8:128 1 65:32 1 
Sep 14 09:45:31 | status = 2 0 0 0 1 1 A 0 4 0 8:208 A 0 8:48 A 0 8:128 A 0 65:32 A 0 
Sep 14 09:45:31 | params = 0 0 1 1 round-robin 0 4 1 8:192 1 8:32 1 8:112 1 65:16 1 
Sep 14 09:45:31 | status = 2 0 0 0 1 1 A 0 4 0 8:192 A 0 8:32 A 0 8:112 A 0 65:16 A 0 
Sep 14 09:45:31 | params = 0 0 1 1 round-robin 0 4 1 8:176 1 8:16 1 8:96 1 65:0 1 
Sep 14 09:45:31 | status = 2 0 0 0 1 1 A 0 4 0 8:176 A 0 8:16 A 0 8:96 A 0 65:0 A 0 
Sep 14 09:45:31 | sda: ownership set to 36001e4f02053fe000f72e29478df3495
Sep 14 09:45:31 | sda: not found in pathvec
Sep 14 09:45:31 | sda: mask = 0xc
Sep 14 09:45:31 | sda: get_state
Sep 14 09:45:31 | sda: state = running
Sep 14 09:45:31 | sda: state = 3
Sep 14 09:45:31 | sda: const prio = 1
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: pgfailover = -1 (internal default)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: pgpolicy = multibus (config file default)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: selector = round-robin 0 (internal default)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: features = 0 (internal default)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: hwhandler = 0 (internal default)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: rr_weight = 1 (internal default)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: minio = 8 (config file default)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: no_path_retry = NONE (internal default)
Sep 14 09:45:31 | pg_timeout = NONE (internal default)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: set ACT_CREATE (map does not exist)
Sep 14 09:45:31 | 36001e4f02053fe000f72e29478df3495: domap (0) failure for create/reload map

Round-robin multipath -ll

u02 (350002ac000020246) dm-1 3PARdata,VV
size=100G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:0:3 sdo 8:224 active ready running
  |- 1:0:0:3 sde 8:64  active ready running
  |- 1:0:1:3 sdj 8:144 active ready running
  `- 2:0:1:3 sdt 65:48 active ready running
u01_vm4 (350002ac001670246) dm-3 3PARdata,VV
size=20G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:0:4 sdp 8:240 active ready running
  |- 1:0:0:4 sdf 8:80  active ready running
  |- 1:0:1:4 sdk 8:160 active ready running
  `- 2:0:1:4 sdu 65:64 active ready running
u01_vm3 (350002ac001260246) dm-2 3PARdata,VV
size=25G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:0:2 sdn 8:208 active ready running
  |- 1:0:0:2 sdd 8:48  active ready running
  |- 1:0:1:2 sdi 8:128 active ready running
  `- 2:0:1:2 sds 65:32 active ready running
u01_vm2 (350002ac000ee0246) dm-4 3PARdata,VV
size=35G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:0:1 sdm 8:192 active ready running
  |- 1:0:0:1 sdc 8:32  active ready running
  |- 1:0:1:1 sdh 8:112 active ready running
  `- 2:0:1:1 sdr 65:16 active ready running
u01_vm1 (350002ac000ed0246) dm-0 3PARdata,VV
size=35G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:0:0 sdl 8:176 active ready running
  |- 1:0:0:0 sdb 8:16  active ready running
  |- 1:0:1:0 sdg 8:96  active ready running
  `- 2:0:1:0 sdq 65:0  active ready running


queue-length multipath -v3 (after multipathd causes a segfault):

Sep 14 10:04:27 | loop0: device node name blacklisted
Sep 14 10:04:27 | loop1: device node name blacklisted
Sep 14 10:04:27 | loop2: device node name blacklisted
Sep 14 10:04:27 | loop3: device node name blacklisted
Sep 14 10:04:27 | loop4: device node name blacklisted
Sep 14 10:04:27 | loop5: device node name blacklisted
Sep 14 10:04:27 | loop6: device node name blacklisted
Sep 14 10:04:27 | loop7: device node name blacklisted
Sep 14 10:04:27 | hda: device node name blacklisted
Sep 14 10:04:27 | sda: not found in pathvec
Sep 14 10:04:27 | sda: mask = 0x1f
Sep 14 10:04:27 | sda: dev_t = 8:0
Sep 14 10:04:27 | sda: size = 142082048
Sep 14 10:04:27 | sda: subsystem = scsi
Sep 14 10:04:27 | sda: vendor = DELL
Sep 14 10:04:27 | sda: product = PERC 5/i
Sep 14 10:04:27 | sda: rev = 1.03
Sep 14 10:04:27 | sda: h:b:t:l = 0:2:0:0
Sep 14 10:04:27 | sda: serial = 009534df7894e2720f00fe5320f0e401
Sep 14 10:04:27 | sda: get_state
Sep 14 10:04:27 | loading /lib64/multipath/libcheckreadsector0.so checker
Sep 14 10:04:27 | sda: path checker = readsector0 (config file default)
Sep 14 10:04:27 | sda: state = running
Sep 14 10:04:27 | sda: state = 3
Sep 14 10:04:27 | sda: prio = const (config file default)
Sep 14 10:04:27 | sda: const prio = 1
Sep 14 10:04:27 | sda: getuid = /sbin/scsi_id -g -u -s /block/%n (config file default)
Sep 14 10:04:27 | sda: uid = 36001e4f02053fe000f72e29478df3495 (callout)
Sep 14 10:04:27 | sdb: not found in pathvec
Sep 14 10:04:27 | sdb: mask = 0x1f
Sep 14 10:04:27 | sdb: dev_t = 8:16
Sep 14 10:04:27 | sdb: size = 73400320
Sep 14 10:04:27 | sdb: subsystem = scsi
Sep 14 10:04:27 | sdb: vendor = 3PARdata
Sep 14 10:04:27 | sdb: product = VV
Sep 14 10:04:27 | sdb: rev = 0000
Sep 14 10:04:27 | sdb: h:b:t:l = 1:0:0:0
Sep 14 10:04:27 | sdb: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdb: serial = 00ED0246
Sep 14 10:04:27 | sdb: get_state
Sep 14 10:04:27 | sdb: path checker = directio (controller setting)
Sep 14 10:04:27 | sdb: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdb: state = 3
Sep 14 10:04:27 | sdb: prio = const (controller setting)
Sep 14 10:04:27 | sdb: const prio = 1
Sep 14 10:04:27 | sdb: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdb: uid = 350002ac000ed0246 (callout)
Sep 14 10:04:27 | sdc: not found in pathvec
Sep 14 10:04:27 | sdc: mask = 0x1f
Sep 14 10:04:27 | sdc: dev_t = 8:32
Sep 14 10:04:27 | sdc: size = 73400320
Sep 14 10:04:27 | sdc: subsystem = scsi
Sep 14 10:04:27 | sdc: vendor = 3PARdata
Sep 14 10:04:27 | sdc: product = VV
Sep 14 10:04:27 | sdc: rev = 0000
Sep 14 10:04:27 | sdc: h:b:t:l = 1:0:0:1
Sep 14 10:04:27 | sdc: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdc: serial = 00EE0246
Sep 14 10:04:27 | sdc: get_state
Sep 14 10:04:27 | sdc: path checker = directio (controller setting)
Sep 14 10:04:27 | sdc: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdc: state = 3
Sep 14 10:04:27 | sdc: prio = const (controller setting)
Sep 14 10:04:27 | sdc: const prio = 1
Sep 14 10:04:27 | sdc: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdc: uid = 350002ac000ee0246 (callout)
Sep 14 10:04:27 | sdd: not found in pathvec
Sep 14 10:04:27 | sdd: mask = 0x1f
Sep 14 10:04:27 | sdd: dev_t = 8:48
Sep 14 10:04:27 | sdd: size = 52428800
Sep 14 10:04:27 | sdd: subsystem = scsi
Sep 14 10:04:27 | sdd: vendor = 3PARdata
Sep 14 10:04:27 | sdd: product = VV
Sep 14 10:04:27 | sdd: rev = 0000
Sep 14 10:04:27 | sdd: h:b:t:l = 1:0:0:2
Sep 14 10:04:27 | sdd: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdd: serial = 01260246
Sep 14 10:04:27 | sdd: get_state
Sep 14 10:04:27 | sdd: path checker = directio (controller setting)
Sep 14 10:04:27 | sdd: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdd: state = 3
Sep 14 10:04:27 | sdd: prio = const (controller setting)
Sep 14 10:04:27 | sdd: const prio = 1
Sep 14 10:04:27 | sdd: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdd: uid = 350002ac001260246 (callout)
Sep 14 10:04:27 | sde: not found in pathvec
Sep 14 10:04:27 | sde: mask = 0x1f
Sep 14 10:04:27 | sde: dev_t = 8:64
Sep 14 10:04:27 | sde: size = 209715200
Sep 14 10:04:27 | sde: subsystem = scsi
Sep 14 10:04:27 | sde: vendor = 3PARdata
Sep 14 10:04:27 | sde: product = VV
Sep 14 10:04:27 | sde: rev = 0000
Sep 14 10:04:27 | sde: h:b:t:l = 1:0:0:3
Sep 14 10:04:27 | sde: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sde: serial = 00020246
Sep 14 10:04:27 | sde: get_state
Sep 14 10:04:27 | sde: path checker = directio (controller setting)
Sep 14 10:04:27 | sde: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sde: state = 3
Sep 14 10:04:27 | sde: prio = const (controller setting)
Sep 14 10:04:27 | sde: const prio = 1
Sep 14 10:04:27 | sde: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sde: uid = 350002ac000020246 (callout)
Sep 14 10:04:27 | sdf: not found in pathvec
Sep 14 10:04:27 | sdf: mask = 0x1f
Sep 14 10:04:27 | sdf: dev_t = 8:80
Sep 14 10:04:27 | sdf: size = 41943040
Sep 14 10:04:27 | sdf: subsystem = scsi
Sep 14 10:04:27 | sdf: vendor = 3PARdata
Sep 14 10:04:27 | sdf: product = VV
Sep 14 10:04:27 | sdf: rev = 0000
Sep 14 10:04:27 | sdf: h:b:t:l = 1:0:0:4
Sep 14 10:04:27 | sdf: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdf: serial = 01670246
Sep 14 10:04:27 | sdf: get_state
Sep 14 10:04:27 | sdf: path checker = directio (controller setting)
Sep 14 10:04:27 | sdf: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdf: state = 3
Sep 14 10:04:27 | sdf: prio = const (controller setting)
Sep 14 10:04:27 | sdf: const prio = 1
Sep 14 10:04:27 | sdf: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdf: uid = 350002ac001670246 (callout)
Sep 14 10:04:27 | sdg: not found in pathvec
Sep 14 10:04:27 | sdg: mask = 0x1f
Sep 14 10:04:27 | sdg: dev_t = 8:96
Sep 14 10:04:27 | sdg: size = 73400320
Sep 14 10:04:27 | sdg: subsystem = scsi
Sep 14 10:04:27 | sdg: vendor = 3PARdata
Sep 14 10:04:27 | sdg: product = VV
Sep 14 10:04:27 | sdg: rev = 0000
Sep 14 10:04:27 | sdg: h:b:t:l = 1:0:1:0
Sep 14 10:04:27 | sdg: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdg: serial = 00ED0246
Sep 14 10:04:27 | sdg: get_state
Sep 14 10:04:27 | sdg: path checker = directio (controller setting)
Sep 14 10:04:27 | sdg: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdg: state = 3
Sep 14 10:04:27 | sdg: prio = const (controller setting)
Sep 14 10:04:27 | sdg: const prio = 1
Sep 14 10:04:27 | sdg: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdg: uid = 350002ac000ed0246 (callout)
Sep 14 10:04:27 | sdh: not found in pathvec
Sep 14 10:04:27 | sdh: mask = 0x1f
Sep 14 10:04:27 | sdh: dev_t = 8:112
Sep 14 10:04:27 | sdh: size = 73400320
Sep 14 10:04:27 | sdh: subsystem = scsi
Sep 14 10:04:27 | sdh: vendor = 3PARdata
Sep 14 10:04:27 | sdh: product = VV
Sep 14 10:04:27 | sdh: rev = 0000
Sep 14 10:04:27 | sdh: h:b:t:l = 1:0:1:1
Sep 14 10:04:27 | sdh: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdh: serial = 00EE0246
Sep 14 10:04:27 | sdh: get_state
Sep 14 10:04:27 | sdh: path checker = directio (controller setting)
Sep 14 10:04:27 | sdh: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdh: state = 3
Sep 14 10:04:27 | sdh: prio = const (controller setting)
Sep 14 10:04:27 | sdh: const prio = 1
Sep 14 10:04:27 | sdh: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdh: uid = 350002ac000ee0246 (callout)
Sep 14 10:04:27 | sdi: not found in pathvec
Sep 14 10:04:27 | sdi: mask = 0x1f
Sep 14 10:04:27 | sdi: dev_t = 8:128
Sep 14 10:04:27 | sdi: size = 52428800
Sep 14 10:04:27 | sdi: subsystem = scsi
Sep 14 10:04:27 | sdi: vendor = 3PARdata
Sep 14 10:04:27 | sdi: product = VV
Sep 14 10:04:27 | sdi: rev = 0000
Sep 14 10:04:27 | sdi: h:b:t:l = 1:0:1:2
Sep 14 10:04:27 | sdi: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdi: serial = 01260246
Sep 14 10:04:27 | sdi: get_state
Sep 14 10:04:27 | sdi: path checker = directio (controller setting)
Sep 14 10:04:27 | sdi: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdi: state = 3
Sep 14 10:04:27 | sdi: prio = const (controller setting)
Sep 14 10:04:27 | sdi: const prio = 1
Sep 14 10:04:27 | sdi: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdi: uid = 350002ac001260246 (callout)
Sep 14 10:04:27 | sdj: not found in pathvec
Sep 14 10:04:27 | sdj: mask = 0x1f
Sep 14 10:04:27 | sdj: dev_t = 8:144
Sep 14 10:04:27 | sdj: size = 209715200
Sep 14 10:04:27 | sdj: subsystem = scsi
Sep 14 10:04:27 | sdj: vendor = 3PARdata
Sep 14 10:04:27 | sdj: product = VV
Sep 14 10:04:27 | sdj: rev = 0000
Sep 14 10:04:27 | sdj: h:b:t:l = 1:0:1:3
Sep 14 10:04:27 | sdj: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdj: serial = 00020246
Sep 14 10:04:27 | sdj: get_state
Sep 14 10:04:27 | sdj: path checker = directio (controller setting)
Sep 14 10:04:27 | sdj: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdj: state = 3
Sep 14 10:04:27 | sdj: prio = const (controller setting)
Sep 14 10:04:27 | sdj: const prio = 1
Sep 14 10:04:27 | sdj: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdj: uid = 350002ac000020246 (callout)
Sep 14 10:04:27 | sdk: not found in pathvec
Sep 14 10:04:27 | sdk: mask = 0x1f
Sep 14 10:04:27 | sdk: dev_t = 8:160
Sep 14 10:04:27 | sdk: size = 41943040
Sep 14 10:04:27 | sdk: subsystem = scsi
Sep 14 10:04:27 | sdk: vendor = 3PARdata
Sep 14 10:04:27 | sdk: product = VV
Sep 14 10:04:27 | sdk: rev = 0000
Sep 14 10:04:27 | sdk: h:b:t:l = 1:0:1:4
Sep 14 10:04:27 | sdk: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdk: serial = 01670246
Sep 14 10:04:27 | sdk: get_state
Sep 14 10:04:27 | sdk: path checker = directio (controller setting)
Sep 14 10:04:27 | sdk: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdk: state = 3
Sep 14 10:04:27 | sdk: prio = const (controller setting)
Sep 14 10:04:27 | sdk: const prio = 1
Sep 14 10:04:27 | sdk: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdk: uid = 350002ac001670246 (callout)
Sep 14 10:04:27 | dm-0: device node name blacklisted
Sep 14 10:04:27 | dm-1: device node name blacklisted
Sep 14 10:04:27 | dm-2: device node name blacklisted
Sep 14 10:04:27 | dm-3: device node name blacklisted
Sep 14 10:04:27 | dm-4: device node name blacklisted
Sep 14 10:04:27 | sdl: not found in pathvec
Sep 14 10:04:27 | sdl: mask = 0x1f
Sep 14 10:04:27 | sdl: dev_t = 8:176
Sep 14 10:04:27 | sdl: size = 73400320
Sep 14 10:04:27 | sdl: subsystem = scsi
Sep 14 10:04:27 | sdl: vendor = 3PARdata
Sep 14 10:04:27 | sdl: product = VV
Sep 14 10:04:27 | sdl: rev = 0000
Sep 14 10:04:27 | sdl: h:b:t:l = 2:0:0:0
Sep 14 10:04:27 | sdl: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdl: serial = 00ED0246
Sep 14 10:04:27 | sdl: get_state
Sep 14 10:04:27 | sdl: path checker = directio (controller setting)
Sep 14 10:04:27 | sdl: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdl: state = 3
Sep 14 10:04:27 | sdl: prio = const (controller setting)
Sep 14 10:04:27 | sdl: const prio = 1
Sep 14 10:04:27 | sdl: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdl: uid = 350002ac000ed0246 (callout)
Sep 14 10:04:27 | sdm: not found in pathvec
Sep 14 10:04:27 | sdm: mask = 0x1f
Sep 14 10:04:27 | sdm: dev_t = 8:192
Sep 14 10:04:27 | sdm: size = 73400320
Sep 14 10:04:27 | sdm: subsystem = scsi
Sep 14 10:04:27 | sdm: vendor = 3PARdata
Sep 14 10:04:27 | sdm: product = VV
Sep 14 10:04:27 | sdm: rev = 0000
Sep 14 10:04:27 | sdm: h:b:t:l = 2:0:0:1
Sep 14 10:04:27 | sdm: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdm: serial = 00EE0246
Sep 14 10:04:27 | sdm: get_state
Sep 14 10:04:27 | sdm: path checker = directio (controller setting)
Sep 14 10:04:27 | sdm: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdm: state = 3
Sep 14 10:04:27 | sdm: prio = const (controller setting)
Sep 14 10:04:27 | sdm: const prio = 1
Sep 14 10:04:27 | sdm: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdm: uid = 350002ac000ee0246 (callout)
Sep 14 10:04:27 | sdn: not found in pathvec
Sep 14 10:04:27 | sdn: mask = 0x1f
Sep 14 10:04:27 | sdn: dev_t = 8:208
Sep 14 10:04:27 | sdn: size = 52428800
Sep 14 10:04:27 | sdn: subsystem = scsi
Sep 14 10:04:27 | sdn: vendor = 3PARdata
Sep 14 10:04:27 | sdn: product = VV
Sep 14 10:04:27 | sdn: rev = 0000
Sep 14 10:04:27 | sdn: h:b:t:l = 2:0:0:2
Sep 14 10:04:27 | sdn: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdn: serial = 01260246
Sep 14 10:04:27 | sdn: get_state
Sep 14 10:04:27 | sdn: path checker = directio (controller setting)
Sep 14 10:04:27 | sdn: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdn: state = 3
Sep 14 10:04:27 | sdn: prio = const (controller setting)
Sep 14 10:04:27 | sdn: const prio = 1
Sep 14 10:04:27 | sdn: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdn: uid = 350002ac001260246 (callout)
Sep 14 10:04:27 | sdo: not found in pathvec
Sep 14 10:04:27 | sdo: mask = 0x1f
Sep 14 10:04:27 | sdo: dev_t = 8:224
Sep 14 10:04:27 | sdo: size = 209715200
Sep 14 10:04:27 | sdo: subsystem = scsi
Sep 14 10:04:27 | sdo: vendor = 3PARdata
Sep 14 10:04:27 | sdo: product = VV
Sep 14 10:04:27 | sdo: rev = 0000
Sep 14 10:04:27 | sdo: h:b:t:l = 2:0:0:3
Sep 14 10:04:27 | sdo: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdo: serial = 00020246
Sep 14 10:04:27 | sdo: get_state
Sep 14 10:04:27 | sdo: path checker = directio (controller setting)
Sep 14 10:04:27 | sdo: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdo: state = 3
Sep 14 10:04:27 | sdo: prio = const (controller setting)
Sep 14 10:04:27 | sdo: const prio = 1
Sep 14 10:04:27 | sdo: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdo: uid = 350002ac000020246 (callout)
Sep 14 10:04:27 | sdq: not found in pathvec
Sep 14 10:04:27 | sdq: mask = 0x1f
Sep 14 10:04:27 | sdq: dev_t = 65:0
Sep 14 10:04:27 | sdq: size = 73400320
Sep 14 10:04:27 | sdq: subsystem = scsi
Sep 14 10:04:27 | sdq: vendor = 3PARdata
Sep 14 10:04:27 | sdq: product = VV
Sep 14 10:04:27 | sdq: rev = 0000
Sep 14 10:04:27 | sdq: h:b:t:l = 2:0:1:0
Sep 14 10:04:27 | sdq: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdq: serial = 00ED0246
Sep 14 10:04:27 | sdq: get_state
Sep 14 10:04:27 | sdq: path checker = directio (controller setting)
Sep 14 10:04:27 | sdq: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdq: state = 3
Sep 14 10:04:27 | sdq: prio = const (controller setting)
Sep 14 10:04:27 | sdq: const prio = 1
Sep 14 10:04:27 | sdq: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdq: uid = 350002ac000ed0246 (callout)
Sep 14 10:04:27 | sdp: not found in pathvec
Sep 14 10:04:27 | sdp: mask = 0x1f
Sep 14 10:04:27 | sdp: dev_t = 8:240
Sep 14 10:04:27 | sdp: size = 41943040
Sep 14 10:04:27 | sdp: subsystem = scsi
Sep 14 10:04:27 | sdp: vendor = 3PARdata
Sep 14 10:04:27 | sdp: product = VV
Sep 14 10:04:27 | sdp: rev = 0000
Sep 14 10:04:27 | sdp: h:b:t:l = 2:0:0:4
Sep 14 10:04:27 | sdp: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdp: serial = 01670246
Sep 14 10:04:27 | sdp: get_state
Sep 14 10:04:27 | sdp: path checker = directio (controller setting)
Sep 14 10:04:27 | sdp: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdp: state = 3
Sep 14 10:04:27 | sdp: prio = const (controller setting)
Sep 14 10:04:27 | sdp: const prio = 1
Sep 14 10:04:27 | sdp: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdp: uid = 350002ac001670246 (callout)
Sep 14 10:04:27 | sdr: not found in pathvec
Sep 14 10:04:27 | sdr: mask = 0x1f
Sep 14 10:04:27 | sdr: dev_t = 65:16
Sep 14 10:04:27 | sdr: size = 73400320
Sep 14 10:04:27 | sdr: subsystem = scsi
Sep 14 10:04:27 | sdr: vendor = 3PARdata
Sep 14 10:04:27 | sdr: product = VV
Sep 14 10:04:27 | sdr: rev = 0000
Sep 14 10:04:27 | sdr: h:b:t:l = 2:0:1:1
Sep 14 10:04:27 | sdr: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdr: serial = 00EE0246
Sep 14 10:04:27 | sdr: get_state
Sep 14 10:04:27 | sdr: path checker = directio (controller setting)
Sep 14 10:04:27 | sdr: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdr: state = 3
Sep 14 10:04:27 | sdr: prio = const (controller setting)
Sep 14 10:04:27 | sdr: const prio = 1
Sep 14 10:04:27 | sdr: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdr: uid = 350002ac000ee0246 (callout)
Sep 14 10:04:27 | sds: not found in pathvec
Sep 14 10:04:27 | sds: mask = 0x1f
Sep 14 10:04:27 | sds: dev_t = 65:32
Sep 14 10:04:27 | sds: size = 52428800
Sep 14 10:04:27 | sds: subsystem = scsi
Sep 14 10:04:27 | sds: vendor = 3PARdata
Sep 14 10:04:27 | sds: product = VV
Sep 14 10:04:27 | sds: rev = 0000
Sep 14 10:04:27 | sds: h:b:t:l = 2:0:1:2
Sep 14 10:04:27 | sds: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sds: serial = 01260246
Sep 14 10:04:27 | sds: get_state
Sep 14 10:04:27 | sds: path checker = directio (controller setting)
Sep 14 10:04:27 | sds: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sds: state = 3
Sep 14 10:04:27 | sds: prio = const (controller setting)
Sep 14 10:04:27 | sds: const prio = 1
Sep 14 10:04:27 | sds: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sds: uid = 350002ac001260246 (callout)
Sep 14 10:04:27 | sdt: not found in pathvec
Sep 14 10:04:27 | sdt: mask = 0x1f
Sep 14 10:04:27 | sdt: dev_t = 65:48
Sep 14 10:04:27 | sdt: size = 209715200
Sep 14 10:04:27 | sdt: subsystem = scsi
Sep 14 10:04:27 | sdt: vendor = 3PARdata
Sep 14 10:04:27 | sdt: product = VV
Sep 14 10:04:27 | sdt: rev = 0000
Sep 14 10:04:27 | sdt: h:b:t:l = 2:0:1:3
Sep 14 10:04:27 | sdt: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdt: serial = 00020246
Sep 14 10:04:27 | sdt: get_state
Sep 14 10:04:27 | sdt: path checker = directio (controller setting)
Sep 14 10:04:27 | sdt: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdt: state = 3
Sep 14 10:04:27 | sdt: prio = const (controller setting)
Sep 14 10:04:27 | sdt: const prio = 1
Sep 14 10:04:27 | sdt: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdt: uid = 350002ac000020246 (callout)
Sep 14 10:04:27 | sdu: not found in pathvec
Sep 14 10:04:27 | sdu: mask = 0x1f
Sep 14 10:04:27 | sdu: dev_t = 65:64
Sep 14 10:04:27 | sdu: size = 41943040
Sep 14 10:04:27 | sdu: subsystem = scsi
Sep 14 10:04:27 | sdu: vendor = 3PARdata
Sep 14 10:04:27 | sdu: product = VV
Sep 14 10:04:27 | sdu: rev = 0000
Sep 14 10:04:27 | sdu: h:b:t:l = 2:0:1:4
Sep 14 10:04:27 | sdu: tgt_node_name = 0x2ff70002ac00024
Sep 14 10:04:27 | sdu: serial = 01670246
Sep 14 10:04:27 | sdu: get_state
Sep 14 10:04:27 | sdu: path checker = directio (controller setting)
Sep 14 10:04:27 | sdu: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdu: state = 3
Sep 14 10:04:27 | sdu: prio = const (controller setting)
Sep 14 10:04:27 | sdu: const prio = 1
Sep 14 10:04:27 | sdu: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 14 10:04:27 | sdu: uid = 350002ac001670246 (callout)
Sep 14 10:04:27 | dm-5: device node name blacklisted
Sep 14 10:04:27 | dm-6: device node name blacklisted
===== paths list =====
uuid                              hcil    dev dev_t pri dm_st chk_st vend/prod
36001e4f02053fe000f72e29478df3495 0:2:0:0 sda 8:0   1   undef ready  DELL,PERC
350002ac000ed0246                 1:0:0:0 sdb 8:16  1   undef ready  3PARdata,
350002ac000ee0246                 1:0:0:1 sdc 8:32  1   undef ready  3PARdata,
350002ac001260246                 1:0:0:2 sdd 8:48  1   undef ready  3PARdata,
350002ac000020246                 1:0:0:3 sde 8:64  1   undef ready  3PARdata,
350002ac001670246                 1:0:0:4 sdf 8:80  1   undef ready  3PARdata,
350002ac000ed0246                 1:0:1:0 sdg 8:96  1   undef ready  3PARdata,
350002ac000ee0246                 1:0:1:1 sdh 8:112 1   undef ready  3PARdata,
350002ac001260246                 1:0:1:2 sdi 8:128 1   undef ready  3PARdata,
350002ac000020246                 1:0:1:3 sdj 8:144 1   undef ready  3PARdata,
350002ac001670246                 1:0:1:4 sdk 8:160 1   undef ready  3PARdata,
350002ac000ed0246                 2:0:0:0 sdl 8:176 1   undef ready  3PARdata,
350002ac000ee0246                 2:0:0:1 sdm 8:192 1   undef ready  3PARdata,
350002ac001260246                 2:0:0:2 sdn 8:208 1   undef ready  3PARdata,
350002ac000020246                 2:0:0:3 sdo 8:224 1   undef ready  3PARdata,
350002ac000ed0246                 2:0:1:0 sdq 65:0  1   undef ready  3PARdata,
350002ac001670246                 2:0:0:4 sdp 8:240 1   undef ready  3PARdata,
350002ac000ee0246                 2:0:1:1 sdr 65:16 1   undef ready  3PARdata,
350002ac001260246                 2:0:1:2 sds 65:32 1   undef ready  3PARdata,
350002ac000020246                 2:0:1:3 sdt 65:48 1   undef ready  3PARdata,
350002ac001670246                 2:0:1:4 sdu 65:64 1   undef ready  3PARdata,
Sep 14 10:04:27 | params = 0 0 1 1 round-robin 0 4 1 8:240 1 8:80 1 8:160 1 65:64 1 
Sep 14 10:04:27 | status = 2 0 0 0 1 1 A 0 4 0 8:240 A 0 8:80 A 0 8:160 A 0 65:64 A 0 
Sep 14 10:04:27 | params = 0 0 1 1 round-robin 0 4 1 8:208 1 8:48 1 8:128 1 65:32 1 
Sep 14 10:04:27 | status = 2 0 0 0 1 1 A 0 4 0 8:208 A 0 8:48 A 0 8:128 A 0 65:32 A 0 
Sep 14 10:04:27 | params = 0 0 1 1 round-robin 0 4 1 8:192 1 8:32 1 8:112 1 65:16 1 
Sep 14 10:04:27 | status = 2 0 0 0 1 1 A 0 4 0 8:192 A 0 8:32 A 0 8:112 A 0 65:16 A 0 
Sep 14 10:04:27 | params = 0 0 1 1 round-robin 0 4 1 8:176 1 8:16 1 8:96 1 65:0 1 
Sep 14 10:04:27 | status = 2 0 0 0 1 1 A 0 4 0 8:176 A 0 8:16 A 0 8:96 A 0 65:0 A 0 
Sep 14 10:04:27 | sda: ownership set to 36001e4f02053fe000f72e29478df3495
Sep 14 10:04:27 | sda: not found in pathvec
Sep 14 10:04:27 | sda: mask = 0xc
Sep 14 10:04:27 | sda: get_state
Sep 14 10:04:27 | sda: state = running
Sep 14 10:04:27 | sda: state = 3
Sep 14 10:04:27 | sda: const prio = 1
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: pgfailover = -1 (internal default)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: pgpolicy = multibus (config file default)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: selector = round-robin 0 (internal default)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: features = 0 (internal default)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: hwhandler = 0 (internal default)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: rr_weight = 1 (internal default)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: minio = 8 (config file default)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: no_path_retry = NONE (internal default)
Sep 14 10:04:27 | pg_timeout = NONE (internal default)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: set ACT_CREATE (map does not exist)
Sep 14 10:04:27 | 36001e4f02053fe000f72e29478df3495: domap (0) failure for create/reload map
Sep 14 10:04:27 | sde: ownership set to u02
Sep 14 10:04:27 | sde: not found in pathvec
Sep 14 10:04:27 | sde: mask = 0xc
Sep 14 10:04:27 | sde: get_state
Sep 14 10:04:27 | sde: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sde: state = 3
Sep 14 10:04:27 | sde: const prio = 1
Sep 14 10:04:27 | sdj: ownership set to u02
Sep 14 10:04:27 | sdj: not found in pathvec
Sep 14 10:04:27 | sdj: mask = 0xc
Sep 14 10:04:27 | sdj: get_state
Sep 14 10:04:27 | sdj: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdj: state = 3
Sep 14 10:04:27 | sdj: const prio = 1
Sep 14 10:04:27 | sdo: ownership set to u02
Sep 14 10:04:27 | sdo: not found in pathvec
Sep 14 10:04:27 | sdo: mask = 0xc
Sep 14 10:04:27 | sdo: get_state
Sep 14 10:04:27 | sdo: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdo: state = 3
Sep 14 10:04:27 | sdo: const prio = 1
Sep 14 10:04:27 | sdt: ownership set to u02
Sep 14 10:04:27 | sdt: not found in pathvec
Sep 14 10:04:27 | sdt: mask = 0xc
Sep 14 10:04:27 | sdt: get_state
Sep 14 10:04:27 | sdt: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdt: state = 3
Sep 14 10:04:27 | sdt: const prio = 1
Sep 14 10:04:27 | u02: pgfailover = -1 (internal default)
Sep 14 10:04:27 | u02: pgpolicy = multibus (LUN setting)
Sep 14 10:04:27 | u02: selector = queue-length (LUN setting)
Sep 14 10:04:27 | u02: features = 0 (controller setting)
Sep 14 10:04:27 | u02: hwhandler = 0 (controller setting)
Sep 14 10:04:27 | u02: rr_weight = 1 (controller setting)
Sep 14 10:04:27 | u02: minio = 8 (LUN setting)
Sep 14 10:04:27 | u02: no_path_retry = NONE (internal default)
Sep 14 10:04:27 | pg_timeout = NONE (internal default)
Sep 14 10:04:27 | u02: set ACT_CREATE (map does not exist)
Sep 14 10:04:27 | u02: map already present
Sep 14 10:04:27 | u02: domap (0) failure for create/reload map
Sep 14 10:04:27 | sde: ownership set to u02
Sep 14 10:04:27 | sde: not found in pathvec
Sep 14 10:04:27 | sde: mask = 0xc
Sep 14 10:04:27 | sde: get_state
Sep 14 10:04:27 | sde: path checker = directio (controller setting)
Sep 14 10:04:27 | sde: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sde: state = 3
Sep 14 10:04:27 | sde: prio = const (controller setting)
Sep 14 10:04:27 | sde: const prio = 1
Sep 14 10:04:27 | sdj: ownership set to u02
Sep 14 10:04:27 | sdj: not found in pathvec
Sep 14 10:04:27 | sdj: mask = 0xc
Sep 14 10:04:27 | sdj: get_state
Sep 14 10:04:27 | sdj: path checker = directio (controller setting)
Sep 14 10:04:27 | sdj: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdj: state = 3
Sep 14 10:04:27 | sdj: prio = const (controller setting)
Sep 14 10:04:27 | sdj: const prio = 1
Sep 14 10:04:27 | sdo: ownership set to u02
Sep 14 10:04:27 | sdo: not found in pathvec
Sep 14 10:04:27 | sdo: mask = 0xc
Sep 14 10:04:27 | sdo: get_state
Sep 14 10:04:27 | sdo: path checker = directio (controller setting)
Sep 14 10:04:27 | sdo: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdo: state = 3
Sep 14 10:04:27 | sdo: prio = const (controller setting)
Sep 14 10:04:27 | sdo: const prio = 1
Sep 14 10:04:27 | sdt: ownership set to u02
Sep 14 10:04:27 | sdt: not found in pathvec
Sep 14 10:04:27 | sdt: mask = 0xc
Sep 14 10:04:27 | sdt: get_state
Sep 14 10:04:27 | sdt: path checker = directio (controller setting)
Sep 14 10:04:27 | sdt: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdt: state = 3
Sep 14 10:04:27 | sdt: prio = const (controller setting)
Sep 14 10:04:27 | sdt: const prio = 1
Sep 14 10:04:27 | u02: pgfailover = -1 (internal default)
Sep 14 10:04:27 | u02: pgpolicy = multibus (LUN setting)
Sep 14 10:04:27 | u02: selector = queue-length (LUN setting)
Sep 14 10:04:27 | u02: features = 0 (controller setting)
Sep 14 10:04:27 | u02: hwhandler = 0 (controller setting)
Sep 14 10:04:27 | u02: rr_weight = 1 (controller setting)
Sep 14 10:04:27 | u02: minio = 8 (LUN setting)
Sep 14 10:04:27 | u02: no_path_retry = NONE (internal default)
Sep 14 10:04:27 | pg_timeout = NONE (internal default)
Sep 14 10:04:27 | u02: set ACT_CREATE (map does not exist)
Sep 14 10:04:27 | u02: map already present
Sep 14 10:04:27 | u02: domap (0) failure for create/reload map
Sep 14 10:04:27 | sde: ownership set to u02
Sep 14 10:04:27 | sde: not found in pathvec
Sep 14 10:04:27 | sde: mask = 0xc
Sep 14 10:04:27 | sde: get_state
Sep 14 10:04:27 | sde: path checker = directio (controller setting)
Sep 14 10:04:27 | sde: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sde: state = 3
Sep 14 10:04:27 | sde: prio = const (controller setting)
Sep 14 10:04:27 | sde: const prio = 1
Sep 14 10:04:27 | sdj: ownership set to u02
Sep 14 10:04:27 | sdj: not found in pathvec
Sep 14 10:04:27 | sdj: mask = 0xc
Sep 14 10:04:27 | sdj: get_state
Sep 14 10:04:27 | sdj: path checker = directio (controller setting)
Sep 14 10:04:27 | sdj: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdj: state = 3
Sep 14 10:04:27 | sdj: prio = const (controller setting)
Sep 14 10:04:27 | sdj: const prio = 1
Sep 14 10:04:27 | sdo: ownership set to u02
Sep 14 10:04:27 | sdo: not found in pathvec
Sep 14 10:04:27 | sdo: mask = 0xc
Sep 14 10:04:27 | sdo: get_state
Sep 14 10:04:27 | sdo: path checker = directio (controller setting)
Sep 14 10:04:27 | sdo: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdo: state = 3
Sep 14 10:04:27 | sdo: prio = const (controller setting)
Sep 14 10:04:27 | sdo: const prio = 1
Sep 14 10:04:27 | sdt: ownership set to u02
Sep 14 10:04:27 | sdt: not found in pathvec
Sep 14 10:04:27 | sdt: mask = 0xc
Sep 14 10:04:27 | sdt: get_state
Sep 14 10:04:27 | sdt: path checker = directio (controller setting)
Sep 14 10:04:27 | sdt: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdt: state = 3
Sep 14 10:04:27 | sdt: prio = const (controller setting)
Sep 14 10:04:27 | sdt: const prio = 1
Sep 14 10:04:27 | u02: pgfailover = -1 (internal default)
Sep 14 10:04:27 | u02: pgpolicy = multibus (LUN setting)
Sep 14 10:04:27 | u02: selector = queue-length (LUN setting)
Sep 14 10:04:27 | u02: features = 0 (controller setting)
Sep 14 10:04:27 | u02: hwhandler = 0 (controller setting)
Sep 14 10:04:27 | u02: rr_weight = 1 (controller setting)
Sep 14 10:04:27 | u02: minio = 8 (LUN setting)
Sep 14 10:04:27 | u02: no_path_retry = NONE (internal default)
Sep 14 10:04:27 | pg_timeout = NONE (internal default)
Sep 14 10:04:27 | u02: set ACT_CREATE (map does not exist)
Sep 14 10:04:27 | u02: map already present
Sep 14 10:04:27 | u02: domap (0) failure for create/reload map
Sep 14 10:04:27 | sde: ownership set to u02
Sep 14 10:04:27 | sde: not found in pathvec
Sep 14 10:04:27 | sde: mask = 0xc
Sep 14 10:04:27 | sde: get_state
Sep 14 10:04:27 | sde: path checker = directio (controller setting)
Sep 14 10:04:27 | sde: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sde: state = 3
Sep 14 10:04:27 | sde: prio = const (controller setting)
Sep 14 10:04:27 | sde: const prio = 1
Sep 14 10:04:27 | sdj: ownership set to u02
Sep 14 10:04:27 | sdj: not found in pathvec
Sep 14 10:04:27 | sdj: mask = 0xc
Sep 14 10:04:27 | sdj: get_state
Sep 14 10:04:27 | sdj: path checker = directio (controller setting)
Sep 14 10:04:27 | sdj: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdj: state = 3
Sep 14 10:04:27 | sdj: prio = const (controller setting)
Sep 14 10:04:27 | sdj: const prio = 1
Sep 14 10:04:27 | sdo: ownership set to u02
Sep 14 10:04:27 | sdo: not found in pathvec
Sep 14 10:04:27 | sdo: mask = 0xc
Sep 14 10:04:27 | sdo: get_state
Sep 14 10:04:27 | sdo: path checker = directio (controller setting)
Sep 14 10:04:27 | sdo: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdo: state = 3
Sep 14 10:04:27 | sdo: prio = const (controller setting)
Sep 14 10:04:27 | sdo: const prio = 1
Sep 14 10:04:27 | sdt: ownership set to u02
Sep 14 10:04:27 | sdt: not found in pathvec
Sep 14 10:04:27 | sdt: mask = 0xc
Sep 14 10:04:27 | sdt: get_state
Sep 14 10:04:27 | sdt: path checker = directio (controller setting)
Sep 14 10:04:27 | sdt: state = running
Sep 14 10:04:27 | directio: starting new request
Sep 14 10:04:27 | directio: io finished 4096/0
Sep 14 10:04:27 | sdt: state = 3
Sep 14 10:04:27 | sdt: prio = const (controller setting)
Sep 14 10:04:27 | sdt: const prio = 1
Sep 14 10:04:27 | u02: pgfailover = -1 (internal default)
Sep 14 10:04:27 | u02: pgpolicy = multibus (LUN setting)
Sep 14 10:04:27 | u02: selector = queue-length (LUN setting)
Sep 14 10:04:27 | u02: features = 0 (controller setting)
Sep 14 10:04:27 | u02: hwhandler = 0 (controller setting)
Sep 14 10:04:27 | u02: rr_weight = 1 (controller setting)
Sep 14 10:04:27 | u02: minio = 8 (LUN setting)
Sep 14 10:04:27 | u02: no_path_retry = NONE (internal default)
Sep 14 10:04:27 | pg_timeout = NONE (internal default)
Sep 14 10:04:27 | u02: set ACT_CREATE (map does not exist)
Sep 14 10:04:27 | u02: map already present
Sep 14 10:04:27 | u02: domap (0) failure for create/reload map
