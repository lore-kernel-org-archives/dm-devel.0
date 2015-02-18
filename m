From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 0/3] md raid: enhancements to support the
 device mapper dm-raid target
Date: Wed, 18 Feb 2015 12:50:32 +0100
Message-ID: <54E47C88.1080203@redhat.com>
References: <1423853282-6218-1-git-send-email-heinzm@redhat.com>
	<20150218130328.3ce5ab53@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8330457477897289339=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150218130328.3ce5ab53@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: neilbrown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============8330457477897289339==
Content-Type: multipart/alternative;
	boundary="------------090303020109050104000106"

This is a multi-part message in MIME format.
--------------090303020109050104000106
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 02/18/2015 03:03 AM, NeilBrown wrote:
> On Fri, 13 Feb 2015 19:47:59 +0100 heinzm@redhat.com wrote:
>
>> From: Heinz Mauelshagen <heinzm@redhat.com>
>>
>> I'm enhancing the device mapper raid target (dm-raid) to take
>> advantage of so far unused md raid kernel funtionality:
>> takeover, reshape, resize, addition and removal of devices to/from raid sets.
>>
>> This series of patches remove constraints doing so.
>>
>>
>> Patch #1:
>> add 2 API functions to allow dm-raid to access the raid takeover
>> and resize functionality (namely md_takeover() and md_resize());
>> reshape APIs are not needed in lieu of the existing personalilty ones
>>
>> Patch #2:
>> because device mapper core manages a request queue per mapped device
>> utilizing the md make_request API to pass on bios via the dm-raid target,
>> no md instance underneath it needs to manage a request queue of its own.
>> Thus dm-raid can't use the md raid0 personality as is, because the latter
>> accesses the request queue unconditionally in 3 places via mddev->queue
>> which this patch addresses.
>>
>> Patch #3:
>> when dm-raid processes a down takeover to raid0, it needs to destroy
>> any existing bitmap, because raid0 does not require one. The patch
>> exports the bitmap_destroy() API to allow dm-raid to remove bitmaps.
>>
>>
>> Heinz Mauelshagen (3):
>>    md core:   add 2 API functions for takeover and resize to support dm-raid
>>    md raid0:  access mddev->queue (request queue member) conditionally
>>               because it is not set when accessed from dm-raid
>>    md bitmap: export bitmap_destroy() to support dm-raid down takover to raid0
>>
>>   drivers/md/bitmap.c |  1 +
>>   drivers/md/md.c     | 39 ++++++++++++++++++++++++++++++---------
>>   drivers/md/md.h     |  3 +++
>>   drivers/md/raid0.c  | 48 +++++++++++++++++++++++++++---------------------
>>   4 files changed, 61 insertions(+), 30 deletions(-)
>>
> Hi Heinz,
>   I don't object to these patches if you will find the exported functionality
>   useful, but I am a little surprised by them.

Hi Neil,

I find them useful to allow for atomic takeover using the already given 
md raid
code rather than duplicating ACID takeover in dm-raid/lvm. If I'd not 
use md for this,
I'd have to keep copies of the given md superblocks and restore them in case
the assembly of the array failed and superblocks have been updated.

>
>   I would expect that dm-raid wouldn't ask md to 'takeover' from one level to
>   another, but instead would
>     - suspend the dm device
>     - dismantle the array using the old level
>     - assemble the array using the new level
>     - resume the dm device

That scenario is on my TODO, because it is for instance paritcularly 
useful to
convert a "striped" array (or a "raid0" array without metadata for that 
purpose)
directly into a raid6_n_6 one (i.e. dedicated xor and syndrome devices)
thus avoding any interim levels.
In these cases, I'd only need to drop the metadata devs allocations if
the array does not start up properly and restart the previous mapping.


>
>   The reason md needs 'takeover' is because it doesn't have the same
>   device/target separation that dm does.

Correct.
Nonetheless, I found accessing md's takeover functionality still useful
for the atomic updates to be simpler in dm/lvm.

>
>   I was particularly surprised that you wanted to use md/raid0.c  It is no
>   better than dm/dm-stripe.c and managing two different stripe engines under
>   LVM doesn't see like a good idea.

I actually see differences in performance which I have not explained yet.

In some cases, dm-stripe performs better, in others md raid0 does for 
the same mappings
and load; exact same mappings are possible, because I've got patches to 
lvconvert back
and forth between "striped" and "raid0", hence accesing exactly the same 
physical extents.

So supporting "raid0" in dm-raid is senseful for 3 reasons:
- replace dm-stripe with md raid0
- atomic md takeover from "raid0" -> "raid5"
- potential performance implications

>
>   Is there some reason that I have missed which makes it easier to use
>   'takeover' rather than suspend/resume?

Use md takover for atomic updates as mentioned above.

You don't have issues with md_resize() which I use to shrink existing 
arrays?

Thanks,
Heinz

>
> Thanks,
> NeilBrown
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------090303020109050104000106
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    On 02/18/2015 03:03 AM, NeilBrown wrote:<br>
    <blockquote cite="mid:20150218130328.3ce5ab53@notabene.brown"
      type="cite">
      <pre wrap="">On Fri, 13 Feb 2015 19:47:59 +0100 <a class="moz-txt-link-abbreviated" href="mailto:heinzm@redhat.com">heinzm@redhat.com</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="">From: Heinz Mauelshagen <a class="moz-txt-link-rfc2396E" href="mailto:heinzm@redhat.com">&lt;heinzm@redhat.com&gt;</a>

I'm enhancing the device mapper raid target (dm-raid) to take
advantage of so far unused md raid kernel funtionality:
takeover, reshape, resize, addition and removal of devices to/from raid sets.

This series of patches remove constraints doing so.


Patch #1:
add 2 API functions to allow dm-raid to access the raid takeover
and resize functionality (namely md_takeover() and md_resize());
reshape APIs are not needed in lieu of the existing personalilty ones

Patch #2:
because device mapper core manages a request queue per mapped device
utilizing the md make_request API to pass on bios via the dm-raid target,
no md instance underneath it needs to manage a request queue of its own.
Thus dm-raid can't use the md raid0 personality as is, because the latter
accesses the request queue unconditionally in 3 places via mddev-&gt;queue
which this patch addresses.

Patch #3:
when dm-raid processes a down takeover to raid0, it needs to destroy
any existing bitmap, because raid0 does not require one. The patch
exports the bitmap_destroy() API to allow dm-raid to remove bitmaps.


Heinz Mauelshagen (3):
  md core:   add 2 API functions for takeover and resize to support dm-raid
  md raid0:  access mddev-&gt;queue (request queue member) conditionally
             because it is not set when accessed from dm-raid
  md bitmap: export bitmap_destroy() to support dm-raid down takover to raid0

 drivers/md/bitmap.c |  1 +
 drivers/md/md.c     | 39 ++++++++++++++++++++++++++++++---------
 drivers/md/md.h     |  3 +++
 drivers/md/raid0.c  | 48 +++++++++++++++++++++++++++---------------------
 4 files changed, 61 insertions(+), 30 deletions(-)

</pre>
      </blockquote>
      <pre wrap="">
Hi Heinz,
 I don't object to these patches if you will find the exported functionality
 useful, but I am a little surprised by them.</pre>
    </blockquote>
    <br>
    Hi Neil,<br>
    <br>
    I find them useful to allow for atomic takeover using the already
    given md raid<br>
    code rather than duplicating ACID takeover in dm-raid/lvm. If I'd
    not use md for this,<br>
    I'd have to keep copies of the given md superblocks and restore them
    in case<br>
    the assembly of the array failed and superblocks have been updated.<br>
    <br>
    <blockquote cite="mid:20150218130328.3ce5ab53@notabene.brown"
      type="cite">
      <pre wrap="">

 I would expect that dm-raid wouldn't ask md to 'takeover' from one level to
 another, but instead would
   - suspend the dm device
   - dismantle the array using the old level
   - assemble the array using the new level
   - resume the dm device</pre>
    </blockquote>
    <br>
    That scenario is on my TODO, because it is for instance paritcularly
    useful to<br>
    convert a "striped" array (or a "raid0" array without metadata for
    that purpose)<br>
    directly into a raid6_n_6 one (i.e. dedicated xor and syndrome
    devices)<br>
    thus avoding any interim levels.<br>
    In these cases, I'd only need to drop the metadata devs allocations
    if<br>
    the array does not start up properly and restart the previous
    mapping.<br>
    <br>
    <br>
    <blockquote cite="mid:20150218130328.3ce5ab53@notabene.brown"
      type="cite">
      <pre wrap="">

 The reason md needs 'takeover' is because it doesn't have the same
 device/target separation that dm does.</pre>
    </blockquote>
    <br>
    Correct.<br>
    Nonetheless, I found accessing md's takeover functionality still
    useful<br>
    for the atomic updates to be simpler in dm/lvm.<br>
    <br>
    <blockquote cite="mid:20150218130328.3ce5ab53@notabene.brown"
      type="cite">
      <pre wrap="">

 I was particularly surprised that you wanted to use md/raid0.c  It is no
 better than dm/dm-stripe.c and managing two different stripe engines under
 LVM doesn't see like a good idea.</pre>
    </blockquote>
    <br>
    I actually see differences in performance which I have not explained
    yet.<br>
    <br>
    In some cases, dm-stripe performs better, in others md raid0 does
    for the same mappings<br>
    and load; exact same mappings are possible, because I've got patches
    to lvconvert back<br>
    and forth between "striped" and "raid0", hence accesing exactly the
    same physical extents.<br>
    <br>
    So supporting "raid0" in dm-raid is senseful for 3 reasons:<br>
    - replace dm-stripe with md raid0<br>
    - atomic md takeover from "raid0" -&gt; "raid5"<br>
    - potential performance implications<br>
    <br>
    <blockquote cite="mid:20150218130328.3ce5ab53@notabene.brown"
      type="cite">
      <pre wrap="">

 Is there some reason that I have missed which makes it easier to use
 'takeover' rather than suspend/resume?</pre>
    </blockquote>
    <br>
    Use md takover for atomic updates as mentioned above.<br>
    <br>
    You don't have issues with md_resize() which I use to shrink
    existing arrays?<br>
    <br>
    Thanks,<br>
    Heinz<br>
    <br>
    <blockquote cite="mid:20150218130328.3ce5ab53@notabene.brown"
      type="cite">
      <pre wrap="">

Thanks,
NeilBrown
</pre>
      <br>
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap="">--
dm-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a></pre>
    </blockquote>
    <br>
  </body>
</html>

--------------090303020109050104000106--


--===============8330457477897289339==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8330457477897289339==--
