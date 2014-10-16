From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm raid: ensure metadata IO matches device block
	size.
Date: Thu, 16 Oct 2014 15:31:12 +0200
Message-ID: <543FC8A0.8000709@redhat.com>
References: <20141015121907.265b3aed@notabene.brown>	<20141015025550.GC19683@redhat.com>	<20141015144003.7b17752d@notabene.brown>	<20141015131307.GA23955@redhat.com>
	<20141016080054.7c906901@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7937262608680189545=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141016080054.7c906901@notabene.brown>
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
Cc: lwang@suse.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============7937262608680189545==
Content-Type: multipart/alternative;
	boundary="------------050202030800010309030301"

This is a multi-part message in MIME format.
--------------050202030800010309030301
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit


On 10/15/2014 11:00 PM, NeilBrown wrote:
> On Wed, 15 Oct 2014 09:13:08 -0400 Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Tue, Oct 14 2014 at 11:40pm -0400,
>> NeilBrown <neilb@suse.de> wrote:
>>
>>> On Tue, 14 Oct 2014 22:55:50 -0400 Mike Snitzer <snitzer@redhat.com> wrote:
>>>
>>>> On Tue, Oct 14 2014 at  9:19pm -0400,
>>>> NeilBrown <neilb@suse.de> wrote:
>>>>
>>>>> dm_raid_superblock is 512.
>>>>> Reading or writing this on a 512-byte sector works fine.
>>>>> On a 4096-byte sector device, this fails.
>>>>>
>>>>> If we round up rdev->sb_size to match the block size of
>>>>> the device, all IO will work correctly.
>>>>>
>>>>> Reported-by: "Liuhua Wang" <lwang@suse.com>
>>>>> Signed-off-by: NeilBrown <neilb@suse.de>
>>>>>
>>>>> ---
>>>>> this issue has been discussed already a bit. See email thread
>>>>>   Subject: Re: [dm-devel] [PATCH] fix mirror device creation with lvcreate failed
>>>>> I think this is the best fix.  It handles boths read and writes, and (I think)
>>>>> at the best level.
>>>>>
>>>>> Thanks,
>>>>> NeilBrown
>>>>>
>>>>>
>>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>>>> index 4880b69e2e9e..31bdd73bc368 100644
>>>>> --- a/drivers/md/dm-raid.c
>>>>> +++ b/drivers/md/dm-raid.c
>>>>> @@ -858,7 +858,8 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
>>>>>   	uint64_t events_sb, events_refsb;
>>>>>   
>>>>>   	rdev->sb_start = 0;
>>>>> -	rdev->sb_size = sizeof(*sb);
>>>>> +	rdev->sb_size = roundup(sizeof(*sb),
>>>>> +				bdev_logical_block_size(rdev->meta_bdev));
>>>>>   
>>>>>   	ret = read_disk_sb(rdev, rdev->sb_size);
>>>>>   	if (ret)
>>>> Wouldn't it be better to use bdev_physical_block_size()?
>>>>
>>>> Even on a 4K device that emulates 512b logical sectors it is better to
>>>> use the physical block size (4K).
>>>
>>> _logical_ is the smallest value for which the IO actually works.
>>> And the goal of the change is to make it work.
>>>
>>> I don't object to using _physical_, but it isn't clear to me how I would
>>> justify that as "correct".
>>>
>>> A big question in my mind is: how much space does LVM reserve in this device
>>> for the metadata?  It seems reasonable to assume that it reserves at least
>>> 1 logical block.  If the API guarantees that at least one physical block is
>>> reserved, then that would justify using _physical_.

dm-raid uses 512 bytes for its superblock including padding in the 
current code
(with way less payload), followed by the bitmap at offset 4096 bytes.

With Neil's proposal, the padding will be avoided alltogether.

So logical looks fine to me, because physical may well be more than 4K 
in the future.
Admittingly a longer time in the future though.

If that happens, we'd end up with the bitmap start at offset 4096 bytes 
in the same physical sector
and would have to cope with it plus the issues involved with 4K page sizes.

In order to prevent this to occur unrecognized in dm/md later,
we should have an "if (rdev->sb_size > PAGE_SIZE) return -EINVAL;" after 
the setting
of rdev->sb_size in dm-raid.c and appropriate checks in md.c.

BTW: even with additions to the dm-raid superblock I have to make in 
order to allow for reshaping etc.,
          it's paylod is going to stay < 512 bytes.

Heinz

>> I'll have to check with Jon and/or Heinz on this point.
>>
>>> A quick look at the code shows that the bitmap superblock is placed 4K after
>>> the start of the metadata.
>> "the code" being the MD kernel code right?  Any reason not to export a
>> #define that reflects the space MD reserves and just have dm-raid use that?
> No, "the code" being
>
> 	mddev->bitmap_info.offset = 4096 >> 9; /* Enable bitmap creation */
> 	rdev->mddev->bitmap_info.default_offset = 4096 >> 9;
>
> in super_validate in dm-raid.c.
> i.e. dm-raid specific code.
> md doesn't reserve space, it just uses what it is told to.  Told either by
> mdadm via the md superblock or by dm-raid.
>
> NeilBrown
>
>> Starting to feel like hardcoding 4K is the right thing to do given the
>> current code.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------050202030800010309030301
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id s9GDVOBL028288

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    <br>
    <div class=3D"moz-cite-prefix">On 10/15/2014 11:00 PM, NeilBrown
      wrote:<br>
    </div>
    <blockquote cite=3D"mid:20141016080054.7c906901@notabene.brown"
      type=3D"cite">
      <pre wrap=3D"">On Wed, 15 Oct 2014 09:13:08 -0400 Mike Snitzer <a c=
lass=3D"moz-txt-link-rfc2396E" href=3D"mailto:snitzer@redhat.com">&lt;sni=
tzer@redhat.com&gt;</a> wrote:

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">On Tue, Oct 14 2014 at 11:40pm -0400,
NeilBrown <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:neilb@suse.de=
">&lt;neilb@suse.de&gt;</a> wrote:

</pre>
        <blockquote type=3D"cite">
          <pre wrap=3D"">On Tue, 14 Oct 2014 22:55:50 -0400 Mike Snitzer =
<a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:snitzer@redhat.com">&lt=
;snitzer@redhat.com&gt;</a> wrote:

</pre>
          <blockquote type=3D"cite">
            <pre wrap=3D"">On Tue, Oct 14 2014 at  9:19pm -0400,
NeilBrown <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:neilb@suse.de=
">&lt;neilb@suse.de&gt;</a> wrote:

</pre>
            <blockquote type=3D"cite">
              <pre wrap=3D"">
dm_raid_superblock is 512.
Reading or writing this on a 512-byte sector works fine.
On a 4096-byte sector device, this fails.

If we round up rdev-&gt;sb_size to match the block size of
the device, all IO will work correctly.

Reported-by: "Liuhua Wang" <a class=3D"moz-txt-link-rfc2396E" href=3D"mai=
lto:lwang@suse.com">&lt;lwang@suse.com&gt;</a>
Signed-off-by: NeilBrown <a class=3D"moz-txt-link-rfc2396E" href=3D"mailt=
o:neilb@suse.de">&lt;neilb@suse.de&gt;</a>

---
this issue has been discussed already a bit. See email thread
 Subject: Re: [dm-devel] [PATCH] fix mirror device creation with lvcreate=
 failed
I think this is the best fix.  It handles boths read and writes, and (I t=
hink)
at the best level.

Thanks,
NeilBrown


diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69e2e9e..31bdd73bc368 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -858,7 +858,8 @@ static int super_load(struct md_rdev *rdev, struct md=
_rdev *refdev)
 	uint64_t events_sb, events_refsb;
=20
 	rdev-&gt;sb_start =3D 0;
-	rdev-&gt;sb_size =3D sizeof(*sb);
+	rdev-&gt;sb_size =3D roundup(sizeof(*sb),
+				bdev_logical_block_size(rdev-&gt;meta_bdev));
=20
 	ret =3D read_disk_sb(rdev, rdev-&gt;sb_size);
 	if (ret)
</pre>
            </blockquote>
            <pre wrap=3D"">
Wouldn't it be better to use bdev_physical_block_size()?

Even on a 4K device that emulates 512b logical sectors it is better to
use the physical block size (4K).
</pre>
          </blockquote>
          <pre wrap=3D"">

_logical_ is the smallest value for which the IO actually works.
And the goal of the change is to make it work.

I don't object to using _physical_, but it isn't clear to me how I would
justify that as "correct".

A big question in my mind is: how much space does LVM reserve in this dev=
ice
for the metadata?  It seems reasonable to assume that it reserves at leas=
t
1 logical block.  If the API guarantees that at least one physical block =
is
reserved, then that would justify using _physical_.
</pre>
        </blockquote>
      </blockquote>
    </blockquote>
    <br>
    dm-raid uses 512 bytes for its superblock including padding in the
    current code<br>
    (with way less payload), followed by the bitmap at offset 4096
    bytes.<br>
    <br>
    With Neil's proposal, the padding will be avoided alltogether.<br>
    <br>
    So logical looks fine to me, because physical may well be more than
    4K in the future.<br>
    Admittingly a longer time in the future though.<br>
    <br>
    If that happens, we'd end up with the bitmap start at offset 4096
    bytes in the same physical sector<br>
    and would have to cope with it plus the issues involved with 4K page
    sizes.<br>
    <br>
    In order to prevent this to occur unrecognized in dm/md later,<br>
    we should have an "if (rdev-&gt;sb_size &gt; PAGE_SIZE) return
    -EINVAL;" after the setting<br>
    of rdev-&gt;sb_size in dm-raid.c and appropriate checks in md.c.<br>
    <br>
    BTW: even with additions to the dm-raid superblock I have to make in
    order to allow for reshaping etc.,<br>
    =A0=A0=A0=A0=A0=A0=A0=A0 it's paylod is going to stay &lt; 512 bytes.=
<br>
    <br>
    Heinz<br>
    <br>
    <blockquote cite=3D"mid:20141016080054.7c906901@notabene.brown"
      type=3D"cite">
      <blockquote type=3D"cite">
        <pre wrap=3D"">
I'll have to check with Jon and/or Heinz on this point.

</pre>
        <blockquote type=3D"cite">
          <pre wrap=3D"">A quick look at the code shows that the bitmap s=
uperblock is placed 4K after
the start of the metadata.
</pre>
        </blockquote>
        <pre wrap=3D"">
"the code" being the MD kernel code right?  Any reason not to export a
#define that reflects the space MD reserves and just have dm-raid use tha=
t?
</pre>
      </blockquote>
      <pre wrap=3D"">
No, "the code" being

	mddev-&gt;bitmap_info.offset =3D 4096 &gt;&gt; 9; /* Enable bitmap creat=
ion */
	rdev-&gt;mddev-&gt;bitmap_info.default_offset =3D 4096 &gt;&gt; 9;

in super_validate in dm-raid.c.
i.e. dm-raid specific code.
md doesn't reserve space, it just uses what it is told to.  Told either b=
y
mdadm via the md superblock or by dm-raid.

NeilBrown

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">
Starting to feel like hardcoding 4K is the right thing to do given the
current code.
</pre>
      </blockquote>
      <pre wrap=3D"">
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
    <br>
  </body>
</html>

--------------050202030800010309030301--


--===============7937262608680189545==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============7937262608680189545==--
