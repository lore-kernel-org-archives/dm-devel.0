From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: multipath-tools - checker for DDN S2A8500
Date: Wed, 26 Jul 2006 14:06:24 +0200
Message-ID: <44C75AC0.1030905@ext.bull.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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
Cc: =?ISO-8859-1?Q?Ludovic_Fran=E7ois?= <lfrancois@datadirectnet.com>, Alain Moulle <Alain.Moulle@bull.net>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Hello,


When using multipath-tools 0.4.7, I would like to reports that DDN S2A8500 disk 
array reports a wrong status whith 'readsector0' checker. 'directio' seems to be 
the right checker for such storage system (see following logs).
Can you update hwtable.c in this way ?


multipathd logs when using 'readsector0':

[root@iotiger2 ~]# multipathd -d -v3
Jul 26 10:53:59 | --------start up--------
Jul 26 10:53:59 | read /etc/multipath.conf
Jul 26 10:53:59 | dm-0: blacklisted
Jul 26 10:53:59 | dm-1: blacklisted
Jul 26 10:53:59 | dm-2: blacklisted
Jul 26 10:53:59 | dm-3: blacklisted
Jul 26 10:53:59 | hda: blacklisted
Jul 26 10:53:59 | loop0: blacklisted
Jul 26 10:53:59 | loop1: blacklisted
Jul 26 10:53:59 | loop2: blacklisted
Jul 26 10:53:59 | loop3: blacklisted
Jul 26 10:53:59 | loop4: blacklisted
Jul 26 10:53:59 | loop5: blacklisted
Jul 26 10:53:59 | loop6: blacklisted
Jul 26 10:53:59 | loop7: blacklisted
Jul 26 10:53:59 | ram0: blacklisted
Jul 26 10:53:59 | ram1: blacklisted
Jul 26 10:53:59 | ram2: blacklisted
...
Jul 26 10:53:59 | sdc: not found in pathvec
Jul 26 10:53:59 | sdc: mask = 0x1f
Jul 26 10:53:59 | sdc: bus = 1
Jul 26 10:53:59 | sdc: dev_t = 8:32
Jul 26 10:53:59 | sdc: size = 571416576
Jul 26 10:53:59 | sdc: vendor = DDN
Jul 26 10:53:59 | sdc: product = S2A 8500
Jul 26 10:53:59 | sdc: rev = 5.22
Jul 26 10:53:59 | sdc: h:b:t:l = 4:0:0:0
Jul 26 10:53:59 | sdc: tgt_node_name = 0x20000001ff0302a8
Jul 26 10:53:59 | sdc: serial =
Jul 26 10:53:59 | sdc: path checker = readsector0 (config file default)
Jul 26 10:53:59 | sdc: state = 1
Jul 26 10:53:59 | sdc: checker msg is "readsector0 checker reports path is down"
Jul 26 10:53:59 | sdc: getuid = /sbin/scsi_id -g -u -s /block/%n (config file 
default)
Jul 26 10:53:59 | sdc: uid = 360001ff02002110102a8fe1c220f0100 (callout)
Jul 26 10:53:59 | sdd: not found in pathvec
Jul 26 10:53:59 | sdd: mask = 0x1f
Jul 26 10:53:59 | sdd: bus = 1
Jul 26 10:53:59 | sdd: dev_t = 8:48
Jul 26 10:53:59 | sdd: size = 571416576
Jul 26 10:53:59 | sdd: vendor = DDN
Jul 26 10:53:59 | sdd: product = S2A 8500
Jul 26 10:53:59 | sdd: rev = 5.22
Jul 26 10:53:59 | sdd: h:b:t:l = 4:0:0:1
Jul 26 10:53:59 | sdd: tgt_node_name = 0x20000001ff0302a8
Jul 26 10:53:59 | sdd: serial =
Jul 26 10:53:59 | sdd: path checker = readsector0 (config file default)
Jul 26 10:53:59 | sdd: state = 1
Jul 26 10:53:59 | sdd: checker msg is "readsector0 checker reports path is down"
Jul 26 10:53:59 | sdd: getuid = /sbin/scsi_id -g -u -s /block/%n (config file 
default)
Jul 26 10:53:59 | sdd: uid = 360001ff02002110102a8fe20220f0300 (callout)
Jul 26 10:53:59 | sde: not found in pathvec
...

then, multipathd logs when using 'directio':

Jul 26 10:56:09 | --------start up--------
Jul 26 10:56:09 | read /etc/multipath.conf
Jul 26 10:56:09 | dm-0: blacklisted
Jul 26 10:56:09 | dm-1: blacklisted
Jul 26 10:56:09 | dm-2: blacklisted
Jul 26 10:56:09 | dm-3: blacklisted
Jul 26 10:56:09 | dm-4: blacklisted
Jul 26 10:56:09 | hda: blacklisted
Jul 26 10:56:09 | loop0: blacklisted
Jul 26 10:56:09 | loop1: blacklisted
Jul 26 10:56:09 | loop2: blacklisted
Jul 26 10:56:09 | loop3: blacklisted
Jul 26 10:56:09 | loop4: blacklisted
Jul 26 10:56:09 | loop5: blacklisted
Jul 26 10:56:09 | loop6: blacklisted
Jul 26 10:56:09 | loop7: blacklisted
Jul 26 10:56:09 | ram0: blacklisted
Jul 26 10:56:09 | ram1: blacklisted
Jul 26 10:56:09 | ram2: blacklisted
...
Jul 26 10:56:09 | sdc: not found in pathvec
Jul 26 10:56:09 | sdc: mask = 0x1f
Jul 26 10:56:09 | sdc: bus = 1
Jul 26 10:56:09 | sdc: dev_t = 8:32
Jul 26 10:56:09 | sdc: size = 571416576
Jul 26 10:56:09 | sdc: vendor = DDN
Jul 26 10:56:09 | sdc: product = S2A 8500
Jul 26 10:56:09 | sdc: rev = 5.22
Jul 26 10:56:09 | sdc: h:b:t:l = 4:0:0:0
Jul 26 10:56:09 | sdc: tgt_node_name = 0x20000001ff0302a8
Jul 26 10:56:09 | sdc: serial =
Jul 26 10:56:09 | sdc: path checker = directio (config file default)
Jul 26 10:56:09 | sdc: state = 0
Jul 26 10:56:09 | sdc: getprio = /bin/true (config file default)
Jul 26 10:56:09 | sdc: prio = 0
Jul 26 10:56:09 | sdc: getuid = /sbin/scsi_id -g -u -s /block/%n (config file 
default)
Jul 26 10:56:09 | sdc: uid = 360001ff02002110102a8fe1c220f0100 (callout)
Jul 26 10:56:09 | sdd: not found in pathvec
Jul 26 10:56:09 | sdd: mask = 0x1f
Jul 26 10:56:09 | sdd: bus = 1
Jul 26 10:56:09 | sdd: dev_t = 8:48
Jul 26 10:56:09 | sdd: size = 571416576
Jul 26 10:56:09 | sdd: vendor = DDN
Jul 26 10:56:09 | sdd: product = S2A 8500
Jul 26 10:56:09 | sdd: rev = 5.22
Jul 26 10:56:09 | sdd: h:b:t:l = 4:0:0:1
Jul 26 10:56:09 | sdd: tgt_node_name = 0x20000001ff0302a8
Jul 26 10:56:09 | sdd: serial =
Jul 26 10:56:09 | sdd: path checker = directio (config file default)
Jul 26 10:56:09 | sdd: state = 0
Jul 26 10:56:09 | sdd: getprio = /bin/true (config file default)
Jul 26 10:56:09 | sdd: prio = 0
Jul 26 10:56:09 | sdd: getuid = /sbin/scsi_id -g -u -s /block/%n (config file 
default)
Jul 26 10:56:09 | sdd: uid = 360001ff02002110102a8fe20220f0300 (callout)
Jul 26 10:56:09 | sde: not found in pathvec
Jul 26 10:56:09 | sde: mask = 0x1f
Jul 26 10:56:09 | sde: bus = 1
Jul 26 10:56:09 | sde: dev_t = 8:64
Jul 26 10:56:09 | sde: size = 571416576
Jul 26 10:56:09 | sde: vendor = DDN
Jul 26 10:56:09 | sde: product = S2A 8500
Jul 26 10:56:09 | sde: rev = 5.22
Jul 26 10:56:09 | sde: h:b:t:l = 4:0:0:2
Jul 26 10:56:09 | sde: tgt_node_name = 0x20000001ff0302a8
Jul 26 10:56:09 | sde: serial =
Jul 26 10:56:09 | sde: path checker = directio (config file default)
Jul 26 10:56:09 | sde: state = 0
Jul 26 10:56:09 | sde: getprio = /bin/true (config file default)
Jul 26 10:56:09 | sde: prio = 0
Jul 26 10:56:09 | sde: getuid = /sbin/scsi_id -g -u -s /block/%n (config file 
default)
Jul 26 10:56:09 | sde: uid = 360001ff02002110102a8fe24220f0500 (callout)
...


Best regards


-- 
Frederic TEMPORELLI
