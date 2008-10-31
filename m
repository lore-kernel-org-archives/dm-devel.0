From: <Yanqing_Liu@Dell.com>
Subject: Dm error: reload ioctl failed
Date: Fri, 31 Oct 2008 12:26:21 -0500
Message-ID: <00FE57DD11E3A94893D5BD54C3358BE884BFBB@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Hi,

In testing with dm-rdac, I found that multipathing device cannot be
properly craeted. The kernel version is 2.6.27-rc7 (SLES11 beta2
kernel), multipathing tool version is 2.4.8-21.1.=20

Theie is error message "ibdevmapper: ioctl/libdm-iface.c(1691):
device-mapper: reload ioctl failed: Invalid argument".

Can anyone help?

Thanks.

......

Oct 29 10:31:01 | sdo: ownership set to mpathg
Oct 29 10:31:01 | sdo: not found in pathvec
Oct 29 10:31:01 | sdo: mask =3D 0xc
Oct 29 10:31:01 | sdo: path checker =3D rdac (controller setting)
Oct 29 10:31:01 | sdo: state =3D 4
Oct 29 10:31:01 | sdo: prio =3D const (config file default)
Oct 29 10:31:01 | sdo: const prio =3D 1
Oct 29 10:31:01 | mpathg: pgfailback =3D -2 (controller setting)
Oct 29 10:31:01 | mpathg: pgpolicy =3D group_by_prio (controller setting)
Oct 29 10:31:01 | mpathg: selector =3D round-robin 0 (internal default)
Oct 29 10:31:01 | mpathg: features =3D 0 (internal default)
Oct 29 10:31:01 | mpathg: hwhandler =3D 1 rdac (controller setting)
Oct 29 10:31:01 | mpathg: rr_weight =3D 1 (internal default)
Oct 29 10:31:01 | mpathg: minio =3D 1000 (config file default)
Oct 29 10:31:01 | mpathg: no_path_retry =3D NONE (internal default)
Oct 29 10:31:01 | pg_timeout =3D NONE (internal default)
Oct 29 10:31:01 | mpathg: set ACT_CREATE (map does not exist)
Oct 29 10:31:01 | libdevmapper: ioctl/libdm-iface.c(1691):
device-mapper: reload ioctl failed: Invalid argument
Oct 29 10:31:01 | libdevmapper: ioctl/libdm-iface.c(1691):
device-mapper: reload ioctl failed: Invalid argument
Oct 29 10:31:01 | mpathg: domap (0) failure for create/reload map
Oct 29 10:31:01 | mpathg: remove multipath map
Oct 29 10:31:01 | sdj: orphaned
Oct 29 10:31:01 | sdk: orphaned
Oct 29 10:31:01 | sdo: orphaned
Oct 29 10:31:01 | sdm: (DELL:Universal Xport) vendor/product blacklisted
Oct 29 10:31:01 | sdl: (DELL:Universal Xport) vendor/product blacklisted
Oct 29 10:31:01 | Found matching wwid
[36001422000ffe20800009751490092f9] in bindings file. Setting alias to
mpathf
Oct 29 10:31:01 | sdi: ownership set to mpathf
Oct 29 10:31:01 | sdi: not found in pathvec
Oct 29 10:31:01 | sdi: mask =3D 0xc
Oct 29 10:31:01 | sdi: path checker =3D rdac (controller setting)
Oct 29 10:31:01 | sdi: state =3D 2
Oct 29 10:31:01 | sdi: prio =3D const (config file default)
Oct 29 10:31:01 | sdi: const prio =3D 1
Oct 29 10:31:01 | sdh: ownership set to mpathf
Oct 29 10:31:01 | sdh: not found in pathvec
Oct 29 10:31:01 | sdh: mask =3D 0xc
Oct 29 10:31:01 | sdh: path checker =3D rdac (controller setting)
Oct 29 10:31:01 | sdh: state =3D 2
Oct 29 10:31:01 | sdh: prio =3D const (config file default)
Oct 29 10:31:01 | sdh: const prio =3D 1
Oct 29 10:31:01 | sdn: ownership set to mpathf
Oct 29 10:31:01 | sdn: not found in pathvec
Oct 29 10:31:01 | sdn: mask =3D 0xc
Oct 29 10:31:01 | sdn: path checker =3D rdac (controller setting)
Oct 29 10:31:01 | sdn: state =3D 4
Oct 29 10:31:01 | sdn: prio =3D const (config file default)
Oct 29 10:31:01 | sdn: const prio =3D 1
Oct 29 10:31:01 | mpathf: pgfailback =3D -2 (controller setting)
Oct 29 10:31:01 | mpathf: pgpolicy =3D group_by_prio (controller setting)
Oct 29 10:31:01 | mpathf: selector =3D round-robin 0 (internal default)
Oct 29 10:31:01 | mpathf: features =3D 0 (internal default)
Oct 29 10:31:01 | mpathf: hwhandler =3D 1 rdac (controller setting)
Oct 29 10:31:01 | mpathf: rr_weight =3D 1 (internal default)
Oct 29 10:31:01 | mpathf: minio =3D 1000 (config file default)
Oct 29 10:31:01 | mpathf: no_path_retry =3D NONE (internal default)
Oct 29 10:31:01 | pg_timeout =3D NONE (internal default)
Oct 29 10:31:01 | mpathf: set ACT_CREATE (map does not exist)
Oct 29 10:31:01 | libdevmapper: ioctl/libdm-iface.c(1691):
device-mapper: reload ioctl failed: Invalid argument
Oct 29 10:31:02 | libdevmapper: ioctl/libdm-iface.c(1691):
device-mapper: reload ioctl failed: Invalid argument
Oct 29 10:31:02 | mpathf: domap (0) failure for create/reload map
Oct 29 10:31:02 | mpathf: remove multipath map
Oct 29 10:31:02 | sdi: orphaned
Oct 29 10:31:02 | sdh: orphaned
Oct 29 10:31:02 | sdn: orphaned
Oct 29 10:31:02 | Found matching wwid
[36000d56000b8509e0000131149009898] in bindings file. Setting alias to
mpathg
Oct 29 10:31:02 | sdj: ownership set to mpathg
Oct 29 10:31:02 | sdj: not found in pathvec
Oct 29 10:31:02 | sdj: mask =3D 0xc
Oct 29 10:31:02 | sdj: path checker =3D rdac (controller setting)
Oct 29 10:31:02 | sdj: state =3D 2
Oct 29 10:31:02 | sdj: prio =3D const (config file default)
Oct 29 10:31:02 | sdj: const prio =3D 1
Oct 29 10:31:02 | sdk: ownership set to mpathg
Oct 29 10:31:02 | sdk: not found in pathvec
Oct 29 10:31:02 | sdk: mask =3D 0xc
Oct 29 10:31:02 | sdk: path checker =3D rdac (controller setting)
Oct 29 10:31:02 | sdk: state =3D 2
Oct 29 10:31:02 | sdk: prio =3D const (config file default)
Oct 29 10:31:02 | sdk: const prio =3D 1
Oct 29 10:31:02 | sdo: ownership set to mpathg
Oct 29 10:31:02 | sdo: not found in pathvec
Oct 29 10:31:02 | sdo: mask =3D 0xc
Oct 29 10:31:02 | sdo: path checker =3D rdac (controller setting)
Oct 29 10:31:02 | sdo: state =3D 4
Oct 29 10:31:02 | sdo: prio =3D const (config file default)
Oct 29 10:31:02 | sdo: const prio =3D 1
Oct 29 10:31:02 | mpathg: pgfailback =3D -2 (controller setting)
Oct 29 10:31:02 | mpathg: pgpolicy =3D group_by_prio (controller setting)
Oct 29 10:31:02 | mpathg: selector =3D round-robin 0 (internal default)
Oct 29 10:31:02 | mpathg: features =3D 0 (internal default)
Oct 29 10:31:02 | mpathg: hwhandler =3D 1 rdac (controller setting)
Oct 29 10:31:02 | mpathg: rr_weight =3D 1 (internal default)
Oct 29 10:31:02 | mpathg: minio =3D 1000 (config file default)
Oct 29 10:31:02 | mpathg: no_path_retry =3D NONE (internal default)
Oct 29 10:31:02 | pg_timeout =3D NONE (internal default)
Oct 29 10:31:02 | mpathg: set ACT_CREATE (map does not exist)
Oct 29 10:31:02 | libdevmapper: ioctl/libdm-iface.c(1691):
device-mapper: reload ioctl failed: Invalid argument
Oct 29 10:31:02 | libdevmapper: ioctl/libdm-iface.c(1691):
device-mapper: reload ioctl failed: Invalid argument
Oct 29 10:31:02 | mpathg: domap (0) failure for create/reload map
Oct 29 10:31:02 | mpathg: remove multipath map
Oct 29 10:31:02 | sdj: orphaned
Oct 29 10:31:02 | sdk: orphaned
Oct 29 10:31:02 | sdo: orphaned
Oct 29 10:31:02 | sdp: (DELL:Universal Xport) vendor/product blacklisted

Thanks,
Yanqing
