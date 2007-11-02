From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: how to flush device with no paths but
	no_path_retry=queue
Date: Fri, 2 Nov 2007 13:01:33 -0700
Message-ID: <20071102200133.GB3712@linux.vnet.ibm.com>
References: <1194019311.6006.23.camel@eddie-laptop.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1194019311.6006.23.camel@eddie-laptop.sc.steeleye.com>
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

Eddie Williams <Eddie.Williams@steeleye.com> wrote:
> 
> If you have a device configured with no_path_retry=queue but you can not
> repair the connections is there any way to flush the IO's?  
> 
> I can not find a way to force the device offline so that it will
> flush/fail all of the pending IO's so I can shutdown or clean up the
> mess.
> 
> Is there a way?

There maybe a cleaner way, but you should be able to do:
	dmsetup message ${device} 0 fail_if_no_path

It worked on my test config, but it was a pretty simple config.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
