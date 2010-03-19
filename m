From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 10:49:43 +0100
Message-ID: <4BA348B7.5070604@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
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

On 03/19/2010 10:24 AM, Kay Sievers wrote:
> On Fri, Mar 19, 2010 at 10:06, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
>> Would introducing a KOBJ_READY_TO_BE_CONSUMED_BY_UDEV help?
> 
> No, that's what "change" is for, and we already have these "change"
> events for dm. Udev does not care if the device is ready or not, it
> synchronizes /sys and /dev, and that works just fine with "change"
> events.

Udev (rules) do not not care if the device is ready?

That's really news for me. So you are basically saying that dm ADD event is ok,
and it is problem of udev rules that they react here on ADD event and run
various scan over not-yet-ready device because it should wait for CHANGE?

ok, then I am wasting time with fixing the dm ADD event. We have this already.

Mea culpa. Sorry for spam then:-)

Milan
--
mbroz@redhat.com
