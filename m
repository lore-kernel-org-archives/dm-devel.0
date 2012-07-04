From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] DM RAID: Add support for MD RAID10
	personality
Date: Tue, 3 Jul 2012 22:20:29 -0500
Message-ID: <262AC9F3-56D9-48A8-8A03-32D6B81D4689@redhat.com>
References: <1340712231.19015.42.camel@f16>
	<20120704112159.36cdb42a@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/mixed; boundary="===============8926900693793419862=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120704112159.36cdb42a@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


--===============8926900693793419862==
Content-Type: multipart/alternative; boundary=Apple-Mail-2-140093184


--Apple-Mail-2-140093184
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jul 3, 2012, at 8:21 PM, NeilBrown wrote:

> On Tue, 26 Jun 2012 07:03:51 -0500 Jonathan Brassow =
<jbrassow@redhat.com>
> wrote:
>=20
>> dm raid: add md raid10 support
>>=20
>> Support the MD RAID10 personality through dm-raid.c
>>=20
>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>>=20
>> Index: linux-upstream/drivers/md/dm-raid.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-upstream.orig/drivers/md/dm-raid.c
>> +++ linux-upstream/drivers/md/dm-raid.c
>> @@ -11,6 +11,7 @@
>> #include "md.h"
>> #include "raid1.h"
>> #include "raid5.h"
>> +#include "raid10.h"
>> #include "bitmap.h"
>>=20
>> #include <linux/device-mapper.h>
>> @@ -52,7 +53,11 @@ struct raid_dev {
>> #define DMPF_MAX_RECOVERY_RATE 0x20
>> #define DMPF_MAX_WRITE_BEHIND  0x40
>> #define DMPF_STRIPE_CACHE      0x80
>> -#define DMPF_REGION_SIZE       0X100
>> +#define DMPF_REGION_SIZE       0x100
>> +#define DMPF_RAID10_NEAR_COPIES 0x200
>> +#define DMPF_RAID10_FAR_COPIES  0x400
>> +#define DMPF_RAID10_FAR_OFFSET  0x800
>> +
>> struct raid_set {
>> 	struct dm_target *ti;
>>=20
>> @@ -66,6 +71,15 @@ struct raid_set {
>> 	struct raid_dev dev[0];
>> };
>>=20
>> +/* near_copies in first byte */
>> +/* far_copies in second byte */
>> +/* far_offset in 17th bit */
>> +#define ALGORITHM_RAID10(near_copies, far_copies, far_offset) \
>> +	((near_copies & 0xFF) | ((far_copies & 0xFF) << 8) | =
((!!far_offset) << 16))
>> +#define RAID10_NC(layout) (layout & 0xFF)
>> +#define RAID10_FC(layout) ((layout >> 8) & 0xFF)
>> +#define RAID10_FO(layout) (layout & 0x10000)
>> +
>> /* Supported raid types and properties. */
>> static struct raid_type {
>> 	const char *name;		/* RAID algorithm. */
>> @@ -76,6 +90,8 @@ static struct raid_type {
>> 	const unsigned algorithm;	/* RAID algorithm. */
>> } raid_types[] =3D {
>> 	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* =
NONE */},
>> +	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, -1 /* =
Varies */},
>> +	{"raid1e",   "RAID1E (Enhanced RAID1)",         0, 2, 10, -1 /* =
Varies */},
>> 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, =
ALGORITHM_PARITY_0},
>> 	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, =
ALGORITHM_LEFT_ASYMMETRIC},
>> 	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, =
ALGORITHM_RIGHT_ASYMMETRIC},
>> @@ -339,10 +355,17 @@ static int validate_region_size(struct r
>>  *    [max_write_behind <sectors>]	See '-write-behind=3D' (man =
mdadm)
>>  *    [stripe_cache <sectors>]		Stripe cache size for =
higher RAIDs
>>  *    [region_size <sectors>]           Defines granularity of bitmap
>> + *
>> + * RAID10-only options:
>> + *    [raid10_near_copies   <# copies>] Near copies. (Default: 2)
>> + *    [raid10_far_copies    <# copies>] Far copies.  (Default: 1)
>> + *    [raid10_far_offset    <0/1>]      Offset is device size(0) or =
stripe(1).
>=20
> Can I suggest that you don't do it like this?  i.e. don't copy the
> mistakes I made :-)
>=20
> I don't think there is any value in supporting multiple near and far =
copies.
> There are two dimensions of the layout:
> - number of copies.  Defaults to 2
> - location of the copies:  near, far, offset
>=20
> Some day I could implement an alternate version of 'far' or 'offset' =
which
> improves redundancy slightly.
> Instead of=20
>   A B C D
>   ...
>   D A B C
>=20
> it would be
>=20
>   A B C D=20
>   ....
>   B A D C
>=20
> i.e. treat the devices as pair and swap the device for the second =
copy.
> This doesn't generalise to an odd number of devices, but increases the =
number
> of pairs of devices that can concurrently fail without losing date.
> (for 4 devices, there are 6 pairs.  With current 'far' mode there are =
only 2
> pair of devices that can concurrently fail (0,2 and 1,3).  With the =
proposed
> far mode there are 4 (0,2 0,3 1,2, 1,3).
>=20
> Adding this with your current proposal would be messy.
> Adding it with the two dimensions I suggest would simply involve =
adding
> another 'location' - 'farswap' or 'far2' or something.
>=20
> I note you didn't make 'dm-raid1e' a module alias.  Was that =
deliberate?

The missed module alias was an oversight, thanks for catching that.  =
(Similar - as you can see from this patch - to the oversight I had when =
introducing raid1. :)  I have gone back and forth on whether to include =
the alternate "raid1e" or not.  There are different RAID1E algorithms, =
as described in the kernel doc.  Perhaps there should also be aliases =
similar to raid5 and raid6 - like raid1e_as (i.e. RAID1E - Adjacent =
Stripe), etc.  However, there are several combinations that don't have a =
real name.  Any thoughts?  I would be just fine leaving "raid1e" out as =
I would leaving it in.  These days, RAID10 is really a subset of RAID1E =
- perhaps I should be considering taking "raid10" out.  ;)

I like your suggestion of changing the parameter names.  I've found the =
original names somewhat confusing.  ('far_offset' seems to imply to me =
that the copy would not be the very next stripe, but _offset_ somehow - =
it seems to have the reverse meaning to me.  I think this comes from the =
fact that it acts as a modifier to 'far_copy'.)  I toyed with a couple =
different ways of doing this but figured it was best to just go along.  =
Anyway, what you are suggesting seems to be:
	raid10_copies <number> (Default: 2)
	raid10_layout <string> (Default: "near"/"adjacent")
Where <string> could be "near", "far", "offset" and "some-future-thing". =
 That seems nice to me and seems to clear up some of the confusion =
caused by "far_offset" seeming to be a modifier to "far_copies".

Let me know what you think about the above, and I'll get v2 ready.

 brassow

P.S.  While it doesn't affect this singular patch, I see people posting =
their set of patches as a reply to the summary '0 of' patch.  This keeps =
things together better, and I'll assume this is the way I should post =
from now on.=

--Apple-Mail-2-140093184
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><br><div><div>On Jul 3, 2012, at 8:21 PM, NeilBrown wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; =
font-family: Helvetica; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; ">On Tue, 26 =
Jun 2012 07:03:51 -0500 Jonathan Brassow &lt;<a =
href=3D"mailto:jbrassow@redhat.com">jbrassow@redhat.com</a>&gt;<br>wrote:<=
br><br><blockquote type=3D"cite">dm raid: add md raid10 =
support<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Support the MD =
RAID10 personality through dm-raid.c<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Signed-off-by: =
Jonathan Brassow &lt;<a =
href=3D"mailto:jbrassow@redhat.com">jbrassow@redhat.com</a>&gt;<br></block=
quote><blockquote type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">Index: =
linux-upstream/drivers/md/dm-raid.c<br></blockquote><blockquote =
type=3D"cite">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br></bl=
ockquote><blockquote type=3D"cite">--- =
linux-upstream.orig/drivers/md/dm-raid.c<br></blockquote><blockquote =
type=3D"cite">+++ =
linux-upstream/drivers/md/dm-raid.c<br></blockquote><blockquote =
type=3D"cite">@@ -11,6 +11,7 @@<br></blockquote><blockquote =
type=3D"cite">#include "md.h"<br></blockquote><blockquote =
type=3D"cite">#include "raid1.h"<br></blockquote><blockquote =
type=3D"cite">#include "raid5.h"<br></blockquote><blockquote =
type=3D"cite">+#include "raid10.h"<br></blockquote><blockquote =
type=3D"cite">#include "bitmap.h"<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">#include =
&lt;linux/device-mapper.h&gt;<br></blockquote><blockquote type=3D"cite">@@=
 -52,7 +53,11 @@ struct raid_dev {<br></blockquote><blockquote =
type=3D"cite">#define DMPF_MAX_RECOVERY_RATE =
0x20<br></blockquote><blockquote type=3D"cite">#define =
DMPF_MAX_WRITE_BEHIND &nbsp;0x40<br></blockquote><blockquote =
type=3D"cite">#define DMPF_STRIPE_CACHE =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0x80<br></blockquote><blockquote =
type=3D"cite">-#define DMPF_REGION_SIZE =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0X100<br></blockquote><blockquote =
type=3D"cite">+#define DMPF_REGION_SIZE =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0x100<br></blockquote><blockquote =
type=3D"cite">+#define DMPF_RAID10_NEAR_COPIES =
0x200<br></blockquote><blockquote type=3D"cite">+#define =
DMPF_RAID10_FAR_COPIES &nbsp;0x400<br></blockquote><blockquote =
type=3D"cite">+#define DMPF_RAID10_FAR_OFFSET =
&nbsp;0x800<br></blockquote><blockquote =
type=3D"cite">+<br></blockquote><blockquote type=3D"cite">struct =
raid_set {<br></blockquote><blockquote type=3D"cite"><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>struct =
dm_target *ti;<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">@@ -66,6 +71,15 =
@@ struct raid_set {<br></blockquote><blockquote type=3D"cite"><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>struct =
raid_dev dev[0];<br></blockquote><blockquote =
type=3D"cite">};<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">+/* near_copies =
in first byte */<br></blockquote><blockquote type=3D"cite">+/* =
far_copies in second byte */<br></blockquote><blockquote type=3D"cite">+/*=
 far_offset in 17th bit */<br></blockquote><blockquote =
type=3D"cite">+#define ALGORITHM_RAID10(near_copies, far_copies, =
far_offset) \<br></blockquote><blockquote type=3D"cite">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>((near_copies &amp; 0xFF) | ((far_copies &amp; 0xFF) &lt;&lt; 8) =
| ((!!far_offset) &lt;&lt; 16))<br></blockquote><blockquote =
type=3D"cite">+#define RAID10_NC(layout) (layout &amp; =
0xFF)<br></blockquote><blockquote type=3D"cite">+#define =
RAID10_FC(layout) ((layout &gt;&gt; 8) &amp; =
0xFF)<br></blockquote><blockquote type=3D"cite">+#define =
RAID10_FO(layout) (layout &amp; 0x10000)<br></blockquote><blockquote =
type=3D"cite">+<br></blockquote><blockquote type=3D"cite">/* Supported =
raid types and properties. */<br></blockquote><blockquote =
type=3D"cite">static struct raid_type {<br></blockquote><blockquote =
type=3D"cite"><span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>const char *name;<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>/* RAID algorithm. =
*/<br></blockquote><blockquote type=3D"cite">@@ -76,6 +90,8 @@ static =
struct raid_type {<br></blockquote><blockquote type=3D"cite"><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>const =
unsigned algorithm;<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span>/* RAID algorithm. */<br></blockquote><blockquote =
type=3D"cite">} raid_types[] =3D {<br></blockquote><blockquote =
type=3D"cite"><span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>{"raid1", &nbsp;&nbsp;&nbsp;"RAID1 (mirroring)", =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;0, 2, 1, 0 /* NONE */},<br></blockquote><blockquote =
type=3D"cite">+<span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>{"raid10", &nbsp;&nbsp;"RAID10 (striped mirrors)", =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0, 2, 10, -1 /* Varies =
*/},<br></blockquote><blockquote type=3D"cite">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>{"raid1e", &nbsp;&nbsp;"RAID1E (Enhanced RAID1)", =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0, 2, 10, -1 /* Varies =
*/},<br></blockquote><blockquote type=3D"cite"><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>{"raid4", =
&nbsp;&nbsp;&nbsp;"RAID4 (dedicated parity disk)",<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>1, 2, 5, =
ALGORITHM_PARITY_0},<br></blockquote><blockquote type=3D"cite"><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>{"raid5_la", "RAID5 (left asymmetric)",<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>1, 2, 5, =
ALGORITHM_LEFT_ASYMMETRIC},<br></blockquote><blockquote =
type=3D"cite"><span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>{"raid5_ra", "RAID5 (right asymmetric)",<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>1, 2, 5, =
ALGORITHM_RIGHT_ASYMMETRIC},<br></blockquote><blockquote type=3D"cite">@@ =
-339,10 +355,17 @@ static int validate_region_size(struct =
r<br></blockquote><blockquote type=3D"cite">&nbsp;* =
&nbsp;&nbsp;&nbsp;[max_write_behind &lt;sectors&gt;]<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>See =
'-write-behind=3D' (man mdadm)<br></blockquote><blockquote =
type=3D"cite">&nbsp;* &nbsp;&nbsp;&nbsp;[stripe_cache =
&lt;sectors&gt;]<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span><span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>Stripe cache size for higher =
RAIDs<br></blockquote><blockquote type=3D"cite">&nbsp;* =
&nbsp;&nbsp;&nbsp;[region_size &lt;sectors&gt;] =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Defines =
granularity of bitmap<br></blockquote><blockquote type=3D"cite">+ =
*<br></blockquote><blockquote type=3D"cite">+ * RAID10-only =
options:<br></blockquote><blockquote type=3D"cite">+ * =
&nbsp;&nbsp;&nbsp;[raid10_near_copies &nbsp;&nbsp;&lt;# copies&gt;] Near =
copies. (Default: 2)<br></blockquote><blockquote type=3D"cite">+ * =
&nbsp;&nbsp;&nbsp;[raid10_far_copies &nbsp;&nbsp;&nbsp;&lt;# copies&gt;] =
Far copies. &nbsp;(Default: 1)<br></blockquote><blockquote type=3D"cite">+=
 * &nbsp;&nbsp;&nbsp;[raid10_far_offset &nbsp;&nbsp;&nbsp;&lt;0/1&gt;] =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Offset is device size(0) or =
stripe(1).<br></blockquote><br>Can I suggest that you don't do it like =
this? &nbsp;i.e. don't copy the<br>mistakes I made :-)<br><br>I don't =
think there is any value in supporting multiple near and far =
copies.<br>There are two dimensions of the layout:<br>- number of =
copies. &nbsp;Defaults to 2<br>- location of the copies: &nbsp;near, =
far, offset<br><br>Some day I could implement an alternate version of =
'far' or 'offset' which<br>improves redundancy slightly.<br>Instead =
of<span class=3D"Apple-converted-space">&nbsp;</span><br>&nbsp;&nbsp;A B =
C D<br>&nbsp;&nbsp;...<br>&nbsp;&nbsp;D A B C<br><br>it would =
be<br><br>&nbsp;&nbsp;A B C D<span =
class=3D"Apple-converted-space">&nbsp;</span><br>&nbsp;&nbsp;....<br>&nbsp=
;&nbsp;B A D C<br><br>i.e. treat the devices as pair and swap the device =
for the second copy.<br>This doesn't generalise to an odd number of =
devices, but increases the number<br>of pairs of devices that can =
concurrently fail without losing date.<br>(for 4 devices, there are 6 =
pairs. &nbsp;With current 'far' mode there are only 2<br>pair of devices =
that can concurrently fail (0,2 and 1,3). &nbsp;With the proposed<br>far =
mode there are 4 (0,2 0,3 1,2, 1,3).<br><br>Adding this with your =
current proposal would be messy.<br>Adding it with the two dimensions I =
suggest would simply involve adding<br>another 'location' - 'farswap' or =
'far2' or something.<br><br>I note you didn't make 'dm-raid1e' a module =
alias. &nbsp;Was that =
deliberate?<br></span></blockquote></div><br><div>The missed module =
alias was an oversight, thanks for catching that. &nbsp;(Similar - as =
you can see from this patch - to the oversight I had when introducing =
raid1. :) &nbsp;I have gone back and forth on whether to include the =
alternate "raid1e" or not. &nbsp;There are different RAID1E algorithms, =
as described in the kernel doc. &nbsp;Perhaps there should also be =
aliases similar to raid5 and raid6 - like raid1e_as (i.e. RAID1E - =
Adjacent Stripe), etc. &nbsp;However, there are several combinations =
that don't have a real name. &nbsp;Any thoughts? &nbsp;I would be just =
fine leaving "raid1e" out as I would leaving it in. &nbsp;These days, =
RAID10 is really a subset of RAID1E - perhaps I should be considering =
taking "raid10" out. &nbsp;;)</div><div><br></div><div>I like your =
suggestion of changing the parameter names. &nbsp;I've found the =
original names somewhat confusing. &nbsp;('far_offset' seems to imply to =
me that the copy would not be the very next stripe, but _offset_ somehow =
- it seems to have the reverse meaning to me. &nbsp;I think this comes =
from the fact that it acts as a modifier to 'far_copy'.) &nbsp;I toyed =
with a couple different ways of doing this but figured it was best to =
just go along. &nbsp;Anyway, what you are suggesting seems to =
be:</div><div><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>raid10_copies &lt;number&gt; (Default: 2)</div><div><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>raid10_layout &lt;string&gt; (Default: =
"near"/"adjacent")</div><div>Where &lt;string&gt; could be "near", =
"far", "offset" and "some-future-thing". &nbsp;That seems nice to me and =
seems to clear up some of the confusion caused by "far_offset" seeming =
to be a modifier to "far_copies".</div><div><br></div><div>Let me know =
what you think about the above, and I'll get v2 =
ready.</div><div><br></div><div>&nbsp;brassow</div><div><br></div><div>P.S=
. &nbsp;While it doesn't affect this singular patch, I see people =
posting their set of patches as a reply to the summary '0 of' patch. =
&nbsp;This keeps things together better, and I'll assume this is the way =
I should post from now on.</div></body></html>=

--Apple-Mail-2-140093184--


--===============8926900693793419862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8926900693793419862==--
