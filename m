From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: clustered snapshots status,
	LVM on shared storage without CLVM?
Date: Mon, 28 Feb 2011 22:28:44 +0100
Message-ID: <20110228212844.GB2173@nik-comp.lan>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: nikola.ciprich@linuxbox.cz
List-Id: dm-devel.ids

Hello,
I'd like to ask, what is the current status of cluster locking patches?
I'm especially interested in clustered snapshots, is there some
estimate on when I could be suitable for testing and possibly
closer to production?
I'd like to use DMLoop on my clustered storage (as well as snapshots
in general), but with CLVM it's not really possible.
If the time is not close yet, my second question is - is it
dangerous to use LVM on top of shared storage without using CLVM?
If I'll take care to not run lvm commands from more then one node?
I'll be gratefull for any reply from more more experienced users
in this area.
thanks a lot in advance!
with best regards
nik


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
