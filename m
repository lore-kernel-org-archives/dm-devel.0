From: devicemapper niko <devicemapper.niko@gmail.com>
Subject: dd between thin provisioned devices
Date: Sun, 27 Jan 2013 18:01:25 +0800
Message-ID: <CABSD0hKsdtxyQCeZPzFhwpiKY7kmapkPxWJLFidK4VujHnTqTg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8529257356277245748=="
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

--===============8529257356277245748==
Content-Type: multipart/alternative; boundary=f46d04478a8959e3b304d4423e16

--f46d04478a8959e3b304d4423e16
Content-Type: text/plain; charset=ISO-8859-1

Hi,everyone

if we dd between thin provisioned devices,
can we just get allocated blocks copied ?
Will the output thin device get fully provisioned?

I glanced through the dm-thin code,
it turns out unmapped blocks return zeroed,am i right?

Is there a trick to tell upper applications that all u got are zeroes.
or should they scan zeroed blocks themselves to trigger WRITE_SAME to
reduce I/O load?

--f46d04478a8959e3b304d4423e16
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,everyone</div><div>=A0</div><div>if we dd between =
thin provisioned devices,</div><div>can we just get allocated blocks copied=
 ?</div><div>Will=A0the output=A0thin device get fully provisioned?</div><d=
iv>=A0</div>
<div>I=A0glanced through the dm-thin code,</div><div>it turns out=A0unmappe=
d blocks return zeroed,am i right?</div><div>=A0</div><div>Is there a trick=
 to tell upper=A0applications that all u got are zeroes.</div><div>or=A0sho=
uld=A0they scan zeroed blocks themselves to trigger WRITE_SAME to reduce I/=
O load?</div>
</div>

--f46d04478a8959e3b304d4423e16--


--===============8529257356277245748==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8529257356277245748==--
