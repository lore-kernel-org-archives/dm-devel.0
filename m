From: Christian May <cmay@linux.vnet.ibm.com>
Subject: RHEL6.2: path failures during good path I/O
Date: Wed, 13 Jun 2012 13:02:13 +0200
Message-ID: <4FD87335.3040300@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,
I've setup RHEL 6.2 on a VIO server. Two pathes to the DS4300 storage 
server are established using two VIO server.
Ten SCSI LUNs were assigned to the RHEL system:

[root@jabulan-lp4 ~]# lsscsi
[0:0:1:0]    disk    AIX      VDASD            0001  /dev/sda
[0:0:2:0]    cd/dvd  AIX      VOPTA                  /dev/sr0
[0:0:3:0]    tape    VIOS     VTAPE            0001  /dev/st0
[1:0:1:0]    disk    AIX      VDASD            0001  /dev/sdb
[2:0:1:0]    disk    AIX      VDASD            0001  /dev/sdc
[3:0:1:0]    disk    AIX      VDASD            0001  /dev/sdd
[4:0:1:0]    disk    AIX      VDASD            0001  /dev/sde
[5:0:1:0]    disk    AIX      VDASD            0001  /dev/sdf
[6:0:1:0]    disk    AIX      VDASD            0001  /dev/sdg
[7:0:1:0]    disk    AIX      VDASD            0001  /dev/sdh
[8:0:1:0]    disk    AIX      VDASD            0001  /dev/sdi
[9:0:1:0]    disk    AIX      VDASD            0001  /dev/sdj
[10:0:1:0]   disk    AIX      VDASD            0001  /dev/sdk
[11:0:1:0]   disk    AIX      VDASD            0001  /dev/sdl
[12:0:1:0]   disk    AIX      VDASD            0001  /dev/sdm
[13:0:1:0]   disk    AIX      VDASD            0001  /dev/sdn
[14:0:1:0]   disk    AIX      VDASD            0001  /dev/sdo
[15:0:1:0]   disk    AIX      VDASD            0001  /dev/sdp
[16:0:1:0]   disk    AIX      VDASD            0001  /dev/sdq
[17:0:1:0]   disk    AIX      VDASD            0001  /dev/sdr
[18:0:1:0]   disk    AIX      VDASD            0001  /dev/sds
[19:0:1:0]   disk    AIX      VDASD            0001  /dev/sdt
[20:0:1:0]   disk    AIX      VDASD            0001  /dev/sdu
[root@jabulan-lp4 ~]#

[root@jabulan-lp4 ~]# multipath -ll
Jun 13 12:55:28 | libdevmapper version 1.02.66-RHEL6 (2011-10-12)
Jun 13 12:55:28 | DM multipath kernel driver v1.3.0
Jun 13 12:55:28 | loading /lib64/multipath/libcheckdirectio.so checker
Jun 13 12:55:28 | loading /lib64/multipath/libprioconst.so prioritizer
Jun 13 12:55:28 | ram0: device node name blacklisted
Jun 13 12:55:28 | ram1: device node name blacklisted
Jun 13 12:55:28 | ram2: device node name blacklisted
Jun 13 12:55:28 | ram3: device node name blacklisted
Jun 13 12:55:28 | ram4: device node name blacklisted
Jun 13 12:55:28 | ram5: device node name blacklisted
Jun 13 12:55:28 | ram6: device node name blacklisted
Jun 13 12:55:28 | ram7: device node name blacklisted
Jun 13 12:55:28 | ram8: device node name blacklisted
Jun 13 12:55:28 | ram9: device node name blacklisted
Jun 13 12:55:28 | ram10: device node name blacklisted
Jun 13 12:55:28 | ram11: device node name blacklisted
Jun 13 12:55:28 | ram12: device node name blacklisted
Jun 13 12:55:28 | ram13: device node name blacklisted
Jun 13 12:55:28 | ram14: device node name blacklisted
Jun 13 12:55:28 | ram15: device node name blacklisted
Jun 13 12:55:28 | loop0: device node name blacklisted
Jun 13 12:55:28 | loop1: device node name blacklisted
Jun 13 12:55:28 | loop2: device node name blacklisted
Jun 13 12:55:28 | loop3: device node name blacklisted
Jun 13 12:55:28 | loop4: device node name blacklisted
Jun 13 12:55:28 | loop5: device node name blacklisted
Jun 13 12:55:28 | loop6: device node name blacklisted
Jun 13 12:55:28 | loop7: device node name blacklisted
Jun 13 12:55:28 | sda: device node name blacklisted
Jun 13 12:55:28 | sdc: not found in pathvec
Jun 13 12:55:28 | sdc: mask = 0x5
Jun 13 12:55:28 | sdc: dev_t = 8:32
Jun 13 12:55:28 | sdc: size = 104857600
Jun 13 12:55:28 | sdc: subsystem = scsi
Jun 13 12:55:28 | sdc: vendor = AIX
Jun 13 12:55:28 | sdc: product = VDASD
Jun 13 12:55:28 | sdc: rev = 0001
Jun 13 12:55:28 | sdc: h:b:t:l = 2:0:1:0
Jun 13 12:55:28 | sdc: get_state
Jun 13 12:55:28 | sdc: path checker = directio (controller setting)
Jun 13 12:55:28 | sdc: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:28 | sdc: state = running
Jun 13 12:55:28 | directio: starting new request
Jun 13 12:55:28 | directio: io finished 4096/0
Jun 13 12:55:28 | sdc: state = 3
Jun 13 12:55:28 | sdb: not found in pathvec
Jun 13 12:55:28 | sdb: mask = 0x5
Jun 13 12:55:28 | sdb: dev_t = 8:16
Jun 13 12:55:28 | sdb: size = 104857600
Jun 13 12:55:28 | sdb: subsystem = scsi
Jun 13 12:55:28 | sdb: vendor = AIX
Jun 13 12:55:28 | sdb: product = VDASD
Jun 13 12:55:28 | sdb: rev = 0001
Jun 13 12:55:28 | sdb: h:b:t:l = 1:0:1:0
Jun 13 12:55:28 | sdb: get_state
Jun 13 12:55:28 | sdb: path checker = directio (controller setting)
Jun 13 12:55:28 | sdb: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:28 | sdb: state = running
Jun 13 12:55:28 | directio: starting new request
Jun 13 12:55:28 | directio: io finished 4096/0
Jun 13 12:55:28 | sdb: state = 3
Jun 13 12:55:28 | sde: not found in pathvec
Jun 13 12:55:28 | sde: mask = 0x5
Jun 13 12:55:28 | sde: dev_t = 8:64
Jun 13 12:55:28 | sde: size = 104857464
Jun 13 12:55:28 | sde: subsystem = scsi
Jun 13 12:55:28 | sde: vendor = AIX
Jun 13 12:55:28 | sde: product = VDASD
Jun 13 12:55:28 | sde: rev = 0001
Jun 13 12:55:28 | sde: h:b:t:l = 4:0:1:0
Jun 13 12:55:28 | sde: get_state
Jun 13 12:55:28 | sde: path checker = directio (controller setting)
Jun 13 12:55:28 | sde: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:28 | sde: state = running
Jun 13 12:55:28 | directio: starting new request
Jun 13 12:55:28 | directio: io finished 4096/0
Jun 13 12:55:28 | sde: state = 3
Jun 13 12:55:28 | sdi: not found in pathvec
Jun 13 12:55:28 | sdi: mask = 0x5
Jun 13 12:55:28 | sdi: dev_t = 8:128
Jun 13 12:55:28 | sdi: size = 104857600
Jun 13 12:55:28 | sdi: subsystem = scsi
Jun 13 12:55:28 | sdi: vendor = AIX
Jun 13 12:55:28 | sdi: product = VDASD
Jun 13 12:55:28 | sdi: rev = 0001
Jun 13 12:55:28 | sdi: h:b:t:l = 8:0:1:0
Jun 13 12:55:28 | sdi: get_state
Jun 13 12:55:28 | sdi: path checker = directio (controller setting)
Jun 13 12:55:28 | sdi: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:28 | sdi: state = running
Jun 13 12:55:28 | directio: starting new request
Jun 13 12:55:28 | directio: io finished 4096/0
Jun 13 12:55:28 | sdi: state = 3
Jun 13 12:55:28 | sdh: not found in pathvec
Jun 13 12:55:28 | sdh: mask = 0x5
Jun 13 12:55:28 | sdh: dev_t = 8:112
Jun 13 12:55:28 | sdh: size = 104857600
Jun 13 12:55:28 | sdh: subsystem = scsi
Jun 13 12:55:28 | sdh: vendor = AIX
Jun 13 12:55:28 | sdh: product = VDASD
Jun 13 12:55:28 | sdh: rev = 0001
Jun 13 12:55:28 | sdh: h:b:t:l = 7:0:1:0
Jun 13 12:55:28 | sdh: get_state
Jun 13 12:55:28 | sdh: path checker = directio (controller setting)
Jun 13 12:55:28 | sdh: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:28 | sdh: state = running
Jun 13 12:55:28 | directio: starting new request
Jun 13 12:55:28 | directio: io finished 4096/0
Jun 13 12:55:28 | sdh: state = 3
Jun 13 12:55:28 | sdg: not found in pathvec
Jun 13 12:55:28 | sdg: mask = 0x5
Jun 13 12:55:28 | sdg: dev_t = 8:96
Jun 13 12:55:28 | sdg: size = 104857600
Jun 13 12:55:28 | sdg: subsystem = scsi
Jun 13 12:55:28 | sdg: vendor = AIX
Jun 13 12:55:28 | sdg: product = VDASD
Jun 13 12:55:28 | sdg: rev = 0001
Jun 13 12:55:28 | sdg: h:b:t:l = 6:0:1:0
Jun 13 12:55:28 | sdg: get_state
Jun 13 12:55:28 | sdg: path checker = directio (controller setting)
Jun 13 12:55:28 | sdg: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:28 | sdg: state = running
Jun 13 12:55:28 | directio: starting new request
Jun 13 12:55:28 | directio: io finished 4096/0
Jun 13 12:55:28 | sdg: state = 3
Jun 13 12:55:28 | sdf: not found in pathvec
Jun 13 12:55:28 | sdf: mask = 0x5
Jun 13 12:55:28 | sdf: dev_t = 8:80
Jun 13 12:55:28 | sdf: size = 104857600
Jun 13 12:55:28 | sdf: subsystem = scsi
Jun 13 12:55:28 | sdf: vendor = AIX
Jun 13 12:55:28 | sdf: product = VDASD
Jun 13 12:55:28 | sdf: rev = 0001
Jun 13 12:55:28 | sdf: h:b:t:l = 5:0:1:0
Jun 13 12:55:28 | sdf: get_state
Jun 13 12:55:28 | sdf: path checker = directio (controller setting)
Jun 13 12:55:28 | sdf: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:28 | sdf: state = running
Jun 13 12:55:28 | directio: starting new request
Jun 13 12:55:29 | directio: io finished 4096/0
Jun 13 12:55:29 | sdf: state = 3
Jun 13 12:55:29 | sdd: not found in pathvec
Jun 13 12:55:29 | sdd: mask = 0x5
Jun 13 12:55:29 | sdd: dev_t = 8:48
Jun 13 12:55:29 | sdd: size = 104857600
Jun 13 12:55:29 | sdd: subsystem = scsi
Jun 13 12:55:29 | sdd: vendor = AIX
Jun 13 12:55:29 | sdd: product = VDASD
Jun 13 12:55:29 | sdd: rev = 0001
Jun 13 12:55:29 | sdd: h:b:t:l = 3:0:1:0
Jun 13 12:55:29 | sdd: get_state
Jun 13 12:55:29 | sdd: path checker = directio (controller setting)
Jun 13 12:55:29 | sdd: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:29 | sdd: state = running
Jun 13 12:55:29 | directio: starting new request
Jun 13 12:55:29 | directio: io finished 4096/0
Jun 13 12:55:29 | sdd: state = 3
Jun 13 12:55:29 | sdj: not found in pathvec
Jun 13 12:55:29 | sdj: mask = 0x5
Jun 13 12:55:29 | sdj: dev_t = 8:144
Jun 13 12:55:29 | sdj: size = 104857600
Jun 13 12:55:29 | sdj: subsystem = scsi
Jun 13 12:55:29 | sdj: vendor = AIX
Jun 13 12:55:29 | sdj: product = VDASD
Jun 13 12:55:29 | sdj: rev = 0001
Jun 13 12:55:29 | sdj: h:b:t:l = 9:0:1:0
Jun 13 12:55:29 | sdj: get_state
Jun 13 12:55:29 | sdj: path checker = directio (controller setting)
Jun 13 12:55:29 | sdj: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:29 | sdj: state = running
Jun 13 12:55:29 | directio: starting new request
Jun 13 12:55:29 | directio: io finished 4096/0
Jun 13 12:55:29 | sdj: state = 3
Jun 13 12:55:29 | sdk: not found in pathvec
Jun 13 12:55:29 | sdk: mask = 0x5
Jun 13 12:55:29 | sdk: dev_t = 8:160
Jun 13 12:55:29 | sdk: size = 104857600
Jun 13 12:55:29 | sdk: subsystem = scsi
Jun 13 12:55:29 | sdk: vendor = AIX
Jun 13 12:55:29 | sdk: product = VDASD
Jun 13 12:55:29 | sdk: rev = 0001
Jun 13 12:55:29 | sdk: h:b:t:l = 10:0:1:0
Jun 13 12:55:29 | sdk: get_state
Jun 13 12:55:29 | sdk: path checker = directio (controller setting)
Jun 13 12:55:29 | sdk: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:29 | sdk: state = running
Jun 13 12:55:29 | directio: starting new request
Jun 13 12:55:29 | directio: io finished 4096/0
Jun 13 12:55:29 | sdk: state = 3
Jun 13 12:55:29 | sdl: not found in pathvec
Jun 13 12:55:29 | sdl: mask = 0x5
Jun 13 12:55:29 | sdl: dev_t = 8:176
Jun 13 12:55:29 | sdl: size = 104857600
Jun 13 12:55:29 | sdl: subsystem = scsi
Jun 13 12:55:29 | sdl: vendor = AIX
Jun 13 12:55:29 | sdl: product = VDASD
Jun 13 12:55:29 | sdl: rev = 0001
Jun 13 12:55:29 | sdl: h:b:t:l = 11:0:1:0
Jun 13 12:55:29 | sdl: get_state
Jun 13 12:55:29 | sdl: path checker = directio (controller setting)
Jun 13 12:55:29 | sdl: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:29 | sdl: state = running
Jun 13 12:55:29 | directio: starting new request
Jun 13 12:55:29 | directio: io finished 4096/0
Jun 13 12:55:29 | sdl: state = 3
Jun 13 12:55:29 | sdm: not found in pathvec
Jun 13 12:55:29 | sdm: mask = 0x5
Jun 13 12:55:29 | sdm: dev_t = 8:192
Jun 13 12:55:29 | sdm: size = 104857600
Jun 13 12:55:29 | sdm: subsystem = scsi
Jun 13 12:55:29 | sdm: vendor = AIX
Jun 13 12:55:29 | sdm: product = VDASD
Jun 13 12:55:29 | sdm: rev = 0001
Jun 13 12:55:29 | sdm: h:b:t:l = 12:0:1:0
Jun 13 12:55:29 | sdm: get_state
Jun 13 12:55:29 | sdm: path checker = directio (controller setting)
Jun 13 12:55:29 | sdm: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:29 | sdm: state = running
Jun 13 12:55:29 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sdm: state = 3
Jun 13 12:55:30 | sdn: not found in pathvec
Jun 13 12:55:30 | sdn: mask = 0x5
Jun 13 12:55:30 | sdn: dev_t = 8:208
Jun 13 12:55:30 | sdn: size = 104857600
Jun 13 12:55:30 | sdn: subsystem = scsi
Jun 13 12:55:30 | sdn: vendor = AIX
Jun 13 12:55:30 | sdn: product = VDASD
Jun 13 12:55:30 | sdn: rev = 0001
Jun 13 12:55:30 | sdn: h:b:t:l = 13:0:1:0
Jun 13 12:55:30 | sdn: get_state
Jun 13 12:55:30 | sdn: path checker = directio (controller setting)
Jun 13 12:55:30 | sdn: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:30 | sdn: state = running
Jun 13 12:55:30 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sdn: state = 3
Jun 13 12:55:30 | sdp: not found in pathvec
Jun 13 12:55:30 | sdp: mask = 0x5
Jun 13 12:55:30 | sdp: dev_t = 8:240
Jun 13 12:55:30 | sdp: size = 104857464
Jun 13 12:55:30 | sdp: subsystem = scsi
Jun 13 12:55:30 | sdp: vendor = AIX
Jun 13 12:55:30 | sdp: product = VDASD
Jun 13 12:55:30 | sdp: rev = 0001
Jun 13 12:55:30 | sdp: h:b:t:l = 15:0:1:0
Jun 13 12:55:30 | sdp: get_state
Jun 13 12:55:30 | sdp: path checker = directio (controller setting)
Jun 13 12:55:30 | sdp: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:30 | sdp: state = running
Jun 13 12:55:30 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sdp: state = 3
Jun 13 12:55:30 | sdo: not found in pathvec
Jun 13 12:55:30 | sdo: mask = 0x5
Jun 13 12:55:30 | sdo: dev_t = 8:224
Jun 13 12:55:30 | sdo: size = 104857600
Jun 13 12:55:30 | sdo: subsystem = scsi
Jun 13 12:55:30 | sdo: vendor = AIX
Jun 13 12:55:30 | sdo: product = VDASD
Jun 13 12:55:30 | sdo: rev = 0001
Jun 13 12:55:30 | sdo: h:b:t:l = 14:0:1:0
Jun 13 12:55:30 | sdo: get_state
Jun 13 12:55:30 | sdo: path checker = directio (controller setting)
Jun 13 12:55:30 | sdo: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:30 | sdo: state = running
Jun 13 12:55:30 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sdo: state = 3
Jun 13 12:55:30 | sdq: not found in pathvec
Jun 13 12:55:30 | sdq: mask = 0x5
Jun 13 12:55:30 | sdq: dev_t = 65:0
Jun 13 12:55:30 | sdq: size = 104857600
Jun 13 12:55:30 | sdq: subsystem = scsi
Jun 13 12:55:30 | sdq: vendor = AIX
Jun 13 12:55:30 | sdq: product = VDASD
Jun 13 12:55:30 | sdq: rev = 0001
Jun 13 12:55:30 | sdq: h:b:t:l = 16:0:1:0
Jun 13 12:55:30 | sdq: get_state
Jun 13 12:55:30 | sdq: path checker = directio (controller setting)
Jun 13 12:55:30 | sdq: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:30 | sdq: state = running
Jun 13 12:55:30 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sdq: state = 3
Jun 13 12:55:30 | sdr: not found in pathvec
Jun 13 12:55:30 | sdr: mask = 0x5
Jun 13 12:55:30 | sdr: dev_t = 65:16
Jun 13 12:55:30 | sdr: size = 104857600
Jun 13 12:55:30 | sdr: subsystem = scsi
Jun 13 12:55:30 | sdr: vendor = AIX
Jun 13 12:55:30 | sdr: product = VDASD
Jun 13 12:55:30 | sdr: rev = 0001
Jun 13 12:55:30 | sdr: h:b:t:l = 17:0:1:0
Jun 13 12:55:30 | sdr: get_state
Jun 13 12:55:30 | sdr: path checker = directio (controller setting)
Jun 13 12:55:30 | sdr: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:30 | sdr: state = running
Jun 13 12:55:30 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sdr: state = 3
Jun 13 12:55:30 | sds: not found in pathvec
Jun 13 12:55:30 | sds: mask = 0x5
Jun 13 12:55:30 | sds: dev_t = 65:32
Jun 13 12:55:30 | sds: size = 104857600
Jun 13 12:55:30 | sds: subsystem = scsi
Jun 13 12:55:30 | sds: vendor = AIX
Jun 13 12:55:30 | sds: product = VDASD
Jun 13 12:55:30 | sds: rev = 0001
Jun 13 12:55:30 | sds: h:b:t:l = 18:0:1:0
Jun 13 12:55:30 | sds: get_state
Jun 13 12:55:30 | sds: path checker = directio (controller setting)
Jun 13 12:55:30 | sds: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:30 | sds: state = running
Jun 13 12:55:30 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sds: state = 3
Jun 13 12:55:30 | sdu: not found in pathvec
Jun 13 12:55:30 | sdu: mask = 0x5
Jun 13 12:55:30 | sdu: dev_t = 65:64
Jun 13 12:55:30 | sdu: size = 104857600
Jun 13 12:55:30 | sdu: subsystem = scsi
Jun 13 12:55:30 | sdu: vendor = AIX
Jun 13 12:55:30 | sdu: product = VDASD
Jun 13 12:55:30 | sdu: rev = 0001
Jun 13 12:55:30 | sdu: h:b:t:l = 20:0:1:0
Jun 13 12:55:30 | sdu: get_state
Jun 13 12:55:30 | sdu: path checker = directio (controller setting)
Jun 13 12:55:30 | sdu: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:30 | sdu: state = running
Jun 13 12:55:30 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sdu: state = 3
Jun 13 12:55:30 | sdt: not found in pathvec
Jun 13 12:55:30 | sdt: mask = 0x5
Jun 13 12:55:30 | sdt: dev_t = 65:48
Jun 13 12:55:30 | sdt: size = 104857600
Jun 13 12:55:30 | sdt: subsystem = scsi
Jun 13 12:55:30 | sdt: vendor = AIX
Jun 13 12:55:30 | sdt: product = VDASD
Jun 13 12:55:30 | sdt: rev = 0001
Jun 13 12:55:30 | sdt: h:b:t:l = 19:0:1:0
Jun 13 12:55:30 | sdt: get_state
Jun 13 12:55:30 | sdt: path checker = directio (controller setting)
Jun 13 12:55:30 | sdt: checker timeout = 120000 ms (sysfs setting)
Jun 13 12:55:30 | sdt: state = running
Jun 13 12:55:30 | directio: starting new request
Jun 13 12:55:30 | directio: io finished 4096/0
Jun 13 12:55:30 | sdt: state = 3
Jun 13 12:55:30 | sr0: device node name blacklisted
Jun 13 12:55:30 | dm-0: device node name blacklisted
Jun 13 12:55:30 | dm-1: device node name blacklisted
Jun 13 12:55:30 | dm-2: device node name blacklisted
Jun 13 12:55:30 | dm-3: device node name blacklisted
Jun 13 12:55:30 | dm-4: device node name blacklisted
Jun 13 12:55:30 | dm-5: device node name blacklisted
Jun 13 12:55:30 | dm-6: device node name blacklisted
Jun 13 12:55:30 | dm-7: device node name blacklisted
Jun 13 12:55:30 | dm-8: device node name blacklisted
Jun 13 12:55:30 | dm-9: device node name blacklisted
Jun 13 12:55:30 | dm-10: device node name blacklisted
Jun 13 12:55:30 | dm-11: device node name blacklisted
Jun 13 12:55:30 | dm-12: device node name blacklisted
Jun 13 12:55:30 | dm-13: device node name blacklisted
Jun 13 12:55:30 | dm-14: device node name blacklisted
Jun 13 12:55:30 | dm-15: device node name blacklisted
Jun 13 12:55:30 | dm-16: device node name blacklisted
Jun 13 12:55:30 | dm-17: device node name blacklisted
Jun 13 12:55:30 | dm-18: device node name blacklisted
Jun 13 12:55:30 | dm-19: device node name blacklisted
Jun 13 12:55:30 | dm-20: device node name blacklisted
Jun 13 12:55:30 | dm-21: device node name blacklisted
Jun 13 12:55:30 | dm-22: device node name blacklisted
Jun 13 12:55:30 | dm-23: device node name blacklisted
Jun 13 12:55:30 | dm-24: device node name blacklisted
Jun 13 12:55:30 | dm-25: device node name blacklisted
Jun 13 12:55:30 | dm-26: device node name blacklisted
Jun 13 12:55:30 | dm-27: device node name blacklisted
Jun 13 12:55:30 | dm-28: device node name blacklisted
Jun 13 12:55:30 | dm-30: device node name blacklisted
Jun 13 12:55:30 | dm-31: device node name blacklisted
Jun 13 12:55:30 | dm-29: device node name blacklisted
Jun 13 12:55:30 | dm-32: device node name blacklisted
Jun 13 12:55:30 | dm-33: device node name blacklisted
Jun 13 12:55:30 | dm-34: device node name blacklisted
Jun 13 12:55:30 | dm-35: device node name blacklisted
Jun 13 12:55:30 | dm-36: device node name blacklisted
Jun 13 12:55:30 | dm-37: device node name blacklisted
Jun 13 12:55:30 | dm-38: device node name blacklisted
Jun 13 12:55:30 | dm-39: device node name blacklisted
Jun 13 12:55:30 | dm-40: device node name blacklisted
Jun 13 12:55:30 | dm-41: device node name blacklisted
Jun 13 12:55:30 | dm-42: device node name blacklisted
Jun 13 12:55:30 | dm-43: device node name blacklisted
Jun 13 12:55:30 | dm-44: device node name blacklisted
Jun 13 12:55:30 | dm-46: device node name blacklisted
Jun 13 12:55:30 | dm-45: device node name blacklisted
Jun 13 12:55:30 | dm-47: device node name blacklisted
Jun 13 12:55:30 | dm-48: device node name blacklisted
Jun 13 12:55:30 | dm-49: device node name blacklisted
===== paths list =====
uuid hcil     dev dev_t pri dm_st chk_st vend/prod/rev dev_st
      2:0:1:0  sdc 8:32  -1  undef ready  AIX,VDASD     running
      1:0:1:0  sdb 8:16  -1  undef ready  AIX,VDASD     running
      4:0:1:0  sde 8:64  -1  undef ready  AIX,VDASD     running
      8:0:1:0  sdi 8:128 -1  undef ready  AIX,VDASD     running
      7:0:1:0  sdh 8:112 -1  undef ready  AIX,VDASD     running
      6:0:1:0  sdg 8:96  -1  undef ready  AIX,VDASD     running
      5:0:1:0  sdf 8:80  -1  undef ready  AIX,VDASD     running
      3:0:1:0  sdd 8:48  -1  undef ready  AIX,VDASD     running
      9:0:1:0  sdj 8:144 -1  undef ready  AIX,VDASD     running
      10:0:1:0 sdk 8:160 -1  undef ready  AIX,VDASD     running
      11:0:1:0 sdl 8:176 -1  undef ready  AIX,VDASD     running
      12:0:1:0 sdm 8:192 -1  undef ready  AIX,VDASD     running
      13:0:1:0 sdn 8:208 -1  undef ready  AIX,VDASD     running
      15:0:1:0 sdp 8:240 -1  undef ready  AIX,VDASD     running
      14:0:1:0 sdo 8:224 -1  undef ready  AIX,VDASD     running
      16:0:1:0 sdq 65:0  -1  undef ready  AIX,VDASD     running
      17:0:1:0 sdr 65:16 -1  undef ready  AIX,VDASD     running
      18:0:1:0 sds 65:32 -1  undef ready  AIX,VDASD     running
      20:0:1:0 sdu 65:64 -1  undef ready  AIX,VDASD     running
      19:0:1:0 sdt 65:48 -1  undef ready  AIX,VDASD     running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:64 1 8:240 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:64 A 10 8:240 A 8
Jun 13 12:55:30 | sde: mask = 0x8
Jun 13 12:55:30 | sde: state = running
Jun 13 12:55:30 | sde: prio = const (controller setting)
Jun 13 12:55:30 | sde: const prio = 1
Jun 13 12:55:30 | sdp: mask = 0x8
Jun 13 12:55:30 | sdp: state = running
Jun 13 12:55:30 | sdp: prio = const (controller setting)
Jun 13 12:55:30 | sdp: const prio = 1
mpathe (3600a0b8000135943000040ee4ed81c2e) dm-2 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 4:0:1:0  sde 8:64  active ready running
   `- 15:0:1:0 sdp 8:240 active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:96 1 65:16 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:96 A 0 65:16 A 0
Jun 13 12:55:30 | sdg: mask = 0x8
Jun 13 12:55:30 | sdg: state = running
Jun 13 12:55:30 | sdg: prio = const (controller setting)
Jun 13 12:55:30 | sdg: const prio = 1
Jun 13 12:55:30 | sdr: mask = 0x8
Jun 13 12:55:30 | sdr: state = running
Jun 13 12:55:30 | sdr: prio = const (controller setting)
Jun 13 12:55:30 | sdr: const prio = 1
mpathd (3600a0b800013e21a00003bd14f6facf1) dm-5 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 6:0:1:0  sdg 8:96  active ready running
   `- 17:0:1:0 sdr 65:16 active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:16 1 8:192 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:16 A 10 8:192 A 6
Jun 13 12:55:30 | sdb: mask = 0x8
Jun 13 12:55:30 | sdb: state = running
Jun 13 12:55:30 | sdb: prio = const (controller setting)
Jun 13 12:55:30 | sdb: const prio = 1
Jun 13 12:55:30 | sdm: mask = 0x8
Jun 13 12:55:30 | sdm: state = running
Jun 13 12:55:30 | sdm: prio = const (controller setting)
Jun 13 12:55:30 | sdm: const prio = 1
mpathb (3600a0b8000135943000040eb4ed81b44) dm-1 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 1:0:1:0  sdb 8:16  active ready running
   `- 12:0:1:0 sdm 8:192 active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:32 1 8:208 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:32 A 0 8:208 A 0
Jun 13 12:55:30 | sdc: mask = 0x8
Jun 13 12:55:30 | sdc: state = running
Jun 13 12:55:30 | sdc: prio = const (controller setting)
Jun 13 12:55:30 | sdc: const prio = 1
Jun 13 12:55:30 | sdn: mask = 0x8
Jun 13 12:55:30 | sdn: state = running
Jun 13 12:55:30 | sdn: prio = const (controller setting)
Jun 13 12:55:30 | sdn: const prio = 1
mpatha (3600a0b8000135943000040ed4ed81bec) dm-0 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 2:0:1:0  sdc 8:32  active ready running
   `- 13:0:1:0 sdn 8:208 active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:80 1 65:0 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:80 A 7 65:0 A 6
Jun 13 12:55:30 | sdf: mask = 0x8
Jun 13 12:55:30 | sdf: state = running
Jun 13 12:55:30 | sdf: prio = const (controller setting)
Jun 13 12:55:30 | sdf: const prio = 1
Jun 13 12:55:30 | sdq: mask = 0x8
Jun 13 12:55:30 | sdq: state = running
Jun 13 12:55:30 | sdq: prio = const (controller setting)
Jun 13 12:55:30 | sdq: const prio = 1
mpathk (3600a0b8000135943000041b64f6fc15c) dm-6 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 5:0:1:0  sdf 8:80  active ready running
   `- 16:0:1:0 sdq 65:0  active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:160 1 8:176 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:160 A 0 8:176 A 0
Jun 13 12:55:30 | sdk: mask = 0x8
Jun 13 12:55:30 | sdk: state = running
Jun 13 12:55:30 | sdk: prio = const (controller setting)
Jun 13 12:55:30 | sdk: const prio = 1
Jun 13 12:55:30 | sdl: mask = 0x8
Jun 13 12:55:30 | sdl: state = running
Jun 13 12:55:30 | sdl: prio = const (controller setting)
Jun 13 12:55:30 | sdl: const prio = 1
mpathj (3600a0b800013e21a00003bd54f6fad85) dm-9 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 10:0:1:0 sdk 8:160 active ready running
   `- 11:0:1:0 sdl 8:176 active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:128 1 65:48 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:128 A 10 65:48 A 4
Jun 13 12:55:30 | sdi: mask = 0x8
Jun 13 12:55:30 | sdi: state = running
Jun 13 12:55:30 | sdi: prio = const (controller setting)
Jun 13 12:55:30 | sdi: const prio = 1
Jun 13 12:55:30 | sdt: mask = 0x8
Jun 13 12:55:30 | sdt: state = running
Jun 13 12:55:30 | sdt: prio = const (controller setting)
Jun 13 12:55:30 | sdt: const prio = 1
mpathi (3600a0b8000135943000041b44f6fc0d4) dm-3 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 8:0:1:0  sdi 8:128 active ready running
   `- 19:0:1:0 sdt 65:48 active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:144 1 65:64 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:144 A 0 65:64 A 0
Jun 13 12:55:30 | sdj: mask = 0x8
Jun 13 12:55:30 | sdj: state = running
Jun 13 12:55:30 | sdj: prio = const (controller setting)
Jun 13 12:55:30 | sdj: const prio = 1
Jun 13 12:55:30 | sdu: mask = 0x8
Jun 13 12:55:30 | sdu: state = running
Jun 13 12:55:30 | sdu: prio = const (controller setting)
Jun 13 12:55:30 | sdu: const prio = 1
mpathh (3600a0b800013594300005b974fc75194) dm-8 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 9:0:1:0  sdj 8:144 active ready running
   `- 20:0:1:0 sdu 65:64 active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:48 1 8:224 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:48 A 4 8:224 A 6
Jun 13 12:55:30 | sdd: mask = 0x8
Jun 13 12:55:30 | sdd: state = running
Jun 13 12:55:30 | sdd: prio = const (controller setting)
Jun 13 12:55:30 | sdd: const prio = 1
Jun 13 12:55:30 | sdo: mask = 0x8
Jun 13 12:55:30 | sdo: state = running
Jun 13 12:55:30 | sdo: prio = const (controller setting)
Jun 13 12:55:30 | sdo: const prio = 1
mpathg (3600a0b800013e21a00003b254ed809b5) dm-7 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 3:0:1:0  sdd 8:48  active ready running
   `- 14:0:1:0 sdo 8:224 active ready running
Jun 13 12:55:30 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 
8:112 1 65:32 1
Jun 13 12:55:30 | status = 2 0 0 0 1 1 A 0 2 0 8:112 A 0 65:32 A 0
Jun 13 12:55:30 | sdh: mask = 0x8
Jun 13 12:55:30 | sdh: state = running
Jun 13 12:55:30 | sdh: prio = const (controller setting)
Jun 13 12:55:30 | sdh: const prio = 1
Jun 13 12:55:30 | sds: mask = 0x8
Jun 13 12:55:30 | sds: state = running
Jun 13 12:55:30 | sds: prio = const (controller setting)
Jun 13 12:55:30 | sds: const prio = 1
mpathf (3600a0b800013e21a00003bd34f6fad45) dm-4 AIX,VDASD
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
   |- 7:0:1:0  sdh 8:112 active ready running
   `- 18:0:1:0 sds 65:32 active ready running


After starting filesystem and block I/O against the multipath devices 
I've noticed path failures. In order to get some more information I've 
changed verbosity to 3:

Jun 13 10:14:14 jabulan-lp4 multipathd: checker failed path 8:80 in map 
mpathk
Jun 13 10:14:14 jabulan-lp4 multipathd: mpathk: remaining active paths: 1
Jun 13 10:14:14 jabulan-lp4 kernel: device-mapper: multipath: Failing 
path 8:80.
Jun 13 10:14:15 jabulan-lp4 multipathd: mpathi: sdi - directio checker 
reports path is down
Jun 13 10:14:15 jabulan-lp4 multipathd: checker failed path 8:128 in map 
mpathi
Jun 13 10:14:15 jabulan-lp4 multipathd: mpathi: remaining active paths: 1
Jun 13 10:14:15 jabulan-lp4 kernel: device-mapper: multipath: Failing 
path 8:128.
Jun 13 10:14:15 jabulan-lp4 multipathd: mpathe: sdp - directio checker 
reports path is down
Jun 13 10:14:15 jabulan-lp4 multipathd: checker failed path 8:240 in map 
mpathe
Jun 13 10:14:15 jabulan-lp4 multipathd: mpathe: Entering recovery mode: 
max_retries=60
Jun 13 10:14:15 jabulan-lp4 multipathd: mpathe: remaining active paths: 0
Jun 13 10:14:15 jabulan-lp4 kernel: device-mapper: multipath: Failing 
path 8:240.
Jun 13 10:14:15 jabulan-lp4 multipathd: mpathe: Entering recovery mode: 
max_retries=60
Jun 13 10:14:16 jabulan-lp4 multipathd: mpathe: sde - directio checker 
reports path is up
Jun 13 10:14:16 jabulan-lp4 multipathd: 8:64: reinstated
Jun 13 10:14:16 jabulan-lp4 multipathd: mpathe: queue_if_no_path enabled
Jun 13 10:14:16 jabulan-lp4 multipathd: mpathe: Recovered to normal mode
Jun 13 10:14:16 jabulan-lp4 multipathd: mpathe: remaining active paths: 1
Jun 13 10:14:19 jabulan-lp4 multipathd: mpathk: sdf - directio checker 
reports path is up
Jun 13 10:14:19 jabulan-lp4 multipathd: 8:80: reinstated
Jun 13 10:14:19 jabulan-lp4 multipathd: mpathk: remaining active paths: 2
Jun 13 10:14:20 jabulan-lp4 multipathd: mpathi: sdi - directio checker 
reports path is up
Jun 13 10:14:20 jabulan-lp4 multipathd: 8:128: reinstated
Jun 13 10:14:20 jabulan-lp4 multipathd: mpathi: remaining active paths: 2
Jun 13 10:14:20 jabulan-lp4 multipathd: mpathe: sdp - directio checker 
reports path is up
Jun 13 10:14:20 jabulan-lp4 multipathd: 8:240: reinstated
Jun 13 10:14:20 jabulan-lp4 multipathd: mpathe: remaining active paths: 2
Jun 13 10:14:21 jabulan-lp4 kernel: sd 1:0:1:0: aborting command. lun 
0x8100000000000000, tag 0xc00000026d1719d0
Jun 13 10:14:21 jabulan-lp4 kernel: sd 1:0:1:0: aborted task tag 
0xc00000026d1719d0 completed
Jun 13 10:14:27 jabulan-lp4 multipathd: mpathb: sdm - directio checker 
reports path is down
Jun 13 10:14:27 jabulan-lp4 multipathd: checker failed path 8:192 in map 
mpathb
Jun 13 10:14:27 jabulan-lp4 multipathd: mpathb: remaining active paths: 1
Jun 13 10:14:27 jabulan-lp4 kernel: device-mapper: multipath: Failing 
path 8:192.
Jun 13 10:14:32 jabulan-lp4 multipathd: mpathb: sdm - directio checker 
reports path is up
Jun 13 10:14:32 jabulan-lp4 multipathd: 8:192: reinstated
Jun 13 10:14:32 jabulan-lp4 multipathd: mpathb: remaining active paths: 2
Jun 13 10:14:40 jabulan-lp4 kernel: sd 3:0:1:0: aborting command. lun 
0x8100000000000000, tag 0xc00000026d372890
Jun 13 10:14:40 jabulan-lp4 kernel: sd 3:0:1:0: aborted task tag 
0xc00000026d372890 completed
Jun 13 10:14:56 jabulan-lp4 kernel: sd 15:0:1:0: aborting command. lun 
0x8100000000000000, tag 0xc00000026d7084c0
Jun 13 10:14:57 jabulan-lp4 kernel: sd 15:0:1:0: aborted task tag 
0xc00000026d7084c0 completed
Jun 13 10:15:05 jabulan-lp4 kernel: sd 14:0:1:0: aborting command. lun 
0x8100000000000000, tag 0xc00000026d6bb2d8
Jun 13 10:15:05 jabulan-lp4 kernel: sd 14:0:1:0: aborted task tag 
0xc00000026d6bb2d8 completed
:

Any ideas why pathes get marked as failed?

Regards,

Christian May (IBM)
