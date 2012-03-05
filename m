From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 1/2] dm thin: rename dm_thin_id to more
	generic dm_dev_id
Date: Mon, 5 Mar 2012 10:29:42 +0000
Message-ID: <20120305102941.GC6431@ubuntu>
References: <1330732770-18621-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1330732770-18621-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

This is part of the hsm target development work.  Let's keep this in
git for now; there's no point spamming dm-devel with work in progress.
I'm happy to give you write access to my github repo if you like.
Otherwise I can merge from any git repo you wish.


On Fri, Mar 02, 2012 at 06:59:29PM -0500, Mike Snitzer wrote:
> dm_thin_id is too specific to thin devices.  Rename to allow for reuse
> by other targets.
