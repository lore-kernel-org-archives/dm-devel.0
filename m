From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-mirror: do not degrade the mirror on
 discard error
Date: Wed, 18 Feb 2015 11:29:18 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502181109020.32036@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1502121007010.24282@file01.intranet.prod.int.rdu2.redhat.com>
	<1423967994.19864.9.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502160742030.14038@file01.intranet.prod.int.rdu2.redhat.com>
	<1424096844.2089.2.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502171455140.13128@file01.intranet.prod.int.rdu2.redhat.com>
	<1424272616.2122.12.camel@HansenPartnership.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1424272616.2122.12.camel@HansenPartnership.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Wed, 18 Feb 2015, James Bottomley wrote:

> On Tue, 2015-02-17 at 14:59 -0500, Mikulas Patocka wrote:
> > 
> > On Mon, 16 Feb 2015, James Bottomley wrote:
> > 
> > > I already said this in the first sentence of the last paragraph of my
> > > email.  The point isn't what it does today it's what might happen
> > > tomorrow and the principle of least surprise.  One day, someone might
> > > propagate the error.  When that happens, they'll be surprised to find
> > > every discard failure reported as -ENOTSUPP and it will cost someone
> > > time and effort to investigate and fix.  If you just propagate the error
> > > today, you save all that work in the future.
> > > 
> > > James
> > 
> > The question is if this case is so important that it justifies dm-io 
> > change.
> 
> I'm not sure I follow.  Are you saying no-one would ever want to
> propagate the error?  I think that would be short sighted.

The SATA device may report success on the trim command and may not trim 
any data. I know this is stupid, but the standard allows the device to do 
that and the devices are doing that. See this thread 
http://www.spinics.net/lists/linux-scsi/msg80297.html

Consequently, if some filesystem or other application contains the logic 
"if trim succeeded, do something", it is broken, because the SSD may 
ignore the command and report success.

> > The SSD may ignore discards and report them as sucesfully completed, so no 
> > one should depend on the return code anyway. The error code may be used as 
> > a hint that it is futile to send more discards in the future, but relying 
> > on the return code is already not correct.
> 
> That's not a good way of interpreting the standards.

It doesn't matter how do you interpret the standard. It does matter how do 
SSD vendors interpret it. And they interpret it in such a way that it is 
OK to report success and not trim any data. I know it doesn't make much 
sense to standardize the flag "Return Zero After Trim" and then specify 
that the device (despite having RZAT set) may ignore the trim command and 
not return zeroes on the trimmed data. But it's the way it is.

Mikulas


> For instance unmap has two types of error: permanent and transient.  
> Permanent means the device would never be able to process the unmap and 
> you should move on. Transient means the device may be able to process 
> the unmap and you might like to repeat it.  Mostly the retries will be 
> handled by SCSI but not always.
> 
> That the discard issuer doesn't care is also not a given.  In the low
> end SSD case you cite above, they probably don't.  However, if it's a
> cloud environment charging per megabyte per day for provisioned
> capacity, they probably do care.
> 
> The point here is that since you have the ability to do the right thing
> (you have the error code the lower layer sent), just do it.  It will
> save a lot of pain later on.  Doing the wrong thing and trying to
> justify it post facto based on how you see the future evolving is
> inevitably the wrong course of action because we're not very good at
> predictions.
> 
> James
