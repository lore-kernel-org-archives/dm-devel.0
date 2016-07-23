From: Gary <admin@garyshood.com>
Subject: dm-cache as a writeback cache that streams all writes to
 cache, and then updates origin
Date: Fri, 22 Jul 2016 18:56:47 -0700
Message-ID: <CAMOP6rNqF3K2-st5_W+nekUnvghT4oZAWMN9fj9SWhPDTmBR_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6229019247218382061=="
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

--===============6229019247218382061==
Content-Type: multipart/alternative; boundary=001a114452e226a556053843dd3f

--001a114452e226a556053843dd3f
Content-Type: text/plain; charset=UTF-8

I haven't tested the MQ policy since I'm on kernel 4.6, I am on SMQ. I have
a spinning disk as the origin that is falling behind as a mysql slave. I
added an ssd writeback cache but I can still see a a large amount of random
writes going to the spinning disk on iotop. The filesystem is XFS. Origin
is 2tb, but the dataset I am working with is only 305gb. The cache is 40gb
total.

dmsetup status shows

cached: 0 3906766976 cache 8 330/1663 512 163686/163686 1781562 5956880
6792625 24895886 18847 18847 3398 1 writeback 2 migration_threshold 2048
smq 0 rw -

a minute later shows

cached: 0 3906766976 cache 8 330/1663 512 163686/163686 1781956 5959500
6794474 24908493 18850 18850 3396 1 writeback 2 migration_threshold 2048
smq 0 rw -

I was looking over the archives of dm-cache and came across
https://www.redhat.com/archives/dm-devel/2015-September/msg00090.html

I understand that dm-cache does not just blindly stream all writes to the
cache and then update the origin. Is there some way I can enable that
though (even if it involves changing code)? The hotspot feature is
impractical for this workload and is of little help it seems. I know the
SSD taking writes by itself can keep up, I just can't dedicate that much
SSD space to this right now. I have to turn barriers off to make the hard
disk keep up and I'd rather not do that.

--001a114452e226a556053843dd3f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I haven&#39;t tested the MQ policy since I&#39;m on k=
ernel 4.6, I am on SMQ. I have a spinning disk as the origin that is fallin=
g behind as a mysql slave. I added an ssd writeback cache but I can still s=
ee a a large amount of random writes going to the spinning disk on iotop. T=
he filesystem is XFS. Origin is 2tb, but the dataset I am working with is o=
nly 305gb. The cache is 40gb total.<br></div><div><br></div><div>dmsetup st=
atus shows</div><div><br></div><div>cached: 0 3906766976 cache 8 330/1663 5=
12 163686/163686 1781562 5956880 6792625 24895886 18847 18847 3398 1 writeb=
ack 2 migration_threshold 2048 smq 0 rw -<br></div><div><br></div><div>a mi=
nute later shows</div><div><br></div><div>cached: 0 3906766976 cache 8 330/=
1663 512 163686/163686 1781956 5959500 6794474 24908493 18850 18850 3396 1 =
writeback 2 migration_threshold 2048 smq 0 rw -<br></div><div><br></div><di=
v>I was looking over the archives of dm-cache and came across <a href=3D"ht=
tps://www.redhat.com/archives/dm-devel/2015-September/msg00090.html">https:=
//www.redhat.com/archives/dm-devel/2015-September/msg00090.html</a><br></di=
v><div><br></div><div>I understand that dm-cache does not just blindly stre=
am all writes to the cache and then update the origin. Is there some way I =
can enable that though (even if it involves changing code)? The hotspot fea=
ture is impractical for this workload and is of little help it seems. I kno=
w the SSD taking writes by itself can keep up, I just can&#39;t dedicate th=
at much SSD space to this right now. I have to turn barriers off to make th=
e hard disk keep up and I&#39;d rather not do that.</div></div>

--001a114452e226a556053843dd3f--


--===============6229019247218382061==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6229019247218382061==--
