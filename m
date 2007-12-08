From: Milan Broz <mbroz@redhat.com>
Subject: Re: dmsetup load not working?
Date: Sat, 08 Dec 2007 18:53:59 +0100
Message-ID: <475ADA37.6060108@redhat.com>
References: <20071208162439.GA3964@newbie.thebellsplace.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071208162439.GA3964@newbie.thebellsplace.net>
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

Bob Bell wrote:
> I'm using a SLES10 SP1 x86_64 system, and I'm been using dmsetup 
> intensively for the first time.  From what I can tell, `dmsetup load` 
> just doesn't seem to work; it doesn't seem to have any effect.
> 
> Below is the simplest case I could think to come up with to illustrate 
> this issue.  Could anyone help me here?  Am I doing something wrong?
...
> brick14b:~ # dmsetup create loop2 --notable
> brick14b:~ # dmsetup table loop
> 0 204800 linear 7:1 0
> brick14b:~ # dmsetup table loop2
> 
> brick14b:~ # dmsetup table loop | dmsetup load loop2
> brick14b:~ # echo $?
> 0

There can be two tables for DM device, active and inactive.

Active (live) table is used for operation, inactive is used
in preparation for table change.

"Inactive" table is activated during device resume (if you need to
change table, suspend device and resume device is needed to switch
inactive table to live state).

> brick14b:~ # dmsetup table loop2

loop2 was created with --notable, so there is no live table but only inactive.
You need to add "dmsetup resume loop2" here.
(Because device has no table, suspend is not required.)

See "man dmsetup" too. Anyway, be very careful using this low level commands,
better use some volume management system on top of device mapper.

> 
> brick14b:~ # dmsetup info loop2
> Name:              loop2
> State:             ACTIVE
> Tables present:    INACTIVE
^^ this is problem, no live table, just inactive here.

> Open count:        0
> Event number:      0
> Major, minor:      253, 11
> Number of targets: 0

Milan
--
mbroz@redhat.com
