From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Multipath selector policy additions
Date: Thu, 09 Feb 2006 20:37:25 +0100
Message-ID: <1139513846.2915.12.camel@zezette>
References: <00f901c62c33$48a82090$060aa8c0@workshop>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <00f901c62c33$48a82090$060aa8c0@workshop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On mar, 2006-02-07 at 16:10 -0600, Brad Johnson wrote:
> I am a software developer that is new to this list. I understand that
> currently round-robin is the only implemented path selector type. I am
> scoping (for a major storage vendor) the effort required to implement
> additional selector types, as well as other work required to function
> properly with their hardware (possibly special device-specific
> hardware handlers, config file changes, etc.). I assume there is a
> procedure in place to allow developers to submit changes such as these
> to the public domain, and hope that eventually they may be included in
> some future distributions.
>  
> My questions are:
>  
> What is the procedure for submitting kernel patches for the device
> mapper?

Submitting changes to the maintainer, cc the dm-devel list is the
practice for both kernel-space and user-space multipath subsystems.

> Who (or what organization) owns responsibility for the device mapper
> kernel modules?

I'll guess you mean maintainership, not "responsibility" :/

The DM maintainer is Alasdair Kergon, RedHat.

> Who owns responsibility for the user-space multipath pieces?

I maintain the user-space tools
> 
> Is anyone else currently developing additional path selector types?

Mike Christie, RedHat, and Lars M. Bree, Suse, have experimence with
hwhandlers

>  
> I am sorry if my newbie questions are naive, but any help to point me
> in the right direction will be greatly appreciated.
>  
> Regards,
> Brad Johnson
>  
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
