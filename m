From: li nux <lnxluv@yahoo.com>
Subject: Unable to get INQUIRY vpd 1 page 0x0
Date: Mon, 13 Mar 2006 03:00:46 -0800 (PST)
Message-ID: <20060313110046.91886.qmail@web33302.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

On doing a '/etc/init.d/boot.udev start' or 'multipath
-v2 -d' i get following error for all the devices:

creating device nodes 0:0:0:0: sg_io failed status 0x0
0x1 0x0 0x0
0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
0:0:0:1: sg_io failed status 0x0 0x1 0x0 0x0

Can somebody have an idea, what i need to correct.

-lnxluv

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around=20
http://mail.yahoo.com=20
