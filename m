From: Lupe Christoph <lupe@lupe-christoph.de>
Subject: Changes in multipathing between 0.4.5 (SLES9) and 0.4.7
	(SLES10)
Date: Thu, 26 Mar 2009 17:06:41 +0100
Message-ID: <20090326160641.GA12038@lupe-christoph.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi!

I just ran into a strange difference in the behavious of multipathing
between SLES9 and SLES10. While SLES9 seemed to ignore single-pathed
disks like volumes on the internal RAID controller of IBM xSeries,
SLES10 welcomes them leading to different pathes in /etc/fstab.

There is a lot of our software involved in this behavious, so let's just
say that the change is unwelcome ;-)

We have for now overcome this by blacklisting the internal RAID
controller. But there are many types of RAID controllers involved (the
machines have all hardware-mirrored internal disks), so we would like to
have a better solution.

Is there a way to tell the multipath-tools to ignore devices that have
only a single path? I found nothing in the multipath.conf manpage, but
maybe I read it wrong.

Thanks for any help!
Luipe Christoph
-- 
| There is no substitute for bad design except worse design.                   |
| /me                                                                          |
