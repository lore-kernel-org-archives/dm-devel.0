From: "S. J. van Harmelen" <svh@dds.nl>
Subject: RE: Reloading multipathd?
Date: Wed, 07 Nov 2007 16:18:47 +0100
Message-ID: <1194448727.6012.18.camel@sanderbal>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8B8C@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8B8C@exch-2003.incipient.waltham>
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

On Wed, 2007-11-07 at 08:33 -0500, Paul Cote wrote:
> Did you do a rescan so that the O/S "sees" the new LUN? 

Nope... Could you tell me how to do that? And does a rescan have any
effect on already active LUN's?


> If so; simply do
> a multipath -v2 to build the new path list.
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of S. J. van Harmelen
> Sent: Wednesday, November 07, 2007 8:08 AM
> To: device-mapper development
> Subject: [dm-devel] Reloading multipathd?
> 
> Hi...
> 
> I just added another LUN on our storage (MD3000). But now that I run
> multipath -ll I don't see the new LUN.
> 
> Do I need to reload something (like /etc/init.d/multipath-tools reload
> maybe)? And if so, can I do this without it interrupting the
> connectivity of the other (production) LUN's?
> 
> Sander
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
