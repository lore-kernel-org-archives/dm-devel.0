From: monica g <monica.knmt@gmail.com>
Subject: Not able to create a device mapper target node
Date: Mon, 24 Jun 2013 12:49:04 +0530
Message-ID: <CABmd-rm-6P-+bkoHVAK25pEVgVBNswELepV5qvweTUd1J2Poag@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1155272971634003122=="
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

--===============1155272971634003122==
Content-Type: multipart/alternative; boundary=047d7b1632413cc7c104dfe13a3f

--047d7b1632413cc7c104dfe13a3f
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I wrote a basic device mapper driver which caches reads.

I gave dm msg prefix as below
 #define DM_MSG_PREFIX "cacheread".

When i try to create a device mapper node using the below command
echo "0 `blockdev --getsize /dev/sda2` cacheread /dev/sda2 0" | dmsetup
create cacheread

the system hangs.I am not getting any error messages.

When i try to create a device mapper node for linear target(this target is
already present with the device mapper code) using below command

echo "0 `blockdev --getsize /dev/sda2` linear /dev/sda2 0" | dmsetup create
linear
it succeeds and creates device node linear in /dev/mapper directory.

I am stuck with this issue and not able to proceed furthur.

Please let me know if you have any suggestions.

Any help is truely appreciated.

Thanks in advance.

Regards,
Monica

--047d7b1632413cc7c104dfe13a3f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div><div><div><div><div><di=
v>Hi,<br><br></div>I wrote a basic device mapper driver which caches reads.=
<br><br></div>I gave dm msg prefix as below<br>=A0#define DM_MSG_PREFIX &qu=
ot;cacheread&quot;.<br>
<br></div>When i try to create a device mapper node using the below command=
<br>echo &quot;0 `blockdev --getsize /dev/sda2` cacheread /dev/sda2 0&quot;=
 | dmsetup create cacheread<br><br></div>the system hangs.I am not getting =
any error messages.<br>
<br></div>When i try to create a device mapper node for linear target(this =
target is already present with the device mapper code) using below command<=
br><br>echo &quot;0 `blockdev --getsize /dev/sda2` linear /dev/sda2 0&quot;=
 | dmsetup create linear<br>
</div>it succeeds and creates device node linear in /dev/mapper directory.<=
br><br></div>I am stuck with this issue and not able to proceed furthur.<br=
><br></div>Please let me know if you have any suggestions.<br><br></div>
Any help is truely appreciated.<br><br></div>Thanks in advance.<br><br></di=
v>Regards,<br></div>Monica<br><div><div><div><div><div><div><div><div><br><=
br></div></div></div></div></div></div></div></div></div>

--047d7b1632413cc7c104dfe13a3f--


--===============1155272971634003122==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1155272971634003122==--
