From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: Bug in dm-stripe.c driver
Date: Wed, 21 Nov 2007 11:15:52 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC019BA3E9@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1888456044=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: "Healey, Douglas D" <douglas.d.healey@intel.com>, "Ciechanowski,  Ed" <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1888456044==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C82C72.EF461036"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C82C72.EF461036
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello everyone,=20

=20

I believe that I've found a bug in the dm-stripe.c driver. I've been
working on getting event alerting put into the driver so that it matches
what is found in the dm-raid1.c driver. During my implementation efforts
I ran into a problem where the kernel would oops out when I tried to
call the queue_work() function. After putting some printk's in the
driver to monitor the pointer addresses of the stripe_c structure
members I finally think I've got an answer. I found that in its
declaration the struct stripe stripe[0] is only accounting for a stripe
with one drive present; in my case I have 2 drives in the stripe volume.
Here is the stripe struct (and as you can see it only allows for 1
drive):

=20

struct stripe_c {

       uint32_t stripes;

=20

       /* The size of this target / num. stripes */

       sector_t stripe_width;

=20

       /* stripe chunk size */

       uint32_t chunk_shift;

       sector_t chunk_mask;

=20

/***** Here's the problem spot *****/=20

       struct stripe stripe[0];

      =20

/***** New member elements below problem declaration *****/

       /* Needed for handling events */

       struct dm_target *ti;

      =20

       /* New work_queue setup for triggering events*/

       struct work_struct kstriped_ws;

=20

};

=20

So, by adding the new declarations of member elements after that
stripe[0] declaration there is the possibility of overwriting memory
addresses when the processing code for the get_stripe() function is ran.
Here's a snippet of the printk code I used to figure this out and its
resulting syslog data:

=20

/*

 * Construct a striped mapping.

 * <number of stripes> <chunk size (2^^n)> [<dev_path> <offset>]+

 */

static int stripe_ctr(struct dm_target *ti, unsigned int argc, char
**argv)

{

.

.

.

       /*

        * Get the stripe destinations.

        */

       for (i =3D 0; i < stripes; i++) {

              argv +=3D 2;

printk("EVENT: 7:%d Address of sc->kstriped_ws.entry=3D%p, next=3D%p,
prev=3D%p\n", i, &sc->kstriped_ws.entry, sc->kstriped_ws.entry.next,
sc->kstriped_ws.entry.prev);

              r =3D get_stripe(ti, sc, i, argv);

printk("EVENT: 8:%d Address of sc->kstriped_ws.entry=3D%p, next=3D%p,
prev=3D%p\n", i, &sc->kstriped_ws.entry, sc->kstriped_ws.entry.next,
sc->kstriped_ws.entry.prev);

              if (r < 0) {

                     ti->error =3D "Couldn't parse stripe destination";

                     while (i--)

                             dm_put_device(ti, sc->stripe[i].dev);

                     kfree(sc);

                     return r;

              }

       }

.

.

.

}

      =20

/*

 * Parse a single <dev> <sector> pair

 */

static int get_stripe(struct dm_target *ti, struct stripe_c *sc,

                    unsigned int stripe, char **argv)

{

       unsigned long long start;

=20

       if (sscanf(argv[1], "%llu", &start) !=3D 1)

              return -EINVAL;

=20

printk("EVENT: 7:%d%d.1 Address of sc->kstriped_ws.entry=3D%p, =
next=3D%p,
prev=3D%p\n", stripe, stripe, &sc->kstriped_ws.entry,
sc->kstriped_ws.entry.next, sc->kstriped_ws.entry.prev);

printk("           argv[0]=3D%s, stripe=3D%d, sc->stripe_width=3D%u\n",
argv[0], stripe, (uint32_t)sc->stripe_width);     =20

       if (dm_get_device(ti, argv[0], start, sc->stripe_width,

                       dm_table_get_mode(ti->table),

                       &sc->stripe[stripe].dev))

              return -ENXIO;

printk("EVENT: 7:%d%d.2 Address of sc->kstriped_ws.entry=3D%p, =
next=3D%p,
prev=3D%p\n",stripe, stripe, &sc->kstriped_ws.entry,
sc->kstriped_ws.entry.next, sc->kstriped_ws.entry.prev);

=20

       sc->stripe[stripe].physical_start =3D start;

printk("EVENT: 7:%d%d.3 Address of sc->kstriped_ws.entry=3D%p, =
next=3D%p,
prev=3D%p\n",stripe, stripe, &sc->kstriped_ws.entry,
sc->kstriped_ws.entry.next, sc->kstriped_ws.entry.prev);

=20

       return 0;

}

=20

=20

=20

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 7:0 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 7:00.1 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0

Nov 21 01:55:19 dmraid-devhost kernel:            argv[0]=3D/dev/sdb,
stripe=3D0, sc->stripe_width=3D488391936

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 7:00.2 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 7:00.3 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 8:0 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 7:1 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 7:11.1 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0

Nov 21 01:55:19 dmraid-devhost kernel:            argv[0]=3D/dev/sdc,
stripe=3D1, sc->stripe_width=3D488391936

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 7:11.2 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81003c47dec0,
prev=3Dffff81001d8ca5b0

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 7:11.3 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81003c47dec0,
prev=3D0000000000000000

Nov 21 01:55:19 dmraid-devhost kernel: EVENT: 8:1 Address of
sc->kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81003c47dec0,
prev=3D0000000000000000

=20

As you can see from the output when it hits the second drive of the
stripe it is overwriting the memory addresses for the work_struct
list_head "prev" pointer; leading to my oops condition.

=20

To verify this I decided to up the number in stripe[] to match the
number of drives present:

struct stripe stripe[1];

=20

After this change the memory corruption is gone:

=20

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 7:0 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 7:00.1 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel:            argv[0]=3D/dev/sdb,
stripe=3D0, sc->stripe_width=3D488391936

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 7:00.2 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 7:00.3 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 8:0 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 7:1 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 7:11.1 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel:            argv[0]=3D/dev/sdc,
stripe=3D1, sc->stripe_width=3D488391936

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 7:11.2 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 7:11.3 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

Nov 21 02:21:45 dmraid-devhost kernel: EVENT: 8:1 Address of
sc->kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040

=20

=20

My question now is how should this be patched? Do I just use some
arbitrary number in the stripe[] declaration? Say something like 6
(since that is the maximum number of on-board SATA ports for an Intel
based controller at the moment). (Probably not, since this is making it
platform specific.) How about maybe changing this to an
array-of-pointers to a "struct stripe" and setting this to something
like "struct stripe *stripe[256]"? This would only be wasting memory for
the unused pointers which is comparatively small.=20

=20

I look forward to hearing everyone's ideas on how this should be solved,
thank you.

=20

=20

Brian Wood

Software Engineer

Intel Corp., Manageability & Platform Software Division

brian.j.wood@intel.com

=20


------_=_NextPart_001_01C82C72.EF461036
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 77.95pt 1.0in 77.95pt;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"2050" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>Hello everyone, =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>I believe that =
I&#8217;ve
found a bug in the dm-stripe.c driver. I&#8217;ve been working on =
getting event
alerting put into the driver so that it matches what is found in the =
dm-raid1.c
driver. During my implementation efforts I ran into a problem where the =
kernel
would oops out when I tried to call the queue_work() function. After =
putting
some printk&#8217;s in the driver to monitor the pointer addresses of =
the
stripe_c structure members I finally think I&#8217;ve got an answer. I =
found
that in its declaration the struct stripe stripe[0] is only accounting =
for a
stripe with one drive present; in my case I have 2 drives in the stripe =
volume.
Here is the stripe struct (and as you can see it only allows for 1 =
drive):<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>struct stripe_c =
{<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint32_t
stripes;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*
The size of this target / num. stripes */<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sector_t
stripe_width;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*
stripe chunk size */<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uint32_t
chunk_shift;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sector_t
chunk_mask;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>/***** Here&#8217;s =
the
problem spot *****/ <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct
stripe stripe[0];<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>/***** New member =
elements below
problem declaration *****/<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*
Needed for handling events */<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct
dm_target *ti;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*
New work_queue setup for triggering =
events*/<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct
work_struct kstriped_ws;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>};<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>So, by adding the =
new
declarations of member elements after that stripe[0] declaration there =
is the
possibility of overwriting memory addresses when the processing code for =
the
get_stripe() function is ran. Here&#8217;s a snippet of the printk code =
I used
to figure this out and its resulting syslog =
data:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>/*<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>&nbsp;* Construct a =
striped
mapping.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>&nbsp;* &lt;number =
of
stripes&gt; &lt;chunk size (2^^n)&gt; [&lt;dev_path&gt; =
&lt;offset&gt;]+<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;*/<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>static int =
stripe_ctr(struct
dm_target *ti, unsigned int argc, char =
**argv)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>{<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
/*<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*
Get the stripe destinations.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;*/<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for
(i =3D 0; i &lt; stripes; i++) {<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; argv
+=3D 2;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>printk(&quot;EVENT: =
7:%d
Address of sc-&gt;kstriped_ws.entry=3D%p, next=3D%p, prev=3D%p\n&quot;, =
i, &amp;sc-&gt;kstriped_ws.entry,
sc-&gt;kstriped_ws.entry.next, =
sc-&gt;kstriped_ws.entry.prev);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; r
=3D get_stripe(ti, sc, i, argv);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>printk(&quot;EVENT: =
8:%d
Address of sc-&gt;kstriped_ws.entry=3D%p, next=3D%p, prev=3D%p\n&quot;, =
i,
&amp;sc-&gt;kstriped_ws.entry, sc-&gt;kstriped_ws.entry.next, =
sc-&gt;kstriped_ws.entry.prev);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; if
(r &lt; 0) {<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ti-&gt;error
=3D &quot;Couldn't parse stripe =
destination&quot;;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while
(i--)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; dm_put_device(ti,
sc-&gt;stripe[i].dev);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
kfree(sc);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return
r;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; }<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
}<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>/*<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>&nbsp;* Parse a =
single
&lt;dev&gt; &lt;sector&gt; pair<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;*/<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>static int =
get_stripe(struct
dm_target *ti, struct stripe_c *sc,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
unsigned int stripe, char **argv)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>{<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned
long long start;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(sscanf(argv[1], &quot;%llu&quot;, &amp;start) !=3D =
1)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; return
-EINVAL;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>printk(&quot;EVENT: =
7:%d%d.1
Address of sc-&gt;kstriped_ws.entry=3D%p, next=3D%p, prev=3D%p\n&quot;, =
stripe,
stripe, &amp;sc-&gt;kstriped_ws.entry, sc-&gt;kstriped_ws.entry.next,
sc-&gt;kstriped_ws.entry.prev);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>printk(&quot;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;
argv[0]=3D%s, stripe=3D%d, sc-&gt;stripe_width=3D%u\n&quot;, argv[0], =
stripe,
(uint32_t)sc-&gt;stripe_width);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(dm_get_device(ti, argv[0], start, =
sc-&gt;stripe_width,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
dm_table_get_mode(ti-&gt;table),<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
&amp;sc-&gt;stripe[stripe].dev))<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; return
-ENXIO;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>printk(&quot;EVENT: =
7:%d%d.2
Address of sc-&gt;kstriped_ws.entry=3D%p, next=3D%p, =
prev=3D%p\n&quot;,stripe,
stripe, &amp;sc-&gt;kstriped_ws.entry, sc-&gt;kstriped_ws.entry.next,
sc-&gt;kstriped_ws.entry.prev);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
sc-&gt;stripe[stripe].physical_start
=3D start;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>printk(&quot;EVENT: =
7:%d%d.3
Address of sc-&gt;kstriped_ws.entry=3D%p, next=3D%p, =
prev=3D%p\n&quot;,stripe,
stripe, &amp;sc-&gt;kstriped_ws.entry, sc-&gt;kstriped_ws.entry.next,
sc-&gt;kstriped_ws.entry.prev);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return
0;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:9.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 7:0 Address of =
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0,
next=3Dffff81001d8ca5b0, =
prev=3Dffff81001d8ca5b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 7:00.1 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel:&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;argv[0]=3D/dev/sdb,=

stripe=3D0, sc-&gt;stripe_width=3D488391936<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 7:00.2 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 7:00.3 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 8:0 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 7:1 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 7:11.1 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81001d8ca5b0,
prev=3Dffff81001d8ca5b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost
kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

argv[0]=3D/dev/sdc, stripe=3D1, =
sc-&gt;stripe_width=3D488391936<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 7:11.2 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81003c47dec0,
prev=3Dffff81001d8ca5b0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 7:11.3 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0, next=3Dffff81003c47dec0,
prev=3D0000000000000000<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 01:55:19
dmraid-devhost kernel: EVENT: 8:1 Address of =
sc-&gt;kstriped_ws.entry=3Dffff81001d8ca5b0,
next=3Dffff81003c47dec0, =
prev=3D0000000000000000<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:9.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>As you can see from =
the
output when it hits the second drive of the stripe it is overwriting the =
memory
addresses for the work_struct list_head &#8220;prev&#8221; pointer; =
leading to
my oops condition.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>To verify this I =
decided to
up the number in stripe[] to match the number of drives =
present:</span></font><font
size=3D1 face=3D"Courier New"><span =
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'text-indent:.5in;text-autospace:none'><font size=3D1
face=3D"Courier New"><span style=3D'font-size:8.0pt;font-family:"Courier =
New"'>struct
stripe stripe[1];<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>After this change =
the memory
corruption is gone:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 7:0 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 7:00.1 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost
kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

argv[0]=3D/dev/sdb, stripe=3D0, =
sc-&gt;stripe_width=3D488391936<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 7:00.2 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 7:00.3 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 8:0 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 7:1 Address of =
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040,
next=3Dffff81001f4d8040, =
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 7:11.1 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost =
kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

argv[0]=3D/dev/sdc, stripe=3D1, =
sc-&gt;stripe_width=3D488391936<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 7:11.2 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 7:11.3 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:8.0pt;font-family:"Courier New"'>Nov 21 02:21:45
dmraid-devhost kernel: EVENT: 8:1 Address of
sc-&gt;kstriped_ws.entry=3Dffff81001f4d8040, next=3Dffff81001f4d8040,
prev=3Dffff81001f4d8040<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:9.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D1 =
face=3D"Courier New"><span
style=3D'font-size:9.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>My question now is how should this be patched? Do I just use =
some
arbitrary number in the stripe[] declaration? Say something like 6 =
(since that
is the maximum number of on-board SATA ports for an Intel based =
controller at
the moment). (Probably not, since this is making it platform specific.) =
How
about maybe changing this to an array-of-pointers to a &#8220;struct =
stripe&#8221;
and setting this to something like &#8220;struct stripe =
*stripe[256]&#8221;?
This would only be wasting memory for the unused pointers which is =
comparatively
small. <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>I look forward to hearing everyone&#8217;s ideas on how this =
should be
solved, thank you.<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Brian Wood<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Software Engineer<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>Intel Corp., Manageability &amp; Platform Software =
Division<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'>brian.j.wood@intel.com<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
10.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C82C72.EF461036--


--===============1888456044==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1888456044==--
