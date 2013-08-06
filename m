From: =?Big5?B?seek5avb?= <burton.paramountcy@gmail.com>
Subject: dm-thin - issue about the maximum size of the metadata
	device
Date: Tue, 6 Aug 2013 12:18:22 +0800
Message-ID: <CAKG=6JXeGenwbFmgt9z+ScdMEAdxGHxH7NkoXxm_CmzCM8QxZQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2839090799022553701=="
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
List-Id: dm-devel.ids

--===============2839090799022553701==
Content-Type: multipart/alternative; boundary=001a11c227ee3388a804e33fb7a6

--001a11c227ee3388a804e33fb7a6
Content-Type: text/plain; charset=ISO-8859-1

Hi folks,

I currently do some experiments on the dm-thin-provisioning targets.
One of these experiments is trying to create/find-out the largest thin
volumn on the pool.

As I Know, each time we provision blocks from the pool, the metadata is
comsumed for recording the mapping information.
By executing the lvdisplay command, we can observe the status of the pool &
metadata usage, such as
$ sudo lvdisplay | grep Allocated
  Allocated pool data    7.87%
  Allocated metadata    6.09%

And the following content is extracted from thin-provisioning.txt from
Documentation\device-mapper in the source tree.
"As a guide, we suggest you calculate the number of bytes to use in the
metadata device as 48 * $data_dev_size / $data_block_size but round it up
to 2MB if the answer is smaller."

If the size of the metadata dev was fixed as 16G, and the block size of the
pool dev was set as 64K,
then we may infer that the largest volumn size of the thin is 21.33TB.

(48 * $data_dev_size / 64K = 16G
 $data_dev_size = 16G * 64K / 48 = 21.33TB)

If this inference was not correct, please kindly let me know why.

Then I do the experiment with the following steps:
1. create a thin-pool with size 21.33T on my RAID0, say, the largest size
we infered, and block size 64K, metadata size 16G
2. create a thin volumn with virtual size 21.33T.
3. dd data(/dev/uramdom) to the thin device

Finally, I observed that
  Allocated pool data    100.00%
  Allocated metadata     71.89%

It seemed that the pool data had already out of usage, but the metadata was
not.
Did it means that, metadata 16G can be applied to record a thin dev with
size bigger than 21.73T?

I did another experiment. In this time, I enlarged the size of pool/ thin
dev as big as I could offer.

1. create a thin-pool on my RAID0 with size 36.20T, and block size 64K,
metadata size 16G
2. create a thin volumn with virtual size 36.20T.
3. dd data to the thin device

Finally, I observed that
  Allocated pool data    84.52%
  Allocated metadata    99.99%

And these messages were shown in dmesge
device-mapper: space map metadata: out of metadata space
device-mapper: thin: pre_alloc_func: dm_thin_insert_block failed
device-mapper: space map metadata: out of metadata space
device-mapper: thin: commit failed, error = -28
device-mapper: thin: switching pool to read-only mode

In this experiment, we run out of the metadata, and by the "Allocated pool
data" field, we infered that the maximum thin device was about 30.59TB, was
it correct?

Regards,
Burton

--001a11c227ee3388a804e33fb7a6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi folks,</div><div><br></div><div>I currently do som=
e experiments on the dm-thin-provisioning targets.</div><div>One of these e=
xperiments is trying to create/find-out the largest thin volumn on the pool=
.</div>
<div><br></div><div>As I Know, each time we provision blocks from the pool,=
 the metadata is comsumed for recording the mapping information.</div><div>=
By executing the lvdisplay command, we can observe the status of the pool &=
amp; metadata usage, such as</div>
<div>$ sudo lvdisplay | grep Allocated</div><div>=A0 Allocated pool data =
=A0 =A07.87%</div><div>=A0 Allocated metadata =A0 =A06.09%</div><div><br></=
div><div>And the following content is extracted from thin-provisioning.txt =
from Documentation\device-mapper in the source tree.</div>
<div>&quot;As a guide, we suggest you calculate the number of bytes to use =
in the</div><div>metadata device as 48 * $data_dev_size / $data_block_size =
but round it up</div><div>to 2MB if the answer is smaller.&quot;</div><div>
<br></div><div>If the size of the metadata dev was fixed as 16G, and the bl=
ock size of the pool dev was set as 64K,=A0</div><div>then we may infer tha=
t the largest volumn size of the thin is 21.33TB.</div><div><br></div><div>
(48 * $data_dev_size / 64K =3D 16G</div><div>=A0$data_dev_size =3D 16G * 64=
K / 48 =3D 21.33TB)</div><div><br></div><div>If this inference was not corr=
ect, please kindly let me know why.</div><div><br></div><div>Then I do the =
experiment with the following steps:</div>
<div>1. create a thin-pool with size 21.33T on my RAID0, say, the largest s=
ize we infered, and block size 64K, metadata size 16G</div><div>2. create a=
 thin volumn with virtual size 21.33T.</div><div>3. dd data(/dev/uramdom) t=
o the thin device</div>
<div><br></div><div>Finally, I observed that</div><div>=A0 Allocated pool d=
ata =A0 =A0100.00%</div><div>=A0 Allocated metadata =A0 =A0 71.89%</div><di=
v><br></div><div>It seemed that the pool data had already out of usage, but=
 the metadata was not.</div>
<div>Did it means that, metadata 16G can be applied to record a thin dev wi=
th size bigger than 21.73T?</div><div><br></div><div>I did another experime=
nt. In this time, I enlarged the size of pool/ thin dev as big as I could o=
ffer.</div>
<div><br></div><div>1. create a thin-pool on my RAID0 with size 36.20T, and=
 block size 64K, metadata size 16G</div><div>2. create a thin volumn with v=
irtual size 36.20T.</div><div>3. dd data to the thin device</div><div><br>
</div><div>Finally, I observed that</div><div>=A0 Allocated pool data =A0 =
=A084.52%</div><div>=A0 Allocated metadata =A0 =A099.99%</div><div><br></di=
v><div>And these messages were shown in dmesge</div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>device-mapper: space map metadata: out of =
metadata space</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>device-mapper: thin=
: pre_alloc_func: dm_thin_insert_block failed</div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>device-mapper: space map metadata: out of m=
etadata space</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>device-mapper: thin=
: commit failed, error =3D -28</div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>device-mapper: thin: switching pool to read-only mode</div=
><div>
<br></div><div>In this experiment, we run out of the metadata, and by the &=
quot;Allocated pool data&quot; field, we infered that the maximum thin devi=
ce was about 30.59TB, was it correct?</div><div><br></div><div>Regards,</di=
v>
<div>Burton</div><div><br></div>
</div>

--001a11c227ee3388a804e33fb7a6--


--===============2839090799022553701==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2839090799022553701==--
