From: "David Guyon Martin" <david.guyonmartin@gmail.com>
Subject: device mapper integrated loops - and one more year !
Date: Thu, 5 Oct 2006 16:26:54 +0200
Message-ID: <2c53b31c0610050726o47e6784en417de93b98d15e50@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0479858206=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============0479858206==
Content-Type: multipart/alternative;
	boundary="----=_Part_11298_30099163.1160058414050"

------=_Part_11298_30099163.1160058414050
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

Do you think dm could have a loop target instead of seting loops with
losetup ?
We allready have dm-crypt for the encryption stage of a "losetup -e
<crypt>", dm replaces losetup when source is a device but I understand that
we still need losetup if the source is a regular file.
Our problem is that we will need to map a great number of files, as if they
were PVs of a VG. Linux kernel can have up to 255 loops but we will reach
this limit.

The idea is to embed to loop itself in a device mapper add-on like dm-crypt,
so we won't use any /dev/loop* .

Do you think this is stupid or is there some possility out there ?
(we would like to have some advice before starting any project in this
direction)

Thank you,
David G.M.

PS:
Anniversary of this post, one year ago !
http://www.redhat.com/archives/dm-devel/2005-October/msg00031.html

------=_Part_11298_30099163.1160058414050
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,<br>
<br>
Do you think dm could have a loop target instead of seting loops with losetup ?<br>
We allready have dm-crypt for the encryption stage of a &quot;losetup -e
&lt;crypt&gt;&quot;, dm replaces losetup when source is a device but I
understand that we still need losetup if the source is a regular file.<br>
Our problem is that we will need to map a great number of files, as if
they were PVs of a VG. Linux kernel can have up to 255 loops but we
will reach this limit.<br>
<br>
The idea is to embed to loop itself in a device mapper add-on like dm-crypt, so we won't use any /dev/loop* .<br>
<br>
Do you think this is stupid or is there some possility out there ?<br>
(we would like to have some advice before starting any project in this direction)<br>
<br>
Thank you,<br>
David G.M.<br>
<br>
PS:<br>
Anniversary of this post, one year ago !<br>
<a href="http://www.redhat.com/archives/dm-devel/2005-October/msg00031.html">http://www.redhat.com/archives/dm-devel/2005-October/msg00031.html</a><br>

------=_Part_11298_30099163.1160058414050--


--===============0479858206==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0479858206==--
