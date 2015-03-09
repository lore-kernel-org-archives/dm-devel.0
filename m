From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 11/15] multipath: enable configuration
 directory
Date: Mon, 9 Mar 2015 01:42:48 +0100
Message-ID: <20150309014248.00007306@localhost>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
	<1425785506-20419-12-git-send-email-bmarzins@redhat.com>
	<20150308232706.000039e7@localhost>
	<CABr-GncekSo0WLREj6B2XZehaEvbd32vcAt747bcJufgqd+nnA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GncekSo0WLREj6B2XZehaEvbd32vcAt747bcJufgqd+nnA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Christophe Varoqui wrote:
> I had the same thought reading the patch, but I couldn't see any
> consistency in existing "*.d" directory locations in modern distros I
> couldn't decently object to Ben's proposal :

On my fairly recent openSUSE I (also) have

> Following Ben's proposal :
> /etc/udev/*.d
> /etc/mysql/conf.d
> /etc/apm/*.d

/etc/X11/xorg.conf.d
/etc/fonts/conf.d
 
> Following your proposal :
> /etc/rsyslog.d
> /etc/sysctl.d
> /etc/profile.d

/etc/auto.master.d
/etc/ld.so.conf.d
/etc/sudoers.d
/etc/permissions.d
/etc/aliases.d
/etc/gdbinit.d
 
> Does somebody know if the LSB FHS gives guidelines for this ?
> 
> Best regards,
> Christophe Varoqui

Sebastian
