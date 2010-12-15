From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [Patch 2 of 2]: scsi-dh + dm-mpath: propagate SCSI
 device deletion to multipath
Date: Wed, 15 Dec 2010 11:09:53 -0500
Message-ID: <20101215160952.GA20869@redhat.com>
References: <D8C50530D6022F40A817A35C40CC06A7064AFC9450@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064AFC9450@DUBX7MCDUB01.EMEA.DELL.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Menny_Hamburger@dell.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 15 2010 at  3:31am -0500,
Menny_Hamburger@dell.com <Menny_Hamburger@dell.com> wrote:

> The problem:
> When a SCSI device attached to a device handler is deleted, userland processes currently performing I/O on the device will I/O hang forever.
> 
> Attached is the multipath layer part of the patch.

Please do not use attachments when submitting patches.  Please inline
the patch in the body of the mail.  Also please trim extraneous info
when you reply to mails and please do not top-post.

Your patch submissions were not well received by the dm-devel patchwork
(which automatically collects submitted dm-devel patches so they don't
get lost in the shuffle).

Also, please use unique and descriptive subjects for the patches in a
multipatch series.

As for the proposed mpath change: Babu already pointed out that you
don't need this mpath change as the default case already performs
fail_path().

So all you need is that scsi_dh patch to get upstream.  But to do that
you'll need to:
1) create a patch against the upstream scsi-misc tree (not RHEL5.5):
   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

2) send the patch to the linux-scsi@vger.kernel.org mailing list (feel
   free to cc dm-devel too).

Once this change is in the upstream scsi tree it'll propagate to RHEL
releases.

Thanks,
Mike
