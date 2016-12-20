From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 2/2] multipathd: skip spurious event
 message for blacklisted paths
Date: Tue, 20 Dec 2016 11:00:18 -0600
Message-ID: <20161220170018.GF19659@octiron.msp.redhat.com>
References: <1481653629-22430-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<1481653629-22430-2-git-send-email-mauricfo@linux.vnet.ibm.com>
	<20161213215024.GB19659@octiron.msp.redhat.com>
	<1481719989.23867.5.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1481719989.23867.5.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 14, 2016 at 01:53:09PM +0100, Martin Wilck wrote:
> On Tue, 2016-12-13 at 15:50 -0600, Benjamin Marzinski wrote:
> =

> > On Tue, Dec 13, 2016 at 04:27:09PM -0200, Mauricio Faria de Oliveira
> > wrote:
> > When you call alloc_path_with_pathinfo(), it already grabs the second
> > reference before calling pathinfo. When it exits without pp_ptr being
> > set, it frees that extra reference in free_path(). But this whole
> > time,
> > we are still servicing the uevent, and that originl reference is
> > always
> > held, so we don't ever need to worry about the udevice getting
> > deleted
> > out from under us. I don't see any possible danger in removing the
> > udev_device_ref/unref calls from your code. They don't hurt anything,
> > but grabbing references when we don't need them just confuses other
> > people who are trying reading the code, and makes the purpose of the
> > references harder to understand.
> =

> As someone who has just recently started reading the multipath-tools
> code in depth, I tend to disagree. Someone reading the function
> including the udev_device_ref()/unref() calls would see that the device
> references are handled correctly in the function itself, without having
> to know or having to track down how the device references are created
> and dropped in other parts of the code. Moreover, if the global ref
> handling was ever to be changed in the future, this function would
> still be "safe".

I would argue that you don't need to track down these reference. Since
uev_update_path is accessing the device, you can assume that it has a
reference (otherwise it would be accessing memory that could be freed at
any moment, and may already be freed). If the code you add doesn't drop
that reference, then it is clearly able to acces the udev device,
without worrying about the memory going away. If the code you add DOES
drop a reference, then you really DO need to track down the ref/unref
calls, because otherwise, you could be breaking things. For instance, if
this patch dropped a reference between those ref/unref calls, that would
break multipathd. After the unref call, the memory could now be freed,
where before, uev_update_path returned with the reference still held.
The only time you ever need to grab a another reference is if your code
stores the udev device, so that it can exist after multipathd finishes
processing the uevent. When your code finally is done with the udev
device, it needs to drop the reference, so the the memory can get freed.

No matter how global ref handling is changed in the future,
uev_update_path will still need to be called with a reference to the
udev device, because it accesses it. So as long as it doesn't store the
device, it doesn't need to grab another reference.

 =

> If the udev_device_ref/unref calls are removed, at least a comment
> explaining why they aren't needed would help new readers of the code.

But then why not comment all the functions that access the udev device,
since most of them don't grab a reference (nor do they need to).  If
we're going to comment the code, I'd rather put comments in the small
number of places where we do need to grab or drop extra references,
explaining why it is necessary there.

-Ben

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
