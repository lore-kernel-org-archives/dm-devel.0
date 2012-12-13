From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Failed pvmove causes freeze of lvm in Total
Date: Thu, 13 Dec 2012 08:20:41 +0100
Message-ID: <CAG2kNCxa2VDW+B=iXqf76m=XFy8D8YDuy0QcAdPpCzOi2cFzNg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2368182611338967113=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2368182611338967113==
Content-Type: multipart/alternative; boundary=047d7b2e42aca3a89604d0b6c0c6

--047d7b2e42aca3a89604d0b6c0c6
Content-Type: text/plain; charset=UTF-8

Hello,
Rhel 5.8.
Lvm tags enabled.
So, my pvmove command fails because it cannot activate the temporary
mirror...
But now on, all command related to lvm, also for other vg, completely
freeze..
Any wait to unblock?
I tried removing the volume_list directive in lvm.conf, but no way...
I would like to avoid doing power off if possible..
Thanks Gianluca

--047d7b2e42aca3a89604d0b6c0c6
Content-Type: text/html; charset=UTF-8

<p dir="ltr">Hello,<br>
Rhel 5.8.<br>
Lvm tags enabled.<br>
So, my pvmove command fails because it cannot activate the temporary mirror...<br>
But now on, all command related to lvm, also for other vg, completely freeze..<br>
Any wait to unblock?<br>
I tried removing the volume_list directive in lvm.conf, but no way...<br>
I would like to avoid doing power off if possible..<br>
Thanks Gianluca</p>

--047d7b2e42aca3a89604d0b6c0c6--


--===============2368182611338967113==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2368182611338967113==--
