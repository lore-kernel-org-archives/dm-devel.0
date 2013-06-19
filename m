From: Kyle Manna <kyle.manna@gmail.com>
Subject: Proper dm-cache shutdown
Date: Tue, 18 Jun 2013 18:39:48 -0700
Message-ID: <CAM9fjH4PYKsidH+buZkmRQ5GMMNd_sOkxvqfxpctP-zQn9y9uw@mail.gmail.com>
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

What is the proper shutdown sequence for dm-cache?  Should I be
disassembling the dm device everytime?

There is a section in Documentation/device-mapper/cache.txt that
suggests that I should:

    The 'dirty' state for a cache block changes far too frequently for us
    to keep updating it on the fly.  So we treat it as a hint.  In normal
    operation it will be written when the dm device is suspended.  If the
    system crashes all cache blocks will be assumed dirty when restarted.

Right now I'm using the following:

    (wait for standard init system to unmount the filesystem)
    dmsetup suspend home-cached
    dmsetup remove home-cached
    dmsetup remove ssd-blocks
    dmsetup remove ssd-metadata

I assume the suspend will accomplish the syncing of the metadata
according to the Docs.  Is tearing down the dm nodes under it of any
value during a shutdown or reboot?

Thanks,
- Kyle
