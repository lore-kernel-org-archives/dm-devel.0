From: Rudy Gevaert <Rudy.Gevaert@UGent.be>
Subject: Re: how to troubleshoot faulty multipath path?
Date: Wed, 21 Dec 2011 17:23:20 +0100
Message-ID: <4EF207F8.7030904@UGent.be>
References: <4EEB6886.402@UGent.be><47D23AD8469A2B448F33C24BD7A39BD910C56472@RTPMVEXC1-PRD.hq.netapp.com>	<20111217113450.35436m5i93gv279m@webmail.ugent.be>
	<47D23AD8469A2B448F33C24BD7A39BD910D14220@RTPMVEXC1-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070006090406080306050402"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD910D14220@RTPMVEXC1-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
--------------070006090406080306050402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/2011 08:45 PM, Moger, Babu wrote:

> None of your logs show any problems with the paths related to DS3400.
> Can you please set the verbosity to 6 and collect the logs.
> To set the verbosity level  add following line in default section in
> your multipath.conf.
> verbosity 	6

Hello,

I have changed the verbosity level to 6.  I have attached the output of 
multipath -l.

Do you need any other logs?

Thanks in advance!
Rudy

--------------070006090406080306050402
Content-Type: text/plain;
 name="multipath_ll"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="multipath_ll"

Dec 21 17:23:02 | loading /lib/multipath/libcheckdirectio.so checker
Dec 21 17:23:02 | loading /lib/multipath/libprioconst.so prioritizer
Dec 21 17:23:02 | Discover device /sys/block/sda
Dec 21 17:23:02 | sda: not found in pathvec
Dec 21 17:23:02 | sda: mask = 0x1
Dec 21 17:23:02 | sda: dev_t = 8:0
Dec 21 17:23:02 | sda: size = 2924216320
Dec 21 17:23:02 | sda: subsystem = scsi
Dec 21 17:23:02 | sda: vendor = DELL
Dec 21 17:23:02 | sda: product = PERC 6/i
Dec 21 17:23:02 | sda: rev = 1.22
Dec 21 17:23:02 | sda: h:b:t:l = 0:2:0:0
Dec 21 17:23:02 | Discover device /sys/block/sdb
Dec 21 17:23:02 | sdb: not found in pathvec
Dec 21 17:23:02 | sdb: mask = 0x1
Dec 21 17:23:02 | sdb: dev_t = 8:16
Dec 21 17:23:02 | sdb: size = 1153433600
Dec 21 17:23:02 | sdb: subsystem = scsi
Dec 21 17:23:02 | sdb: vendor = IBM
Dec 21 17:23:02 | sdb: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdb: rev = 0617
Dec 21 17:23:02 | sdb: h:b:t:l = 1:0:0:8
Dec 21 17:23:02 | sdb: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdc
Dec 21 17:23:02 | sdc: not found in pathvec
Dec 21 17:23:02 | sdc: mask = 0x1
Dec 21 17:23:02 | sdc: dev_t = 8:32
Dec 21 17:23:02 | sdc: size = 1153433600
Dec 21 17:23:02 | sdc: subsystem = scsi
Dec 21 17:23:02 | sdc: vendor = IBM
Dec 21 17:23:02 | sdc: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdc: rev = 0617
Dec 21 17:23:02 | sdc: h:b:t:l = 1:0:0:10
Dec 21 17:23:02 | sdc: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdd
Dec 21 17:23:02 | sdd: not found in pathvec
Dec 21 17:23:02 | sdd: mask = 0x1
Dec 21 17:23:02 | sdd: dev_t = 8:48
Dec 21 17:23:02 | sdd: size = 1153433600
Dec 21 17:23:02 | sdd: subsystem = scsi
Dec 21 17:23:02 | sdd: vendor = IBM
Dec 21 17:23:02 | sdd: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdd: rev = 0617
Dec 21 17:23:02 | sdd: h:b:t:l = 1:0:0:11
Dec 21 17:23:02 | sdd: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Couldn't open node for sdd: No such device or address
Dec 21 17:23:02 | Discover device /sys/block/sde
Dec 21 17:23:02 | sde: not found in pathvec
Dec 21 17:23:02 | sde: mask = 0x1
Dec 21 17:23:02 | sde: dev_t = 8:64
Dec 21 17:23:02 | sde: size = 1153433600
Dec 21 17:23:02 | sde: subsystem = scsi
Dec 21 17:23:02 | sde: vendor = IBM
Dec 21 17:23:02 | sde: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sde: rev = 0617
Dec 21 17:23:02 | sde: h:b:t:l = 1:0:0:12
Dec 21 17:23:02 | sde: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdf
Dec 21 17:23:02 | sdf: not found in pathvec
Dec 21 17:23:02 | sdf: mask = 0x1
Dec 21 17:23:02 | sdf: dev_t = 8:80
Dec 21 17:23:02 | sdf: size = 1153433600
Dec 21 17:23:02 | sdf: subsystem = scsi
Dec 21 17:23:02 | sdf: vendor = IBM
Dec 21 17:23:02 | sdf: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdf: rev = 0617
Dec 21 17:23:02 | sdf: h:b:t:l = 1:0:0:13
Dec 21 17:23:02 | sdf: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdg
Dec 21 17:23:02 | sdg: not found in pathvec
Dec 21 17:23:02 | sdg: mask = 0x1
Dec 21 17:23:02 | sdg: dev_t = 8:96
Dec 21 17:23:02 | sdg: size = 1153433600
Dec 21 17:23:02 | sdg: subsystem = scsi
Dec 21 17:23:02 | sdg: vendor = IBM
Dec 21 17:23:02 | sdg: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdg: rev = 0617
Dec 21 17:23:02 | sdg: h:b:t:l = 1:0:0:14
Dec 21 17:23:02 | sdg: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdh
Dec 21 17:23:02 | sdh: not found in pathvec
Dec 21 17:23:02 | sdh: mask = 0x1
Dec 21 17:23:02 | sdh: dev_t = 8:112
Dec 21 17:23:02 | sdh: size = 1153433600
Dec 21 17:23:02 | sdh: subsystem = scsi
Dec 21 17:23:02 | sdh: vendor = IBM
Dec 21 17:23:02 | sdh: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdh: rev = 0617
Dec 21 17:23:02 | sdh: h:b:t:l = 1:0:0:15
Dec 21 17:23:02 | sdh: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdi
Dec 21 17:23:02 | sdi: not found in pathvec
Dec 21 17:23:02 | sdi: mask = 0x1
Dec 21 17:23:02 | sdi: dev_t = 8:128
Dec 21 17:23:02 | sdi: size = 1153433600
Dec 21 17:23:02 | sdi: subsystem = scsi
Dec 21 17:23:02 | sdi: vendor = IBM
Dec 21 17:23:02 | sdi: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdi: rev = 0617
Dec 21 17:23:02 | sdi: h:b:t:l = 1:0:0:16
Dec 21 17:23:02 | sdi: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdj
Dec 21 17:23:02 | sdj: not found in pathvec
Dec 21 17:23:02 | sdj: mask = 0x1
Dec 21 17:23:02 | sdj: dev_t = 8:144
Dec 21 17:23:02 | sdj: size = 1153433600
Dec 21 17:23:02 | sdj: subsystem = scsi
Dec 21 17:23:02 | sdj: vendor = IBM
Dec 21 17:23:02 | sdj: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdj: rev = 0617
Dec 21 17:23:02 | sdj: h:b:t:l = 1:0:0:17
Dec 21 17:23:02 | sdj: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdk
Dec 21 17:23:02 | sdk: not found in pathvec
Dec 21 17:23:02 | sdk: mask = 0x1
Dec 21 17:23:02 | sdk: dev_t = 8:160
Dec 21 17:23:02 | sdk: size = 1153433600
Dec 21 17:23:02 | sdk: subsystem = scsi
Dec 21 17:23:02 | sdk: vendor = IBM
Dec 21 17:23:02 | sdk: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdk: rev = 0617
Dec 21 17:23:02 | sdk: h:b:t:l = 1:0:0:18
Dec 21 17:23:02 | sdk: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdl
Dec 21 17:23:02 | sdl: not found in pathvec
Dec 21 17:23:02 | sdl: mask = 0x1
Dec 21 17:23:02 | sdl: dev_t = 8:176
Dec 21 17:23:02 | sdl: size = 1153433600
Dec 21 17:23:02 | sdl: subsystem = scsi
Dec 21 17:23:02 | sdl: vendor = IBM
Dec 21 17:23:02 | sdl: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdl: rev = 0617
Dec 21 17:23:02 | sdl: h:b:t:l = 1:0:0:19
Dec 21 17:23:02 | sdl: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdm
Dec 21 17:23:02 | sdm: not found in pathvec
Dec 21 17:23:02 | sdm: mask = 0x1
Dec 21 17:23:02 | sdm: dev_t = 8:192
Dec 21 17:23:02 | sdm: size = 1153433600
Dec 21 17:23:02 | sdm: subsystem = scsi
Dec 21 17:23:02 | sdm: vendor = IBM
Dec 21 17:23:02 | sdm: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdm: rev = 0617
Dec 21 17:23:02 | sdm: h:b:t:l = 1:0:0:20
Dec 21 17:23:02 | sdm: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdn
Dec 21 17:23:02 | sdn: not found in pathvec
Dec 21 17:23:02 | sdn: mask = 0x1
Dec 21 17:23:02 | sdn: dev_t = 8:208
Dec 21 17:23:02 | sdn: size = 1153433600
Dec 21 17:23:02 | sdn: subsystem = scsi
Dec 21 17:23:02 | sdn: vendor = IBM
Dec 21 17:23:02 | sdn: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdn: rev = 0617
Dec 21 17:23:02 | sdn: h:b:t:l = 1:0:0:21
Dec 21 17:23:02 | sdn: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdo
Dec 21 17:23:02 | sdo: not found in pathvec
Dec 21 17:23:02 | sdo: mask = 0x1
Dec 21 17:23:02 | sdo: dev_t = 8:224
Dec 21 17:23:02 | sdo: size = 1153433600
Dec 21 17:23:02 | sdo: subsystem = scsi
Dec 21 17:23:02 | sdo: vendor = IBM
Dec 21 17:23:02 | sdo: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdo: rev = 0617
Dec 21 17:23:02 | sdo: h:b:t:l = 1:0:0:22
Dec 21 17:23:02 | sdo: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdp
Dec 21 17:23:02 | sdp: not found in pathvec
Dec 21 17:23:02 | sdp: mask = 0x1
Dec 21 17:23:02 | sdp: dev_t = 8:240
Dec 21 17:23:02 | sdp: size = 1153433600
Dec 21 17:23:02 | sdp: subsystem = scsi
Dec 21 17:23:02 | sdp: vendor = IBM
Dec 21 17:23:02 | sdp: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdp: rev = 0617
Dec 21 17:23:02 | sdp: h:b:t:l = 5:0:0:8
Dec 21 17:23:02 | sdp: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdq
Dec 21 17:23:02 | sdq: not found in pathvec
Dec 21 17:23:02 | sdq: mask = 0x1
Dec 21 17:23:02 | sdq: dev_t = 65:0
Dec 21 17:23:02 | sdq: size = 1153433600
Dec 21 17:23:02 | sdq: subsystem = scsi
Dec 21 17:23:02 | sdq: vendor = IBM
Dec 21 17:23:02 | sdq: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdq: rev = 0617
Dec 21 17:23:02 | sdq: h:b:t:l = 5:0:0:10
Dec 21 17:23:02 | sdq: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Couldn't open node for sdq: No such device or address
Dec 21 17:23:02 | Discover device /sys/block/sdr
Dec 21 17:23:02 | sdr: not found in pathvec
Dec 21 17:23:02 | sdr: mask = 0x1
Dec 21 17:23:02 | sdr: dev_t = 65:16
Dec 21 17:23:02 | sdr: size = 1153433600
Dec 21 17:23:02 | sdr: subsystem = scsi
Dec 21 17:23:02 | sdr: vendor = IBM
Dec 21 17:23:02 | sdr: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdr: rev = 0617
Dec 21 17:23:02 | sdr: h:b:t:l = 5:0:0:11
Dec 21 17:23:02 | sdr: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sds
Dec 21 17:23:02 | sds: not found in pathvec
Dec 21 17:23:02 | sds: mask = 0x1
Dec 21 17:23:02 | sds: dev_t = 65:32
Dec 21 17:23:02 | sds: size = 1153433600
Dec 21 17:23:02 | sds: subsystem = scsi
Dec 21 17:23:02 | sds: vendor = IBM
Dec 21 17:23:02 | sds: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sds: rev = 0617
Dec 21 17:23:02 | sds: h:b:t:l = 5:0:0:12
Dec 21 17:23:02 | sds: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdt
Dec 21 17:23:02 | sdt: not found in pathvec
Dec 21 17:23:02 | sdt: mask = 0x1
Dec 21 17:23:02 | sdt: dev_t = 65:48
Dec 21 17:23:02 | sdt: size = 1153433600
Dec 21 17:23:02 | sdt: subsystem = scsi
Dec 21 17:23:02 | sdt: vendor = IBM
Dec 21 17:23:02 | sdt: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdt: rev = 0617
Dec 21 17:23:02 | sdt: h:b:t:l = 5:0:0:13
Dec 21 17:23:02 | sdt: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdu
Dec 21 17:23:02 | sdu: not found in pathvec
Dec 21 17:23:02 | sdu: mask = 0x1
Dec 21 17:23:02 | sdu: dev_t = 65:64
Dec 21 17:23:02 | sdu: size = 1153433600
Dec 21 17:23:02 | sdu: subsystem = scsi
Dec 21 17:23:02 | sdu: vendor = IBM
Dec 21 17:23:02 | sdu: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdu: rev = 0617
Dec 21 17:23:02 | sdu: h:b:t:l = 5:0:0:14
Dec 21 17:23:02 | sdu: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdv
Dec 21 17:23:02 | sdv: not found in pathvec
Dec 21 17:23:02 | sdv: mask = 0x1
Dec 21 17:23:02 | sdv: dev_t = 65:80
Dec 21 17:23:02 | sdv: size = 1153433600
Dec 21 17:23:02 | sdv: subsystem = scsi
Dec 21 17:23:02 | sdv: vendor = IBM
Dec 21 17:23:02 | sdv: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdv: rev = 0617
Dec 21 17:23:02 | sdv: h:b:t:l = 5:0:0:15
Dec 21 17:23:02 | sdv: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Couldn't open node for sdv: No such device or address
Dec 21 17:23:02 | Discover device /sys/block/sdw
Dec 21 17:23:02 | sdw: not found in pathvec
Dec 21 17:23:02 | sdw: mask = 0x1
Dec 21 17:23:02 | sdw: dev_t = 65:96
Dec 21 17:23:02 | sdw: size = 1153433600
Dec 21 17:23:02 | sdw: subsystem = scsi
Dec 21 17:23:02 | sdw: vendor = IBM
Dec 21 17:23:02 | sdw: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdw: rev = 0617
Dec 21 17:23:02 | sdw: h:b:t:l = 5:0:0:16
Dec 21 17:23:02 | sdw: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdx
Dec 21 17:23:02 | sdx: not found in pathvec
Dec 21 17:23:02 | sdx: mask = 0x1
Dec 21 17:23:02 | sdx: dev_t = 65:112
Dec 21 17:23:02 | sdx: size = 1153433600
Dec 21 17:23:02 | sdx: subsystem = scsi
Dec 21 17:23:02 | sdx: vendor = IBM
Dec 21 17:23:02 | sdx: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdx: rev = 0617
Dec 21 17:23:02 | sdx: h:b:t:l = 5:0:0:17
Dec 21 17:23:02 | sdx: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdy
Dec 21 17:23:02 | sdy: not found in pathvec
Dec 21 17:23:02 | sdy: mask = 0x1
Dec 21 17:23:02 | sdy: dev_t = 65:128
Dec 21 17:23:02 | sdy: size = 1153433600
Dec 21 17:23:02 | sdy: subsystem = scsi
Dec 21 17:23:02 | sdy: vendor = IBM
Dec 21 17:23:02 | sdy: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdy: rev = 0617
Dec 21 17:23:02 | sdy: h:b:t:l = 5:0:0:18
Dec 21 17:23:02 | sdy: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdz
Dec 21 17:23:02 | sdz: not found in pathvec
Dec 21 17:23:02 | sdz: mask = 0x1
Dec 21 17:23:02 | sdz: dev_t = 65:144
Dec 21 17:23:02 | sdz: size = 1153433600
Dec 21 17:23:02 | sdz: subsystem = scsi
Dec 21 17:23:02 | sdz: vendor = IBM
Dec 21 17:23:02 | sdz: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdz: rev = 0617
Dec 21 17:23:02 | sdz: h:b:t:l = 5:0:0:19
Dec 21 17:23:02 | sdz: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdaa
Dec 21 17:23:02 | sdaa: not found in pathvec
Dec 21 17:23:02 | sdaa: mask = 0x1
Dec 21 17:23:02 | sdaa: dev_t = 65:160
Dec 21 17:23:02 | sdaa: size = 1153433600
Dec 21 17:23:02 | sdaa: subsystem = scsi
Dec 21 17:23:02 | sdaa: vendor = IBM
Dec 21 17:23:02 | sdaa: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdaa: rev = 0617
Dec 21 17:23:02 | sdaa: h:b:t:l = 5:0:0:20
Dec 21 17:23:02 | sdaa: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdab
Dec 21 17:23:02 | sdab: not found in pathvec
Dec 21 17:23:02 | sdab: mask = 0x1
Dec 21 17:23:02 | sdab: dev_t = 65:176
Dec 21 17:23:02 | sdab: size = 1153433600
Dec 21 17:23:02 | sdab: subsystem = scsi
Dec 21 17:23:02 | sdab: vendor = IBM
Dec 21 17:23:02 | sdab: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdab: rev = 0617
Dec 21 17:23:02 | sdab: h:b:t:l = 5:0:0:21
Dec 21 17:23:02 | sdab: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sdac
Dec 21 17:23:02 | sdac: not found in pathvec
Dec 21 17:23:02 | sdac: mask = 0x1
Dec 21 17:23:02 | sdac: dev_t = 65:192
Dec 21 17:23:02 | sdac: size = 1153433600
Dec 21 17:23:02 | sdac: subsystem = scsi
Dec 21 17:23:02 | sdac: vendor = IBM
Dec 21 17:23:02 | sdac: product = 1726-4xx  FAStT
Dec 21 17:23:02 | sdac: rev = 0617
Dec 21 17:23:02 | sdac: h:b:t:l = 5:0:0:22
Dec 21 17:23:02 | sdac: tgt_node_name = 0x200400a0b85a591
Dec 21 17:23:02 | Discover device /sys/block/sr0
Dec 21 17:23:02 | sr0: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-0
Dec 21 17:23:02 | dm-0: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-1
Dec 21 17:23:02 | dm-1: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-2
Dec 21 17:23:02 | dm-2: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-3
Dec 21 17:23:02 | dm-3: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-4
Dec 21 17:23:02 | dm-4: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-5
Dec 21 17:23:02 | dm-5: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-6
Dec 21 17:23:02 | dm-6: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-7
Dec 21 17:23:02 | dm-7: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-8
Dec 21 17:23:02 | dm-8: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-9
Dec 21 17:23:02 | dm-9: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-10
Dec 21 17:23:02 | dm-10: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-11
Dec 21 17:23:02 | dm-11: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-12
Dec 21 17:23:02 | dm-12: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-13
Dec 21 17:23:02 | dm-13: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-14
Dec 21 17:23:02 | dm-14: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-15
Dec 21 17:23:02 | dm-15: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-16
Dec 21 17:23:02 | dm-16: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-17
Dec 21 17:23:02 | dm-17: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-18
Dec 21 17:23:02 | dm-18: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-19
Dec 21 17:23:02 | dm-19: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-20
Dec 21 17:23:02 | dm-20: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-21
Dec 21 17:23:02 | dm-21: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-22
Dec 21 17:23:02 | dm-22: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-23
Dec 21 17:23:02 | dm-23: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-24
Dec 21 17:23:02 | dm-24: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-25
Dec 21 17:23:02 | dm-25: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-26
Dec 21 17:23:02 | dm-26: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-27
Dec 21 17:23:02 | dm-27: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-28
Dec 21 17:23:02 | dm-28: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-29
Dec 21 17:23:02 | dm-29: device node name blacklisted
Dec 21 17:23:02 | Discover device /sys/block/dm-30
Dec 21 17:23:02 | dm-30: device node name blacklisted
Dec 21 17:23:02 | Discovery status 0
===== paths list =====
uuid hcil     dev  dev_t  pri dm_st chk_st vend/prod/rev       dev_st 
     0:2:0:0  sda  8:0    -1  undef undef  DELL,PERC 6/i       running
     1:0:0:8  sdb  8:16   -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:10 sdc  8:32   -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:11 sdd  8:48   -1  undef faulty IBM,1726-4xx  FAStT running
     1:0:0:12 sde  8:64   -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:13 sdf  8:80   -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:14 sdg  8:96   -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:15 sdh  8:112  -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:16 sdi  8:128  -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:17 sdj  8:144  -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:18 sdk  8:160  -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:19 sdl  8:176  -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:20 sdm  8:192  -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:21 sdn  8:208  -1  undef undef  IBM,1726-4xx  FAStT running
     1:0:0:22 sdo  8:224  -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:8  sdp  8:240  -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:10 sdq  65:0   -1  undef faulty IBM,1726-4xx  FAStT running
     5:0:0:11 sdr  65:16  -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:12 sds  65:32  -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:13 sdt  65:48  -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:14 sdu  65:64  -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:15 sdv  65:80  -1  undef faulty IBM,1726-4xx  FAStT running
     5:0:0:16 sdw  65:96  -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:17 sdx  65:112 -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:18 sdy  65:128 -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:19 sdz  65:144 -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:20 sdaa 65:160 -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:21 sdab 65:176 -1  undef undef  IBM,1726-4xx  FAStT running
     5:0:0:22 sdac 65:192 -1  undef undef  IBM,1726-4xx  FAStT running
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm names   NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore19r  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail17r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail17r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail17r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail17r-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail17r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail13-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail13-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail13-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail13-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail13-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore14r  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail19r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail19r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail19r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail19r-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail19r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail12-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail12-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail12-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail12-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail12-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore17r  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail11-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail11-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail11-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail11-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail11-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore21  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore20  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore22r  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail10-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail10-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail10-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail10-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail10-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail14r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail14r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail14r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail14r-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail14r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail8-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail8-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail8-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail8-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail8-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore15r  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail16r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail16r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail16r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail16r-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail16r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail22r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail22r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail22r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail22r-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail22r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail18r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail18r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail18r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail18r-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail18r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table ugent-tmp  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore18r  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore13  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore8  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore12  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail21-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail21-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail21-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail21-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail21-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore16r  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table ugent-var  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore11  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail20-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail20-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail20-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail20-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail20-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail15r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mail15r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm status mail15r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail15r-ds3400-1  OF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm info mail15r-ds3400-1  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table mailstore10  NF   [16384]
Dec 21 17:23:02 | libdevmapper: ioctl/libdm-iface.c(1821): dm table ugent-home  NF   [16384]
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 65:112 1000 round-robin 0 1 1 8:144 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 65:112 A 0 E 0 1 0 8:144 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:112, len = 6
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:144, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail17r-ds3400-1 (3600a0b80005a67b6000004764cac4912) dm-8 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 5:0:0:17 sdx  65:112 active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 1:0:0:17 sdj  8:144  active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 65:48 1000 round-robin 0 1 1 8:80 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 65:48 A 0 E 0 1 0 8:80 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:48, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:80, len = 4
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail13-ds3400-1 (3600a0b80005a67b60000046f4cac471e) dm-4 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 5:0:0:13 sdt  65:48  active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 1:0:0:13 sdf  8:80   active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 65:144 1000 round-robin 0 1 1 8:176 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 65:144 A 0 E 0 1 0 8:176 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:144, len = 6
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:176, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail19r-ds3400-1 (3600a0b80005a67b6000004744cac48bd) dm-10 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 5:0:0:19 sdz  65:144 active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 1:0:0:19 sdl  8:176  active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:64 1000 round-robin 0 1 1 65:32 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 8:64 A 0 E 0 1 0 65:32 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:64, len = 4
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:32, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail12-ds3400-1 (3600a0b80005a591a0000042d4cac4753) dm-3 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 1:0:0:12 sde  8:64   active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 5:0:0:12 sds  65:32  active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 2 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 65:16 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 2 E 0 1 0 8:48 A 1 A 0 1 0 65:16 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:48, len = 4
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:16, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail11-ds3400-1 (3600a0b80005a591a0000042b4cac46de) dm-2 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=0 status=enabled
| `- 1:0:0:11 sdd  8:48   active faulty running
`-+- policy='round-robin 0' prio=-1 status=active
  `- 5:0:0:11 sdr  65:16  active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 2 round-robin 0 1 1 65:0 1000 round-robin 0 1 1 8:32 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 2 E 0 1 0 65:0 A 1 A 0 1 0 8:32 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:0, len = 4
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:32, len = 4
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail10-ds3400-1 (3600a0b80005a67b60000046a4cac4613) dm-1 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=0 status=enabled
| `- 5:0:0:10 sdq  65:0   active faulty running
`-+- policy='round-robin 0' prio=-1 status=active
  `- 1:0:0:10 sdc  8:32   active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:96 1000 round-robin 0 1 1 65:64 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 8:96 A 0 E 0 1 0 65:64 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:96, len = 4
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:64, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail14r-ds3400-1 (3600a0b80005a591a000004294cac468b) dm-5 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 1:0:0:14 sdg  8:96   active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 5:0:0:14 sdu  65:64  active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:240 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 8:16 A 0 E 0 1 0 8:240 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:16, len = 4
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:240, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail8-ds3400-1 (3600a0b80005a591a000004264cac464b) dm-0 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 1:0:0:8  sdb  8:16   active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 5:0:0:8  sdp  8:240  active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:128 1000 round-robin 0 1 1 65:96 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 8:128 A 0 E 0 1 0 65:96 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:128, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:96, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail16r-ds3400-1 (3600a0b80005a591a000004304cac47f7) dm-7 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 1:0:0:16 sdi  8:128  active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 5:0:0:16 sdw  65:96  active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:224 1000 round-robin 0 1 1 65:192 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 8:224 A 0 E 0 1 0 65:192 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:224, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:192, len = 6
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail22r-ds3400-1 (3600a0b80005a591a000004374cac49dd) dm-13 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 1:0:0:22 sdo  8:224  active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 5:0:0:22 sdac 65:192 active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:160 1000 round-robin 0 1 1 65:128 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 8:160 A 0 E 0 1 0 65:128 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:160, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:128, len = 6
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail18r-ds3400-1 (3600a0b80005a591a000004324cac4953) dm-9 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 1:0:0:18 sdk  8:160  active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 5:0:0:18 sdy  65:128 active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 65:176 1000 round-robin 0 1 1 8:208 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 65:176 A 0 E 0 1 0 8:208 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:176, len = 6
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:208, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail21-ds3400-1 (3600a0b80005a67b6000004714cac4771) dm-12 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 5:0:0:21 sdab 65:176 active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 1:0:0:21 sdn  8:208  active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:192 1000 round-robin 0 1 1 65:160 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 1 A 0 1 0 8:192 A 0 E 0 1 0 65:160 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:192, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:160, len = 6
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail20-ds3400-1 (3600a0b80005a591a000004344cac49a6) dm-11 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 1:0:0:20 sdm  8:192  active undef  running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 5:0:0:20 sdaa 65:160 active undef  running
Dec 21 17:23:02 | params = 1 queue_if_no_path 1 rdac 2 2 round-robin 0 1 1 65:80 1000 round-robin 0 1 1 8:112 1000 
Dec 21 17:23:02 | status = 2 0 1 0 2 2 E 0 1 0 65:80 A 1 A 0 1 0 8:112 A 0 
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = queue_if_no_path, len = 16
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = rdac, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = round-robin, len = 11
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 65:80, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 8:112, len = 5
Dec 21 17:23:02 | *word = 1000, len = 4
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = 2, len = 1
Dec 21 17:23:02 | *word = E, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 1, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
Dec 21 17:23:02 | *word = A, len = 1
Dec 21 17:23:02 | *word = 0, len = 1
mail15r-ds3400-1 (3600a0b80005a67b60000046d4cac464f) dm-6 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=0 status=enabled
| `- 5:0:0:15 sdv  65:80  active faulty running
`-+- policy='round-robin 0' prio=-1 status=active
  `- 1:0:0:15 sdh  8:112  active undef  running

--------------070006090406080306050402
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070006090406080306050402--
