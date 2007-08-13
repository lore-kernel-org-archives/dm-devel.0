From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: multipath-tool udev rules require missing dmsetup
	features
Date: Mon, 13 Aug 2007 13:21:00 +0200
Message-ID: <20070813112100.GA20627@bogon.ms20.nix>
References: <469EB881.6070207@csupomona.edu>
	<20070719061622.GB21899@pentland.suse.de>
	<20070720164635.GB459@agk.fab.redhat.com>
	<20070812162716.GA9108@bogon.ms20.nix>
	<20070812182144.GA16910@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070812182144.GA16910@wavehammer.waldi.eu.org>
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

On Sun, Aug 12, 2007 at 08:21:44PM +0200, Bastian Blank wrote:
> On Sun, Aug 12, 2007 at 06:27:17PM +0200, Guido Guenther wrote:
> > +		[state]       = "DM_STATE=\"%s%s\"\n",
> > +		[tablestate]  = "DM_TABLE_STATE=\"%s%s%s\"\n",
> 
> Why use freetext fields if you can set it in a splitted way?
> 
> DM_STATE for example shows both suspended and read-only state without
> making in properly parsable.
This is just does what the patch I based this on does, I'd rather split
this into separate fields too.
Cheers,
 -- Guido
