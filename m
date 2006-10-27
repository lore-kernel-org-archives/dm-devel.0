From: lnx dm <lnxdm@yahoo.com>
Subject: dm-0
Date: Fri, 27 Oct 2006 00:34:51 -0700 (PDT)
Message-ID: <20061027073451.33894.qmail@web56112.mail.re3.yahoo.com>
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
To: dm <dm-devel@redhat.com>
List-Id: dm-devel.ids

will dm-0 will always point to the same device across
reboots irrespective of the the order in which devices
are detected ?
which is persistent /dev/dm-0 or /dev/mapper/<wwid> ?

# ls -l /dev/mpath/
lrwxrwxrwx  1 root root 7 Mar 24 01:45
3600805f300176640a435a927359c0003 -> ../dm-0

-lnxdm

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around=20
http://mail.yahoo.com=20
