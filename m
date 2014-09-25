From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: RHEL6.6 dm-cache and dm-era
Date: Thu, 25 Sep 2014 12:19:55 +0200
Message-ID: <5423EC4B.5070904@redhat.com>
References: <54164DC0.3020907@gmail.com>	<FBF1ED45-5B3E-4D0C-90B5-9A51D6EAE8F7@redhat.com>	<541A977D.7010108@gmail.com>	<CANoG8sVhN92jy559m4oLEvRhHWypMWeeU1TFe24CALs_Bw7Qbw@mail.gmail.com>	<6FC8490A-55CA-454E-83FE-061A33FDE8DE@redhat.com>
	<5423B1E0.4000400@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1311280840224902943=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5423B1E0.4000400@gmail.com>
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

This is a multi-part message in MIME format.
--===============1311280840224902943==
Content-Type: multipart/alternative;
	boundary="------------080403030002090902040704"

This is a multi-part message in MIME format.
--------------080403030002090902040704
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 09/25/2014 08:10 AM, Romu Hu wrote:
> On 2014/9/24 12:10, Brassow Jonathan wrote:
>> On Sep 22, 2014, at 7:35 AM, Romu wrote:
>>
>>> I tried the following command to set up my era target but the 
>>> command immediately panics the system and the system reboots.
>>>
>>> # dmsetup create MyEra --table "0 41941903 era 
>>> /dev/mapper/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV 4096"
>>>
>>> The metadata dev and the origin dev are all part of a LVM cache LV.  
>>> VG-CacheDataLV_cmeta is the cache metadata LV on the smaller and 
>>> faster device, VG-OriginLV is the origin LV on the faster and slower 
>>> device, 41941903 is the total sector number of the device of 
>>> OriginLV (the LV takes 100% space of the device), 4096 is the block 
>>> size of OriginLV, I have run 'mkfs.ext4 /dev/mapper/VG-OriginLV' 
>>> before running the dmsetup command.
>>>
>>> Below is the message in /var/log/messages after running the dmsetup 
>>> comnmand:
>>>
>>> kernel: device-mapper: era: sb_check failed: magic 1623043: wanted 
>>> 2126579579
>>> kernel: device-mapper: block manager: superblock validator check 
>>> failed for block 0
>>> kernel: device-mapper: era: couldn't read_lock superblock
>>>
>>>
>>> Any idea?
>>>
>>
>> Sorry, I haven't used dm-era yet.  However, it does appear that you 
>> are perhaps specifying the wrong devices when creating the era 
>> device?  Looks like you might be allowing the era target and the 
>> cache target to use the same metadata area at the same time - causing 
>> them to corrupt each other's metadata area?
>>
>>  brassow
>
> I think the dmsetup command to set up an era target should be 
> something like this:
>
> # dmsetup create MyEra --table "0 sector_number era metadeta_dev 
> origin_dev block_size"
>
> My questions:
>
> 1) How to calculate sector_number?  According to 
> https://www.kernel.org/doc/Documentation/device-mapper/era.txt, I 
> guess it should be (4 * nr_blocks) bytes + buffers, but what is 
> nr_blocks and what is buffers?

No calculation: it's the size of your era target in sectors. Typically 
"blockdev --getsz origin_dev"

> 2) Any documentation for dmsetup tables?

Look for examples in the kernel source trees Documentaion/device.mapper.

table line syntax is: "start_sector length_in_sectors <target> 
<target_arguments{0,N}>"

> 3) Both my metadata_dev and origin_dev are 10G partitions, is this all 
> right?

Metadata device size is plenty but that depends on how many eras with 
how many updates you want to have.

> 4) My origin_dev is a ext4 filesystem with a block size of 4096, so 
> the block_size in the command line should also be 4096?

You may use 4096 = _8_ sectors, you used 4096 sectors = 2MB below.
It's the granularity the era target housekeeps blocks for.

>
> I tried the following command:
>
> # dmsetup create MyEra --table "0 160000 era /dev/mapper/mpathap1 
> /dev/mapper/mpathbp1 4096"

May not be  same physical device for data and metadata!
If it is, thta'd explain your oops.

# dmsetup create MyEra --table "0 $(blockdev --getsz 
/dev/mapper/mpathbp) era whatever_disctinct_metadata_device 
/dev/mapper/mpathbp1 8"

Would use 8 sector block size (which is tiny!) with disctinct metadata 
and data devices (presumabyl your ext4 sits on /dev/mapper/mpathbp1)

Heinz


>
> It immediately panics the kernel (2.6.32-494.el6.i686) with the 
> following info in /var/log/messages:
>
> Sep 24 22:44:22 localhost kernel: device-mapper: era: sb_check failed: 
> magic 0: wanted 2126579579
> Sep 24 22:44:22 localhost kernel: device-mapper: block manager: 
> superblock validator check failed for block 0
> Sep 24 22:44:22 localhost kernel: device-mapper: era: couldn't 
> read_lock superblock
> Sep 24 22:44:22 localhost kernel: BUG: unable to handle kernel NULL 
> pointer dereference at 00000008
> Sep 24 22:44:22 localhost kernel: IP: [<f7e9a3c7>] 
> era_destroy+0x7/0x60 [dm_era]
> Sep 24 22:44:22 localhost kernel: *pdpt = 0000000001945001 *pde = 
> 00000003ff97f067
> Sep 24 22:44:22 localhost kernel: Oops: 0000 [#1] SMP
> Sep 24 22:44:22 localhost kernel: last sysfs file: 
> /sys/module/dm_mod/initstate
>
> Thanks
> Romu
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------080403030002090902040704
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx5-phx2.redhat.com id s8PAJxUT020454

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    On 09/25/2014 08:10 AM, Romu Hu wrote:<br>
    <blockquote cite=3D"mid:5423B1E0.4000400@gmail.com" type=3D"cite">
      <meta content=3D"text/html; charset=3Dwindows-1252"
        http-equiv=3D"Content-Type">
      On 2014/9/24 12:10, Brassow Jonathan wrote:<br>
      <blockquote
        cite=3D"mid:6FC8490A-55CA-454E-83FE-061A33FDE8DE@redhat.com"
        type=3D"cite">On Sep 22, 2014, at 7:35 AM, Romu wrote:
        <div><br class=3D"Apple-interchange-newline">
          <blockquote type=3D"cite"><span class=3D"Apple-style-span"
              style=3D"border-collapse: separate; font-family: Helvetica;
              font-style: normal; font-variant: normal; font-weight:
              normal; letter-spacing: normal; line-height: normal;
              orphans: 2; text-align: -webkit-auto; text-indent: 0px;
              text-transform: none; white-space: normal; widows: 2;
              word-spacing: 0px; -webkit-border-horizontal-spacing: 0px;
              -webkit-border-vertical-spacing: 0px;
              -webkit-text-decorations-in-effect: none;
              -webkit-text-size-adjust: auto; -webkit-text-stroke-width:
              0px; font-size: medium; ">I tried the following command to
              set up my era target but the command immediately panics
              the system and the system reboots.
              <div><br>
              </div>
              <div># dmsetup create MyEra --table "0 41941903=A0era
                /dev/mapper/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV
                4096"<br>
              </div>
              <div><br>
              </div>
              <div>The metadata dev and the origin dev are all part of a
                LVM cache LV.=A0 VG-CacheDataLV_cmeta is the=A0cache
                metadata LV on the smaller and faster device,
                VG-OriginLV is the origin LV on the faster and slower
                device, 41941903 is the total sector number of the
                device of OriginLV (the LV takes 100% space of the
                device), 4096 is the block size of OriginLV, I have run
                'mkfs.ext4 /dev/mapper/VG-OriginLV' before running the
                dmsetup command.<br>
              </div>
              <div><br>
              </div>
              <div>Below is the message in /var/log/messages after
                running the dmsetup comnmand:</div>
              <div><br>
              </div>
              <div>kernel: device-mapper: era: sb_check failed: magic
                1623043: wanted 2126579579<br>
              </div>
              <div>
                <div>kernel: device-mapper: block manager: superblock
                  validator check failed for block 0</div>
                <div>kernel: device-mapper: era: couldn't read_lock
                  superblock</div>
              </div>
              <div><br>
              </div>
              <div><br>
              </div>
              <div>Any idea?</div>
            </span><br class=3D"Apple-interchange-newline">
          </blockquote>
        </div>
        <br>
        <div>Sorry, I haven't used dm-era yet. =A0However, it does appear
          that you are perhaps specifying the wrong devices when
          creating the era device? =A0Looks like you might be allowing th=
e
          era target and the cache target to use the same metadata area
          at the same time - causing them to corrupt each other's
          metadata area?</div>
        <div><br>
        </div>
        <div>=A0brassow</div>
      </blockquote>
      <br>
      I think the dmsetup command to set up an era target should be
      something like this:<br>
      <br>
      <tt><span class=3D"Apple-style-span" style=3D"border-collapse:
          separate; font-style: normal; font-variant: normal;
          font-weight: normal; letter-spacing: normal; line-height:
          normal; orphans: 2; text-indent: 0px; text-transform: none;
          white-space: normal; widows: 2; word-spacing: 0px; font-size:
          medium;"># dmsetup create MyEra --table "0 sector_number era
          metadeta_dev origin_dev block_size"</span></tt><br>
      <br>
      My questions:<br>
      <br>
      1) How to calculate sector_number?=A0 According to <a
        moz-do-not-send=3D"true" class=3D"moz-txt-link-freetext"
        href=3D"https://www.kernel.org/doc/Documentation/device-mapper/er=
a.txt">https://www.kernel.org/doc/Documentation/device-mapper/era.txt</a>=
,
      I guess it should be (4 * nr_blocks) bytes + buffers, but what is
      nr_blocks and what is buffers?<br>
    </blockquote>
    <br>
    No calculation: it's the size of your era target in sectors.
    Typically "blockdev --getsz origin_dev"<br>
    <br>
    <blockquote cite=3D"mid:5423B1E0.4000400@gmail.com" type=3D"cite"> 2)
      Any documentation for dmsetup tables?<br>
    </blockquote>
    <br>
    Look for examples in the kernel source trees
    Documentaion/device.mapper.<br>
    <br>
    table line syntax is: "start_sector length_in_sectors &lt;target&gt;
    &lt;target_arguments{0,N}&gt;"<br>
    <br>
    <blockquote cite=3D"mid:5423B1E0.4000400@gmail.com" type=3D"cite"> 3)
      Both my metadata_dev and origin_dev are 10G partitions, is this
      all right?<br>
    </blockquote>
    <br>
    Metadata device size is plenty but that depends on how many eras
    with how many updates you want to have.<br>
    <br>
    <blockquote cite=3D"mid:5423B1E0.4000400@gmail.com" type=3D"cite"> 4)=
 My
      origin_dev is a ext4 filesystem with a block size of 4096, so the
      block_size in the command line should also be 4096?<br>
    </blockquote>
    <br>
    You may use 4096 =3D _8_ sectors, you used 4096 sectors =3D 2MB below=
.<br>
    It's the granularity the era target housekeeps blocks for.<br>
    <br>
    <blockquote cite=3D"mid:5423B1E0.4000400@gmail.com" type=3D"cite"> <b=
r>
      I tried the following command:<br>
      <br>
      <tt># dmsetup create MyEra --table "0 160000 era
        /dev/mapper/mpathap1 /dev/mapper/mpathbp1 4096"</tt><br>
    </blockquote>
    <br>
    May not be=A0 same physical device for data and metadata!<br>
    If it is, thta'd explain your oops.<br>
    <br>
    <tt># dmsetup create MyEra --table "0 $(blockdev --getsz </tt><tt><tt=
>/dev/mapper/mpathbp)</tt>
      era whatever_disctinct_metadata_device /dev/mapper/mpathbp1 8"</tt>=
<br>
    <br>
    Would use 8 sector block size (which is tiny!) with disctinct
    metadata and data devices (presumabyl your ext4 sits on <tt>/dev/mapp=
er/mpathbp1)</tt><br>
    <br>
    Heinz<br>
    <br>
    <br>
    <blockquote cite=3D"mid:5423B1E0.4000400@gmail.com" type=3D"cite"> <b=
r>
      It immediately panics the kernel (2.6.32-494.el6.i686) with the
      following info in /var/log/messages:<br>
      <br>
      <tt>Sep 24 22:44:22 localhost kernel: device-mapper: era: sb_check
        failed: magic 0: wanted 2126579579</tt><tt><br>
      </tt><tt>Sep 24 22:44:22 localhost kernel: device-mapper: block
        manager: superblock validator check failed for block 0</tt><tt><b=
r>
      </tt><tt>Sep 24 22:44:22 localhost kernel: device-mapper: era:
        couldn't read_lock superblock</tt><tt><br>
      </tt><tt>Sep 24 22:44:22 localhost kernel: BUG: unable to handle
        kernel NULL pointer dereference at 00000008</tt><tt><br>
      </tt><tt>Sep 24 22:44:22 localhost kernel: IP: [&lt;f7e9a3c7&gt;]
        era_destroy+0x7/0x60 [dm_era]</tt><tt><br>
      </tt><tt>Sep 24 22:44:22 localhost kernel: *pdpt =3D
        0000000001945001 *pde =3D 00000003ff97f067</tt><tt><br>
      </tt><tt>Sep 24 22:44:22 localhost kernel: Oops: 0000 [#1] SMP</tt>=
<tt><br>
      </tt><tt>Sep 24 22:44:22 localhost kernel: last sysfs file:
        /sys/module/dm_mod/initstate</tt><br>
      <br>
      Thanks<br>
      Romu<br>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap=3D"">--
dm-devel mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:dm-devel@redhat.com"=
>dm-devel@redhat.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://www.redhat.com/mailman=
/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><=
/pre>
    </blockquote>
    <br>
  </body>
</html>

--------------080403030002090902040704--


--===============1311280840224902943==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============1311280840224902943==--
