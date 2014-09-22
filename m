From: Romu <huruomu@gmail.com>
Subject: Re: RHEL6.6 dm-cache and dm-era
Date: Mon, 22 Sep 2014 20:35:21 +0800
Message-ID: <CANoG8sVhN92jy559m4oLEvRhHWypMWeeU1TFe24CALs_Bw7Qbw@mail.gmail.com>
References: <54164DC0.3020907@gmail.com>
	<FBF1ED45-5B3E-4D0C-90B5-9A51D6EAE8F7@redhat.com>
	<541A977D.7010108@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2210169307897841799=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <541A977D.7010108@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2210169307897841799==
Content-Type: multipart/alternative; boundary=047d7b10ce5129e4d20503a6af73

--047d7b10ce5129e4d20503a6af73
Content-Type: text/plain; charset=UTF-8

I tried the following command to set up my era target but the command
immediately panics the system and the system reboots.

# dmsetup create MyEra --table "0 41941903 era
/dev/mapper/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV 4096"

The metadata dev and the origin dev are all part of a LVM cache LV.
VG-CacheDataLV_cmeta is the cache metadata LV on the smaller and faster
device, VG-OriginLV is the origin LV on the faster and slower device,
41941903 is the total sector number of the device of OriginLV (the LV takes
100% space of the device), 4096 is the block size of OriginLV, I have run
'mkfs.ext4 /dev/mapper/VG-OriginLV' before running the dmsetup command.

Below is the message in /var/log/messages after running the dmsetup
comnmand:

kernel: device-mapper: era: sb_check failed: magic 1623043: wanted
2126579579
kernel: device-mapper: block manager: superblock validator check failed for
block 0
kernel: device-mapper: era: couldn't read_lock superblock


Any idea?

Thanks
Romu

2014-09-18 16:27 GMT+08:00 Romu Hu <huruomu@gmail.com>:

> On 2014/9/16 4:25, Brassow Jonathan wrote:
>
>> On Sep 14, 2014, at 9:24 PM, Romu Hu wrote:
>>
>>  Hi,
>>>
>>> According to https://access.redhat.com/documentation/en-US/Red_Hat_
>>> Enterprise_Linux/6-Beta/html-single/6.6_Release_Notes/
>>> index.html#bh-storage, dm-cache and dm-era have been added into RHEL6.6
>>> as technology preview, but I couldn't find any other documentation about
>>> using dm-cache and dm-era.  I found the following utilities in
>>>
>>> /usr/sbin/era_check
>>> /usr/sbin/era_dump
>>> /usr/sbin/era_invalidate
>>>
>>> /usr/sbin/cache_check
>>> /usr/sbin/cache_dump
>>> /usr/sbin/cache_repair
>>> /usr/sbin/cache_restore
>>>
>>> I guess these utilities are related to dm-era and dm-cache,
>>> respectively.  There are only manpages for the cache utilities. After
>>> reading the manpages I still have no clue how to use these technologies.  I
>>> want to do a sanity check of these technologies on my SAN storage.  Is it
>>> possible to try dm-cache and dm-era without a SSD?  e.g. using ram to
>>> imitate a fast block device..
>>>
>>> Any idea?
>>>
>> You can use cache to teir any block device over another.  Layering
>> faster, smaller drives over slower, larger ones is the point; but for
>> testing non-performance things you can still do it.  For the cache target,
>> it would be a more inclusive test to go through LVM.  The lvmcache.7 man
>> page would help out with that.  There is no dm-era support in LVM ATM.
>>
>>   brassow
>>
>
> Thanks, I have successfully set up LVM caching with dm-cache, works like a
> charm.  However, I still haven't any useful documentation about how to set
> dm-era.  Any idea?
>
> Thanks
> Romu
>

--047d7b10ce5129e4d20503a6af73
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I tried the following command to set up my era target but =
the command immediately panics the system and the system reboots.<div><br><=
/div><div># dmsetup create MyEra --table &quot;0 41941903=C2=A0era /dev/map=
per/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV 4096&quot;<br></div><div><=
br></div><div>The metadata dev and the origin dev are all part of a LVM cac=
he LV.=C2=A0 VG-CacheDataLV_cmeta is the=C2=A0cache metadata LV on the smal=
ler and faster device, VG-OriginLV is the origin LV on the faster and slowe=
r device, 41941903 is the total sector number of the device of OriginLV (th=
e LV takes 100% space of the device), 4096 is the block size of OriginLV, I=
 have run &#39;mkfs.ext4 /dev/mapper/VG-OriginLV&#39; before running the dm=
setup command.<br></div><div><br></div><div>Below is the message in /var/lo=
g/messages after running the dmsetup comnmand:</div><div><br></div><div>ker=
nel: device-mapper: era: sb_check failed: magic 1623043: wanted 2126579579<=
br></div><div><div>kernel: device-mapper: block manager: superblock validat=
or check failed for block 0</div><div>kernel: device-mapper: era: couldn&#3=
9;t read_lock superblock</div></div><div><br></div><div><br></div><div>Any =
idea?</div><div><br></div><div>Thanks</div><div>Romu</div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">2014-09-18 16:27 GMT+08:00 =
Romu Hu <span dir=3D"ltr">&lt;<a href=3D"mailto:huruomu@gmail.com" target=
=3D"_blank">huruomu@gmail.com</a>&gt;</span>:<br><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 2014/9/16 4:25, Brassow Jon=
athan wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On Sep 14, 2014, at 9:24 PM, Romu Hu wrote:<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi,<br>
<br>
According to <a href=3D"https://access.redhat.com/documentation/en-US/Red_H=
at_Enterprise_Linux/6-Beta/html-single/6.6_Release_Notes/index.html#bh-stor=
age" target=3D"_blank">https://access.redhat.com/<u></u>documentation/en-US=
/Red_Hat_<u></u>Enterprise_Linux/6-Beta/html-<u></u>single/6.6_Release_Note=
s/<u></u>index.html#bh-storage</a>, dm-cache and dm-era have been added int=
o RHEL6.6 as technology preview, but I couldn&#39;t find any other document=
ation about using dm-cache and dm-era.=C2=A0 I found the following utilitie=
s in<br>
<br>
/usr/sbin/era_check<br>
/usr/sbin/era_dump<br>
/usr/sbin/era_invalidate<br>
<br>
/usr/sbin/cache_check<br>
/usr/sbin/cache_dump<br>
/usr/sbin/cache_repair<br>
/usr/sbin/cache_restore<br>
<br>
I guess these utilities are related to dm-era and dm-cache, respectively.=
=C2=A0 There are only manpages for the cache utilities. After reading the m=
anpages I still have no clue how to use these technologies.=C2=A0 I want to=
 do a sanity check of these technologies on my SAN storage.=C2=A0 Is it pos=
sible to try dm-cache and dm-era without a SSD?=C2=A0 e.g. using ram to imi=
tate a fast block device..<br>
<br>
Any idea?<br>
</blockquote>
You can use cache to teir any block device over another.=C2=A0 Layering fas=
ter, smaller drives over slower, larger ones is the point; but for testing =
non-performance things you can still do it.=C2=A0 For the cache target, it =
would be a more inclusive test to go through LVM.=C2=A0 The lvmcache.7 man =
page would help out with that.=C2=A0 There is no dm-era support in LVM ATM.=
<br>
<br>
=C2=A0 brassow<br>
</blockquote>
<br></div></div>
Thanks, I have successfully set up LVM caching with dm-cache, works like a =
charm.=C2=A0 However, I still haven&#39;t any useful documentation about ho=
w to set dm-era.=C2=A0 Any idea?<br>
<br>
Thanks<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Romu<br>
</font></span></blockquote></div><br></div>

--047d7b10ce5129e4d20503a6af73--


--===============2210169307897841799==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2210169307897841799==--
