From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 10/17] multipathd: delay reloads during
	creation
Date: Tue, 29 Mar 2016 10:02:41 -0400
Message-ID: <22266.35585.347696.835499@quad.stoffel.home>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
	<1459221194-23222-11-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1459221194-23222-11-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

>>>>> "Benjamin" == Benjamin Marzinski <bmarzins@redhat.com> writes:

Benjamin> lvm needs PV devices to not be suspended while the udev
Benjamin> rules are running, for them to be correctly identified as
Benjamin> PVs. However, multipathd will often be in a situation where
Benjamin> it will create a multipath device upon seeing a path, and
Benjamin> then immediately reload the device upon seeing another path.
Benjamin> If multipath is reloading a device while processing the udev
Benjamin> event from its creation, lvm can fail to identify it as a
Benjamin> PV. This can cause systems to fail to boot. Unfortunately,
Benjamin> using udev synchronization cookies to solve this issue would
Benjamin> cause a host of other issues that could only be avoided by a
Benjamin> pretty substantial change in how multipathd does locking and
Benjamin> event processing. The good news is that multipathd is
Benjamin> already listening to udev events itself, and can make sure
Benjamin> that it isn't reloading when it shouldn't be.

Benjamin> This patch makes multipathd delay or refuse any reloads that
Benjamin> would happen between the time when it creates a device, and
Benjamin> when it receives the change uevent from the device
Benjamin> creation. The only reloads that it refuses are from the
Benjamin> multipathd interactive commands that make no sense on a not
Benjamin> fully started device.  Otherwise, it processes the event or
Benjamin> command, and sets a flag to either mark that device for an
Benjamin> update, or to signal that multipathd needs a
Benjamin> reconfigure. When the udev event for the creation arrives,
Benjamin> multipath will reload the device if necessary. If a
Benjamin> reconfigure has been requested, and no devices are currently
Benjamin> being created, multipathd will also do the reconfigure then.

Benjamin> Also this patch adds a configurable timer
Benjamin> "missing_uev_msg_delay" defaulting to 30 seconds. If the
Benjamin> udev creation event has not arrived after this timeout has
Benjamin> triggered, multipathd will start printing messages alerting
Benjamin> the user of this every "missing_uev_msg_delay" seconds.

Should this really keep printing this message every 30 seconds for
eternity?  I would think that having it give up after 30 * N seconds
would be better instead.  I'm worried that this might block or slow
down system boots forever, instead of at least failing and falling
through so that maybe something can be recovered here.

Basically, what can the user do if they start getting these messages?
We should prompt them with a possible cause/solution if at all
possible.

John
