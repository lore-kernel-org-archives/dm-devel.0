From: "David Guyon Martin" <david.guyonmartin@gmail.com>
Subject: Re: Usage question: how to access partitions?
Date: Tue, 10 Oct 2006 15:36:52 +0200
Message-ID: <2c53b31c0610100636j40b0385bh62d0989f4378cc41@mail.gmail.com>
References: <2c53b31c0610090721g3b5bfc64v30d5ed081e7b348d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2c53b31c0610090721g3b5bfc64v30d5ed081e7b348d@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dan Bar Dov wrote on Sun, 8 Oct 2006 19:01:00:
> After configuring multipath access to a LU, I partitioned it with fdisk.
> fdisk complained about failing to re-read the partition table,
> blockdev --rereadpt failed as well.
>
> No new devices were created for the new partitions. I guess
> there are udev rules to do that, are there?
>
> How do I get the partition to become available, what should be the
> partitions device names in /dev?

man kpartx

"This tool, derived from util-linux' partx, reads partition tables on
specified device and create device maps over partitions segments
detected. It is called from hotplug upon device maps creation and
deletion."

More info in
www.linuxsymposium.org/2005/linuxsymposium_procv1.pdf
search kpartx, or see page 166 ( "p158" )

David G.M.

PS: this is a text-only repost, previous mail caught by anti-spam
