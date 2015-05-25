From: Milan Broz <mbroz@redhat.com>
Subject: Re: dmsetup remove gives EBUSY (even though it shouldn't
	be busy)
Date: Mon, 25 May 2015 14:38:43 +0200
Message-ID: <556317D3.6070901@redhat.com>
References: <5562513D.3080203@gmx.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5562513D.3080203@gmx.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/25/2015 12:31 AM, Johannes Bauer wrote:
> This is my problem: I have a open dm-crypt mapping (LUKS) on which I do
> perform some block operations (copying). There are no mounted file
> systems on the copied device handles at any time. Let's say my device is
> called under /dev/mapper/foobar and I'm writing to that block device.
> 
> The file descriptor that points to the /dev/mapper/foobar is then closed
> via close(2). Then I call sync(2).
> 
> Afterwards I fork/exec the command "dmsetup remove foobar". This yields:
> 
> device-mapper: remove ioctl on foobar failed: Device or resource busy
> Command failed

Usually this is caused by running blkid (automatically running from udev rules)
which react to close-on-write on the device and keep the device open while scanning.
(You can try to run lsof, there is a chance you will see the process blocking
this device.)

Recent device mapper tries to retry removal operation, so if you use
recent dmsetup (or cryptsetup close command) you should see that it
tries several times.

First option is to disable WATCH rule in udev rules and check if this helps.
(Unfortunately this has some side effects.)

Better solution is probably explicitly call "udevadm settle" instead
of sleep(). Still not perfect (it waits for all devices/udev processes),
but I am afraid there is nothing better yet to synchronize with these scans.

Milan
