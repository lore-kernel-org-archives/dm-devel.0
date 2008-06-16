From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: NetBSD libdevmapper port
Date: Mon, 16 Jun 2008 19:26:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0806161919540.3889@engineering.redhat.com>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
	<Pine.LNX.4.64.0806131236500.32455@engineering.redhat.com>
	<9B8150BC-CD20-4E8B-A40F-17CD4BA5DA69@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9B8150BC-CD20-4E8B-A40F-17CD4BA5DA69@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Adam Hamsik <haaaad@gmail.com>
Cc: dm-devel@redhat.com, tech-kern@netbsd.org
List-Id: dm-devel.ids



On Tue, 17 Jun 2008, Adam Hamsik wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
> On Jun,Friday 13 2008, at 6:51 PM, Mikulas Patocka wrote:
>
>> Hi
>> 
>> If you are rewriting it --- have you somehow thought about avoiding 
>> suspend?
>
> device suspend/resume are unsupported for now. I was not sure what these 
> commands should really do.
> Because GPL/BSD licensing issues I haven't look at linux code.
>
>> 
>> 
>> A big source of problems in Linux is, that when you suspend a device, you 
>> can do only a limited set of calls --- basically, you must avoid anything 
>> that could possibly wait for I/O or allocate memory --- or you might end up 
>> waiting for the suspended device and deadlock. And I know still about 3 
>> places in kernel that have this error possibility.
>
> ok but why I should want to do something like suspending of device ? to 
> avoid IO operations when I'm changing device table

Yes, exactly that. For example if you are about to move a logical volume 
somewhere else, lvm replaces it with dm-raid1 target that does the 
copying. If there were old IOs for the old linear target flying around 
while dm-raid1 copies the data, there would be data corruption.

It also updates on-disk metadata while it's suspended. I'm not sure if 
this is really needed to update them at this point. Maybe at some cases it 
is.

> or what problem are device suspend/resume want to solve. If this 
> is problem I can use one mutex
> shared between dm_dev_suspend/resume_ioctl call and dmstrategy(this routine 
> does IO) so I can avoid IO's when device is suspended.

The problem is that when you lock this mutex, you must avoid any memory 
allocation (because it may submit write IO and wait for it). And it's very 
hard to do it if you return to userspace.

Mikulas
