From: Brad Dameron <brad@seatab.com>
Subject: Re: device mapper error when attempting to install 2nd
	kernel on CentOS
Date: Tue, 14 Mar 2006 10:17:39 -0800
Message-ID: <1142360260.16437.10.camel@localhost.localdomain>
References: <7903deec0603140129t5e97d6dw13de371d4650f0ce@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7903deec0603140129t5e97d6dw13de371d4650f0ce@mail.gmail.com>
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

On Tue, 2006-03-14 at 01:29 -0800, Michael Phoenix wrote:
> I am having trouble trying to install version 2.6.15 of the linux
> kernel onto a machine that is currently running 2.6.9 version of the
> kernel. I am using the 2.6.9 configuration file and running make
> install successfully. When I try to boot the new kernel, I get the
> following:
> No entry for device mapper found Is device mapper driver missing from kernel?
> Failure to communicate with kernel
> mount: error 19 mounting ext3
> mount: error 2 mounting none
> 
> Apparently the device mapper is being used on the current kernel and
> does exist in the direcotory /sys/misc. What do I need to do to get my
> new kernel to run? According to what I've read, every kernel since
> 2.6.9 should have it in the source.
> I checked the .config file and couldn't find anything called device
> mapper. There was an entry for an IOMAPPER associated with a certain
> scsi device that was commented out, but I have no idea what to put
> after =. I couldn't find a comparable entry using make menuconfig. Any
> help would be greatly appreciated.
> I don't really have any need for it so if I can get my kernel to run
> without it that is an acceptable solution.
> 
> Mike


I had this similar problem. And it wasn't with DM. It was something
strange with using the old config file. I had to create a new config
file with the new kernel.

Brad Dameron
SeaTab Software
www.seatab.com
