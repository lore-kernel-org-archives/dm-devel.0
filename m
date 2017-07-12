From: Renesanso <renesanso@yandex.ru>
Subject: Re: dm-integrity
Date: Wed, 12 Jul 2017 21:30:06 +0300
Message-ID: <f694c673-96e4-692f-c3a2-31f2c5d07f84@yandex.ru>
References: <bbf2a91d-2eac-5b10-903d-50939acfb57a@yandex.ru>
	<4d2e0176-071a-1cb4-3eaa-3c3552a2ce09@gmail.com>
	<0d01c698-211e-a969-8c4a-e6bb4ab2cf9b@yandex.ru>
	<96314674-1b66-ce91-732e-17901d1f3236@yandex.ru>
	<ce9f9bdb-cb04-097d-5628-4f4ea0155195@gmail.com>
	<559a498c-c91a-62e0-aef5-783210d245b6@yandex.ru>
	<7c811e93-ff1c-420d-bc99-2b234d13ae30@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4933697956981038449=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7c811e93-ff1c-420d-bc99-2b234d13ae30@gmail.com>
Content-Language: ru-RU
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, dmitry.kasatkin@huawei.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============4933697956981038449==
Content-Type: multipart/alternative;
	boundary="------------C66000A732DAB859B84CE4FA"
Content-Language: ru-RU

This is a multi-part message in MIME format.
--------------C66000A732DAB859B84CE4FA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi.*Please, give link to your blog.*

I succesfully create configuration for virtual machines (and it works 
fine), test force reboot many time (and machine have some problem with 
ACPI table, thats why SATA controller reset links for all disks (now it 
fixed), but only one disk is out from md-raid and system worked. when 
controller problem was it heavy test I/O). E.g. I think, that with 
journal and crc32 dm-integrity is stable. In one of tests I write 1Mb 
with dd (with skip), then read (cat > /dev/null) LVM-partition on top of 
md. dm-intergity succesfully detect corrution, generate i/o error and md 
fencing disk, but still works.


I use this configuration: 7 SATA disks => each with own dm-integrity => 
md raid6 6 disks + 1 spare disk -> LVM for virtual machines.

If any disk gives up buggy info, dm-integrity will generate i/o error 
and md fence disk from raid, but system continious working. You can say, 
that I must use ZFS for this case, but I don't have SSD-cache, and 
without SSD-cache ZFS is too slow, SLOWSLOWSLOW in future, when virtual 
machines disks will fragment, e.g. CoW. My solution gives integrity 
opportunity without fragmentation penalty.

Please, use this info in your blog, becase in production we want not 
only know, that info from disk is buggy, but read non-buggy info and 
continue working. If you will paste to your blog, please. change serial 
numbers of my disks. :)

*And one more think: after system boot and assemble script executed, it 
eates ~4Gb RAM (only dm-intergity). What parameter doing it?*


I use this sript on boot to assemle raid:

cd /root/local/integrity/src

LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
--integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
--journal-commit-time=60000 open 
/dev/disk/by-id/ata-WDC_WD5000AADS-00S9B0_WD-WCAV90886975-part1 
integra-WCAV90886975

LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
--integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
--journal-commit-time=60000 open 
/dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0SJX4T6-part1 
integra-WCC3F0SJX4T6

LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
--integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
--journal-commit-time=60000 open 
/dev/disk/by-id/ata-WDC_WD5001AALS-00J7B0_WD-WMATV7467797-part1 
integra-WMATV7467797

LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
--integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
--journal-commit-time=60000 open 
/dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0YY89KN-part1 
integra-WCC3F0YY89KN

LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
--integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
--journal-commit-time=60000 open 
/dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F5HF3NN0-part1 
integra-WCC3F5HF3NN0

LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
--integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
--journal-commit-time=60000 open 
/dev/disk/by-id/ata-WDC_WD5003AZEX-00K3CA0_WD-WCC6Y4XEA1RS-part1 
integra-WCC6Y4XEA1RS

LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
--integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
--journal-commit-time=60000 open 
/dev/mapper/vg--super--blue-lv--super--spare integra-spare

cd /

mdadm --assemble --scan

sleep 6

echo 50000 > /proc/sys/dev/raid/speed_limit_min

echo 500000 > /proc/sys/dev/raid/speed_limit_max

echo 32768 > /sys/block/md0/md/stripe_cache_size

And this to create:

LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup -v 
--sector-size=512 --integrity=crc32 --tag-size 32 
--buffer-sectors=414096 --journal-size=836870912 format 
/dev/disk/by-id/ata-WDC_WD5000AADS-00S9B0_WD-WCAV90886975-part1 ##-> 
../../sda1 LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' 
./integritysetup -v --sector-size=512 --integrity=crc32 --tag-size 32 
--buffer-sectors=414096 --journal-size=836870912 format 
/dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0SJX4T6-part1 ## -> 
../../sdb1 LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' 
./integritysetup -v --sector-size=512 --integrity=crc32 --tag-size 32 
--buffer-sectors=414096 --journal-size=836870912 format 
/dev/disk/by-id/ata-WDC_WD5001AALS-00J7B0_WD-WMATV7467797-part1 ##-> 
../../sdc1 LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' 
./integritysetup -v --sector-size=512 --integrity=crc32 --tag-size 32 
--buffer-sectors=414096 --journal-size=836870912 format 
/dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0YY89KN-part1 ##-> 
../../sdd1 LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' 
./integritysetup -v --sector-size=512 --integrity=crc32 --tag-size 32 
--buffer-sectors=414096 --journal-size=836870912 format 
/dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F5HF3NN0-part1 ## -> 
../../sde1 LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' 
./integritysetup -v --sector-size=512 --integrity=crc32 --tag-size 32 
--buffer-sectors=414096 --journal-size=836870912 format 
/dev/disk/by-id/ata-WDC_WD5003AZEX-00K3CA0_WD-WCC6Y4XEA1RS-part1 ## -> 
../../sdf1 LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' 
./integritysetup -v --sector-size=512 --integrity=crc32 --tag-size 32 
--buffer-sectors=414096 --journal-size=836870912 format 
/dev/mapper/vg--super--blue-lv--super--spare

mdadm --verbose --create /dev/md0  --bitmap=internal 
--bitmap-chunk=524288 -c 128  --level=6  --raid-devices=6 
/dev/mapper/integra-WCAV90886975 /dev/mapper/integra-WCC3F0SJX4T6 
/dev/mapper/integra-WMATV7467797 /dev/mapper/integra-WCC3F0YY89KN 
/dev/mapper/integra-WCC3F5HF3NN0 /dev/mapper/integra-WCC6Y4XEA1RS 
--spare-devices=1 /dev/mapper/integra-spare


11.07.2017 12:52, Milan Broz пишет:
> On 07/10/2017 05:53 PM, Renesanso wrote:
>> And I have other question: is it ready for production in crc32+journal
>> mode? Not as like IBM-like production, I mean, but it is not full> buggy, but stable now? :)
> Hi,
>
> well, there are some tests, we found and fixed some issues in 4.12-rcX
> (so be sure you are using code from released 4.12.0 or later!).
>
> So I hope it is stable, but it would definitely need more users to test.
> If you find any problem, crash or anything related to kernel code, please send
> a report to the dm-devel@redhat.com list.
>
> Thanks,
> Milan


--------------C66000A732DAB859B84CE4FA
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">Hi.<b> Please, give link to your blog.</b><br>
      <br>
      I succesfully create configuration for virtual machines (and it
      works fine), test force reboot many time (and machine have some
      problem with ACPI table, thats why SATA controller reset links for
      all disks (now it fixed), but only one disk is out from md-raid
      and system worked. when controller problem was it heavy test I/O).
      E.g. I think, that with journal and crc32 dm-integrity is stable.
      In one of tests I write 1Mb with dd (with skip), then read (cat
      &gt; /dev/null) LVM-partition on top of md. dm-intergity
      succesfully detect corrution, generate i/o error and md fencing
      disk, but still works.<br>
      <br>
      <br>
      I use this configuration: 7 SATA disks =&gt; each with own
      dm-integrity =&gt; md raid6 6 disks + 1 spare disk -&gt; LVM for
      virtual machines.<br>
      <br>
      If any disk gives up buggy info, dm-integrity will generate i/o
      error and md fence disk from raid, but system continious working.
      You can say, that I must use ZFS for this case, but I don't have
      SSD-cache, and without SSD-cache ZFS is too slow, SLOWSLOWSLOW in
      future, when virtual machines disks will fragment, e.g. CoW. My
      solution gives integrity opportunity without fragmentation
      penalty.<br>
      <br>
      Please, use this info in your blog, becase in production we want
      not only know, that info from disk is buggy, but read non-buggy
      info and continue working. If you will paste to your blog, please.
      change serial numbers of my disks. :)<br>
      <br>
      <b>And one more think: after system boot and assemble script
        executed, it eates ~4Gb RAM (only dm-intergity). What parameter
        doing it?</b><br>
      <br>
      <br>
      I use this sript on boot to assemle raid:<br>
      <style type="text/css">
p, li { white-space: pre-wrap; }
</style>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">cd /root/local/integrity/src</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup --integrity=crc32 --buffer-sectors=414096  --journal-watermark=70  --journal-commit-time=60000  open  /dev/disk/by-id/ata-WDC_WD5000AADS-00S9B0_WD-WCAV90886975-part1 integra-WCAV90886975</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup --integrity=crc32 --buffer-sectors=414096  --journal-watermark=70  --journal-commit-time=60000  open   /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0SJX4T6-part1 integra-WCC3F0SJX4T6</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup --integrity=crc32 --buffer-sectors=414096  --journal-watermark=70  --journal-commit-time=60000  open   /dev/disk/by-id/ata-WDC_WD5001AALS-00J7B0_WD-WMATV7467797-part1 integra-WMATV7467797</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup --integrity=crc32 --buffer-sectors=414096  --journal-watermark=70  --journal-commit-time=60000  open   /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0YY89KN-part1 integra-WCC3F0YY89KN</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup --integrity=crc32 --buffer-sectors=414096  --journal-watermark=70  --journal-commit-time=60000  open  /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F5HF3NN0-part1 integra-WCC3F5HF3NN0</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup --integrity=crc32 --buffer-sectors=414096  --journal-watermark=70  --journal-commit-time=60000  open  /dev/disk/by-id/ata-WDC_WD5003AZEX-00K3CA0_WD-WCC6Y4XEA1RS-part1 integra-WCC6Y4XEA1RS</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup --integrity=crc32 --buffer-sectors=414096  --journal-watermark=70  --journal-commit-time=60000  open  /dev/mapper/vg--super--blue-lv--super--spare integra-spare</p>
      <p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">
</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">cd /</p>
      <p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">
</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">mdadm --assemble --scan</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">sleep 6</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">echo 50000 &gt; /proc/sys/dev/raid/speed_limit_min</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">echo 500000 &gt; /proc/sys/dev/raid/speed_limit_max</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">echo 32768 &gt; /sys/block/md0/md/stripe_cache_size</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">
</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">And this to create:</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">
</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup  -v --sector-size=512 --integrity=crc32  --tag-size 32 --buffer-sectors=414096 --journal-size=836870912  format /dev/disk/by-id/ata-WDC_WD5000AADS-00S9B0_WD-WCAV90886975-part1 ##-&gt; ../../sda1
LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup  -v --sector-size=512 --integrity=crc32  --tag-size 32 --buffer-sectors=414096 --journal-size=836870912  format  /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0SJX4T6-part1 ## -&gt; ../../sdb1
LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup  -v --sector-size=512 --integrity=crc32  --tag-size 32 --buffer-sectors=414096 --journal-size=836870912  format  /dev/disk/by-id/ata-WDC_WD5001AALS-00J7B0_WD-WMATV7467797-part1 ##-&gt; ../../sdc1
LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup  -v --sector-size=512 --integrity=crc32  --tag-size 32 --buffer-sectors=414096 --journal-size=836870912  format  /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0YY89KN-part1 ##-&gt; ../../sdd1
LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup  -v --sector-size=512 --integrity=crc32  --tag-size 32 --buffer-sectors=414096 --journal-size=836870912  format  /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F5HF3NN0-part1 ## -&gt; ../../sde1
LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup  -v --sector-size=512 --integrity=crc32  --tag-size 32 --buffer-sectors=414096 --journal-size=836870912  format  /dev/disk/by-id/ata-WDC_WD5003AZEX-00K3CA0_WD-WCC6Y4XEA1RS-part1 ## -&gt; ../../sdf1
LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup  -v --sector-size=512 --integrity=crc32  --tag-size 32 --buffer-sectors=414096 --journal-size=836870912  format /dev/mapper/vg--super--blue-lv--super--spare
</p>
      <p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">
</p>
      mdadm --verbose --create /dev/md0  --bitmap=internal
      --bitmap-chunk=524288 -c 128  --level=6  --raid-devices=6
      /dev/mapper/integra-WCAV90886975 /dev/mapper/integra-WCC3F0SJX4T6
      /dev/mapper/integra-WMATV7467797 /dev/mapper/integra-WCC3F0YY89KN
      /dev/mapper/integra-WCC3F5HF3NN0 /dev/mapper/integra-WCC6Y4XEA1RS
      --spare-devices=1 /dev/mapper/integra-spare<br>
      <br>
      <br>
      11.07.2017 12:52, Milan Broz пишет:<br>
    </div>
    <blockquote type="cite"
      cite="mid:7c811e93-ff1c-420d-bc99-2b234d13ae30@gmail.com">
      <pre wrap="">On 07/10/2017 05:53 PM, Renesanso wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">And I have other question: is it ready for production in crc32+journal 
mode? Not as like IBM-like production, I mean, but it is not full&gt; buggy, but stable now? :)
</pre>
      </blockquote>
      <pre wrap="">
Hi,

well, there are some tests, we found and fixed some issues in 4.12-rcX
(so be sure you are using code from released 4.12.0 or later!).

So I hope it is stable, but it would definitely need more users to test.
If you find any problem, crash or anything related to kernel code, please send
a report to the <a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a> list.

Thanks,
Milan
</pre>
    </blockquote>
    <p>
</p>
  </body>
</html>

--------------C66000A732DAB859B84CE4FA--


--===============4933697956981038449==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4933697956981038449==--
