From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Trying to blacklist a USB memory stick
Date: Tue, 30 Sep 2008 10:23:48 -0400
Message-ID: <20080930142348.GB17311@mars.virtualiron.com>
References: <87C820D35C176D428A1A8A3B34F6FB86C274D4@uppx3m1.upp.emea.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87C820D35C176D428A1A8A3B34F6FB86C274D4@uppx3m1.upp.emea.dell.com>
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

On Tue, Sep 30, 2008 at 12:47:34PM +0200, Harald_Jensas@Dell.com wrote:
> Hi,
> 
> I just subscribed to the list, I am an enterprise deployment engineer at Dell and do frequently work with device-mapper-multipath. A few weeks back I configured the SAN storage for 4 RHEL 5 servers that will be an Oracle RAC cluster. Now the customer plugged an USB key into 2 of the systems, and he noticed that device-mapper-multipath creates a device and adds a binding to /var/lib/multipath/bindings. 
> 

You can also edit the udev rules (or add a new one) that will make your USB devices be ignored by
multipath daemon. This will effectivly ignore _any_ USB device.

Look for example for 40-redhat.rules and 'man udev' on how to configure your own rules.

Here is an example where the linear maps don't ever get to the multipathd daemon:

#Weed out the linear map.
KERNEL=="dm-*", PROGRAM=="/sbin/dmsetup table -j %M -m %m", RESULT=="*linear*", OPTIONS="last_rule"

# And block devices that come from usb:
ACTION=="add", KERNEL=="sd*", SUBSYSTEM=="usb", OPTIONS="last_rule"

This of course being before the, catch-it-all rule:

RUN+="socket:/org/kernel/dm/multipath_event"
