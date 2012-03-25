From: Amar Mudrankit <amar.mudrankit@gmail.com>
Subject: Query about dm device max_discard_sectors
Date: Sun, 25 Mar 2012 18:46:26 -0400
Message-ID: <CAL08bwfwD0wtOvum-oeA=skLfQQ_BKSmwJ-ZQbZ+RBwduEJm_A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1323336373635154772=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============1323336373635154772==
Content-Type: multipart/alternative; boundary=14dae9340d2925793304bc190767

--14dae9340d2925793304bc190767
Content-Type: text/plain; charset=ISO-8859-1

Hi all,

I am building an experimental device mapper target which is supposed to
receive
all TRIM requests (REQ_DISCARD).  Irrespective of whether underlying actual
physical block device supports discards or not, my device mapper target
should
receive REQ_DISCARD bios.

In my target, I set:

ti->num_discard_requests = 1;
ti->discards_supported = 1;

It looks like setting above 2 parameters did not get me any REQ_DISCARD
requests when "fstrim" utility is used.  The operations fails with
"Operation not
supported" from kernel funcion:

blkdev_issue_discard

because max_discard_sectors for device queue is set to 0.

max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
if (unlikely(!max_discard_sectors))
       return -EOPNOTSUPP;

When I further digged into the device mapper code, I found that
dm_calculate_queue_limits function sets the queue limits to default values
of 0 for both limits as well as ti_limits and thus blk_stack_limits
eventually
sets max_discard_sectors to 0 for the device mapper target.

So, if my device mapper target does not implement iterate_devices function
(used to set max_discard_sectors based on underlying physical device's
discard
support) or underlying physical device does not support discards, then there
is no way for device mapper target to set max_discard_sectors more than 0
to receive REQ_DISCARD commands.

Is this analysis correct? Or I am missing something?

Appreciate the help / advice.

Thanks and Regards,
Amar

--14dae9340d2925793304bc190767
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,<br><br>I am building an experimental device mapper target which is =
supposed to receive<br>all TRIM requests (REQ_DISCARD).=A0 Irrespective of =
whether underlying actual<br>physical block device supports discards or not=
, my device mapper target should<br>
receive REQ_DISCARD bios.<br><br>
In my target, I set:<br><br>ti-&gt;num_discard_requests =3D 1;<br>ti-&gt;di=
scards_supported =3D 1;<br><br>It looks like setting above 2 parameters did=
 not get me any REQ_DISCARD<br>requests when &quot;fstrim&quot; utility is =
used.=A0 The operations fails with &quot;Operation not<br>
supported&quot; from kernel funcion:<br><br>blkdev_issue_discard<br><br>bec=
ause max_discard_sectors for device queue is set to 0.<br><br>max_discard_s=
ectors =3D min(q-&gt;limits.max_discard_sectors, UINT_MAX &gt;&gt; 9);<br>
if (unlikely(!max_discard_sectors))<br>=A0=A0=A0=A0=A0=A0 return -EOPNOTSUP=
P;<br><br>When I further digged into the device mapper code, I found that<b=
r>dm_calculate_queue_limits function sets the queue limits to default value=
s<br>of 0 for both limits as well as ti_limits and thus blk_stack_limits ev=
entually<br>
sets max_discard_sectors to 0 for the device mapper target.<br><br>So, if m=
y device mapper target does not implement iterate_devices function<br>(used=
 to set max_discard_sectors based on underlying physical device&#39;s disca=
rd<br>
support) or underlying physical device does not support discards, then ther=
e<br>is no way for device mapper target to set max_discard_sectors more tha=
n 0<br>to receive REQ_DISCARD commands.<br><br>Is this analysis correct? Or=
 I am missing something?<br>
<br>Appreciate the help / advice.<br><br>Thanks and Regards,<br>Amar<br><br=
><br><br>

--14dae9340d2925793304bc190767--


--===============1323336373635154772==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1323336373635154772==--
