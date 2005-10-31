From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: /dev/dm-N and Veritas?
Date: Mon, 31 Oct 2005 21:30:25 +0100
Message-ID: <1130790625.13850.135.camel@zezette>
References: <4366702B.1010206@trilegiant.com>
	<1130788268.13850.128.camel@zezette> <436678B8.9090804@trilegiant.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <436678B8.9090804@trilegiant.com>
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

On lun, 2005-10-31 at 15:04 -0500, Bruen, Mark wrote:
> I would like to use "device mapper" for multipathing which I have setup 
> and Veritas Volume Manager for Virtualization. I normally  create LUNs 
> on the SAN and they show up as /dev/sdX, /dev/sdY, etc... I initialize 
> them for use with Veritas Volume Manager which allows me to expand 
> filesystems across multiple LUNs, create snapshots, split disks off for 
> deporting, etc...
> I have many years of Veritas experience and none with LVM so I would 
> (for now anyway) like to use the multipathed devices /dev/dm-N with 
> Veritas. Is it possible?
> Thanks.
>     -Mark
> 
There are some issues in this field : /dev/dm-* might or might not
exist, might be duplicate of /dev/mapper/ entries, paths appear
as /dev/sd* nodes and are not hidden.

The Volume manager has to deal with these things. Even LVM2 has rough
edges here. I would guess VxVM may have a hard time too.

That said, this question will ultimately have to be responded by
Veritas. I can image them saying that you'd better use *their*
multipathing solution, being well integrated with the volume manager.

The DM multipathing is easily disabled.

Regards,
cvaroqui
