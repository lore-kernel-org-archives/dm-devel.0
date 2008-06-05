From: Yan Li <elliot.li.tech@gmail.com>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Fri, 6 Jun 2008 06:44:10 +0800
Message-ID: <20080605224410.GA7584@yantp.cn.ibm.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com> <48439890.6030904@redhat.com> <20080602123145.GA8258@yantp.cn.ibm.com> <4843ECB8.4010002@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758988AbYFEWoe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4843ECB8.4010002@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Ritesh Raj Sarraf <rrs@researchut.com>, Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>, rjmaomao@gmail.com, Alasdair G Kergon <agk@redhat.com>, dm-crypt@saout.de
List-Id: dm-devel.ids


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2008 at 02:51:04PM +0200, Milan Broz wrote:
> Patch for 2.6.24 kernel
> Add cond_resched() to prevent stuck in big bio processing.

This patch actual has lead to performance _gain_.

Test Result, performance gain:
aes-cbc-essiv:sha256, keysize 128: 2.53%
aes-xts-plain, keysize 256: 0.26%
aes-xts-plain, keysize 512: 9.31%

Test kernel:
AMD64 2.6.24 from Debian Etch-and-a-half

Test command:
# dd if=/dev/zero of=/dev/mapper/open_device bs=500M count=100

This would write 50G zero data to an open LUKS raw device (no
filesystem overhead here), as 500M per block.  This will stress mainly
the cryptographic and dm code, with little overhead. During the test,
the CPU usage was always full, thus HD speed was not bottleneck.

The count is 10 times bigger than my initial plan.  Any by doing this
I found that, on my server, all the encryption methods has triggered
soft lockup for at least one time.  So this problem is universal, not
only with XTS or LRW operation mode.

With patched kernel, soft lockup _no longer_ occurred.

This server has 2G memory, Intel Xeon Duo @ 1.86GHz.

The command will be run	for 3 times, and average speed of last two
runs will be taken as result score.
  
Device was synced (luksClose ; sync ; luksOpen) between tests.

With my test script (Makefile), calculation spreadsheet and raw test
result attached.

-- 
Li, Yan

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=Makefile

# dm-crypt stress & benchmark
# Copyright Yan Li <elliot.li.tech@gmail.com>
# License: GPLv3 or above

# README
# this test should be run in runlevel 1
# check dmsg after test for soft lockup

all: show_sysinfo prepare test

show_sysinfo:
	echo ============ SYS INFO ============
	uname -a
	cat /proc/cpuinfo
	free
	hdparm -I /dev/sdc

prepare:
	/etc/init.d/boinc-client stop
	/etc/init.d/mysql stop
	/etc/init.d/apache2 stop
	[ -b /dev/mapper/ohome ] && cryptsetup luksClose ohome || true
	sync

test: test_cbc_128 test_xts_256 test_xts_512

# device ohome must be closed
test_cbc_128:
	echo ============ TEST: aes-cbc-essiv:sha256 keysize: 128 ============
	echo "abc123" | cryptsetup -s 128 -c aes-cbc-essiv:sha256 -d - luksFormat /dev/bigotvg/home
	echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ WARM UP ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ ROUND 1 ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ ROUND 2 ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	cryptsetup luksClose ohome

# device ohome must be closed
test_xts_256:
	echo ============ TEST: aes-xts-plain keysize: 256 ============
	echo "abc123" | cryptsetup -s 256 -c aes-xts-plain -d - luksFormat /dev/bigotvg/home
	echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ WARM UP ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ ROUND 1 ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ ROUND 2 ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	cryptsetup luksClose ohome

# device ohome must be closed
test_xts_512:
	echo ============ TEST: aes-xts-plain keysize: 512 ============
	echo "abc123" | cryptsetup -s 512 -c aes-xts-plain -d - luksFormat /dev/bigotvg/home
	echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ WARM UP ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ ROUND 1 ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	echo ============ ROUND 2 ============
	dd if=/dev/zero of=/dev/mapper/ohome bs=500M count=100
	cryptsetup luksClose ohome && sync && echo "abc123" | cryptsetup luksOpen /dev/bigotvg/home ohome
	sync
	sleep 2
	cryptsetup luksClose ohome

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2008-06-05-patched.out"

echo ============ SYS INFO ============
============ SYS INFO ============
uname -a
Linux bigot 2.6.24-etchnhalf.1-amd64 #1 SMP Wed Jun 4 08:56:22 CST 2008 x86_64 GNU/Linux
cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Xeon(R) CPU            3040  @ 1.86GHz
stepping	: 2
cpu MHz		: 1862.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 3726.81
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Xeon(R) CPU            3040  @ 1.86GHz
stepping	: 2
cpu MHz		: 1862.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 3724.06
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

free
             total       used       free     shared    buffers     cached
Mem:       2062188      54756    2007432          0       5020      15292
-/+ buffers/cache:      34444    2027744
Swap:      5863704          0    5863704
hdparm -I /dev/sdc

/dev/sdc:

ATA device, with non-removable media
	Model Number:       ST3500320NS                             
	Serial Number:      9QM1NV32
	Firmware Revision:  SN04    
Standards:
	Used: ATA/ATAPI-6 T13 1410D revision 2 
	Supported: 6 5 4 
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  976773168
	device size with M = 1024*1024:      476940 MBytes
	device size with M = 1000*1000:      500107 MBytes (500 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max = 16	Current = 8
	Recommended acoustic management value: 254, current value: 0
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	DOWNLOAD_MICROCODE
	    	SET_MAX security extension
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	    	General Purpose Logging feature set
	   *	64-bit World wide name
	   *	Write-Read-Verify feature set
	   *	WRITE_UNCORRECTABLE command
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Phy event counters
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT LBA Segment Access (AC2)
	   *	SCT Error Recovery Control (AC3)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
		supported: enhanced erase
Checksum: correct
/etc/init.d/boinc-client stop
Stopping BOINC core client: boinc_client not running.
/etc/init.d/mysql stop
Stopping MySQL database server: mysqld.
/etc/init.d/apache2 stop
Stopping web server (apache2)...apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName
httpd (no pid file) not running
--LQksG6bCIzRHxTLp--
