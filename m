From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm snapshot: revise snapshot_resume's
 exception handover
Date: Wed, 4 Nov 2009 17:20:52 -0500
Message-ID: <20091104222052.GA21348@redhat.com>
References: <1257371140-18483-1-git-send-email-snitzer@redhat.com>
	<20091104221148.GA19580@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091104221148.GA19580@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 04 2009 at  5:11pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Until now snapshot_resume only allowed the resuming snapshot to get the
> exception store from another snapshot.
> 
> Revise snapshot_resume's exception handover to allow a snapshot to
> handover its exceptions to another snapshot prior to resuming.
> 
> This is needed to accomodate the following sequence:
> new_snapshot->ctr
> old_snapshot->suspend
> old_snapshot->resume
> new_snapshot->resume
> 
> lvm2 relies on this sequence if 'lvchange --refresh' is used to start a
> snapshot merge that was deferred until both origin and snapshot were not
> in use.

FYI, the above is the last of 3 patches in the "exception handover"
series, the patch order is:

dm snapshot: initial support for exception handover
http://patchwork.kernel.org/patch/55022/

dm snapshot: exception handover improvements
http://patchwork.kernel.org/patch/55569/

dm snapshot: revise snapshot_resume's exception handover
http://patchwork.kernel.org/patch/57787/
