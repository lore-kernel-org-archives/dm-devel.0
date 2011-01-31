From: Joe Thornber <thornber@redhat.com>
Subject: Re: Possible severe bug in the device mapper?
Date: Mon, 31 Jan 2011 11:20:45 +0000
Message-ID: <1296472845.2642.2.camel@ubuntu>
References: <4D46811C.9050506@gmx.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D46811C.9050506@gmx.com>
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

On Mon, 2011-01-31 at 10:30 +0100, Andreas Heinlein wrote:
> 2. Create a loopback device with this file (losetup -f
> /media/somedrive/testfile) 

I'm just trying to understand your complaint here.  If device-mapper
wasn't in the equation here, and you were using the loop-back device
directly (i.e. by putting a filesystem on it and mounting).  Then you
pulled the removable device, what happens?

- Joe
