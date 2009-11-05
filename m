From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm snapshot: revise snapshot_resume's
	exception handover
Date: Thu, 5 Nov 2009 01:44:17 +0000
Message-ID: <20091105014417.GO13375@agk-dp.fab.redhat.com>
References: <1257371140-18483-1-git-send-email-snitzer@redhat.com>
	<20091104221148.GA19580@redhat.com>
	<20091104222052.GA21348@redhat.com>
	<20091104222834.GB21348@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091104222834.GB21348@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 04, 2009 at 05:28:34PM -0500, Mike Snitzer wrote:
> Ok, actually this 'suspended' flag patch is the first; so its 4 patches:
> 
> dm snapshot: add suspended flag to dm_snapshot
> http://patchwork.kernel.org/patch/55021/
>  
> > dm snapshot: initial support for exception handover
> > http://patchwork.kernel.org/patch/55022/
> > 
> > dm snapshot: exception handover improvements
> > http://patchwork.kernel.org/patch/55569/
> > 
> > dm snapshot: revise snapshot_resume's exception handover
> > http://patchwork.kernel.org/patch/57787/

As quite a few changes get superceded by later changes, with added lines
later removed, I've merged the last three of those together into a single
patch for now.

Alasdair
