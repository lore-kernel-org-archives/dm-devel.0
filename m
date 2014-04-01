From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 9/9] dm crypt: sort writes
Date: Mon, 31 Mar 2014 21:01:29 -0400
Message-ID: <20140401010129.GB9214@redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-10-git-send-email-snitzer@redhat.com>
	<53368043.5000808@gmail.com> <20140331123940.GB25683@redhat.com>
	<20140401083755.55afa738d5a98b6bc07aca71@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140401083755.55afa738d5a98b6bc07aca71@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Akira Hayakawa <hayakawa@valinux.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 31 2014 at  7:37pm -0400,
Akira Hayakawa <hayakawa@valinux.co.jp> wrote:

> Hi,
> 
> This is just a comment.
> 
> I like this sorting and I would like to apply this sorting code also to dm-writeboost.
> https://github.com/akiradeveloper/dm-writeboost
> 
> Hope that improves the writeback.
> dm-writeboost writes back multiple (e.g. 4KB * 1000) data in cache device at once
> hoping that the scheduler sorts them implicitly.
> Explictly sort them possibly makes writeback more efficient.
> 
> Thanks for the code.

OK.  FYI, I cleaned the code up a little today based on Milan's dislike
for the #define within the function, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=039e943277604c3f4f6b4ee803b8793627d53d36
