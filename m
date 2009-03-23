From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: configure MD3000 episode 2
Date: Mon, 23 Mar 2009 10:31:27 -0400
Message-ID: <20090323143127.GA12731@mars.virtualiron.com>
References: <d1392840903201754g119199d1u5b3863ba3a96abad@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d1392840903201754g119199d1u5b3863ba3a96abad@mail.gmail.com>
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

On Fri, Mar 20, 2009 at 08:54:27PM -0400, Thomas Witzel wrote:
> I have a Dell NX1950 with a MD3000 running ubuntu server 8.04 . With
> the help of this list I managed to configure the RAID etc. However
> there is one remaining problem. udev doesn't seem to recognize this
> setup. After every reboot I have to manually create the /dev/dm-*
> devices with mknod and run kpartx to make the partitions show up. Can
> someone please hint to me where I get the appropriate udev scripts ?

You can drop this in your udev/rules.d directory:

> cat /etc/udev/rules.d/95-mpdc.rules 
RUN+="socket:/org/kernel/dm/multipath_event"


Obviously you need to have your multipathd to start _before_ your
iSCSI daemon.

> Ubuntu does have dmapper and multipath related scripts in the udev
> directory, but they don't seem to be working for me.
> 
> Thank you so much,
> Thomas Witzel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
