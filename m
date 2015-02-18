From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mirror: do not degrade the mirror on discard error
Date: Wed, 18 Feb 2015 12:10:17 -0500
Message-ID: <20150218171016.GA2032@redhat.com>
References: <alpine.LRH.2.02.1502121007010.24282@file01.intranet.prod.int.rdu2.redhat.com>
	<1423967994.19864.9.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502160742030.14038@file01.intranet.prod.int.rdu2.redhat.com>
	<1424096844.2089.2.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502171455140.13128@file01.intranet.prod.int.rdu2.redhat.com>
	<1424272616.2122.12.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502181109020.32036@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1502181109020.32036@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 18 2015 at 11:29am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 18 Feb 2015, James Bottomley wrote:
> 
> > On Tue, 2015-02-17 at 14:59 -0500, Mikulas Patocka wrote:
> > > 
> > > On Mon, 16 Feb 2015, James Bottomley wrote:
> > > 
> > > > I already said this in the first sentence of the last paragraph of my
> > > > email.  The point isn't what it does today it's what might happen
> > > > tomorrow and the principle of least surprise.  One day, someone might
> > > > propagate the error.  When that happens, they'll be surprised to find
> > > > every discard failure reported as -ENOTSUPP and it will cost someone
> > > > time and effort to investigate and fix.  If you just propagate the error
> > > > today, you save all that work in the future.
> > > > 
> > > > James
> > > 
> > > The question is if this case is so important that it justifies dm-io 
> > > change.
> > 
> > I'm not sure I follow.  Are you saying no-one would ever want to
> > propagate the error?  I think that would be short sighted.
> 
> The SATA device may report success on the trim command and may not trim 
> any data. I know this is stupid, but the standard allows the device to do 
> that and the devices are doing that. See this thread 
> http://www.spinics.net/lists/linux-scsi/msg80297.html
> 
> Consequently, if some filesystem or other application contains the logic 
> "if trim succeeded, do something", it is broken, because the SSD may 
> ignore the command and report success.
> 
> > > The SSD may ignore discards and report them as sucesfully completed, so no 
> > > one should depend on the return code anyway. The error code may be used as 
> > > a hint that it is futile to send more discards in the future, but relying 
> > > on the return code is already not correct.
> > 
> > That's not a good way of interpreting the standards.
> 
> It doesn't matter how do you interpret the standard. It does matter how do 
> SSD vendors interpret it. And they interpret it in such a way that it is 
> OK to report success and not trim any data. I know it doesn't make much 
> sense to standardize the flag "Return Zero After Trim" and then specify 
> that the device (despite having RZAT set) may ignore the trim command and 
> not return zeroes on the trimmed data. But it's the way it is.

Let's please set this thread to one side.  I already offered my thoughts
in this thread, see: 
https://www.redhat.com/archives/dm-devel/2015-February/msg00076.html

I'm not interested in wiring up the actual error return for dm-mirror's
benefit.  If/when other dm-io consumers have a need to differentiate
between error codes we'll fix dm-io as needed.
