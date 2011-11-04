From: Tejun Heo <tj@kernel.org>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 4 Nov 2011 14:50:25 -0700
Message-ID: <20111104215025.GB4417@google.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com> <4EB2E4B7.7000103@cfl.rr.com>
	<CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
	<4EB407DC.8070307@cfl.rr.com> <20111104155228.GY4417@google.com>
	<4EB4121A.1060102@cfl.rr.com> <20111104163207.GA4417@google.com>
	<4EB45467.4060605@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4EB45467.4060605@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

On Fri, Nov 04, 2011 at 05:08:55PM -0400, Phillip Susi wrote:
> On 11/4/2011 12:32 PM, Tejun Heo wrote:
> >Umm... partioned / mkfs'd while unlocked and bios (on whatever
> >machine) locks it on later boots.
> 
> So the first machine does not set an HPA at all, you format the
> drive, then move it to a machine whose bios blindly adds an HPA to
> the drive? A bios certainly shouldn't be blindly adding an HPA to an
> already formatted drive that did not have one before.  If it does,
> why is that our problem?

Sigh, yes, it is as much our problem as any other HPA related issues
and it can be much more common because it can happen with hot
plugging/swapping.

-- 
tejun
