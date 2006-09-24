From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Re: dm-devel : disks being taken over by dm-raid/dm at
	boot.
Date: Sun, 24 Sep 2006 11:59:21 +0200
Message-ID: <62b0912f0609240259w5268a2dbqe5e2a63af5966ee6@mail.gmail.com>
References: <20060915160030.725E07358C@hormel.redhat.com>
	<0B4D5886-ADB2-420F-9DB6-F9540EF44FE8@ysbl.york.ac.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0B4D5886-ADB2-420F-9DB6-F9540EF44FE8@ysbl.york.ac.uk>
Content-Disposition: inline
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
Cc: kirk@ysbl.york.ac.uk
List-Id: dm-devel.ids

Tim Kirk wrote:
> I thought I'd stopped dmraid, but it was still registering the drives
> it seems. I simply commented the dmraid startup lines out of /etc/
> rc.sysinit and everything seems to be working how I want it to now.
>
> There must be a nicer way of telling dmraid to leave things alone,
> but I couldn't find one and as this is working [...snip...]

# dmraid --help | grep erase
        {-E|--erase_metadata}

If you erase the RAID metadata on the drives, dmraid will cease to
consider them RAID devices.
