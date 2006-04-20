From: Steve Feehan <sfeehan@sbb.uvm.edu>
Subject: Re: multipath and StorageWorks HSG80
Date: Thu, 20 Apr 2006 16:47:39 -0400
Message-ID: <20060420204739.GB32417@ingress.sbb.uvm.edu>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>
	<4447E8BF.1060205@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4447E8BF.1060205@bzed.de>
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

On Thu, Apr 20, 2006 at 10:02:07PM +0200, Bernd Zeimetz wrote:
> Steve Feehan wrote:
> > Hello. I'm trying to figure out multipath on a StorageWorks HSG80
> > contoller. I'm using Ubuntu "Dapper" with the following software
> >   
> there was a thread about the HSG80s few days ago.
> http://www.redhat.com/archives/dm-devel/2006-April/msg00025.html
> probably that answers all your questions.

Yes, I saw that. The particular problem that I saw there
was the misreporting of unit size. The Ubuntu init script
takes care of this and all of my units report the same 
size.

> Actually I'd really like to have them supported well, chances are good
> that we'll get some of them soon :\
> 
> 
> Best regards,
> 
> 
> Bernd
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Steve Feehan
