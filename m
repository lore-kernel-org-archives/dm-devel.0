From: Romu Hu <huruomu@gmail.com>
Subject: Re: RHEL6.6 dm-cache and dm-era
Date: Fri, 26 Sep 2014 11:16:41 +0800
Message-ID: <5424DA99.2070308@gmail.com>
References: <54164DC0.3020907@gmail.com>	<FBF1ED45-5B3E-4D0C-90B5-9A51D6EAE8F7@redhat.com>	<541A977D.7010108@gmail.com>	<CANoG8sVhN92jy559m4oLEvRhHWypMWeeU1TFe24CALs_Bw7Qbw@mail.gmail.com>	<6FC8490A-55CA-454E-83FE-061A33FDE8DE@redhat.com>	<5423B1E0.4000400@gmail.com>	<5423EC4B.5070904@redhat.com>	<CANoG8sWXjR5LmZvY2K1ebOr=kS+A=-EPveqh=XsqD0v6bWcc2g@mail.gmail.com>
	<54242D6D.4090004@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1990645481977254260=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54242D6D.4090004@redhat.com>
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
--===============1990645481977254260==
Content-Type: multipart/alternative;
	boundary="------------040201070407050605050602"

This is a multi-part message in MIME format.
--------------040201070407050605050602
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 2014/9/25 22:57, Heinz Mauelshagen wrote:
> Romu,
>
> "dmsetup create MyEra --table "0 20971520 /dev/mapper/mpathbp1 
> /dev/mapper/mpathap1 8"
>
> should read
>
> dmsetup create MyEra --table "0 20971520 era /dev/mapper/mpathbp1 
> /dev/mapper/mpathap1 8"

Sorry my bad.

I ran 'dmsetup create MyEra --table "0 20971520 era /dev/mapper/mpathbp1 
/dev/mapper/mpathap1 8"' but kernel (2.6.32-494.el6.i686) oopsed:

Sep 25 18:34:11 localhost kernel: device-mapper: era: sb_check failed: 
magic 0: wanted 2126579579
Sep 25 18:34:11 localhost kernel: device-mapper: block manager: 
superblock validator check failed for block 0
Sep 25 18:34:11 localhost kernel: device-mapper: era: couldn't read_lock 
superblock
Sep 25 18:34:11 localhost kernel: BUG: unable to handle kernel NULL 
pointer dereference at 00000008
Sep 25 18:34:11 localhost kernel: IP: [<f7e2b3c7>] era_destroy+0x7/0x60 
[dm_era]Sep 25 18:34:11 localhost kernel: *pdpt = 0000000032457001 *pde 
= 00000003fb5fa067
Sep 25 18:34:11 localhost kernel: Oops: 0000 [#1] SMP
Sep 25 18:34:11 localhost kernel: last sysfs file: 
/sys/module/dm_persistent_data/initstate

Perhaps this should be cherry-picked?
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=989f26f5ad308f40a95f280bf9cd75e558d4f18d

The log says sb_check failed, anything wrong with the dmsetup command 
parameters?

Thanks
Romu

> On 09/25/2014 04:02 PM, Romu wrote:
>> 2014-09-25 18:19 GMT+08:00 Heinz Mauelshagen <heinzm@redhat.com 
>> <mailto:heinzm@redhat.com>>:
>>
>>     On 09/25/2014 08:10 AM, Romu Hu wrote:
>>>     On 2014/9/24 12:10, Brassow Jonathan wrote:
>>>>     On Sep 22, 2014, at 7:35 AM, Romu wrote:
>>>>
>>>>>     I tried the following command to set up my era target but the
>>>>>     command immediately panics the system and the system reboots.
>>>>>
>>>>>     # dmsetup create MyEra --table "0 41941903 era
>>>>>     /dev/mapper/VG-CacheDataLV_cmeta /dev/mapper/VG-OriginLV 4096"
>>>>>
>>>>>     The metadata dev and the origin dev are all part of a LVM
>>>>>     cache LV. VG-CacheDataLV_cmeta is the cache metadata LV on the
>>>>>     smaller and faster device, VG-OriginLV is the origin LV on the
>>>>>     faster and slower device, 41941903 is the total sector number
>>>>>     of the device of OriginLV (the LV takes 100% space of the
>>>>>     device), 4096 is the block size of OriginLV, I have run
>>>>>     'mkfs.ext4 /dev/mapper/VG-OriginLV' before running the dmsetup
>>>>>     command.
>>>>>
>>>>>     Below is the message in /var/log/messages after running the
>>>>>     dmsetup comnmand:
>>>>>
>>>>>     kernel: device-mapper: era: sb_check failed: magic 1623043:
>>>>>     wanted 2126579579 <tel:2126579579>
>>>>>     kernel: device-mapper: block manager: superblock validator
>>>>>     check failed for block 0
>>>>>     kernel: device-mapper: era: couldn't read_lock superblock
>>>>>
>>>>>
>>>>>     Any idea?
>>>>>
>>>>
>>>>     Sorry, I haven't used dm-era yet.  However, it does appear that
>>>>     you are perhaps specifying the wrong devices when creating the
>>>>     era device?  Looks like you might be allowing the era target
>>>>     and the cache target to use the same metadata area at the same
>>>>     time - causing them to corrupt each other's metadata area?
>>>>
>>>>      brassow
>>>
>>>     I think the dmsetup command to set up an era target should be
>>>     something like this:
>>>
>>>     # dmsetup create MyEra --table "0 sector_number era metadeta_dev
>>>     origin_dev block_size"
>>>
>>>     My questions:
>>>
>>>     1) How to calculate sector_number?  According to
>>>     https://www.kernel.org/doc/Documentation/device-mapper/era.txt,
>>>     I guess it should be (4 * nr_blocks) bytes + buffers, but what
>>>     is nr_blocks and what is buffers?
>>
>>     No calculation: it's the size of your era target in sectors.
>>     Typically "blockdev --getsz origin_dev"
>>
>>>     2) Any documentation for dmsetup tables?
>>
>>     Look for examples in the kernel source trees
>>     Documentaion/device.mapper.
>>
>>     table line syntax is: "start_sector length_in_sectors <target>
>>     <target_arguments{0,N}>"
>>
>>>     3) Both my metadata_dev and origin_dev are 10G partitions, is
>>>     this all right?
>>
>>     Metadata device size is plenty but that depends on how many eras
>>     with how many updates you want to have.
>>
>>>     4) My origin_dev is a ext4 filesystem with a block size of 4096,
>>>     so the block_size in the command line should also be 4096?
>>
>>     You may use 4096 = _8_ sectors, you used 4096 sectors = 2MB below.
>>     It's the granularity the era target housekeeps blocks for.
>>
>>>
>>>     I tried the following command:
>>>
>>>     # dmsetup create MyEra --table "0 160000 era
>>>     /dev/mapper/mpathap1 /dev/mapper/mpathbp1 4096"
>>
>>     May not be  same physical device for data and metadata!
>>     If it is, thta'd explain your oops.
>>
>>     # dmsetup create MyEra --table "0 $(blockdev --getsz
>>     /dev/mapper/mpathbp) era whatever_disctinct_metadata_device
>>     /dev/mapper/mpathbp1 8"
>>
>>     Would use 8 sector block size (which is tiny!) with disctinct
>>     metadata and data devices (presumabyl your ext4 sits on
>>     /dev/mapper/mpathbp1)
>>
>>     Heinz
>>
>>
>> Heinz, thank you for your help!
>>
>> My origin dev is 10G so total sector number is 20971520. 
>>  /dev/mapper/mpathbp1 (/dev/dm-6) is the metadata dev, 
>> /dev/mapper/mpathap1 (/dev/dm-7) is the origin dev, they are on 
>> different LUNs.
>>
>> I tried the following commands:
>>
>> # dmsetup create MyEra --table "0 20971520 /dev/mapper/mpathbp1 
>> /dev/mapper/mpathap1 8"
>> # Target type name /dev/mapper/mpathbp1 is too long.
>> # Command failed
>>
>> # dmsetup create MyEra --table "0 20971520 /dev/dm-6 /dev/dm-7 8"
>> # device-mapper: reload ioctl on MyEra failed: Invalid argument
>> # Command failed
>>
>> And when executing the second command I see the following in 
>> /var/log/messages:
>>
>> Sep 25 06:37:48 localhost kernel: device-mapper: table: 253:8: 
>> /dev/dm-6: unknown target type
>> Sep 25 06:37:48 localhost kernel: device-mapper: ioctl: error adding 
>> target to table
>> Sep 25 06:37:48 localhost multipathd: dm-8: remove map (uevent)
>> Sep 25 06:37:48 localhost multipathd: dm-8: devmap not registered, 
>> can't remove
>> Sep 25 06:37:48 localhost multipathd: dm-8: remove map (uevent)
>> Sep 25 06:37:48 localhost multipathd: dm-8: devmap not registered, 
>> can't remove
>>
>> Then I run 'mkfs.ext4 /dev/dm-6' and tried the second command again 
>> but got the same result.
>>
>> Any idea?
>>
>> Thanks
>> Romu
>>
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------040201070407050605050602
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id s8Q3Gsuh012992

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    On 2014/9/25 22:57, Heinz Mauelshagen wrote:<br>
    <blockquote cite=3D"mid:54242D6D.4090004@redhat.com" type=3D"cite">
      <meta content=3D"text/html; charset=3Dwindows-1252"
        http-equiv=3D"Content-Type">
      Romu,<br>
      <br>
      "dmsetup create MyEra --table "0 20971520 /dev/mapper/mpathbp1
      /dev/mapper/mpathap1 8"<br>
      <br>
      should read<br>
      <br>
      dmsetup create MyEra --table "0 20971520 era /dev/mapper/mpathbp1
      /dev/mapper/mpathap1 8"<br>
    </blockquote>
    <br>
    Sorry my bad.<br>
    <br>
    I ran 'dmsetup create MyEra --table "0 20971520 era
    /dev/mapper/mpathbp1 /dev/mapper/mpathap1 8"' but kernel
    (2.6.32-494.el6.i686) oopsed:<br>
    <br>
    <tt>Sep 25 18:34:11 localhost kernel: device-mapper: era: sb_check
      failed: magic 0: wanted 2126579579</tt><tt><br>
    </tt><tt>Sep 25 18:34:11 localhost kernel: device-mapper: block
      manager: superblock validator check failed for block 0</tt><tt><br>
    </tt><tt>Sep 25 18:34:11 localhost kernel: device-mapper: era:
      couldn't read_lock superblock</tt><tt><br>
    </tt><tt>Sep 25 18:34:11 localhost kernel: BUG: unable to handle
      kernel NULL pointer dereference at 00000008</tt><tt><br>
    </tt><tt>Sep 25 18:34:11 localhost kernel: IP: [&lt;f7e2b3c7&gt;]
      era_destroy+0x7/0x60 [dm_era]Sep 25 18:34:11 localhost kernel:
      *pdpt =3D 0000000032457001 *pde =3D 00000003fb5fa067</tt><tt><br>
    </tt><tt>Sep 25 18:34:11 localhost kernel: Oops: 0000 [#1] SMP</tt><t=
t><br>
    </tt><tt>Sep 25 18:34:11 localhost kernel: last sysfs file:
      /sys/module/dm_persistent_data/initstate</tt><br>
    <br>
    Perhaps this should be cherry-picked?<br>
<a class=3D"moz-txt-link-freetext" href=3D"https://git.kernel.org/cgit/li=
nux/kernel/git/torvalds/linux.git/commit/?id=3D989f26f5ad308f40a95f280bf9=
cd75e558d4f18d">https://git.kernel.org/cgit/linux/kernel/git/torvalds/lin=
ux.git/commit/?id=3D989f26f5ad308f40a95f280bf9cd75e558d4f18d</a><br>
    <br>
    The log says sb_check failed, anything wrong with the dmsetup
    command parameters?<br>
    <br>
    Thanks<br>
    Romu<br>
    <br>
    <blockquote cite=3D"mid:54242D6D.4090004@redhat.com" type=3D"cite">
      <div class=3D"moz-cite-prefix">On 09/25/2014 04:02 PM, Romu wrote:<=
br>
      </div>
      <blockquote
cite=3D"mid:CANoG8sWXjR5LmZvY2K1ebOr=3DkS+A=3D-EPveqh=3DXsqD0v6bWcc2g@mai=
l.gmail.com"
        type=3D"cite">
        <div dir=3D"ltr">
          <div class=3D"gmail_extra">
            <div class=3D"gmail_quote">2014-09-25 18:19 GMT+08:00 Heinz
              Mauelshagen <span dir=3D"ltr">&lt;<a moz-do-not-send=3D"tru=
e"
                  href=3D"mailto:heinzm@redhat.com" target=3D"_blank">hei=
nzm@redhat.com</a>&gt;</span>:<br>
              <blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px
0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-lef=
t-style:solid;padding-left:1ex">
                <div bgcolor=3D"#FFFFFF" text=3D"#000000"><span class=3D"=
"> On
                    09/25/2014 08:10 AM, Romu Hu wrote:<br>
                    <blockquote type=3D"cite"> On 2014/9/24 12:10, Brasso=
w
                      Jonathan wrote:<br>
                      <blockquote type=3D"cite">On Sep 22, 2014, at 7:35
                        AM, Romu wrote:
                        <div><br>
                          <blockquote type=3D"cite"><span
style=3D"border-collapse:separate;font-family:Helvetica;font-style:normal=
;font-variant:normal;font-weight:normal;letter-spacing:normal;line-height=
:normal;text-align:-webkit-auto;text-indent:0px;text-transform:none;white=
-space:normal;word-spacing:0px;font-size:medium">I
                              tried the following command to set up my
                              era target but the command immediately
                              panics the system and the system reboots.
                              <div><br>
                              </div>
                              <div># dmsetup create MyEra --table "0
                                41941903=A0era
                                /dev/mapper/VG-CacheDataLV_cmeta
                                /dev/mapper/VG-OriginLV 4096"<br>
                              </div>
                              <div><br>
                              </div>
                              <div>The metadata dev and the origin dev
                                are all part of a LVM cache LV.=A0
                                VG-CacheDataLV_cmeta is the=A0cache
                                metadata LV on the smaller and faster
                                device, VG-OriginLV is the origin LV on
                                the faster and slower device, 41941903
                                is the total sector number of the device
                                of OriginLV (the LV takes 100% space of
                                the device), 4096 is the block size of
                                OriginLV, I have run 'mkfs.ext4
                                /dev/mapper/VG-OriginLV' before running
                                the dmsetup command.<br>
                              </div>
                              <div><br>
                              </div>
                              <div>Below is the message in
                                /var/log/messages after running the
                                dmsetup comnmand:</div>
                              <div><br>
                              </div>
                              <div>kernel: device-mapper: era: sb_check
                                failed: magic 1623043: wanted <a
                                  moz-do-not-send=3D"true"
                                  href=3D"tel:2126579579"
                                  value=3D"+12126579579" target=3D"_blank=
">2126579579</a><br>
                              </div>
                              <div>
                                <div>kernel: device-mapper: block
                                  manager: superblock validator check
                                  failed for block 0</div>
                                <div>kernel: device-mapper: era:
                                  couldn't read_lock superblock</div>
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
                        <div>Sorry, I haven't used dm-era yet.=A0 However=
,
                          it does appear that you are perhaps specifying
                          the wrong devices when creating the era
                          device?=A0 Looks like you might be allowing the
                          era target and the cache target to use the
                          same metadata area at the same time - causing
                          them to corrupt each other's metadata area?</di=
v>
                        <div><br>
                        </div>
                        <div>=A0brassow</div>
                      </blockquote>
                      <br>
                      I think the dmsetup command to set up an era
                      target should be something like this:<br>
                      <br>
                      <tt><span
style=3D"border-collapse:separate;font-style:normal;font-variant:normal;f=
ont-weight:normal;letter-spacing:normal;line-height:normal;text-indent:0p=
x;text-transform:none;white-space:normal;word-spacing:0px;font-size:mediu=
m">#
                          dmsetup create MyEra --table "0 sector_number
                          era metadeta_dev origin_dev block_size"</span><=
/tt><br>
                      <br>
                      My questions:<br>
                      <br>
                      1) How to calculate sector_number?=A0 According to =
<a
                        moz-do-not-send=3D"true"
                        href=3D"https://www.kernel.org/doc/Documentation/=
device-mapper/era.txt"
                        target=3D"_blank">https://www.kernel.org/doc/Docu=
mentation/device-mapper/era.txt</a>,
                      I guess it should be (4 * nr_blocks) bytes +
                      buffers, but what is nr_blocks and what is
                      buffers?<br>
                    </blockquote>
                    <br>
                  </span> No calculation: it's the size of your era
                  target in sectors. Typically "blockdev --getsz
                  origin_dev"<span class=3D""><br>
                    <br>
                    <blockquote type=3D"cite"> 2) Any documentation for
                      dmsetup tables?<br>
                    </blockquote>
                    <br>
                  </span> Look for examples in the kernel source trees
                  Documentaion/device.mapper.<br>
                  <br>
                  table line syntax is: "start_sector length_in_sectors
                  &lt;target&gt; &lt;target_arguments{0,N}&gt;"<span
                    class=3D""><br>
                    <br>
                    <blockquote type=3D"cite"> 3) Both my metadata_dev an=
d
                      origin_dev are 10G partitions, is this all right?<b=
r>
                    </blockquote>
                    <br>
                  </span> Metadata device size is plenty but that
                  depends on how many eras with how many updates you
                  want to have.<span class=3D""><br>
                    <br>
                    <blockquote type=3D"cite"> 4) My origin_dev is a ext4
                      filesystem with a block size of 4096, so the
                      block_size in the command line should also be
                      4096?<br>
                    </blockquote>
                    <br>
                  </span> You may use 4096 =3D _8_ sectors, you used 4096
                  sectors =3D 2MB below.<br>
                  It's the granularity the era target housekeeps blocks
                  for.<span class=3D""><br>
                    <br>
                    <blockquote type=3D"cite"> <br>
                      I tried the following command:<br>
                      <br>
                      <tt># dmsetup create MyEra --table "0 160000 era
                        /dev/mapper/mpathap1 /dev/mapper/mpathbp1 4096"</=
tt><br>
                    </blockquote>
                    <br>
                  </span> May not be=A0 same physical device for data and
                  metadata!<br>
                  If it is, thta'd explain your oops.<br>
                  <br>
                  <tt># dmsetup create MyEra --table "0 $(blockdev
                    --getsz </tt><tt><tt>/dev/mapper/mpathbp)</tt> era
                    whatever_disctinct_metadata_device
                    /dev/mapper/mpathbp1 8"</tt><br>
                  <br>
                  Would use 8 sector block size (which is tiny!) with
                  disctinct metadata and data devices (presumabyl your
                  ext4 sits on <tt>/dev/mapper/mpathbp1)</tt><span
                    class=3D""><font color=3D"#888888"><br>
                      <br>
                      Heinz<br>
                    </font></span></div>
              </blockquote>
              <div><br>
              </div>
              <div>Heinz, thank you for your help!</div>
              <div><br>
              </div>
              <div>My origin dev is 10G so total sector number
                is=A020971520. =A0/dev/mapper/mpathbp1 (/dev/dm-6) is the
                metadata dev, /dev/mapper/mpathap1 (/dev/dm-7) is the
                origin dev, they are on different LUNs.</div>
              <div><br>
              </div>
              <div>I tried the following commands:</div>
              <div><br>
              </div>
              <div># dmsetup create MyEra --table "0 20971520
                /dev/mapper/mpathbp1 /dev/mapper/mpathap1 8"<br>
              </div>
              <div># Target type name /dev/mapper/mpathbp1 is too long.</=
div>
              <div>
                <div># Command failed</div>
              </div>
              <div><br>
              </div>
              <div># dmsetup create MyEra --table "0 20971520 /dev/dm-6
                /dev/dm-7 8"<br>
              </div>
              <div># device-mapper: reload ioctl on MyEra failed:
                Invalid argument</div>
              <div>
                <div># Command failed</div>
              </div>
              <div><br>
              </div>
              <div>And when executing the second command I see the
                following in /var/log/messages:</div>
              <div><br>
              </div>
              <div>
                <div>Sep 25 06:37:48 localhost kernel: device-mapper:
                  table: 253:8: /dev/dm-6: unknown target type</div>
                <div>Sep 25 06:37:48 localhost kernel: device-mapper:
                  ioctl: error adding target to table</div>
                <div>Sep 25 06:37:48 localhost multipathd: dm-8: remove
                  map (uevent)</div>
                <div>Sep 25 06:37:48 localhost multipathd: dm-8: devmap
                  not registered, can't remove</div>
                <div>Sep 25 06:37:48 localhost multipathd: dm-8: remove
                  map (uevent)</div>
                <div>Sep 25 06:37:48 localhost multipathd: dm-8: devmap
                  not registered, can't remove</div>
              </div>
              <div><br>
              </div>
              <div>Then I run 'mkfs.ext4 /dev/dm-6' and tried the second
                command again but got the same result.</div>
              <div><br>
              </div>
              <div>Any idea?</div>
              <div><br>
              </div>
              <div>Thanks</div>
              <div>Romu</div>
            </div>
          </div>
        </div>
        <br>
        <fieldset class=3D"mimeAttachmentHeader"></fieldset>
        <br>
        <pre wrap=3D"">--
dm-devel mailing list
<a moz-do-not-send=3D"true" class=3D"moz-txt-link-abbreviated" href=3D"ma=
ilto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a moz-do-not-send=3D"true" class=3D"moz-txt-link-freetext" href=3D"https=
://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailm=
an/listinfo/dm-devel</a></pre>
      </blockquote>
      <br>
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

--------------040201070407050605050602--


--===============1990645481977254260==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============1990645481977254260==--
