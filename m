From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: Getting dm extent mapping
Date: Tue, 18 Oct 2011 21:37:48 +0200
Message-ID: <1318966668.31359.1.camel@lapoo.opensvc.com>
References: <86e7fc50eb867c64d1cc9c1ad74cdf8f.squirrel@mail.mohawksoft.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <86e7fc50eb867c64d1cc9c1ad74cdf8f.squirrel@mail.mohawksoft.com>
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

On lun., 2011-10-17 at 13:15 -0400, markw@mohawksoft.com wrote:
> Is it possible to get a list of extents mapped to an object from an ioctl
> call?
> 
> The reason why I am asking is that I need to be able to calculate the
> deltas between a snapshot and a real device. For instance:
> 
> Suppose I have a virtual machine on device /dev/lvmvol/vmserver. I create
> a snapshot of that device named /dev/lvmvol/vmsnap.
> 
> If I could get a list of the extents used to constitute "vmserver" and the
> extents that constitute "vmsnap" I could calculate how much has changed
> and what ranges I need to actually backup. Obviously, there has to be some
> way to map "extents" to locations on the device itself in order for this
> to work.
> 
> I have looked in the dm code and can not see if this is possible.
> 
The ddsnap tool might fit your need. It is hosted on the git space of
http://www.opensvc.com

Regards,
cvaroqui
