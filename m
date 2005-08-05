From: Andrew Morton <akpm@osdl.org>
Subject: Re: File corruption on LVM2 on top of software RAID1
Date: Fri, 5 Aug 2005 01:02:36 -0700
Message-ID: <20050805010236.12d811ff.akpm@osdl.org>
References: <45138.213.188.237.106.1123086677.squirrel@localhost>
	<20050804195853.0866ade9.akpm@osdl.org>
	<34082.213.188.237.106.1123228569.squirrel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <34082.213.188.237.106.1123228569.squirrel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Simon Matter <simon.matter@invoca.ch>
Cc: linux-raid@vger.kernel.org, kernel-maint@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

"Simon Matter" <simon.matter@invoca.ch> wrote:
>
> While looking at some data corruption vulnerability reports on
>  Securityfocus I wonder why this issue does not get any attention from
>  distributors. I have an open bugzilla report with RedHat, have an open
>  customer service request with RedHat, have mailed peoples directly. No
>  real feedback.
>  I'm now in the process of restoring intergrity of my data with the help of
>  backups and mirrored data. Maybe I just care too much about other peoples
>  data, but I know that this bug will corrupt files on hundreds or thousands
>  of servers today and most people simply don't know it. Did I miss
>  something?

I guess the bug hit really rarely and maybe the reports were lost in the
permanent background noise of dodgy hardware.

We only found and fixed it last week, due to much sleuthing by Matthew
Stapleton.  I assume vendor updates are in the pipeline.
