From: "rohit vashist" <rohitvashist2kk3@gmail.com>
Subject: Regarding dm-linear.c
Date: Fri, 12 Sep 2008 22:48:00 +0530
Message-ID: <42a668660809121018x4f43f72am2b610bf49d0c4788@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0596101981=="
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

--===============0596101981==
Content-Type: multipart/alternative;
	boundary="----=_Part_129665_18331849.1221239880190"

------=_Part_129665_18331849.1221239880190
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I am currently working on device mapper and logical volume manager.My
question is whether dm-linear.c 's
function linear_ctr and linear_map is called or not when we do lvcreate.(or
vgcreate,pvcreate).I am concentrating
on linear mapping only.I did strace but i m not able to figure it out.

Thank You
Rohit

------=_Part_129665_18331849.1221239880190
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi,<br><br>I am currently working on device mapper and logical volume manager.My question is whether dm-linear.c &#39;s <br>function linear_ctr and linear_map is called or not when we do lvcreate.(or vgcreate,pvcreate).I am concentrating<br>
on linear mapping only.I did strace but i m not able to figure it out.<br><br>Thank You<br>Rohit<br><br><br><br><br><br></div>

------=_Part_129665_18331849.1221239880190--


--===============0596101981==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0596101981==--
