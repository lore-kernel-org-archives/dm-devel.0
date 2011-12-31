From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: mpathpersist
Date: Sat, 31 Dec 2011 15:00:15 +0100
Message-ID: <1325340015.6564.18.camel@lapoo.opensvc.com>
References: <4EFEA631.3020902@internyc.net>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EFEA631.3020902@internyc.net>
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


> I have seen your set of patches for persistent reservation of multipath
> devices and wanted to try them out. While trying this patch set I have
> run into several issues. Which code base can I apply this against? Any
> help would be greatly appreciated. Issues are listed below.

This patchset has been developped by Netapp's Vijay Chauhan.

> 2. I pulled multipath-tools from opensvc git and that patching failed
> too, so I had to apply all the patches manually.
> 
This is the correct project repository. The patchset may need rebasing
over the HEAD. If it does not apply cleanly there, you might try to
revert to a previous commit.

I'll try this patchset soon and compare my experience with your
observations.

Thanks for the report.

> 3. while testing mppersist I get following error:
> 
> mpathpersist --out --register --param-sark=123abc --prout-type=8
> /dev/mapper/blah -v 4
> Dec 31 00:54:29 | alias = blah
> Dec 31 00:54:29 | params = 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1
> Dec 31 00:54:29 | status = 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 A 0
> Dec 31 00:54:29 | blah: disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
> 8:16 1 ]
> Dec 31 00:54:29 | 8:0: not found in pathvec
> Dec 31 00:54:29 | 8:16: not found in pathvec
> Dec 31 00:54:29 | No device found for 8:0
> 
> Dec 31 00:54:29 | No device found for 8:16
> 
> Dec 31 00:54:29 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0 A 0
> 8:16 A 0 ]
> Dec 31 00:54:29 | 36001405c55fc03cd8193d491eda0d4d7: no path available
> PR out: command failed
> 
> 4. with all patches applied, all multipathd cli commands crash the daemon.
> 
> here are my configs:
> 
> cat /etc/multipath.conf
> defaults {
> 	user_friendly_names	yes
> 	polling_interval	10
> }
> 
> multipaths {
> 	multipath {
> 		wwid			36001405c55fc03cd8193d491eda0d4d7
> 		alias			blah
> 	}
> }
> 
> 
> devices {
> 	device {
> 		vendor			"QNAP"
> 		product			"iSCSI Storage"
> 		path_selector		"round-robin 0"
> 		path_grouping_policy	multibus
> 		getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
> 		path_checker		directio
> 		failback		immediate
> 	}
> 
> }
> 
> blacklist {
>         devnode "^(vd)[a-z]"
> }
> 
> multipath -ll -v3
> Dec 31 00:59:01 | loading /lib64/multipath/libcheckdirectio.so checker
> Dec 31 00:59:01 | loading /lib64/multipath/libprioconst.so prioritizer
> Dec 31 00:59:01 | loop0: device node name blacklisted
> Dec 31 00:59:01 | loop1: device node name blacklisted
> Dec 31 00:59:01 | loop2: device node name blacklisted
> Dec 31 00:59:01 | loop3: device node name blacklisted
> Dec 31 00:59:01 | loop4: device node name blacklisted
> Dec 31 00:59:01 | loop5: device node name blacklisted
> Dec 31 00:59:01 | loop6: device node name blacklisted
> Dec 31 00:59:01 | loop7: device node name blacklisted
> Dec 31 00:59:01 | vda: device node name blacklisted
> Dec 31 00:59:01 | dm-0: device node name blacklisted
> Dec 31 00:59:01 | dm-1: device node name blacklisted
> Dec 31 00:59:01 | dm-2: device node name blacklisted
> Dec 31 00:59:01 | dm-3: device node name blacklisted
> Dec 31 00:59:01 | sda: not found in pathvec
> Dec 31 00:59:01 | sda: mask = 0x5
> Dec 31 00:59:01 | sda: dev_t = 8:0
> Dec 31 00:59:01 | sda: size = 20971520
> Dec 31 00:59:01 | sda: vendor = QNAP
> Dec 31 00:59:01 | sda: product = iSCSI Storage
> Dec 31 00:59:01 | sda: rev = 3.1
> Dec 31 00:59:01 | sda: h:b:t:l = 2:0:0:0
> Dec 31 00:59:01 | sda: path state = running
> Dec 31 00:59:01 | sda: get_state
> Dec 31 00:59:01 | sda: path checker = directio (controller setting)
> Dec 31 00:59:01 | sda: checker timeout = 30000 ms (sysfs setting)
> Dec 31 00:59:01 | directio: starting new request
> Dec 31 00:59:01 | directio: io finished 4096/0
> Dec 31 00:59:01 | sda: state = up
> Dec 31 00:59:01 | sdb: not found in pathvec
> Dec 31 00:59:01 | sdb: mask = 0x5
> Dec 31 00:59:01 | sdb: dev_t = 8:16
> Dec 31 00:59:01 | sdb: size = 20971520
> Dec 31 00:59:01 | sdb: vendor = QNAP
> Dec 31 00:59:01 | sdb: product = iSCSI Storage
> Dec 31 00:59:01 | sdb: rev = 3.1
> Dec 31 00:59:01 | sdb: h:b:t:l = 3:0:0:0
> Dec 31 00:59:01 | sdb: path state = running
> Dec 31 00:59:01 | sdb: get_state
> Dec 31 00:59:01 | sdb: path checker = directio (controller setting)
> Dec 31 00:59:01 | sdb: checker timeout = 30000 ms (sysfs setting)
> Dec 31 00:59:01 | directio: starting new request
> Dec 31 00:59:01 | directio: io finished 4096/0
> Dec 31 00:59:01 | sdb: state = up
> Dec 31 00:59:01 | dm-4: device node name blacklisted
> ===== paths list =====
> uuid hcil    dev dev_t pri dm_st chk_st vend/prod/rev      dev_st
>      2:0:0:0 sda 8:0   -1  undef ready  QNAP,iSCSI Storage running
>      3:0:0:0 sdb 8:16  -1  undef ready  QNAP,iSCSI Storage running
> Dec 31 00:59:01 | params = 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1
> Dec 31 00:59:01 | status = 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 A 0
> Dec 31 00:59:01 | blah: disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
> 8:16 1 ]
> Dec 31 00:59:01 | sda: mask = 0x8
> Dec 31 00:59:01 | sda: path state = running
> Dec 31 00:59:01 | sda: prio = const (internal default)
> Dec 31 00:59:01 | sda: prio =  (internal default)
> Dec 31 00:59:01 | sda: const prio = 1
> Dec 31 00:59:01 | sdb: mask = 0x8
> Dec 31 00:59:01 | sdb: path state = running
> Dec 31 00:59:01 | sdb: prio = const (internal default)
> Dec 31 00:59:01 | sdb: prio =  (internal default)
> Dec 31 00:59:01 | sdb: const prio = 1
> Dec 31 00:59:01 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0 A 0
> 8:16 A 0 ]
> blah (36001405c55fc03cd8193d491eda0d4d7) dm-4 QNAP,iSCSI Storage
> size=10G features='0' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=0 status=active
>   |- 2:0:0:0 sda 8:0  active ready running
>   `- 3:0:0:0 sdb 8:16 active ready running
> Dec 31 00:59:01 | directio checker refcount 2
> Dec 31 00:59:01 | directio checker refcount 1
> Dec 31 00:59:01 | unloading const prioritizer
> Dec 31 00:59:01 | unloading directio checker
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
