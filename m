From: Ravi Prakash Putchala <praks.putchala@gmail.com>
Subject: Help request: setting up /dev/zero using dm-crypt ...
Date: Wed, 7 Feb 2018 13:45:50 +0530
Message-ID: <CABRTiaiJNVk-UXOVq6Qhah3sLRrjj1sb6KVWHNnVP1JbMUzx1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3978917049460740743=="
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

--===============3978917049460740743==
Content-Type: multipart/alternative; boundary="94eb2c11bed43f64dc05649ae777"

--94eb2c11bed43f64dc05649ae777
Content-Type: text/plain; charset="UTF-8"

Hi,

We would like to experiment and see the performance results with different
options of dm-crypt. To do this we would like to setup /dev/zero with
dm-crypt as mentioned in
https://www.redhat.com/archives/dm-devel/2015-February/msg00106.html
However, when I did the following no new mapping gets created in
/dev/mapper:

# cryptsetup -y luksFormat /dev/zero
# cryptsetup luksOpen /dev/zero dm-zero
# cryptsetup status /dev/mapper/dm-zero
/dev/mapper/dm-zero is inactive.

Could you please help by giving instructions on how to do this right?

Thank you.

Ravi

--94eb2c11bed43f64dc05649ae777
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div>Hi,<br><br></div>We would like to=
 experiment and see the performance results with different options of dm-cr=
ypt. To do this we would like to setup /dev/zero with dm-crypt as mentioned=
 in <a href=3D"https://www.redhat.com/archives/dm-devel/2015-February/msg00=
106.html">https://www.redhat.com/archives/dm-devel/2015-February/msg00106.h=
tml</a><br></div>However, when I did the following no new mapping gets crea=
ted in /dev/mapper:<br><br># cryptsetup -y luksFormat /dev/zero<br># crypts=
etup luksOpen /dev/zero dm-zero<br># cryptsetup status /dev/mapper/dm-zero<=
br>/dev/mapper/dm-zero is inactive.<br><br></div>Could you please help by g=
iving instructions on how to do this right?<br><br></div>Thank you.<br><br>=
</div>Ravi<br> </div>

--94eb2c11bed43f64dc05649ae777--


--===============3978917049460740743==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3978917049460740743==--
