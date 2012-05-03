From: Mark-Willem Jansen <markwillem@hotmail.com>
Subject: Changing from dm-raid45.ko to dm-raid.ko
Date: Thu, 3 May 2012 23:12:18 +0200
Message-ID: <SNT145-W90D1BBEAC18B35B7F27D1CC2F0@phx.gbl>
Reply-To: "ATARAID \(eg, Promise Fasttrak,
	Highpoint 370\) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_e65f4349-aec9-4119-82e0-bf609525da5e_"
Return-path: <ataraid-list-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: ataraid-list@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

--_e65f4349-aec9-4119-82e0-bf609525da5e_
Content-Type: multipart/alternative;
	boundary="_3fb379ca-aba0-4253-a7dc-7113f9efeb9e_"

--_3fb379ca-aba0-4253-a7dc-7113f9efeb9e_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Dear md/dm developers=2C

As I already pointed out on the ataraid-list=2C I have made a small patch f=
or dmraid=2C so it will use the dm-raid target in state of the dm-raid45 ta=
rget to handle raid4 and riad5 setups. This patch is added to this e-mail. =
To put it in context I use dmraid to detect my fakeraid=2C which is shared =
with a Windows OS.

There were some things I could not figure out and would like to ask three q=
uestions regarding the arguments passed to the module.

- First a more general question does it look okay to you what I have implem=
ented?

- Second what to do with the offset variable that is given by the metadata =
on the disk? On the other dmraid related modules the disk information is pa=
ssed like [dev][offset]. With the dm-raid module it changed to [meta-dev][d=
ata-dev]. In the patch I ignore the meta-dev and just pass "- path_to_dev" =
to the module. This will work as the offset given by the metadata on my dis=
ks are equal to zero=2C the same value that is automatically set by the mod=
ule. What does one have to do if the metadata on the disk says that the off=
set is not equal to zero?

- Last I would like to build up the argument string more generally. Like co=
ncatenate the argument strings depending on some if statements=2C like

if(need_sync)
   num_arg +=3D 2=3B
   arguments =3D arguments + sprintf("rebuild %d"=2C rebuild_drive.data.i32=
)=3B
fi

And then pass the final string using

p_fmt(lc=2C table=2C "0 %U %s %s %u %s"=2C sectors=2C dm_type=2C raid_type=
=2C num_arg=2C arguments).

This will make the code easier to read and quicker to hack/change/code.

Thanks=2C

Mark-Willem Jansen
P.S.: The patch is a modified version of the one I send to the ataraid-list=
 some weeks ago.
 		 	   		  =

--_3fb379ca-aba0-4253-a7dc-7113f9efeb9e_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Tahoma
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>
Dear md/dm developers=2C<br><br>As I already pointed out on the ataraid-lis=
t=2C I have made a small patch for dmraid=2C so it will use the dm-raid tar=
get in state of the dm-raid45 target to handle raid4 and riad5 setups. This=
 patch is added to this e-mail. To put it in context I use dmraid to detect=
 my fakeraid=2C which is shared with a Windows OS.<br><br>There were some t=
hings I could not figure out and would like to ask three questions regardin=
g the arguments passed to the module.<br><br>- First a more general questio=
n does it look okay to you what I have implemented?<br><br>- Second what to=
 do with the offset variable that is given by the metadata on the disk? On =
the other dmraid related modules the disk information is passed like [dev][=
offset]. With the dm-raid module it changed to [meta-dev][data-dev]. In the=
 patch I ignore the meta-dev and just pass "- path_to_dev" to the module. T=
his will work as the offset given by the metadata on my disks are equal to =
zero=2C the same value that is automatically set by the module. What does o=
ne have to do if the metadata on the disk says that the offset is not equal=
 to zero?<br><br>- Last I would like to build up the argument string more g=
enerally. Like concatenate the argument strings depending on some if statem=
ents=2C like<br><br>if(need_sync)<br>&nbsp=3B&nbsp=3B num_arg +=3D 2=3B<br>=
&nbsp=3B&nbsp=3B arguments =3D arguments + sprintf("rebuild %d"=2C rebuild_=
drive.data.i32)=3B<br>fi<br><br>And then pass the final string using<br><br=
>p_fmt(lc=2C table=2C "0 %U %s %s %u %s"=2C sectors=2C dm_type=2C raid_type=
=2C num_arg=2C arguments).<br><br>This will make the code easier to read an=
d quicker to hack/change/code.<br><br>Thanks=2C<br><br>Mark-Willem Jansen<b=
r>P.S.: The patch is a modified version of the one I send to the ataraid-li=
st some weeks ago.<br> 		 	   		  </div></body>
</html>=

--_3fb379ca-aba0-4253-a7dc-7113f9efeb9e_--

--_e65f4349-aec9-4119-82e0-bf609525da5e_
Content-Type: text/x-patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="0014-Changed-from-dm-raid45-to-dm-raid-for-handling-RAID4.patch"

RnJvbSA1NmI5ZGZjMTczYzk5OGQyNmE2MGY4MjYzYTFiY2UyNGNkODU4YWU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJrLVdpbGxlbSBKYW5zZW4gPHJhd25hckB1c2Vycy5zb3Vy
Y2Vmb3JnZS5uZXQ+CkRhdGU6IFN1biwgMTUgQXByIDIwMTIgMDE6MDM6NDYgKzAyMDAKU3ViamVj
dDogW1BBVENIXSBDaGFuZ2VkIGZyb20gZG0tcmFpZDQ1IHRvIGRtLXJhaWQgZm9yIGhhbmRsaW5n
IFJBSUQ0LzUKCi0tLQogMS4wLjAucmMxNi9saWIvYWN0aXZhdGUvYWN0aXZhdGUuYyB8ICAgNDIg
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tCiAxLjAuMC5yYzE2L2xpYi9tZXRh
ZGF0YS9tZXRhZGF0YS5jIHwgICAxMCArKysrLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMzcgaW5z
ZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvMS4wLjAucmMxNi9saWIv
YWN0aXZhdGUvYWN0aXZhdGUuYyBiLzEuMC4wLnJjMTYvbGliL2FjdGl2YXRlL2FjdGl2YXRlLmMK
aW5kZXggMDViZDYxMC4uNmIzMzFjMiAxMDA2NDQKLS0tIGEvMS4wLjAucmMxNi9saWIvYWN0aXZh
dGUvYWN0aXZhdGUuYworKysgYi8xLjAuMC5yYzE2L2xpYi9hY3RpdmF0ZS9hY3RpdmF0ZS5jCkBA
IC0xMTgsNiArMTE4LDE1IEBAIF9kbV9wYXRoX29mZnNldChzdHJ1Y3QgbGliX2NvbnRleHQgKmxj
LCBjaGFyICoqdGFibGUsCiAJCSAgICAgdmFsaWQgPyBwYXRoIDogbGMtPnBhdGguZXJyb3IsIG9m
ZnNldCk7CiB9CiAKKy8qIFB1c2ggbWV0YSBwYXRoIGFuZCBkYXRhIHBhdGggb250byBhIHRhYmxl
LiAqLworc3RhdGljIGludAorX2RtX21ldGFfZGF0YV9wYXRoKHN0cnVjdCBsaWJfY29udGV4dCAq
bGMsIGNoYXIgKip0YWJsZSwKKwkJaW50IHZhbGlkLCBjb25zdCBjaGFyICpwYXRoKQoreworCXJl
dHVybiBwX2ZtdChsYywgdGFibGUsICIgLSAlcyIsCisJCSAgICAgdmFsaWQgPyBwYXRoIDogbGMt
PnBhdGguZXJyb3IpOworfQorCiAvKgogICogQ3JlYXRlIGRtIHRhYmxlIGZvciBsaW5lYXIgbWFw
cGluZy4KICAqLwpAQCAtNTQyLDE5ICs1NTEsMzIgQEAgX2RtX3JhaWQ0NV9ib2woc3RydWN0IGxp
Yl9jb250ZXh0ICpsYywgY2hhciAqKnRhYmxlLCBzdHJ1Y3QgcmFpZF9zZXQgKnJzLAogewogCWlu
dCBuZWVkX3N5bmMgPSByc19uZWVkX3N5bmMocnMpOwogCXN0cnVjdCBoYW5kbGVyX2luZm8gcmVi
dWlsZF9kcml2ZTsKKwl1bnNpZ25lZCBpbnQgbnVtX3JhaWRfcGFyYW1zOworCWNoYXIgKnJhaWRf
cGFyYW1zOwogCiAJLyogR2V0IGRyaXZlIGFzIHJlYnVpbGQgdGFyZ2V0LiAqLwogCXJlYnVpbGRf
ZHJpdmUuZGF0YS5pMzIgPSAtMTsKIAlpZiAobmVlZF9zeW5jICYmICFnZXRfcmVidWlsZF9kcml2
ZShsYywgcnMsICZyZWJ1aWxkX2RyaXZlKSkKIAkJcmV0dXJuIDA7CiAKLQlyZXR1cm4gcF9mbXQo
bGMsIHRhYmxlLCAiMCAlVSAlcyBjb3JlIDIgJXUgJXMgJXMgMSAldSAldSAlZCIsCi0JCSAgICAg
c2VjdG9ycywgZ2V0X2RtX3R5cGUobGMsIHJzLT50eXBlKSwKLQkJICAgICBjYWxjX3JlZ2lvbl9z
aXplKGxjLAotCQkJCSAgICAgIHRvdGFsX3NlY3RvcnMobGMsIHJzKSAvCi0JCQkJICAgICAgX2Rt
X3JhaWRfZGV2cyhsYywgcnMsIDApKSwKLQkJICAgICAobmVlZF9zeW5jKSA/ICJzeW5jIiA6ICJu
b3N5bmMiLCBnZXRfdHlwZShsYywgcnMtPnR5cGUpLAotCQkgICAgIHJzLT5zdHJpZGUsIG1lbWJl
cnMsIHJlYnVpbGRfZHJpdmUuZGF0YS5pMzIpOworCWlmICghbmVlZF9zeW5jKSB7CisJCXJldHVy
biBwX2ZtdChsYywgdGFibGUsICIwICVVICVzICVzIDQgJXUgbm9zeW5jIHJlZ2lvbl9zaXplICV1
ICV1IiwKKwkJCXNlY3RvcnMsCisJCQlnZXRfZG1fdHlwZShsYywgcnMtPnR5cGUpLCBnZXRfdHlw
ZShsYywgcnMtPnR5cGUpLAorCQkJcnMtPnN0cmlkZSwKKwkJCWNhbGNfcmVnaW9uX3NpemUobGMs
CisJCQkJdG90YWxfc2VjdG9ycyhsYywgcnMpIC8gX2RtX3JhaWRfZGV2cyhsYywgcnMsIDApKSwK
KwkJCW1lbWJlcnMpOworCX0gZWxzZSB7CisJCXJldHVybiBwX2ZtdChsYywgdGFibGUsICIwICVV
ICVzICVzIDYgJXUgc3luYyByZWJ1aWxkICV1IHJlZ2lvbl9zaXplICV1ICV1IiwKKwkJCXNlY3Rv
cnMsCisJCQlnZXRfZG1fdHlwZShsYywgcnMtPnR5cGUpLCBnZXRfdHlwZShsYywgcnMtPnR5cGUp
LAorCQkJcnMtPnN0cmlkZSwKKwkJCXJlYnVpbGRfZHJpdmUuZGF0YS5pMzIsCisJCQljYWxjX3Jl
Z2lvbl9zaXplKGxjLAorCQkJCXRvdGFsX3NlY3RvcnMobGMsIHJzKSAvIF9kbV9yYWlkX2RldnMo
bGMsIHJzLCAwKSksCisJCQltZW1iZXJzKTsKKwl9CiB9CiAKIC8qIENyZWF0ZSAiZXJyb3IgdGFy
Z2V0IiBuYW1lIGJhc2VkIG9uIHJhaWQgc2V0IG5hbWUuICovCkBAIC03NTksNyArNzgxLDcgQEAg
ZG1fcmFpZDQ1KHN0cnVjdCBsaWJfY29udGV4dCAqbGMsIGNoYXIgKip0YWJsZSwgc3RydWN0IHJh
aWRfc2V0ICpycykKIAkJaWYgKCEocGF0aCA9IG1rZG1fcGF0aChsYywgci0+bmFtZSkpKQogCQkJ
Z290byBlcnI7CiAKLQkJcmV0ID0gX2RtX3BhdGhfb2Zmc2V0KGxjLCB0YWJsZSwgdmFsaWRfcnMo
ciksIHBhdGgsIDApOworCQlyZXQgPSBfZG1fbWV0YV9kYXRhX3BhdGgobGMsIHRhYmxlLCB2YWxp
ZF9ycyhyKSwgcGF0aCk7CiAJCWRiZ19mcmVlKHBhdGgpOwogCiAJCWlmICghcmV0KQpAQCAtNzY4
LDggKzc5MCw4IEBAIGRtX3JhaWQ0NShzdHJ1Y3QgbGliX2NvbnRleHQgKmxjLCBjaGFyICoqdGFi
bGUsIHN0cnVjdCByYWlkX3NldCAqcnMpCiAKIAkvKiBMb3dlc3QgbGV2ZWwgUkFJRCBkZXZpY2Vz
LiAqLwogCWxpc3RfZm9yX2VhY2hfZW50cnkocmQsICZycy0+ZGV2cywgZGV2cykgewotCQlpZiAo
IV9kbV9wYXRoX29mZnNldChsYywgdGFibGUsIHZhbGlkX3JkKHJkKSwgCi0JCQkJICAgICByZC0+
ZGktPnBhdGgsIHJkLT5vZmZzZXQpKQorCQlpZiAoIV9kbV9tZXRhX2RhdGFfcGF0aChsYywgdGFi
bGUsIHZhbGlkX3JkKHJkKSwgCisJCQkJICAgICByZC0+ZGktPnBhdGgpKQogCQkJZ290byBlcnI7
CiAJfQogCmRpZmYgLS1naXQgYS8xLjAuMC5yYzE2L2xpYi9tZXRhZGF0YS9tZXRhZGF0YS5jIGIv
MS4wLjAucmMxNi9saWIvbWV0YWRhdGEvbWV0YWRhdGEuYwppbmRleCBlODc4MGVkLi4xZTU1ZWQw
IDEwMDY0NAotLS0gYS8xLjAuMC5yYzE2L2xpYi9tZXRhZGF0YS9tZXRhZGF0YS5jCisrKyBiLzEu
MC4wLnJjMTYvbGliL21ldGFkYXRhL21ldGFkYXRhLmMKQEAgLTMxLDExICszMSwxMSBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IHsKIAl7IHRfbGluZWFyLCAibGluZWFyIiwgImxpbmVhciJ9LAogCXsg
dF9yYWlkMCwgInN0cmlwZSIsICJzdHJpcGVkIn0sCiAJeyB0X3JhaWQxLCAibWlycm9yIiwgIm1p
cnJvciJ9LAotCXsgdF9yYWlkNCwgInJhaWQ0IiwgInJhaWQ0NSJ9LAotCXsgdF9yYWlkNV9scywg
InJhaWQ1X2xzIiwgInJhaWQ0NSJ9LAotCXsgdF9yYWlkNV9ycywgInJhaWQ1X3JzIiwgInJhaWQ0
NSJ9LAotCXsgdF9yYWlkNV9sYSwgInJhaWQ1X2xhIiwgInJhaWQ0NSJ9LAotCXsgdF9yYWlkNV9y
YSwgInJhaWQ1X3JhIiwgInJhaWQ0NSJ9LAorCXsgdF9yYWlkNCwgInJhaWQ0IiwgInJhaWQifSwK
Kwl7IHRfcmFpZDVfbHMsICJyYWlkNV9scyIsICJyYWlkIn0sCisJeyB0X3JhaWQ1X3JzLCAicmFp
ZDVfcnMiLCAicmFpZCJ9LAorCXsgdF9yYWlkNV9sYSwgInJhaWQ1X2xhIiwgInJhaWQifSwKKwl7
IHRfcmFpZDVfcmEsICJyYWlkNV9yYSIsICJyYWlkIn0sCiAJeyB0X3JhaWQ2LCAicmFpZDYiLCBO
VUxMfSwKIH07CiAKLS0gCjEuNy45LjUKCg==

--_e65f4349-aec9-4119-82e0-bf609525da5e_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ataraid-list mailing list
Ataraid-list@redhat.com
https://www.redhat.com/mailman/listinfo/ataraid-list
--_e65f4349-aec9-4119-82e0-bf609525da5e_--
