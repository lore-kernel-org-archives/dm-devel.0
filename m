From: Leonardo Santos <heiligerstein@gmail.com>
Subject: Re: dmcache RAID1 bug?
Date: Wed, 19 Nov 2014 19:39:44 -0200
Message-ID: <CAEZ+n-ha0tFew+807rumUQsk-tqYVyxPUTrGoz0DvdCqLK50Og@mail.gmail.com>
References: <CAEZ+n-i7kOC3zZzrv5GHbmfuKJ3b1U6COG8DyDW8HjHk9wDf-Q@mail.gmail.com>
	<20141117144659.GA29929@redhat.com>
	<CAEZ+n-jJoCS0WqeeiETYf1jAwPJzy+fyEgr_-Qek+7NzS+uERQ@mail.gmail.com>
	<CAEZ+n-i3yP+qO6bVDs8O0CwkJKBNzVBMW6gOtd=dty9ALj_8eQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b3a8b0ad76df105083d0cb0
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEZ+n-i3yP+qO6bVDs8O0CwkJKBNzVBMW6gOtd=dty9ALj_8eQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--047d7b3a8b0ad76df105083d0cb0
Content-Type: multipart/alternative; boundary=047d7b3a8b0ad76dec05083d0cae

--047d7b3a8b0ad76dec05083d0cae
Content-Type: text/plain; charset=UTF-8

After run regression tests using 'git bisect', I identify that the error
was created after commit 8c081b52c6833a30a69ea3bdcef316eccc740c87

To reproduce this error just:
- create a raid1 HDDs for origin device;
- create a cache device with SSDs (could or not be raid)
- create a metadata device with SSDs (could or not be raid)
- create a cache device using prior devices
- kernel crashes.

I attached the bitseclog and diff file!

On Tue, Nov 18, 2014 at 4:18 PM, Leonardo Santos <heiligerstein@gmail.com>
wrote:

> I tested updating my xbox to same production kernel (3.17.2) and the
> problem appears now.
>
> The old kernel (ok) is 3.13.0-37.
>
> About updating lvm, I think it should not be, because this time I did not
> use them and did creating only through the dmsetup command.
>
> I will continue testing with other kernels.
>
> Can anyone help me?
>
>
> On Mon, Nov 17, 2014 at 4:14 PM, Leonardo Santos <heiligerstein@gmail.com>
> wrote:
>
>> On Mon, Nov 17, 2014 at 12:46 PM, Mike Snitzer <snitzer@redhat.com>
>> wrote:
>>
>>> On Mon, Nov 17 2014 at  9:24am -0500,
>>> Leonardo Santos <heiligerstein@gmail.com> wrote:
>>>
>>> > I'm working in tests for my msc thesis envolving dm_cache module. I'm
>>> > having problems with the following scenario:
>>> >
>>> > Slowstorage: RAID1 (mdadm) with 4 HDDs;
>>> > - /dev/md/raid1_4ssds
>>>
>>> You mean /dev/md/raid1_4hdds ?
>>>
>>
>> A symlink to raid1 created using 4 ssds.
>>
>> mdadm --create --verbose /dev/md/raid0_4ssds --raid-devices=4 --force
>> --level=1 /dev/sdd /dev/sdc /dev/sdb /dev/sda
>>
>>
>>>
>>> > -- /dev/sda
>>> > -- /dev/sdb
>>> > -- /dev/sdc
>>> > -- /dev/sdd
>>> >
>>> > Faststorage: RAID1 (mdadm) with 4 SSDs
>>> > - /dev/md/raid1_4hdds
>>>
>>> And /dev/md/raid1_4ssds here?
>>>
>>
>> mdadm --create --verbose /dev/md/raid0_4hdds --raid-devices=4 --force
>> --level=1  /dev/sdh /dev/sdg /dev/sdf /dev/sde
>>
>>
>>>
>>> > -- /dev/sde
>>> > -- /dev/sdf
>>> > -- /dev/sdg
>>> > -- /dev/sdh
>>> >
>>> >
>>> > Cachestorage: dm_cache envolving both devices
>>> > - /dev/mapper/dmcache
>>> > -- /dev/md/raid1_4ssds
>>> > -- /dev/md/raid1_4hdds
>>> >
>>>
>>
>> Commands:
>> vgcreate cache /dev/md/raid0_4ssds -y
>> lvcreate cache -n metadata -l 5%FREE
>> lvcreate cache -n block -l 100%FREE
>> dd if=/dev/zero of=/dev/cache/metadata bs=1M count=100
>> # 16773120 = blockdev --getsize /dev/md/raid0_4hdds
>> dmsetup create dmcache --table '0 16773120 cache /dev/cache/metadata
>> /dev/cache/block /dev/md/raid0_4hdds 512 1 writeback default 0'
>>
>>
>>> > Other informations (strange facts):
>>> > In RAID0 it's working very well.
>>> > In a virtual machine (vbox) it's working as well (in this case disks
>>> have
>>> > 2GB only for big tests automatization, in production are 160GB SSDs
>>> and 2TB
>>> > HDDs);
>>> >
>>> > Have you seen about this error? Syslog is bellow.
>>>
>>> Never seen this before... have you taken care to zero the dm-cache
>>> metadata's superblock (first 512B of the cache metadata device) each
>>> time you've reconfigured the cache device?
>>>
>>> Have you tried using the latest lvm2 to create the dm-cache device?
>>>
>>
>> I've used LVM2 from distribution (debian) and a latest kernel version.
>>
>> LVM2 latest today is 2.02.112 (I'll try with latest LVM2 version and post
>> results).
>>
>> # lvm version
>>   LVM version:     2.02.95(2) (2012-03-06)
>>   Library version: 1.02.74 (2012-03-06)
>>   Driver version:  4.27.0
>>
>> # uname -a
>> Linux steinhager 3.17.2 #2 SMP Fri Nov 7 12:49:16 BRST 2014 x86_64
>> GNU/Linux
>>
>
>

--047d7b3a8b0ad76dec05083d0cae
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>After run regression tests using &#39;git bisect&#39;=
, I identify that the error was created after commit 8c081b52c6833a30a69ea3=
bdcef316eccc740c87</div><div><br></div><div>To reproduce this error just:</=
div><div>- create a raid1 HDDs for origin device;</div><div>- create a cach=
e device with SSDs (could or not be raid)</div><div>- create a metadata dev=
ice with SSDs (could or not be raid)</div><div>- create a cache device usin=
g prior devices</div><div>- kernel crashes.<br></div><div><br></div><div>I =
attached the bitseclog and diff file!</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Tue, Nov 18, 2014 at 4:18 PM, Leonardo S=
antos <span dir=3D"ltr">&lt;<a href=3D"mailto:heiligerstein@gmail.com" targ=
et=3D"_blank">heiligerstein@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><div dir=3D"ltr"><div><div>I tested updating my xbox to =
same production kernel (3.17.2) and the problem appears now.</div><div><br>=
</div><div>The old kernel (ok) is 3.13.0-37.</div><div><br></div><div>About=
 updating lvm, I think it should not be, because this time I did not use th=
em and did creating only through the dmsetup command.</div><div><br></div><=
div>I will continue testing with other kernels.</div><div><br></div><div>Ca=
n anyone help me?</div></div><div><br></div></div><div class=3D"HOEnZb"><di=
v class=3D"h5"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On=
 Mon, Nov 17, 2014 at 4:14 PM, Leonardo Santos <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:heiligerstein@gmail.com" target=3D"_blank">heiligerstein@gmail.=
com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr=
"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><span>On Mon, Nov 1=
7, 2014 at 12:46 PM, Mike Snitzer <span dir=3D"ltr">&lt;<a href=3D"mailto:s=
nitzer@redhat.com" target=3D"_blank">snitzer@redhat.com</a>&gt;</span> wrot=
e:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;b=
order-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:s=
olid;padding-left:1ex"><span>On Mon, Nov 17 2014 at=C2=A0 9:24am -0500,<br>
Leonardo Santos &lt;<a href=3D"mailto:heiligerstein@gmail.com" target=3D"_b=
lank">heiligerstein@gmail.com</a>&gt; wrote:<br>
<br>
&gt; I&#39;m working in tests for my msc thesis envolving dm_cache module. =
I&#39;m<br>
&gt; having problems with the following scenario:<br>
&gt;<br>
&gt; Slowstorage: RAID1 (mdadm) with 4 HDDs;<br>
&gt; - /dev/md/raid1_4ssds<br>
<br>
</span>You mean /dev/md/raid1_4hdds ?<br></blockquote><div><br></div></span=
><div>A symlink to raid1 created using 4 ssds.</div><div><br></div><div>mda=
dm --create --verbose /dev/md/raid0_4ssds --raid-devices=3D4 --force --leve=
l=3D1 /dev/sdd /dev/sdc /dev/sdb /dev/sda<br></div><span><div>=C2=A0</div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;pa=
dding-left:1ex">
<span><br>
&gt; -- /dev/sda<br>
&gt; -- /dev/sdb<br>
&gt; -- /dev/sdc<br>
&gt; -- /dev/sdd<br>
&gt;<br>
&gt; Faststorage: RAID1 (mdadm) with 4 SSDs<br>
&gt; - /dev/md/raid1_4hdds<br>
<br>
</span>And /dev/md/raid1_4ssds here?<br></blockquote><div><br></div></span>=
<div>mdadm --create --verbose /dev/md/raid0_4hdds --raid-devices=3D4 --forc=
e --level=3D1 =C2=A0/dev/sdh /dev/sdg /dev/sdf /dev/sde<br></div><span><div=
>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-=
style:solid;padding-left:1ex">
<span><br>
&gt; -- /dev/sde<br>
&gt; -- /dev/sdf<br>
&gt; -- /dev/sdg<br>
&gt; -- /dev/sdh<br>
&gt;<br>
&gt;<br>
&gt; Cachestorage: dm_cache envolving both devices<br>
&gt; - /dev/mapper/dmcache<br>
&gt; -- /dev/md/raid1_4ssds<br>
&gt; -- /dev/md/raid1_4hdds<br>
&gt;<br></span></blockquote><div><br></div></span><div>Commands:</div><div>=
vgcreate cache /dev/md/raid0_4ssds -y<br></div><div><div>lvcreate cache -n =
metadata -l 5%FREE<br></div><div>lvcreate cache -n block -l 100%FREE<br></d=
iv><div>dd if=3D/dev/zero of=3D/dev/cache/metadata bs=3D1M count=3D100<br><=
/div><div>#=C2=A016773120=C2=A0=3D blockdev --getsize /dev/md/raid0_4hdds<b=
r></div><div>dmsetup create dmcache --table &#39;0 16773120 cache /dev/cach=
e/metadata /dev/cache/block /dev/md/raid0_4hdds 512 1 writeback default 0&#=
39;</div></div><span><div>=C2=A0<br></div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:=
rgb(204,204,204);border-left-style:solid;padding-left:1ex"><span>
&gt; Other informations (strange facts):<br>
&gt; In RAID0 it&#39;s working very well.<br>
&gt; In a virtual machine (vbox) it&#39;s working as well (in this case dis=
ks have<br>
&gt; 2GB only for big tests automatization, in production are 160GB SSDs an=
d 2TB<br>
&gt; HDDs);<br>
&gt;<br>
&gt; Have you seen about this error? Syslog is bellow.<br>
<br>
</span>Never seen this before... have you taken care to zero the dm-cache<b=
r>
metadata&#39;s superblock (first 512B of the cache metadata device) each<br=
>
time you&#39;ve reconfigured the cache device?<br>
<br>
Have you tried using the latest lvm2 to create the dm-cache device?<br>
</blockquote></span></div><br></div><div class=3D"gmail_extra">I&#39;ve use=
d LVM2 from distribution (debian) and a latest kernel version.</div><div cl=
ass=3D"gmail_extra"><br></div><div class=3D"gmail_extra">LVM2 latest today =
is 2.02.112 (I&#39;ll try with latest LVM2 version and post results).</div>=
<div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><div class=
=3D"gmail_extra"># lvm version</div><div class=3D"gmail_extra">=C2=A0 LVM v=
ersion: =C2=A0 =C2=A0 2.02.95(2) (2012-03-06)</div><div class=3D"gmail_extr=
a">=C2=A0 Library version: 1.02.74 (2012-03-06)</div><div class=3D"gmail_ex=
tra">=C2=A0 Driver version: =C2=A04.27.0</div><div><br></div><div><div># un=
ame -a</div><div>Linux steinhager 3.17.2 #2 SMP Fri Nov 7 12:49:16 BRST 201=
4 x86_64 GNU/Linux</div></div></div></div>
</blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--047d7b3a8b0ad76dec05083d0cae--

--047d7b3a8b0ad76df105083d0cb0
Content-Type: text/plain; charset=US-ASCII; name="dmcache.diff"
Content-Disposition: attachment; filename="dmcache.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2p7nm5c1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tY2FjaGUtdGFyZ2V0LmMgYi9kcml2ZXJzL21kL2Rt
LWNhY2hlLXRhcmdldC5jCmluZGV4IDJjNjMzMjYuLjJhMTU2YWYgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbWQvZG0tY2FjaGUtdGFyZ2V0LmMKKysrIGIvZHJpdmVycy9tZC9kbS1jYWNoZS10YXJnZXQu
YwpAQCAtNzE4LDYgKzcxOCwyMiBAQCBzdGF0aWMgaW50IGJpb190cmlnZ2Vyc19jb21taXQoc3Ry
dWN0IGNhY2hlICpjYWNoZSwgc3RydWN0IGJpbyAqYmlvKQogCXJldHVybiBiaW8tPmJpX3J3ICYg
KFJFUV9GTFVTSCB8IFJFUV9GVUEpOwogfQogCisvKgorICogWW91IG11c3QgaW5jcmVtZW50IHRo
ZSBkZWZlcnJlZCBzZXQgd2hpbHN0IHRoZSBwcmlzb24gY2VsbCBpcyBoZWxkLiAgVG8KKyAqIGVu
Y291cmFnZSB0aGlzLCB3ZSBhc2sgZm9yICdjZWxsJyB0byBiZSBwYXNzZWQgaW4uCisgKi8KK3N0
YXRpYyB2b2lkIGluY19kcyhzdHJ1Y3QgY2FjaGUgKmNhY2hlLCBzdHJ1Y3QgYmlvICpiaW8sCisJ
CSAgIHN0cnVjdCBkbV9iaW9fcHJpc29uX2NlbGwgKmNlbGwpCit7CisJc2l6ZV90IHBiX2RhdGFf
c2l6ZSA9IGdldF9wZXJfYmlvX2RhdGFfc2l6ZShjYWNoZSk7CisJc3RydWN0IHBlcl9iaW9fZGF0
YSAqcGIgPSBnZXRfcGVyX2Jpb19kYXRhKGJpbywgcGJfZGF0YV9zaXplKTsKKworCUJVR19PTigh
Y2VsbCk7CisJQlVHX09OKHBiLT5hbGxfaW9fZW50cnkpOworCisJcGItPmFsbF9pb19lbnRyeSA9
IGRtX2RlZmVycmVkX2VudHJ5X2luYyhjYWNoZS0+YWxsX2lvX2RzKTsKK30KKwogc3RhdGljIHZv
aWQgaXNzdWUoc3RydWN0IGNhY2hlICpjYWNoZSwgc3RydWN0IGJpbyAqYmlvKQogewogCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7CkBAIC03MzcsNiArNzUzLDEyIEBAIHN0YXRpYyB2b2lkIGlzc3VlKHN0
cnVjdCBjYWNoZSAqY2FjaGUsIHN0cnVjdCBiaW8gKmJpbykKIAlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZjYWNoZS0+bG9jaywgZmxhZ3MpOwogfQogCitzdGF0aWMgdm9pZCBpbmNfYW5kX2lzc3Vl
KHN0cnVjdCBjYWNoZSAqY2FjaGUsIHN0cnVjdCBiaW8gKmJpbywgc3RydWN0IGRtX2Jpb19wcmlz
b25fY2VsbCAqY2VsbCkKK3sKKwlpbmNfZHMoY2FjaGUsIGJpbywgY2VsbCk7CisJaXNzdWUoY2Fj
aGUsIGJpbyk7Cit9CisKIHN0YXRpYyB2b2lkIGRlZmVyX3dyaXRldGhyb3VnaF9iaW8oc3RydWN0
IGNhY2hlICpjYWNoZSwgc3RydWN0IGJpbyAqYmlvKQogewogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7
CkBAIC0xMDE1LDYgKzEwMzcsMTEgQEAgc3RhdGljIHZvaWQgaXNzdWVfb3ZlcndyaXRlKHN0cnVj
dCBkbV9jYWNoZV9taWdyYXRpb24gKm1nLCBzdHJ1Y3QgYmlvICpiaW8pCiAKIAlkbV9ob29rX2Jp
bygmcGItPmhvb2tfaW5mbywgYmlvLCBvdmVyd3JpdGVfZW5kaW8sIG1nKTsKIAlyZW1hcF90b19j
YWNoZV9kaXJ0eShtZy0+Y2FjaGUsIGJpbywgbWctPm5ld19vYmxvY2ssIG1nLT5jYmxvY2spOwor
CisJLyoKKwkgKiBObyBuZWVkIHRvIGluY19kcygpIGhlcmUsIHNpbmNlIHRoZSBjZWxsIHdpbGwg
YmUgaGVsZCBmb3IgdGhlCisJICogZHVyYXRpb24gb2YgdGhlIGlvLgorCSAqLwogCWdlbmVyaWNf
bWFrZV9yZXF1ZXN0KGJpbyk7CiB9CiAKQEAgLTExMTUsOCArMTE0Miw3IEBAIHN0YXRpYyB2b2lk
IGNoZWNrX2Zvcl9xdWllc2NlZF9taWdyYXRpb25zKHN0cnVjdCBjYWNoZSAqY2FjaGUsCiAJCXJl
dHVybjsKIAogCUlOSVRfTElTVF9IRUFEKCZ3b3JrKTsKLQlpZiAocGItPmFsbF9pb19lbnRyeSkK
LQkJZG1fZGVmZXJyZWRfZW50cnlfZGVjKHBiLT5hbGxfaW9fZW50cnksICZ3b3JrKTsKKwlkbV9k
ZWZlcnJlZF9lbnRyeV9kZWMocGItPmFsbF9pb19lbnRyeSwgJndvcmspOwogCiAJaWYgKCFsaXN0
X2VtcHR5KCZ3b3JrKSkKIAkJcXVldWVfcXVpZXNjZWRfbWlncmF0aW9ucyhjYWNoZSwgJndvcmsp
OwpAQCAtMTI1Miw2ICsxMjc4LDExIEBAIHN0YXRpYyB2b2lkIHByb2Nlc3NfZmx1c2hfYmlvKHN0
cnVjdCBjYWNoZSAqY2FjaGUsIHN0cnVjdCBiaW8gKmJpbykKIAllbHNlCiAJCXJlbWFwX3RvX2Nh
Y2hlKGNhY2hlLCBiaW8sIDApOwogCisJLyoKKwkgKiBSRVFfRkxVU0ggaXMgbm90IGRpcmVjdGVk
IGF0IGFueSBwYXJ0aWN1bGFyIGJsb2NrIHNvIHdlIGRvbid0CisJICogbmVlZCB0byBpbmNfZHMo
KS4gIFJFUV9GVUEncyBhcmUgc3BsaXQgaW50byBhIHdyaXRlICsgUkVRX0ZMVVNICisJICogYnkg
ZG0tY29yZS4KKwkgKi8KIAlpc3N1ZShjYWNoZSwgYmlvKTsKIH0KIApAQCAtMTMwMSwxNSArMTMz
Miw2IEBAIHN0YXRpYyB2b2lkIGluY19taXNzX2NvdW50ZXIoc3RydWN0IGNhY2hlICpjYWNoZSwg
c3RydWN0IGJpbyAqYmlvKQogCQkgICAmY2FjaGUtPnN0YXRzLnJlYWRfbWlzcyA6ICZjYWNoZS0+
c3RhdHMud3JpdGVfbWlzcyk7CiB9CiAKLXN0YXRpYyB2b2lkIGlzc3VlX2NhY2hlX2JpbyhzdHJ1
Y3QgY2FjaGUgKmNhY2hlLCBzdHJ1Y3QgYmlvICpiaW8sCi0JCQkgICAgc3RydWN0IHBlcl9iaW9f
ZGF0YSAqcGIsCi0JCQkgICAgZG1fb2Jsb2NrX3Qgb2Jsb2NrLCBkbV9jYmxvY2tfdCBjYmxvY2sp
Ci17Ci0JcGItPmFsbF9pb19lbnRyeSA9IGRtX2RlZmVycmVkX2VudHJ5X2luYyhjYWNoZS0+YWxs
X2lvX2RzKTsKLQlyZW1hcF90b19jYWNoZV9kaXJ0eShjYWNoZSwgYmlvLCBvYmxvY2ssIGNibG9j
ayk7Ci0JaXNzdWUoY2FjaGUsIGJpbyk7Ci19Ci0KIHN0YXRpYyB2b2lkIHByb2Nlc3NfYmlvKHN0
cnVjdCBjYWNoZSAqY2FjaGUsIHN0cnVjdCBwcmVhbGxvYyAqc3RydWN0cywKIAkJCXN0cnVjdCBi
aW8gKmJpbykKIHsKQEAgLTEzMTgsOCArMTM0MCw2IEBAIHN0YXRpYyB2b2lkIHByb2Nlc3NfYmlv
KHN0cnVjdCBjYWNoZSAqY2FjaGUsIHN0cnVjdCBwcmVhbGxvYyAqc3RydWN0cywKIAlkbV9vYmxv
Y2tfdCBibG9jayA9IGdldF9iaW9fYmxvY2soY2FjaGUsIGJpbyk7CiAJc3RydWN0IGRtX2Jpb19w
cmlzb25fY2VsbCAqY2VsbF9wcmVhbGxvYywgKm9sZF9vY2VsbCwgKm5ld19vY2VsbDsKIAlzdHJ1
Y3QgcG9saWN5X3Jlc3VsdCBsb29rdXBfcmVzdWx0OwotCXNpemVfdCBwYl9kYXRhX3NpemUgPSBn
ZXRfcGVyX2Jpb19kYXRhX3NpemUoY2FjaGUpOwotCXN0cnVjdCBwZXJfYmlvX2RhdGEgKnBiID0g
Z2V0X3Blcl9iaW9fZGF0YShiaW8sIHBiX2RhdGFfc2l6ZSk7CiAJYm9vbCBkaXNjYXJkZWRfYmxv
Y2sgPSBpc19kaXNjYXJkZWRfb2Jsb2NrKGNhY2hlLCBibG9jayk7CiAJYm9vbCBwYXNzdGhyb3Vn
aCA9IHBhc3N0aHJvdWdoX21vZGUoJmNhY2hlLT5mZWF0dXJlcyk7CiAJYm9vbCBjYW5fbWlncmF0
ZSA9ICFwYXNzdGhyb3VnaCAmJiAoZGlzY2FyZGVkX2Jsb2NrIHx8IHNwYXJlX21pZ3JhdGlvbl9i
YW5kd2lkdGgoY2FjaGUpKTsKQEAgLTEzNTksOSArMTM3OSw4IEBAIHN0YXRpYyB2b2lkIHByb2Nl
c3NfYmlvKHN0cnVjdCBjYWNoZSAqY2FjaGUsIHN0cnVjdCBwcmVhbGxvYyAqc3RydWN0cywKIAog
CQkJfSBlbHNlIHsKIAkJCQkvKiBGSVhNRTogZmFjdG9yIG91dCBpc3N1ZV9vcmlnaW4oKSAqLwot
CQkJCXBiLT5hbGxfaW9fZW50cnkgPSBkbV9kZWZlcnJlZF9lbnRyeV9pbmMoY2FjaGUtPmFsbF9p
b19kcyk7CiAJCQkJcmVtYXBfdG9fb3JpZ2luX2NsZWFyX2Rpc2NhcmQoY2FjaGUsIGJpbywgYmxv
Y2spOwotCQkJCWlzc3VlKGNhY2hlLCBiaW8pOworCQkJCWluY19hbmRfaXNzdWUoY2FjaGUsIGJp
bywgbmV3X29jZWxsKTsKIAkJCX0KIAkJfSBlbHNlIHsKIAkJCWluY19oaXRfY291bnRlcihjYWNo
ZSwgYmlvKTsKQEAgLTEzNjksMjAgKzEzODgsMjEgQEAgc3RhdGljIHZvaWQgcHJvY2Vzc19iaW8o
c3RydWN0IGNhY2hlICpjYWNoZSwgc3RydWN0IHByZWFsbG9jICpzdHJ1Y3RzLAogCQkJaWYgKGJp
b19kYXRhX2RpcihiaW8pID09IFdSSVRFICYmCiAJCQkgICAgd3JpdGV0aHJvdWdoX21vZGUoJmNh
Y2hlLT5mZWF0dXJlcykgJiYKIAkJCSAgICAhaXNfZGlydHkoY2FjaGUsIGxvb2t1cF9yZXN1bHQu
Y2Jsb2NrKSkgewotCQkJCXBiLT5hbGxfaW9fZW50cnkgPSBkbV9kZWZlcnJlZF9lbnRyeV9pbmMo
Y2FjaGUtPmFsbF9pb19kcyk7CiAJCQkJcmVtYXBfdG9fb3JpZ2luX3RoZW5fY2FjaGUoY2FjaGUs
IGJpbywgYmxvY2ssIGxvb2t1cF9yZXN1bHQuY2Jsb2NrKTsKLQkJCQlpc3N1ZShjYWNoZSwgYmlv
KTsKLQkJCX0gZWxzZQotCQkJCWlzc3VlX2NhY2hlX2JpbyhjYWNoZSwgYmlvLCBwYiwgYmxvY2ss
IGxvb2t1cF9yZXN1bHQuY2Jsb2NrKTsKKwkJCQlpbmNfYW5kX2lzc3VlKGNhY2hlLCBiaW8sIG5l
d19vY2VsbCk7CisKKwkJCX0gZWxzZSAgeworCQkJCXJlbWFwX3RvX2NhY2hlX2RpcnR5KGNhY2hl
LCBiaW8sIGJsb2NrLCBsb29rdXBfcmVzdWx0LmNibG9jayk7CisJCQkJaW5jX2FuZF9pc3N1ZShj
YWNoZSwgYmlvLCBuZXdfb2NlbGwpOworCQkJfQogCQl9CiAKIAkJYnJlYWs7CiAKIAljYXNlIFBP
TElDWV9NSVNTOgogCQlpbmNfbWlzc19jb3VudGVyKGNhY2hlLCBiaW8pOwotCQlwYi0+YWxsX2lv
X2VudHJ5ID0gZG1fZGVmZXJyZWRfZW50cnlfaW5jKGNhY2hlLT5hbGxfaW9fZHMpOwogCQlyZW1h
cF90b19vcmlnaW5fY2xlYXJfZGlzY2FyZChjYWNoZSwgYmlvLCBibG9jayk7Ci0JCWlzc3VlKGNh
Y2hlLCBiaW8pOworCQlpbmNfYW5kX2lzc3VlKGNhY2hlLCBiaW8sIG5ld19vY2VsbCk7CiAJCWJy
ZWFrOwogCiAJY2FzZSBQT0xJQ1lfTkVXOgpAQCAtMTUwMSw2ICsxNTIxLDkgQEAgc3RhdGljIHZv
aWQgcHJvY2Vzc19kZWZlcnJlZF9mbHVzaF9iaW9zKHN0cnVjdCBjYWNoZSAqY2FjaGUsIGJvb2wg
c3VibWl0X2Jpb3MpCiAJYmlvX2xpc3RfaW5pdCgmY2FjaGUtPmRlZmVycmVkX2ZsdXNoX2Jpb3Mp
OwogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNhY2hlLT5sb2NrLCBmbGFncyk7CiAKKwkvKgor
CSAqIFRoZXNlIGJpb3MgaGF2ZSBhbHJlYWR5IGJlZW4gdGhyb3VnaCBpbmNfZHMoKQorCSAqLwog
CXdoaWxlICgoYmlvID0gYmlvX2xpc3RfcG9wKCZiaW9zKSkpCiAJCXN1Ym1pdF9iaW9zID8gZ2Vu
ZXJpY19tYWtlX3JlcXVlc3QoYmlvKSA6IGJpb19pb19lcnJvcihiaW8pOwogfQpAQCAtMTUxOCw2
ICsxNTQxLDkgQEAgc3RhdGljIHZvaWQgcHJvY2Vzc19kZWZlcnJlZF93cml0ZXRocm91Z2hfYmlv
cyhzdHJ1Y3QgY2FjaGUgKmNhY2hlKQogCWJpb19saXN0X2luaXQoJmNhY2hlLT5kZWZlcnJlZF93
cml0ZXRocm91Z2hfYmlvcyk7CiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY2FjaGUtPmxvY2ss
IGZsYWdzKTsKIAorCS8qCisJICogVGhlc2UgYmlvcyBoYXZlIGFscmVhZHkgYmVlbiB0aHJvdWdo
IGluY19kcygpCisJICovCiAJd2hpbGUgKChiaW8gPSBiaW9fbGlzdF9wb3AoJmJpb3MpKSkKIAkJ
Z2VuZXJpY19tYWtlX3JlcXVlc3QoYmlvKTsKIH0KQEAgLTI0MDYsMTYgKzI0MzIsMTMgQEAgb3V0
OgogCXJldHVybiByOwogfQogCi1zdGF0aWMgaW50IGNhY2hlX21hcChzdHJ1Y3QgZG1fdGFyZ2V0
ICp0aSwgc3RydWN0IGJpbyAqYmlvKQorc3RhdGljIGludCBfX2NhY2hlX21hcChzdHJ1Y3QgY2Fj
aGUgKmNhY2hlLCBzdHJ1Y3QgYmlvICpiaW8sIHN0cnVjdCBkbV9iaW9fcHJpc29uX2NlbGwgKipj
ZWxsKQogewotCXN0cnVjdCBjYWNoZSAqY2FjaGUgPSB0aS0+cHJpdmF0ZTsKLQogCWludCByOwog
CWRtX29ibG9ja190IGJsb2NrID0gZ2V0X2Jpb19ibG9jayhjYWNoZSwgYmlvKTsKIAlzaXplX3Qg
cGJfZGF0YV9zaXplID0gZ2V0X3Blcl9iaW9fZGF0YV9zaXplKGNhY2hlKTsKIAlib29sIGNhbl9t
aWdyYXRlID0gZmFsc2U7CiAJYm9vbCBkaXNjYXJkZWRfYmxvY2s7Ci0Jc3RydWN0IGRtX2Jpb19w
cmlzb25fY2VsbCAqY2VsbDsKIAlzdHJ1Y3QgcG9saWN5X3Jlc3VsdCBsb29rdXBfcmVzdWx0Owog
CXN0cnVjdCBwZXJfYmlvX2RhdGEgKnBiID0gaW5pdF9wZXJfYmlvX2RhdGEoYmlvLCBwYl9kYXRh
X3NpemUpOwogCkBAIC0yNDM3LDE1ICsyNDYwLDE1IEBAIHN0YXRpYyBpbnQgY2FjaGVfbWFwKHN0
cnVjdCBkbV90YXJnZXQgKnRpLCBzdHJ1Y3QgYmlvICpiaW8pCiAJLyoKIAkgKiBDaGVjayB0byBz
ZWUgaWYgdGhhdCBibG9jayBpcyBjdXJyZW50bHkgbWlncmF0aW5nLgogCSAqLwotCWNlbGwgPSBh
bGxvY19wcmlzb25fY2VsbChjYWNoZSk7Ci0JaWYgKCFjZWxsKSB7CisJKmNlbGwgPSBhbGxvY19w
cmlzb25fY2VsbChjYWNoZSk7CisJaWYgKCEqY2VsbCkgewogCQlkZWZlcl9iaW8oY2FjaGUsIGJp
byk7CiAJCXJldHVybiBETV9NQVBJT19TVUJNSVRURUQ7CiAJfQogCi0JciA9IGJpb19kZXRhaW4o
Y2FjaGUsIGJsb2NrLCBiaW8sIGNlbGwsCisJciA9IGJpb19kZXRhaW4oY2FjaGUsIGJsb2NrLCBi
aW8sICpjZWxsLAogCQkgICAgICAgKGNlbGxfZnJlZV9mbikgZnJlZV9wcmlzb25fY2VsbCwKLQkJ
ICAgICAgIGNhY2hlLCAmY2VsbCk7CisJCSAgICAgICBjYWNoZSwgY2VsbCk7CiAJaWYgKHIpIHsK
IAkJaWYgKHIgPCAwKQogCQkJZGVmZXJfYmlvKGNhY2hlLCBiaW8pOwpAQCAtMjQ1OCwxMSArMjQ4
MSwxMiBAQCBzdGF0aWMgaW50IGNhY2hlX21hcChzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0
IGJpbyAqYmlvKQogCXIgPSBwb2xpY3lfbWFwKGNhY2hlLT5wb2xpY3ksIGJsb2NrLCBmYWxzZSwg
Y2FuX21pZ3JhdGUsIGRpc2NhcmRlZF9ibG9jaywKIAkJICAgICAgIGJpbywgJmxvb2t1cF9yZXN1
bHQpOwogCWlmIChyID09IC1FV09VTERCTE9DSykgewotCQljZWxsX2RlZmVyKGNhY2hlLCBjZWxs
LCB0cnVlKTsKKwkJY2VsbF9kZWZlcihjYWNoZSwgKmNlbGwsIHRydWUpOwogCQlyZXR1cm4gRE1f
TUFQSU9fU1VCTUlUVEVEOwogCiAJfSBlbHNlIGlmIChyKSB7CiAJCURNRVJSX0xJTUlUKCJVbmV4
cGVjdGVkIHJldHVybiBmcm9tIGNhY2hlIHJlcGxhY2VtZW50IHBvbGljeTogJWQiLCByKTsKKwkJ
Y2VsbF9kZWZlcihjYWNoZSwgKmNlbGwsIGZhbHNlKTsKIAkJYmlvX2lvX2Vycm9yKGJpbyk7CiAJ
CXJldHVybiBETV9NQVBJT19TVUJNSVRURUQ7CiAJfQpAQCAtMjQ3Niw1MiArMjUwMCw0NCBAQCBz
dGF0aWMgaW50IGNhY2hlX21hcChzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0IGJpbyAqYmlv
KQogCQkJCSAqIFdlIG5lZWQgdG8gaW52YWxpZGF0ZSB0aGlzIGJsb2NrLCBzbwogCQkJCSAqIGRl
ZmVyIGZvciB0aGUgd29ya2VyIHRocmVhZC4KIAkJCQkgKi8KLQkJCQljZWxsX2RlZmVyKGNhY2hl
LCBjZWxsLCB0cnVlKTsKKwkJCQljZWxsX2RlZmVyKGNhY2hlLCAqY2VsbCwgdHJ1ZSk7CiAJCQkJ
ciA9IERNX01BUElPX1NVQk1JVFRFRDsKIAogCQkJfSBlbHNlIHsKLQkJCQlwYi0+YWxsX2lvX2Vu
dHJ5ID0gZG1fZGVmZXJyZWRfZW50cnlfaW5jKGNhY2hlLT5hbGxfaW9fZHMpOwogCQkJCWluY19t
aXNzX2NvdW50ZXIoY2FjaGUsIGJpbyk7CiAJCQkJcmVtYXBfdG9fb3JpZ2luX2NsZWFyX2Rpc2Nh
cmQoY2FjaGUsIGJpbywgYmxvY2spOwotCi0JCQkJY2VsbF9kZWZlcihjYWNoZSwgY2VsbCwgZmFs
c2UpOwogCQkJfQogCiAJCX0gZWxzZSB7CiAJCQlpbmNfaGl0X2NvdW50ZXIoY2FjaGUsIGJpbyk7
Ci0JCQlwYi0+YWxsX2lvX2VudHJ5ID0gZG1fZGVmZXJyZWRfZW50cnlfaW5jKGNhY2hlLT5hbGxf
aW9fZHMpOwotCiAJCQlpZiAoYmlvX2RhdGFfZGlyKGJpbykgPT0gV1JJVEUgJiYgd3JpdGV0aHJv
dWdoX21vZGUoJmNhY2hlLT5mZWF0dXJlcykgJiYKIAkJCSAgICAhaXNfZGlydHkoY2FjaGUsIGxv
b2t1cF9yZXN1bHQuY2Jsb2NrKSkKIAkJCQlyZW1hcF90b19vcmlnaW5fdGhlbl9jYWNoZShjYWNo
ZSwgYmlvLCBibG9jaywgbG9va3VwX3Jlc3VsdC5jYmxvY2spOwogCQkJZWxzZQogCQkJCXJlbWFw
X3RvX2NhY2hlX2RpcnR5KGNhY2hlLCBiaW8sIGJsb2NrLCBsb29rdXBfcmVzdWx0LmNibG9jayk7
Ci0KLQkJCWNlbGxfZGVmZXIoY2FjaGUsIGNlbGwsIGZhbHNlKTsKIAkJfQogCQlicmVhazsKIAog
CWNhc2UgUE9MSUNZX01JU1M6CiAJCWluY19taXNzX2NvdW50ZXIoY2FjaGUsIGJpbyk7Ci0JCXBi
LT5hbGxfaW9fZW50cnkgPSBkbV9kZWZlcnJlZF9lbnRyeV9pbmMoY2FjaGUtPmFsbF9pb19kcyk7
Ci0KIAkJaWYgKHBiLT5yZXFfbnIgIT0gMCkgewogCQkJLyoKIAkJCSAqIFRoaXMgaXMgYSBkdXBs
aWNhdGUgd3JpdGV0aHJvdWdoIGlvIHRoYXQgaXMgbm8KIAkJCSAqIGxvbmdlciBuZWVkZWQgYmVj
YXVzZSB0aGUgYmxvY2sgaGFzIGJlZW4gZGVtb3RlZC4KIAkJCSAqLwogCQkJYmlvX2VuZGlvKGJp
bywgMCk7Ci0JCQljZWxsX2RlZmVyKGNhY2hlLCBjZWxsLCBmYWxzZSk7Ci0JCQlyZXR1cm4gRE1f
TUFQSU9fU1VCTUlUVEVEOwotCQl9IGVsc2UgeworCQkJY2VsbF9kZWZlcihjYWNoZSwgKmNlbGws
IGZhbHNlKTsKKwkJCXIgPSBETV9NQVBJT19TVUJNSVRURUQ7CisKKwkJfSBlbHNlCiAJCQlyZW1h
cF90b19vcmlnaW5fY2xlYXJfZGlzY2FyZChjYWNoZSwgYmlvLCBibG9jayk7Ci0JCQljZWxsX2Rl
ZmVyKGNhY2hlLCBjZWxsLCBmYWxzZSk7Ci0JCX0KKwogCQlicmVhazsKIAogCWRlZmF1bHQ6CiAJ
CURNRVJSX0xJTUlUKCIlczogZXJyb3JpbmcgYmlvOiB1bmtub3duIHBvbGljeSBvcDogJXUiLCBf
X2Z1bmNfXywKIAkJCSAgICAodW5zaWduZWQpIGxvb2t1cF9yZXN1bHQub3ApOworCQljZWxsX2Rl
ZmVyKGNhY2hlLCAqY2VsbCwgZmFsc2UpOwogCQliaW9faW9fZXJyb3IoYmlvKTsKIAkJciA9IERN
X01BUElPX1NVQk1JVFRFRDsKIAl9CkBAIC0yNTI5LDYgKzI1NDUsMjEgQEAgc3RhdGljIGludCBj
YWNoZV9tYXAoc3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVjdCBiaW8gKmJpbykKIAlyZXR1cm4g
cjsKIH0KIAorc3RhdGljIGludCBjYWNoZV9tYXAoc3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVj
dCBiaW8gKmJpbykKK3sKKwlpbnQgcjsKKwlzdHJ1Y3QgZG1fYmlvX3ByaXNvbl9jZWxsICpjZWxs
OworCXN0cnVjdCBjYWNoZSAqY2FjaGUgPSB0aS0+cHJpdmF0ZTsKKworCXIgPSBfX2NhY2hlX21h
cChjYWNoZSwgYmlvLCAmY2VsbCk7CisJaWYgKHIgPT0gRE1fTUFQSU9fUkVNQVBQRUQpIHsKKwkJ
aW5jX2RzKGNhY2hlLCBiaW8sIGNlbGwpOworCQljZWxsX2RlZmVyKGNhY2hlLCBjZWxsLCBmYWxz
ZSk7CisJfQorCisJcmV0dXJuIHI7Cit9CisKIHN0YXRpYyBpbnQgY2FjaGVfZW5kX2lvKHN0cnVj
dCBkbV90YXJnZXQgKnRpLCBzdHJ1Y3QgYmlvICpiaW8sIGludCBlcnJvcikKIHsKIAlzdHJ1Y3Qg
Y2FjaGUgKmNhY2hlID0gdGktPnByaXZhdGU7CkBAIC0zMDcyLDcgKzMxMDMsNyBAQCBzdGF0aWMg
dm9pZCBjYWNoZV9pb19oaW50cyhzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0IHF1ZXVlX2xp
bWl0cyAqbGltaXRzKQogCiBzdGF0aWMgc3RydWN0IHRhcmdldF90eXBlIGNhY2hlX3RhcmdldCA9
IHsKIAkubmFtZSA9ICJjYWNoZSIsCi0JLnZlcnNpb24gPSB7MSwgNCwgMH0sCisJLnZlcnNpb24g
PSB7MSwgNSwgMH0sCiAJLm1vZHVsZSA9IFRISVNfTU9EVUxFLAogCS5jdHIgPSBjYWNoZV9jdHIs
CiAJLmR0ciA9IGNhY2hlX2R0ciwK
--047d7b3a8b0ad76df105083d0cb0
Content-Type: application/octet-stream; name=bisectlog
Content-Disposition: attachment; filename=bisectlog
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2p7mmgo0

Z2l0IGJpc2VjdCBzdGFydAojIGJhZDogW2ZjMTRmOWMxMjcyZjYyYzNlOGQwMTMwMGY1MjQ2N2Mw
ZDlhZjUwZjldIExpbnV4IDMuMTgtcmM1CmdpdCBiaXNlY3QgYmFkIGZjMTRmOWMxMjcyZjYyYzNl
OGQwMTMwMGY1MjQ2N2MwZDlhZjUwZjkKIyBnb29kOiBbZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1
NmU4ODE0MjEwZjBlNjRiZV0gTGludXggMy4xMwpnaXQgYmlzZWN0IGdvb2QgZDhlYzI2ZDdmODI4
N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQojIGdvb2Q6IFswN2VjZjE2Mjk3YmJlYzhkOTQw
MTJmMmRkOWQ2MTVmOTgwOTNmYmJlXSBMaW51eCAzLjEzLjEKZ2l0IGJpc2VjdCBnb29kIDA3ZWNm
MTYyOTdiYmVjOGQ5NDAxMmYyZGQ5ZDYxNWY5ODA5M2ZiYmUKIyBnb29kOiBbZDhlYzI2ZDdmODI4
N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZV0gTGludXggMy4xMwpnaXQgYmlzZWN0IGdvb2Qg
ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQojIGdvb2Q6IFtiNzcyNzli
YzJlODE1NDViMjA4MjRkYTcwMWIzNDkyNzJhNzhlNGU3XSBNZXJnZSB0YWcgJ3NvdW5kLTMuMTYt
cmMxJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGl3
YWkvc291bmQgaW50byBuZXh0CmdpdCBiaXNlY3QgZ29vZCBiNzcyNzliYzJlODE1NDViMjA4MjRk
YTcwMWIzNDkyNzJhNzhlNGU3CiMgZ29vZDogW2E3ZDdhMTQzZDBiNGNiMTkxNDcwNTg4NGNhNWMy
NWUzMjJkYmE2OTNdIE1lcmdlIGJyYW5jaCAnZHJtLW5leHQnIG9mIGdpdDovL3Blb3BsZS5mcmVl
ZGVza3RvcC5vcmcvfmFpcmxpZWQvbGludXgKZ2l0IGJpc2VjdCBnb29kIGE3ZDdhMTQzZDBiNGNi
MTkxNDcwNTg4NGNhNWMyNWUzMjJkYmE2OTMKIyBiYWQ6IFtlYjc4NWJlZjY4NGYyYjdkMDNiNTMw
ZWZjOGU2ZjE5OWU5Nzc3ZTJmXSBNZXJnZSB0YWcgJ2R0LWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2FybS9hcm0tc29jCmdpdCBiaXNl
Y3QgYmFkIGViNzg1YmVmNjg0ZjJiN2QwM2I1MzBlZmM4ZTZmMTk5ZTk3NzdlMmYKIyBiYWQ6IFti
MjI2OTlkNjczNGQ2NmE2ODgxNmE5NWYyNjI4YjI3ODQwZGE5ZGFkXSBzdGFnaW5nOiBjb21lZGk6
IGFkbF9wY2k5MTE4OiByZW1vdmUgJ2FvX21heGRhdGEnIGJvYXJkaW5mbwpnaXQgYmlzZWN0IGJh
ZCBiMjI2OTlkNjczNGQ2NmE2ODgxNmE5NWYyNjI4YjI3ODQwZGE5ZGFkCiMgZ29vZDogW2RjMWNj
ODUxMzMxMjBlNDljMjIzZjM2YWE3N2QzOThiOGFiYWM3MjddIE1lcmdlIHRhZyAneGZzLWZvci1s
aW51cy0zLjE3LXJjMScgb2YgZ2l0Oi8vb3NzLnNnaS5jb20veGZzL3hmcwpnaXQgYmlzZWN0IGdv
b2QgZGMxY2M4NTEzMzEyMGU0OWMyMjNmMzZhYTc3ZDM5OGI4YWJhYzcyNwojIGJhZDogWzM5YmRj
OTU4NzFiNTc4MjhiM2JiZWZjMDI4MGExYTgwYTZiNjNkOWVdIE1lcmdlIHRhZyAnaWlvLWZvci0z
LjE4YScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2pp
YzIzL2lpbyBpbnRvIHdvcmstbmV4dApnaXQgYmlzZWN0IGJhZCAzOWJkYzk1ODcxYjU3ODI4YjNi
YmVmYzAyODBhMWE4MGE2YjYzZDllCiMgYmFkOiBbMDY4MGViMWY0ODViYTVhYWMyZWUwMmM5ZjA2
MjIyMzljOWE0YjE2Y10gdGltZWtlZXBpbmc6IEFub3RoZXIgZml4IHRvIHRoZSBWU1lTQ0FMTF9P
TEQgdXBkYXRlX3ZzeXNjYWxsCmdpdCBiaXNlY3QgYmFkIDA2ODBlYjFmNDg1YmE1YWFjMmVlMDJj
OWYwNjIyMjM5YzlhNGIxNmMKIyBnb29kOiBbNGEzMTlhNDkwY2E1OWE3NDZiM2QzNjc2OGMwZTI5
ZWUxOTgzMjM2Nl0gTWVyZ2UgYnJhbmNoICdmb3ItMy4xNy9jb3JlJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLmRrL2xpbnV4LWJsb2NrCmdpdCBiaXNlY3QgZ29vZCA0YTMxOWE0OTBjYTU5YTc0NmIzZDM2
NzY4YzBlMjllZTE5ODMyMzY2CiMgZ29vZDogW2E4ZTRkZWY2MDRhOWFmZmEwNGZkZDRlZmEwNjky
ZGExMzg1ZmZhM2ZdIE1lcmdlIHRhZyAnbW1jLXYzLjE3LTEnIG9mIGdpdDovL2dpdC5saW5hcm8u
b3JnL3Blb3BsZS91bGYuaGFuc3Nvbi9tbWMKZ2l0IGJpc2VjdCBnb29kIGE4ZTRkZWY2MDRhOWFm
ZmEwNGZkZDRlZmEwNjkyZGExMzg1ZmZhM2YKIyBiYWQ6IFthZTM2ZTk1Y2Y4MWM5OGIxMTFiODQz
MTdhZGViMzU4YWFmZmE4MGUyXSBNZXJnZSB0YWcgJ2RldmljZXRyZWUtZm9yLWxpbnVzJyBvZiBn
aXQ6Ly9naXQuc2VjcmV0bGFiLmNhL2dpdC9saW51eApnaXQgYmlzZWN0IGJhZCBhZTM2ZTk1Y2Y4
MWM5OGIxMTFiODQzMTdhZGViMzU4YWFmZmE4MGUyCiMgYmFkOiBbY2M4YTQ0YzY3MWZkM2EyYzc5
MmU5ZTFmNTllYTFkZjUyNjk3Y2M4Yl0gTWVyZ2UgdGFnICd2ZmlvLXYzLjE3LXJjMScgb2YgZ2l0
Oi8vZ2l0aHViLmNvbS9hd2lsbGlhbS9saW51eC12ZmlvCmdpdCBiaXNlY3QgYmFkIGNjOGE0NGM2
NzFmZDNhMmM3OTJlOWUxZjU5ZWExZGY1MjY5N2NjOGIKIyBiYWQ6IFs5OWViMTkwOGU2NDM2MDll
ODM0NTRjNmZiY2JiNTlmOTA1NWFiZjA5XSBkbSBzd2l0Y2g6IGZhY3RvciBvdXQgc3dpdGNoX3Jl
Z2lvbl90YWJsZV9yZWFkCmdpdCBiaXNlY3QgYmFkIDk5ZWIxOTA4ZTY0MzYwOWU4MzQ1NGM2ZmJj
YmI1OWY5MDU1YWJmMDkKIyBiYWQ6IFszMDRhZmZhYTg4MzI4ZmU4ZjQwZmYxNGY1ZTZjY2JmYWQ4
ZjEyMWViXSBkbSBjYWNoZTogZmFpbCBtaWdyYXRpb25zIGluIHRoZSBkb193b3JrZXIgZXJyb3Ig
cGF0aApnaXQgYmlzZWN0IGJhZCAzMDRhZmZhYTg4MzI4ZmU4ZjQwZmYxNGY1ZTZjY2JmYWQ4ZjEy
MWViCiMgZ29vZDogWzUwZjNjM2VmZGQ1NzczZDkwMzk2YmUwN2E3ZWNhYTU4MjI3ZmY5MDZdIGRt
IHRoaW46IHN3aXRjaCB0byBhbiBhdG9taWNfdCBmb3IgdHJhY2tpbmcgcGVuZGluZyBuZXcgYmxv
Y2sgcHJlcGFyYXRpb25zCmdpdCBiaXNlY3QgZ29vZCA1MGYzYzNlZmRkNTc3M2Q5MDM5NmJlMDdh
N2VjYWE1ODIyN2ZmOTA2CiMgYmFkOiBbOGMwODFiNTJjNjgzM2EzMGE2OWVhM2JkY2VmMzE2ZWNj
Yzc0MGM4N10gZG0gY2FjaGU6IHNpbXBsaWZ5IGRlZmVycmVkIHNldCByZWZlcmVuY2UgY291bnQg
aW5jcmVtZW50cwpnaXQgYmlzZWN0IGJhZCA4YzA4MWI1MmM2ODMzYTMwYTY5ZWEzYmRjZWYzMTZl
Y2NjNzQwYzg3CiMgZ29vZDogW2U1YWVhN2I0OWYyYjFmZDAxZjM1Y2E3YWJlYjc2ZjVjNTYxMjhh
NTVdIGRtIHRoaW46IHJlbGF4IGV4dGVybmFsIG9yaWdpbiBzaXplIGNvbnN0cmFpbnRzCmdpdCBi
aXNlY3QgZ29vZCBlNWFlYTdiNDlmMmIxZmQwMWYzNWNhN2FiZWI3NmY1YzU2MTI4YTU1CiMgZmly
c3QgYmFkIGNvbW1pdDogWzhjMDgxYjUyYzY4MzNhMzBhNjllYTNiZGNlZjMxNmVjY2M3NDBjODdd
IGRtIGNhY2hlOiBzaW1wbGlmeSBkZWZlcnJlZCBzZXQgcmVmZXJlbmNlIGNvdW50IGluY3JlbWVu
dHMK
--047d7b3a8b0ad76df105083d0cb0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--047d7b3a8b0ad76df105083d0cb0--
