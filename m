From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/2] multipath-tools: Housekeeping
Date: Sat,  4 Jun 2016 01:52:54 +0200
Message-ID: <1464997974-19881-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I don't know if you want to keep these ones:
[Hannes says, and Benjamin agrees:]

getuid/usb_id
> Huh? What is that doing there?
> It should really have been moved to the udev package ...

multipath/01_udev
multipath/02_multipath
> Not used anymore with systemd/dracut

Xose Vazquez Perez (2):
  multipath-tools: tarballs from gitweb
  multipath-tools: remove useless init scripts

 README                            |   4 +
 multipathd/multipathd.init.debian |  29 ------
 multipathd/multipathd.init.redhat | 152 -----------------------------
 multipathd/multipathd.init.suse   | 200 --------------------------------------
 4 files changed, 4 insertions(+), 381 deletions(-)
 delete mode 100644 multipathd/multipathd.init.debian
 delete mode 100644 multipathd/multipathd.init.redhat
 delete mode 100644 multipathd/multipathd.init.suse

-- 
2.5.5
