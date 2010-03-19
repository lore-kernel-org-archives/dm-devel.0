From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 14:34:12 +0000
Message-ID: <20100319143412.GE919@agk-dp.fab.redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
	<7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Zeuthen <zeuthen@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 19, 2010 at 09:58:00AM -0400, David Zeuthen wrote:
> I think the problem is the that fact that 3rd party user space
> opens the device before it is ready (e.g. just after ADD but before
> the first CHANGE) makes things fall over.
> This short-coming is what needs to get fixed, I think - it's very
> fragile this way and since any random user / package can add
> rules to open the device on add events, said user / package can
> make device-mapper fail. Which doesn't exactly strike me
> as robust behavior.

And we suggested two potential solutions:

  1 - change the kernel so the ADD event doesn't arrive until the device is
ready for use.     [plus equivalent change for REMOVE]

      Advantage: the dm device handling looks more like a real disk so we have
less 'special case' code.  /dev then only indexes "dm devices ready to be used"
rather than "dm devices registered in the kernel"

      Disadvantage: breaks the currently-simple kobject/sysfs/dev linkage (as
per Kay's earlier mail)
 

  2 - several changes to the way udev rules are handled so we can choose to
ignore events and make no changes to /dev, so we can override rules other
packages insert without requiring dm-specific checks adding to them all, and
probably some of the other things we've discussed on these various threads.

 
Alasdair
