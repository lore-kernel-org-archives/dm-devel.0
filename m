From: Krishan Baveja <kkbaveja1@gmail.com>
Subject: [dm-verity driver]: suggestion needed for dm-verity data
 block corrupted issue
Date: Thu, 10 Dec 2015 19:18:50 +0530
Message-ID: <CAPa=XHuOGY2PpvskxX6uL1r4JxtjVi-K9upgt3fS7qAw8sXCeQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1805199935918234022=="
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

--===============1805199935918234022==
Content-Type: multipart/alternative; boundary=001a114028e48060c305268b775d

--001a114028e48060c305268b775d
Content-Type: text/plain; charset=UTF-8

Hi,

This is regarding the behavior of dm-verity on Android. Could you please
provide your valuable suggestions?

[Issue]:
During development on android device after some usage of device , I could
see the following logs from dm-verity driver
https://android.googlesource.com/kernel/msm/+/android-6.0.1_r0.9/drivers/md/dm-verity.c#379

[dmesg]:
dm-verity: data block 77897 is corrupted

I think this indicates that data block 77897 in partition on which
dm-verity is enabled is corrupted. Means some hash mismatch occurred with
the predefined hash.

[Debugging]:
The /dev/block/dm-0 is mounted successfully on ext4 partition.

So I thought it could be a filesystem corruption issue, but it does not
seems to be.
I compared the system partition of the device in which the log is observed
and compared it with the same S/W in which the issue is not observed.

There seems to be no difference.

I am suspecting that it can be due to OS corruption or some bug in
dm-verity module.

Could you please suggest how to proceed further?

P.S.:
In my understanding correct about dm-verity in above case. At runtime,
dm-verity calculates the hash of each block when its read and verifies it
by traversing the precalculated hash tree. As dm-verity depends on a
precalculated hash tree over all blocks of a device, the underlying device
must be mounted read-only in order for verification to be possible. In
system partition dm-verity is enabled that hold system files, so system
files can be changed during OS updates through OTA. Any other change
indicates either OS(RAM) or disk(eMMC) corruption, or that a malicious
program is trying to modify the OS or masquerade as a system file.

Thanks in advance !

Best Regards
KK

--001a114028e48060c305268b775d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi, </div><div><br></div><div>This is regarding the b=
ehavior of dm-verity on Android. Could you please provide your valuable sug=
gestions?<br><br>[Issue]: <br>During development on android device after so=
me usage of device=C2=A0, I could see the following logs from dm-verity dri=
ver</div><div><a href=3D"https://android.googlesource.com/kernel/msm/+/andr=
oid-6.0.1_r0.9/drivers/md/dm-verity.c#379" target=3D"_blank">https://androi=
d.googlesource.com/kernel/msm/+/android-6.0.1_r0.9/drivers/md/dm-verity.c#3=
79</a></div><div><br></div><div>[dmesg]:</div><div>dm-verity: data block 77=
897 is corrupted </div><div><br></div><div>I think this indicates that data=
 block 77897 in partition on which dm-verity is enabled is corrupted. Means=
 some hash mismatch occurred with the predefined hash.</div><div><br></div>=
<div>[Debugging]: </div><div>The /dev/block/dm-0 is mounted successfully on=
 ext4 partition.</div><div><br></div><div>So I thought it could be a filesy=
stem corruption issue, but it does not seems to be. </div><div>I compared t=
he system partition of the device in which the log is observed and compared=
 it with the same=C2=A0S/W in which the issue is not observed. </div><div><=
br></div><div>There seems to be no difference.</div><div><br></div><div>I a=
m suspecting that it can be due to OS corruption or some bug in dm-verity m=
odule.</div><div><br></div><div>Could you please suggest how to proceed fur=
ther?</div><div><br></div><div>P.S.:</div><div>In my understanding correct =
about dm-verity in above case. At runtime, dm-verity calculates the hash of=
 each block when its read and verifies it by traversing the precalculated h=
ash tree. As dm-verity depends on a precalculated hash tree over all blocks=
 of a device, the underlying device must be mounted read-only in order for =
verification to be possible. In system partition dm-verity is enabled that =
hold system files, so system files can be changed during OS updates through=
 OTA. Any other change indicates either OS(RAM) or disk(eMMC) corruption, o=
r that a malicious program is trying to modify the OS or masquerade as a sy=
stem file. </div><div><br></div><div>Thanks in advance !</div><div><br></di=
v><div>Best Regards</div><div>KK</div></div>

--001a114028e48060c305268b775d--


--===============1805199935918234022==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1805199935918234022==--
