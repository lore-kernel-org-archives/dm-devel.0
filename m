From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Extending DM w/ new target type
Date: Fri, 02 Aug 2013 14:07:43 +0200
Message-ID: <51FBA10F.7070006@redhat.com>
References: <CAH1aXXYQVnYndk7S6-6TM9hiuTE2xpN+4Qt8BA_36PvrQVQSsw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAH1aXXYQVnYndk7S6-6TM9hiuTE2xpN+4Qt8BA_36PvrQVQSsw@mail.gmail.com>
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
Cc: John Strange <johnstra10@gmail.com>
List-Id: dm-devel.ids

Dne 1.8.2013 19:04, John Strange napsal(a):
> two questions:
>
> 1. I'd like to use DM with a new target type.  I'm porting our virtualized
> storage solution from Windows.  I've been able to register my target and get
> callbacks working, but in looking at the dm-raid code, I'm concerned with how
> tightly coupled it is with the routines in md.c (multiple devices
> implementation).  Is there an expectation that a DM target use the md_xxxx
> routines?
>
> 2. I used dmsetup to create a mapping for a device that my target controls.
> Is there a way to make the underlying device (e.g. /dev/sdb) not visible to
> the system?  I'm paranoid about external accesses to a LUN that I'm using.

In lvm2 it's solved in a way - that we use special flags for udev to avoid
some scanning/watchrules - however all device are always available through 
/dev/mapper but  user visible devices are accessible via   /dev/vg/lv name 
which is the only suggested and supported way to use LVs.

Obviously we often get reports where users are directly playing with 
/dev/dm-XXX devices or /dev/mapper/vg-lv  in their scripts and configs...

But you can't hide existing devices in  system from userland visibility.


Zdenek
