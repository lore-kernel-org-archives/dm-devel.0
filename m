From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: dm-cache failure semantics in write-back mode
Date: Tue, 17 Feb 2015 12:15:30 +0000
Message-ID: <CAM2wQBtW2Bit2rx-1+hngUyh1gObtt+vjWQkDVWcTfm=axCyDw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2510199085580466613=="
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

--===============2510199085580466613==
Content-Type: multipart/alternative; boundary=047d7bdc11d6b4abd7050f47a8e9

--047d7bdc11d6b4abd7050f47a8e9
Content-Type: text/plain; charset=UTF-8

Hi,

I'm trying to understand the failure semantics of dm-cache in write-back
mode. In Documentation/device-mapper/cache.txt it is stated:

"On-disk metadata is committed every time a FLUSH or FUA bio is written.
If no such requests are made then commits will occur every second.  This
means the cache behaves like a physical disk that has a volatile write
cache.  If power is lost you may lose some recent writes.  The metadata
should always be consistent in spite of any crash."

Which I admit confuses me. Assumie that no FLUSH/FUA requerst is issued
(e.g. the user of the cached device is a Windows VM) and a failure occurs
(e.g. there is a power failure but both the HDD and the SSD are fine)
immediatelly after a write I/O request, but before on-disk metadata get
commited (e.g. the failure occurs less than a second after the write I/O
request was completed). After the hosts reboots, is this completed write
I/O request going to be lost?

--047d7bdc11d6b4abd7050f47a8e9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div><br></div><div>I&#39;m trying to unders=
tand the failure semantics of dm-cache in write-back mode. In Documentation=
/device-mapper/cache.txt it is stated:</div><div><br></div><div><div>&quot;=
On-disk metadata is committed every time a FLUSH or FUA bio is written.</di=
v><div>If no such requests are made then commits will occur every second.=
=C2=A0 This</div><div>means the cache behaves like a physical disk that has=
 a volatile write</div><div>cache.=C2=A0 If power is lost you may lose some=
 recent writes.=C2=A0 The metadata</div><div>should always be consistent in=
 spite of any crash.&quot;</div></div><div><br></div><div>Which I admit con=
fuses me. Assumie that no FLUSH/FUA requerst is issued (e.g. the user of th=
e cached device is a Windows VM) and a failure occurs (e.g. there is a powe=
r failure but both the HDD and the SSD are fine) immediatelly after a write=
 I/O request, but before on-disk metadata get commited (e.g. the failure oc=
curs less than a second after the write I/O request was completed). After t=
he hosts reboots, is this completed write I/O request going to be lost?</di=
v></div>

--047d7bdc11d6b4abd7050f47a8e9--


--===============2510199085580466613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2510199085580466613==--
