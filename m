From: Luca Berra <bluca@comedia.it>
Subject: Re: New disk under /dev/mapper control??
Date: Tue, 10 Apr 2007 07:25:36 +0200
Message-ID: <20070410052536.GA1464@percy.comedia.it>
References: <44864.131.225.80.2.1176154166.squirrel@mail.linuxscope.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <44864.131.225.80.2.1176154166.squirrel@mail.linuxscope.com>
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

On Mon, Apr 09, 2007 at 04:29:26PM -0500, Paul Tader wrote:
>I've added a new, single IDE disk to a system.  I've run though fdisk,
It does not look "new" to me...

>mkfs and then attempted a mount command but mount failed with "already
>mounted or /mnt/ busy".  I see that now device-mapper is "claiming" this
>disk and newly created partitions and doesn't allow me to mount the
>partitions by addressing the /dev/hdb1 device file. In other words,
>/dev/mapper files are being automatically created only for this (new)
>disk.  Is there a way to have device-mapper relinquish control of this
>disk?
it is not device mapper, but dmraid
i believe your ide disk was 'touched' by a promise fakeraid controller.
your init scripts probably call dmraid during boot and finding a promise
fakeraid metadata on the disk dmraid activates it.

>I've tried removing and clearing the devices with dmsetup, all to no avail.
you could try removing the fakeraid metadata with dmraid -E.
if the promise fakeraid adapter is installed in your PC you might have
to disable fakeraid in the bios first.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
