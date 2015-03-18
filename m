From: Maxim Patlasov <mpatlasov@parallels.com>
Subject: dm thin: How to shrink think pool device?
Date: Wed, 18 Mar 2015 16:46:17 -0700
Message-ID: <CAFmwnFZU56G8EAHprspPhsXsihRj017RhuansYtgEAuoCBG9qA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2478856125817616881=="
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

--===============2478856125817616881==
Content-Type: multipart/alternative; boundary=047d7bf0f5fe8229ba051198b099

--047d7bf0f5fe8229ba051198b099
Content-Type: text/plain; charset=UTF-8

Hi,

It seems that a "trim" pool message was planned long time ago, but never
implemented. Could someone update about current status of that? The
question came from the following use-case:

Suppose we have a thin pool on top of LVM volume group. The group comprises
of several storage drives. Now I need to (physically) remove one of them.
The intention is to use pvmove and vgreduce, but obviously thin pool must
be requested to shrink itself at first.

Btw, Documentation/device-mapper/thin-provisioning.txt still has a leftover
about it:

> If you wish to reduce the size of your thin device and potentially
> regain some space then send the 'trim' message to the pool.

Thanks,
Maxim

--047d7bf0f5fe8229ba051198b099
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div>Hi,<br><br></div>It seems that a =
&quot;trim&quot; pool message was planned long time ago, but never implemen=
ted. Could someone update about current status of that? The question came f=
rom the following use-case:<br><br></div>Suppose we have a thin pool on top=
 of LVM volume group. The group comprises of several storage drives. Now I =
need to (physically) remove one of them. The intention is to use pvmove and=
 vgreduce, but obviously thin pool must be requested to shrink itself at fi=
rst.<br><br></div>Btw, Documentation/device-mapper/thin-provisioning.txt st=
ill has a leftover about it:<br><br>&gt; If you wish to reduce the size of =
your thin device and potentially<br>&gt; regain some space then send the &#=
39;trim&#39; message to the pool.<br><br></div>Thanks,<br></div>Maxim<br></=
div>

--047d7bf0f5fe8229ba051198b099--


--===============2478856125817616881==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2478856125817616881==--
