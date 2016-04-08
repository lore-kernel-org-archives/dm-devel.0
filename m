From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 10/18] multipathd: delay reloads during
	creation
Date: Fri, 8 Apr 2016 16:53:35 -0500
Message-ID: <20160408215335.GL2915@octiron.msp.redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
	<1460071212-21018-11-git-send-email-bmarzins@redhat.com>
	<57076D77.6020208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <57076D77.6020208@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Fri, Apr 08, 2016 at 10:36:07AM +0200, Zdenek Kabelac wrote:
> However now the multipathd *kills* this assumption - since the current udev
> rules implementation for multipath devices targets only for the initial scan
> and all subsequent RESUMES are supposed to be ignored as it's believed the
> device remained in the same state and only some paths have been added/lost.
> Scanning such a device thus shall not change any remembered info in udev
> database. As 'extra' bonus multipath may SUSPEND devices (and that's somehow
> solved by this patch) right after the initial activation of the device so
> the lvm2 check for skipping of suspended devices may have skipped the whole
> discovery operation and since further RESUMES were meant to be ignore,
> device remained invisible forever.

Yep, that's the general idea of the patch, to avoid the case where the
initial activation uevent isn't getting processed while the device is
suspended.
 
> Now we get to the best technical solution for multipath here with other
> surrounding software (i.e. udev) - before multipath starts to mark RESUMES
> as 'ignorable' it should check/validate if udevdb already does contain a
> valid information about the device (i.e. it's been scanned...)  and only in
> this case it would mark this device to be ignored.

This makes sense, and has the benefit of not forcing multipathd to wait
before doing reloads, or having to deal with what happens if the initial
change uevent gets backed up. The only thing I'm not sure we have is a
variable to check in the udev database that will get set (and then
retained over subsequent uevents) when the device is scanned, regardless
of whether any lvm metadata is found or not. Peter, does anything like
this exist? I didn't see anything that looked like what we'd need. If
nothing currently exists, could we add a variable that gets added to the
udev database for a device whenever pvscan is run, and also gets
imported from the database on all change events?

-Ben

> Regards
> 
> Zdenek
