From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: kernel update and dmraid causing grub errors
Date: Wed, 03 Nov 2010 13:04:53 +0100
Message-ID: <1288785893.25565.42.camel@o>
References: <4CCF3EC4.1020708@suddenlinkmail.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CCF3EC4.1020708@suddenlinkmail.com>
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


Hi David,

because you're able to access your config fine with some arch LTS
kernels, it doesn't make sense to analyze your metadata upfront and the
following reasons may cause the failures:

- initramfs issue not activating ATARAID mappings properly via dmraid

- drivers missing to access the mappings

- host protected area changes going together with the kernel changes
  (eg. the "Error 24: Attempt to access block outside partition");
  try the libata.ignore_hpa kernel paramaters described
  in the kernel source Documentation/kernel-parameters.txt
  to test for this one

FYI: in general dmraid doesn't rely on a particular controller, just
metadata signatures it discovers. You could attach the disks to some
other SATA controller and still access your RAID sets.

Regards,
Heinz

On Mon, 2010-11-01 at 17:27 -0500, David C. Rankin wrote:
> dmraid devs,
> 
> 	Over the past 8-9 months, I have had numerous dmraid related boot failures with
> the past 6-8 kernels. It seems like a Russian-roulette type problem. Some
> kernels work with dmraid, some cause grub errors. The problem is most acute on
> an MSI SLI Platinum Based board (MS-7374), Phenom X4 (9850), with the following
> pci bus config:
> 
> [15:48 archangel:/home/david/bugs/aa] # lspci
> 00:00.0 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller
> (rev a2)
> 00:01.0 ISA bridge: nVidia Corporation MCP78S [GeForce 8200] LPC Bridge (rev a2)
> 00:01.1 SMBus: nVidia Corporation MCP78S [GeForce 8200] SMBus (rev a1)
> 00:01.2 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller
> (rev a1)
> 00:01.3 Co-processor: nVidia Corporation MCP78S [GeForce 8200] Co-Processor (rev a2)
> 00:01.4 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller
> (rev a1)
> 00:02.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 1.1
> Controller (rev a1)
> 00:02.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI USB 2.0
> Controller (rev a1)
> 00:04.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 1.1
> Controller (rev a1)
> 00:04.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI USB 2.0
> Controller (rev a1)
> 00:06.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] IDE (rev a1)
> 00:07.0 Audio device: nVidia Corporation MCP72XE/MCP72P/MCP78U/MCP78S High
> Definition Audio (rev a1)
> 00:08.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1)
> 00:09.0 RAID bus controller: nVidia Corporation MCP78S [GeForce 8200] SATA
> Controller (RAID mode) (rev a2)
> 00:0a.0 Ethernet controller: nVidia Corporation MCP77 Ethernet (rev a2)
> 00:10.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express Bridge
> (rev a1)
> 00:12.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express Bridge
> (rev a1)
> 00:13.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1)
> 00:14.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] HyperTransport Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] Miscellaneous Control
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] Link Control
> 01:06.0 Serial controller: 3Com Corp, Modem Division 56K FaxModem Model 5610
> (rev 01)
> 01:09.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)]
> IEEE 1394 OHCI Controller (rev c0)
> 02:00.0 VGA compatible controller: nVidia Corporation G92 [GeForce 8800 GT] (rev a2)
> 04:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA
> Controller (rev 03)
> 04:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA
> Controller (rev 03)
> 
> full dmidecode information at:
>   http://www.3111skyline.com/dl/Archlute/bugs/aa-dmidecode.txt

Not accessible.

> 
> 	Booting the current Arch Linux kernel (2.6.35.8-1) fails and the boot hangs at
> the very start. The kernel line I use hasn't changed in a long time:
> 
>   kernel /vmlinuz root=/dev/mapper/nvidia_baaccajap5 ro vga=0x31a
> 
> 	Booting first stopped with the following error:
> 
> Booting 'Arch Linux on Archangel'
> 
> root (hd1,5)
>   Filesystem type is ext2fs, Partition type 0x83
> Kernel /vmlinuz26 root=/dev/mapper/nvidia_baacca_jap5 ro vga=794
> 
> Error 24: Attempt to access block outside partition
> 
> Press any key to continue...
> 
> 	Upgrading to device-mapper-2.02.75-1 completely changes the error to:
> 
> Error 5: Partition table invalid or corrupt
> 
> 	Rebooting to 2.6.35.7-1, or 2.6.32.25-1 (the Arch LTS kernel) works just fine.
> So the problem is not a partition or partition table problem. The Arch Linux
> developer (Tobias Powalowski) has referred me here as the problem isn't a kernel
> problem, but something strange that is happening with dmraid.
> 
> 	The only guess I have is that it is a dmraid/GeForce controller issue that is
> triggered when dmraid loads under certain circumstances.
> 
> 	This box has 2 dmraid arrays:
> 
> [17:15 archangel:/home/david/bugs/aa] # dmraid -r
> /dev/sdd: nvidia, "nvidia_baaccaja", mirror, ok, 1465149166 sectors, data@ 0
> /dev/sda: nvidia, "nvidia_fdaacfde", mirror, ok, 976773166 sectors, data@ 0
> /dev/sdb: nvidia, "nvidia_baaccaja", mirror, ok, 1465149166 sectors, data@ 0
> /dev/sdc: nvidia, "nvidia_fdaacfde", mirror, ok, 976773166 sectors, data@ 0
> 
> [17:15 archangel:/home/david/bugs/aa] # dmraid -s
> *** Active Set
> name   : nvidia_baaccaja
> size   : 1465149056
> stride : 128
> type   : mirror
> status : ok
> subsets: 0
> devs   : 2
> spares : 0
> *** Active Set
> name   : nvidia_fdaacfde
> size   : 976773120
> stride : 128
> type   : mirror
> status : ok
> subsets: 0
> devs   : 2
> spares : 0
> 
> 	All disks check out fine with smartctl, so it isn't a disk-hardware problem.
> The detailed information on the GeForce controller (lspci -vv) is:
> 
> 00:09.0 RAID bus controller: nVidia Corporation MCP78S [GeForce 8200] SATA
> Controller (RAID mode) (rev a2)
>         Subsystem: Micro-Star International Co., Ltd. Device 7374
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>         Latency: 0 (750ns min, 250ns max)
>         Interrupt: pin A routed to IRQ 28
>         Region 0: I/O ports at b080 [size=8]
>         Region 1: I/O ports at b000 [size=4]
>         Region 2: I/O ports at ac00 [size=8]
>         Region 3: I/O ports at a880 [size=4]
>         Region 4: I/O ports at a800 [size=16]
>         Region 5: Memory at f9e76000 (32-bit, non-prefetchable) [size=8K]
>         Capabilities: [44] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [8c] SATA HBA v1.0 InCfgSpace
>         Capabilities: [b0] MSI: Enable+ Count=1/8 Maskable- 64bit+
>                 Address: 00000000fee0f00c  Data: 4191
>         Capabilities: [ec] HyperTransport: MSI Mapping Enable+ Fixed+
>         Kernel driver in use: ahci
>         Kernel modules: ahci
> 
> 
>     Basically, I'm stumped here. Nothing has changed with this box in over a
> year (same grub menu.lst, same hardware), the only oddity is that in 4 of the
> last 6 kernels or so have failed to boot with this weird grub error, that has
> nothing to do with grub (because it boots all other kernels fine), but is
> 1Gsomething that results from dmraid and the way it gets initialized (which I'm
> clueless about).
> 
>     Let me know what you think and let me know what data or testing you want me
> to do. I'll be happy to do it. I last filed this bug with Arch against 2.6.35-1
> and the problem was never fixed, but (solved) by upgrading to the (next -
> testing kernel), so the actual problem was never found. The url to the closed
> report is:
> 
> https://bugs.archlinux.org/task/20918?
> 
>     Thanks for any ideas or help you can give.
> 
