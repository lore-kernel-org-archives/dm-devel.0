From: Neil Brown <neilb@suse.de>
Subject: Re: RFC: multipath IO multiplex
Date: Sat, 6 Nov 2010 05:32:03 -0400
Message-ID: <20101106053203.7e4ef435@notabene>
References: <20101105183946.GG25992@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101105183946.GG25992@suse.de>
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
Cc: lmb@novell.com
List-Id: dm-devel.ids

On Fri, 5 Nov 2010 19:39:46 +0100
Lars Marowsky-Bree <lmb@novell.com> wrote:

> Hi all,
> 
> this is a topic that came up during our HA miniconference at LPC. I
> inherited the action item to code this, but before coding it, I thought
> I'd get some validation on the design.
> 
> In a cluster environment, we occasionally have time critical IO - both
> read and writes, for a mix of via-disk heartbeating, or the exchange of
> poison pills.
> 
> MPIO plays hell with this, since an IO could potentially experience very
> high latency during a path switch. Extending the timeouts to allow for
> this is reasonably impractical.
> 
> However, our IO has certain properties that make it special - we have
> rather careful patterns, they don't overlap, they are effectively single
> page/single atomic write unit, and each node effectively writes to its
> own area.
> 
> So the idea would be to, instead of relying on the active/passive access
> pattern, to send the IO down all paths in parallel - and reporting
> either the first success or the last failure.

Hi Lars,
 the only issue that occurs to me is that if you want to report the first
 success, then you need to copy the data to a private buffer before
 submitting the write.  Then wait for all writes to complete before freeing
 the buffer.  If you just return the first write the page would be unlocked
 and so could be changed will another path was still writing it out.

 Finding a way to signal 'write all paths sounds tricky.  This flag needs to
 be state of the filedescriptor, not the whole device, so it would need to be
 an fcntl rather than an ioctl.  And defining new fcntls is a lot harder
 because they need to be more generic - you cannot really make them device
 specific...
 Might it make sense to configure a range of the device where writes always
 went down all paths?  That would seem to fit with your problem description
 and might be easiest??

NeilBrown


> 
> (Clearly, this only works for active/active arrays; active/passive
> setups still may have problems.)
> 
> Doing this in user-space is somewhat icky; short of scanning the devices
> ourselves, or asking multipathd for each IO for the current list, we
> have no good way to do that. But the kernel obviously has the correct
> list at all times.
> 
> So, I think a special IO flag for block IO (ioctl, open() flag on the
> device, whatever) that would cause dm-multipath to send the IO down all
> paths (and, as mentioned, report either the last failure or first
> success), seems to be the easiest way.
> 
> How would you prefer such a flag to be implemented and passed in, and
> what do you think of the general use case?
> 
> 
> Regards,
>     Lars
> 
