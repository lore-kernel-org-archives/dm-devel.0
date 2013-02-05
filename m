From: thornber@redhat.com
Subject: Re: Default low water mark threshold for a new thin pool
Date: Tue, 5 Feb 2013 12:18:47 +0000
Message-ID: <20130205121846.GB3082@raspberrypi>
References: <87ehgv16gf.fsf@in.ibm.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87ehgv16gf.fsf@in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: LVM2 development <lvm-devel@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 05, 2013 at 02:30:00PM +0530, M. Mohan Kumar wrote:
> 
> Hello,
> 
> We are adding a lvm2api for creating a thin pool. During thin pool
> creation if user does not specify anything for the low water mark
> thresold, it would result in 0 and no events will be generated when thin
> pool capacity is reaching its full size.

An event will be generated.

> I am not sure what should be the default low water threshold
> percentage. Is there any recommended value for low water threshold value
> in dm thin pools?

It's very hard to say since it depends on your use case.  In general
you want to allow dmeventd plenty of time to extend the pool before
you run out of space.  So if you're seeing a _peak_ provisioning rate of
100meg a minute, I'd set the lwm to about 100meg.  It would be nice if LVM
could help you through this process.

- Joe

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
