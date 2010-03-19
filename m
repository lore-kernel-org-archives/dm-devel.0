From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
 ioctl.
Date: Fri, 19 Mar 2010 10:06:56 +0100
Message-ID: <20100319090656.GR6379@soda.linbit>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
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

On Fri, Mar 19, 2010 at 09:27:35AM +0100, Kay Sievers wrote:
> On Thu, Mar 18, 2010 at 22:35, Milan Broz <mbroz@redhat.com> wrote:
> 
> > But if your statement is "it is your broken activation model" as you said
> > in some discussion, I can do nothing, just disagree - it is different model,
> > not broken.
> 
> Sure, if you are fine with that model, I'm fine with it too. You are
> the one sending patches to mangle basic driver-core definitions to
> paper-over some issues dm seem to have with it. I just object to such
> core changes, not to the way dm is doing things.
> 
> I have no problem with dm creating "dead" devices, it's like this
> since a long time, but please don't try to fake things in the driver
> core to make it look different from what it is. We don't want /sys and
> /dev and events to be out of sync, like non-"add"-ed devices which are
> fully created in /sys, or "remove"-d devices which are still fully
> populated in /sys.
> 
> /sys is the direct export of kernel objects, if you create objects,
> they appear, and they get announced. If you don't want them to be
> announced at that time, just don't register them at that time.
> 
> Don't get me wrong, I'm not asking you to change the current state how
> dm is doing things, I just object to the patch which inconsistently
> tries to fake events, which do not match the state in /sys.

Would introducing a KOBJ_READY_TO_BE_CONSUMED_BY_UDEV help?

Or re-using KOBJ_ONLINE for that purpose,
even though it has different meaning elsewhere?

	Lars
