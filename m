From: markw@mohawksoft.com
Subject: Getting dm extent mapping
Date: Mon, 17 Oct 2011 13:15:36 -0400
Message-ID: <86e7fc50eb867c64d1cc9c1ad74cdf8f.squirrel@mail.mohawksoft.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Is it possible to get a list of extents mapped to an object from an ioctl
call?

The reason why I am asking is that I need to be able to calculate the
deltas between a snapshot and a real device. For instance:

Suppose I have a virtual machine on device /dev/lvmvol/vmserver. I create
a snapshot of that device named /dev/lvmvol/vmsnap.

If I could get a list of the extents used to constitute "vmserver" and the
extents that constitute "vmsnap" I could calculate how much has changed
and what ranges I need to actually backup. Obviously, there has to be some
way to map "extents" to locations on the device itself in order for this
to work.

I have looked in the dm code and can not see if this is possible.

Thanks,

Mark
