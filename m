From: Stephan =?utf-8?Q?Austerm=C3=BChle?= <au@hcsd.de>
Subject: Re: dm-multipath: multipath setup okay,
	nothing in /dev/disk/by-name (solved)
Date: Mon, 13 Feb 2006 18:16:31 +0100 (CET)
Message-ID: <60031.194.39.131.40.1139850991.squirrel@www.hcsd.de>
References: <57309.194.39.131.39.1139845883.squirrel@www.hcsd.de>
	<1139846514.7784.9.camel@zezette>
	<37637.194.39.131.39.1139847251.squirrel@www.hcsd.de>
	<43F0495D.D2F3.0050.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43F0495D.D2F3.0050.0@novell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kevin Lyons <klyons@novell.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Kevin,

> On SLES, the symlinks are created by the udev system.  The symlinks are
> created by a rule in the /etc/udev/udev.rules file similar to the
> following:
>
> KERNEL=3D"dm-[0-9]*", PROGRAM=3D"/sbin/devmap_name %M %m", NAME=3D"%k"
> SYMLINK=3D"disk/by-name/%c"

That's it! A more recent version of the udev package creates the symlink.

Thanks a lot!

Stephan
