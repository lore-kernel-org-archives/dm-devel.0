From: Andy <genanr@emsphone.com>
Subject: Re: multipath-tools and queue-length/service-time path
	selectors oops
Date: Tue, 15 Sep 2009 09:35:10 -0500
Message-ID: <20090915143509.GA22993@thumper2>
References: <20090911213435.GA1590@thumper2> <4AADA753.6000205@ct.jp.nec.com>
	<20090914151251.GA17421@thumper2> <4AAEF795.9060301@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AAEF795.9060301@ct.jp.nec.com>
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

On Tue, Sep 15, 2009 at 11:10:29AM +0900, Kiyoshi Ueda wrote:
> Hi Andy,
> 
> On 09/15/2009 12:12 AM +0900, Andy wrote:
> 
> OK, thanks.
> Please specify the path_selector part in the same way as
> round-robin like below:
> 
> 	path_selector	"queue-length 0"
> 
> Note that '0' is the required argument which specifies the number
> of path_selector parameters.
> 
> I think this is a bug in the parameter parsing of multipath target
> driver, not queue-length/service-time specific.
> 
I thought I had tried that. But, an informative error message would be nice. 
Now, I have another question. Why does the queue-length selector not use all
my paths?

Sep 15 09:25:44 | loop0: device node name blacklisted
Sep 15 09:25:44 | loop1: device node name blacklisted
Sep 15 09:25:44 | loop2: device node name blacklisted
Sep 15 09:25:44 | loop3: device node name blacklisted
Sep 15 09:25:44 | loop4: device node name blacklisted
Sep 15 09:25:44 | loop5: device node name blacklisted
Sep 15 09:25:44 | loop6: device node name blacklisted
Sep 15 09:25:44 | loop7: device node name blacklisted
Sep 15 09:25:44 | hda: device node name blacklisted
Sep 15 09:25:44 | sda: not found in pathvec
Sep 15 09:25:44 | sda: mask = 0x1f
Sep 15 09:25:44 | sda: dev_t = 8:0
Sep 15 09:25:44 | sda: size = 142082048
Sep 15 09:25:44 | sda: subsystem = scsi
Sep 15 09:25:44 | sda: vendor = DELL
Sep 15 09:25:44 | sda: product = PERC 5/i
Sep 15 09:25:44 | sda: rev = 1.03
Sep 15 09:25:44 | sda: h:b:t:l = 0:2:0:0
Sep 15 09:25:44 | sda: serial = 009534df7894e2720f00fe5320f0e401
Sep 15 09:25:44 | sda: get_state
Sep 15 09:25:44 | loading /lib64/multipath/libcheckreadsector0.so checker
Sep 15 09:25:44 | sda: path checker = readsector0 (config file default)
Sep 15 09:25:44 | sda: state = running
Sep 15 09:25:44 | sda: state = 3
Sep 15 09:25:44 | sda: prio = const (config file default)
Sep 15 09:25:44 | sda: const prio = 1
Sep 15 09:25:44 | sda: getuid = /sbin/scsi_id -g -u -s /block/%n (config file default)
Sep 15 09:25:44 | sda: uid = 36001e4f02053fe000f72e29478df3495 (callout)
Sep 15 09:25:44 | sdb: not found in pathvec
Sep 15 09:25:44 | sdb: mask = 0x1f
Sep 15 09:25:44 | sdb: dev_t = 8:16
Sep 15 09:25:44 | sdb: size = 73400320
Sep 15 09:25:44 | sdb: subsystem = scsi
Sep 15 09:25:44 | sdb: vendor = 3PARdata
Sep 15 09:25:44 | sdb: product = VV
Sep 15 09:25:44 | sdb: rev = 0000
Sep 15 09:25:44 | sdb: h:b:t:l = 1:0:0:0
Sep 15 09:25:44 | sdb: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdb: serial = 00ED0246
Sep 15 09:25:44 | sdb: get_state
Sep 15 09:25:44 | sdb: path checker = directio (controller setting)
Sep 15 09:25:44 | sdb: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdb: state = 3
Sep 15 09:25:44 | sdb: prio = const (controller setting)
Sep 15 09:25:44 | sdb: const prio = 1
Sep 15 09:25:44 | sdb: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdb: uid = 350002ac000ed0246 (callout)
Sep 15 09:25:44 | sdc: not found in pathvec
Sep 15 09:25:44 | sdc: mask = 0x1f
Sep 15 09:25:44 | sdc: dev_t = 8:32
Sep 15 09:25:44 | sdc: size = 73400320
Sep 15 09:25:44 | sdc: subsystem = scsi
Sep 15 09:25:44 | sdc: vendor = 3PARdata
Sep 15 09:25:44 | sdc: product = VV
Sep 15 09:25:44 | sdc: rev = 0000
Sep 15 09:25:44 | sdc: h:b:t:l = 1:0:0:1
Sep 15 09:25:44 | sdc: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdc: serial = 00EE0246
Sep 15 09:25:44 | sdc: get_state
Sep 15 09:25:44 | sdc: path checker = directio (controller setting)
Sep 15 09:25:44 | sdc: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdc: state = 3
Sep 15 09:25:44 | sdc: prio = const (controller setting)
Sep 15 09:25:44 | sdc: const prio = 1
Sep 15 09:25:44 | sdc: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdc: uid = 350002ac000ee0246 (callout)
Sep 15 09:25:44 | sdd: not found in pathvec
Sep 15 09:25:44 | sdd: mask = 0x1f
Sep 15 09:25:44 | sdd: dev_t = 8:48
Sep 15 09:25:44 | sdd: size = 52428800
Sep 15 09:25:44 | sdd: subsystem = scsi
Sep 15 09:25:44 | sdd: vendor = 3PARdata
Sep 15 09:25:44 | sdd: product = VV
Sep 15 09:25:44 | sdd: rev = 0000
Sep 15 09:25:44 | sdd: h:b:t:l = 1:0:0:2
Sep 15 09:25:44 | sdd: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdd: serial = 01260246
Sep 15 09:25:44 | sdd: get_state
Sep 15 09:25:44 | sdd: path checker = directio (controller setting)
Sep 15 09:25:44 | sdd: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdd: state = 3
Sep 15 09:25:44 | sdd: prio = const (controller setting)
Sep 15 09:25:44 | sdd: const prio = 1
Sep 15 09:25:44 | sdd: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdd: uid = 350002ac001260246 (callout)
Sep 15 09:25:44 | sde: not found in pathvec
Sep 15 09:25:44 | sde: mask = 0x1f
Sep 15 09:25:44 | sde: dev_t = 8:64
Sep 15 09:25:44 | sde: size = 209715200
Sep 15 09:25:44 | sde: subsystem = scsi
Sep 15 09:25:44 | sde: vendor = 3PARdata
Sep 15 09:25:44 | sde: product = VV
Sep 15 09:25:44 | sde: rev = 0000
Sep 15 09:25:44 | sde: h:b:t:l = 1:0:0:3
Sep 15 09:25:44 | sde: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sde: serial = 00020246
Sep 15 09:25:44 | sde: get_state
Sep 15 09:25:44 | sde: path checker = directio (controller setting)
Sep 15 09:25:44 | sde: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sde: state = 3
Sep 15 09:25:44 | sde: prio = const (controller setting)
Sep 15 09:25:44 | sde: const prio = 1
Sep 15 09:25:44 | sde: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sde: uid = 350002ac000020246 (callout)
Sep 15 09:25:44 | sdg: not found in pathvec
Sep 15 09:25:44 | sdg: mask = 0x1f
Sep 15 09:25:44 | sdg: dev_t = 8:96
Sep 15 09:25:44 | sdg: size = 73400320
Sep 15 09:25:44 | sdg: subsystem = scsi
Sep 15 09:25:44 | sdg: vendor = 3PARdata
Sep 15 09:25:44 | sdg: product = VV
Sep 15 09:25:44 | sdg: rev = 0000
Sep 15 09:25:44 | sdg: h:b:t:l = 1:0:1:0
Sep 15 09:25:44 | sdg: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdg: serial = 00ED0246
Sep 15 09:25:44 | sdg: get_state
Sep 15 09:25:44 | sdg: path checker = directio (controller setting)
Sep 15 09:25:44 | sdg: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdg: state = 3
Sep 15 09:25:44 | sdg: prio = const (controller setting)
Sep 15 09:25:44 | sdg: const prio = 1
Sep 15 09:25:44 | sdg: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdg: uid = 350002ac000ed0246 (callout)
Sep 15 09:25:44 | sdf: not found in pathvec
Sep 15 09:25:44 | sdf: mask = 0x1f
Sep 15 09:25:44 | sdf: dev_t = 8:80
Sep 15 09:25:44 | sdf: size = 41943040
Sep 15 09:25:44 | sdf: subsystem = scsi
Sep 15 09:25:44 | sdf: vendor = 3PARdata
Sep 15 09:25:44 | sdf: product = VV
Sep 15 09:25:44 | sdf: rev = 0000
Sep 15 09:25:44 | sdf: h:b:t:l = 1:0:0:4
Sep 15 09:25:44 | sdf: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdf: serial = 01670246
Sep 15 09:25:44 | sdf: get_state
Sep 15 09:25:44 | sdf: path checker = directio (controller setting)
Sep 15 09:25:44 | sdf: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdf: state = 3
Sep 15 09:25:44 | sdf: prio = const (controller setting)
Sep 15 09:25:44 | sdf: const prio = 1
Sep 15 09:25:44 | sdf: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdf: uid = 350002ac001670246 (callout)
Sep 15 09:25:44 | sdh: not found in pathvec
Sep 15 09:25:44 | sdh: mask = 0x1f
Sep 15 09:25:44 | sdh: dev_t = 8:112
Sep 15 09:25:44 | sdh: size = 73400320
Sep 15 09:25:44 | sdh: subsystem = scsi
Sep 15 09:25:44 | sdh: vendor = 3PARdata
Sep 15 09:25:44 | sdh: product = VV
Sep 15 09:25:44 | sdh: rev = 0000
Sep 15 09:25:44 | sdh: h:b:t:l = 1:0:1:1
Sep 15 09:25:44 | sdh: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdh: serial = 00EE0246
Sep 15 09:25:44 | sdh: get_state
Sep 15 09:25:44 | sdh: path checker = directio (controller setting)
Sep 15 09:25:44 | sdh: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdh: state = 3
Sep 15 09:25:44 | sdh: prio = const (controller setting)
Sep 15 09:25:44 | sdh: const prio = 1
Sep 15 09:25:44 | sdh: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdh: uid = 350002ac000ee0246 (callout)
Sep 15 09:25:44 | sdi: not found in pathvec
Sep 15 09:25:44 | sdi: mask = 0x1f
Sep 15 09:25:44 | sdi: dev_t = 8:128
Sep 15 09:25:44 | sdi: size = 52428800
Sep 15 09:25:44 | sdi: subsystem = scsi
Sep 15 09:25:44 | sdi: vendor = 3PARdata
Sep 15 09:25:44 | sdi: product = VV
Sep 15 09:25:44 | sdi: rev = 0000
Sep 15 09:25:44 | sdi: h:b:t:l = 1:0:1:2
Sep 15 09:25:44 | sdi: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdi: serial = 01260246
Sep 15 09:25:44 | sdi: get_state
Sep 15 09:25:44 | sdi: path checker = directio (controller setting)
Sep 15 09:25:44 | sdi: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdi: state = 3
Sep 15 09:25:44 | sdi: prio = const (controller setting)
Sep 15 09:25:44 | sdi: const prio = 1
Sep 15 09:25:44 | sdi: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdi: uid = 350002ac001260246 (callout)
Sep 15 09:25:44 | sdj: not found in pathvec
Sep 15 09:25:44 | sdj: mask = 0x1f
Sep 15 09:25:44 | sdj: dev_t = 8:144
Sep 15 09:25:44 | sdj: size = 209715200
Sep 15 09:25:44 | sdj: subsystem = scsi
Sep 15 09:25:44 | sdj: vendor = 3PARdata
Sep 15 09:25:44 | sdj: product = VV
Sep 15 09:25:44 | sdj: rev = 0000
Sep 15 09:25:44 | sdj: h:b:t:l = 1:0:1:3
Sep 15 09:25:44 | sdj: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdj: serial = 00020246
Sep 15 09:25:44 | sdj: get_state
Sep 15 09:25:44 | sdj: path checker = directio (controller setting)
Sep 15 09:25:44 | sdj: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdj: state = 3
Sep 15 09:25:44 | sdj: prio = const (controller setting)
Sep 15 09:25:44 | sdj: const prio = 1
Sep 15 09:25:44 | sdj: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdj: uid = 350002ac000020246 (callout)
Sep 15 09:25:44 | sdk: not found in pathvec
Sep 15 09:25:44 | sdk: mask = 0x1f
Sep 15 09:25:44 | sdk: dev_t = 8:160
Sep 15 09:25:44 | sdk: size = 41943040
Sep 15 09:25:44 | sdk: subsystem = scsi
Sep 15 09:25:44 | sdk: vendor = 3PARdata
Sep 15 09:25:44 | sdk: product = VV
Sep 15 09:25:44 | sdk: rev = 0000
Sep 15 09:25:44 | sdk: h:b:t:l = 1:0:1:4
Sep 15 09:25:44 | sdk: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdk: serial = 01670246
Sep 15 09:25:44 | sdk: get_state
Sep 15 09:25:44 | sdk: path checker = directio (controller setting)
Sep 15 09:25:44 | sdk: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdk: state = 3
Sep 15 09:25:44 | sdk: prio = const (controller setting)
Sep 15 09:25:44 | sdk: const prio = 1
Sep 15 09:25:44 | sdk: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdk: uid = 350002ac001670246 (callout)
Sep 15 09:25:44 | dm-0: device node name blacklisted
Sep 15 09:25:44 | dm-1: device node name blacklisted
Sep 15 09:25:44 | dm-2: device node name blacklisted
Sep 15 09:25:44 | dm-3: device node name blacklisted
Sep 15 09:25:44 | dm-4: device node name blacklisted
Sep 15 09:25:44 | sdl: not found in pathvec
Sep 15 09:25:44 | sdl: mask = 0x1f
Sep 15 09:25:44 | sdl: dev_t = 8:176
Sep 15 09:25:44 | sdl: size = 73400320
Sep 15 09:25:44 | sdl: subsystem = scsi
Sep 15 09:25:44 | sdl: vendor = 3PARdata
Sep 15 09:25:44 | sdl: product = VV
Sep 15 09:25:44 | sdl: rev = 0000
Sep 15 09:25:44 | sdl: h:b:t:l = 2:0:0:0
Sep 15 09:25:44 | sdl: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdl: serial = 00ED0246
Sep 15 09:25:44 | sdl: get_state
Sep 15 09:25:44 | sdl: path checker = directio (controller setting)
Sep 15 09:25:44 | sdl: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdl: state = 3
Sep 15 09:25:44 | sdl: prio = const (controller setting)
Sep 15 09:25:44 | sdl: const prio = 1
Sep 15 09:25:44 | sdl: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdl: uid = 350002ac000ed0246 (callout)
Sep 15 09:25:44 | sdm: not found in pathvec
Sep 15 09:25:44 | sdm: mask = 0x1f
Sep 15 09:25:44 | sdm: dev_t = 8:192
Sep 15 09:25:44 | sdm: size = 73400320
Sep 15 09:25:44 | sdm: subsystem = scsi
Sep 15 09:25:44 | sdm: vendor = 3PARdata
Sep 15 09:25:44 | sdm: product = VV
Sep 15 09:25:44 | sdm: rev = 0000
Sep 15 09:25:44 | sdm: h:b:t:l = 2:0:0:1
Sep 15 09:25:44 | sdm: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdm: serial = 00EE0246
Sep 15 09:25:44 | sdm: get_state
Sep 15 09:25:44 | sdm: path checker = directio (controller setting)
Sep 15 09:25:44 | sdm: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdm: state = 3
Sep 15 09:25:44 | sdm: prio = const (controller setting)
Sep 15 09:25:44 | sdm: const prio = 1
Sep 15 09:25:44 | sdm: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdm: uid = 350002ac000ee0246 (callout)
Sep 15 09:25:44 | sdn: not found in pathvec
Sep 15 09:25:44 | sdn: mask = 0x1f
Sep 15 09:25:44 | sdn: dev_t = 8:208
Sep 15 09:25:44 | sdn: size = 52428800
Sep 15 09:25:44 | sdn: subsystem = scsi
Sep 15 09:25:44 | sdn: vendor = 3PARdata
Sep 15 09:25:44 | sdn: product = VV
Sep 15 09:25:44 | sdn: rev = 0000
Sep 15 09:25:44 | sdn: h:b:t:l = 2:0:0:2
Sep 15 09:25:44 | sdn: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdn: serial = 01260246
Sep 15 09:25:44 | sdn: get_state
Sep 15 09:25:44 | sdn: path checker = directio (controller setting)
Sep 15 09:25:44 | sdn: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdn: state = 3
Sep 15 09:25:44 | sdn: prio = const (controller setting)
Sep 15 09:25:44 | sdn: const prio = 1
Sep 15 09:25:44 | sdn: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdn: uid = 350002ac001260246 (callout)
Sep 15 09:25:44 | sdq: not found in pathvec
Sep 15 09:25:44 | sdq: mask = 0x1f
Sep 15 09:25:44 | sdq: dev_t = 65:0
Sep 15 09:25:44 | sdq: size = 73400320
Sep 15 09:25:44 | sdq: subsystem = scsi
Sep 15 09:25:44 | sdq: vendor = 3PARdata
Sep 15 09:25:44 | sdq: product = VV
Sep 15 09:25:44 | sdq: rev = 0000
Sep 15 09:25:44 | sdq: h:b:t:l = 2:0:1:0
Sep 15 09:25:44 | sdq: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdq: serial = 00ED0246
Sep 15 09:25:44 | sdq: get_state
Sep 15 09:25:44 | sdq: path checker = directio (controller setting)
Sep 15 09:25:44 | sdq: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdq: state = 3
Sep 15 09:25:44 | sdq: prio = const (controller setting)
Sep 15 09:25:44 | sdq: const prio = 1
Sep 15 09:25:44 | sdq: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdq: uid = 350002ac000ed0246 (callout)
Sep 15 09:25:44 | sdp: not found in pathvec
Sep 15 09:25:44 | sdp: mask = 0x1f
Sep 15 09:25:44 | sdp: dev_t = 8:240
Sep 15 09:25:44 | sdp: size = 41943040
Sep 15 09:25:44 | sdp: subsystem = scsi
Sep 15 09:25:44 | sdp: vendor = 3PARdata
Sep 15 09:25:44 | sdp: product = VV
Sep 15 09:25:44 | sdp: rev = 0000
Sep 15 09:25:44 | sdp: h:b:t:l = 2:0:0:4
Sep 15 09:25:44 | sdp: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdp: serial = 01670246
Sep 15 09:25:44 | sdp: get_state
Sep 15 09:25:44 | sdp: path checker = directio (controller setting)
Sep 15 09:25:44 | sdp: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdp: state = 3
Sep 15 09:25:44 | sdp: prio = const (controller setting)
Sep 15 09:25:44 | sdp: const prio = 1
Sep 15 09:25:44 | sdp: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdp: uid = 350002ac001670246 (callout)
Sep 15 09:25:44 | sdo: not found in pathvec
Sep 15 09:25:44 | sdo: mask = 0x1f
Sep 15 09:25:44 | sdo: dev_t = 8:224
Sep 15 09:25:44 | sdo: size = 209715200
Sep 15 09:25:44 | sdo: subsystem = scsi
Sep 15 09:25:44 | sdo: vendor = 3PARdata
Sep 15 09:25:44 | sdo: product = VV
Sep 15 09:25:44 | sdo: rev = 0000
Sep 15 09:25:44 | sdo: h:b:t:l = 2:0:0:3
Sep 15 09:25:44 | sdo: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdo: serial = 00020246
Sep 15 09:25:44 | sdo: get_state
Sep 15 09:25:44 | sdo: path checker = directio (controller setting)
Sep 15 09:25:44 | sdo: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdo: state = 3
Sep 15 09:25:44 | sdo: prio = const (controller setting)
Sep 15 09:25:44 | sdo: const prio = 1
Sep 15 09:25:44 | sdo: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdo: uid = 350002ac000020246 (callout)
Sep 15 09:25:44 | sdr: not found in pathvec
Sep 15 09:25:44 | sdr: mask = 0x1f
Sep 15 09:25:44 | sdr: dev_t = 65:16
Sep 15 09:25:44 | sdr: size = 73400320
Sep 15 09:25:44 | sdr: subsystem = scsi
Sep 15 09:25:44 | sdr: vendor = 3PARdata
Sep 15 09:25:44 | sdr: product = VV
Sep 15 09:25:44 | sdr: rev = 0000
Sep 15 09:25:44 | sdr: h:b:t:l = 2:0:1:1
Sep 15 09:25:44 | sdr: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdr: serial = 00EE0246
Sep 15 09:25:44 | sdr: get_state
Sep 15 09:25:44 | sdr: path checker = directio (controller setting)
Sep 15 09:25:44 | sdr: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdr: state = 3
Sep 15 09:25:44 | sdr: prio = const (controller setting)
Sep 15 09:25:44 | sdr: const prio = 1
Sep 15 09:25:44 | sdr: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdr: uid = 350002ac000ee0246 (callout)
Sep 15 09:25:44 | sds: not found in pathvec
Sep 15 09:25:44 | sds: mask = 0x1f
Sep 15 09:25:44 | sds: dev_t = 65:32
Sep 15 09:25:44 | sds: size = 52428800
Sep 15 09:25:44 | sds: subsystem = scsi
Sep 15 09:25:44 | sds: vendor = 3PARdata
Sep 15 09:25:44 | sds: product = VV
Sep 15 09:25:44 | sds: rev = 0000
Sep 15 09:25:44 | sds: h:b:t:l = 2:0:1:2
Sep 15 09:25:44 | sds: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sds: serial = 01260246
Sep 15 09:25:44 | sds: get_state
Sep 15 09:25:44 | sds: path checker = directio (controller setting)
Sep 15 09:25:44 | sds: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sds: state = 3
Sep 15 09:25:44 | sds: prio = const (controller setting)
Sep 15 09:25:44 | sds: const prio = 1
Sep 15 09:25:44 | sds: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sds: uid = 350002ac001260246 (callout)
Sep 15 09:25:44 | sdt: not found in pathvec
Sep 15 09:25:44 | sdt: mask = 0x1f
Sep 15 09:25:44 | sdt: dev_t = 65:48
Sep 15 09:25:44 | sdt: size = 209715200
Sep 15 09:25:44 | sdt: subsystem = scsi
Sep 15 09:25:44 | sdt: vendor = 3PARdata
Sep 15 09:25:44 | sdt: product = VV
Sep 15 09:25:44 | sdt: rev = 0000
Sep 15 09:25:44 | sdt: h:b:t:l = 2:0:1:3
Sep 15 09:25:44 | sdt: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdt: serial = 00020246
Sep 15 09:25:44 | sdt: get_state
Sep 15 09:25:44 | sdt: path checker = directio (controller setting)
Sep 15 09:25:44 | sdt: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdt: state = 3
Sep 15 09:25:44 | sdt: prio = const (controller setting)
Sep 15 09:25:44 | sdt: const prio = 1
Sep 15 09:25:44 | sdt: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdt: uid = 350002ac000020246 (callout)
Sep 15 09:25:44 | sdu: not found in pathvec
Sep 15 09:25:44 | sdu: mask = 0x1f
Sep 15 09:25:44 | sdu: dev_t = 65:64
Sep 15 09:25:44 | sdu: size = 41943040
Sep 15 09:25:44 | sdu: subsystem = scsi
Sep 15 09:25:44 | sdu: vendor = 3PARdata
Sep 15 09:25:44 | sdu: product = VV
Sep 15 09:25:44 | sdu: rev = 0000
Sep 15 09:25:44 | sdu: h:b:t:l = 2:0:1:4
Sep 15 09:25:44 | sdu: tgt_node_name = 0x2ff70002ac00024
Sep 15 09:25:44 | sdu: serial = 01670246
Sep 15 09:25:44 | sdu: get_state
Sep 15 09:25:44 | sdu: path checker = directio (controller setting)
Sep 15 09:25:44 | sdu: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdu: state = 3
Sep 15 09:25:44 | sdu: prio = const (controller setting)
Sep 15 09:25:44 | sdu: const prio = 1
Sep 15 09:25:44 | sdu: getuid = /lib/udev/scsi_id --whitelisted --device=/dev/%n (controller setting)
Sep 15 09:25:44 | sdu: uid = 350002ac001670246 (callout)
Sep 15 09:25:44 | dm-5: device node name blacklisted
===== paths list =====
uuid                              hcil    dev dev_t pri dm_st chk_st vend/prod
36001e4f02053fe000f72e29478df3495 0:2:0:0 sda 8:0   1   undef ready  DELL,PERC
350002ac000ed0246                 1:0:0:0 sdb 8:16  1   undef ready  3PARdata,
350002ac000ee0246                 1:0:0:1 sdc 8:32  1   undef ready  3PARdata,
350002ac001260246                 1:0:0:2 sdd 8:48  1   undef ready  3PARdata,
350002ac000020246                 1:0:0:3 sde 8:64  1   undef ready  3PARdata,
350002ac000ed0246                 1:0:1:0 sdg 8:96  1   undef ready  3PARdata,
350002ac001670246                 1:0:0:4 sdf 8:80  1   undef ready  3PARdata,
350002ac000ee0246                 1:0:1:1 sdh 8:112 1   undef ready  3PARdata,
350002ac001260246                 1:0:1:2 sdi 8:128 1   undef ready  3PARdata,
350002ac000020246                 1:0:1:3 sdj 8:144 1   undef ready  3PARdata,
350002ac001670246                 1:0:1:4 sdk 8:160 1   undef ready  3PARdata,
350002ac000ed0246                 2:0:0:0 sdl 8:176 1   undef ready  3PARdata,
350002ac000ee0246                 2:0:0:1 sdm 8:192 1   undef ready  3PARdata,
350002ac001260246                 2:0:0:2 sdn 8:208 1   undef ready  3PARdata,
350002ac000ed0246                 2:0:1:0 sdq 65:0  1   undef ready  3PARdata,
350002ac001670246                 2:0:0:4 sdp 8:240 1   undef ready  3PARdata,
350002ac000020246                 2:0:0:3 sdo 8:224 1   undef ready  3PARdata,
350002ac000ee0246                 2:0:1:1 sdr 65:16 1   undef ready  3PARdata,
350002ac001260246                 2:0:1:2 sds 65:32 1   undef ready  3PARdata,
350002ac000020246                 2:0:1:3 sdt 65:48 1   undef ready  3PARdata,
350002ac001670246                 2:0:1:4 sdu 65:64 1   undef ready  3PARdata,
Sep 15 09:25:44 | params = 0 0 1 1 queue-length 0 4 1 8:64 8 8:144 8 8:224 8 65:48 8 
Sep 15 09:25:44 | status = 2 0 0 0 1 1 A 0 4 1 8:64 A 0 0 8:144 A 0 0 8:224 A 0 0 65:48 A 0 0 
Sep 15 09:25:44 | 8: not found in pathvec
Sep 15 09:25:44 | Invalid device number 8
Sep 15 09:25:44 | Invalid device number 8
Sep 15 09:25:44 | params = 0 0 1 1 round-robin 0 4 1 8:240 1 8:80 1 8:160 1 65:64 1 
Sep 15 09:25:44 | status = 2 0 0 0 1 1 A 0 4 0 8:240 A 0 8:80 A 0 8:160 A 0 65:64 A 0 
Sep 15 09:25:44 | params = 0 0 1 1 round-robin 0 4 1 65:32 1 8:48 1 8:128 1 8:208 1 
Sep 15 09:25:44 | status = 2 0 0 0 1 1 A 0 4 0 65:32 A 0 8:48 A 0 8:128 A 0 8:208 A 0 
Sep 15 09:25:44 | params = 0 0 1 1 round-robin 0 4 1 8:192 1 8:32 1 8:112 1 65:16 1 
Sep 15 09:25:44 | status = 2 0 0 0 1 1 A 0 4 0 8:192 A 0 8:32 A 0 8:112 A 0 65:16 A 0 
Sep 15 09:25:44 | params = 0 0 1 1 round-robin 0 4 1 8:176 1 8:16 1 8:96 1 65:0 1 
Sep 15 09:25:44 | status = 2 0 0 0 1 1 A 0 4 0 8:176 A 0 8:16 A 0 8:96 A 0 65:0 A 0 
Sep 15 09:25:44 | sda: ownership set to 36001e4f02053fe000f72e29478df3495
Sep 15 09:25:44 | sda: not found in pathvec
Sep 15 09:25:44 | sda: mask = 0xc
Sep 15 09:25:44 | sda: get_state
Sep 15 09:25:44 | sda: state = running
Sep 15 09:25:44 | sda: state = 3
Sep 15 09:25:44 | sda: const prio = 1
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: pgfailover = -1 (internal default)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: pgpolicy = multibus (config file default)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: selector = round-robin 0 (internal default)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: features = 0 (internal default)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: hwhandler = 0 (internal default)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: rr_weight = 1 (internal default)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: minio = 8 (config file default)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: no_path_retry = NONE (internal default)
Sep 15 09:25:44 | pg_timeout = NONE (internal default)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: set ACT_CREATE (map does not exist)
Sep 15 09:25:44 | 36001e4f02053fe000f72e29478df3495: domap (0) failure for create/reload map
Sep 15 09:25:44 | sde: ownership set to u02
Sep 15 09:25:44 | sde: not found in pathvec
Sep 15 09:25:44 | sde: mask = 0xc
Sep 15 09:25:44 | sde: get_state
Sep 15 09:25:44 | sde: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sde: state = 3
Sep 15 09:25:44 | sde: const prio = 1
Sep 15 09:25:44 | sdj: ownership set to u02
Sep 15 09:25:44 | sdj: not found in pathvec
Sep 15 09:25:44 | sdj: mask = 0xc
Sep 15 09:25:44 | sdj: get_state
Sep 15 09:25:44 | sdj: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdj: state = 3
Sep 15 09:25:44 | sdj: const prio = 1
Sep 15 09:25:44 | sdo: ownership set to u02
Sep 15 09:25:44 | sdo: not found in pathvec
Sep 15 09:25:44 | sdo: mask = 0xc
Sep 15 09:25:44 | sdo: get_state
Sep 15 09:25:44 | sdo: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdo: state = 3
Sep 15 09:25:44 | sdo: const prio = 1
Sep 15 09:25:44 | sdt: ownership set to u02
Sep 15 09:25:44 | sdt: not found in pathvec
Sep 15 09:25:44 | sdt: mask = 0xc
Sep 15 09:25:44 | sdt: get_state
Sep 15 09:25:44 | sdt: state = running
Sep 15 09:25:44 | directio: starting new request
Sep 15 09:25:44 | directio: io finished 4096/0
Sep 15 09:25:44 | sdt: state = 3
Sep 15 09:25:44 | sdt: const prio = 1
Sep 15 09:25:44 | : ownership set to u02
Sep 15 09:25:44 | : not found in pathvec
Sep 15 09:25:44 | : mask = 0xc
Sep 15 09:25:44 | : get_state
Sep 15 09:25:44 | : path checker = readsector0 (config file default)
Sep 15 09:25:44 | : failed to get parent
Sep 15 09:25:44 | : path offline
Sep 15 09:25:44 | : prio = const (config file default)
Sep 15 09:25:44 | : const prio = 1
Sep 15 09:25:44 | block: no 'dev' attribute in sysfs
Sep 15 09:25:44 | u02: failed to access path /block
Sep 15 09:25:44 | u02: pgfailover = -1 (internal default)
Sep 15 09:25:44 | u02: pgpolicy = multibus (LUN setting)
Sep 15 09:25:44 | u02: selector = queue-length 0 (LUN setting)
Sep 15 09:25:44 | u02: features = 0 (controller setting)
Sep 15 09:25:44 | u02: hwhandler = 0 (controller setting)
Sep 15 09:25:44 | u02: rr_weight = 1 (controller setting)
Sep 15 09:25:44 | u02: minio = 8 (LUN setting)
Sep 15 09:25:44 | u02: no_path_retry = NONE (internal default)
Sep 15 09:25:44 | pg_timeout = NONE (internal default)
Sep 15 09:25:44 | u02: set ACT_RELOAD (minio change, 0->8)
reload: u02 (350002ac000020246) undef 3PARdata,VV
size=100G features='0' hwhandler='0' wp=undef
`-+- policy='queue-length 0' prio=4 status=undef
  |- 1:0:0:3 sde 8:64  active ready running
  |- 1:0:1:3 sdj 8:144 active ready running
  |- 2:0:0:3 sdo 8:224 undef ready running
  `- 2:0:1:3 sdt 65:48 undef ready running
Sep 15 09:25:49 | Invalid device number 8
Sep 15 09:25:49 | Invalid device number 8


u02 (350002ac000020246) dm-3 3PARdata,VV
size=100G features='0' hwhandler='0' wp=rw
`-+- policy='queue-length 0' prio=2 status=active
  |- 1:0:0:3 sde 8:64  active ready running
  |- #:#:#:# -   #:#   active faulty running
  |- 1:0:1:3 sdj 8:144 active ready running
  `- #:#:#:# -   #:#   active faulty running
u01_vm4 (350002ac001670246) dm-0 3PARdata,VV
size=20G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:0:4 sdp 8:240 active ready running
  |- 1:0:0:4 sdf 8:80  active ready running
  |- 1:0:1:4 sdk 8:160 active ready running
  `- 2:0:1:4 sdu 65:64 active ready running
u01_vm3 (350002ac001260246) dm-4 3PARdata,VV
size=25G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:1:2 sds 65:32 active ready running
  |- 1:0:0:2 sdd 8:48  active ready running
  |- 1:0:1:2 sdi 8:128 active ready running
  `- 2:0:0:2 sdn 8:208 active ready running
u01_vm2 (350002ac000ee0246) dm-2 3PARdata,VV
size=35G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:0:1 sdm 8:192 active ready running
  |- 1:0:0:1 sdc 8:32  active ready running
  |- 1:0:1:1 sdh 8:112 active ready running
  `- 2:0:1:1 sdr 65:16 active ready running
u01_vm1 (350002ac000ed0246) dm-1 3PARdata,VV
size=35G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=4 status=active
  |- 2:0:0:0 sdl 8:176 active ready running
  |- 1:0:0:0 sdb 8:16  active ready running
  |- 1:0:1:0 sdg 8:96  active ready running
  `- 2:0:1:0 sdq 65:0  active ready running
