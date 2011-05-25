From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: SUSE multipath-tools patch resync
Date: Wed, 25 May 2011 13:14:39 +0200
Message-ID: <1306322079.2290.25.camel@lapoo.opensvc.com>
References: <4DD3DFC0.9050300@suse.de>
	<1306309907.2290.14.camel@lapoo.opensvc.com> <4DDCC72A.8000601@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DDCC72A.8000601@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mer., 2011-05-25 at 11:08 +0200, Hannes Reinecke wrote:
> On 05/25/2011 09:51 AM, Christophe Varoqui wrote:
> > On mer., 2011-05-18 at 17:03 +0200, Hannes Reinecke wrote:
> >> git.kernel.org:/pub/scm/linux/kernel/git/hare/multipath-tools.git
> >
> > I started the merge. I'll post comments along the reading. It seems
> > there won't be much : this patchset is clearly a must-have.
> >
> :-)
> 
> With some things so bloody obvious that I keep wondering if I'm the
> only one seeing these ...
> 
The merge is done. No change wrt your branch. Still not pushed to korg.
I struggle with a hwtable corruption with no /etc/multipath.conf ... can
you reproduce that ?

For example, iterating through the hwtable and printing ->product from
config.c:find_hwe() gives:

...
(StorEdge 3510|T4)
FC2502
RAIGE VOLUME
CSM200_R
LCSM100_[IEFS]
INF-01-00
FLEXLINE 380

hd
dcssblk

The final spurious entries are clearly from the blacklist mem region. I
verified the hwtable is not corrupted after initialization. Corruption
thus occurs between hwtable init and path discovery.

I'll continue tracking it, but if you see something obvious ...
