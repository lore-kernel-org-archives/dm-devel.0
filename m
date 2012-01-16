From: Yukihito HARA <yukihito.hara623@gmail.com>
Subject: About the thin provision function @ kernel 3.2 or later.
Date: Mon, 16 Jan 2012 10:27:34 +0900
Message-ID: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6201622116181064915=="
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

--===============6201622116181064915==
Content-Type: multipart/alternative; boundary=20cf307cfc608188d904b69b1e7e

--20cf307cfc608188d904b69b1e7e
Content-Type: text/plain; charset=ISO-8859-1

Hi, I'm Yukihito, and interested in Linux system.

Recently days, I became happy to hear that Linux kernel start to support
thin-provisioning function.
And not trying to how it work on latest kernel.

According to the word "thin provisioning", I'm imaging that, I can get
larger space than actual disk size. This image is born from
thin-provisioning system working on VMWare series.
And can write the files until reach to the physical maximum. Once reach to
the physical maximum, I can't write any more files to that volume, but I
can write more files after add additional physical disks to thin-pool.

I could create the pool according to the documents included in the kernel
source(Documentation/device-mapper/thin-provisioning.txt).
But I'm not sure, it works as I expecting like above.

So can you provide more detailed documentation about the thin-provisioning,
if you have?
There're no documentation written in Japanese, so I'll also output this
communication to wiki or my twitter in Japanese. It helpful to make your
work more major among Japanese IT engineers. And you can get more feedback
if the challengers in Japan will be increased.
The worst point of the current documentation is, it's not instruct about
how to use like above. Can't get image how to use this like VMware system
from that document.

Sorry, this is my private testing, not for work. So I can't get much time
to this, but very interested in.


I'm looking forward to your answer.

Thank you.
Yukihito.

--20cf307cfc608188d904b69b1e7e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi, I&#39;m Yukihito, and interested in Linux system.<br><br>Recently days,=
 I became happy to hear that Linux kernel start to support thin-provisionin=
g function.<br>And not trying to how it work on latest kernel.<br><br>Accor=
ding to the word &quot;thin provisioning&quot;, I&#39;m imaging that, I can=
 get larger space than actual disk size. This image is born from thin-provi=
sioning system working on VMWare series.<br>
And can write the files until reach to the physical maximum. Once reach to =
the physical maximum, I can&#39;t write any more files to that volume, but =
I can write more files after add additional physical disks to thin-pool.<br=
>
<br>I could create the pool according to the documents included in the kern=
el source(Documentation/device-mapper/thin-provisioning.txt).<br>But I&#39;=
m not sure, it works as I expecting like above.<br><br>So can you provide m=
ore detailed documentation about the thin-provisioning, if you have?<br>
There&#39;re no documentation written in Japanese, so I&#39;ll also output =
this communication to wiki or my twitter in Japanese. It helpful to make yo=
ur work more major among Japanese IT engineers. And you can get more feedba=
ck if the challengers in Japan will be increased.<br>
The worst point of the current documentation is, it&#39;s not instruct abou=
t how to use like above. Can&#39;t get image how to use this like VMware sy=
stem from that document.<br><br>Sorry, this is my private testing, not for =
work. So I can&#39;t get much time to this, but very interested in.<br>
<br><br>I&#39;m looking forward to your answer.<br><br>Thank you.<br>Yukihi=
to.<br>

--20cf307cfc608188d904b69b1e7e--


--===============6201622116181064915==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6201622116181064915==--
