From: Jagan Reddy <gjmsreddy@yahoo.com>
Subject: Re: dm-thin vs lvm performance
Date: Wed, 18 Jan 2012 11:30:54 -0800 (PST)
Message-ID: <1326915054.99335.YahooMailNeo@web36407.mail.mud.yahoo.com>
References: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
	<20120116124158.GA4426@ubuntu>
Reply-To: Jagan Reddy <gjmsreddy@yahoo.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3417799784578844595=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120116124158.GA4426@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3417799784578844595==
Content-Type: multipart/alternative;
	boundary="-2114655128-221890458-1326915054=:99335"

---2114655128-221890458-1326915054=:99335
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Joe,=0A=A0Thanks for looking into the issue and running the tests and sugge=
sting to use "direct" flag. I do see a difference with "direct" flag using =
dd. However the difference is significant when using bs=3D64M compared to b=
s=3D4k.=A0=0A=0Add-blocksize =A0flags =A0dm-thin =A0 =A0 LVMoutput =A0=A0=
=0A64M =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0none =A0 179 MB/s =A0 =A0 =A0 =A0 1GB=
/s =A0 =A0 =A0 =A0 =A0=A0=0A64M =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0direct =A0 2=
.4GB/s =A0 =A0 =A0 =A0 =A0 3.6GB/s =A0 =A0 =A0 =A0=0A4k =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 none =A0 179 MB/s =A0 =A0 =A0 =A0 =A0965MB/s =A0 =A0 =A0=
=0A4k =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 direct =A0 193MB/s =A0 =A0 =A0 =
=A0 =A01.7GB/s =A0 =A0 =A0 =A0=0A=0AIn all the tests, dm-thin performance i=
s below lvm.=A0I used 8M pages as we are not planning to use snapshots righ=
t now. =A0=0A=0AWe are planning to use the dm-thin module in a high end fla=
sh device that supports upto 300k IOPS/second. Hence =A0we are doing some p=
erformance tests. I wanted to try more parallel async IO instead of dd. A g=
ood program I found on web is=A0=0A=0A=0Afsbench.filesystems.org/bench/aio-=
stress.c=0A=0A=0A(if you are aware of other tools to test parallel async io=
 using multiple threads, please let me know. I will give it a try.)=0A=0A=
=0AI compiled it with libaio and libpth.=A0=0A=0AThen I ran the test on LVM=
 lun. Throughput is 9563.56MB/s.=A0Fully allocated TP LUN is=A05399.81MB/s=
=0A=0AI used "perf top" to see where most of the time is spent. Lot of time=
 is spent in=A0_raw_spin_lock. I poked the code little bit and I see that=
=A0dm_thin_find_block returns EWOULDBLOCK and hence the bio gets deferred. =
It looks like spin locks are used when putting the bio on deferred list and=
 getting it back from the deferred list. I see that EWOULDBLOCK is returned=
 from=A0dm_thin_find_block ->=A0dm_btree_lookup->btree_lookup_raw->ro_step-=
>bn_read_lock->dm_tm_read_lock->dm_bm_read_try_lock->bl_down_read_nonblock.=
=0A=0AI tried to change the code little bit so that=A0dm_thin_find_block us=
es array as a cache and looks up btree only if not found in the array.=0AWi=
th that change, I see TP performance go way up.=0A=0AFully allocated TP LUN=
 with array lookup is 9387.17MB/s. With array, no bios are being deferred. =
However when I used the array, I see kernel hang after several runs ( yet t=
o debug the reason).=0A=0ACode changes are initialize array in pool_ctr() i=
n dm-thin.c=0A=0Aextern dm_block_t blockmap[1000];=0A=0Aprintk("blockmap ar=
ray inited");=0A=A0=A0 =A0 =A0 =A0for(i=3D0;i<1000;i++)=0A=A0=A0 =A0 =A0 =
=A0{=0A=A0=A0 =A0 =A0 =A0 =A0blockmap[i]=3D0xffffffff;=0A=A0=A0 =A0 =A0 =A0=
}=0A=0A=0Adm_thin_find_block() in dm-thin-metadata.c=0A=0Aat the begining:=
=0A=A0=A0 =A0 =A0 if(blockmap[block]=3D=3D0xffffffff)=0A=A0=A0 =A0 =A0 =A0{=
=0A=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("found unassigned block %llu\n"=
,block);=0A=A0=A0 =A0 =A0 =A0}=0A=A0=A0 =A0 =A0 =A0else=0A=A0=A0 =A0 =A0 =
=A0{=0A=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0result->block =3D blockmap[block];=
=0A=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0result->shared =3D 0;=0A=A0=A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0return 0;=0A=A0=A0 =A0 =A0 =A0}=0A=0Aat the end before =
returning:=0A=A0=A0 =A0 =A0 if(r =3D=3D 0)=0A=A0=A0 =A0 =A0 =A0{=0A=A0=A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0blockmap[block] =3D result->block ;=0A=A0=A0 =A0=
 =A0 =A0}=0A=0A=0ANote that the array changes are only for my testing and n=
ot generic enough at all. =A0Command I used for getting the throughput numb=
ers are=0A=0Ai=3D0; while [ $i -lt 100 ] ; do ./aio-stress.exe =A0-O -o 1 -=
c 16 -t 16 -d 256 /dev/mapper/thin1 2>&1 | grep throughput | cut -f3 -d ' '=
 | cut -f2 -d '(' | cut -f1 -d ' ' ; let i=3D$i+1; done =A0| awk 'BEGIN{i=
=3D0.0} {i+=3D$0} END{print i/100}'=0A=0A=0AThanks,=0AJagan.=0A=0A=0A______=
__________________________=0A From: Joe Thornber <thornber@redhat.com>=0ATo=
: Jagan Reddy <gjmsreddy@yahoo.com>; device-mapper development <dm-devel@re=
dhat.com> =0ASent: Monday, January 16, 2012 4:42 AM=0ASubject: Re: [dm-deve=
l] dm-thin vs lvm performance=0A =0AHi Jagan,=0A=0AOn Thu, Jan 12, 2012 at =
04:55:16PM -0800, Jagan Reddy wrote:=0A> Hi,=0A=0A> I =A0recently started u=
sing dm-thin module and first of all, thank you=0A> for the good work. It w=
orks great, well documented and the comments=0A> in the code are very usefu=
l. =A0I tried to run some performance tests=0A> using a high performance fl=
ash device and the performance of dm thin=0A> is about 30% of LVM performan=
ce on a full allocated thin provisioned=0A> volume. ( ie after all pages/bl=
ocks are allocated using=0A> dd). Performance test does only reads and no w=
rites.=A0=0A=0AThanks very much for taking the time to try thinp out proper=
ly.=0APeople testing different scenarios is very useful to us.=0A=0AYou're =
probably aware that the thinp test suite is available here:=0A=0A=A0 =A0 ht=
tps://github.com/jthornber/thinp-test-suite=0A=0AI've added a little set of=
 tests that recreate your scenario here:=0A=0A=A0 =A0 https://github.com/jt=
hornber/thinp-test-suite/blob/master/ramdisk_tests.rb=0A=0AI used a 2G ramd=
isk for these tests, and a variety of thinp block=0Asizes and 'dd' options.=
=A0 I'll just summarise the main results, also I=0Ashould point out that my=
 testing was done on a VM hosted on a 4G=0Amachine, so the machine was unde=
r a lot of memory pressure and there=0Awas a lot of variance in the benchma=
rks.=0A=0Awrites across various volumes=0A-----------------------------=0A=
=0Awrite1=0A------=0A=0ATesting write performance.=0A=0Add if=3D/dev/zero o=
f=3D/dev/mapper/<thin> oflags=3Ddirect bs=3D64M=0A=0Azeroing new blocks tur=
ned on.=0A=0Athinp block size =3D 64k=0A=0A| Linear=A0 =A0 =A0 =A0 =A0 =A0 =
=A0 | 2.2 G/s |=0A| Unprovisioned thin=A0 | 1.4 G/s |=0A| Provisioned thin=
=A0 =A0 | 1.9=A0 =A0  |=0A| Snap totally shared | 1.5 G/s |=0A| Snap no sha=
ring=A0 =A0  | 1.9=A0 =A0  |=0A=0APretty good.=A0 Not showing the drastic d=
rop that you were seeing.=A0 The=0Asmall thinp block size means the snaps p=
erform nicely (not many=0Acopy-on-writes).=0A=0Awrite2=0A------=0A=0AAs tes=
t1, but with 8M thinp block size as in your tests.=0A=0A| Linear=A0 =A0 =A0=
 =A0 =A0 =A0 =A0 | 2.2 G/s |=0A| Unprovisioned thin=A0 | 1.5 G/s |=0A| Prov=
isioned thin=A0 =A0 | 2.2=A0 =A0  |=0A| Snap totally shared | 882 Ms=A0 |=
=0A| Snap no sharing=A0 =A0  | 2.2=A0 =A0  | =0A=0AGood results, breaking s=
haring performance is down because the large=0Ablock size mean there will b=
e more actual copying incurred.=0A=0Awrite3=0A------=0A=0AAs test2, but no =
oflags=3Ddirect option to dd.=0A=0A| Linear=A0 =A0 =A0 =A0 =A0 =A0 =A0 | 90=
0 M/s |=0A| Unprovisioned thin=A0 | 579 M/s |=0A| Provisioned thin=A0 =A0 |=
 694 M/s |=0A| Snap totally shared | 510 M/s |=0A| Snap no sharing=A0 =A0  =
| 654 M/s | =0A=0AAlarming.=A0 Results are similar for thinp block size of =
64k.=0A=0Aread1=0A-----=0A=0ATesting read performance.=0A=0Add if=3D/dev/ma=
pper/<thin> of=3D/dev/null iflags=3Ddirect bs=3D64M=0A=0Athinp block size =
=3D 64k=0A=0A| Linear=A0 =A0 =A0 =A0 =A0 =A0 =A0 | 3.3 G/s |=0A| Provisione=
d thin=A0 =A0 | 2.7 G/s |=0A| Snap no sharing=A0 =A0  | 2.8 G/s | =0A=0A=0A=
read2=0A-----=0A=0Aread1 but with 8M thinp block size=0A=0A| Linear=A0 =A0 =
=A0 =A0 =A0 =A0 =A0 | 3.3 G/s |=0A| Provisioned thin=A0 =A0 | 3.2 G/s |=0A|=
 Snap no sharing=A0 =A0  | 3.3 G/s | =0A=0Aread3=0A-----=0A=0AAs read2, but=
 without the iflags=3Ddirect option to 'dd'.=0A=0A| Linear=A0 =A0 =A0 =A0 =
=A0 =A0 =A0 | 1.0 G/s |=0A| Provisioned thin=A0 =A0 | 594 M/s |=0A| Snap no=
 sharing=A0 =A0  | 605 M/s | =0A=0A=0A=0AI think there are a couple of conc=
lusions we can draw from this:=0A=0Ai) dd isn't great for benchmarking bloc=
k devices=0Aii) if you are going to use it, then make sure you use O_DIRECT=
=0A=0AUsing an instrumented kernel, I've confirmed that these read tests=0A=
are taking the fast path through the code.=A0 The mapping tables are all=0A=
in memory.=A0 The bio_map function is always returning DM_MAPIO_REMAPPED.=
=0A=0AWill you be using a filesystem on these block devices?=0A=0A- Joe
---2114655128-221890458-1326915054=:99335
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:ar=
ial, helvetica, sans-serif;font-size:12pt"><div><span><div>Joe,</div><div>&=
nbsp;Thanks for looking into the issue and running the tests and suggesting=
 to use "direct" flag. I do see a difference with "direct" flag using dd. H=
owever the difference is significant when using bs=3D64M compared to bs=3D4=
k.&nbsp;</div><div><br></div><div><meta http-equiv=3D"content-type" content=
=3D"text/html; charset=3Dutf-8"><div style=3D"font-family: arial, helvetica=
, sans-serif; font-size: 12pt; "><span class=3D"Apple-style-span" style=3D"=
font-size: 16px; "><div style=3D"font-family: arial, helvetica, sans-serif;=
 font-size: 12pt; "><span class=3D"Apple-style-span" style=3D"font-size: 16=
px; "><div style=3D"font-family: arial, helvetica, sans-serif; font-size: 1=
2pt; ">dd-blocksize &nbsp;flags &nbsp;dm-thin &nbsp; &nbsp; LVMoutput &nbsp=
;&nbsp;</div><div style=3D"font-family: arial, helvetica, sans-serif; font-=
size: 12pt; ">64M
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;none &nbsp; 179 MB/=
s &nbsp; &nbsp; &nbsp; &nbsp; 1GB/s &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp=
;</div><div style=3D"font-family: arial, helvetica, sans-serif; font-size: =
12pt; ">64M &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;direct &=
nbsp; 2.4GB/s &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3.6GB/s &nbsp; &nbsp; &nbs=
p; &nbsp;</div><div style=3D"font-family: arial, helvetica, sans-serif; fon=
t-size: 12pt; ">4k &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; none &nbsp; 179 MB/s &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;965MB/s &nbsp=
; &nbsp; &nbsp;</div><div style=3D"font-family: arial, helvetica, sans-seri=
f; font-size: 12pt; ">4k &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; direct &nbsp; 193MB/s &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1.7GB/=
s &nbsp; &nbsp; &nbsp; &nbsp;</div><div><br></div></span></div></span></div=
></div><div>In all the tests, dm-thin performance is below lvm.&nbsp;<span
 class=3D"Apple-style-span" style=3D"font-size: 16px; ">I used 8M pages as =
we are not planning to use snapshots right now. &nbsp;</span></div><div sty=
le=3D"font-family: arial, helvetica, sans-serif; font-size: 12pt; "><br></d=
iv><div style=3D"font-family: arial, helvetica, sans-serif; font-size: 12pt=
; ">We are planning to use the dm-thin module in a high end flash device th=
at supports upto 300k IOPS/second. Hence &nbsp;we are doing some performanc=
e tests. I wanted to try more parallel async IO instead of dd. A good progr=
am I found on web is&nbsp;<br></div><div style=3D"font-family: arial, helve=
tica, sans-serif; font-size: 12pt; "><span class=3D"Apple-style-span" style=
=3D"color: rgb(0, 153, 51); font-family: arial, sans-serif; font-size: 14px=
; line-height: 15px; "><br></span></div><div style=3D"font-family: arial, h=
elvetica, sans-serif; font-size: 12pt; "><span class=3D"Apple-style-span" s=
tyle=3D"color: rgb(0, 153, 51); font-family: arial, sans-serif; font-size: =
14px;
 line-height: 15px; ">fsbench.filesystems.org/bench/<b>aio</b>-<b>stress</b=
>.c</span><br></div><div style=3D"font-family: arial, helvetica, sans-serif=
; font-size: 12pt; "><span class=3D"Apple-style-span" style=3D"color: rgb(0=
, 153, 51); font-family: arial, sans-serif; font-size: 14px; line-height: 1=
5px; "><br></span></div><div style=3D"font-family: arial, helvetica, sans-s=
erif; font-size: 12pt; ">(if you are aware of other tools to test parallel =
async io using multiple threads, please let me know. I will give it a try.)=
<br></div><div style=3D"font-family: arial, helvetica, sans-serif; font-siz=
e: 12pt; "><br></div><div style=3D"font-family: arial, helvetica, sans-seri=
f; font-size: 12pt; ">I compiled it with libaio and libpth.&nbsp;</div><div=
 style=3D"font-family: arial, helvetica, sans-serif; font-size: 12pt; "><br=
></div><div style=3D"font-family: arial, helvetica, sans-serif; font-size: =
12pt; ">Then I ran the test on LVM lun. Throughput is 9563.56MB/s.&nbsp;Ful=
ly
 allocated TP LUN is&nbsp;5399.81MB/s</div><div style=3D"font-family: arial=
, helvetica, sans-serif; font-size: 12pt; "><br></div><div style=3D"font-fa=
mily: arial, helvetica, sans-serif; font-size: 12pt; ">I used "perf top" to=
 see where most of the time is spent. Lot of time is spent in&nbsp;_raw_spi=
n_lock. I poked the code little bit and I see that&nbsp;dm_thin_find_block =
returns EWOULDBLOCK and hence the bio gets deferred. It looks like spin loc=
ks are used when putting the bio on deferred list and getting it back from =
the deferred list. I see that EWOULDBLOCK is returned from&nbsp;dm_thin_fin=
d_block -&gt;&nbsp;dm_btree_lookup-&gt;btree_lookup_raw-&gt;ro_step-&gt;bn_=
read_lock-&gt;dm_tm_read_lock-&gt;dm_bm_read_try_lock-&gt;bl_down_read_nonb=
lock.</div><div style=3D"font-family: arial, helvetica, sans-serif; font-si=
ze: 12pt; "><br></div><div style=3D"font-family: arial, helvetica, sans-ser=
if; font-size: 12pt; ">I tried to change the code little bit so
 that&nbsp;dm_thin_find_block uses array as a cache and looks up btree only=
 if not found in the array.</div><div style=3D"font-family: arial, helvetic=
a, sans-serif; font-size: 12pt; ">With that change, I see TP performance go=
 way up.</div><div style=3D"font-family: arial, helvetica, sans-serif; font=
-size: 12pt; "><br></div><div style=3D"font-family: arial, helvetica, sans-=
serif; font-size: 12pt; ">Fully allocated TP LUN with array lookup is 9387.=
17MB/s. With array, no bios are being deferred. However when I used the arr=
ay, I see kernel hang after several runs ( yet to debug the reason).</div><=
div style=3D"font-family: arial, helvetica, sans-serif; font-size: 12pt; ">=
<br></div><div style=3D"font-family: arial, helvetica, sans-serif; font-siz=
e: 12pt; ">Code changes are initialize array in pool_ctr() in dm-thin.c</di=
v><div style=3D"font-family: arial, helvetica, sans-serif; font-size: 12pt;=
 "><br></div><div>extern dm_block_t
 blockmap[1000];<br></div><div><div>printk("blockmap array inited");</div><=
div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;for(i=3D0;i&lt;1000;i++)</div><div>&nb=
sp;&nbsp; &nbsp; &nbsp; &nbsp;{</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp;blockmap[i]=3D0xffffffff;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp=
;}</div><div><br></div></div><div style=3D"font-family: arial, helvetica, s=
ans-serif; font-size: 12pt; "><br></div><div><div>dm_thin_find_block() in d=
m-thin-metadata.c</div><div><br></div><div>at the begining:</div><div><div>=
&nbsp;&nbsp; &nbsp; &nbsp; if(blockmap[block]=3D=3D0xffffffff)</div><div>&n=
bsp;&nbsp; &nbsp; &nbsp; &nbsp;{</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;printk("found unassigned block %llu\n",block);=
</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;}</div><div>&nbsp;&nbsp; &nbsp;=
 &nbsp; &nbsp;else</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;{</div><div>&=
nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;result-&gt;bloc=
k =3D
 blockmap[block];</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp;result-&gt;shared =3D 0;</div><div>&nbsp;&nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return 0;</div><div>&nbsp;&nbsp; &nbsp; =
&nbsp; &nbsp;}</div><div><br></div></div><div style=3D"font-family: arial, =
helvetica, sans-serif; font-size: 12pt; ">at the end before returning:</div=
><div><div>&nbsp;&nbsp; &nbsp; &nbsp; if(r =3D=3D 0)</div><div>&nbsp;&nbsp;=
 &nbsp; &nbsp; &nbsp;{</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp;blockmap[block] =3D result-&gt;block ;</div><div>&nbsp;&=
nbsp; &nbsp; &nbsp; &nbsp;}</div><div style=3D"font-family: arial, helvetic=
a, sans-serif; font-size: 12pt; "><br></div></div><div style=3D"font-family=
: arial, helvetica, sans-serif; font-size: 12pt; "><br></div></div><div sty=
le=3D"font-family: arial, helvetica, sans-serif; font-size: 12pt; ">Note th=
at the array changes are only for my testing and not generic enough at all.
 &nbsp;Command I used for getting the throughput numbers are</div><div styl=
e=3D"font-family: arial, helvetica, sans-serif; font-size: 12pt; "><br></di=
v><div>i=3D0; while [ $i -lt 100 ] ; do ./aio-stress.exe &nbsp;-O -o 1 -c 1=
6 -t 16 -d 256 /dev/mapper/thin1 2&gt;&amp;1 | grep throughput | cut -f3 -d=
 ' ' | cut -f2 -d '(' | cut -f1 -d ' ' ; let i=3D$i+1; done &nbsp;| awk 'BE=
GIN{i=3D0.0} {i+=3D$0} END{print i/100}'<br></div><div style=3D"font-family=
: arial, helvetica, sans-serif; font-size: 12pt; "><br></div><div style=3D"=
font-family: arial, helvetica, sans-serif; font-size: 12pt; ">Thanks,</div>=
<div style=3D"font-family: arial, helvetica, sans-serif; font-size: 12pt; "=
>Jagan.</div><div style=3D"font-family: arial, helvetica, sans-serif; font-=
size: 12pt; "><br></div></span></div>  <div style=3D"font-size: 12pt; font-=
family: arial, helvetica, sans-serif; "> <div style=3D"font-size: 12pt; fon=
t-family: 'times new roman', 'new york', times, serif; "> <div dir=3D"ltr">=
 <font size=3D"2"
 face=3D"Arial"> <hr size=3D"1">  <b><span style=3D"font-weight:bold;">From=
:</span></b> Joe Thornber &lt;thornber@redhat.com&gt;<br> <b><span style=3D=
"font-weight: bold;">To:</span></b> Jagan Reddy &lt;gjmsreddy@yahoo.com&gt;=
; device-mapper development &lt;dm-devel@redhat.com&gt; <br> <b><span style=
=3D"font-weight: bold;">Sent:</span></b> Monday, January 16, 2012 4:42 AM<b=
r> <b><span style=3D"font-weight: bold;">Subject:</span></b> Re: [dm-devel]=
 dm-thin vs lvm performance<br> </font> </div> <br>=0AHi Jagan,<br><br>On T=
hu, Jan 12, 2012 at 04:55:16PM -0800, Jagan Reddy wrote:<br>&gt; Hi,<br><br=
>&gt; I &nbsp;recently started using dm-thin module and first of all, thank=
 you<br>&gt; for the good work. It works great, well documented and the com=
ments<br>&gt; in the code are very useful. &nbsp;I tried to run some perfor=
mance tests<br>&gt; using a high performance flash device and the performan=
ce of dm thin<br>&gt; is about 30% of LVM performance on a full allocated t=
hin provisioned<br>&gt; volume. ( ie after all pages/blocks are allocated u=
sing<br>&gt; dd). Performance test does only reads and no writes.&nbsp;<br>=
<br>Thanks very much for taking the time to try thinp out properly.<br>Peop=
le testing different scenarios is very useful to us.<br><br>You're probably=
 aware that the thinp test suite is available here:<br><br>&nbsp; &nbsp; <a=
 href=3D"https://github.com/jthornber/thinp-test-suite"
 target=3D"_blank">https://github.com/jthornber/thinp-test-suite</a><br><br=
>I've added a little set of tests that recreate your scenario here:<br><br>=
&nbsp; &nbsp; <a href=3D"https://github.com/jthornber/thinp-test-suite/blob=
/master/ramdisk_tests.rb" target=3D"_blank">https://github.com/jthornber/th=
inp-test-suite/blob/master/ramdisk_tests.rb</a><br><br>I used a 2G ramdisk =
for these tests, and a variety of thinp block<br>sizes and 'dd' options.&nb=
sp; I'll just summarise the main results, also I<br>should point out that m=
y testing was done on a VM hosted on a 4G<br>machine, so the machine was un=
der a lot of memory pressure and there<br>was a lot of variance in the benc=
hmarks.<br><br>writes across various volumes<br>---------------------------=
--<br><br>write1<br>------<br><br>Testing write performance.<br><br>dd if=
=3D/dev/zero of=3D/dev/mapper/&lt;thin&gt; oflags=3Ddirect bs=3D64M<br><br>=
zeroing new blocks turned on.<br><br>thinp block size =3D 64k<br><br>| Line=
ar&nbsp;
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | 2.2 G/s |<br>| Unprovisioned t=
hin&nbsp; | 1.4 G/s |<br>| Provisioned thin&nbsp; &nbsp; | 1.9&nbsp; &nbsp;=
  |<br>| Snap totally shared | 1.5 G/s |<br>| Snap no sharing&nbsp; &nbsp; =
 | 1.9&nbsp; &nbsp;  |<br><br>Pretty good.&nbsp; Not showing the drastic dr=
op that you were seeing.&nbsp; The<br>small thinp block size means the snap=
s perform nicely (not many<br>copy-on-writes).<br><br>write2<br>------<br><=
br>As test1, but with 8M thinp block size as in your tests.<br><br>| Linear=
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | 2.2 G/s |<br>| Unprovisi=
oned thin&nbsp; | 1.5 G/s |<br>| Provisioned thin&nbsp; &nbsp; | 2.2&nbsp; =
&nbsp;  |<br>| Snap totally shared | 882 Ms&nbsp; |<br>| Snap no sharing&nb=
sp; &nbsp;  | 2.2&nbsp; &nbsp;  | <br><br>Good results, breaking sharing pe=
rformance is down because the large<br>block size mean there will be more a=
ctual copying incurred.<br><br>write3<br>------<br><br>As test2, but
 no oflags=3Ddirect option to dd.<br><br>| Linear&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; | 900 M/s |<br>| Unprovisioned thin&nbsp; | 579 M/s =
|<br>| Provisioned thin&nbsp; &nbsp; | 694 M/s |<br>| Snap totally shared |=
 510 M/s |<br>| Snap no sharing&nbsp; &nbsp;  | 654 M/s | <br><br>Alarming.=
&nbsp; Results are similar for thinp block size of 64k.<br><br>read1<br>---=
--<br><br>Testing read performance.<br><br>dd if=3D/dev/mapper/&lt;thin&gt;=
 of=3D/dev/null iflags=3Ddirect bs=3D64M<br><br>thinp block size =3D 64k<br=
><br>| Linear&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | 3.3 G/s |<b=
r>| Provisioned thin&nbsp; &nbsp; | 2.7 G/s |<br>| Snap no sharing&nbsp; &n=
bsp;  | 2.8 G/s | <br><br><br>read2<br>-----<br><br>read1 but with 8M thinp=
 block size<br><br>| Linear&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 | 3.3 G/s |<br>| Provisioned thin&nbsp; &nbsp; | 3.2 G/s |<br>| Snap no sh=
aring&nbsp; &nbsp;  | 3.3 G/s | <br><br>read3<br>-----<br><br>As read2, but
 without the iflags=3Ddirect option to 'dd'.<br><br>| Linear&nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | 1.0 G/s |<br>| Provisioned thin&nbsp; &=
nbsp; | 594 M/s |<br>| Snap no sharing&nbsp; &nbsp;  | 605 M/s | <br><br><b=
r><br>I think there are a couple of conclusions we can draw from this:<br><=
br>i) dd isn't great for benchmarking block devices<br>ii) if you are going=
 to use it, then make sure you use O_DIRECT<br><br>Using an instrumented ke=
rnel, I've confirmed that these read tests<br>are taking the fast path thro=
ugh the code.&nbsp; The mapping tables are all<br>in memory.&nbsp; The bio_=
map function is always returning DM_MAPIO_REMAPPED.<br><br>Will you be usin=
g a filesystem on these block devices?<br><br>- Joe<br><br><br> </div> </di=
v>  </div></body></html>
---2114655128-221890458-1326915054=:99335--


--===============3417799784578844595==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3417799784578844595==--
