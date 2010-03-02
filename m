From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/14] mikulas' shared snapshot patches
Date: Tue, 2 Mar 2010 09:56:45 -0500
Message-ID: <20100302145645.GA13568@redhat.com>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 01 2010 at  7:23pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Mikulas,
> 
> This is just the full submit of your shared snapshot patches from:
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r15/
> 
> I think the next phase of review should possibly be driven through the
> dm-devel mailing list.  I'd at least like the option of exchanging
> mail on aspects of some of these patches.
> 
> The first patch has one small cleanup in do_origin_write(): I
> eliminated the 'midcycle' goto.
> 
> But the primary difference with this submission (when compared to your
> r15 patches) is I editted the patches for whitespace and typos.

Mikulas,

I've made these patches available for download here:
http://people.redhat.com/msnitzer/patches/multisnap/kernel/2.6.33/

I'd like to hand these DM patches, and the lvm2 patches, over to you so
we don't get out of sync.

The lvm2 patches were rebased and fixed to work with lvm2 2.02.62:
http://people.redhat.com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.62/

I've not heard from you on either line of work that I did here.  I
welcome your feedback.

Mike
