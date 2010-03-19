From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 10:10:05 +0100
Message-ID: <4BA33F6D.7070306@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/19/2010 09:27 AM, Kay Sievers wrote:
> On Thu, Mar 18, 2010 at 22:35, Milan Broz <mbroz@redhat.com> wrote:

> /sys is the direct export of kernel objects, if you create objects,
> they appear, and they get announced. If you don't want them to be
> announced at that time, just don't register them at that time.

Well, again, I used something what is already used (not on many places,
but it is there), just search for dev_set_uevent_suppress().

See

/* delay uevents, until we scanned partition table */
dev_set_uevent_suppress(ddev, 1);

... (part table scan etc. it reads disk, so there can be
significant delay if device retries read for example)

+ /* caller will send ADD event later */
+ if (disk->flags & GENHD_FL_SUPPRESS_ADD_EVENT)
+ return;
+
/* announce disk after possible partitions are created */
dev_set_uevent_suppress(ddev, 0);
kobject_uevent(&ddev->kobj, KOBJ_ADD);


So the comment says that base device is announced after all
partitions devices are created.

I thought it is exactly the same model I used - so there is for
some time unannounced fully created "dead" device in sysfs.

Probably I am still missing where the problem is - the ADD
event is sent later, so the problem in time interval?
Or the atomicity of the call?

Well, if it is not acceptable (is this what you want to say?),
what do you suggest?

Not use add_disk()/del_gendisk() in dm core and rewrite it?
This seems like change a lot of code. And after that someone
surely will say "why dm implements this differently".

But I think it always need a change in device core code.

Thanks,
Milan
--
mbroz@redhat.com
