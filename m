From: Martin Petermann <martin@linux.vnet.ibm.com>
Subject: question to queue_if_no_path
Date: Tue, 02 Sep 2008 23:59:53 +0200
Message-ID: <48BDB759.4000907@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
List-Id: dm-devel.ids

Hi,

I'm working on Linux on zSeries systems. Some of my colleagues do some 
testing with multipathing. Within the tests they conduct there is 
normally one path available: but it can happen that all paths disappear. 
They use the queue_if_no_path option to avoid any io problems if this 
case will happen. Unfortunately they receiving io errors. I can 
re-create this issue. I have looked for some documentation about the 
behavior using the queue_if_no_path option but was not successful.

I used a tool generating at lot of io on file systems formatted with 
ext3. If the paths are gone the application doing this io stress is 
stalled. After establishing the paths again the application is failing 
with io errors. If I look into the system message log file I can find 
EXT3 errors like the following:

Sep  2 11:58:34 t6360034 kernel: EXT3-fs error (device dm-15): 
ext3_journal_start_sb: <6>sd 1:0:10:1087455248: [sdg] Done: 0\
x0000000023b4fd00 SUCCESS

There also appear EXT3 errors not related to EXT3 journaling.

My question is if this is something that can be expected since the 
multipath queueing can not prevent from this. Is this behaviour 
something that only appears on Linux for zSeries.

Btw. the SCSI requests failing because of the detached devices return a 
DID_ERROR sense code:

Sep  2 11:56:50 t6360034 kernel: sd 1:0:10:1087520784: Notifying upper 
driver of completion (result 70000)

Regards
     Martin

I used the following configuration file for my tests:

defaults {
polling_interval 1
}

multipaths {
multipath {
wwid 36005076303ffc56200000000000010d1
alias mpvol1
}
multipath {
wwid 36005076303ffc56200000000000010d0
alias mpvol2
}
multipath {
wwid 36005076303ffc56200000000000010d3
alias mpvol3
}
}

[root@t6360034 /]# mount
/dev/dasda2 on / type ext3 (rw)
none on /proc type proc (rw)
none on /sys type sysfs (rw)
none on /dev/pts type devpts (rw,gid=5,mode=620)
none on /sys/kernel/debug type debugfs (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
/dev/mapper/mpvol1-part1 on /mpvol1-part1 type ext3 (rw)
/dev/mapper/mpvol1-part2 on /mpvol1-part2 type ext3 (rw)
/dev/mapper/mpvol1-part3 on /mpvol1-part3 type ext3 (rw)
/dev/mapper/mpvol1-part4 on /mpvol1-part4 type ext3 (rw)
/dev/mapper/mpvol2-part1 on /mpvol2-part1 type ext3 (rw)
/dev/mapper/mpvol2-part2 on /mpvol2-part2 type ext3 (rw)
/dev/mapper/mpvol2-part3 on /mpvol2-part3 type ext3 (rw)
/dev/mapper/mpvol2-part4 on /mpvol2-part4 type ext3 (rw)
/dev/mapper/mpvol3-part1 on /mpvol3-part1 type ext3 (rw)
/dev/mapper/mpvol3-part2 on /mpvol3-part2 type ext3 (rw)
/dev/mapper/mpvol3-part3 on /mpvol3-part3 type ext3 (rw)
/dev/mapper/mpvol3-part4 on /mpvol3-part4 type ext3 (rw)


multipath -ll shows the following:

[root@t6360034 devices]# multipath -ll
mpvol3 (36005076303ffc56200000000000010d3) dm-1 IBM,2107900
[size=5.0G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=2][enabled]
  \_ 0:0:11:1087586320 sdg 8:96  [active][ready]
  \_ 1:0:10:1087586320 sdm 8:192 [active][ready]
mpvol2 (36005076303ffc56200000000000010d0) dm-0 IBM,2107900
[size=5.0G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=2][enabled]
  \_ 0:0:11:1087389712 sdc 8:32  [active][ready]
  \_ 1:0:10:1087389712 sdl 8:176 [active][ready]
mpvol1 (36005076303ffc56200000000000010d1) dm-3 IBM,2107900
[size=5.0G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=2][enabled]
  \_ 0:0:11:1087455248 sdj 8:144 [active][ready]
  \_ 1:0:10:1087455248 sdk 8:160 [active][ready]
