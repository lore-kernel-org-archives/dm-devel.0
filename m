From: Markus Hentsch <markus.hentsch@cloudandheat.com>
Subject: Re: Usage of dm-era
Date: Mon, 26 Sep 2016 15:19:15 +0200
Message-ID: <bfe373cc-16c4-2664-b9f7-c575895c8daf@cloudandheat.com>
References: <12089ffa-c3dd-523b-2302-58445f12e737@cloudandheat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1144935052597775315=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <12089ffa-c3dd-523b-2302-58445f12e737@cloudandheat.com>
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

This is a multi-part message in MIME format.
--===============1144935052597775315==
Content-Type: multipart/alternative;
	boundary="------------AE0B481B17A1CD0A28B779BF"

This is a multi-part message in MIME format.
--------------AE0B481B17A1CD0A28B779BF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Okay, I got it now. There was a misinterpretation of how to use the era
device on my side as well as an error in the Rackcorp blog post. The era
device has to be the same size as the origin not the metadata device.
Also the era device is supposed to be used in place of the underlying
block device (for read/write).
Now it's listing the correct amount of blocks in the metadata.


Finally I'm trying to find the correct calculation of the required disk
space for the era metadata.
The dm-era docs [2] state the following formula:

(4 * nr_blocks) bytes + buffers

 1. So I assume "nr_blocks" is refering to the amount of blocks tracked
    by the era device, i.e. the same amount of blocks as listed by the
    "era_dump" output?
 2. How big is "buffers" supposed to be? Is this what "it uses a few 4k
    blocks for updating metadata" [2] refers to? What are "a few 4k
    blocks" in this context? Several blocks of 4096 bytes or blocks
    consisting of 4k sectors, i.e. 4096 * 512 bytes each?


[2] https://www.kernel.org/doc/Documentation/device-mapper/era.txt


Best Regards,

Markus Hentsch
Cloud&Heat Technologies

> Dear dm-devel community,
>
> I'm trying to get familiar with dm-era but I'm stuck.
>
> What I'm trying to achieve is to have a dm-era device which keeps
> track of changed blocks on a seperate hard drive or logical
> volume/mapping in order to create a live backup solution.
>
> The documentation on dm-era is very sparse. So far I found a Gentoo
> wiki entry, a blog entry by Rackcorp and the official kernel doc.
> I tried to come up with a basic setup using a virtual machine running
> Ubuntu 16.04.
>
> So far I was able to create a setup that looks like this:
> http://i.imgur.com/LNCPima.png
> To set this up, I came up with the following script:
> http://pastebin.com/Y3B2m7wL
> It is inspired by the setup done by Rackcorp [1]. The resulting
> 'lsblk' looks like this:
> sdb                       8:16   0  256M  0 disk=20
> `-metadev-era           252:2    0  276K  0 dm  =20
>   |-era                 252:4    0  276K  0 dm  =20
>   `-era-access          252:5    0  276K  0 dm  =20
> sdc                       8:32   0  256M  0 disk=20
> `-metadev-data          252:3    0  256M  0 dm  =20
>   |-era                 252:4    0  276K  0 dm  =20
>   `-metadev-data-access 252:6    0  256M  0 dm   /media/sdc-data
>
>
> In comparison to Rackcorp's setup, I did the following adjustment:
>
>   * i) mounting /dev/mapper/metadev-data (or the underlying sdc) or
>     ii) using it as an origin device for era, seemed to be mutually
>     exclusive
>   * that's why I created an additional linear mapping called
>     'metadev-data-access' inspired by the 'era-access' device to be
>     able to mount and write to the sdc device again
>
> Basically this setup is supposed to track changed blocks on /dev/sdc
> and uses a mounted /dev/mapper/metadev-data-access at /media/sdc-data
> to access /dev/sdc on top of the dm setup.
>
> However, when reading the era metadata via 'era_dump
> /dev/mapper/era-access', I only get this result:
> <superblock uuid=3D"" block_size=3D"4096" nr_blocks=3D"1" current_era=3D=
"1">
>   <era_array>
>     <era block=3D"0" era=3D"0"/>
>   </era_array>
> </superblock>
>
> Why is there only one block listed? Shouldn't that list exactly as
> much blocks as my 'metadev-data' device has, since it is the origin
> for the era target?
> Or is there some basic misunderstanding in my interpretation of how
> dm-era is supposed to work and be used?
>
> Please be so kind and shed some light on this!
>
> [1] http://blog.rackcorp.com/2016/03/dm-era-device-for-backups/
>
>
> Best Regards,
>
> Markus Hentsch
> Cloud&Heat Technologies
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--------------AE0B481B17A1CD0A28B779BF
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Okay, I got it now. There was a misinterpretation of how to use the
    era device on my side as well as an error in the Rackcorp blog post.
    The era device has to be the same size as the origin not the
    metadata device. Also the era device is supposed to be used in place
    of the underlying block device (for read/write).<br>
    Now it's listing the correct amount of blocks in the metadata.<br>
    <br>
    <br>
    Finally I'm trying to find the correct calculation of the required
    disk space for the era metadata.<br>
    The dm-era docs [2] state the following formula:<br>
    <pre><font size="+1">    (4 * nr_blocks) bytes + buffers</font>
</pre>
    <ol>
      <li>So I assume "nr_blocks" is refering to the amount of blocks
        tracked by the era device, i.e. the same amount of blocks as
        listed by the "era_dump" output?</li>
      <li>How big is "buffers" supposed to be? Is this what "it uses a
        few 4k blocks for updating metadata" [2] refers to? What are "a
        few 4k blocks" in this context? Several blocks of 4096 bytes or
        blocks consisting of 4k sectors, i.e. 4096 * 512 bytes each?</li>
    </ol>
    <br>
    [2] <a
      href="https://www.kernel.org/doc/Documentation/device-mapper/era.txt">https://www.kernel.org/doc/Documentation/device-mapper/era.txt</a><br>
    <br>
    <br>
    Best Regards,<br>
    <br>
    Markus Hentsch<br>
    Cloud&amp;Heat Technologies<br>
    <br>
    <blockquote
      cite="mid:12089ffa-c3dd-523b-2302-58445f12e737@cloudandheat.com"
      type="cite">
      <meta http-equiv="content-type" content="text/html;
        charset=windows-1252">
      Dear dm-devel community,<br>
      <br>
      I'm trying to get familiar with dm-era but I'm stuck.<br>
      <br>
      What I'm trying to achieve is to have a dm-era device which keeps
      track of changed blocks on a seperate hard drive or logical
      volume/mapping in order to create a live backup solution.<br>
      <br>
      The documentation on dm-era is very sparse. So far I found a
      Gentoo wiki entry, a blog entry by Rackcorp and the official
      kernel doc.<br>
      I tried to come up with a basic setup using a virtual machine
      running Ubuntu 16.04.<br>
      <br>
      So far I was able to create a setup that looks like this: <a
        moz-do-not-send="true" href="http://i.imgur.com/LNCPima.png">http://i.imgur.com/LNCPima.png</a><br>
      To set this up, I came up with the following script: <a
        moz-do-not-send="true" href="http://pastebin.com/Y3B2m7wL">http://pastebin.com/Y3B2m7wL</a><br>
      It is inspired by the setup done by Rackcorp [1]. The resulting
      'lsblk' looks like this:<br>
      <pre>sdb                       8:16   0  256M  0 disk </pre>
      <pre>`-metadev-era           252:2    0  276K  0 dm   </pre>
      <pre>  |-era                 252:4    0  276K  0 dm   </pre>
      <pre>  `-era-access          252:5    0  276K  0 dm   </pre>
      <pre>sdc                       8:32   0  256M  0 disk </pre>
      <pre>`-metadev-data          252:3    0  256M  0 dm   </pre>
      <pre>  |-era                 252:4    0  276K  0 dm   </pre>
      <pre>  `-metadev-data-access 252:6    0  256M  0 dm   /media/sdc-data</pre>
      <br>
      <br>
      In comparison to Rackcorp's setup, I did the following adjustment:<br>
      <ul>
        <li>i) mounting /dev/mapper/metadev-data (or the underlying sdc)
          or ii) using it as an origin device for era, seemed to be
          mutually exclusive</li>
        <li>that's why I created an additional linear mapping called
          'metadev-data-access' inspired by the 'era-access' device to
          be able to mount and write to the sdc device again</li>
      </ul>
      Basically this setup is supposed to track changed blocks on
      /dev/sdc and uses a mounted /dev/mapper/metadev-data-access at
      /media/sdc-data to access /dev/sdc on top of the dm setup.<br>
      <br>
      However, when reading the era metadata via 'era_dump
      /dev/mapper/era-access', I only get this result:<br>
      <pre>&lt;superblock uuid="" block_size="4096" nr_blocks="1" current_era="1"&gt;</pre>
      <pre>  &lt;era_array&gt;</pre>
      <pre>    &lt;era block="0" era="0"/&gt;</pre>
      <pre>  &lt;/era_array&gt;</pre>
      <pre>&lt;/superblock&gt;</pre>
      <br>
      Why is there only one block listed? Shouldn't that list exactly as
      much blocks as my 'metadev-data' device has, since it is the
      origin for the era target?<br>
      Or is there some basic misunderstanding in my interpretation of
      how dm-era is supposed to work and be used?<br>
      <br>
      Please be so kind and shed some light on this!<br>
      <br>
      [1] <a moz-do-not-send="true"
        href="http://blog.rackcorp.com/2016/03/dm-era-device-for-backups/">http://blog.rackcorp.com/2016/03/dm-era-device-for-backups/</a><br>
      <br>
      <br>
      Best Regards,<br>
      <br>
      Markus Hentsch<br>
      Cloud&amp;Heat Technologies<br>
      <br>
      <br>
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap="">--
dm-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a></pre>
    </blockquote>
  </body>
</html>

--------------AE0B481B17A1CD0A28B779BF--


--===============1144935052597775315==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1144935052597775315==--
