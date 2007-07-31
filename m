From: Tom Parker <palfrey@tevp.net>
Subject: Using device-mapper with many targets
Date: Tue, 31 Jul 2007 23:21:20 +0200
Message-ID: <46AFA7D0.8040900@tevp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000803060302080409010304"
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

This is a multi-part message in MIME format.
--------------000803060302080409010304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Summary: RAID 1 with 600 targets/RAID 5 with 50 targets causes OOM with 
320MB of RAM, and I don't know why.

First off, thanks for everyone's hard work on this lovely piece of 
software. It's very nice to be able to mess around with things at this 
level without having to delve into kernel space, and being able to 
manipulate things with command lines and libraries :-)

I've been trying some experiments recently, mainly as a precursor to 
some ideas I had, and I've run into some issues with device-mapper. 
Specifically, my use of *lots* of targets, and the tendancy of the 
kernel to head into OOM territory when you try this. I've been using a 
2.6.22 kernel (with Ubuntu's basic patches, but I don't think that's 
what's causing this) under a VMware virtual machine with 320MB RAM, and 
it seems to be having some issues. It's got a default text-mode Ubuntu 
7.04 setup, with probably a few more things loaded than it really needs, 
but not that much.

With RAID 1 targets, I can get up to about 600 targets before the whole 
thing seems to lock hard (dmsetup itself gets OOM'ed, and I can't get 
back to the shell or to any other of the virtual terminals). While 
scaling up to that point, I find that for every RAID 1 target, 
device-mapper seems to eat ~.5MB of RAM. The targets themselves are 
currently very small (1MB I think) as this was more a test in many 
targets, rather than in large targets.

I was also interested in the RAID 5 patch, so I'd earlier tried a kernel 
with the 20070720 version of the patch (marked as 2.6.22-rc7, but it 
applied cleanly against the aforementioned 2.6.22 kernel, and it was the 
latest version available when I was downloading). OOM also occurred, but 
at only ~50 targets. In this case, there's a substantial delay between 
telling dm-setup to load the target and OOM (dmesg post-mortem says ~50 
seconds), and the shell is still responsive, so I could get a dmesg log 
(attached).

I've also attached the genlist.py that I hacked together for generating 
many targets, as well as the 100 item "test" target file I started with 
for RAID 5 before narrowing the problem down to ~50. genlist should be 
fairly self-explanatory (command line for the example test file was 
"python genlist.py -l 100 sda sdb sdc")

Any thoughts on what's causing this, and anything that can be done to 
reduce/remove the problem? I'm guessing this isn't a usual target 
configuration, as most people with 50 RAID 5 targets probably have GBs 
of RAM...

I can reproduce all of this easily, so if there's any further questions 
about my configuration or recommendations for things to upgrade, I'd 
love to hear them!

Thanks,

Tom Parker

--------------000803060302080409010304
Content-Type: text/plain;
 name="test"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test"

0 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 0 /dev/sdb 0 /dev/sdc 0
2048 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 1024 /dev/sdb 1024 /dev/sdc 1024
4096 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 2048 /dev/sdb 2048 /dev/sdc 2048
6144 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 3072 /dev/sdb 3072 /dev/sdc 3072
8192 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 4096 /dev/sdb 4096 /dev/sdc 4096
10240 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 5120 /dev/sdb 5120 /dev/sdc 5120
12288 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 6144 /dev/sdb 6144 /dev/sdc 6144
14336 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 7168 /dev/sdb 7168 /dev/sdc 7168
16384 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 8192 /dev/sdb 8192 /dev/sdc 8192
18432 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 9216 /dev/sdb 9216 /dev/sdc 9216
20480 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 10240 /dev/sdb 10240 /dev/sdc 10240
22528 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 11264 /dev/sdb 11264 /dev/sdc 11264
24576 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 12288 /dev/sdb 12288 /dev/sdc 12288
26624 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 13312 /dev/sdb 13312 /dev/sdc 13312
28672 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 14336 /dev/sdb 14336 /dev/sdc 14336
30720 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 15360 /dev/sdb 15360 /dev/sdc 15360
32768 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 16384 /dev/sdb 16384 /dev/sdc 16384
34816 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 17408 /dev/sdb 17408 /dev/sdc 17408
36864 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 18432 /dev/sdb 18432 /dev/sdc 18432
38912 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 19456 /dev/sdb 19456 /dev/sdc 19456
40960 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 20480 /dev/sdb 20480 /dev/sdc 20480
43008 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 21504 /dev/sdb 21504 /dev/sdc 21504
45056 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 22528 /dev/sdb 22528 /dev/sdc 22528
47104 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 23552 /dev/sdb 23552 /dev/sdc 23552
49152 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 24576 /dev/sdb 24576 /dev/sdc 24576
51200 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 25600 /dev/sdb 25600 /dev/sdc 25600
53248 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 26624 /dev/sdb 26624 /dev/sdc 26624
55296 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 27648 /dev/sdb 27648 /dev/sdc 27648
57344 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 28672 /dev/sdb 28672 /dev/sdc 28672
59392 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 29696 /dev/sdb 29696 /dev/sdc 29696
61440 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 30720 /dev/sdb 30720 /dev/sdc 30720
63488 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 31744 /dev/sdb 31744 /dev/sdc 31744
65536 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 32768 /dev/sdb 32768 /dev/sdc 32768
67584 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 33792 /dev/sdb 33792 /dev/sdc 33792
69632 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 34816 /dev/sdb 34816 /dev/sdc 34816
71680 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 35840 /dev/sdb 35840 /dev/sdc 35840
73728 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 36864 /dev/sdb 36864 /dev/sdc 36864
75776 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 37888 /dev/sdb 37888 /dev/sdc 37888
77824 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 38912 /dev/sdb 38912 /dev/sdc 38912
79872 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 39936 /dev/sdb 39936 /dev/sdc 39936
81920 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 40960 /dev/sdb 40960 /dev/sdc 40960
83968 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 41984 /dev/sdb 41984 /dev/sdc 41984
86016 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 43008 /dev/sdb 43008 /dev/sdc 43008
88064 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 44032 /dev/sdb 44032 /dev/sdc 44032
90112 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 45056 /dev/sdb 45056 /dev/sdc 45056
92160 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 46080 /dev/sdb 46080 /dev/sdc 46080
94208 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 47104 /dev/sdb 47104 /dev/sdc 47104
96256 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 48128 /dev/sdb 48128 /dev/sdc 48128
98304 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 49152 /dev/sdb 49152 /dev/sdc 49152
100352 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 50176 /dev/sdb 50176 /dev/sdc 50176
102400 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 51200 /dev/sdb 51200 /dev/sdc 51200
104448 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 52224 /dev/sdb 52224 /dev/sdc 52224
106496 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 53248 /dev/sdb 53248 /dev/sdc 53248
108544 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 54272 /dev/sdb 54272 /dev/sdc 54272
110592 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 55296 /dev/sdb 55296 /dev/sdc 55296
112640 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 56320 /dev/sdb 56320 /dev/sdc 56320
114688 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 57344 /dev/sdb 57344 /dev/sdc 57344
116736 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 58368 /dev/sdb 58368 /dev/sdc 58368
118784 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 59392 /dev/sdb 59392 /dev/sdc 59392
120832 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 60416 /dev/sdb 60416 /dev/sdc 60416
122880 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 61440 /dev/sdb 61440 /dev/sdc 61440
124928 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 62464 /dev/sdb 62464 /dev/sdc 62464
126976 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 63488 /dev/sdb 63488 /dev/sdc 63488
129024 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 64512 /dev/sdb 64512 /dev/sdc 64512
131072 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 65536 /dev/sdb 65536 /dev/sdc 65536
133120 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 66560 /dev/sdb 66560 /dev/sdc 66560
135168 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 67584 /dev/sdb 67584 /dev/sdc 67584
137216 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 68608 /dev/sdb 68608 /dev/sdc 68608
139264 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 69632 /dev/sdb 69632 /dev/sdc 69632
141312 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 70656 /dev/sdb 70656 /dev/sdc 70656
143360 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 71680 /dev/sdb 71680 /dev/sdc 71680
145408 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 72704 /dev/sdb 72704 /dev/sdc 72704
147456 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 73728 /dev/sdb 73728 /dev/sdc 73728
149504 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 74752 /dev/sdb 74752 /dev/sdc 74752
151552 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 75776 /dev/sdb 75776 /dev/sdc 75776
153600 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 76800 /dev/sdb 76800 /dev/sdc 76800
155648 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 77824 /dev/sdb 77824 /dev/sdc 77824
157696 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 78848 /dev/sdb 78848 /dev/sdc 78848
159744 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 79872 /dev/sdb 79872 /dev/sdc 79872
161792 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 80896 /dev/sdb 80896 /dev/sdc 80896
163840 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 81920 /dev/sdb 81920 /dev/sdc 81920
165888 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 82944 /dev/sdb 82944 /dev/sdc 82944
167936 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 83968 /dev/sdb 83968 /dev/sdc 83968
169984 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 84992 /dev/sdb 84992 /dev/sdc 84992
172032 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 86016 /dev/sdb 86016 /dev/sdc 86016
174080 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 87040 /dev/sdb 87040 /dev/sdc 87040
176128 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 88064 /dev/sdb 88064 /dev/sdc 88064
178176 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 89088 /dev/sdb 89088 /dev/sdc 89088
180224 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 90112 /dev/sdb 90112 /dev/sdc 90112
182272 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 91136 /dev/sdb 91136 /dev/sdc 91136
184320 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 92160 /dev/sdb 92160 /dev/sdc 92160
186368 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 93184 /dev/sdb 93184 /dev/sdc 93184
188416 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 94208 /dev/sdb 94208 /dev/sdc 94208
190464 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 95232 /dev/sdb 95232 /dev/sdc 95232
192512 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 96256 /dev/sdb 96256 /dev/sdc 96256
194560 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 97280 /dev/sdb 97280 /dev/sdc 97280
196608 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 98304 /dev/sdb 98304 /dev/sdc 98304
198656 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 99328 /dev/sdb 99328 /dev/sdc 99328
200704 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 100352 /dev/sdb 100352 /dev/sdc 100352
202752 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 101376 /dev/sdb 101376 /dev/sdc 101376

--------------000803060302080409010304
Content-Type: text/plain;
 name="dmesg-log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-log"

[    0.000000] Linux version 2.6.22-8-generic (buildd@palmer) (gcc version 4.1.3 20070629 (prerelease) (Ubuntu 4.1.2-13ubuntu2)) #1 SMP Thu Jul 12 15:59:45 GMT 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000013ef0000 (usable)
[    0.000000]  BIOS-e820: 0000000013ef0000 - 0000000013efc000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000013efc000 - 0000000013f00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000013f00000 - 0000000014000000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 320MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f6ce0
[    0.000000] Entering add_active_range(0, 0, 81920) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->    81920
[    0.000000]   HighMem     81920 ->    81920
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->    81920
[    0.000000] On node 0 totalpages: 81920
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77216 pages, LIFO batch:15
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F6C70, 0014 (r0 PTLTD )
[    0.000000] ACPI: RSDT 13EF7C02, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP 13EFBF14, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
[    0.000000] ACPI: DSDT 13EF7C32, 42E2 (r1 PTLTD  Custom    6040000 MSFT  100000D)
[    0.000000] ACPI: FACS 13EFCFC0, 0040
[    0.000000] ACPI: APIC 13EFBF88, 0050 (r1 PTLTD  	 APIC    6040000  LTP        0)
[    0.000000] ACPI: BOOT 13EFBFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:2 APIC version 17
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 14000000:eac00000)
[    0.000000] Built 1 zonelists.  Total pages: 81280
[    0.000000] Kernel command line: root=UUID=3bb80416-10e9-424a-ab1e-19364838a774 ro quiet splash
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 3066.476 MHz processor.
[   11.213822] Console: colour VGA+ 80x25
[   11.214677] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[   11.215533] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[   11.216389] Memory: 313876k/327680k available (2009k kernel code, 13144k reserved, 918k data, 364k init, 0k highmem)
[   11.216438] virtual kernel memory layout:
[   11.216442]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[   11.216444]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   11.216448]     vmalloc : 0xd4800000 - 0xff7fe000   ( 687 MB)
[   11.216449]     lowmem  : 0xc0000000 - 0xd4000000   ( 320 MB)
[   11.216451]       .init : 0xc03e1000 - 0xc043c000   ( 364 kB)
[   11.216452]       .data : 0xc02f6606 - 0xc03dbe64   ( 918 kB)
[   11.216456]       .text : 0xc0100000 - 0xc02f6606   (2009 kB)
[   11.216494] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   11.217350] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[   11.298328] Calibrating delay using timer specific routine.. 6176.15 BogoMIPS (lpj=12352303)
[   11.298390] Security Framework v1.0.0 initialized
[   11.298452] SELinux:  Disabled at boot.
[   11.298515] Mount-cache hash table entries: 512
[   11.298577] CPU: After generic identify, caps: 0febfbff 00000000 00000000 00000000 00000000 00000000 00000000
[   11.298639] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   11.298679] CPU: L2 cache: 512K
[   11.298741] CPU: After all inits, caps: 0febfbff 00000000 00000000 0000b080 00000000 00000000 00000000
[   11.298804] Compat vDSO mapped to ffffe000.
[   11.298866] Checking 'hlt' instruction... OK.
[   11.313825] SMP alternatives: switching to UP code
[   11.313887] Freeing SMP alternatives: 11k freed
[   11.313949] ACPI: Core revision 20070126
[   11.314261] CPU0: Intel Mobile Intel(R) Pentium(R) 4     CPU 3.06GHz stepping 08
[   11.314386] Total of 1 processors activated (6176.15 BogoMIPS).
[   11.314448] ENABLING IO-APIC IRQs
[   11.314673] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   11.500238] Brought up 1 CPUs
[   11.520401] Booting paravirtualized kernel on bare hardware
[   11.525445] Time: 17:23:01  Date: 06/26/107
[   11.529183] NET: Registered protocol family 16
[   11.552964] EISA bus registered
[   11.553382] ACPI: bus type pci registered
[   11.557035] PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
[   11.557115] PCI: Using configuration type 1
[   11.557162] Setting up standard PCI resources
[   11.597171] ACPI: EC: Look up EC in DSDT
[   11.697400] ACPI: Interpreter enabled
[   11.697450] ACPI: (supports S0 S1 S5)
[   11.697721] ACPI: Using IOAPIC for interrupt routing
[   11.830648] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   11.830779] PCI: Probing PCI hardware (bus 00)
[   11.854511] PCI quirk: region 1000-103f claimed by PIIX4 ACPI
[   11.854574] PCI quirk: region 1040-104f claimed by PIIX4 SMB
[   11.870907] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   11.894558] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
[   11.894937] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
[   11.895112] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
[   11.895259] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 14 15)
[   11.898378] Linux Plug and Play Support v0.97 (c) Adam Belay
[   11.898435] pnp: PnP ACPI init
[   11.898553] ACPI: bus type pnp registered
[   12.088502] pnp: PnP ACPI: found 12 devices
[   12.088580] ACPI: ACPI bus type pnp unregistered
[   12.088656] PnPBIOS: Disabled by ACPI PNP
[   12.091889] PCI: Using ACPI for IRQ routing
[   12.091983] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   12.160056] NET: Registered protocol family 8
[   12.160087] NET: Registered protocol family 20
[   12.163955] Time: tsc clocksource has been installed.
[   12.198134] PCI: Bridge: 0000:00:01.0
[   12.198168]   IO window: disabled.
[   12.198231]   MEM window: disabled.
[   12.198294]   PREFETCH window: disabled.
[   12.198357] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   12.198419] NET: Registered protocol family 2
[   12.236231] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[   12.236294] TCP established hash table entries: 16384 (order: 5, 196608 bytes)
[   12.236356] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[   12.236419] TCP: Hash tables configured (established 16384 bind 16384)
[   12.236482] TCP reno registered
[   12.252336] checking if image is initramfs... it is
[   12.703071] Switched to high resolution mode on CPU 0
[   12.758176] Freeing initrd memory: 6316k freed
[   12.758374] Simple Boot Flag at 0x36 set to 0x1
[   12.758936] audit: initializing netlink socket (disabled)
[   12.758970] audit(1185470563.216:1): initialized
[   12.764302] VFS: Disk quotas dquot_6.5.1
[   12.764482] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   12.766281] io scheduler noop registered
[   12.766315] io scheduler anticipatory registered
[   12.766335] io scheduler deadline registered
[   12.766369] io scheduler cfq registered (default)
[   12.766404] Limiting direct PCI/PCI transfers.
[   12.766478] Boot video device is 0000:00:0f.0
[   12.766915] isapnp: Scanning for PnP cards...
[   13.124464] isapnp: No Plug & Play device found
[   13.182536] Real Time Clock Driver v1.12ac
[   13.182744] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   13.185057] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   13.185315] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   13.186867] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   13.189054] input: Macintosh mouse button emulation as /class/input/input0
[   13.189261] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
[   13.693399] serio: i8042 KBD port at 0x60,0x64 irq 1
[   13.693519] serio: i8042 AUX port at 0x60,0x64 irq 12
[   13.694249] mice: PS/2 mouse device common for all mice
[   13.696527] EISA: Probing bus 0 at eisa.0
[   13.696696] Cannot allocate resource for EISA slot 1
[   13.696781] EISA: Detected 0 cards.
[   13.696865] TCP cubic registered
[   13.696931] NET: Registered protocol family 1
[   13.697016] Using IPI No-Shortcut mode
[   13.697387]   Magic number: 15:585:391
[   13.727453] Freeing unused kernel memory: 364k freed
[   13.727628] input: AT Translated Set 2 keyboard as /class/input/input1
[   13.996041] Capability LSM initialized
[   14.030724] ACPI: Processor [CPU0] (supports 8 throttling states)
[   14.030809] ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
[   14.030893] ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
[   14.030945] ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
[   14.756842] SCSI subsystem initialized
[   14.761061] libata version 2.21 loaded.
[   14.761458] ata_piix 0000:00:07.1: version 2.11
[   14.764655] scsi0 : ata_piix
[   14.764938] scsi1 : ata_piix
[   14.765065] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011050 irq 14
[   14.765104] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011058 irq 15
[   14.796638] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 17 (level, low) -> IRQ 16
[   14.802558] scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
[   14.802607] scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
[   14.818239] scsi2: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
[   14.818290] scsi2:   Firmware Version: 5.07B, I/O Address: 0x1080, IRQ Channel: 16/Level
[   14.818326] scsi2:   PCI Bus: 0, Device: 16, Address: 0xE8810000, Host Adapter SCSI ID: 7
[   14.818415] scsi2:   Parity Checking: Enabled, Extended Translation: Enabled
[   14.818513] scsi2:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
[   14.818563] scsi2:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
[   14.818597] scsi2:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
[   14.818627] scsi2:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
[   14.818657] scsi2:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
[   14.820667] scsi2: *** BusLogic BT-958 Initialized Successfully ***
[   16.827789] scsi2 : BusLogic BT-958
[   16.828906] ata1.00: ATA-4: VMware Virtual IDE Hard Drive, 00000001, max UDMA/33
[   16.828956] ata1.00: 1431552 sectors, multi 16: LBA 
[   16.829434] ata1.00: configured for UDMA/33
[   16.854762] usbcore: registered new interface driver usbfs
[   16.854812] usbcore: registered new interface driver hub
[   16.855130] usbcore: registered new device driver usb
[   16.855348] USB Universal Host Controller Interface driver v3.0
[   16.862497] scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
[   16.862547] scsi 2:0:1:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
[   16.862597] scsi 2:0:2:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
[   16.862647] scsi scan: INQUIRY result too short (5), using 36
[   16.862697] scsi scan: INQUIRY result too short (5), using 36
[   16.862747] scsi scan: INQUIRY result too short (5), using 36
[   16.862797] scsi scan: INQUIRY result too short (5), using 36
[   16.862847] scsi scan: INQUIRY result too short (5), using 36
[   16.862897] scsi scan: INQUIRY result too short (5), using 36
[   16.862947] scsi scan: INQUIRY result too short (5), using 36
[   16.862997] scsi scan: INQUIRY result too short (5), using 36
[   16.863046] scsi scan: INQUIRY result too short (5), using 36
[   16.863096] scsi scan: INQUIRY result too short (5), using 36
[   16.863146] scsi scan: INQUIRY result too short (5), using 36
[   16.863196] scsi scan: INQUIRY result too short (5), using 36
[   16.863246] scsi scan: INQUIRY result too short (5), using 36
[   16.863296] scsi scan: INQUIRY result too short (5), using 36
[   16.863346] scsi scan: INQUIRY result too short (5), using 36
[   16.863396] scsi scan: INQUIRY result too short (5), using 36
[   16.863446] scsi scan: INQUIRY result too short (5), using 36
[   16.863496] scsi scan: INQUIRY result too short (5), using 36
[   16.863546] scsi scan: INQUIRY result too short (5), using 36
[   16.863596] scsi scan: INQUIRY result too short (5), using 36
[   16.863646] scsi scan: INQUIRY result too short (5), using 36
[   16.863696] scsi scan: INQUIRY result too short (5), using 36
[   16.863746] scsi scan: INQUIRY result too short (5), using 36
[   16.863796] scsi scan: INQUIRY result too short (5), using 36
[   16.874584] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[   16.874623] Copyright (c) 1999-2006 Intel Corporation.
[   17.007313] sd 2:0:0:0: [sda] 20971520 512-byte hardware sectors (10737 MB)
[   17.007358] sd 2:0:0:0: [sda] Write Protect is off
[   17.007404] sd 2:0:0:0: [sda] Mode Sense: 5d 00 00 00
[   17.007450] sd 2:0:0:0: [sda] Cache data unavailable
[   17.007496] sd 2:0:0:0: [sda] Assuming drive cache: write through
[   17.010019] sd 2:0:0:0: [sda] 20971520 512-byte hardware sectors (10737 MB)
[   17.010065] sd 2:0:0:0: [sda] Write Protect is off
[   17.010082] sd 2:0:0:0: [sda] Mode Sense: 5d 00 00 00
[   17.010128] sd 2:0:0:0: [sda] Cache data unavailable
[   17.010144] sd 2:0:0:0: [sda] Assuming drive cache: write through
[   17.010189]  sda: unknown partition table
[   17.010601] sd 2:0:0:0: [sda] Attached SCSI disk
[   17.010777] sd 2:0:1:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
[   17.010823] sd 2:0:1:0: [sdb] Write Protect is off
[   17.010842] sd 2:0:1:0: [sdb] Mode Sense: 5d 00 00 00
[   17.010888] sd 2:0:1:0: [sdb] Cache data unavailable
[   17.010903] sd 2:0:1:0: [sdb] Assuming drive cache: write through
[   17.010949] sd 2:0:1:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
[   17.010995] sd 2:0:1:0: [sdb] Write Protect is off
[   17.011017] sd 2:0:1:0: [sdb] Mode Sense: 5d 00 00 00
[   17.011063] sd 2:0:1:0: [sdb] Cache data unavailable
[   17.011078] sd 2:0:1:0: [sdb] Assuming drive cache: write through
[   17.011124]  sdb: unknown partition table
[   17.011466] sd 2:0:1:0: [sdb] Attached SCSI disk
[   17.011641] sd 2:0:2:0: [sdc] 20971520 512-byte hardware sectors (10737 MB)
[   17.011687] sd 2:0:2:0: [sdc] Write Protect is off
[   17.011706] sd 2:0:2:0: [sdc] Mode Sense: 5d 00 00 00
[   17.011752] sd 2:0:2:0: [sdc] Cache data unavailable
[   17.011777] sd 2:0:2:0: [sdc] Assuming drive cache: write through
[   17.011822] sd 2:0:2:0: [sdc] 20971520 512-byte hardware sectors (10737 MB)
[   17.011868] sd 2:0:2:0: [sdc] Write Protect is off
[   17.011884] sd 2:0:2:0: [sdc] Mode Sense: 5d 00 00 00
[   17.011930] sd 2:0:2:0: [sdc] Cache data unavailable
[   17.011945] sd 2:0:2:0: [sdc] Assuming drive cache: write through
[   17.011991]  sdc: unknown partition table
[   17.012325] sd 2:0:2:0: [sdc] Attached SCSI disk
[   17.018640] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   17.018800] sd 2:0:1:0: Attached scsi generic sg1 type 0
[   17.018957] sd 2:0:2:0: Attached scsi generic sg2 type 0
[   17.074185] Floppy drive(s): fd0 is 1.44M
[   17.122124] FDC 0 is a post-1991 82077
[   17.138036] ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, max UDMA/33
[   17.293417] ata2.00: configured for UDMA/33
[   17.293683] scsi 0:0:0:0: Direct-Access     ATA      VMware Virtual I 0000 PQ: 0 ANSI: 5
[   17.294026] sd 0:0:0:0: [sdd] 1431552 512-byte hardware sectors (733 MB)
[   17.294129] sd 0:0:0:0: [sdd] Write Protect is off
[   17.294175] sd 0:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   17.294336] sd 0:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   17.294442] sd 0:0:0:0: [sdd] 1431552 512-byte hardware sectors (733 MB)
[   17.294489] sd 0:0:0:0: [sdd] Write Protect is off
[   17.294503] sd 0:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   17.294573] sd 0:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   17.294594]  sdd: sdd1
[   17.294901] sd 0:0:0:0: [sdd] Attached SCSI disk
[   17.294946] sd 0:0:0:0: Attached scsi generic sg3 type 0
[   17.295197] scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
[   17.295242] scsi 1:0:0:0: Attached scsi generic sg4 type 5
[   17.297466] ACPI: PCI Interrupt 0000:00:07.2[D] -> GSI 19 (level, low) -> IRQ 17
[   17.297512] uhci_hcd 0000:00:07.2: UHCI Host Controller
[   17.301187] uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
[   17.301284] uhci_hcd 0000:00:07.2: irq 17, io base 0x00001060
[   17.309164] usb usb1: configuration #1 chosen from 1 choice
[   17.309209] hub 1-0:1.0: USB hub found
[   17.309255] hub 1-0:1.0: 2 ports detected
[   17.341119] sr0: scsi3-mmc drive: 1x/1x xa/form2 cdda tray
[   17.341165] Uniform CD-ROM driver Revision: 3.20
[   17.341210] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   17.413934] ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 18 (level, low) -> IRQ 18
[   17.414049] PCI: Setting latency timer of device 0000:00:11.0 to 64
[   17.776182] e1000: 0000:00:11.0: e1000_probe: (PCI:66MHz:32-bit) 00:0c:29:20:48:c0
[   17.823840] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[   17.832549] EXT3-fs: INFO: recovery required on readonly filesystem.
[   17.832594] EXT3-fs: write access will be enabled during recovery.
[   17.972544] kjournald starting.  Commit interval 5 seconds
[   17.972686] EXT3-fs: recovery complete.
[   17.973506] EXT3-fs: mounted filesystem with ordered data mode.
[   24.366227] Linux agpgart interface v0.102 (c) Dave Jones
[   24.629313] agpgart: Detected an Intel 440BX Chipset.
[   24.640453] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   24.672102] agpgart: AGP aperture is 64M @ 0xec000000
[   24.672342] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   25.375602] piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
[   25.375776] piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
[   26.081346] input: ImPS/2 Generic Wheel Mouse as /class/input/input2
[   27.089926] input: PC Speaker as /class/input/input3
[   27.353286] parport_pc 00:08: reported by Plug and Play ACPI
[   27.356580] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   28.856507] lp0: using parport0 (interrupt-driven).
[   29.362902] dm_mod: no version for "struct_module" found: kernel tainted.
[   29.395008] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   29.503320] raid5: automatically using best checksumming function: pIII_sse
[   29.842303]    pIII_sse  :  1345.000 MB/sec
[   29.842352] raid5: using function: pIII_sse (1345.000 MB/sec)
[   30.188856] device-mapper: dm-raid45: initialized v0.2334
[   30.966462] EXT3 FS on sdd1, internal journal
[   35.218212] NET: Registered protocol family 17
[   40.954525] input: Power Button (FF) as /class/input/input4
[   40.959039] ACPI: Power Button (FF) [PWRF]
[   41.603994] ACPI: AC Adapter [ACAD] (on-line)
[   41.684120] No dock devices found.
[   44.141305] NET: Registered protocol family 10
[   44.160723] lo: Disabled Privacy Extensions
[   72.563905] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   72.563950] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   72.563965] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   72.563993] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   72.564030] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2750MB/s
[   72.564078] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   72.796232] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   72.796256] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   72.796270] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   72.796284] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   72.796303] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2375MB/s
[   72.796320] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   73.026261] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   73.026287] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   73.026301] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   73.026315] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   73.026334] device-mapper: dm-raid45: algorithm "xor_8", 2 chunks with 2312MB/s
[   73.026351] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   73.272708] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   73.272733] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   73.272748] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   73.272762] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   73.272781] device-mapper: dm-raid45: algorithm "xor_asm", 2 chunks with 2187MB/s
[   73.272799] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   73.506266] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   73.506292] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   73.506306] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   73.506320] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   73.506339] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 1875MB/s
[   73.506357] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   73.737348] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   73.737372] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   73.737387] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   73.737506] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   73.737525] device-mapper: dm-raid45: algorithm "xor_asm", 4 chunks with 2812MB/s
[   73.737543] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   73.968654] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   73.968680] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   73.968694] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   73.968708] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   73.968728] device-mapper: dm-raid45: algorithm "xor_asm", 4 chunks with 3125MB/s
[   73.968748] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   74.199181] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   74.199206] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   74.199220] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   74.199234] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   74.199252] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2250MB/s
[   74.199269] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   74.447965] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   74.447990] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   74.448004] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   74.448018] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   74.448037] device-mapper: dm-raid45: algorithm "xor_asm", 4 chunks with 3000MB/s
[   74.448054] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   74.678821] device-mapper: dm-raid45: /dev/sda is raid disk 0
[   74.678845] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[   74.678859] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[   74.678873] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[   74.678892] device-mapper: dm-raid45: algorithm "xor_asm", 4 chunks with 1875MB/s
[   74.678910] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[   74.819851] device-mapper: dm-raid45: No more regions to recover
[   74.824120] device-mapper: dm-raid45: No more regions to recover
[   74.828066] device-mapper: dm-raid45: No more regions to recover
[   74.832975] device-mapper: dm-raid45: No more regions to recover
[   74.837028] device-mapper: dm-raid45: No more regions to recover
[   74.841157] device-mapper: dm-raid45: No more regions to recover
[   74.845336] device-mapper: dm-raid45: No more regions to recover
[   74.856421] device-mapper: dm-raid45: No more regions to recover
[   74.867228] device-mapper: dm-raid45: No more regions to recover
[   75.770794] device-mapper: dm-raid45: No more regions to recover
[  107.975121] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  107.975146] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  107.975161] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  107.975175] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  107.975194] device-mapper: dm-raid45: algorithm "xor_64", 2 chunks with 1187MB/s
[  107.975212] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  108.227148] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  108.227173] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  108.227187] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  108.227201] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  108.227220] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2125MB/s
[  108.227238] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  108.466881] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  108.466907] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  108.466921] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  108.466936] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  108.466955] device-mapper: dm-raid45: algorithm "xor_32", 5 chunks with 2500MB/s
[  108.466972] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  108.698160] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  108.698186] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  108.698200] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  108.698214] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  108.698233] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2500MB/s
[  108.698255] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  108.930801] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  108.930825] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  108.930840] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  108.930854] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  108.930873] device-mapper: dm-raid45: algorithm "xor_asm", 4 chunks with 2375MB/s
[  108.930891] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  109.168080] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  109.168105] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  109.168119] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  109.168133] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  109.168152] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2687MB/s
[  109.168169] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  109.400478] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  109.400503] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  109.400517] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  109.400531] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  109.400550] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2500MB/s
[  109.400567] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  109.642611] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  109.642636] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  109.642650] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  109.642664] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  109.642683] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2375MB/s
[  109.642701] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  109.873011] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  109.873035] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  109.873050] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  109.873064] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  109.873082] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 4250MB/s
[  109.873100] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  110.109417] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  110.109442] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  110.109457] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  110.109503] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  110.109523] device-mapper: dm-raid45: algorithm "xor_asm", 4 chunks with 2187MB/s
[  110.109540] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  110.257945] device-mapper: dm-raid45: No more regions to recover
[  110.295995] device-mapper: dm-raid45: No more regions to recover
[  110.297173] device-mapper: dm-raid45: No more regions to recover
[  110.298397] device-mapper: dm-raid45: No more regions to recover
[  110.299570] device-mapper: dm-raid45: No more regions to recover
[  110.300952] device-mapper: dm-raid45: No more regions to recover
[  110.302121] device-mapper: dm-raid45: No more regions to recover
[  110.302721] device-mapper: dm-raid45: No more regions to recover
[  110.302802] device-mapper: dm-raid45: No more regions to recover
[  111.209798] device-mapper: dm-raid45: No more regions to recover
[  135.159479] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  135.159509] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  135.159523] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  135.159538] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  135.159557] device-mapper: dm-raid45: algorithm "xor_64", 5 chunks with 2500MB/s
[  135.159578] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  135.393406] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  135.393432] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  135.393447] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  135.393461] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  135.393480] device-mapper: dm-raid45: algorithm "xor_asm", 2 chunks with 2312MB/s
[  135.393498] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  135.659241] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  135.659266] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  135.659281] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  135.659295] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  135.659314] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 1687MB/s
[  135.659331] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  135.891143] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  135.891169] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  135.891184] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  135.891198] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  135.891217] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 1500MB/s
[  135.891235] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  136.124268] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  136.124293] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  136.124307] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  136.124322] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  136.124341] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2500MB/s
[  136.124358] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  136.370098] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  136.370124] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  136.370138] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  136.370152] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  136.370171] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 1875MB/s
[  136.370188] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  136.604153] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  136.604178] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  136.604193] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  136.604207] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  136.604226] device-mapper: dm-raid45: algorithm "xor_8", 2 chunks with 1937MB/s
[  136.604244] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  136.837997] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  136.838022] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  136.838036] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  136.838051] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  136.838070] device-mapper: dm-raid45: algorithm "xor_16", 7 chunks with 2750MB/s
[  136.838087] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  137.072017] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  137.072044] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  137.072058] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  137.072072] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  137.072091] device-mapper: dm-raid45: algorithm "xor_asm", 4 chunks with 2875MB/s
[  137.072108] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  137.498824] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  137.498851] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  137.498878] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  137.498892] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  137.498911] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 3625MB/s
[  137.498928] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  141.275840] device-mapper: dm-raid45: /dev/sda is raid disk 0
[  141.275882] device-mapper: dm-raid45: /dev/sdb is raid disk 1
[  141.275896] device-mapper: dm-raid45: /dev/sdc is raid disk 2
[  141.275911] device-mapper: dm-raid45: 128/128/256 sectors chunk/io/recovery size, 64 stripes
[  141.275930] device-mapper: dm-raid45: algorithm "xor_asm", 3 chunks with 2375MB/s
[  141.275947] device-mapper: dm-raid45: RAID5 (left asymmetric) set with net 2/3 devices
[  194.099118] syslogd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.099388]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.099784]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.099813]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.099842]  [<c0103434>] setup_sigcontext+0x104/0x190
[  194.099861]  [<c01322f9>] __dequeue_signal+0xd9/0x160
[  194.099889]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.099913]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.099932]  [<c0140d66>] getnstimeofday+0x36/0xd0
[  194.099962]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.099996]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.100013]  [<c02f2b82>] error_code+0x72/0x80
[  194.100089]  =======================
[  194.100136] Mem-info:
[  194.100181] DMA per-cpu:
[  194.100222] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.100272] Normal per-cpu:
[  194.100281] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.100369] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.100381]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.100458] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.100495] lowmem_reserve[]: 0 301 301
[  194.100563] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.100590] lowmem_reserve[]: 0 0 0
[  194.100635] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.100772] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.100896] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.100922] Free swap  = 0kB
[  194.100941] Total swap = 0kB
[  194.100969] Free swap:            0kB
[  194.102076] 81920 pages of RAM
[  194.102100] 0 pages of HIGHMEM
[  194.102119] 1741 reserved pages
[  194.102142] 11 pages shared
[  194.102161] 0 pages swap cached
[  194.102182] 0 pages dirty
[  194.102202] 0 pages writeback
[  194.102227] 0 pages mapped
[  194.102252] 1814 pages slab
[  194.102273] 52 pages pagetables
[  194.102757] Out of memory: kill process 3978 (bash) score 1321 or a child
[  194.103032] Killed process 4070 (dmsetup)
[  194.103418] dd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.103445]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.103471]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.103495]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.103519]  [<c0194d35>] file_update_time+0x35/0x90
[  194.103544]  [<c0186d7b>] pipe_write+0x22b/0x470
[  194.103569]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.103586]  [<c02f087a>] schedule+0x2ca/0x890
[  194.103607]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.103637]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.103655]  [<c0180ca5>] vfs_read+0x125/0x160
[  194.103676]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.103695]  [<c02f2b82>] error_code+0x72/0x80
[  194.103718]  =======================
[  194.103730] Mem-info:
[  194.103737] DMA per-cpu:
[  194.103746] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.103764] Normal per-cpu:
[  194.103772] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.103792] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.103802]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.103819] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.103844] lowmem_reserve[]: 0 301 301
[  194.103860] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.103888] lowmem_reserve[]: 0 0 0
[  194.103902] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.103939] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.103976] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.103988] Free swap  = 0kB
[  194.103995] Total swap = 0kB
[  194.104003] Free swap:            0kB
[  194.104885] 81920 pages of RAM
[  194.104896] 0 pages of HIGHMEM
[  194.104903] 1741 reserved pages
[  194.104912] 11 pages shared
[  194.104919] 0 pages swap cached
[  194.104927] 0 pages dirty
[  194.104934] 0 pages writeback
[  194.104942] 0 pages mapped
[  194.104949] 1814 pages slab
[  194.104956] 52 pages pagetables
[  194.109308] syslogd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.109340]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.109366]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.109389]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.109416]  [<c0103434>] setup_sigcontext+0x104/0x190
[  194.109432]  [<c01322f9>] __dequeue_signal+0xd9/0x160
[  194.109457]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.109480]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.109499]  [<c0140d66>] getnstimeofday+0x36/0xd0
[  194.109526]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.109552]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.109569]  [<c02f2b82>] error_code+0x72/0x80
[  194.109593]  =======================
[  194.109602] Mem-info:
[  194.109609] DMA per-cpu:
[  194.109617] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.109636] Normal per-cpu:
[  194.109644] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.109663] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.109674]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.109691] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.109716] lowmem_reserve[]: 0 301 301
[  194.109732] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.109759] lowmem_reserve[]: 0 0 0
[  194.109773] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.109810] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.109848] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.109860] Free swap  = 0kB
[  194.109868] Total swap = 0kB
[  194.109876] Free swap:            0kB
[  194.110769] 81920 pages of RAM
[  194.110780] 0 pages of HIGHMEM
[  194.110789] 1741 reserved pages
[  194.110798] 11 pages shared
[  194.110805] 0 pages swap cached
[  194.110814] 0 pages dirty
[  194.110821] 0 pages writeback
[  194.110829] 0 pages mapped
[  194.110836] 1814 pages slab
[  194.110844] 52 pages pagetables
[  194.110933] dd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.110963]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.110988]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.111012]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.111035]  [<c0194d35>] file_update_time+0x35/0x90
[  194.111054]  [<c0186d7b>] pipe_write+0x22b/0x470
[  194.111077]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.111094]  [<c02f087a>] schedule+0x2ca/0x890
[  194.111115]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.111144]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.111163]  [<c0180ca5>] vfs_read+0x125/0x160
[  194.111164]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.111279]  [<c02f2b82>] error_code+0x72/0x80
[  194.111304]  =======================
[  194.111314] Mem-info:
[  194.111321] DMA per-cpu:
[  194.111329] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.111349] Normal per-cpu:
[  194.111357] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.111377] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.111387]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.111404] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.111429] lowmem_reserve[]: 0 301 301
[  194.111446] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.111473] lowmem_reserve[]: 0 0 0
[  194.111487] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.111524] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.111562] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.111575] Free swap  = 0kB
[  194.111582] Total swap = 0kB
[  194.111590] Free swap:            0kB
[  194.112467] 81920 pages of RAM
[  194.112477] 0 pages of HIGHMEM
[  194.112485] 1741 reserved pages
[  194.112493] 11 pages shared
[  194.112500] 0 pages swap cached
[  194.112508] 0 pages dirty
[  194.112515] 0 pages writeback
[  194.112523] 0 pages mapped
[  194.112531] 1814 pages slab
[  194.112538] 52 pages pagetables
[  194.112630] syslogd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.112655]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.112681]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.112705]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.112731]  [<c0103434>] setup_sigcontext+0x104/0x190
[  194.112748]  [<c01322f9>] __dequeue_signal+0xd9/0x160
[  194.112771]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.112795]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.112814]  [<c0140d66>] getnstimeofday+0x36/0xd0
[  194.112840]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.112866]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.112882]  [<c02f2b82>] error_code+0x72/0x80
[  194.112905]  =======================
[  194.112914] Mem-info:
[  194.112921] DMA per-cpu:
[  194.112928] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.112946] Normal per-cpu:
[  194.112954] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.112973] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.112983]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.113000] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.113024] lowmem_reserve[]: 0 301 301
[  194.113041] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.113068] lowmem_reserve[]: 0 0 0
[  194.113082] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.113125] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.113164] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.113177] Free swap  = 0kB
[  194.113184] Total swap = 0kB
[  194.113192] Free swap:            0kB
[  194.117681] 81920 pages of RAM
[  194.117696] 0 pages of HIGHMEM
[  194.117704] 1741 reserved pages
[  194.117713] 11 pages shared
[  194.117721] 0 pages swap cached
[  194.117729] 0 pages dirty
[  194.117737] 0 pages writeback
[  194.117744] 0 pages mapped
[  194.117752] 1814 pages slab
[  194.117760] 52 pages pagetables
[  194.117853] dd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.117877]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.117902]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.117926]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.117950]  [<c0194d35>] file_update_time+0x35/0x90
[  194.117969]  [<c0186d7b>] pipe_write+0x22b/0x470
[  194.117993]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.118010]  [<c02f087a>] schedule+0x2ca/0x890
[  194.118031]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.118060]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.118079]  [<c0180ca5>] vfs_read+0x125/0x160
[  194.118099]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.118116]  [<c02f2b82>] error_code+0x72/0x80
[  194.118140]  =======================
[  194.118149] Mem-info:
[  194.118156] DMA per-cpu:
[  194.118164] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.118183] Normal per-cpu:
[  194.118192] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.118211] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.118222]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.118238] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.118264] lowmem_reserve[]: 0 301 301
[  194.118280] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.118308] lowmem_reserve[]: 0 0 0
[  194.118322] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.118360] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.118397] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.118410] Free swap  = 0kB
[  194.118418] Total swap = 0kB
[  194.118426] Free swap:            0kB
[  194.118517] 81920 pages of RAM
[  194.119388] 0 pages of HIGHMEM
[  194.119396] 1741 reserved pages
[  194.119405] 11 pages shared
[  194.119412] 0 pages swap cached
[  194.119420] 0 pages dirty
[  194.119428] 0 pages writeback
[  194.119436] 0 pages mapped
[  194.119443] 1814 pages slab
[  194.119450] 52 pages pagetables
[  194.119800] syslogd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.119827]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.119853]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.119877]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.119904]  [<c0103434>] setup_sigcontext+0x104/0x190
[  194.119921]  [<c01322f9>] __dequeue_signal+0xd9/0x160
[  194.119944]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.119969]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.119987]  [<c0140d66>] getnstimeofday+0x36/0xd0
[  194.120014]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.120040]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.120056]  [<c02f2b82>] error_code+0x72/0x80
[  194.120080]  =======================
[  194.120089] Mem-info:
[  194.120096] DMA per-cpu:
[  194.120104] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.120122] Normal per-cpu:
[  194.120131] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.120157] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.120167]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.120184] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.120209] lowmem_reserve[]: 0 301 301
[  194.120226] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.120253] lowmem_reserve[]: 0 0 0
[  194.120267] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.120304] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.120342] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.120354] Free swap  = 0kB
[  194.120362] Total swap = 0kB
[  194.120370] Free swap:            0kB
[  194.121279] 81920 pages of RAM
[  194.121290] 0 pages of HIGHMEM
[  194.121298] 1741 reserved pages
[  194.121307] 11 pages shared
[  194.121315] 0 pages swap cached
[  194.121323] 0 pages dirty
[  194.121330] 0 pages writeback
[  194.121338] 0 pages mapped
[  194.121346] 1814 pages slab
[  194.121353] 52 pages pagetables
[  194.123878] dd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.123907]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.123932]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.123956]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.123981]  [<c0194d35>] file_update_time+0x35/0x90
[  194.124001]  [<c0186d7b>] pipe_write+0x22b/0x470
[  194.124025]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.124042]  [<c02f087a>] schedule+0x2ca/0x890
[  194.124063]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.124093]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.124113]  [<c0180ca5>] vfs_read+0x125/0x160
[  194.124135]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.124152]  [<c02f2b82>] error_code+0x72/0x80
[  194.124176]  =======================
[  194.124186] Mem-info:
[  194.124192] DMA per-cpu:
[  194.124201] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.124219] Normal per-cpu:
[  194.124227] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.124246] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.124257]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.124274] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.124299] lowmem_reserve[]: 0 301 301
[  194.124316] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.124343] lowmem_reserve[]: 0 0 0
[  194.124357] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.124393] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.124431] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.124444] Free swap  = 0kB
[  194.124452] Total swap = 0kB
[  194.124459] Free swap:            0kB
[  194.125339] 81920 pages of RAM
[  194.125350] 0 pages of HIGHMEM
[  194.125358] 1741 reserved pages
[  194.125367] 11 pages shared
[  194.125375] 0 pages swap cached
[  194.125383] 0 pages dirty
[  194.125390] 0 pages writeback
[  194.125399] 0 pages mapped
[  194.125406] 1814 pages slab
[  194.125414] 52 pages pagetables
[  194.125505] syslogd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.125531]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.125556]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.125581]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.125607]  [<c0103434>] setup_sigcontext+0x104/0x190
[  194.125629]  [<c01322f9>] __dequeue_signal+0xd9/0x160
[  194.125653]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.125676]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.125694]  [<c0140d66>] getnstimeofday+0x36/0xd0
[  194.125721]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.125824]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.125842]  [<c02f2b82>] error_code+0x72/0x80
[  194.125867]  =======================
[  194.125876] Mem-info:
[  194.125883] DMA per-cpu:
[  194.125891] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.125910] Normal per-cpu:
[  194.125919] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.125938] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.125948]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.125965] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.125990] lowmem_reserve[]: 0 301 301
[  194.126007] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.126034] lowmem_reserve[]: 0 0 0
[  194.126048] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.126085] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.126124] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.126136] Free swap  = 0kB
[  194.126144] Total swap = 0kB
[  194.126152] Free swap:            0kB
[  194.127029] 81920 pages of RAM
[  194.127040] 0 pages of HIGHMEM
[  194.127048] 1741 reserved pages
[  194.127057] 11 pages shared
[  194.127065] 0 pages swap cached
[  194.127073] 0 pages dirty
[  194.127082] 0 pages writeback
[  194.127090] 0 pages mapped
[  194.127097] 1814 pages slab
[  194.127105] 52 pages pagetables
[  194.127237] dd invoked oom-killer: gfp_mask=0x201d2, order=0, oomkilladj=0
[  194.127262]  [<c0161f15>] out_of_memory+0x185/0x1c0
[  194.127288]  [<c01638e4>] __alloc_pages+0x2e4/0x340
[  194.127312]  [<c0165389>] __do_page_cache_readahead+0x109/0x250
[  194.127336]  [<c0194d35>] file_update_time+0x35/0x90
[  194.127355]  [<c0186d7b>] pipe_write+0x22b/0x470
[  194.127379]  [<c0161055>] filemap_nopage+0x155/0x340
[  194.127396]  [<c02f087a>] schedule+0x2ca/0x890
[  194.127417]  [<c016cc88>] __handle_mm_fault+0x148/0xb00
[  194.127446]  [<c02f4426>] do_page_fault+0x126/0x680
[  194.127465]  [<c0180ca5>] vfs_read+0x125/0x160
[  194.127486]  [<c02f4300>] do_page_fault+0x0/0x680
[  194.127502]  [<c02f2b82>] error_code+0x72/0x80
[  194.127526]  =======================
[  194.127535] Mem-info:
[  194.127542] DMA per-cpu:
[  194.127550] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[  194.127569] Normal per-cpu:
[  194.127577] CPU    0: Hot: hi:   90, btch:  15 usd:  14   Cold: hi:   30, btch:   7 usd:  24
[  194.127596] Active:1457 inactive:0 dirty:0 writeback:0 unstable:0
[  194.127606]  free:862 slab:1814 mapped:0 pagetables:52 bounce:0
[  194.127623] DMA free:1308kB min:112kB low:140kB high:168kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
[  194.127648] lowmem_reserve[]: 0 301 301
[  194.127664] Normal free:2140kB min:2164kB low:2704kB high:3244kB active:5828kB inactive:0kB present:308864kB pages_scanned:9606 all_unreclaimable? yes
[  194.127691] lowmem_reserve[]: 0 0 0
[  194.127705] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1308kB
[  194.127742] Normal: 1*4kB 1*8kB 3*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2140kB
[  194.127780] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  194.127793] Free swap  = 0kB
[  194.127801] Total swap = 0kB
[  194.127924] Free swap:            0kB
[  194.128811] 81920 pages of RAM
[  194.128823] 0 pages of HIGHMEM
[  194.128831] 1741 reserved pages
[  194.128839] 11 pages shared
[  194.128847] 0 pages swap cached
[  194.128855] 0 pages dirty
[  194.128862] 0 pages writeback
[  194.128869] 0 pages mapped
[  194.128877] 1814 pages slab
[  194.128884] 52 pages pagetables
[  194.272704] ------------[ cut here ]------------
[  194.272848] kernel BUG at drivers/md/dm-mem-cache.c:173!
[  194.272986] invalid opcode: 0000 [#1]
[  194.274005] SMP 
[  194.274244] Modules linked in: ipv6 battery video dock ac container sbs button af_packet dm_raid4_5(F) dm_region_hash(F) dm_log(F) dm_mem_cache(F) xor(F) dm_mod(F) lp parport_pc parport pcspkr psmouse serio_raw i2c_piix4 i2c_core shpchp pci_hotplug intel_agp agpgart evdev ext3 jbd mbcache sr_mod cdrom ata_generic floppy sg sd_mod e1000 uhci_hcd usbcore BusLogic ata_piix libata scsi_mod thermal processor fan capability commoncap
[  194.275866] CPU:    0
[  194.275872] EIP:    0060:[<d4973273>]    Tainted: GF      VLI
[  194.275881] EFLAGS: 00010287   (2.6.22-8-generic #1)
[  194.276412] EIP is at dm_mem_cache_client_destroy+0x23/0x30 [dm_mem_cache]
[  194.276557] eax: 00000cc0   ebx: d1deaa80   ecx: c03d8a90   edx: ffff0001
[  194.276693] esi: d4a3b640   edi: d1e2d078   ebp: 00000040   esp: d007fc74
[  194.276828] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  194.276959] Process dmsetup (pid: 4070, ti=d007e000 task=d25f19a0 task.ti=d007e000)
[  194.277105] Stack: d1e2d078 d49f5c62 000000c0 d49f7455 00000000 00000000 00000000 0000001f 
[  194.277628]        00000400 00000001 00000000 00000001 00000000 c701ff00 0000000c d4a3b640 
[  194.277941]        00000100 00000080 00000040 0000000a 00000080 00000000 00000080 00000100 
[  194.278256] Call Trace:
[  194.278427]  [<d49f5c62>] sc_exit+0x32/0x50 [dm_raid4_5]
[  194.278569]  [<d49f7455>] raid_ctr+0x955/0x12d0 [dm_raid4_5]
[  194.278715]  [<c017c532>] __slab_alloc+0x2b2/0x4f0
[  194.278855]  [<d4ad5c77>] dm_table_add_target+0x167/0x340 [dm_mod]
[  194.279007]  [<d4ad77ba>] table_load+0xba/0x1d0 [dm_mod]
[  194.279144]  [<d4ad8440>] ctl_ioctl+0x220/0x290 [dm_mod]
[  194.279331]  [<c015f458>] do_generic_mapping_read+0x4b8/0x5d0
[  194.279464]  [<d4ad7700>] table_load+0x0/0x1d0 [dm_mod]
[  194.279631]  [<d4ad8220>] ctl_ioctl+0x0/0x290 [dm_mod]
[  194.279762]  [<c018c744>] do_ioctl+0x84/0xc0
[  194.279881]  [<c02f467a>] do_page_fault+0x37a/0x680
[  194.280007]  [<d4ad8220>] ctl_ioctl+0x0/0x290 [dm_mod]
[  194.280139]  [<c018c7dc>] vfs_ioctl+0x5c/0x290
[  194.280259]  [<c018ca82>] sys_ioctl+0x72/0x90
[  194.280448]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[  194.280582]  =======================
[  194.280701] Code: 5f 5d c3 90 8d 74 26 00 53 89 c3 8b 40 14 3b 43 18 75 18 8b 43 08 e8 3d fe ff ff 8b 43 04 e8 75 e2 7e eb 89 d8 5b e9 ad 95 80 eb <0f> 0b eb fe 89 f6 8d bc 27 00 00 00 00 83 ec 18 89 7c 24 10 89 
[  194.282179] EIP: [<d4973273>] dm_mem_cache_client_destroy+0x23/0x30 [dm_mem_cache] SS:ESP 0068:d007fc74

--------------000803060302080409010304
Content-Type: text/plain;
 name="genlist.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="genlist.py"

#!/usr/bin/python

from sys import argv,exit,stderr
from optparse import OptionParser
from os.path import basename
from pprint import PrettyPrinter

pp = PrettyPrinter(stream=stderr)

class ErrParser(OptionParser):
	def error(self,msg):
		self.print_help()
		self.exit(2, "%s: error: %s\n" % (self.get_prog_name(), msg))

parser = ErrParser(usage="%prog [options] <list of block devices separated by spaces>")
parser.add_option("-l","--limit", type="int", dest="limit",default=10,help="Limit to number of items. Default is 10")
parser.add_option("-b","--blocksize", type="int", dest="bsize",default=1024,help="Size of per-disk blocks in sectors. Default is 1024 (=512KB)")
parser.add_option("-r","--raid",type="int",dest="raid",default=5,help="RAID type to generate (1 or 5). Default is 5")
(options,args) = parser.parse_args(argv[1:])

if options.raid == 5:
	if len(args)<3:
		parser.error("Need more devices for RAID 5! (minimum is 3)")
elif options.raid == 1:
	if len(args)!=2:
		parser.error("Need precisely 2 devices for RAID 1")
else:
	parser.error("Only valid values for RAID are 1 and 5, not %d"%options.raid)

drives = {}

for x in args:
	# FIXME: do right with sysfs
	name = basename(x)
	try:
		if len(name)<4: # just a block, no device
			path = "/sys/block/%s" % name
			start = 0
		else:
			path = "/sys/block/%s/%s" % (name[:3],name)
			start = int(open("%s/start"%path).read())
		size = int(open("%s/size"%path).read())
	except IOError,e:
		if e.errno == 2: # can't find file
			parser.error("No sys path for drive %s (guess was %s)"%(x,path))
		else:
			raise
	drives[name] = {"size":size,"start":start,"end":start+size}

pp.pprint(drives)

count = len(drives.keys())

start = 0
for i in range(options.limit):
	if options.raid == 5:
		#0 2048 raid45 core 1 1024 raid5_la 1 128 3 -1 /dev/sda 0 /dev/sdb 0 /dev/sdc 0
		line = "%d %d raid45 core 1 %d raid5_la 1 128 %d -1"%(start,(count-1)*options.bsize,options.bsize,count)
		start += (count-1)*options.bsize
	elif options.raid == 1:
		#line = "%d %d striped 2 %d" %(start,options.bsize,options.bsize)
		line = "%d %d mirror core 1 %d 2" %(start,options.bsize,options.bsize)
		start += options.bsize
	for d in drives.keys():
		line += " /dev/%s %d"%(d,drives[d]["start"])
		drives[d]["start"]+=options.bsize
		if drives[d]["start"]>=drives[d]["end"]:
			raise Exception,"Reached end of drive %d"%d
	print line
		

--------------000803060302080409010304
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000803060302080409010304--
