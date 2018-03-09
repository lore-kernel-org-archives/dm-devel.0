From: jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: device mapper mapping across reboot
Date: Fri, 9 Mar 2018 15:28:31 +0530
Message-ID: <CAN-6CVmztjkV6JL0k3N8Vh47Tr4oY_8Jj6-JL16b2YY5yNEHOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3844466785622891253=="
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

--===============3844466785622891253==
Content-Type: multipart/alternative; boundary="001a11498e24b34fef0566f7d5e7"

--001a11498e24b34fef0566f7d5e7
Content-Type: text/plain; charset="UTF-8"

Hi All,

I wrote the basic target using device mapper framework. Using dmsetup
utility I am able to create device node under /dev/mapper/my_custom_mapper.

But when I do reboot the system, it lost the mapping. Is there any way by
which I can create mapping during boot like LVM does.

---
Jitendra

--001a11498e24b34fef0566f7d5e7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi All,<div><br></div><div>I wrote the basic target using =
device mapper framework. Using dmsetup utility I am able to create device n=
ode under /dev/mapper/my_custom_mapper.=C2=A0</div><div><br></div><div>But =
when I do reboot the system, it lost the mapping. Is there any way by which=
 I can create mapping during boot like LVM does.</div><div><br></div><div>-=
--</div><div>Jitendra</div></div>

--001a11498e24b34fef0566f7d5e7--


--===============3844466785622891253==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3844466785622891253==--
