From: malahal@us.ibm.com
Subject: Re: [RFC] dm-delay-flakey??
Date: Mon, 18 Jun 2007 17:16:25 -0700
Message-ID: <20070619001625.GB4442@us.ibm.com>
References: <20070615192232.GA17421@us.ibm.com>
	<20070615212911.GM18457@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070615212911.GM18457@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Great! This is what I need.

Thanks, Malahal.

Alasdair G Kergon [agk@redhat.com] wrote:
> On Fri, Jun 15, 2007 at 12:22:32PM -0700, malahal@us.ibm.com wrote:
> > I have seen dm-flakey and dm-delay. But I would like to fail I/Os with
> > a delay. Is that possible? If not, should we enhance dm-delay?
> 
> Stack one device over another.
> e.g. stack a device using a 'delay' target above another device using an
> 'error' target.
> 
> Alasdair
> -- 
> agk@redhat.com
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
