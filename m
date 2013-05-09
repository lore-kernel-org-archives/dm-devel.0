From: neha naik <nehanaik27@gmail.com>
Subject: device mapper v/s block device driver
Date: Thu, 9 May 2013 16:27:05 -0600
Message-ID: <CAOb=_x+xHq06wCYpT0kSGN=u4LYqHw96wm4MC+xoXx-f2UvE1g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4349916986282848347=="
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

--===============4349916986282848347==
Content-Type: multipart/alternative; boundary=047d7b1630c3d690d904dc508cf1

--047d7b1630c3d690d904dc508cf1
Content-Type: text/plain; charset=ISO-8859-1

Hi,
  There is no clear documentation available on the net about the scenarios
in which device mapper should be used and why block device driver cannot
work there.

  So, i am posting this question directly to the device mapper community  :
      One can write a block device driver which intercepts io , puts it in
its own biolist, takes action and then passes it to the block device driver
below it.
      (in the form of stackable block device driver) The same can be done
with the help of device mapper target. Then which should be used ?
       Are there any advantages of using block device driver instead of
device mapper (or vice versa)


Regards,
Neha

--047d7b1630c3d690d904dc508cf1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br>=A0 There is no clear documentation available on the net about the s=
cenarios in which device mapper should be used and why block device driver =
cannot work there.<br><br>=A0 So, i am posting this question directly to th=
e device mapper community=A0 :<br>
=A0=A0=A0=A0=A0 One can write a block device driver which intercepts io , p=
uts it in its own biolist, takes action and then passes it to the block dev=
ice driver below it.<br>=A0=A0=A0=A0=A0 (in the form of stackable block dev=
ice driver) The same can be done with the help of device mapper target. The=
n which should be used ?<br>
=A0=A0=A0=A0=A0=A0 Are there any advantages of using block device driver in=
stead of device mapper (or vice versa)<br><br><br>Regards,<br>Neha<br>=A0 <=
br>

--047d7b1630c3d690d904dc508cf1--


--===============4349916986282848347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4349916986282848347==--
