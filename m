From: Dennis Yang <dennisyang@qnap.com>
Subject: Re: Possible data corruption with dm-thin
Date: Tue, 21 Jun 2016 18:40:27 +0800
Message-ID: <CAAR726KwSx0VU3E4UxhSgtfYyOeYJLdsxJrut10UJcfoOQ7hfw@mail.gmail.com>
References: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
	<54221955-a21e-5152-00e3-d6b78e0c78ef@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6545299448274249637=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54221955-a21e-5152-00e3-d6b78e0c78ef@redhat.com>
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

--===============6545299448274249637==
Content-Type: multipart/alternative; boundary=047d7b5d357a2bcf810535c77402

--047d7b5d357a2bcf810535c77402
Content-Type: text/plain; charset=UTF-8

2016-06-21 16:59 GMT+08:00 Zdenek Kabelac <zkabelac@redhat.com>:

> Dne 21.6.2016 v 09:56 Dennis Yang napsal(a):
>
>> Hi,
>>
>> We have been dealing with a data corruption issue when we run out I/O
>> test suite made by ourselves with multiple thin devices built on top of a
>> thin-pool. In our test suites, we will create multiple thin devices and
>> continually write to them, check the file checksum, and delete all files
>> and issue DISCARD to reclaim space if no checksum error takes place.
>>
>> We found that there is one data access pattern could corrupt the data.
>> Suppose that there are two thin devices A and B, and device A receives
>> a DISCARD bio to discard a physical(pool) block 100. Device A will quiesce
>> all previous I/O and held both virtual and physical data cell before it
>> actually remove the corresponding data mapping. After the data mapping
>> is removed, both data cell will be released and this DISCARD bio will
>> be passed down to underlying devices. If device B tries to allocate
>> a new block at the very same moment, it could reuse the block 100 which
>> was just been discarded by device A (suppose metadata commit had
>> been triggered, for a block cannot be reused in the same transaction).
>> In this case, we will have a race between the WRITE bio coming from
>> device B and the DISCARD bio coming from device A. Once the WRITE
>> bio completes before the DISCARD bio, there would be checksum error
>> for device B.
>>
>> So my question is, does dm-thin have any mechanism to eliminate the race
>> when
>> discarded block is reused right away by another device?
>>
>> Any help would be grateful.
>> Thanks,
>>
>
>
> Please provide version of kernel and surrounding tools (OS release
> version)?
> also are you using  'lvm2'  or you use directly 'dmsetup/ioctl' ?
> (in the later case we would need to see exact sequencing of operation).
>
> Also please provide  reproducer script.
>
>
> Regards
>
> Zdenek
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


Hi Zdenek,

We are using a customized dm-thin driver based on linux 3.19.8 running
on our QNAP NAS. Also, we create all our thin devices with "lvm2". I am
afraid that I cannot provide the reproducer script since we reproduce this
by
running the I/O stress test suite on Windows to all thin devices exported
to
them via samba and iSCSI.

The following is the trace of thin-pool we dumped via blktrace. The data
corruption takes place from sector address 310150144 to 310150144 + 832.

252,19   1   154916   184.875465510 29959  Q   W 310150144 + 1024
[kworker/u8:0]
252,19   0   205964   185.496309521     0      C   W 310150144 + 1024 [0]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
At first, pool receives a 1024 sector WRITE bio which had allocated a pool
block.

252,19   3   353811   656.542481344 30280  Q   D 310150144 + 1024
[kworker/u8:8]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Pool receives a 1024 sector (thin block size) DISCARD bio passed down by
one of the thin device.

252,19   1   495204   656.558652936 30280  Q   W 310150144 + 832
[kworker/u8:8]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Another thin device passed down a 832 sector WRITE bio to the exact same
place.

252,19   3   353820   656.564140283     0      C   W 310150144 + 832 [0]
252,19   0   697455   656.770883592     0      C   D 310150144 + 1024 [0]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Although the DISCARD bio was queued before the WRITE bio, their completion
had
been reordered which could corrupt the data.

252,19   1   515212   684.425478220 20751  A   R 310150144 + 80 <- (252,22)
28932096
252,19   1   515213   684.425478325 20751  Q   R 310150144 + 80 [smbd]
252,19   0   725274   684.425741079 23937  C   R 310150144 + 80 [0]

Hope this helps.
Thanks,

Dennis

-- 
Dennis Yang
QNAP Systems, Inc.
Skype: qnap.dennis.yang
Email: dennisyang@qnap.com
Tel: (+886)-2-2393-5152 ext. 15018
Address: 13F., No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei
City, Taiwan

--047d7b5d357a2bcf810535c77402
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">2016-06-21 16:59 GMT+08:00 Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left-width:1px;border-left-style:solid;border-left-color:rgb(=
204,204,204);padding-left:1ex">Dne 21.6.2016 v 09:56 Dennis Yang napsal(a):=
<span class=3D""><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-style:solid;border-left-color:rgb(204,204,204);p=
adding-left:1ex">
Hi,<br>
<br>
We have been dealing with a data corruption issue when we run out I/O<br>
test suite made by ourselves with multiple thin devices built on top of a<b=
r>
thin-pool. In our test suites, we will create multiple thin devices and<br>
continually write to them, check the file checksum, and delete all files<br=
>
and issue DISCARD to reclaim space if no checksum error takes place.<br>
<br>
We found that there is one data access pattern could corrupt the data.<br>
Suppose that there are two thin devices A and B, and device A receives<br>
a DISCARD bio to discard a physical(pool) block 100. Device A will quiesce<=
br>
all previous I/O and held both virtual and physical data cell before it<br>
actually remove the corresponding data mapping. After the data mapping<br>
is removed, both data cell will be released and this DISCARD bio will<br>
be passed down to underlying devices. If device B tries to allocate<br>
a new block at the very same moment, it could reuse the block 100 which<br>
was just been discarded by device A (suppose metadata commit had<br>
been triggered, for a block cannot be reused in the same transaction).<br>
In this case, we will have a race between the WRITE bio coming from<br>
device B and the DISCARD bio coming from device A. Once the WRITE<br>
bio completes before the DISCARD bio, there would be checksum error<br>
for device B.<br>
<br>
So my question is, does dm-thin have any mechanism to eliminate the race wh=
en<br>
discarded block is reused right away by another device?<br>
<br>
Any help would be grateful.<br>
Thanks,<br>
</blockquote>
<br>
<br></span>
Please provide version of kernel and surrounding tools (OS release version)=
?<br>
also are you using=C2=A0 &#39;lvm2&#39;=C2=A0 or you use directly &#39;dmse=
tup/ioctl&#39; ?<br>
(in the later case we would need to see exact sequencing of operation).<br>
<br>
Also please provide=C2=A0 reproducer script.<br>
<br>
<br>
Regards<br>
<br>
Zdenek<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div><br><br>Hi Zdenek,</div><div class=3D"gmail_extra"><br><=
/div><div class=3D"gmail_extra">We are using a customized dm-thin driver ba=
sed on linux 3.19.8 running</div><div class=3D"gmail_extra">on our QNAP NAS=
. Also, we create all our thin devices with &quot;lvm2&quot;. I am</div><di=
v class=3D"gmail_extra">afraid that I cannot provide the reproducer script =
since we reproduce this by=C2=A0</div><div class=3D"gmail_extra">running th=
e I/O stress test suite on Windows to all thin devices exported to=C2=A0</d=
iv><div class=3D"gmail_extra">them via samba and iSCSI.=C2=A0</div><div cla=
ss=3D"gmail_extra"><br></div><div class=3D"gmail_extra">The following is th=
e trace of thin-pool we dumped via blktrace. The data=C2=A0</div><div class=
=3D"gmail_extra">corruption takes place from sector address 310150144 to 31=
0150144 + 832.</div><div class=3D"gmail_extra">=C2=A0</div><div class=3D"gm=
ail_extra"><div class=3D"gmail_extra">252,19 =C2=A0 1 =C2=A0 154916 =C2=A0 =
184.875465510 29959 =C2=A0Q =C2=A0 W 310150144 + 1024 [kworker/u8:0]</div><=
div class=3D"gmail_extra">252,19 =C2=A0 0 =C2=A0 205964 =C2=A0 185.49630952=
1 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0C =C2=A0 W 310150144 + 1024 [0]</div>=
<div class=3D"gmail_extra">^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</div><div class=3D"gmail_extra">At first, p=
ool receives a 1024 sector WRITE bio which had allocated a pool block.</div=
><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">252,19 =C2=
=A0 3 =C2=A0 353811 =C2=A0 656.542481344 30280 =C2=A0Q =C2=A0 D 310150144 +=
 1024 [kworker/u8:8]</div><div class=3D"gmail_extra">^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</div><div class=
=3D"gmail_extra">Pool receives a 1024 sector (thin block size) DISCARD bio =
passed down by one of the thin device.</div><div class=3D"gmail_extra"><br>=
</div><div class=3D"gmail_extra">252,19 =C2=A0 1 =C2=A0 495204 =C2=A0 656.5=
58652936 30280 =C2=A0Q =C2=A0 W 310150144 + 832 [kworker/u8:8]</div><div cl=
ass=3D"gmail_extra">^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^^^^^^^^^^^^^</div><div class=3D"gmail_extra">Another thin devic=
e passed down a 832 sector WRITE bio to the exact same place.</div><div cla=
ss=3D"gmail_extra">=C2=A0</div><div class=3D"gmail_extra">252,19 =C2=A0 3 =
=C2=A0 353820 =C2=A0 656.564140283 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0C =
=C2=A0 W 310150144 + 832 [0]</div><div class=3D"gmail_extra">252,19 =C2=A0 =
0 =C2=A0 697455 =C2=A0 656.770883592 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0C =
=C2=A0 D 310150144 + 1024 [0]</div><div class=3D"gmail_extra">^^^^^^^^^^^^^=
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^</div><di=
v class=3D"gmail_extra">Although the DISCARD bio was queued before the WRIT=
E bio, their completion had=C2=A0</div><div class=3D"gmail_extra">been reor=
dered which could corrupt the data.</div><div class=3D"gmail_extra"><br></d=
iv><div class=3D"gmail_extra">252,19 =C2=A0 1 =C2=A0 515212 =C2=A0 684.4254=
78220 20751 =C2=A0A =C2=A0 R 310150144 + 80 &lt;- (252,22) 28932096</div><d=
iv class=3D"gmail_extra">252,19 =C2=A0 1 =C2=A0 515213 =C2=A0 684.425478325=
 20751 =C2=A0Q =C2=A0 R 310150144 + 80 [smbd]</div><div class=3D"gmail_extr=
a">252,19 =C2=A0 0 =C2=A0 725274 =C2=A0 684.425741079 23937 =C2=A0C =C2=A0 =
R 310150144 + 80 [0]</div></div><div class=3D"gmail_extra"><br></div><div c=
lass=3D"gmail_extra">Hope this helps.</div><div class=3D"gmail_extra">Thank=
s,</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Den=
nis</div><div class=3D"gmail_extra"><div><br></div>-- <br><div class=3D"gma=
il_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><span lan=
g=3D"EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">Dennis Ya=
ng=C2=A0</span><span lang=3D"EN-US" style=3D"font-size:10pt;font-family:Ari=
al,sans-serif">=C2=A0</span><span lang=3D"EN-US" style=3D"font-size:10pt;fo=
nt-family:Arial,sans-serif"><br>QNAP Systems, Inc.</span><div><span lang=3D=
"EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">Skype: qnap.d=
ennis.yang<br>Email:</span><span lang=3D"EN-US" style=3D"font-size:10pt;fon=
t-family:Arial,sans-serif">=C2=A0<a href=3D"mailto:dennisyang@qnap.com" tar=
get=3D"_blank">dennisyang@qnap.com</a></span><div><span lang=3D"EN-US" styl=
e=3D"font-size:10pt;font-family:Arial,sans-serif">Tel:</span><span style=3D=
"font-family:Arial,sans-serif;font-size:13.3333px">=C2=A0(+886)-2-2393-5152=
 ext.=C2=A0</span><span style=3D"font-family:Arial,sans-serif;font-size:13.=
3333px">15018</span><div><font face=3D"Arial, sans-serif" size=3D"2">Addres=
s:=C2=A0</font><span style=3D"color:rgb(51,51,51);font-family:Verdana,Arial=
,Helvetica,sans-serif;font-size:12px;line-height:18.6667px">13F., No.56, Se=
c. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei City, Taiwan</span></div></=
div></div></div></div>
</div></div>

--047d7b5d357a2bcf810535c77402--


--===============6545299448274249637==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6545299448274249637==--
