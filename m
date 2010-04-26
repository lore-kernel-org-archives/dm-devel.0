From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Development problem: uninterruptable processes
Date: Mon, 26 Apr 2010 13:27:10 +0200
Message-ID: <1272281230.2031.58.camel@o>
References: <000301cae3c7$3ef52250$bcdf66f0$@tu-berlin.de>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000301cae3c7$3ef52250$bcdf66f0$@tu-berlin.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi Anselm,

you're not explaining the design and functions of your driver here, so
it's hard to tell. You're telling though, starvation happens in the
write path so you want to look if you're in an OOM situation, presumably
the locking is correct as you claim. Another possibility may be that
you're scheduling a thread handling your write not properly.

You better provide the source code of your driver to allow for better
advice.

Regards,
Heinz

On Sat, 2010-04-24 at 18:00 +0200, Anselm Busse wrote:
> Hello everyone,
> 
> I am not sure whether I am right in this mailing list or not, but I hope
> so...
> 
> I am relative new to kernel development and especially to the device mapper.
> Currently I am developing a driver using the device mapper API. It works
> perfectly with one exception. After some time of heavy load every process
> that tries to access the mapped block device gets stuck in the
> uninterruptable state.
> 
> I already checked every entry and callback routine in my driver, but it gets
> not stuck there. I also checked every lock I am using in my driver and every
> one of them gets released properly. I am pretty stuck at the moment, because
> I don't know where to look else for the problem and was hoping that some one
> of you might have experienced similar problems or an idea where to look for
> it. 
> I don't know if it is important but I've noticed (using the kernel debug
> option for detecting hung tasks) that every process seems to hang in a write
> call and I've tried kernel versions 2.6.31 and 2.6.33.
> 
> I would appreciate every bit of help because I am completely out of ideas!
> 
> Regards, Anselm
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
