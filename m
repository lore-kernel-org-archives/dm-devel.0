From: Romu <huruomu@gmail.com>
Subject: Re: RHEL6.6 dm-cache and dm-era
Date: Thu, 25 Sep 2014 22:02:46 +0800
Message-ID: <CANoG8sWXjR5LmZvY2K1ebOr=kS+A=-EPveqh=XsqD0v6bWcc2g@mail.gmail.com>
References: <54164DC0.3020907@gmail.com>
	<FBF1ED45-5B3E-4D0C-90B5-9A51D6EAE8F7@redhat.com>
	<541A977D.7010108@gmail.com>
	<CANoG8sVhN92jy559m4oLEvRhHWypMWeeU1TFe24CALs_Bw7Qbw@mail.gmail.com>
	<6FC8490A-55CA-454E-83FE-061A33FDE8DE@redhat.com>
	<5423B1E0.4000400@gmail.com> <5423EC4B.5070904@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3079914831863331584=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5423EC4B.5070904@redhat.com>
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

--===============3079914831863331584==
Content-Type: multipart/alternative; boundary=bcaec518662e4ca05c0503e44160

--bcaec518662e4ca05c0503e44160
Content-Type: text/plain; charset=UTF-8

2014-09-25 18:19 GMT+08:00 Heinz Mauelshagen <heinzm@redhat.com>:

>  On 09/25/2014 08:10 AM, Romu Hu wrote:
>
> On 2014/9/24 12:10, Brassow Jonathan wrote:
>
> On Sep 22, 2014, at 7:35 AM, Romu wrote:
>
> I tried the following command to set up my era target but the command
> immediately panics the system and the system reboots.
>
>  # dmsetup create MyEra --table "0 41941903 era
> /dev/mapper/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV 4096"
>
>  The metadata dev and the origin dev are all part of a LVM cache LV.
> VG-CacheDataLV_cmeta is the cache metadata LV on the smaller and faster
> device, VG-OriginLV is the origin LV on the faster and slower device,
> 41941903 is the total sector number of the device of OriginLV (the LV takes
> 100% space of the device), 4096 is the block size of OriginLV, I have run
> 'mkfs.ext4 /dev/mapper/VG-OriginLV' before running the dmsetup command.
>
>  Below is the message in /var/log/messages after running the dmsetup
> comnmand:
>
>  kernel: device-mapper: era: sb_check failed: magic 1623043: wanted
> 2126579579
>  kernel: device-mapper: block manager: superblock validator check failed
> for block 0
> kernel: device-mapper: era: couldn't read_lock superblock
>
>
>  Any idea?
>
>
> Sorry, I haven't used dm-era yet.  However, it does appear that you are
> perhaps specifying the wrong devices when creating the era device?  Looks
> like you might be allowing the era target and the cache target to use the
> same metadata area at the same time - causing them to corrupt each other's
> metadata area?
>
>   brassow
>
>
> I think the dmsetup command to set up an era target should be something
> like this:
>
> # dmsetup create MyEra --table "0 sector_number era metadeta_dev
> origin_dev block_size"
>
> My questions:
>
> 1) How to calculate sector_number?  According to
> https://www.kernel.org/doc/Documentation/device-mapper/era.txt, I guess
> it should be (4 * nr_blocks) bytes + buffers, but what is nr_blocks and
> what is buffers?
>
>
> No calculation: it's the size of your era target in sectors. Typically
> "blockdev --getsz origin_dev"
>
>  2) Any documentation for dmsetup tables?
>
>
> Look for examples in the kernel source trees Documentaion/device.mapper.
>
> table line syntax is: "start_sector length_in_sectors <target>
> <target_arguments{0,N}>"
>
>  3) Both my metadata_dev and origin_dev are 10G partitions, is this all
> right?
>
>
> Metadata device size is plenty but that depends on how many eras with how
> many updates you want to have.
>
>  4) My origin_dev is a ext4 filesystem with a block size of 4096, so the
> block_size in the command line should also be 4096?
>
>
> You may use 4096 = _8_ sectors, you used 4096 sectors = 2MB below.
> It's the granularity the era target housekeeps blocks for.
>
>
> I tried the following command:
>
> # dmsetup create MyEra --table "0 160000 era /dev/mapper/mpathap1
> /dev/mapper/mpathbp1 4096"
>
>
> May not be  same physical device for data and metadata!
> If it is, thta'd explain your oops.
>
> # dmsetup create MyEra --table "0 $(blockdev --getsz /dev/mapper/mpathbp)
> era whatever_disctinct_metadata_device /dev/mapper/mpathbp1 8"
>
> Would use 8 sector block size (which is tiny!) with disctinct metadata and
> data devices (presumabyl your ext4 sits on /dev/mapper/mpathbp1)
>
> Heinz
>

Heinz, thank you for your help!

My origin dev is 10G so total sector number is 20971520.
 /dev/mapper/mpathbp1 (/dev/dm-6) is the metadata dev, /dev/mapper/mpathap1
(/dev/dm-7) is the origin dev, they are on different LUNs.

I tried the following commands:

# dmsetup create MyEra --table "0 20971520 /dev/mapper/mpathbp1
/dev/mapper/mpathap1 8"
# Target type name /dev/mapper/mpathbp1 is too long.
# Command failed

# dmsetup create MyEra --table "0 20971520 /dev/dm-6 /dev/dm-7 8"
# device-mapper: reload ioctl on MyEra failed: Invalid argument
# Command failed

And when executing the second command I see the following in
/var/log/messages:

Sep 25 06:37:48 localhost kernel: device-mapper: table: 253:8: /dev/dm-6:
unknown target type
Sep 25 06:37:48 localhost kernel: device-mapper: ioctl: error adding target
to table
Sep 25 06:37:48 localhost multipathd: dm-8: remove map (uevent)
Sep 25 06:37:48 localhost multipathd: dm-8: devmap not registered, can't
remove
Sep 25 06:37:48 localhost multipathd: dm-8: remove map (uevent)
Sep 25 06:37:48 localhost multipathd: dm-8: devmap not registered, can't
remove

Then I run 'mkfs.ext4 /dev/dm-6' and tried the second command again but got
the same result.

Any idea?

Thanks
Romu

--bcaec518662e4ca05c0503e44160
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">2014=
-09-25 18:19 GMT+08:00 Heinz Mauelshagen <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:heinzm@redhat.com" target=3D"_blank">heinzm@redhat.com</a>&gt;</span>=
:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:so=
lid;padding-left:1ex">
 =20
   =20
 =20
  <div bgcolor=3D"#FFFFFF" text=3D"#000000"><span class=3D"">
    On 09/25/2014 08:10 AM, Romu Hu wrote:<br>
    <blockquote type=3D"cite">
     =20
      On 2014/9/24 12:10, Brassow Jonathan wrote:<br>
      <blockquote type=3D"cite">On Sep 22, 2014, at 7:35 AM, Romu wrote:
        <div><br>
          <blockquote type=3D"cite"><span style=3D"border-collapse:separate=
;font-family:Helvetica;font-style:normal;font-variant:normal;font-weight:no=
rmal;letter-spacing:normal;line-height:normal;text-align:-webkit-auto;text-=
indent:0px;text-transform:none;white-space:normal;word-spacing:0px;font-siz=
e:medium">I tried the following command to
              set up my era target but the command immediately panics
              the system and the system reboots.
              <div><br>
              </div>
              <div># dmsetup create MyEra --table &quot;0 41941903=C2=A0era
                /dev/mapper/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV
                4096&quot;<br>
              </div>
              <div><br>
              </div>
              <div>The metadata dev and the origin dev are all part of a
                LVM cache LV.=C2=A0 VG-CacheDataLV_cmeta is the=C2=A0cache
                metadata LV on the smaller and faster device,
                VG-OriginLV is the origin LV on the faster and slower
                device, 41941903 is the total sector number of the
                device of OriginLV (the LV takes 100% space of the
                device), 4096 is the block size of OriginLV, I have run
                &#39;mkfs.ext4 /dev/mapper/VG-OriginLV&#39; before running =
the
                dmsetup command.<br>
              </div>
              <div><br>
              </div>
              <div>Below is the message in /var/log/messages after
                running the dmsetup comnmand:</div>
              <div><br>
              </div>
              <div>kernel: device-mapper: era: sb_check failed: magic
                1623043: wanted <a href=3D"tel:2126579579" value=3D"+121265=
79579" target=3D"_blank">2126579579</a><br>
              </div>
              <div>
                <div>kernel: device-mapper: block manager: superblock
                  validator check failed for block 0</div>
                <div>kernel: device-mapper: era: couldn&#39;t read_lock
                  superblock</div>
              </div>
              <div><br>
              </div>
              <div><br>
              </div>
              <div>Any idea?</div>
            </span><br>
          </blockquote>
        </div>
        <br>
        <div>Sorry, I haven&#39;t used dm-era yet.=C2=A0 However, it does a=
ppear
          that you are perhaps specifying the wrong devices when
          creating the era device?=C2=A0 Looks like you might be allowing t=
he
          era target and the cache target to use the same metadata area
          at the same time - causing them to corrupt each other&#39;s
          metadata area?</div>
        <div><br>
        </div>
        <div>=C2=A0brassow</div>
      </blockquote>
      <br>
      I think the dmsetup command to set up an era target should be
      something like this:<br>
      <br>
      <tt><span style=3D"border-collapse:separate;font-style:normal;font-va=
riant:normal;font-weight:normal;letter-spacing:normal;line-height:normal;te=
xt-indent:0px;text-transform:none;white-space:normal;word-spacing:0px;font-=
size:medium"># dmsetup create MyEra --table &quot;0 sector_number era
          metadeta_dev origin_dev block_size&quot;</span></tt><br>
      <br>
      My questions:<br>
      <br>
      1) How to calculate sector_number?=C2=A0 According to <a href=3D"http=
s://www.kernel.org/doc/Documentation/device-mapper/era.txt" target=3D"_blan=
k">https://www.kernel.org/doc/Documentation/device-mapper/era.txt</a>,
      I guess it should be (4 * nr_blocks) bytes + buffers, but what is
      nr_blocks and what is buffers?<br>
    </blockquote>
    <br></span>
    No calculation: it&#39;s the size of your era target in sectors.
    Typically &quot;blockdev --getsz origin_dev&quot;<span class=3D""><br>
    <br>
    <blockquote type=3D"cite"> 2)
      Any documentation for dmsetup tables?<br>
    </blockquote>
    <br></span>
    Look for examples in the kernel source trees
    Documentaion/device.mapper.<br>
    <br>
    table line syntax is: &quot;start_sector length_in_sectors &lt;target&g=
t;
    &lt;target_arguments{0,N}&gt;&quot;<span class=3D""><br>
    <br>
    <blockquote type=3D"cite"> 3)
      Both my metadata_dev and origin_dev are 10G partitions, is this
      all right?<br>
    </blockquote>
    <br></span>
    Metadata device size is plenty but that depends on how many eras
    with how many updates you want to have.<span class=3D""><br>
    <br>
    <blockquote type=3D"cite"> 4) My
      origin_dev is a ext4 filesystem with a block size of 4096, so the
      block_size in the command line should also be 4096?<br>
    </blockquote>
    <br></span>
    You may use 4096 =3D _8_ sectors, you used 4096 sectors =3D 2MB below.<=
br>
    It&#39;s the granularity the era target housekeeps blocks for.<span cla=
ss=3D""><br>
    <br>
    <blockquote type=3D"cite"> <br>
      I tried the following command:<br>
      <br>
      <tt># dmsetup create MyEra --table &quot;0 160000 era
        /dev/mapper/mpathap1 /dev/mapper/mpathbp1 4096&quot;</tt><br>
    </blockquote>
    <br></span>
    May not be=C2=A0 same physical device for data and metadata!<br>
    If it is, thta&#39;d explain your oops.<br>
    <br>
    <tt># dmsetup create MyEra --table &quot;0 $(blockdev --getsz </tt><tt>=
<tt>/dev/mapper/mpathbp)</tt>
      era whatever_disctinct_metadata_device /dev/mapper/mpathbp1 8&quot;</=
tt><br>
    <br>
    Would use 8 sector block size (which is tiny!) with disctinct
    metadata and data devices (presumabyl your ext4 sits on <tt>/dev/mapper=
/mpathbp1)</tt><span class=3D""><font color=3D"#888888"><br>
    <br>
    Heinz<br></font></span></div></blockquote><div><br></div><div>Heinz, th=
ank you for your help!</div><div><br></div><div>My origin dev is 10G so tot=
al sector number is=C2=A020971520. =C2=A0/dev/mapper/mpathbp1 (/dev/dm-6) i=
s the metadata dev, /dev/mapper/mpathap1 (/dev/dm-7) is the origin dev, the=
y are on different LUNs.</div><div><br></div><div>I tried the following com=
mands:</div><div><br></div><div># dmsetup create MyEra --table &quot;0 2097=
1520 /dev/mapper/mpathbp1 /dev/mapper/mpathap1 8&quot;<br></div><div># Targ=
et type name /dev/mapper/mpathbp1 is too long.</div><div><div># Command fai=
led</div></div><div><br></div><div># dmsetup create MyEra --table &quot;0 2=
0971520 /dev/dm-6 /dev/dm-7 8&quot;<br></div><div># device-mapper: reload i=
octl on MyEra failed: Invalid argument</div><div><div># Command failed</div=
></div><div><br></div><div>And when executing the second command I see the =
following in /var/log/messages:</div><div><br></div><div><div>Sep 25 06:37:=
48 localhost kernel: device-mapper: table: 253:8: /dev/dm-6: unknown target=
 type</div><div>Sep 25 06:37:48 localhost kernel: device-mapper: ioctl: err=
or adding target to table</div><div>Sep 25 06:37:48 localhost multipathd: d=
m-8: remove map (uevent)</div><div>Sep 25 06:37:48 localhost multipathd: dm=
-8: devmap not registered, can&#39;t remove</div><div>Sep 25 06:37:48 local=
host multipathd: dm-8: remove map (uevent)</div><div>Sep 25 06:37:48 localh=
ost multipathd: dm-8: devmap not registered, can&#39;t remove</div></div><d=
iv><br></div><div>Then I run &#39;mkfs.ext4 /dev/dm-6&#39; and tried the se=
cond command again but got the same result.</div><div><br></div><div>Any id=
ea?</div><div><br></div><div>Thanks</div><div>Romu</div></div></div></div>

--bcaec518662e4ca05c0503e44160--


--===============3079914831863331584==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3079914831863331584==--
