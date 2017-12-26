From: Henry Liu <tgvlcw@gmail.com>
Subject: Re: [PATCH] dm: add asymmetric stripe target device
	dirver
Date: Tue, 26 Dec 2017 13:49:11 +0800
Message-ID: <CAA7i65ktu9yo+JomoUb+Kory9jYgy7FwWdFufwAG9t6XPdpgsA@mail.gmail.com>
References: <5a41c7d3.4662650a.ea76c.4e6c@mx.google.com>
	<c5b29845-3a96-db67-be2b-a75f734009f0@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4473442538617052610=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c5b29845-3a96-db67-be2b-a75f734009f0@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Randy Dunlap <rdunlap@infradead.org>
Cc: snitzer@redhat.com, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, neilb@suse.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

--===============4473442538617052610==
Content-Type: multipart/alternative; boundary="001a113dae329e9f74056137d7ce"

--001a113dae329e9f74056137d7ce
Content-Type: text/plain; charset="UTF-8"

No, I don't think so, "target_stripe > stripe" is another condition, but I
do nothing here. If I use "else" the condition "target_strie > stripe" can
not be handled.

2017-12-26 12:22 GMT+08:00 Randy Dunlap <rdunlap@infradead.org>:

> On 12/25/2017 07:52 PM, tgvlcw@gmail.com wrote:
> > From: liuchaowei <tgvlcw@gmail.com>
> >
> > This asymmetric stripe target device driver can achieve better io
> > performance between those devices which possess different io performance
> >
> > There are 2 storage device or flash devices: A and B, their sequential
> > read permance are 220M/s and 315M/s inspectively, so their sequential
>
>        performance                    respectively,
>
> > read speed could be approximately equal to 2:3, if we use stripe type
> > to combine these two devices, their layout could be showed below:
> > --------------------------------------------------------
> > |    A1    |    A2    |    B1    |    B2    |    B3    |
> > --------------------------------------------------------
> >
> > If we seletect asymmetric stripe type, their layout could be illustrated
>
>         select
>
> > follow:
> > --------------------------------------------------------
> > |         A1          |               B1               |
> > --------------------------------------------------------
> >
> > The former has 5 stripe devices and each stripe device has also equal
> > chunk size, e.g.: 256secs. If there is a data block which size is
> > 1280secs, so transfer the data to this stripe defvice will be split
>
>                                                 device
>
> > to 5 ios which io size is 256secs. But if we use the asymmetric
> > stripe device, it only has two stripe devices and each one has be
> > setting in optimal chunk size, e.g.: ratio is 2:3, the first one
> > optimal chunk size is 512secs, the second is 768secs.  And same
> > 1280secs data block just only be splited two ios, this can be achieve
>
>                                    split into two ios,
>
> > perfect io performance.
> >
> > Change-Id: Iebaee3480e27022e2b3a7edbfb65425b1166274e
> > Signed-off-by: liuchaowei <tgvlcw@gmail.com>
> > ---
> >  Documentation/device-mapper/asymmetric-striped.txt |  85 ++++
> >  drivers/md/Kconfig                                 |  11 +
> >  drivers/md/Makefile                                |   1 +
> >  drivers/md/dm-asymmetric-stripe.c                  | 523
> +++++++++++++++++++++
> >  drivers/md/dm.c                                    |   5 +
> >  include/linux/device-mapper.h                      |  15 +
> >  6 files changed, 640 insertions(+)
> >  create mode 100644 Documentation/device-mapper/asymmetric-striped.txt
> >  create mode 100644 drivers/md/dm-asymmetric-stripe.c
> >
> > diff --git a/Documentation/device-mapper/asymmetric-striped.txt
> b/Documentation/device-mapper/asymmetric-striped.txt
> > new file mode 100644
> > index 000000000000..0412a224a49e
> > --- /dev/null
> > +++ b/Documentation/device-mapper/asymmetric-striped.txt
> > @@ -0,0 +1,85 @@
> > +dm-asymmetric-stripe
> > +=========
> > +
> > +Device-Mapper's "asm-striped" target is used to create a striped (i.e.
> RAID-0)
> > +device across one or more underlying devices. Data is written in
> "chunks",
> > +with consecutive chunks rotating among the underlying devices. This can
> > +potentially provide improved I/O throughput by utilizing several
> physical
> > +devices in parallel. However, in order to gain maximum I/O performance
> bewteen
>
>
> between
>
> > +slow and fast device, there is a ratio to set up the chunk size among
> these
> > +device.
> > +
> > +Parameters: <num devs> <chunk size> <ratio> [<dev path> <offset>]+
> > +<num devs>: Number of underlying devices.
> > +<chunk size>: Size of each chunk of data. Must be at least as
> > +large as the system's PAGE_SIZE.
> > +<ratio>: The proportion of per io size, it is the times as much
> > +as 1 chunk size
> > +<dev path>: Full pathname to the underlying block-device, or a
> > +"major:minor" device-number.
> > +<offset>: Starting sector within the device.
> > +
> > +One or more underlying devices can be specified. The striped device
> > +size must be a multiple of the chunk size multiplied by the number of
> underlying
> > +devices. However, there is a ratio can be setting, e.g.: 2:3 means the
> first one
>
>                      there is a ratio that can be set,
>
> > +striped device optimal width size is 2 time as much as 1 chunk size,
> the second
>
>                                           times
>
> > +striped device is 3.
> > +
> > +
> > +Example scripts
> > +===============
> > +
> > +[[
> > +#!/usr/bin/perl -w
> > +# Create a striped device across any number of underlying devices. The
> device
> > +# will be called "stripe_dev" and have a chunk-size of 128k.
> > +
> > +my $chunk_size = 128 * 2;
> > +my $ratio = "2:3";
> > +my $dev_name = "stripe_dev";
> > +my $num_devs = @ARGV;
> > +my @devs = @ARGV;
> > +
> > +if ($num_devs < 2) {
> > +die("Specify at least two devices\n");
> > +}
> > +
> > +
> > +$stripe_average_size = 1073741824
> > +$stripe_dev_size = $stripe_average_size * 5;
> > +
> > +$table = "0 $stripe_dev_size asm-striped $num_devs $chunk_size $ratio";
> > +for ($i = 0; $i < $num_devs; $i++) {
> > +$table .= " $devs[$i] 0";
> > +}
> > +
> > +`echo $table | dmsetup create $dev_name`;
> > +]]
> > +
> > +
> > +Why asymmetric striped
> > +=======================
> > +Considering one case:
> > +There are 2 storage device or flash devices: A and B, their sequential
> > +read permance are 220M/s and 315M/s inspectively, so their sequential
>
>         performance                    respectively,
>
> > +read speed could be approximately equal to 2:3, if we use stripe type
> > +to combine these two devices, their layout could be showed below:
> > +--------------------------------------------------------
> > +|    A1    |    A2    |    B1    |    B2    |    B3    |
> > +--------------------------------------------------------
> > +
> > +If we seletect asymmetric stripe type, their layout could be illustrated
>
>          select
>
> > +follow:
> > +--------------------------------------------------------
> > +|         A1          |               B1               |
> > +--------------------------------------------------------
> > +
> > +The former has 5 stripe devices and each stripe device has also equal
> > +chunk size, e.g.: 256secs. If there is a data block which size is
> 1280secs,
> > +so transfer the data to this stripe defvice will be split to 5 ios
> which io
>
>                                        device
>
> > +size is 256secs. But if we use the asymmetric stripe device, it only
> has two
> > +stripe devices and each one has be setting in optimal chunk size, e.g.:
> ratio
> > +is 2:3, the first one optimal chunk size is 512secs, the second is
> 768secs.
> > +And same 1280secs data block just only be splited two ios, this can be
> achieve
>
>                                              split into two ios,
>
> > +perfect io performance.
> > +
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index 7d5aa2c5c81d..4232b929c2f3 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -455,6 +455,17 @@ config DM_FLAKEY
> >         ---help---
> >           A target that intermittently fails I/O for debugging purposes.
> >
> > +config DM_ASYMMETRIC_STRIPE
> > +     tristate "DM asymmetric stripe(asymmetric raid0)"
> > +     depends on BLK_DEV_DM
> > +     ---help---
> > +       This device-mapper target creates a asymmetric raid0/stripe
> device that
> > +          support asymmetric stripe chunk size and can gain same
> performance as
> > +          raid0 device
>
> Align "support" and "raid0" under "This".  And end the sentence with a
> period (".").
>
> > +
> > +          You must configure the accurate ratio between different
> physical storage
> > +          device respectively
>
> End sentence with a period.
>
> > +
> >  config DM_VERITY
> >       tristate "Verity target support"
> >       depends on BLK_DEV_DM
>
> > diff --git a/drivers/md/dm-asymmetric-stripe.c
> b/drivers/md/dm-asymmetric-stripe.c
> > new file mode 100644
> > index 000000000000..4ef3915b435a
> > --- /dev/null
> > +++ b/drivers/md/dm-asymmetric-stripe.c
> > @@ -0,0 +1,523 @@
> > +/*
> > + * Copyright (C) 2018 Smartisan, Inc.
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Author: <tgvlcw@gmail.com>
> > + * Name: Henry Liu
> > + *
> > + */
> > +
> > +
> > +#include "dm.h"
> > +#include <linux/device-mapper.h>
> > +
>
> #include <linux/atomic.h>
>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
>
> #include <linux/kernel.h>
>
> > +#include <linux/blkdev.h>
> > +#include <linux/bio.h>
>
> #include <linux/bitops.h>
>
> > +#include <linux/slab.h>
> > +#include <linux/log2.h>
>
> #include <linux/workqueue.h>
>
> > +
> > +#define DM_MSG_PREFIX "asm-striped"
> > +#define DM_IO_ERROR_THRESHOLD 15
>
> > +/*
> > + * An event is triggered whenever a drive
> > + * drops out of a stripe volume.
> > + */
> > +static void trigger_event(struct work_struct *work)
> > +{
> > +     asm_stripe_c *sc = container_of(work, asm_stripe_c, trigger_event);
> > +
> > +     dm_table_event(sc->ti->table);
> > +}
> > +
> > +     static inline
>
> Above line should not be indented.
> Above and below should be on one line if <= 80 characters.
>
> > +asm_stripe_c *alloc_context(unsigned int stripes)
> > +{
> > +     size_t len;
> > +
> > +     if (dm_array_too_big(sizeof(asm_stripe_c),
> > +                             sizeof(asm_stripe),
> > +                             stripes))
> > +             return NULL;
> > +
> > +     len = sizeof(asm_stripe_c) + (sizeof(asm_stripe) * stripes);
> > +
> > +     return kmalloc(len, GFP_KERNEL);
> > +}
>
> > +static int set_stripe_ratio(struct dm_target *ti,
> > +             asm_stripe_c *sc,
> > +             char *ratio_str)
> > +{
> > +     char *p;
> > +     unsigned int i;
> > +     uint32_t r = 0, ratio;
> > +     char *tmp_ratio = ratio_str;
> > +
> > +     if (sizeof(sc->ratio_str) < strlen(ratio_str)) {
> > +             ti->error = "Too big stripe ratio string";
> > +             return -ENOMEM;
> > +     }
> > +
> > +     strlcpy(sc->ratio_str, ratio_str, strlen(ratio_str) + 1);
> > +     for (i = 0; i < sc->stripes; i++) {
> > +             p  = strsep(&tmp_ratio, ":");
> > +             if (p == NULL)
> > +                     return -EINVAL;
> > +
> > +             if (kstrtouint(p, 10, &ratio) || !ratio)
> > +                     return -EINVAL;
> > +
> > +             sc->stripe[i].ratio = ratio;
> > +             r += ratio;
> > +     }
> > +
> > +     sc->total_ratio = r;
> > +     sc->avg_width = ti->len / r;
> > +     sc->stripe_size = r * sc->chunk_size;
> > +
> > +     return 0;
> > +}
>
> Insert blank line here.
>
> > +/*
> > + * Construct a striped mapping.
> > + * <number of stripes> <chunk size> <ratio> [<dev_path> <offset>]+
> > + */
> > +static int asymmetric_stripe_ctr(struct dm_target *ti,
> > +             unsigned int argc,
> > +             char **argv)
> > +{
>
> [snip]
>
>
> > +static void asymmetric_stripe_map_range_sector(asm_stripe_c *sc,
> > +             sector_t sector,
> > +             uint32_t target_stripe,
> > +             sector_t *result)
> > +{
> > +     sector_t width_offset;
> > +     uint32_t stripe;
> > +
> > +     width_offset = stripe_index_fetch(sc, &sector, &stripe);
> > +
> > +     *result = sector * sc->stripe[target_stripe].opt_io_size;
> > +
> > +     if (target_stripe < stripe)
> > +             *result += sc->stripe[target_stripe].opt_io_size;
> > +     else if (target_stripe == stripe)
> > +             *result += width_offset;
>
> Here you don't expect target_stripe ever to be > stripe, right?
> Then the last "else if" can just be "else"...
>
>
> > +}
> > +
>
>
> --
> ~Randy
>

--001a113dae329e9f74056137d7ce
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">No, I don&#39;t think so, &quot;target_stripe &gt; stripe&=
quot; is another condition, but I do nothing here. If I use &quot;else&quot=
; the condition &quot;target_strie &gt; stripe&quot; can not be handled.=C2=
=A0</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2017-12-=
26 12:22 GMT+08:00 Randy Dunlap <span dir=3D"ltr">&lt;<a href=3D"mailto:rdu=
nlap@infradead.org" target=3D"_blank">rdunlap@infradead.org</a>&gt;</span>:=
<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex">On 12/25/2017 07:52 PM, <a href=3D"mailt=
o:tgvlcw@gmail.com">tgvlcw@gmail.com</a> wrote:<br>
&gt; From: liuchaowei &lt;<a href=3D"mailto:tgvlcw@gmail.com">tgvlcw@gmail.=
com</a>&gt;<br>
&gt;<br>
&gt; This asymmetric stripe target device driver can achieve better io<br>
&gt; performance between those devices which possess different io performan=
ce<br>
&gt;<br>
&gt; There are 2 storage device or flash devices: A and B, their sequential=
<br>
&gt; read permance are 220M/s and 315M/s inspectively, so their sequential<=
br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0performance=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 respectively,<br>
<br>
&gt; read speed could be approximately equal to 2:3, if we use stripe type<=
br>
&gt; to combine these two devices, their layout could be showed below:<br>
&gt; ------------------------------<wbr>--------------------------<br>
&gt; |=C2=A0 =C2=A0 A1=C2=A0 =C2=A0 |=C2=A0 =C2=A0 A2=C2=A0 =C2=A0 |=C2=A0 =
=C2=A0 B1=C2=A0 =C2=A0 |=C2=A0 =C2=A0 B2=C2=A0 =C2=A0 |=C2=A0 =C2=A0 B3=C2=
=A0 =C2=A0 |<br>
&gt; ------------------------------<wbr>--------------------------<br>
&gt;<br>
&gt; If we seletect asymmetric stripe type, their layout could be illustrat=
ed<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 select<br>
<br>
&gt; follow:<br>
&gt; ------------------------------<wbr>--------------------------<br>
&gt; |=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0B1=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|<br>
&gt; ------------------------------<wbr>--------------------------<br>
&gt;<br>
&gt; The former has 5 stripe devices and each stripe device has also equal<=
br>
&gt; chunk size, e.g.: 256secs. If there is a data block which size is<br>
&gt; 1280secs, so transfer the data to this stripe defvice will be split<br=
>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 device<br>
<br>
&gt; to 5 ios which io size is 256secs. But if we use the asymmetric<br>
&gt; stripe device, it only has two stripe devices and each one has be<br>
&gt; setting in optimal chunk size, e.g.: ratio is 2:3, the first one<br>
&gt; optimal chunk size is 512secs, the second is 768secs.=C2=A0 And same<b=
r>
&gt; 1280secs data block just only be splited two ios, this can be achieve<=
br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0split into two ios,<br>
<br>
&gt; perfect io performance.<br>
&gt;<br>
&gt; Change-Id: Iebaee3480e27022e2b3a7edbfb654<wbr>25b1166274e<br>
&gt; Signed-off-by: liuchaowei &lt;<a href=3D"mailto:tgvlcw@gmail.com">tgvl=
cw@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 Documentation/device-mapper/<wbr>asymmetric-striped.txt |=C2=A0 =
85 ++++<br>
&gt;=C2=A0 drivers/md/Kconfig=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 11 +<br>
&gt;=C2=A0 drivers/md/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =
=C2=A01 +<br>
&gt;=C2=A0 drivers/md/dm-asymmetric-<wbr>stripe.c=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 523 +++++++++++++++++++++<br>
&gt;=C2=A0 drivers/md/dm.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 =C2=A05 +<br>
&gt;=C2=A0 include/linux/device-mapper.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 15 +<br>
&gt;=C2=A0 6 files changed, 640 insertions(+)<br>
&gt;=C2=A0 create mode 100644 Documentation/device-mapper/<wbr>asymmetric-s=
triped.txt<br>
&gt;=C2=A0 create mode 100644 drivers/md/dm-asymmetric-<wbr>stripe.c<br>
&gt;<br>
&gt; diff --git a/Documentation/device-mapper/<wbr>asymmetric-striped.txt b=
/Documentation/device-mapper/<wbr>asymmetric-striped.txt<br>
&gt; new file mode 100644<br>
&gt; index 000000000000..0412a224a49e<br>
&gt; --- /dev/null<br>
&gt; +++ b/Documentation/device-mapper/<wbr>asymmetric-striped.txt<br>
&gt; @@ -0,0 +1,85 @@<br>
&gt; +dm-asymmetric-stripe<br>
&gt; +=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; +<br>
&gt; +Device-Mapper&#39;s &quot;asm-striped&quot; target is used to create =
a striped (i.e. RAID-0)<br>
&gt; +device across one or more underlying devices. Data is written in &quo=
t;chunks&quot;,<br>
&gt; +with consecutive chunks rotating among the underlying devices. This c=
an<br>
&gt; +potentially provide improved I/O throughput by utilizing several phys=
ical<br>
&gt; +devices in parallel. However, in order to gain maximum I/O performanc=
e bewteen<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 between<br>
<br>
&gt; +slow and fast device, there is a ratio to set up the chunk size among=
 these<br>
&gt; +device.<br>
&gt; +<br>
&gt; +Parameters: &lt;num devs&gt; &lt;chunk size&gt; &lt;ratio&gt; [&lt;de=
v path&gt; &lt;offset&gt;]+<br>
&gt; +&lt;num devs&gt;: Number of underlying devices.<br>
&gt; +&lt;chunk size&gt;: Size of each chunk of data. Must be at least as<b=
r>
&gt; +large as the system&#39;s PAGE_SIZE.<br>
&gt; +&lt;ratio&gt;: The proportion of per io size, it is the times as much=
<br>
&gt; +as 1 chunk size<br>
&gt; +&lt;dev path&gt;: Full pathname to the underlying block-device, or a<=
br>
&gt; +&quot;major:minor&quot; device-number.<br>
&gt; +&lt;offset&gt;: Starting sector within the device.<br>
&gt; +<br>
&gt; +One or more underlying devices can be specified. The striped device<b=
r>
&gt; +size must be a multiple of the chunk size multiplied by the number of=
 underlying<br>
&gt; +devices. However, there is a ratio can be setting, e.g.: 2:3 means th=
e first one<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0there is a ratio that can be set,<br>
<br>
&gt; +striped device optimal width size is 2 time as much as 1 chunk size, =
the second<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 t=
imes<br>
<br>
&gt; +striped device is 3.<br>
&gt; +<br>
&gt; +<br>
&gt; +Example scripts<br>
&gt; +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; +<br>
&gt; +[[<br>
&gt; +#!/usr/bin/perl -w<br>
&gt; +# Create a striped device across any number of underlying devices. Th=
e device<br>
&gt; +# will be called &quot;stripe_dev&quot; and have a chunk-size of 128k=
.<br>
&gt; +<br>
&gt; +my $chunk_size =3D 128 * 2;<br>
&gt; +my $ratio =3D &quot;2:3&quot;;<br>
&gt; +my $dev_name =3D &quot;stripe_dev&quot;;<br>
&gt; +my $num_devs =3D @ARGV;<br>
&gt; +my @devs =3D @ARGV;<br>
&gt; +<br>
&gt; +if ($num_devs &lt; 2) {<br>
&gt; +die(&quot;Specify at least two devices\n&quot;);<br>
&gt; +}<br>
&gt; +<br>
&gt; +<br>
&gt; +$stripe_average_size =3D 1073741824<br>
&gt; +$stripe_dev_size =3D $stripe_average_size * 5;<br>
&gt; +<br>
&gt; +$table =3D &quot;0 $stripe_dev_size asm-striped $num_devs $chunk_size=
 $ratio&quot;;<br>
&gt; +for ($i =3D 0; $i &lt; $num_devs; $i++) {<br>
&gt; +$table .=3D &quot; $devs[$i] 0&quot;;<br>
&gt; +}<br>
&gt; +<br>
&gt; +`echo $table | dmsetup create $dev_name`;<br>
&gt; +]]<br>
&gt; +<br>
&gt; +<br>
&gt; +Why asymmetric striped<br>
&gt; +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
<br>
&gt; +Considering one case:<br>
&gt; +There are 2 storage device or flash devices: A and B, their sequentia=
l<br>
&gt; +read permance are 220M/s and 315M/s inspectively, so their sequential=
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 performance=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 respectively,<br>
<br>
&gt; +read speed could be approximately equal to 2:3, if we use stripe type=
<br>
&gt; +to combine these two devices, their layout could be showed below:<br>
&gt; +-----------------------------<wbr>---------------------------<br>
&gt; +|=C2=A0 =C2=A0 A1=C2=A0 =C2=A0 |=C2=A0 =C2=A0 A2=C2=A0 =C2=A0 |=C2=A0=
 =C2=A0 B1=C2=A0 =C2=A0 |=C2=A0 =C2=A0 B2=C2=A0 =C2=A0 |=C2=A0 =C2=A0 B3=C2=
=A0 =C2=A0 |<br>
&gt; +-----------------------------<wbr>---------------------------<br>
&gt; +<br>
&gt; +If we seletect asymmetric stripe type, their layout could be illustra=
ted<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0select<br>
<br>
&gt; +follow:<br>
&gt; +-----------------------------<wbr>---------------------------<br>
&gt; +|=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0B1=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|<br>
&gt; +-----------------------------<wbr>---------------------------<br>
&gt; +<br>
&gt; +The former has 5 stripe devices and each stripe device has also equal=
<br>
&gt; +chunk size, e.g.: 256secs. If there is a data block which size is 128=
0secs,<br>
&gt; +so transfer the data to this stripe defvice will be split to 5 ios wh=
ich io<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0device<br=
>
<br>
&gt; +size is 256secs. But if we use the asymmetric stripe device, it only =
has two<br>
&gt; +stripe devices and each one has be setting in optimal chunk size, e.g=
.: ratio<br>
&gt; +is 2:3, the first one optimal chunk size is 512secs, the second is 76=
8secs.<br>
&gt; +And same 1280secs data block just only be splited two ios, this can b=
e achieve<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0split into two ios,<br>
<br>
&gt; +perfect io performance.<br>
&gt; +<br>
&gt; diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig<br>
&gt; index 7d5aa2c5c81d..4232b929c2f3 100644<br>
&gt; --- a/drivers/md/Kconfig<br>
&gt; +++ b/drivers/md/Kconfig<br>
&gt; @@ -455,6 +455,17 @@ config DM_FLAKEY<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0---help---<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A target that intermittently f=
ails I/O for debugging purposes.<br>
&gt;<br>
&gt; +config DM_ASYMMETRIC_STRIPE<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tristate &quot;DM asymmetric stripe(asymmetric ra=
id0)&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0depends on BLK_DEV_DM<br>
&gt; +=C2=A0 =C2=A0 =C2=A0---help---<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0This device-mapper target creates a asymme=
tric raid0/stripe device that<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 support asymmetric stripe chunk si=
ze and can gain same performance as<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 raid0 device<br>
<br>
Align &quot;support&quot; and &quot;raid0&quot; under &quot;This&quot;.=C2=
=A0 And end the sentence with a period (&quot;.&quot;).<br>
<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 You must configure the accurate ra=
tio between different physical storage<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 device respectively<br>
<br>
End sentence with a period.<br>
<br>
&gt; +<br>
&gt;=C2=A0 config DM_VERITY<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tristate &quot;Verity target support&quot;<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0depends on BLK_DEV_DM<br>
<br>
&gt; diff --git a/drivers/md/dm-asymmetric-<wbr>stripe.c b/drivers/md/dm-as=
ymmetric-<wbr>stripe.c<br>
&gt; new file mode 100644<br>
&gt; index 000000000000..4ef3915b435a<br>
&gt; --- /dev/null<br>
&gt; +++ b/drivers/md/dm-asymmetric-<wbr>stripe.c<br>
&gt; @@ -0,0 +1,523 @@<br>
&gt; +/*<br>
&gt; + * Copyright (C) 2018 Smartisan, Inc.<br>
&gt; + *<br>
&gt; + * This software is licensed under the terms of the GNU General Publi=
c<br>
&gt; + * License version 2, as published by the Free Software Foundation, a=
nd<br>
&gt; + * may be copied, distributed, and modified under those terms.<br>
&gt; + *<br>
&gt; + * This program is distributed in the hope that it will be useful,<br=
>
&gt; + * but WITHOUT ANY WARRANTY; without even the implied warranty of<br>
&gt; + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0 See the=
<br>
&gt; + * GNU General Public License for more details.<br>
&gt; + *<br>
&gt; + * Author: &lt;<a href=3D"mailto:tgvlcw@gmail.com">tgvlcw@gmail.com</=
a>&gt;<br>
&gt; + * Name: Henry Liu<br>
&gt; + *<br>
&gt; + */<br>
&gt; +<br>
&gt; +<br>
&gt; +#include &quot;dm.h&quot;<br>
&gt; +#include &lt;linux/device-mapper.h&gt;<br>
&gt; +<br>
<br>
#include &lt;linux/atomic.h&gt;<br>
<br>
&gt; +#include &lt;linux/module.h&gt;<br>
&gt; +#include &lt;linux/init.h&gt;<br>
<br>
#include &lt;linux/kernel.h&gt;<br>
<br>
&gt; +#include &lt;linux/blkdev.h&gt;<br>
&gt; +#include &lt;linux/bio.h&gt;<br>
<br>
#include &lt;linux/bitops.h&gt;<br>
<br>
&gt; +#include &lt;linux/slab.h&gt;<br>
&gt; +#include &lt;linux/log2.h&gt;<br>
<br>
#include &lt;linux/workqueue.h&gt;<br>
<br>
&gt; +<br>
&gt; +#define DM_MSG_PREFIX &quot;asm-striped&quot;<br>
&gt; +#define DM_IO_ERROR_THRESHOLD 15<br>
<br>
&gt; +/*<br>
&gt; + * An event is triggered whenever a drive<br>
&gt; + * drops out of a stripe volume.<br>
&gt; + */<br>
&gt; +static void trigger_event(struct work_struct *work)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0asm_stripe_c *sc =3D container_of(work, asm_strip=
e_c, trigger_event);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0dm_table_event(sc-&gt;ti-&gt;table);<br>
&gt; +}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0static inline<br>
<br>
Above line should not be indented.<br>
Above and below should be on one line if &lt;=3D 80 characters.<br>
<br>
&gt; +asm_stripe_c *alloc_context(unsigned int stripes)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0size_t len;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (dm_array_too_big(sizeof(asm_<wbr>stripe_c),<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sizeof(asm_stripe),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stripes))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0len =3D sizeof(asm_stripe_c) + (sizeof(asm_stripe=
) * stripes);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return kmalloc(len, GFP_KERNEL);<br>
&gt; +}<br>
<br>
&gt; +static int set_stripe_ratio(struct dm_target *ti,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0asm_stripe_c *sc,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *ratio_str)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *p;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned int i;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0uint32_t r =3D 0, ratio;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *tmp_ratio =3D ratio_str;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (sizeof(sc-&gt;ratio_str) &lt; strlen(ratio_st=
r)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ti-&gt;error =3D &quo=
t;Too big stripe ratio string&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0strlcpy(sc-&gt;ratio_str, ratio_str, strlen(ratio=
_str) + 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; sc-&gt;stripes; i++) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p=C2=A0 =3D strsep(&a=
mp;tmp_ratio, &quot;:&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (p =3D=3D NULL)<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (kstrtouint(p, 10,=
 &amp;ratio) || !ratio)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sc-&gt;stripe[i].rati=
o =3D ratio;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r +=3D ratio;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sc-&gt;total_ratio =3D r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sc-&gt;avg_width =3D ti-&gt;len / r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sc-&gt;stripe_size =3D r * sc-&gt;chunk_size;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +}<br>
<br>
Insert blank line here.<br>
<br>
&gt; +/*<br>
&gt; + * Construct a striped mapping.<br>
&gt; + * &lt;number of stripes&gt; &lt;chunk size&gt; &lt;ratio&gt; [&lt;de=
v_path&gt; &lt;offset&gt;]+<br>
&gt; + */<br>
&gt; +static int asymmetric_stripe_ctr(struct dm_target *ti,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int argc,<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char **argv)<br>
&gt; +{<br>
<br>
[snip]<br>
<br>
<br>
&gt; +static void asymmetric_stripe_map_range_<wbr>sector(asm_stripe_c *sc,=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sector_t sector,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t target_strip=
e,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sector_t *result)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sector_t width_offset;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0uint32_t stripe;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0width_offset =3D stripe_index_fetch(sc, &amp;sect=
or, &amp;stripe);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0*result =3D sector * sc-&gt;stripe[target_stripe]=
.opt_<wbr>io_size;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (target_stripe &lt; stripe)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*result +=3D sc-&gt;s=
tripe[target_stripe].opt_<wbr>io_size;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0else if (target_stripe =3D=3D stripe)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*result +=3D width_of=
fset;<br>
<br>
Here you don&#39;t expect target_stripe ever to be &gt; stripe, right?<br>
Then the last &quot;else if&quot; can just be &quot;else&quot;...<br>
<br>
<br>
&gt; +}<br>
&gt; +<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
--<br>
~Randy<br>
</font></span></blockquote></div><br></div>

--001a113dae329e9f74056137d7ce--


--===============4473442538617052610==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4473442538617052610==--
