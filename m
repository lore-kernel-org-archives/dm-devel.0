From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: best way to detect a dm device is dm-multipath from
 userspace?
Date: Tue, 25 Mar 2014 19:30:51 +0100
Message-ID: <5331CB5B.4040701@redhat.com>
References: <20140325172022.GA32702@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140325172022.GA32702@infradead.org>
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
List-Id: dm-devel.ids

Dne 25.3.2014 18:20, Christoph Hellwig napsal(a):
> For a little project I'm working on I'd like to find out if a given
> device node is a dm-multipath device from C code.  dm_is_dm_major tells
> me if it's any DM node, but from there on it seems like I'd have to
> grab the table name from dmsetup table output for which I'd need a name
> for the device or similar.
>
> Is there a good shortcut or library function for this check?
>


dmsetup is just a commandline tool wrapper around  libdm.

libdm has   'libdevmapper.h'  interface.

For more complex usage look at dmsetup.c

In general you prepare  dm_task structure
(dm_task_create()) - you present needed
options and you  'dm_task_run()'  (wrapper over ioctl)

Then you read result.

If you know how to use 'dmsetup' - then you get pretty
easy conversion to libdm usage.


However from the message title - I think you just really want to check
content in udev database - which should be storing all info about device type.

All detection happens in rules - IMHO you should not try to add any new 
detection..

Zdenek
