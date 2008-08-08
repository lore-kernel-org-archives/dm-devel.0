From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: error calling out /sbin/scsi_id
Date: Fri, 8 Aug 2008 10:50:21 -0400
Message-ID: <20080808145021.GB24121@mars.virtualiron.com>
References: <6970f8553dbb14b2b901be06ee4918d7.squirrel@montblanc.homeip.net>
	<ff6be1a9b40e177a2cddb0fb727c8c12.squirrel@montblanc.homeip.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ff6be1a9b40e177a2cddb0fb727c8c12.squirrel@montblanc.homeip.net>
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

On Fri, Aug 08, 2008 at 10:53:17AM +0200, mylists@montblanc.homeip.net wrote:
> About my previous question, could I just write something like :
> 
> getuid_callout "/sbin/scsi_id -g -u -s /block/%n  > /dev/null"
> 
> in multipath.conf ?

No :-)

If you did that the data the scsi_id produced for you disk (like the
WWN) would not be sent to the standard input and multipat wouldn't
be able to read it.

> 
> Cheers,
> Josep SERRANO.
> 
> > Hello all,
> >
> > Why do I get the following error message:
> > error calling out /sbin/scsi_id -g -u -s /block/sda
> >
> > after I run multipath for a second time.

What happens if you run it that program just by itself? Any errors?
