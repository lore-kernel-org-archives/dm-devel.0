From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath 4k partition block issues.
Date: Wed, 4 Sep 2013 17:27:06 -0400
Message-ID: <20130904212705.GA28020@redhat.com>
References: <52279FC1.4000707@dsotm.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52279FC1.4000707@dsotm.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ross Anderson <rosander@dsotm.net>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 04 2013 at  5:01pm -0400,
Ross Anderson <rosander@dsotm.net> wrote:

> Greetings,
> 
> 
> The current git version of multipath-tools doesn't properly handle
> 4k block sizes and partions creation. There very little verbose
> output but I will post what I can find. I would appreciate any help
> getting this working.
> 
> The raw devices detect the 4k partition.

Ben Marzinski had a patch to print the table _before_ it was sent to the
kernel so that we had something to go on beyond "253:6: multipath: error
getting device"...

As is the output is useless.  We have no idea _why_ it failed to get the
device (or which device it failed to get).  We can do better here in
both kernel and userspace error logging.  But chances are multipathd is
just looking to use multipath on devices that aren't meant for
multipathing (and they should be blacklisted in the multipath.conf).

> A manual run of kpartx -a creates the dm points.

Which distro is this?

So samplelib and sfx4k are 4K devices that have partitions.

[multipathd] sfx4k: load table [0 165076992 multipath 0 0 1 1 service-time 0 2 1 8:192 4 8:144 4]
[multipathd] samplelib: load table [0 461373440 multipath 0 0 1 1 service-time 0 2 1 65:16 4 8:240 4]

I assume these devices map to sdp and sdr, and likely other devices not
provided in your log output.  multipathd -ll would be useful.

Are you certain none-4K devices with partitions are created properly?
(I think multpathd leans on kpartx to be invoked by udev after the
multipathd device is established but I could be misrembering).. Could be
the udev hook isn't working in general?

Mike
