From: "Brian Long" <briandlong@gmail.com>
Subject: [RHEL 4 U2] Recommended blacklist for Sun X4200, V40z
Date: Wed, 29 Mar 2006 10:40:05 -0500
Message-ID: <1c59d60b0603290740p7831d874h840add20cc5abab3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_8964_16965281.1143646805230"
Return-path: <dm-devel-bounces@redhat.com>
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

------=_Part_8964_16965281.1143646805230
Content-Type: multipart/alternative;
	boundary="----=_Part_8965_23484689.1143646805230"

------=_Part_8965_23484689.1143646805230
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm running RHEL 4 U2 (device-mapper-multipath-0.4.5-6.0.RHEL4).  I have a
multipath.conf which uses the compiled-in blacklist.  I also have specified
device entries specific to certain EMC arrays in use (see attached
multipath.conf).  The majority of our hosts are HP Proliant with cciss loca=
l
disks and they are blacklisted appropriately.  When I use the same
multipath.conf on a Sun V40z or X4200, multipathing is not working and I
believe it's because the internal disk (LSI Logic / MPT Fusion RAID) is not
blacklisted (see attached multipath-v3.out for details).

Is there a recommended blacklist entry for these hosts?  Can I blacklist by
vendor ID instead of device?

Thank you.

/Brian/

------=_Part_8965_23484689.1143646805230
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm running RHEL 4 U2 (device-mapper-multipath-0.4.5-6.0.RHEL4).&nbsp; I ha=
ve a multipath.conf which uses the compiled-in blacklist.&nbsp; I also have=
 specified device entries specific to certain EMC arrays in use (see attach=
ed multipath.conf
).&nbsp; The majority of our hosts are HP Proliant with cciss local disks a=
nd they are blacklisted appropriately.&nbsp; When I use the same multipath.=
conf on a Sun V40z or X4200, multipathing is not working and I believe it's=
 because the internal disk (LSI Logic / MPT Fusion RAID) is not blacklisted=
 (see attached=20
multipath-v3.out for details).<br><br>Is there a recommended blacklist entr=
y for these hosts?&nbsp; Can I blacklist by vendor ID instead of device?<br=
><br>Thank you.<br><br>/Brian/<br><br><br>

------=_Part_8965_23484689.1143646805230--

------=_Part_8964_16965281.1143646805230
Content-Type: application/octet-stream; name=multipath.conf
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_eldtumnl
Content-Disposition: attachment; filename="multipath.conf"

# See /usr/share/doc/device-mapper-multipath-*/multipath.conf.annotated
# for a fully-detailed multipath.conf.
#
# BEGIN Cisco-specific configuration
defaults {
       multipath_tool           "/sbin/multipath -v0"
       udev_dir                 /dev
       polling_interval         10
       default_selector         "round-robin 0"
       default_path_grouping_policy    multibus
       default_getuid_callout   "/sbin/scsi_id -g -u -s /block/%n"
       default_prio_callout     "/bin/true"
       default_features         "0"
       rr_wmin_io               100
       failback                 immediate
}
# Only specify options in the devices section to override the defaults.
devices {
    # EMC Symmetrix / DMX
    device {
        vendor                  "EMC     "
        product                 "SYMMETRIX     "
    }
    # EMC Clariion (active/passive)
    device {
        vendor "DGC     "
        product "RAID 5        "
        path_grouping_policy    failover
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        path_checker            emc_clariion
        path_selector           "round-robin 0"
        features	            "0"
        hardware_handler        "1 emc"
        failback                immediate
    }
    device {
        vendor "DGC     "
        product "              "
        path_grouping_policy    failover
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        path_checker            emc_clariion
        path_selector           "round-robin 0"
        features	            "0"
        hardware_handler        "1 emc"
        failback                immediate
    }
}
# END Cisco-specific configuration


------=_Part_8964_16965281.1143646805230
Content-Type: application/octet-stream; name=multipath-v3.out
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_eldtv9zg
Content-Disposition: attachment; filename="multipath-v3.out"

hda blacklisted
md0 blacklisted
ram0 blacklisted
ram10 blacklisted
ram11 blacklisted
ram12 blacklisted
ram13 blacklisted
ram14 blacklisted
ram15 blacklisted
ram1 blacklisted
ram2 blacklisted
ram3 blacklisted
ram4 blacklisted
ram5 blacklisted
ram6 blacklisted
ram7 blacklisted
ram8 blacklisted
ram9 blacklisted
path sdaa not found in pathvec

===== path sdaa =====
bus = 1
dev_t = 65:160
size = 53539200
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:18
tgt_node_name = 0x50060482c3a194cd
serial = 5012670AC000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______5012670AC000 (callout)
path sdab not found in pathvec

===== path sdab =====
bus = 1
dev_t = 65:176
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:20
tgt_node_name = 0x50060482c3a194cd
serial = 501267025000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267025000 (callout)
path sdac not found in pathvec

===== path sdac =====
bus = 1
dev_t = 65:192
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:21
tgt_node_name = 0x50060482c3a194cd
serial = 501267026000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267026000 (callout)
path sdad not found in pathvec

===== path sdad =====
bus = 1
dev_t = 65:208
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:22
tgt_node_name = 0x50060482c3a194cd
serial = 501267027000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267027000 (callout)
path sdae not found in pathvec

===== path sdae =====
bus = 1
dev_t = 65:224
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:23
tgt_node_name = 0x50060482c3a194cd
serial = 501267028000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267028000 (callout)
path sdaf not found in pathvec

===== path sdaf =====
bus = 1
dev_t = 65:240
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:24
tgt_node_name = 0x50060482c3a194cd
serial = 501267029000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267029000 (callout)
path sdag not found in pathvec

===== path sdag =====
bus = 1
dev_t = 66:0
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:25
tgt_node_name = 0x50060482c3a194cd
serial = 50126702A000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______50126702A000 (callout)
path sdah not found in pathvec

===== path sdah =====
bus = 1
dev_t = 66:16
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:26
tgt_node_name = 0x50060482c3a194cd
serial = 50126702B000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______50126702B000 (callout)
path sdai not found in pathvec

===== path sdai =====
bus = 1
dev_t = 66:32
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:27
tgt_node_name = 0x50060482c3a194cd
serial = 50126702C000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______50126702C000 (callout)
path sdaj not found in pathvec

===== path sdaj =====
bus = 1
dev_t = 66:48
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:28
tgt_node_name = 0x50060482c3a194cd
serial = 50126702D000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______50126702D000 (callout)
path sdak not found in pathvec

===== path sdak =====
bus = 1
dev_t = 66:64
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:29
tgt_node_name = 0x50060482c3a194cd
serial = 50126702E000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______50126702E000 (callout)
path sdal not found in pathvec

===== path sdal =====
bus = 1
dev_t = 66:80
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:30
tgt_node_name = 0x50060482c3a194cd
serial = 50126702F000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______50126702F000 (callout)
path sdam not found in pathvec

===== path sdam =====
bus = 1
dev_t = 66:96
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:31
tgt_node_name = 0x50060482c3a194cd
serial = 501267030000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267030000 (callout)
path sdan not found in pathvec

===== path sdan =====
bus = 1
dev_t = 66:112
size = 17846400
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:32
tgt_node_name = 0x50060482c3a194cd
serial = 5012670AF000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______5012670AF000 (callout)
path sdao not found in pathvec

===== path sdao =====
bus = 1
dev_t = 66:128
size = 71385600
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:33
tgt_node_name = 0x50060482c3a194cd
serial = 5012670EF000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______5012670EF000 (callout)
path sdap not found in pathvec

===== path sdap =====
bus = 1
dev_t = 66:144
size = 71385600
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:34
tgt_node_name = 0x50060482c3a194cd
serial = 501267100000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267100000 (callout)
path sdaq not found in pathvec

===== path sdaq =====
bus = 1
dev_t = 66:160
size = 71385600
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:35
tgt_node_name = 0x50060482c3a194cd
serial = 501267118000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267118000 (callout)
path sdar not found in pathvec

===== path sdar =====
bus = 1
dev_t = 66:176
size = 71385600
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:36
tgt_node_name = 0x50060482c3a194cd
serial = 501267112000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______501267112000 (callout)
path sdas not found in pathvec

===== path sdas =====
bus = 1
dev_t = 66:192
size = 245760
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:52
tgt_node_name = 0x50060482c3a194cd
serial = 50126710B000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______50126710B000 (callout)
path sdat not found in pathvec

===== path sdat =====
bus = 1
dev_t = 66:208
size = 5760
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:240
tgt_node_name = 0x50060482c3a194cd
serial = 5012670CF000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______5012670CF000 (callout)
path sdau not found in pathvec

===== path sdau =====
bus = 1
dev_t = 66:224
size = 5760
vendor = EMC     
product = SYMMETRIX       
rev = 5568
h:b:t:l = 2:0:0:241
tgt_node_name = 0x50060482c3a194cd
serial = 5012670D0000
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = SEMC_____SYMMETRIX______5012670D0000 (callout)
path sdav not found in pathvec

===== path sdav =====
bus = 1
dev_t = 66:240

------=_Part_8964_16965281.1143646805230
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_Part_8964_16965281.1143646805230--
