From: Bastien Durel <bastien+lvm@durel.org>
Subject: lvmetad in initrd hangs, blocking further lvm calls
Date: Fri, 05 Sep 2014 15:49:53 +0200
Message-ID: <5409BF81.7060404@durel.org>
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
To: linux-lvm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I got a machine running archlinux that have a problem on boot. It hangs
for 90s waiting for pvscan on block devices, and then give up.
(actually, the pvscan process are still stuck, and any lvm command after
that will hang too). Sometimes it works well (one in ten time maybe).

After some digging, it looks like lvmetad(8) is responsible for this
hang, as it hangs itself at start:

lvmetad[360]: Cannot lock lockfile [/run/lvmetad.pid], error was
[Resource temporarily unavailable]
If I kill it and start it again after boot, the hanging pvscan processes
are unlocked, finish their works, and everything goes back to normal
(lvm commands works again, etc.)

You can see this in logs : http://pastebin.com/Tem7TMzE
I also got some info on running processes: http://pastebin.com/nucQARFi

I tried to lower verbosity of lvmetad, but I only get the error given.

sometimes the boot is a little longer than usual (waiting for root
partition), and lvmetad starts well (I'm not sure it's really related,
though)

the "cannot log logfile" error appears when fcntl() fails with EAGAIN (a
file to be locked is already shared-locked or exclusive-locked by
another process)
there is a lvmetad running on the system, with a very little pid (way
littler than the failing process we see in logs)
the lvmetad process spawned by lvm2-lvmetad.service is run with -f, so
the running one is not this one
the first one was started 3 seconds before the second (before systemd)
the cleanup hook of lvm2 component for initrd should kill the early
lvmetad, dont for a reason it does not work:

run_cleanuphook() {
    kill $(cat /run/lvmetad.pid)
}
killing the process after boot don't work neither

I took a debug trace (http://pastebin.com/4mpNBL8t), and it looks like
the main thread is waiting for terminations of other threads, and there
is a client_thread stuck on a read on fd 6 (/run/lvm/lvmetad.socket)

I've posted (https://bugs.archlinux.org/task/41833) on Arch bugtracker,
where someone said me to forward upstream.

-- 
Bastien Durel
