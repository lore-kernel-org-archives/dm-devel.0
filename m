From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Pathvec messages
Date: Tue, 29 Jul 2008 12:04:55 -0500
Message-ID: <20080729170455.GE30728@ether.msp.redhat.com>
References: <488F4A9E.6020906@amnh.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <488F4A9E.6020906@amnh.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: ssingh@amnh.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 29, 2008 at 12:51:42PM -0400, Sajesh Singh wrote:
> Whenever I run the multipath -v3 command on a EL 5 server I see the 
> following line in the output for each device.
>
> sdc: not found in pathvec

This simply means that the device is not already stored in multipath's
in memory list of discovered paths. It's completely normal to see this
for your all your devices when running the multipath command.

-Ben

> I have seen questions on this before, but no answer as to what this means. 
> Is the message merely information or does the multipath configuration need 
> to be changed?
>
> Regards,
>
> Sajesh
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
