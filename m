From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 04 Nov 2011 17:08:55 -0400
Message-ID: <4EB45467.4060605@cfl.rr.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com> <4EB2E4B7.7000103@cfl.rr.com>
	<CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
	<4EB407DC.8070307@cfl.rr.com> <20111104155228.GY4417@google.com>
	<4EB4121A.1060102@cfl.rr.com> <20111104163207.GA4417@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111104163207.GA4417@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

On 11/4/2011 12:32 PM, Tejun Heo wrote:
> Umm... partioned / mkfs'd while unlocked and bios (on whatever
> machine) locks it on later boots.

So the first machine does not set an HPA at all, you format the drive, 
then move it to a machine whose bios blindly adds an HPA to the drive? 
A bios certainly shouldn't be blindly adding an HPA to an already 
formatted drive that did not have one before.  If it does, why is that 
our problem?

> No, with both sizes exposed, mdadm should be able to detect metadata
> at the end even if it was created w/ hpa locked.  This is still
> fundamentally flawed as if you move it to another machine, it may be
> locked in completely different way, but that's as far as we can go.

So mdadm could check both places after the kernel always unlocks, 
without any heuristic?  And when creating an array, it would write it to 
the real, unlocked end of the disk, possibly trashing whatever the bios 
has stored there?

> Upto userspace how?  Unlock it after root is mounted?

Or in the initramfs.  Or just deal with it as part of the upgrade 
process, as I suggested before.
