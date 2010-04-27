From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: semop failed for cookie?
Date: Tue, 27 Apr 2010 15:56:57 -0500
Message-ID: <4BD74F99.8020605@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
Cc: Sebastian Dziallas <sdz@sugarlabs.org>, satellit@bendbroadband.com
List-Id: dm-devel.ids

Hi,

I have a user of an installation tool of mine that is hitting this 
message, with a very recent pre-fedora-13 kernel.

zyx-liveinstaller-cli: creating temporary rootfs virtual duplicate
device-mapper: resume ioctl failed: Invalid argument
semid 65536: semop failed for cookie 0xd4d423c: incorrect semaphore state
Failed to set a proper state for notification semaphore identified by 
cookie value 223167036 (0xd4d423c) to initialize waiting for incoming 
notifications.
Command failed
zyx-liveinstaller-cli: error: failed to create temporary rootfs virtual 
duplicate

The error is happening at line 742 in this monster bash script (which 
I'm pretty sure does work on f11 and f12)

http://filteredperception.org/dawg/projects/zyx-liveinstaller/src/zyx-liveinstaller-latest/rli/zyx-liveinstaller-cli.html

http://filteredperception.org/dawg/projects/zyx-liveinstaller

Now, I've already urged the sugar on a stick project to primarily pursue 
the path of the standard fedora livecd/usb installer, for many 
additional reasons.  But, I guess I would still like my rebootless 
installer to actually work.  And this may be one of those great corner 
case issues that developers love.  I.e. a very obscure tickling of some 
code path.  Or maybe I'm just being too lazy to read the accompanying 
dmsetup man page for some clue as to what I should be doing when I see 
such a bizarre error message.  Or, some other bug in the script is 
causing the arguments to become malformed.  Still, the crypticness of 
the message from devicemapper suggests something you folks might want to 
improve.  In any event, FWIW, there it is...

-dmc
