From: Tejas Rao <raot@bnl.gov>
Subject: Add. Sense: Data synchronization mark error
Date: Thu, 14 Jan 2016 15:43:49 -0500
Message-ID: <56980885.2040506@bnl.gov>
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
To: dm-devel@redhat.com
Cc: Rao Tejas <raot@bnl.gov>
List-Id: dm-devel.ids

We are using linux raid on top of multipath devices (each jbod disk has 
two paths).

Usually medium erros are handled as below. See this bug for a similar 
problem but fixed in RHEL6.

https://bugzilla.redhat.com/show_bug.cgi?id=516170

Jan 12 02:15:59  kernel: sd 8:0:21:0: [sdcf] Unhandled sense code
Jan 12 02:15:59  kernel: sd 8:0:21:0: [sdcf] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
Jan 12 02:15:59  kernel: sd 8:0:21:0: [sdcf] Sense Key : Medium Error 
[current] [descriptor]
Jan 12 02:15:59  kernel: Descriptor sense data with sense descriptors 
(in hex):
Jan 12 02:15:59  kernel:        72 03 11 00 00 00 00 34 00 0a 80 00 00 
00 00 01
Jan 12 02:15:59  kernel:        cd e3 86 90 01 0a 00 00 00 00 00 00 81 
03 01 00
Jan 12 02:15:59  kernel:        02 06 00 00 80 00 ff 00 03 02 00 86 80 
0e 00 00
Jan 12 02:15:59  kernel:        00 00 00 00 00 00 00 00 00 00 00 00
Jan 12 02:15:59  kernel: sd 8:0:21:0: [sdcf] Add. Sense: Unrecovered 
read error
Jan 12 02:15:59  kernel: sd 8:0:21:0: [sdcf] CDB: Read(16): 88 00 00 00 
00 01 cd e3 86 00 00 00 01 00 00 00
Jan 12 02:16:02  kernel: sd 7:0:21:0: [sdx] Unhandled sense code
Jan 12 02:16:02  kernel: sd 7:0:21:0: [sdx] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
Jan 12 02:16:02  kernel: sd 7:0:21:0: [sdx] Sense Key : Medium Error 
[current] [descriptor]
Jan 12 02:16:02  kernel: Descriptor sense data with sense descriptors 
(in hex):
Jan 12 02:16:02  kernel:        72 03 11 00 00 00 00 34 00 0a 80 00 00 
00 00 01
Jan 12 02:16:02  kernel:        cd e3 86 90 01 0a 00 00 00 00 00 00 81 
03 01 00
Jan 12 02:16:02  kernel:        02 06 00 00 80 00 ff 00 03 02 00 86 80 
0e 00 00
Jan 12 02:16:02  kernel:        00 00 00 00 00 00 00 00 00 00 00 00
Jan 12 02:16:02  kernel: sd 7:0:21:0: [sdx] Add. Sense: Unrecovered read 
error
Jan 12 02:16:02  kernel: sd 7:0:21:0: [sdx] CDB: Read(16): 88 00 00 00 
00 01 cd e3 86 90 00 00 00 70 00 00
Jan 12 02:16:03  kernel: md/raid:md3: read error corrected (8 sectors at 
7749205728 on dm-22)
Jan 12 02:16:03  kernel: md/raid:md3: read error corrected (8 sectors at 
7749205736 on dm-22)
Jan 12 02:16:03  kernel: md/raid:md3: read error corrected (8 sectors at 
7749205744 on dm-22)
Jan 12 02:16:03  kernel: md/raid:md3: read error corrected (8 sectors at 
7749205752 on dm-22)

This is all fine and dandy.

We had a case as below and this continued repeatedly for 4 hours until I 
logged in and manually failed both paths sdx and sdcf. - (sdx and sdcf 
are the same drive). The filesystem running on  md3 was hung.

Jan 12 02:38:48 kernel: sd 7:0:21:0: [sdx] Unhandled sense code
Jan 12 02:38:48 kernel: sd 7:0:21:0: [sdx] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
Jan 12 02:38:48 kernel: sd 7:0:21:0: [sdx] Sense Key : Medium Error 
[current] [descriptor]
Jan 12 02:38:48 kernel: Descriptor sense data with sense descriptors (in 
hex):
Jan 12 02:38:48 kernel:        72 03 16 00 00 00 00 34 00 0a 80 00 00 00 
00 01
Jan 12 02:38:48 kernel:        d1 53 bd 98 01 0a 00 00 00 00 00 00 86 01 
00 00
Jan 12 02:38:48 kernel:        02 06 00 00 80 00 ff 00 03 02 00 80 80 0e 
00 00
Jan 12 02:38:48 kernel:        00 00 00 00 00 00 00 00 00 00 00 00
Jan 12 02:38:48 kernel: sd 7:0:21:0: [sdx] Add. Sense: Data 
synchronization mark error
Jan 12 02:38:48 kernel: sd 7:0:21:0: [sdx] CDB: Read(16): 88 00 00 00 00 
01 d1 53 bd 98 00 00 00 68 00 00
Jan 12 02:38:48 kernel: device-mapper: multipath: Failing path 65:112.
Jan 12 02:38:48 multipathd: 65:112: mark as failed
Jan 12 02:38:48 multipathd: mpathab: remaining active paths: 1
Jan 12 02:38:52 multipathd: mpathab: sdx - directio checker reports path 
is up
Jan 12 02:38:52 multipathd: 65:112: reinstated
Jan 12 02:38:52 multipathd: mpathab: remaining active paths: 2
Jan 12 02:39:04 multipathd: 69:48: mark as failed
Jan 12 02:39:04 multipathd: mpathab: remaining active paths: 1
Jan 12 02:39:04 kernel: sd 8:0:21:0: [sdcf] Unhandled sense code
Jan 12 02:39:04 kernel: sd 8:0:21:0: [sdcf] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
Jan 12 02:39:04 kernel: sd 8:0:21:0: [sdcf] Sense Key : Medium Error 
[current] [descriptor]
Jan 12 02:39:04 kernel: Descriptor sense data with sense descriptors (in 
hex):
Jan 12 02:39:04 kernel:        72 03 16 00 00 00 00 34 00 0a 80 00 00 00 
00 01
Jan 12 02:39:04 kernel:        d1 53 bd 98 01 0a 00 00 00 00 00 00 86 01 
00 00
Jan 12 02:39:04 kernel:        02 06 00 00 80 00 ff 00 03 02 00 80 80 0e 
00 00
Jan 12 02:39:04 kernel:        00 00 00 00 00 00 00 00 00 00 00 00
Jan 12 02:39:04 kernel: sd 8:0:21:0: [sdcf] Add. Sense: Data 
synchronization mark error
Jan 12 02:39:04 kernel: sd 8:0:21:0: [sdcf] CDB: Read(16): 88 00 00 00 
00 01 d1 53 bd 98 00 00 00 68 00 00
Jan 12 02:39:04 kernel: device-mapper: multipath: Failing path 69:48.
Jan 12 02:39:05 multipathd: mpathab: sdcf - directio checker reports 
path is up
Jan 12 02:39:05 multipathd: 69:48: reinstated
Jan 12 02:39:05 multipathd: mpathab: remaining active paths: 2


[root@ ~]# rpm -qa | grep multi
device-mapper-multipath-libs-0.4.9-72.el6_5.3.x86_64
device-mapper-multipath-0.4.9-72.el6_5.3.x86_64
[root@ ~]# uname -a
Linux  2.6.32-431.23.3.el6.x86_64 #1 SMP Wed Jul 16 06:12:23 EDT 2014 
x86_64 x86_64 x86_64 GNU/Linux


Anyone know if there is a workaround or patch for this? What does "Add. 
Sense: Data synchronization mark error" mean?



Thanks
