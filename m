From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: SUSE multipath-tools patch resync
Date: Wed, 25 May 2011 14:22:06 +0200
Message-ID: <1306326126.2290.33.camel@lapoo.opensvc.com>
References: <4DD3DFC0.9050300@suse.de>
	<1306309907.2290.14.camel@lapoo.opensvc.com> <4DDCC72A.8000601@suse.de>
	<1306322079.2290.25.camel@lapoo.opensvc.com>
	<1306325431.2290.30.camel@lapoo.opensvc.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1306325431.2290.30.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Well, forget it ... it was just a matter of 'make clean && make' as some
> structures changed length.
> 
> The merge is over and pushed to korg.
> I catched only to problems.
> You might want to review the fixes.
> 
Hmm, there might be other problems.

on a 'multipathd reconfigure' command, the uxclient gets stuck and the
multipathd daemon strace shows:

$ sudo strace -f -p 17721
Process 17721 attached with 7 threads - interrupt to quit
[pid 17757] futex(0x7fdc6a1540a4, FUTEX_WAIT_PRIVATE, 3, NULL
<unfinished ...>
[pid 17756] futex(0x11167f0, FUTEX_WAIT_PRIVATE, 2, NULL
<unfinished ...>
[pid 17755] ioctl(3, DM_DEV_WAIT <unfinished ...>
[pid 17724] futex(0x11167f0, FUTEX_WAIT_PRIVATE, 2, NULL
<unfinished ...>
[pid 17723] recvmsg(6,  <unfinished ...>
[pid 17722] futex(0x110a1b4, FUTEX_WAIT_PRIVATE, 15, NULL
<unfinished ...>
[pid 17721] futex(0x612624, FUTEX_WAIT_PRIVATE, 1, NULL

-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
