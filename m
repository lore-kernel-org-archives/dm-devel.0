From: Vladimir Smolensky <arizal@gmail.com>
Subject: Re: dm-cache fs corruption
Date: Fri, 15 Nov 2013 15:01:12 +0200
Message-ID: <CALwk7=wgChKoSqnj_CJwRfnRRwrfNnjPkr-zVGKunOTSjWz2Pw@mail.gmail.com>
References: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
	<20131113131022.GA13882@debian>
	<CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
	<20131113144112.GF13882@debian>
	<CALwk7=zWxL1QD3_pujA-QpWOCLLbJKT31p5HqTrzJwYPETh26g@mail.gmail.com>
	<CALwk7=xi2NBOE+bGcoygtsqFYzSE8a7DsC7p7MCRd06QU6jihQ@mail.gmail.com>
	<33A0129EBFD46748804DE81B354CA1B21C031F48@SACEXCMBX06-PRD.hq.netapp.com>
	<20131114143832.GC17651@debian>
	<CALwk7=xBTqtOQqXx6WnGyLAAXz4+wrQ9W3MOjs66mWBRhmqxBw@mail.gmail.com>
	<CALwk7=xGynqqH2CN8Eop7qioSR9FGVt7AmGRLkwWXC87KVO8WA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3114466580264376209=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALwk7=xGynqqH2CN8Eop7qioSR9FGVt7AmGRLkwWXC87KVO8WA@mail.gmail.com>
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

--===============3114466580264376209==
Content-Type: multipart/alternative; boundary=047d7ba982cef4d80504eb36ca99

--047d7ba982cef4d80504eb36ca99
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Okay, I'm trying to reproduce the problem using cache_restore, so far with
no luck. The hardware setup is the same as the original.

kernel 3.10.11-gentoo


Cache raid, 1 is meta, 2 data;

# parted /dev/sdc unit b print
Model: DELL PERC H700 (scsi)
Disk /dev/sdc: 2397799710720B
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start        End             Size            File system  Name
Flags
 1      1048576B     1024458751B     1023410176B                  primary
 2      1024458752B  2397798662143B  2396774203392B               primary

Origin:

# parted /dev/sdb unit b print
Model: DELL PERC H700 (scsi)
Disk /dev/sdb: 20973392756736B
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start     End              Size             File system  Name
Flags
 1      1048576B  20973391708159B  20973390659584B  xfs          primary

According to /dev/sda2 size, number of blocks should be

571435, with block size 4MiB( 8192 sectors)

Generating fake meta, I leave 5 blocks free

cache_xml create --nr-cache-blocks 571430 --nr-mappings 571430 0  >
/root/meta.xml

I edit the xml to set block size 8192 since there is no option for this.

cache_restore -i /root/meta.xml -o /dev/sdc1

dmsetup create storage --table '0 40963653632 cache /dev/sdc1 /dev/sdc2
/dev/sdb1 8192 1 writeback default 0=92


mkfs.xfs /dev/mapper/storage

mount //dev/mapper/storage /mnt

Then I run fio with following setup:

[test1]
loops=3D10000
randrepeat=3D1
directory=3D/mnt/fio/data/
new_group
group_reporting=3D1
size=3D100g
rwmixread=3D70
rw=3Drandrw
numjobs=3D12
ioengine=3Dsync
#direct=3D1
bs=3D1M
nrfiles=3D3000

This is the status so far:

# dmsetup status storage
0 40963653632 cache 1719/249856 93161125 11990840 93713813 27533087 307339
307344 571435 306978 0 2 migration_threshold 10000000 4 random_threshold 4
sequential_threshold 10000000

There are ~300k demotions with no crash so far.
So probably filling the cache/demotions are not the only factor here.

regards.




On Thu, Nov 14, 2013 at 10:22 PM, Vladimir Smolensky <arizal@gmail.com>wrot=
e:

> Okay, a little correction here. The problematic setup was with 2.3TB
> cache, not 3TB. The mistake comes from the fact that at the time of the
> writing I was dealing with another server which has 8x480GB ssd's in raid=
5,
> which is little over 3TB. Obviously the number was floating in my head.
>
>
> On Thu, Nov 14, 2013 at 5:21 PM, Vladimir Smolensky <arizal@gmail.com>wro=
te:
>
>> ./cache_restore -V
>> 0.2.8
>>
>>
>> On Thu, Nov 14, 2013 at 4:38 PM, Joe Thornber <thornber@redhat.com>wrote=
:
>>
>>> On Wed, Nov 13, 2013 at 06:39:37PM +0000, Mears, Morgan wrote:
>>> > On Wed, Nov 13, 2013 at 11:29:26AM -0005, Vladimir Smolensky wrote:
>>> > > Hello,
>>> > > I'm compiling the for-linus branch, it shows 3.12.0-rc5, that's ok
>>> right?
>>> > >
>>> > > Where can I get cache_restore, cache_dump, etc. and info how to use
>>> them.
>>> >
>>> > Hi Vladimir,
>>> >
>>> > git clone https://github.com/jthornber/thin-provisioning-tools.git
>>> > cd thin-provisioning-tools
>>> > autoreconf
>>> > ./configure --enable-testing
>>> > make
>>> > sudo cp cache_check cache_dump cache_restore cache_repair /usr/sbin
>>> > cache_check --version
>>> >
>>> > This is mostly distilled from README.md in the repo; there are some
>>> > additional dependencies in there that you might have to address.
>>> >
>>> > All the tools have a --help option; not sure about other documentatio=
n.
>>> >
>>> > --Morgan
>>>
>>> 'make install' should work, and I believe there are some man pages.
>>>
>>> - Joe
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>
>>
>>
>

--047d7ba982cef4d80504eb36ca99
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Okay, I&#39;m trying to reproduce the problem us=
ing cache_restore, so far with no luck. The hardware setup is the same as t=
he original.<br><br></div>kernel 3.10.11-gentoo<br><br><br></div><div>Cache=
 raid, 1 is meta, 2 data;<br>
<br># parted /dev/sdc unit b print<br>Model: DELL PERC H700 (scsi)<br>Disk =
/dev/sdc: 2397799710720B<br>Sector size (logical/physical): 512B/512B<br>Pa=
rtition Table: gpt<br>Disk Flags:<br><br>Number=A0 Start=A0=A0=A0=A0=A0=A0=
=A0 End=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 File system=A0 Name=A0=A0=A0=A0 Flags<br>
=A01=A0=A0=A0=A0=A0 1048576B=A0=A0=A0=A0 1024458751B=A0=A0=A0=A0 1023410176=
B=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 primary<br>=A02=A0=A0=
=A0=A0=A0 1024458752B=A0 2397798662143B=A0 2396774203392B=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 primary<br><br></div><div>Origin:<br><br># parted =
/dev/sdb unit b print<br>Model: DELL PERC H700 (scsi)<br>
Disk /dev/sdb: 20973392756736B<br>Sector size (logical/physical): 512B/512B=
<br>Partition Table: gpt<br>Disk Flags:<br><br>Number=A0 Start=A0=A0=A0=A0 =
End=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 File system=A0 Name=A0=A0=A0=A0 Flags<br>=A01=A0=A0=A0=A0=A0 1048=
576B=A0 20973391708159B=A0 20973390659584B=A0 xfs=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 primary<br>
<br></div><div>According to /dev/sda2 size, number of blocks should be <br>=
<br></div><div>571435, with block size 4MiB( 8192 sectors)<br><br>Generatin=
g fake meta, I leave 5 blocks free<br><span style=3D"font:13px Arial"><br>
cache_xml create --nr-cache-blocks 571430 --nr-mappings 571430 0=A0 &gt; /r=
oot/meta.xml<br><br></span></div><div><span style=3D"font:13px Arial">I edi=
t the xml to set block size 8192 since there is no option for this.<br></sp=
an></div>
<div>
<br><span style=3D"font:13px Arial">cache_restore -i /root/meta.xml -o /dev=
/sdc1</span><br>
<br><span style=3D"font:13px Arial">dmsetup create storage --table &#39;0 4=
0963653632 cache /dev/sdc1 /dev/sdc2 /dev/sdb1 8192 1 writeback default 0=
=92=A0</span><br>
<br><br></div><div>mkfs.xfs /dev/mapper/storage<br><br></div><div>mount //d=
ev/mapper/storage /mnt<br><br></div><div>Then I run fio with following setu=
p:<br><br>[test1]<br>loops=3D10000<br>randrepeat=3D1<br>directory=3D/mnt/fi=
o/data/<br>
new_group<br>group_reporting=3D1<br>size=3D100g<br>rwmixread=3D70<br>rw=3Dr=
andrw<br>numjobs=3D12<br>ioengine=3Dsync<br>#direct=3D1<br>bs=3D1M<br>nrfil=
es=3D3000<br></div><div><br></div><div>This is the status so far:<br><br># =
dmsetup status storage<br>
0 40963653632 cache 1719/249856 93161125 11990840 93713813 27533087 307339 =
307344 571435 306978 0 2 migration_threshold 10000000 4 random_threshold 4 =
sequential_threshold 10000000<br><br></div><div>There are ~300k demotions w=
ith no crash so far. <br>
</div><div>So probably filling the cache/demotions are not the only factor =
here.<br><br>regards.<br><br><br></div></div><div class=3D"gmail_extra"><br=
><br><div class=3D"gmail_quote">On Thu, Nov 14, 2013 at 10:22 PM, Vladimir =
Smolensky <span dir=3D"ltr">&lt;<a href=3D"mailto:arizal@gmail.com" target=
=3D"_blank">arizal@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">Okay, a little correction h=
ere. The problematic setup was with 2.3TB=20
cache, not 3TB. The mistake comes from the fact that at the time of the=20
writing I was dealing with another server which has 8x480GB ssd&#39;s in=20
raid5, which is little over 3TB. Obviously the number was floating in my
 head.<br></div><div class=3D"HOEnZb"><div class=3D"h5"><div class=3D"gmail=
_extra"><br><br><div class=3D"gmail_quote">On Thu, Nov 14, 2013 at 5:21 PM,=
 Vladimir Smolensky <span dir=3D"ltr">&lt;<a href=3D"mailto:arizal@gmail.co=
m" target=3D"_blank">arizal@gmail.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">./cache_restore -V<br>0.2.8=
<br></div><div><div><div class=3D"gmail_extra"><br><br>
<div class=3D"gmail_quote">On Thu, Nov 14, 2013 at 4:38 PM, Joe Thornber <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:thornber@redhat.com" target=3D"_blank=
">thornber@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div>On Wed, Nov 13, 2013 at 06:39:37PM +000=
0, Mears, Morgan wrote:<br>
&gt; On Wed, Nov 13, 2013 at 11:29:26AM -0005, Vladimir Smolensky wrote:<br=
>
&gt; &gt; Hello,<br>
&gt; &gt; I&#39;m compiling the for-linus branch, it shows 3.12.0-rc5, that=
&#39;s ok right?<br>
&gt; &gt;<br>
&gt; &gt; Where can I get cache_restore, cache_dump, etc. and info how to u=
se them.<br>
&gt;<br>
&gt; Hi Vladimir,<br>
&gt;<br>
&gt; git clone <a href=3D"https://github.com/jthornber/thin-provisioning-to=
ols.git" target=3D"_blank">https://github.com/jthornber/thin-provisioning-t=
ools.git</a><br>
&gt; cd thin-provisioning-tools<br>
&gt; autoreconf<br>
&gt; ./configure --enable-testing<br>
&gt; make<br>
&gt; sudo cp cache_check cache_dump cache_restore cache_repair /usr/sbin<br=
>
&gt; cache_check --version<br>
&gt;<br>
&gt; This is mostly distilled from README.md in the repo; there are some<br=
>
&gt; additional dependencies in there that you might have to address.<br>
&gt;<br>
&gt; All the tools have a --help option; not sure about other documentation=
.<br>
&gt;<br>
&gt; --Morgan<br>
<br>
</div>&#39;make install&#39; should work, and I believe there are some man =
pages.<br>
<span><font color=3D"#888888"><br>
- Joe<br>
</font></span><div><div><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--047d7ba982cef4d80504eb36ca99--


--===============3114466580264376209==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3114466580264376209==--
