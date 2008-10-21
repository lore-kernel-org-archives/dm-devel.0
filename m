From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: a question about multipathd and udev
Date: Tue, 21 Oct 2008 09:40:01 -0400
Message-ID: <20081021134001.GA13698@mars.virtualiron.com>
References: <48FD900D.2010709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <48FD900D.2010709@redhat.com>
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

On Tue, Oct 21, 2008 at 04:17:17PM +0800, dwu wrote:
> If a block device is added, the udev will run the command multipath to add 
> the path to the mp if possible.

That depends on your distro. Some of the udev rules do not call the multipath
program but instead pass on the uevent to a netlink socket:

(look for 96-multipath-late.rules):

RUN+="socket:/org/kernel/dm/multipath_event"


and let the multipathd handle the uevent.

> Why multipathd also process a path addition event:
> (!strncmp(uev->action, "add", 3)) {
>        r = uev_add_path(devname, vecs);

Take a look at the logic of the uev_add_path. It extracts the block device name
and figures out to what multipath map this device belongs too, runs the appropiate
path checker, and lastly updates (or creates) the device mapper map with the right major:minor, 
weights, etc.


>        goto out;
>    }
>
> Thanks.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
