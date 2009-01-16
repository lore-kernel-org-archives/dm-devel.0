From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: DM kernel interface
Date: Thu, 15 Jan 2009 20:00:42 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901151954390.23015@hs20-bc2-1.build.redhat.com>
References: <496F0D7A0200000D017159D6@lucius.provo.novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <496F0D7A0200000D017159D6@lucius.provo.novell.com>
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
Cc: ajack@novell.com
List-Id: dm-devel.ids

On Thu, 15 Jan 2009, Allen Jack wrote:

> I have used the ioctl interface to create dm objects and get information 
> about dm objects from a user space application, and am familiar with it.  
> I am now required to get the object information from kernel space, and 
> was wondering what interface is available to do that directly.
> 
> Is there a direct device mapper interface in kernel space that I can use 
> to get the object information from?  For example, I need to see the 
> target mappings within a linear object.
> 
> Allen Jack
> Sr. Software Engineer
> ajack@novell.com
> (801) 861-5923
> Novell, Inc.
> Making IT Work As One
> www.novell.com

Hi

You can call the same ioctls from kernel space as well, see ioctl_by_bdev.

Calling device mapper functions defined in <linux/device-mapper.h> 
directly is discouraged if you are not developing dm target driver.

Mikulas
