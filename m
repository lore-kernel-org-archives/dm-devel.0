From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: how to flush device with no paths but
	no_path_retry=queue
Date: Thu, 15 Nov 2007 14:38:12 -0500
Message-ID: <1195155492.8771.5.camel@eddie-laptop.sc.steeleye.com>
References: <1194019311.6006.23.camel@eddie-laptop.sc.steeleye.com>
	<20071102200133.GB3712@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071102200133.GB3712@linux.vnet.ibm.com>
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


This seems to work fine when you issue dmsetup while there are IO's
pending.  However I recently tried this on a RHEL 4 update 5 system and
have run into at least one scenario where it does not work well.  If I
set the device to fail using dmsetup and then IO's are issued (that
fail) it seems that multipathd will try to "fix" the configuration and
place it back to queue.  I can then reissue the dmsetup to set it to
fail and the IO's fail.

I am not sure if this is an issue with the older multipath in RHEL 4.  I
don't believe I saw this issue with my earlier testing but perhaps I did
not try this scenario.

Eddie

On Fri, 2007-11-02 at 13:01 -0700, Mike Anderson wrote:
> Eddie Williams <Eddie.Williams@steeleye.com> wrote:
> > 
> > If you have a device configured with no_path_retry=queue but you can not
> > repair the connections is there any way to flush the IO's?  
> > 
> > I can not find a way to force the device offline so that it will
> > flush/fail all of the pending IO's so I can shutdown or clean up the
> > mess.
> > 
> > Is there a way?
> 
> There maybe a cleaner way, but you should be able to do:
> 	dmsetup message ${device} 0 fail_if_no_path
> 
> It worked on my test config, but it was a pretty simple config.
> 
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
