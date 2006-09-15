From: "kevin Cheng" <kevin_cheng@thecus.com>
Subject: RE: RE: [Bugme-new] [Bug 7158] New: Out of memory happen
	insnapshot
Date: Fri, 15 Sep 2006 14:56:33 +0800
Message-ID: <200609150656.k8F6ulbs006442@mail.thecus.com>
References: <200609150325.k8F3Petg003696@mail.thecus.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609150325.k8F3Petg003696@mail.thecus.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>, 'Alasdair G Kergon' <agk@redhat.com>
Cc: 'Andrew Morton' <akpm@osdl.org>, "'bugme-daemon@kernel-bugs.osdl.org'" <bugme-daemon@bugzilla.kernel.org>
List-Id: dm-devel.ids

Dear Alasdair:
    When I try use dd to general 8GB file to lv ,and "out of memory" still
happen. 
And in slabinfo "dm-snapshot-ex" always keep high count , may be "1193248"
more higher . 
Have any way to change dm-snapshot-ex memory use trans to swap or les memory
use ? Thanks!!

Regards,

Kevin

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On
Behalf Of kevin Cheng
Sent: Friday, September 15, 2006 11:25 AM
To: 'Alasdair G Kergon'
Cc: 'Andrew Morton'; dm-devel@redhat.com;
'bugme-daemon@kernel-bugs.osdl.org'
Subject: [dm-devel] RE: [Bugme-new] [Bug 7158] New: Out of memory happen
insnapshot

Dear Alasdair:
   Thanks for your help. We have capture the info about you want in the
follow. 
And we have try to use chunk size 64KB ,it seens useful . And we get the
slabinfo in the next follow.
But the speed is very slow ,DISK IO throughtput just down to 1.68MB/s . 
Have any to solve it? 


Thanks!!


Kevin

----------------------------------------------------------------------------
-----------------
root@127.0.0.1:~# /app/dmsetup info -c
Name             Maj Min Stat Open Targ Event  UUID
vg0-2006--09--15--10--32--35 253   7 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOOh53h60HLMcWIqLfCSt8vWO9B6DRhE5c
vg0-lv0-real     253   3 L--w    9    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOW1BfYcHj2lYmvnb1TzyRCzp9hUwHsRl1-real
vg0-2006--09--15--10--32--48 253  17 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VO2ryv6q3C0AxF4WxKdK0wNsgfaJW15uYA
vg0-2006--09--15--10--32--50 253  19 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOdLWwX9RWix7ufflxxcU8pYJ7ugTiTqcr
vg0-2006--09--15--10--32--46-cow 253  14 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOz0IxXWp1V2yB1E2GVNNuStIKS4HGDKul-cow
vg0-syslv        253   0 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOgjsjzAhmgflRymCKspDrRAWEtKTvxGC2
vg0-2006--09--15--10--32--37-cow 253   8 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOXgG6ht87GUFzownX6qboGAjj3aMoDdmB-cow
vg0-2006--09--15--10--32--29 253   5 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOK8ZP2bR28O99DZEXzZF5QmEIHtEyIt28
vg0-2006--09--15--10--32--46 253  15 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOz0IxXWp1V2yB1E2GVNNuStIKS4HGDKul
vg0-2006--09--15--10--32--50-cow 253  18 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOdLWwX9RWix7ufflxxcU8pYJ7ugTiTqcr-cow
vg0-2006--09--15--10--32--29-cow 253   4 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOK8ZP2bR28O99DZEXzZF5QmEIHtEyIt28-cow
vg0-2006--09--15--10--32--44 253  13 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOaSFou8q5Xb3asN9U8WN2RiXaHb9jjVT4
vg0-lv1          253   2 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VO5SUSILIIEM2gLYakhI8maNb1UFI21b1h
vg0-2006--09--15--10--32--48-cow 253  16 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VO2ryv6q3C0AxF4WxKdK0wNsgfaJW15uYA-cow
vg0-2006--09--15--10--32--39-cow 253  10 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOAR6hd59N2ljEz0QIfaEwDgpxNTFENo0B-cow
vg0-lv0          253   1 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOW1BfYcHj2lYmvnb1TzyRCzp9hUwHsRl1
vg0-2006--09--15--10--32--39 253  11 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOAR6hd59N2ljEz0QIfaEwDgpxNTFENo0B
vg0-2006--09--15--10--32--37 253   9 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOXgG6ht87GUFzownX6qboGAjj3aMoDdmB
vg0-2006--09--15--10--32--44-cow 253  12 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOaSFou8q5Xb3asN9U8WN2RiXaHb9jjVT4-cow
vg0-2006--09--15--10--32--35-cow 253   6 L--w    1    1      0
LVM-tyDxlOveI21xekkD63t1eYO42UhWM4VOOh53h60HLMcWIqLfCSt8vWO9B6DRhE5c-cow
root@127.0.0.1:~# /app/dmsetup table
vg0-2006--09--15--10--32--35: 0 161906688 snapshot 253:3 253:6 P 128
vg0-lv0-real: 0 161906688 linear 9:0 2097536
vg0-2006--09--15--10--32--48: 0 161906688 snapshot 253:3 253:16 P 128
vg0-2006--09--15--10--32--50: 0 161906688 snapshot 253:3 253:18 P 128
vg0-2006--09--15--10--32--46-cow: 0 34603008 linear 9:0 360087936
vg0-syslv: 0 2097152 linear 9:0 384
vg0-2006--09--15--10--32--37-cow: 0 34603008 linear 9:0 256278912
vg0-2006--09--15--10--32--29: 0 161906688 snapshot 253:3 253:4 P 128
vg0-2006--09--15--10--32--46: 0 161906688 snapshot 253:3 253:14 P 128
vg0-2006--09--15--10--32--50-cow: 0 35446784 linear 9:0 429293952
vg0-2006--09--15--10--32--29-cow: 0 34603008 linear 9:0 187072896
vg0-2006--09--15--10--32--44: 0 161906688 snapshot 253:3 253:12 P 128
vg0-lv1: 0 23068672 linear 9:0 164004224
vg0-2006--09--15--10--32--48-cow: 0 34603008 linear 9:0 394690944
vg0-2006--09--15--10--32--39-cow: 0 34603008 linear 9:0 290881920
vg0-lv0: 0 161906688 snapshot-origin 253:3
vg0-2006--09--15--10--32--39: 0 161906688 snapshot 253:3 253:10 P 128
vg0-2006--09--15--10--32--37: 0 161906688 snapshot 253:3 253:8 P 128
vg0-2006--09--15--10--32--44-cow: 0 34603008 linear 9:0 325484928
vg0-2006--09--15--10--32--35-cow: 0 34603008 linear 9:0 221675904
root@127.0.0.1:~# /app/dmsetup status
vg0-2006--09--15--10--32--35: 0 161906688 snapshot 5669120/34603008
vg0-lv0-real: 0 161906688 linear
vg0-2006--09--15--10--32--48: 0 161906688 snapshot 5669120/34603008
vg0-2006--09--15--10--32--50: 0 161906688 snapshot 5669120/35446784
vg0-2006--09--15--10--32--46-cow: 0 34603008 linear
vg0-syslv: 0 2097152 linear
vg0-2006--09--15--10--32--37-cow: 0 34603008 linear
vg0-2006--09--15--10--32--29: 0 161906688 snapshot 5669120/34603008
vg0-2006--09--15--10--32--46: 0 161906688 snapshot 5669120/34603008
vg0-2006--09--15--10--32--50-cow: 0 35446784 linear
vg0-2006--09--15--10--32--29-cow: 0 34603008 linear
vg0-2006--09--15--10--32--44: 0 161906688 snapshot 5669120/34603008
vg0-lv1: 0 23068672 linear
vg0-2006--09--15--10--32--48-cow: 0 34603008 linear
vg0-2006--09--15--10--32--39-cow: 0 34603008 linear
vg0-lv0: 0 161906688 snapshot-origin
vg0-2006--09--15--10--32--39: 0 161906688 snapshot 5669120/34603008
vg0-2006--09--15--10--32--37: 0 161906688 snapshot 5669120/34603008
vg0-2006--09--15--10--32--44-cow: 0 34603008 linear
vg0-2006--09--15--10--32--35-cow: 0 34603008 linear
----------------------------------------------------------------------------
----------------------------------------
Before:
kcopyd-jobs          512    525    264   15    1 : tunables   54   27    0 :
slabdata     35     35      0
dm-snapshot-in       128    177     64   59    1 : tunables  120   60    0 :
slabdata      3      3      0
dm-snapshot-ex         8    145     24  145    1 : tunables  120   60    0 :
slabdata      1      1      0
dm_tio              5120   5278     16  203    1 : tunables  120   60    0 :
slabdata     26     26      0
dm_io               5120   5239     20  169    1 : tunables  120   60    0 :
slabdata     31     31      0
journal_head           1     72     52   72    1 : tunables  120   60    0 :
slabdata      1      1      0
biovec-(256)          15     16   3072    2    2 : tunables   24   12    0 :
slabdata      8      8      0
biovec-128            23     25   1536    5    2 : tunables   24   12    0 :
slabdata      5      5      0
biovec-64             39     40    768    5    1 : tunables   54   27    0 :
slabdata      8      8      0
biovec-16             39     40    192   20    1 : tunables  120   60    0 :
slabdata      2      2      0
biovec-4              39     59     64   59    1 : tunables  120   60    0 :
slabdata      1      1      0
biovec-1             100   1218     16  203    1 : tunables  120   60    0 :
slabdata      6      6      0
bio                  295   1050    128   30    1 : tunables  120   60    0 :
slabdata     35     35      0
buffer_head         1419   7560     52   72    1 : tunables  120   60    0 :
slabdata    105    105      0


After:
kcopyd-jobs          512   1290    264   15    1 : tunables   54   27    0 :
slabdata     86     86      0
dm-snapshot-in       129   1121     64   59    1 : tunables  120   60    0 :
slabdata     19     19      0
dm-snapshot-ex     97904  98020     24  145    1 : tunables  120   60    0 :
slabdata    676    676      0
dm_tio              5121   8526     16  203    1 : tunables  120   60    0 :
slabdata     42     42      0
dm_io               5121   6760     20  169    1 : tunables  120   60    0 :
slabdata     40     40      0
journal_head          15    576     52   72    1 : tunables  120   60    0 :
slabdata      8      8      0
biovec-(256)          15     16   3072    2    2 : tunables   24   12    0 :
slabdata      8      8      0
biovec-128            23     25   1536    5    2 : tunables   24   12    0 :
slabdata      5      5      0
biovec-64             40     70    768    5    1 : tunables   54   27    0 :
slabdata     14     14      0
biovec-16             40    140    192   20    1 : tunables  120   60    0 :
slabdata      5      7      0
biovec-4              40    118     64   59    1 : tunables  120   60    0 :
slabdata      2      2      0
biovec-1              81   2030     16  203    1 : tunables  120   60    0 :
slabdata     10     10      0
bio                  318   2250    128   30    1 : tunables  120   60    0 :
slabdata     75     75      0
buffer_head         1331  12960     52   72    1 : tunables  120   60    0 :
slabdata    180    180      0
----------------------------------------------------------------------------
---------------------------------------- 
-----Original Message-----
From: Alasdair G Kergon [mailto:agk@redhat.com] 
Sent: Thursday, September 14, 2006 9:33 PM
To: kevin Cheng
Cc: 'Andrew Morton'; 'bugme-daemon@kernel-bugs.osdl.org';
dm-devel@redhat.com; agk@redhat.com; mbroz@redhat.com
Subject: Re: [Bugme-new] [Bug 7158] New: Out of memory happen in snapshot

What is the output of these three commands?

  dmsetup info -c
  dmsetup table
  dmsetup status

The current snapshot implementation does require a lot of kernel memory to
store each snapshot's exception table, which grows as there is new I/O.
Eight snapshots means eight times the memory needed by one snapshot.

Are you using the default chunk size?  If so, try a larger one (lvcreate
-c).

Alasdair
--
agk@redhat.com


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
