From: Martin Wilck <mwilck@suse.de>
Subject: Re: Disconcerting observation with multipathd's dmevent
	polling code
Date: Wed, 21 Nov 2018 14:33:04 +0100
Message-ID: <ca260fe5035aee8f1e79bd18f52a12557baa36f0.camel@suse.de>
References: <9f372197ec112f97298641e223d2e5e6a5e1b33a.camel@suse.de>
	<6fab77be-763c-4de0-a312-de112e7d1c0a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6fab77be-763c-4de0-a312-de112e7d1c0a@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-11-21 at 12:20 +0100, Hannes Reinecke wrote:
> On 11/21/18 11:50 AM, Martin Wilck wrote:
> > 
> > The concern that I have is with the design of the polling dmevent
> > API,
> > in particular the fact that the default action is EVENT_REMOVE. If,
> > for
> > whatever reason, one map is missing from the return value of the
> > DM_DEVICE_LIST ioctl, multipath removes the map immediately, and
> > there's nothing short of a "reconfigure" or "add map" CLI command
> > that
> > would reinstate the map. IOW, we remove the map not on a kernel
> > event
> > saying "this map has been removed", but on receiving a list where
> > this
> > element happens to be missing. We handle this differently for
> > paths,
> > where we wait for a "remove" uevent before we really delete the
> > path
> > from our data structures. (Note that the messages file I saved from
> > the
> > event above shows no sign of such an uevent ever beeing sent - as I
> > said, the dm map was still present after the above occured).
> > 
> > What do you think about this? Could you maybe inspect those logs I
> > took, to make sure I didn't get on a totally wrong track here?
> > 
> There's an easy solution to it: drop the dmevent handling code in 
> multipath-tools completely.
> It's original design was to track _external_ map reloads, as
> originally 
> the maps had been setup by 'multipath', and 'multipahtd' was just 
> tracking state changes. As such multipathd needed to track those 
> changes, and it had been using dmevents for this.
> However, with the advent of udev and updates to the multipathd
> daemon 
> external map reloads rarely happens, and even if they happen we
> still 
> would be notified by uevents.
> So we might as well drop the dmevent code and rely on udev
> completely.
> Which is what we do nowadays anyway.

I recall Ben arguing that the dmevent API was faster, and more
reliable, than udev. It doesn't depend on udevd being healthy and
having enough workers available, which is a plus. The reliability seems
to be debatable in view of the API design, that was the point of my
mail.

Yet we depend so heavily on udev nowadays that multipathd is pretty
much lost without it anyway.

Let's see what Ben says.

Thanks,
Martin
