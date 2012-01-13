From: HyoGi Sim <sandrain@gmail.com>
Subject: communication between a dm target and a userspace
	application
Date: Fri, 13 Jan 2012 13:17:54 -0500
Message-ID: <CAFUgR=pfQ5qJ3GO8twZGAn8xgQ7eZS6xQ27hY6i+CVj-C5ZMxQ@mail.gmail.com>
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

Hi,

I'm working with a dm device which needs a way to communicate with a
userspace application as follows:

1. The application gives a list of sectors which should be updated in
an async way by the dm device.
2. The application requests to the dm device a list of sectors which
meet with some condition.

What is a good way to implement this?
I'm rather new to the kernel as well as device mapper, and possible
ways that I can imagine are:

1. adding ioctl (is it possible/ok to have target specific ioctl command?)
2. creating a sysfs/proc entry

Or do you think it's a bad idea that the userspace application and the
dm device communicate in that way?

Thanks,
Hyogi
