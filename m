From: Sethuraman Subbiah <ssubbia2@ncsu.edu>
Subject: Help ! : device-mapper: reload ioctl failed: Invalid
	argument
Date: Thu, 16 Sep 2010 19:08:03 -0400
Message-ID: <AANLkTi=jPyz77ZSC64w6K_vHYU1JxsNjooY1PECNO_F8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7331936917291961112=="
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

--===============7331936917291961112==
Content-Type: multipart/alternative; boundary=0016e64ca94e6ed86c04906886a3

--0016e64ca94e6ed86c04906886a3
Content-Type: text/plain; charset=ISO-8859-1

Hi ,

This is Sethuraman Subbiah , a student at NCState. I installed DM-IOBAND. I
needed that for a project.

I downloaded a kernel module binary and used insmod to insert the module. It
worked and i did modprobe.

When I gave dmsetup targets | grep ioband
I got ioband v1.14.0

It was fine till that step.

When I try to associate /dev/sda3 with ioband1 :

echo "0 $(blockdev --getsize /dev/sda3) ioband /dev/sda3 1 0 0 none weight 0
:40" | dmsetup create ioband1

I keep getting this error :
device-mapper: reload ioctl failed: Invalid argument
Command failed


Can someone help me out ? Thanks !

-
Regards,
Sethuraman Subbiah

Graduate Student - NC state University
M.S in Computer Science

--0016e64ca94e6ed86c04906886a3
Content-Type: text/html; charset=ISO-8859-1

Hi , <br>
<br>
This is Sethuraman Subbiah , a student at NCState. I installed DM-IOBAND. I needed that for a project. <br>
<br>
I downloaded a kernel module binary and used insmod to insert the module. It worked and i did modprobe. <br>
<br>
When I gave dmsetup targets | grep ioband <br>
I got ioband    v1.14.0<br>
<br>
It was fine till that step. <br>
<br>
When I try to associate /dev/sda3 with ioband1 : <br>
<br>
echo &quot;0 $(blockdev --getsize /dev/sda3) ioband /dev/sda3 1 0 0 none weight 0 :40&quot; | dmsetup create ioband1<br>
<br>
I keep getting this error : <br>
device-mapper: reload ioctl failed: Invalid argument<br>
Command failed<br>
<br>
<br>
Can someone help me out ? Thanks !<br>
<br>-<br>Regards,<br>Sethuraman Subbiah<br><br>Graduate Student - NC state University<br>M.S in Computer Science<br>

--0016e64ca94e6ed86c04906886a3--


--===============7331936917291961112==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7331936917291961112==--
