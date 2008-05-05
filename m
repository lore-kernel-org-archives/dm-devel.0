From: "Marti Raudsepp" <marti@juffo.org>
Subject: Re: PROBLEM: powertop reports 8000 spurious interrupts/s
	from USB disk
Date: Mon, 5 May 2008 06:14:54 +0300
Message-ID: <54b33ccd0805042014j3773db72s3843c76f01fd0e54@mail.gmail.com>
References: <54b33ccd0805040924x55ad1fcesb3c9f50870043312@mail.gmail.com>
	<20080505001353.GF22961@one-eyed-alien.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080505001353.GF22961@one-eyed-alien.net>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <dbrownell@users.sourceforge.net>
Cc: Linux USB storage list <usb-storage@lists.one-eyed-alien.net>, device-mapper list <dm-devel@redhat.com>, Linux USB list <linux-usb@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, May 5, 2008 at 3:13 AM, Matthew Dharm
<mdharm-usb@one-eyed-alien.net> wrote:
>  If there is no actual activity, then this is likely not a usb-storage
>  problem.  It may very well be an HCD problem, however.
>
>  You may want to turn on CONFIG_USB_STORAGE_DEBUG and verify that there is,
>  in fact, no activity to the drive during these events.

Indeed, I enabled USB_DEBUG and USB_STORAGE_DEBUG; there are no kernel
messages at the time of the interrupt flood.

Any ideas how to proceed to get this problem resolved? I added David
Brownell (the EHCI maintainer) to recipients.

Marti
