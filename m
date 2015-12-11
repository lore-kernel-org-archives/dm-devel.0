From: Krishan Baveja <kkbaveja1@gmail.com>
Subject: Re: : suggestion needed for dm-verity data block
	corrupted issue
Date: Fri, 11 Dec 2015 09:55:27 +0900
Message-ID: <CAPa=XHubHXpkH8cXWEAxSZLNFPrGA-th9kFC7swrcV0xD8Bp-g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1788782720602232169=="
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

--===============1788782720602232169==
Content-Type: multipart/alternative; boundary=001a113f97b27d232a052694c7ba

--001a113f97b27d232a052694c7ba
Content-Type: text/plain; charset=UTF-8

Sending it again my query, after i subscribed to the mailing list.

> Hi,
>
> This is regarding the behavior of dm-verity on Android. Could you please
> provide your valuable suggestions?
>
> [Issue]:
> During development on android device after some usage of device , I could
> see the following logs from dm-verity driver
>
> https://android.googlesource.com/kernel/msm/+/android-6.0.1_r0.9/drivers/md/dm-verity.c#379
>
> [dmesg]:
> dm-verity: data block 77897 is corrupted
>
> I think this indicates that data block 77897 in partition on which
> dm-verity is enabled is corrupted. Means some hash mismatch occurred with
> the predefined hash.
>
> [Debugging]:
> The /dev/block/dm-0 is mounted successfully on ext4 partition.
>
> So I thought it could be a filesystem corruption issue, but it does not
> seems to be.
> I compared the system partition of the device in which the log is observed
> and compared it with the same S/W in which the issue is not observed.
>
> There seems to be no difference.
>
> I am suspecting that it can be due to OS corruption or some bug in
> dm-verity module.
>
> Could you please suggest how to proceed further?
>
> P.S.:
> In my understanding correct about dm-verity in above case. At runtime,
> dm-verity calculates the hash of each block when its read and verifies it
> by traversing the precalculated hash tree. As dm-verity depends on a
> precalculated hash tree over all blocks of a device, the underlying device
> must be mounted read-only in order for verification to be possible. In
> system partition dm-verity is enabled that hold system files, so system
> files can be changed during OS updates through OTA. Any other change
> indicates either OS(RAM) or disk(eMMC) corruption, or that a malicious
> program is trying to modify the OS or masquerade as a system file.
>
> Thanks in advance !
>
> Best Regards
> KK
>

--001a113f97b27d232a052694c7ba
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sending it again my query, after i subscribed to the maili=
ng list.<br><div><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex"><div dir=3D"ltr"><div>Hi, </div><div><br></div><=
div>This is regarding the behavior of dm-verity on Android. Could you pleas=
e provide your valuable suggestions?<br><br>[Issue]: <br>During development=
 on android device after some usage of device=C2=A0, I could see the follow=
ing logs from dm-verity driver</div><div><a href=3D"https://android.googles=
ource.com/kernel/msm/+/android-6.0.1_r0.9/drivers/md/dm-verity.c#379" targe=
t=3D"_blank">https://android.googlesource.com/kernel/msm/+/android-6.0.1_r0=
.9/drivers/md/dm-verity.c#379</a></div><div><br></div><div>[dmesg]:</div><d=
iv>dm-verity: data block 77897 is corrupted </div><div><br></div><div>I thi=
nk this indicates that data block 77897 in partition on which dm-verity is =
enabled is corrupted. Means some hash mismatch occurred with the predefined=
 hash.</div><div><br></div><div>[Debugging]: </div><div>The /dev/block/dm-0=
 is mounted successfully on ext4 partition.</div><div><br></div><div>So I t=
hought it could be a filesystem corruption issue, but it does not seems to =
be. </div><div>I compared the system partition of the device in which the l=
og is observed and compared it with the same=C2=A0S/W in which the issue is=
 not observed. </div><div><br></div><div>There seems to be no difference.</=
div><div><br></div><div>I am suspecting that it can be due to OS corruption=
 or some bug in dm-verity module.</div><div><br></div><div>Could you please=
 suggest how to proceed further?</div><div><br></div><div>P.S.:</div><div>I=
n my understanding correct about dm-verity in above case. At runtime, dm-ve=
rity calculates the hash of each block when its read and verifies it by tra=
versing the precalculated hash tree. As dm-verity depends on a precalculate=
d hash tree over all blocks of a device, the underlying device must be moun=
ted read-only in order for verification to be possible. In system partition=
 dm-verity is enabled that hold system files, so system files can be change=
d during OS updates through OTA. Any other change indicates either OS(RAM) =
or disk(eMMC) corruption, or that a malicious program is trying to modify t=
he OS or masquerade as a system file. </div><div><br></div><div>Thanks in a=
dvance !</div><div><br></div><div>Best Regards</div><div>KK</div></div>
</blockquote></div><br></div></div></div>

--001a113f97b27d232a052694c7ba--


--===============1788782720602232169==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1788782720602232169==--
