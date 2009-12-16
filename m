From: Milan Broz <mbroz@redhat.com>
Subject: Re: Re: dm: sysfs add empty release function to avoid
	debug	warning
Date: Wed, 16 Dec 2009 19:40:27 +0100
Message-ID: <4B29299B.5080704@redhat.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org>
	<20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com>
	<20091216134538.GA20857@kroah.com> <4B290B95.10306@redhat.com>
	<20091216174632.GA12473@kroah.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091216174632.GA12473@kroah.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg KH <greg@kroah.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On 12/16/2009 06:46 PM, Greg KH wrote:
> You will find that all of these are modules, right?  That's being worked
> on still.

probably. I see that this implementation is in kernel since import to git...

What's the right solution in this particular case?
It is exactly the same situation (using embedded kobj like module handle does).

In DM, the whole problem here is that kobject is used for attribute representation
of mapped device, mapped device struct is using its own reference counting
and can dissappear before the kobject. So it must properly solve this situation.

> Again, please fix your code not to have an empty release function.  Will
> you revert this change and fix it properly?

Sure, working on it. Proper fix will replace this when ready.

Milan
