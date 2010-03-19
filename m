From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 10:22:18 +0100
Message-ID: <ac3eb2511003190222n7e16762ep1b35be5c8ad2e5ec@mail.gmail.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<4BA33F6D.7070306@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BA33F6D.7070306@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 19, 2010 at 10:10, Milan Broz <mbroz@redhat.com> wrote:
> On 03/19/2010 09:27 AM, Kay Sievers wrote:
>> On Thu, Mar 18, 2010 at 22:35, Milan Broz <mbroz@redhat.com> wrote:
>
>> /sys is the direct export of kernel objects, if you create objects,
>> they appear, and they get announced. If you don't want them to be
>> announced at that time, just don't register them at that time.
>
> Well, again, I used something what is already used (not on many places,
> but it is there), just search for dev_set_uevent_suppress().
>
> See

Sure, I see. It's code I added myself.

> /* delay uevents, until we scanned partition table */
> dev_set_uevent_suppress(ddev, 1);
>
> ... (part table scan etc. it reads disk, so there can be
> significant delay if device retries read for example)

Come on. It's the same code path, and it's for proper sysfs timing,
not for some it-can-happen-any-time action triggered from userspace.

> So the comment says that base device is announced after all
> partitions devices are created.

Sure, but that's not in any sense what matches your patch, and
"remove" is still fully handled by the core.

> Well, if it is not acceptable (is this what you want to say?),
> what do you suggest?

Leave it as it is, or fix the driver core _interaction_, not the core itself.

> Not use add_disk()/del_gendisk() in dm core and rewrite it?
> This seems like change a lot of code. And after that someone
> surely will say "why dm implements this differently".

Why would anybody say that. You create the _always_visible_ objects
when they are supposed to be visible, that would be all you do. I'm
not saying you need to do that, but you better don't fake around in
driver core events like your patch tries to do.

> But I think it always need a change in device core code.

Sure, we can do all reasonable changes here, inconsistent /sys and
event state we try to avoid for many good reasons.

Kay
