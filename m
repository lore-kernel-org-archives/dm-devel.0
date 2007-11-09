From: Tore Anderson <tore@linpro.no>
Subject: Re: device-errors and multipath device access issue
Date: Fri, 09 Nov 2007 09:28:45 +0100
Message-ID: <47341A3D.2040804@linpro.no>
References: <2072641508@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2072641508@web.de>
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

* devzero@web.de

> on boot, we get lot`s of error messages like
> 
>> [...]
> 
> for each alternative path to a lun.

I assume you mean "for each path to the alternate controller of the volume".

> we also get those messages when the system is up and running because
> some proprietary monitoring software is checking for device
> availability in regular intervals and there seems no way to tell that
> software to skip certain devices - so we get spammed with this
> messages like this in /var/log/messages and are not able to see the
> real errors anymore.
> 
> is there a way to hide those "classic" scsi devices from userspace? 
> i`m not sure if "blacklist" in multipath.conf is what i need here (?)
> or if i safely could delete those device-nodes - i`m not very deep
> into multipathing for now.

I don't think you can (without at the same time taking away
dm-multipath's ability to fail over I/O to those paths...

You're not saying which kind of storage hardware this is.  Maybe it has
a way of being configured in a fake active/active configuration where
I/O can be processed on both controllers at the same time.  I believe
newer EMC CLARiiON and HP EVA can be set up in ALUA mode which does the
trick. HDS AMS does something similar which work mostly the same way.

You might also be able to filter out those lines from the logs, too.  I
think at least syslog-ng can be made to do that.

> in our case, kpartx doesn`t seem to be launched by udev but from
> within boot.multipath, but it looks like a timing issue because it
> sometimes happens and sometimes not.
> 
> any help or some input (links?docs?) to enlighten me would be highly
> appreciated

I'd suggest simply not making partitions - make several smaller volumes
on your storage array instead.  That'll make it easier to expand them
individually if the need should arise, and you won't have to deal with
kpartx at all.  There's always some kind of trouble with it, in my
experience.  Same goes for udev...

Regards
-- 
Tore Anderson
