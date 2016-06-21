From: Dennis Yang <dennisyang@qnap.com>
Subject: Possible data corruption with dm-thin
Date: Tue, 21 Jun 2016 15:56:26 +0800
Message-ID: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8730047642576664042=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8730047642576664042==
Content-Type: multipart/alternative; boundary=001a114b0fc89a900a0535c529bc

--001a114b0fc89a900a0535c529bc
Content-Type: text/plain; charset=UTF-8

Hi,

We have been dealing with a data corruption issue when we run out I/O
test suite made by ourselves with multiple thin devices built on top of a
thin-pool. In our test suites, we will create multiple thin devices and
continually write to them, check the file checksum, and delete all files
and issue DISCARD to reclaim space if no checksum error takes place.

We found that there is one data access pattern could corrupt the data.
Suppose that there are two thin devices A and B, and device A receives
a DISCARD bio to discard a physical(pool) block 100. Device A will quiesce
all previous I/O and held both virtual and physical data cell before it
actually remove the corresponding data mapping. After the data mapping
is removed, both data cell will be released and this DISCARD bio will
be passed down to underlying devices. If device B tries to allocate
a new block at the very same moment, it could reuse the block 100 which
was just been discarded by device A (suppose metadata commit had
been triggered, for a block cannot be reused in the same transaction).
In this case, we will have a race between the WRITE bio coming from
device B and the DISCARD bio coming from device A. Once the WRITE
bio completes before the DISCARD bio, there would be checksum error
for device B.

So my question is, does dm-thin have any mechanism to eliminate the race
when
discarded block is reused right away by another device?

Any help would be grateful.
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

--001a114b0fc89a900a0535c529bc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hi,<br><br></div>We have been dealing with =
a data corruption issue when we run out I/O <br>test suite made by ourselve=
s with multiple thin devices built on top of a <br>thin-pool. In our test s=
uites, we will create multiple thin devices and <br>continually write to th=
em, check the file checksum, and delete all files <br>and issue DISCARD to =
reclaim space if no checksum error takes place. <br><br></div><div>We found=
 that there is one data access pattern could corrupt the data. <br>Suppose =
that there are two thin devices A and B, and device A receives <br></div><d=
iv>a DISCARD bio to discard a physical(pool) block 100. Device A will quies=
ce<br></div><div>all previous I/O and held both virtual and physical data c=
ell before it <br></div><div>actually remove the corresponding data mapping=
. After the data mapping <br></div><div>is removed, both data cell will be =
released and this DISCARD bio will <br></div><div>be passed down to underly=
ing devices. If device B tries to allocate <br></div><div>a new block at th=
e very same moment, it could reuse the block 100 which <br></div><div>was j=
ust been discarded by device A (suppose metadata commit had <br>been trigge=
red, for a block cannot be reused in the same transaction).<br></div><div>I=
n this case, we will have a race between the WRITE bio coming from <br></di=
v><div>device B and the DISCARD bio coming from device A. Once the WRITE<br=
></div><div>bio completes before the DISCARD bio, there would be checksum e=
rror<br></div><div>for device B.<br><br></div><div>So my question is, does =
dm-thin have any mechanism to eliminate the race when <br>discarded block i=
s reused right away by another device?<br></div><div><br></div><div>Any hel=
p would be grateful.<br></div><div>Thanks,<br><br></div><div>Dennis<br></di=
v></div>=C2=A0<br clear=3D"all"><div><div><div><div><div><div><div><div><di=
v><br>-- <br><div class=3D"gmail_signature" data-smartmail=3D"gmail_signatu=
re"><div dir=3D"ltr"><span style=3D"font-size:10pt;font-family:Arial,sans-s=
erif" lang=3D"EN-US">Dennis Yang=C2=A0</span><span style=3D"font-size:10pt;=
font-family:Arial,sans-serif" lang=3D"EN-US">=C2=A0</span><span style=3D"fo=
nt-size:10pt;font-family:Arial,sans-serif" lang=3D"EN-US"><br>QNAP Systems,=
 Inc.</span><div><span style=3D"font-size:10pt;font-family:Arial,sans-serif=
" lang=3D"EN-US">Skype: qnap.dennis.yang<br>Email:</span><span style=3D"fon=
t-size:10pt;font-family:Arial,sans-serif" lang=3D"EN-US">=C2=A0<a href=3D"m=
ailto:dennisyang@qnap.com" target=3D"_blank">dennisyang@qnap.com</a></span>=
<div><span style=3D"font-size:10pt;font-family:Arial,sans-serif" lang=3D"EN=
-US">Tel:</span><span style=3D"font-family:Arial,sans-serif;font-size:13.33=
3333969116211px">=C2=A0(+886)-2-2393-5152 ext.=C2=A0</span><span style=3D"f=
ont-family:Arial,sans-serif;font-size:13.333333969116211px">15018</span><di=
v><font face=3D"Arial, sans-serif" size=3D"2">Address:=C2=A0</font><span st=
yle=3D"color:rgb(51,51,51);font-family:Verdana,Arial,Helvetica,sans-serif;f=
ont-size:12px;line-height:18.66666603088379px">13F., No.56, Sec. 1, Xinshen=
g S. Rd., Zhongzheng Dist., Taipei City, Taiwan</span></div></div></div></d=
iv></div>
</div></div></div></div></div></div></div></div></div></div>

--001a114b0fc89a900a0535c529bc--


--===============8730047642576664042==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8730047642576664042==--
