From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: XFS getting EAGAIN from block device
Date: Wed, 08 Jun 2011 10:11:13 +0100
Message-ID: <4DEF3CB1.20900@redhat.com>
References: <BANLkTinc-zSEY5uQ-8i__KzWPp24Q-yB+w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BANLkTinc-zSEY5uQ-8i__KzWPp24Q-yB+w@mail.gmail.com>
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
Cc: Marko Huttunen <marko@codito.se>
List-Id: dm-devel.ids

On 06/07/2011 09:44 PM, Marko Huttunen wrote:
> HW specs:
> The XFS partition is run on a HW Raid on 2 x 1TB WD Black Caviar. Motherboard is 
> an ASUS Sabertooth P67 with Intel Sandy Bridge i5-2500K CPU @ 3.30GHz.

As Mike said, it sounds like something further down the stack. You don't mention
what sort of array this is (i.e. which hardware RAID driver it's using, whether
it presents as a SCSI device etc.).

Depending on the answer to that question your next steps might involve enabling
debug in that driver, turning up the generic SCSI logging level or making use of
blktrace to try to understand where the I/O is going (or rather, where it isn't
going ;).

Regards,
Bryn.
