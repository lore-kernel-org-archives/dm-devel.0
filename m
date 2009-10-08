From: "j.Lucas" <lukasz.jurewicz@gmail.com>
Subject: Help with MPIO assigning / blacklisting
Date: Fri, 9 Oct 2009 00:15:28 +0200
Message-ID: <8f3e95600910081515x1257d9fbud365667c7e55c713@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0209252532=="
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

--===============0209252532==
Content-Type: multipart/alternative; boundary=0015175ccf5cde67fc047573d1ae

--0015175ccf5cde67fc047573d1ae
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

I apologize if this is a simple question but I have tried in every
place I can google to resolve this before posting this.  The problem I
have (and hoping someone will help resolve) is:

Setting up a MPIO SAS configuration it is important to me that I have
multiple paths to a partition on each drive.. each drive has two
partitions, but only one is of interest.  So we normal have eg sdb,
sdb1 and sdb2.  However we only want to MPIO to sdb1.

Manually this would maybe seem easy, but there is likely to be many
many drives and hot-plugged in and out etc=85 so it seems sensible to
use the option of black listing and exclusions from black lists so
that DM only addresses sdx1=85.. but this is where my problems start and
my hair fails out.

I have tried reading everything I can find on this, and tried all
options I can think of=85 but I cannot get it work like this.  In fact I
cannot seem to get it to by default see any of the partitions (without
having to manually run something).

I have even tried to blacklist ALL sd[a-z]  (which seems to work) but
exclude i.e. sdb1 which doesn=92t seem to work.

I really would appreciate any advice as I am sure that to someone who
has the experience here will probably be able to resolve this in a
couple of lines as opposed to my couple of years!

Thank you

--=20
Lucas

--0015175ccf5cde67fc047573d1ae
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

I apologize if this is a simple question but I have tried in every<br>
place I can google to resolve this before posting this. =A0The problem I<br=
>
have (and hoping someone will help resolve) is:<br>
<br>
Setting up a MPIO SAS configuration it is important to me that I have<br>
multiple paths to a partition on each drive.. each drive has two<br>
partitions, but only one is of interest. =A0So we normal have eg sdb,<br>
sdb1 and sdb2. =A0However we only want to MPIO to sdb1.<br>
<br>
Manually this would maybe seem easy, but there is likely to be many<br>
many drives and hot-plugged in and out etc=85 so it seems sensible to<br>
use the option of black listing and exclusions from black lists so<br>
that DM only addresses sdx1=85.. but this is where my problems start and<br=
>
my hair fails out.<br>
<br>
I have tried reading everything I can find on this, and tried all<br>
options I can think of=85 but I cannot get it work like this. =A0In fact I<=
br>
cannot seem to get it to by default see any of the partitions (without<br>
having to manually run something).<br>
<br>
I have even tried to blacklist ALL sd[a-z] =A0(which seems to work) but<br>
exclude i.e. sdb1 which doesn=92t seem to work.<br>
<br>
I really would appreciate any advice as I am sure that to someone who<br>
has the experience here will probably be able to resolve this in a<br>
couple of lines as opposed to my couple of years!<br>
<br>
Thank you<br clear=3D"all"><br>-- <br>Lucas<br>

--0015175ccf5cde67fc047573d1ae--


--===============0209252532==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0209252532==--
