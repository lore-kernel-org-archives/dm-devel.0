From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Pathvec messages
Date: Tue, 29 Jul 2008 14:07:35 -0500
Message-ID: <20080729190735.GF30728@ether.msp.redhat.com>
References: <488F4A9E.6020906@amnh.org>
	<20080729170455.GE30728@ether.msp.redhat.com>
	<488F54B7.6030600@amnh.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <488F54B7.6030600@amnh.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sajesh Singh <ssingh@amnh.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jul 29, 2008 at 01:34:47PM -0400, Sajesh Singh wrote:
>  ________________________________________________________
>  Sajesh Singh
>  Senior Systems Administrator
>  American Museum of Natural History
>  Central Park West at 79th Street
>  New York, NY 10024
> 
>  (O) (212) 313-7263
>  (C) (917) 577-9195
>  (E) [1]ssingh@amnh.org
> 
>    Benjamin Marzinski wrote:
> 
>  On Tue, Jul 29, 2008 at 12:51:42PM -0400, Sajesh Singh wrote:
> 
> 
>  Whenever I run the multipath -v3 command on a EL 5 server I see the
>  following line in the output for each device.
> 
>  sdc: not found in pathvec
> 
> 
>  This simply means that the device is not already stored in multipath's
>  in memory list of discovered paths. It's completely normal to see this
>  for your all your devices when running the multipath command.
> 
>  -Ben
> 
> 
> 
>    That being said, when does the device make it into the memory list of
>    discovered paths ?

Immediately after multipath realizes that it's not there.  In
multipathd, which uses the same code, you will see this when multipath
first spots a new device.  After that, the device will be list of
discovered paths. 

-Ben
 
>  I have seen questions on this before, but no answer as to what this means.
>  Is the message merely information or does the multipath configuration need
>  to be changed?
> 
>  Regards,
> 
>  Sajesh
> 
>  --
>  dm-devel mailing list
>  [2]dm-devel@redhat.com
>  [3]https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 
> References
> 
>    Visible links
>    1. mailto:ssingh@amnh.org
>    2. mailto:dm-devel@redhat.com
>    3. https://www.redhat.com/mailman/listinfo/dm-devel
