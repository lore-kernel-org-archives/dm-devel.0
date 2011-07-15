From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: add mapping table option to allowing
	discard requests
Date: Thu, 14 Jul 2011 21:13:11 -0400
Message-ID: <20110715011311.GA27697@redhat.com>
References: <1310644590-14438-1-git-send-email-mbroz@redhat.com>
	<4E1F9023.5020801@deserettechnology.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E1F9023.5020801@deserettechnology.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@deserettechnology.com, device-mapper development <dm-devel@redhat.com>
Cc: list@eworm.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 14 2011 at  8:56pm -0400,
Jeff Cook <jeff@deserettechnology.com> wrote:

> On 07/14/2011 05:56 AM, Milan Broz wrote:
> > Add optional parameter field to dmcrypt table and support
> > "allow_discards" option.
> > 
> > Discard requests bypass crypt queue processing, bio
> > request is simple remapped to underlying device.
> > 
> > Note that discard will be never enabled by default because
> > of security consequences, it is up to administrator
> > to enable it for encrypted devices.
> > 
> > (Note that userspace cryptsetup will not understand new
> > optional parameters yet, support for this will come later.)
> > 
> > Signed-off-by: Milan Broz <mbroz@redhat.com>
> > [snip]
> 
> Thanks very much for this patch Milan. I will try compiling it shortly
> and see where things go -- are you expecting this to be submitted for
> inclusion in mainline soon?

It is already staged for linux-next (and upstream inclusion when the 3.1
merge window opens):
ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-crypt-optionally-support-discard-requests.patch

NOTE: this version of the patch depends on additional changes that were
also staged, e.g.:
ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-table-share-target-argument-parsing-functions.patch
