From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Possible bug in DM-RAID.
Date: Wed, 21 Oct 2015 16:11:54 +0200
Message-ID: <56279D2A.7020605@redhat.com>
References: <562659DD.1000505@gmail.com>
	<87y4ex0zl7.fsf@notabene.neil.brown.name>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7773496407593131141=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87y4ex0zl7.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============7773496407593131141==
Content-Type: multipart/alternative;
	boundary="------------030001060707090305080607"

This is a multi-part message in MIME format.
--------------030001060707090305080607
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit


Neil,

this looks like an incarnation of the md bitmap flaw (the one with the bogus
slot number) leading to the false bitmap header page index.


Austin,
this is the respective upstream commit you need to fix your problem:

commit da6fb7a9e5bd6f04f7e15070f630bdf1ea502841
Author: NeilBrown <neilb@suse.com>
Date:   Thu Oct 1 16:03:38 2015 +1000

     md/bitmap: don't pass -1 to bitmap_storage_alloc.

     Passing -1 to bitmap_storage_alloc() causes page->index to be set to
     -1, which is quite problematic.

     So only pass ->cluster_slot if mddev_is_clustered().

     Fixes: b97e92574c0b ("Use separate bitmaps for each nodes in the 
cluster")
     Cc: stable@vger.kernel.org (v4.1+)
     Signed-off-by: NeilBrown <neilb@suse.com>

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index e51de52..48b5890 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1997,7 +1997,8 @@ int bitmap_resize(struct bitmap *bitmap, sector_t 
blocks,
         if (bitmap->mddev->bitmap_info.offset || 
bitmap->mddev->bitmap_info.file)
                 ret = bitmap_storage_alloc(&store, chunks,
!bitmap->mddev->bitmap_info.external,
-                                          bitmap->cluster_slot);
+ mddev_is_clustered(bitmap->mddev)
+                                          ? bitmap->cluster_slot : 0);
         if (ret)
                 goto err;


On 10/21/2015 03:39 AM, Neil Brown wrote:
> Added dm-devel, which is probably the more appropriate list for dm
> things.
>
> NeilBrown
>
> Austin S Hemmelgarn <ahferroin7@gmail.com> writes:
>
>> I think I've stumbled upon a bug in DM-RAID.  The primary symptom is that when
>> creating a new DM-RAID based device (using either LVM or dmsetup) in a RAID1
>> configuration, it very quickly claims one by one that all of the disks failed
>> except the first, and goes degraded.  When this happens on a given system, the
>> disks always 'fail' in the reverse of the order of the mirror numbers.  All of
>> the other RAID profiles work just fine.  Curiously, it also only seems to
>> happen for 'big' devices (I haven't been able to determine exactly what the
>> minimum size is, but I see it 100% of the time with 32G devices, never with 16G
>> ones, and only intermittently with 24G).
>>
>> Here's what I got from dmesg when creating a 32G LVM volume that exhibited
>> this issue:
>> [66318.401295] device-mapper: raid: Superblocks created for new array
>> [66318.450452] md/raid1:mdX: active with 2 out of 2 mirrors
>> [66318.450467] Choosing daemon_sleep default (5 sec)
>> [66318.450482] created bitmap (32 pages) for device mdX
>> [66318.450495] attempt to access beyond end of device
>> [66318.450501] dm-91: rw=13329, want=0, limit=8192
>> [66318.450506] md: super_written gets error=-5, uptodate=0
>> [66318.450513] md/raid1:mdX: Disk failure on dm-92, disabling device.
>>                 md/raid1:mdX: Operation continuing on 1 devices.
>> [66318.459815] attempt to access beyond end of device
>> [66318.459819] dm-89: rw=13329, want=0, limit=8192
>> [66318.459822] md: super_written gets error=-5, uptodate=0
>> [66318.492852] attempt to access beyond end of device
>> [66318.492862] dm-89: rw=13329, want=0, limit=8192
>> [66318.492868] md: super_written gets error=-5, uptodate=0
>> [66318.627183] mdX: bitmap file is out of date, doing full recovery
>> [66318.714107] mdX: bitmap initialized from disk: read 3 pages, set 65536 of 65536 bits
>> [66318.782045] RAID1 conf printout:
>> [66318.782054]  --- wd:1 rd:2
>> [66318.782061]  disk 0, wo:0, o:1, dev:dm-90
>> [66318.782068]  disk 1, wo:1, o:0, dev:dm-92
>> [66318.836598] RAID1 conf printout:
>> [66318.836607]  --- wd:1 rd:2
>> [66318.836614]  disk 0, wo:0, o:1, dev:dm-90
>>
>> And here's output for a 24G LVM volume that didn't display the issue.
>> [66343.407954] device-mapper: raid: Superblocks created for new array
>> [66343.479065] md/raid1:mdX: active with 2 out of 2 mirrors
>> [66343.479078] Choosing daemon_sleep default (5 sec)
>> [66343.479101] created bitmap (24 pages) for device mdX
>> [66343.629329] mdX: bitmap file is out of date, doing full recovery
>> [66343.677374] mdX: bitmap initialized from disk: read 2 pages, set 49152 of 49152 bits
>>
>> I'm using a lightly patched version of 4.2.3
>> (the source can be found at https://github.com/ferroin/linux)
>> but none of the patches I'm using come anywhere near anything in the block layer,
>> let alone the DM/MD code.
>>
>> I've attempted to bisect this, although it got kind of complicated.  So far I've
>> determined that the first commit that I see this issue on is d3b178a: md: Skip cluster setup for dm-raid
>> Prior to that commit, I can't initialize any dm-raid devices due to the bug it fixes.
>> I have not tested anything prior to d51e4fe (the merge commit that pulled in the md-cluster code),
>> but I do distinctly remember that I did not see this issue in 3.19.
>>
>> I'll be happy to provide more info if needed.
>>
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel


--------------030001060707090305080607
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id t9LEBwDb001761

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    <br>
    Neil,<br>
    <br>
    this looks like an incarnation of the md bitmap flaw (the one with
    the bogus<br>
    slot number) leading to the false bitmap header page index.<br>
    <br>
    <br>
    Austin,<br>
    this is the respective upstream commit you need to fix your problem:<=
br>
    <br>
    commit da6fb7a9e5bd6f04f7e15070f630bdf1ea502841<br>
    Author: NeilBrown <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:n=
eilb@suse.com">&lt;neilb@suse.com&gt;</a><br>
    Date:=A0=A0 Thu Oct 1 16:03:38 2015 +1000<br>
    <br>
    =A0=A0=A0 md/bitmap: don't pass -1 to bitmap_storage_alloc.<br>
    =A0=A0=A0 <br>
    =A0=A0=A0 Passing -1 to bitmap_storage_alloc() causes page-&gt;index =
to be
    set to<br>
    =A0=A0=A0 -1, which is quite problematic.<br>
    =A0=A0=A0 <br>
    =A0=A0=A0 So only pass -&gt;cluster_slot if mddev_is_clustered().<br>
    =A0=A0=A0 <br>
    =A0=A0=A0 Fixes: b97e92574c0b ("Use separate bitmaps for each nodes i=
n the
    cluster")<br>
    =A0=A0=A0 Cc: <a class=3D"moz-txt-link-abbreviated" href=3D"mailto:st=
able@vger.kernel.org">stable@vger.kernel.org</a> (v4.1+)<br>
    =A0=A0=A0 Signed-off-by: NeilBrown <a class=3D"moz-txt-link-rfc2396E"=
 href=3D"mailto:neilb@suse.com">&lt;neilb@suse.com&gt;</a><br>
    <br>
    diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c<br>
    index e51de52..48b5890 100644<br>
    --- a/drivers/md/bitmap.c<br>
    +++ b/drivers/md/bitmap.c<br>
    @@ -1997,7 +1997,8 @@ int bitmap_resize(struct bitmap *bitmap,
    sector_t blocks,<br>
    =A0=A0=A0=A0=A0=A0=A0 if (bitmap-&gt;mddev-&gt;bitmap_info.offset ||
    bitmap-&gt;mddev-&gt;bitmap_info.file)<br>
    =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D bitmap_storage_=
alloc(&amp;store, chunks,<br>
    =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
    !bitmap-&gt;mddev-&gt;bitmap_info.external,<br>
    -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bitmap-&gt;cluster=
_slot);<br>
    +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
    mddev_is_clustered(bitmap-&gt;mddev)<br>
    +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ? bitmap-&gt;clust=
er_slot
    : 0);<br>
    =A0=A0=A0=A0=A0=A0=A0 if (ret)<br>
    =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto err;<br>
    <br>
    <br>
    <div class=3D"moz-cite-prefix">On 10/21/2015 03:39 AM, Neil Brown
      wrote:<br>
    </div>
    <blockquote cite=3D"mid:87y4ex0zl7.fsf@notabene.neil.brown.name"
      type=3D"cite">
      <pre wrap=3D"">
Added dm-devel, which is probably the more appropriate list for dm
things.

NeilBrown

Austin S Hemmelgarn <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:ahf=
erroin7@gmail.com">&lt;ahferroin7@gmail.com&gt;</a> writes:

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">I think I've stumbled upon a bug in DM-RAID.  The =
primary symptom is that when
creating a new DM-RAID based device (using either LVM or dmsetup) in a RA=
ID1
configuration, it very quickly claims one by one that all of the disks fa=
iled
except the first, and goes degraded.  When this happens on a given system=
, the
disks always 'fail' in the reverse of the order of the mirror numbers.  A=
ll of
the other RAID profiles work just fine.  Curiously, it also only seems to
happen for 'big' devices (I haven't been able to determine exactly what t=
he
minimum size is, but I see it 100% of the time with 32G devices, never wi=
th 16G
ones, and only intermittently with 24G).

Here's what I got from dmesg when creating a 32G LVM volume that exhibite=
d
this issue:
[66318.401295] device-mapper: raid: Superblocks created for new array
[66318.450452] md/raid1:mdX: active with 2 out of 2 mirrors
[66318.450467] Choosing daemon_sleep default (5 sec)
[66318.450482] created bitmap (32 pages) for device mdX
[66318.450495] attempt to access beyond end of device
[66318.450501] dm-91: rw=3D13329, want=3D0, limit=3D8192
[66318.450506] md: super_written gets error=3D-5, uptodate=3D0
[66318.450513] md/raid1:mdX: Disk failure on dm-92, disabling device.
               md/raid1:mdX: Operation continuing on 1 devices.
[66318.459815] attempt to access beyond end of device
[66318.459819] dm-89: rw=3D13329, want=3D0, limit=3D8192
[66318.459822] md: super_written gets error=3D-5, uptodate=3D0
[66318.492852] attempt to access beyond end of device
[66318.492862] dm-89: rw=3D13329, want=3D0, limit=3D8192
[66318.492868] md: super_written gets error=3D-5, uptodate=3D0
[66318.627183] mdX: bitmap file is out of date, doing full recovery
[66318.714107] mdX: bitmap initialized from disk: read 3 pages, set 65536=
 of 65536 bits
[66318.782045] RAID1 conf printout:
[66318.782054]  --- wd:1 rd:2
[66318.782061]  disk 0, wo:0, o:1, dev:dm-90
[66318.782068]  disk 1, wo:1, o:0, dev:dm-92
[66318.836598] RAID1 conf printout:
[66318.836607]  --- wd:1 rd:2
[66318.836614]  disk 0, wo:0, o:1, dev:dm-90

And here's output for a 24G LVM volume that didn't display the issue.
[66343.407954] device-mapper: raid: Superblocks created for new array
[66343.479065] md/raid1:mdX: active with 2 out of 2 mirrors
[66343.479078] Choosing daemon_sleep default (5 sec)
[66343.479101] created bitmap (24 pages) for device mdX
[66343.629329] mdX: bitmap file is out of date, doing full recovery
[66343.677374] mdX: bitmap initialized from disk: read 2 pages, set 49152=
 of 49152 bits

I'm using a lightly patched version of 4.2.3
(the source can be found at <a class=3D"moz-txt-link-freetext" href=3D"ht=
tps://github.com/ferroin/linux">https://github.com/ferroin/linux</a>)
but none of the patches I'm using come anywhere near anything in the bloc=
k layer,
let alone the DM/MD code.

I've attempted to bisect this, although it got kind of complicated.  So f=
ar I've
determined that the first commit that I see this issue on is d3b178a: md:=
 Skip cluster setup for dm-raid
Prior to that commit, I can't initialize any dm-raid devices due to the b=
ug it fixes.
I have not tested anything prior to d51e4fe (the merge commit that pulled=
 in the md-cluster code),
but I do distinctly remember that I did not see this issue in 3.19.

I'll be happy to provide more info if needed.
</pre>
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
    </blockquote>
    <br>
  </body>
</html>

--------------030001060707090305080607--


--===============7773496407593131141==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============7773496407593131141==--
